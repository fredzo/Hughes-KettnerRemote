--
--
--
modulationTypeChanged = function(modulator, numericModulatorValue)
	if panel:getBootstrapState() then
		return numericModulatorValue
	end
	modulationValue = (numericModulatorValue * 64)
	-- Get modulation type value
	modulationRateModulator = panel:getModulator("modulationRate")
	if modulationRateModulator ~= nil then
		modulationRate = modulationRateModulator:getValue()
		modulationValue = modulationValue + modulationRate
	else
		console("Modulator not found: modulationRate")
	end
	generateMidi(modulator,modulationValue)
	if compareMode then
		highlight("modTypeKnob")
	end
return numericModulatorValue
end