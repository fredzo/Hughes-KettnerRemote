--
--
--
ampTypeSwitchChanged = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] numericModulatorValue)
	if panel:getBootstrapState() or notMouseOver(modulator) then
		return
	end
	if not externalPresetsLoaded then
		return
	end
    local newAmpType
    if numericModulatorValue == 0 then
        newAmpType = "GM36"
    elseif numericModulatorValue == 1 then
        newAmpType = "GM40"
    else
        newAmpType = "BS200"
    end
    switchAmpType(newAmpType)
    return numericModulatorValue
end