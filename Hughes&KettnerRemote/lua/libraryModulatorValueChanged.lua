--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
libraryModulatorValueChanged = function(--[[ CtrlrModulator --]] mod, --[[ number --]] value)
	if panel:getBootstrapState() or panel:getRestoreState() or notActive(mod) then
		return
	end
	local paramName = mod:getName():replace("library-","",false)
	--console("New value for param "..paramName.." = "..value)
	for i=librarySelectionStart,librarySelectionEnd do
		--console("Changing value for preset "..i)
		libraryEditorPresets[i][paramName]=value
	end
	libraryChanged = true
end

function notActive(mod)
	local comp = mod:getComponent()
	--local childComp = comp:getChildComponent(0)
	--what(comp)
	--what(childComp)
	--if (mod == nil or comp == nil or childComp == nil or (not childComp:isMouseOver(true) and not comp:isMouseOver(true))) then
	--	console("Is mouse over false")
	--else
	--	console("Is mouse over true")
	--end
	return (mod == nil or comp == nil or ((not comp:isMouseOver(true)) and (not comp:hasKeyboardFocus(true))))
end

