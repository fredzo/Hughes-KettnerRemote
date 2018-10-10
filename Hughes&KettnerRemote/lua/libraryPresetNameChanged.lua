--
-- Called when the contents of a Label are changed
-- @label
-- @newContent    a string that the label now contains
--

libraryPresetNameChanged = function(--[[ CtrlrLabel --]] label, --[[ String --]] newContent)
	if panel:getBootstrapState() or panel:getRestoreState() then
		return
	end
	-- Disabled in bulk edit mode
	if librarySelectionStart == librarySelectionEnd then
		if libraryEditorPresets[libraryCursorPosition] ~= nil and libraryEditorPresets[libraryCursorPosition]["name"] ~= newContent then
			--console("New name for preset "..libraryCursorPosition.." = "..newContent)
			libraryEditorPresets[libraryCursorPosition]["name"]=newContent
			libraryChanged = true
			initLibraryEditor()
		end
	end
end