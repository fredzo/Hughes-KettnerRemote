--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
setPresetCombo = function(mod, value)
	if panel:getBootstrapState()  or panel:getRestoreState() then
		return
	end
	--console("Set preset combo = "..value)
	if not mutePresetComboChange then
		-- TODO understand why this is called on prog startup...
		changePresetNumber(value+1)
	end
end

mutePresetComboChange = true

setComboSelection = function()
	combo = getPresetCombo()
	if combo ~= nil then
		mutePresetComboChange = true
		combo:setSelectedId(currentPresetNumber,0)
		mutePresetComboChange = false
	end
end