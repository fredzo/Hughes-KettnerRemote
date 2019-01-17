--
--
--
ampTypeSwitchChanged = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] numericModulatorValue)
	if panel:getBootstrapState() or panel:getRestoreState() then
		return numericModulatorValue
	end
    local newAmpType
    if numericModulatorValue == 0 then
        newAmpType = "GM36"
    elseif numericModulatorValue == 1 then
        newAmpType = "GM40"
    else
        newAmpType = "BS200"
    end
    --console("Switching amp type to "..newAmpType)
    switchAmpType(newAmpType)
    return numericModulatorValue
end