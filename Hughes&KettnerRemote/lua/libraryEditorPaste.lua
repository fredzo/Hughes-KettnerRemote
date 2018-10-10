--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
libraryEditorPaste = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(modulator) then
		return
	end
	doLibraryEditorPaste()
end

function doLibraryEditorPaste()
	if libraryCliboardEmpty or (librarySelectionStart ~= librarySelectionEnd) then
		return
	end
	-- Store current content for undo and paste new content
	local selectionIndex = librarySelectionStart
	for k,v in ipairs(libraryClipboard) do
		libraryUndoContent[k] = copyPreset(libraryEditorPresets[selectionIndex])
		libraryEditorPresets[selectionIndex] = copyPreset(v)
		-- Fix preset number
		libraryEditorPresets[selectionIndex]["number"]=selectionIndex
		selectionIndex = selectionIndex + 1
		if selectionIndex > 128 then
			break
		end
	end
	libraryUndoEmpty = false
	libraryUndoStart = librarySelectionStart
	libraryChanged = true
	initLibraryEditor()
end