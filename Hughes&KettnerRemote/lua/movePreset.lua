--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
movePreset = function(mod, value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	copyLibraryPreset(true)
end

copyLibraryPreset = function(move)
	if panel:getBootstrapState() then
		return
	end
	-- Not supported in amp mode
	if not isLibrary then
		return
	end

	local comboItems = StringArray()
	local comboPresets
	local size = 1
	while size <= 128 do
		local presetName
		if libraryPresets[size] == nil then
			presetName = "Preset "..size
		else
			presetName = libraryPresets[size]["name"]
		end
		comboItems:add (""..size.." - "..presetName)
		size = size+1
	end

	local message
	if move then
		message = "Choose a location to move the preset to (exchange)"
	else
		message = "Choose a location to copy the preset to"
	end
	modalWindow = AlertWindow("Location ?", message, AlertWindow.QuestionIcon)
	modalWindow:addButton("OK", 1, KeyPress(KeyPress.returnKey), KeyPress())
	modalWindow:addButton("Cancel", 0, KeyPress(KeyPress.escapeKey), KeyPress())
	modalWindow:addComboBox ("myCombo", comboItems, "Preset #")
	if move then
		modalWindow:setModalHandler(moveWindowCallback)
	else
		modalWindow:setModalHandler(copyWindowCallback)
	end
		
	--  Never let Lua delete this window (3rd parameter), enter modal state
	modalWindow:runModalLoop()end

function copyWindowCallback(result, window)
	libWindowCallback(result, window, false)
end

function moveWindowCallback(result, window)
	libWindowCallback(result, window, true)
end

function libWindowCallback(result, window, move)
	if panel:getBootstrapState() then
		return
	end
	window:setVisible(false)
	--console("\n\nwindowCallback result="..result)
	if result == 1 then
		comboBox = window:getComboBoxComponent("myCombo")
		if comboBox ~= nil then
			local originalPresetNumber = currentPresetNumber
			local newPresetNumber = comboBox:getSelectedId()
			if originalPresetNumber ~= newPresetNumber then
				if showOriginal then
					-- restore original buffer
					editBuffer = copyPreset(originalBuffer)
				end
				if move then
					-- Exchange presets
					local presetFromNewLocation = presets[newPresetNumber]
					-- Update new location
					editBuffer["number"]=newPresetNumber
					presets[newPresetNumber] = copyPreset(editBuffer)
					-- Update original location
					presetFromNewLocation["number"]=originalPresetNumber
					presets[originalPresetNumber] = presetFromNewLocation
				else
					-- Copy preset
					editBuffer["number"]=newPresetNumber
					presets[newPresetNumber] = copyPreset(editBuffer)
				end
				setPresetNumber(newPresetNumber)
				-- Library is now dirty
				libraryDirty = true
				setLibraryFileName()
				-- And update combo content
				local combo = getPresetCombo()
				if combo ~= nil then
					combo:changeItemText(newPresetNumber,""..newPresetNumber.." - "..presets[newPresetNumber]["name"])
					combo:changeItemText(originalPresetNumber,""..originalPresetNumber.." - "..presets[originalPresetNumber]["name"])
				end
			end
		end
	end

end