--
--
--
ampTypeSwitchChanged = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] numericModulatorValue)
	if panel:getBootstrapState() or panel:getRestoreState() then
		return numericModulatorValue
	end
    updateSettingsLabel()
    --console("Switching amp type to "..newAmpType)
    return numericModulatorValue
end
