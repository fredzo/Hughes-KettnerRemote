--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
storePreset = function(mod, value)
	if panel:getBootstrapState() or notMouseOver(mod)  then
		return
	end
	if isLibrary then
		-- Update amp preset
		currentAmpPreset = currentPresetNumber
		local presetToStore
		if showOriginal then
			presetToStore = originalBuffer
		else
			presetToStore = editBuffer
		end
		ampPresets[currentPresetNumber] = copyPreset(presetToStore)
		sendPresetBufferDump(presetToStore,false)
		if connected then
			-- Switch to amp
			setPresetMode(1,false)
			changePresetMode(false,false)
		end
	else
		sendStoreRequest(currentPresetNumber)
	end
	originalBuffer = copyPreset(editBuffer)
	hideCompare()
end