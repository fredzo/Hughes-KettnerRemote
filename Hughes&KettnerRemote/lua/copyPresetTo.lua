--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
copyPresetTo = function(mod, value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	copyLibraryPreset(false)
end