--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
libraryEditorMoveSelection = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(modulator) then
		return
	end
	local increment = modulator:getPropertyInt("modulatorCustomIndex")
	local selection = storeSelection()
	if increment > 0 then
		if (librarySelectionEnd + increment) > 128 then
			return
		end
		-- Move displaced elements
		for i=1,increment do
			moveAndFixPresetNumber(librarySelectionStart+i-1,libraryEditorPresets[librarySelectionEnd+i])
		end
	else
		if (librarySelectionStart + increment) <= 0 then
			return
		end
		-- Move displaced elements
		for i=1,(increment*-1) do
			moveAndFixPresetNumber(librarySelectionEnd-i+1,libraryEditorPresets[librarySelectionStart-i])
		end
	end
	librarySelectionStart=librarySelectionStart+increment
	librarySelectionEnd=librarySelectionEnd+increment
	libraryCursorPosition=libraryCursorPosition+increment
	-- Place selection
	local currentPosition = librarySelectionStart
	for k,v in ipairs(selection) do
		moveAndFixPresetNumber(currentPosition,v)
		currentPosition = currentPosition+1
	end
	libraryChanged = true
	initLibraryEditor()
end

function storeSelection()
	local selection = {}
	local selectionIndex = 1
	for i=librarySelectionStart,librarySelectionEnd do
		selection[selectionIndex] = libraryEditorPresets[i]
		selectionIndex = selectionIndex + 1
	end
	return selection
end

function moveAndFixPresetNumber(index,presetToMove)
	presetToMove["number"]=index
	libraryEditorPresets[index]=presetToMove
end



