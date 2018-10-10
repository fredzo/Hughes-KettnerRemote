--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
sendPresetsToAmp = function(mod, value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	local answer = utils.questionWindow("Overwrite Amp Presets ?", "Do you want to send all the presets of the current library to the Amp ?\nThis will overwrite all the current Amp presets.","OK","Cancel")
	if answer then
		-- Send to amp
		sendPresetsBufferDump(libraryPresets,sendPresetsToAmpFinisehd)
	end
end

function sendPresetsToAmpFinisehd(complete)
	if complete then
		-- Update amp presets
		ampPresets = copyPresets(libraryPresets)
		if connected then
			-- Force combo and preset name update even if we are already in amp mode
			isLibrary = true
			setPresetMode(1,false)
			changePresetMode(false,true)
		end
		--console("Upload complete !")
	else
		--console("Upload canceled !")
	end
end