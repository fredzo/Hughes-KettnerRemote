--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
settingsOk = function(--[[ CtrlrModulator --]] mod, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	-- Read modulator values
	omniMode = panel:getModulator("omniMode"):getValue()
	midiChannel = panel:getModulator("midiChannel"):getValue()
	powerEqGlobal = panel:getModulator("powerEqMode"):getValue()
	powerSoakGlobal = panel:getModulator("powerSoakMode"):getValue()
	local powerSoakValue = nil
	if (isLibrary or  isGm40()) and (powerSoakGlobal == 1) then
		powerSoakValue = globalPowerSoakValue
	else
		if editBuffer ~= nil then
			powerSoakValue = editBuffer["powerSoak"]
		end
	end
	-- Send to amp
	sendSystemConfig()
	if powerSoakValue ~= nil then
		setModulatorValue("powerSoak",powerSoakValue,false,false)
		sendParameter(30,powerSoakValue)
	end
    -- Switch amp type if needed
    local ampSwitchValue = panel:getModulator("ampTypeSwitch"):getValue()
    local newAmpType
    if ampSwitchValue == 0 then
        newAmpType = "GM36"
    elseif ampSwitchValue == 1 then
        newAmpType = "GM40"
    else
        newAmpType = "BS200"
    end
    switchAmpType(newAmpType)
	switchToEditorTab()
end