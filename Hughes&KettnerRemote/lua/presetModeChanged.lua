--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
presetModeChanged = function(mod, value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	local newIsLibrary
	if value == 0 then
		newIsLibrary = true
	else
		newIsLibrary = false
	end
	changePresetMode(newIsLibrary,true)
end

changePresetMode = function(value,sendMidi)
	if panel:getBootstrapState() or panel:getRestoreState() then
		return
	end
	--console("Change preset mode...")
	if value ~= isLibrary then
		--console("Change preset mode !")
		local component = panel:getComponent("presetCopy")
		local component2 = panel:getComponent("presetMove")
		isLibrary = value
		if isLibrary then
			presets = libraryPresets
			-- Switch from amp to library
			currentAmpPresetNumber = currentPresetNumber
			currentPresetNumber = currentLibraryPresetNumber
			-- Enable library buttons
			component:setEnabled(true)
			component2:setEnabled(true)
		else
			presets = ampPresets
			-- Switch from library to amp
			currentLibraryPresetNumber = currentPresetNumber
			currentPresetNumber = currentAmpPresetNumber
			-- Disable library buttons
			component:setEnabled(false)
			component2:setEnabled(false)
		end
		editBuffer = copyPreset(presets[currentPresetNumber])
		originalBuffer = copyPreset(presets[currentPresetNumber])
		if isLibrary then
			loadPreset(editBuffer,true)
			if sendMidi then
				--console("Send edit buffer...")
				sendEditBufferDump()
			end
		else
			if sendMidi then
				--sendEditBufferRequest()
				sendPresetChangeRequest(currentPresetNumber)
			end
		end
		initPresetCombo()
	end
end