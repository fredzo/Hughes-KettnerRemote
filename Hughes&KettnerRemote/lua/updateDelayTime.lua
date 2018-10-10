--
--
--
updateDelayTime = function(modulator, numericModulatorValue)
	--console("Update delay time")
	setDelayTime(numericModulatorValue,false,true,false)
	generateMidi(modulator,numericModulatorValue)
	return numericModulatorValue
end