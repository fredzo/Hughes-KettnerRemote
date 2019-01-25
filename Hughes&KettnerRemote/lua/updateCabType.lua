--
--
--
updateCabType = function(modulator, numericModulatorValue)
	--console("Update cab type")
	setCabType(numericModulatorValue,false,true,false)
	generateMidi(modulator,numericModulatorValue)
	return numericModulatorValue
end

setCabType = function(cabTypeValue,updateModulator,updateDisplay,sendMidi,animate)
	--console("Cab type value = "..cabTypeValue)
	if updateModulator then
		setModulatorValue("cabinetType",cabTypeValue,sendMidi,animate)
	end
	if updateDisplay then
		panel:getComponent("cabinetTypeLabel"):setComponentText("CAB "..(cabTypeValue+1))
	end
end

