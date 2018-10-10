--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
checkSynced = function(--[[ CtrlrModulator --]] mod, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	local value
	if synced then
		value = 1
	else
		value = 0
	end
	mod:setPropertyInt("modulatorValue",value)
	--console("Check synced !")
	if connected then
		-- Force connection check
		state = 0
		setConnected(false)
	end
end