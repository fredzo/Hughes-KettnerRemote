--
--
--
presetStepChanged = function(modulator, numericModulatorValue)
	if panel:getBootstrapState() or notMouseOver(modulator) then
		return numericModulatorValue
	end
	--console("Preset step changed = "..numericModulatorValue)
	changePresetNumber(numericModulatorValue+1)
	return numericModulatorValue
end