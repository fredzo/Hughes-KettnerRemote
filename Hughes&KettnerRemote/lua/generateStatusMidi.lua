--
--
--
generateStatusMidi = function(modulator, numericModulatorValue)
	if numericModulatorValue == 0 then
		return generateMidi(modulator,0)
	else
		if isBs200() then
			-- BS 200 uses 8 bit based values
			return generateMidi(modulator,255)
		else
			return generateMidi(modulator,127)
		end
	end
end