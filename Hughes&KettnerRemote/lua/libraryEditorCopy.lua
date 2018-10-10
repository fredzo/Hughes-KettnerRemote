--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
libraryEditorCopy = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(modulator) then
		return
	end
	doLibraryEditorCopy()
end

function doLibraryEditorCopy()
	-- copy content of selection into clipboard
	local selectionIndex = 1
	for i=librarySelectionStart,librarySelectionEnd do
		libraryClipboard[selectionIndex] = copyPreset(libraryEditorPresets[i])
		selectionIndex = selectionIndex + 1
	end
	-- set clipboard metadata
	libraryClipboardStart = librarySelectionStart
	libraryClipboardEnd = librarySelectionEnd
	libraryCliboardEmpty = false
	libraryClipboardSourceIsLib = not libraryEditorExternal
	initLibraryEditor()
end