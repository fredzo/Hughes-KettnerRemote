--
-- Called when an item is clicked
--
-- @modulator the modulator the event occured on
-- @value      a integer that represents the clicked item
--

libraryEditorItemClicked = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] value)
	if panel:getBootstrapState() or panel:getRestoreState() then
		return numericModulatorValue
	end
	local bankNumber = modulator:getPropertyInt("modulatorCustomIndex")
	-- console("Item clicked = "..value)
	local selectedIndex = (4 * (bankNumber-1)) + value + 1
	if (KeyPress.isKeyCurrentlyDown(KeyPress.escapeKey) or KeyPress.isKeyCurrentlyDown(KeyPress.tabKey)) then 
		if selectedIndex < librarySelectionStart then
			librarySelectionStart = selectedIndex
		else
			librarySelectionEnd = selectedIndex
		end
	else
		librarySelectionStart = selectedIndex
		librarySelectionEnd = selectedIndex
	end
	libraryCursorPosition = selectedIndex
	updateLibraryEditorSelection()
end