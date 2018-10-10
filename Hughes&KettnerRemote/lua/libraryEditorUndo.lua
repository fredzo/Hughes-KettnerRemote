--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
libraryEditorUndo = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(modulator) then
		return
	end
	doLibraryEditorUndo()
end

function doLibraryEditorUndo()
	if libraryUndoEmpty then
		return
	end
	-- Restore original content
	local selectionIndex = libraryUndoStart
	for k,v in ipairs(libraryUndoContent) do
		libraryEditorPresets[selectionIndex] = copyPreset(v)
		selectionIndex = selectionIndex + 1
		if selectionIndex > 128 then
			break
		end
	end
	-- Update undo status
	libraryUndoContent = {}
	libraryUndoEmpty = true
	libraryUndoStart = 0
	initLibraryEditor()
end