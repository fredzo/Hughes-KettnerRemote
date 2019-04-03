--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
storePresetAs = function(mod, value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end

	local comboItems = StringArray()
	local comboPresets
	for i,v in ipairs(ampPresets) do
		comboItems:add (""..v["number"].." - "..v["name"])
	end

	modalWindow = AlertWindow("Location ?", "Choose a location to store the preset", AlertWindow.QuestionIcon)
	modalWindow:addButton("OK", 1, KeyPress(KeyPress.returnKey), KeyPress())
	modalWindow:addButton("Cancel", 0, KeyPress(KeyPress.escapeKey), KeyPress())
	modalWindow:addComboBox ("myCombo", comboItems, "Preset #")
	modalWindow:setModalHandler(windowCallback)
		
	--  Never let Lua delete this window (3rd parameter), enter modal state
	modalWindow:runModalLoop()end

function windowCallback(result, window)
	if panel:getBootstrapState() or panel:getRestoreState() then
		return
	end
	window:setVisible (false)
	--console("\n\nwindowCallback result="..result)
	if result == 1 then
		comboBox = window:getComboBoxComponent("myCombo")
		if comboBox ~= nil then
			if showOriginal then
				-- restore original buffer
				editBuffer = copyPreset(originalBuffer)
			end
			local presetNumber = sanitizePresetNumber(comboBox:getSelectedId())
			editBuffer["number"]=presetNumber
			local updateCombo = true
			if isLibrary then
				-- Store to amp case
				updateCombo = false
				-- Update amp preset
				currentAmpPresetNumber = presetNumber
				ampPresets[presetNumber] = copyPreset(editBuffer)
				sendPresetBufferDump(editBuffer,false)
				if connected then
					-- Switch to amp
					setPresetMode(1,false)
					changePresetMode(false,false)
				else
					setPresetNumber(presetNumber)
				end
			else
				-- Amp case => simply send store command
				-- Update selected preset
				presets[presetNumber] = copyPreset(editBuffer)
				-- Update preset number
				setPresetNumber(presetNumber)
				-- Store preset
				sendPresetBufferDump(editBuffer,false)
			end
			if updateCombo then
				-- And update combo content
				local combo = getPresetCombo()
				if combo ~= nil then
					combo:changeItemText(presetNumber,""..presetNumber.." - "..editBuffer["name"])
				end
			end
		end
	end

end