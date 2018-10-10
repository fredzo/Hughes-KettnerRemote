--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
restorePresets = function(mod, value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	local fileToRead = utils.openFileWindow("Restore Amp presets from disk", File(""), getAmpTypeExtension(), true)

	-- Check if the file exists
	if fileToRead:existsAsFile() then
		local path = fileToRead:getFullPathName()
		local answer = utils.questionWindow("Overwrite Amp Presets ?", "Do you want to send all the presets from "..path.." to the Amp ?\nThis will overwrite all the current Amp presets.","OK","Cancel")
		if not answer then
			return
		end
		-- Load file
		local data = fileToRead:loadFileAsString()
		newAmpPresets = loadFromText(data)
		sendPresetsBufferDump(newAmpPresets,sendBackupToAmpFinisehd)
	else
		console("Could not open file "..fileToRead:getFullPathName())
	end
end

function sendBackupToAmpFinisehd(complete)
	if complete then
		ampPresets = newAmpPresets
		if connected then
			-- Force combo and preset name update even if we are already in amp mode
			isLibrary = true
			setPresetMode(1,false)
			changePresetMode(false,true)
		end
	end
end