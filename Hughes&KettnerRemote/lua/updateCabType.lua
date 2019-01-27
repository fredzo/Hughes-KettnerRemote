--
--
--
updateCabType = function(modulator, numericModulatorValue)
	if panel:getBootstrapState() or panel:getBootstrapState() then
		return numericModulatorValue
	end
	--console("Update cab type")
	setCabType(numericModulatorValue,false,true,false)
	return numericModulatorValue
end

setCabType = function(cabTypeValue,updateModulator,updateDisplay,sendMidi,animate)
	--console("Cab type value = "..cabTypeValue)
	-- Convert back to 1-8 based value
	local cabIndex = math.floor((cabTypeValue/36)+0.5)
	--console("Cab type index = "..cabIndex)
	if updateModulator then
		setModulatorValue("cabTypeStepper",cabTypeValue,sendMidi,animate)
		preventCabTypeUpdate = true
		--console("Set cabt type combo index = "..cabIndex)
		panel:getModulator("cabinetType"):setValue(cabIndex,true,true)
	end
	if updateDisplay then
		panel:getComponent("cabinetTypeLabel"):setComponentText("CAB "..(cabIndex+1))
	end
end

