--
--
--
modulationRateChanged = function(modulator, numericModulatorValue)
	if panel:getBootstrapState() then
		return numericModulatorValue
	end
	modulationValue = numericModulatorValue
	-- Get modulation type value
	modulationTypeModulator = panel:getModulator("modulationType")
	if modulationTypeModulator ~= nil then
		modulationType = modulationTypeModulator:getValue()
		modulationValue = modulationValue + (modulationType * 64)
	else
		console("Modulator not found: modulationType")
	end
	generateMidi(modulator,modulationValue)
	if compareMode then
		highlight("modRateKnob")
	end
return numericModulatorValue
end