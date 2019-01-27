--
--
--
cabTypeComboChanged = function(modulator, value)
	if panel:getBootstrapState() or panel:getBootstrapState() or preventCabTypeUpdate then
		preventCabTypeUpdate = false
		return
	end
	--console("Update cab type "..value)
	-- Convert to 255 based value
	value = value * 36
	setCabType(value,false,true,false)
	generateMidi(modulator,value)
	if compareMode then
		highlight("cabinetType")
	end
end

preventCabTypeUpdate = false
