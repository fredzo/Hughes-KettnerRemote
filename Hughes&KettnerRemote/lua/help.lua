--
-- Called when the mouse moves over a component
--

help = function(--[[ CtrlrModulator --]] mod, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	switchToHelpTab()
end