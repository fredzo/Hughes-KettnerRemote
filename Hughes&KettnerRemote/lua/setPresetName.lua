function changePresetNumber(presetNumber)
	if panel:getBootstrapState() or panel:getRestoreState() then
		return
	end
	setPresetNumber(presetNumber)
	if editBuffer ~= nil then
		if isLibrary then
			sendEditBufferDump()
		else
			sendPresetChangeRequest(presetNumber)
		end
		if not connected then
			loadPreset(editBuffer,false)
		end
	end
end

function setPresetNumber(presetNumber,force)
	if (panel:getBootstrapState() or panel:getRestoreState()) and not force then
		return
	end
	presetNumber = sanitizePresetNumber(presetNumber)
	setModulatorValue("presetStep",presetNumber,false)
	--console("Preset number = "..presetNumber)
	currentPresetNumber = presetNumber
	editBuffer = copyPreset(presets[presetNumber])
	originalBuffer = copyPreset(presets[presetNumber])
	hideCompare()
	if libraryDirty then
		-- Remeber that we are really dirty (even after restore original)
		lastPresetDirty = true
	end

	local component = panel:getComponent("presetName")
	if component ~= nil then
		local presetName
		if editBuffer ~= nil then
			presetName = editBuffer["name"]
		end
		if presetName == nil then
		   presetName = "Preset "..presetNumber
		   console("No name found for preset "..presetNumber)
		end
		if presetName ~= nil then
			component:setComponentText(presetName)
		end
	else
	   console("Modulator not found: presetName")
	end
	component = panel:getComponent("presetNumber")
	if component ~= nil then
		component:setComponentText(""..presetNumber)
	else
	   console("Modulator not found: presetNumber")
	end
	-- Set value for bank
	setBankValue(presetNumber)
	-- Update combo selection
	setComboSelection()
end

function setBankValue(presetNumber)
	local component = panel:getComponent("bankNumber")
	if component ~= nil then
		local bank = math.floor((presetNumber-1)/4)+1
		local patchNumber = (presetNumber-1)%4
		local patchText
		if(patchNumber <= 0) then
			patchText = "A"
		elseif(patchNumber <= 1) then
			patchText = "B"
		elseif(patchNumber <= 2) then
			patchText = "C"
		else
			patchText = "D"
		end
		component:setComponentText(""..bank.." - "..patchText)
	else
	   console("Modulator not found: bankNumber")
	end
end
