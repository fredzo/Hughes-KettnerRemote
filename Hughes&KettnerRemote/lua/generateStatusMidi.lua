--
--
--
generateStatusMidi = function(modulator, numericModulatorValue)
	if numericModulatorValue == 0 then
		return generateMidi(modulator,0)
	else
		return generateMidi(modulator,127)
	end
end