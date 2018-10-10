--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
settingsDefault = function(--[[ CtrlrModulator --]] mod, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	panel:getModulator("omniMode"):setValue(1,true,true)
	panel:getModulator("midiChannel"):setValue(1,true,true)
	panel:getModulator("powerEqMode"):setValue(0,true,true)
	panel:getModulator("powerSoakMode"):setValue(0,true,true)
end