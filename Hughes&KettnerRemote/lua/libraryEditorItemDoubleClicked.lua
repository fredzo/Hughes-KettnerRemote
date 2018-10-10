--
-- Called when an item is double clicked
--
-- @modulator the modulator the event occured on
-- @value      an integer that represents the double clicked item
--

libraryEditorItemDoubleClicked = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(modulator) then
		return
	end
	local bankNumber = modulator:getPropertyInt("modulatorCustomIndex")
	local selectedIndex = (4 * (bankNumber-1)) + value + 1
	librarySelectionStart = selectedIndex
	librarySelectionEnd = selectedIndex
	libraryCursorPosition = selectedIndex
	updateLibraryEditorSelection()

	local name = libraryEditorPresets[selectedIndex]["name"]
	local modalWindow = AlertWindow("Preset #"..selectedIndex.." name", "Change preset name", AlertWindow.QuestionIcon)
	modalWindow:addButton("OK", 1, KeyPress(KeyPress.returnKey), KeyPress())
	modalWindow:addButton("Cancel", 0, KeyPress(KeyPress.escapeKey), KeyPress())
	modalWindow:addTextEditor ("presetNameTextEditor", name, "Preset #"..selectedIndex..":", false)
	modalWindow:setModalHandler(libraryEditorPresetNameCallback)

	--  Never let Lua delete this window (3rd parameter), enter modal state
	modalWindow:runModalLoop()end

function libraryEditorPresetNameCallback(result, window)
	window:setVisible (false)
	if result == 1 then
		textEditor = window:getTextEditor("presetNameTextEditor")
		if textEditor ~= nil then	
			local newName = textEditor:getText()
			libraryEditorPresets[libraryCursorPosition]["name"]=newName
			libraryChanged = true
		end
	end
	initLibraryEditor()
end