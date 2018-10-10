--
-- Called when the a key is pressed and the component has focus
--

libraryEditorKeyPressed = function(--[[ CtrlrComponent --]] comp, --[[KeyPress --]] keyEvent, --[[ Component --]] originatingComponent)
	local doSelectionChange = false
	if keyEvent:getKeyCode() == KeyPress.upKey then
		if keyEvent:getModifiers():isShiftDown() then
			libraryCursorPosition = libraryCursorPosition - 1
			if libraryCursorPosition < librarySelectionStart then
				librarySelectionStart = libraryCursorPosition
			else
				librarySelectionEnd = libraryCursorPosition
			end
		else
			librarySelectionStart = libraryCursorPosition - 1
			librarySelectionEnd = librarySelectionStart
			libraryCursorPosition = librarySelectionStart
		end
		doSelectionChange = true
	elseif keyEvent:getKeyCode() == KeyPress.downKey then
		if keyEvent:getModifiers():isShiftDown() then
			libraryCursorPosition = libraryCursorPosition + 1
			if libraryCursorPosition > librarySelectionEnd then
				librarySelectionEnd = libraryCursorPosition
			else
				librarySelectionStart = libraryCursorPosition
			end
		else
			librarySelectionStart = libraryCursorPosition + 1
			librarySelectionEnd = librarySelectionStart
			libraryCursorPosition = librarySelectionStart
		end
		doSelectionChange = true
	elseif keyEvent:getKeyCode() == KeyPress.leftKey then
		if keyEvent:getModifiers():isShiftDown() then
			libraryCursorPosition = libraryCursorPosition - 32
			if libraryCursorPosition < librarySelectionStart then
				librarySelectionStart = libraryCursorPosition
			else
				librarySelectionEnd = libraryCursorPosition
			end
		else
			librarySelectionStart = libraryCursorPosition - 32
			librarySelectionEnd = librarySelectionStart
			libraryCursorPosition = librarySelectionStart
		end
		doSelectionChange = true
	elseif keyEvent:getKeyCode() == KeyPress.rightKey then
		if keyEvent:getModifiers():isShiftDown() then
			libraryCursorPosition = libraryCursorPosition + 32
			if libraryCursorPosition > librarySelectionEnd then
				librarySelectionEnd = libraryCursorPosition
			else
				librarySelectionStart = libraryCursorPosition
			end
		else
			librarySelectionStart = libraryCursorPosition + 32
			librarySelectionEnd = librarySelectionStart
			libraryCursorPosition = librarySelectionStart
		end
		doSelectionChange = true
	elseif keyEvent:getKeyCode() == 67 and (keyEvent:getModifiers():isCtrlDown() or keyEvent:getModifiers():isCommandDown() or keyEvent:getModifiers():isShiftDown()) then
		doLibraryEditorCopy()
	elseif keyEvent:getKeyCode() == 86 and (keyEvent:getModifiers():isCtrlDown() or keyEvent:getModifiers():isCommandDown() or keyEvent:getModifiers():isShiftDown()) then
		doLibraryEditorPaste()
	elseif keyEvent:getKeyCode() == 90 and (keyEvent:getModifiers():isCtrlDown() or keyEvent:getModifiers():isCommandDown() or keyEvent:getModifiers():isShiftDown()) then
		doLibraryEditorUndo()
	end
	--console("Key presed, key code "..keyEvent:getKeyCode().." modifiers "..keyEvent:getModifiers():getRawFlags())
	if doSelectionChange then
		if librarySelectionStart < 1 then
			librarySelectionStart = 1
		elseif librarySelectionStart > 128 then
			librarySelectionStart = 128
		end
		if librarySelectionEnd < 1 then
			librarySelectionEnd = 1
		elseif librarySelectionEnd > 128 then
			librarySelectionEnd = 128
		end
		if libraryCursorPosition < 1 then
			libraryCursorPosition = 1
		elseif libraryCursorPosition > 128 then
			libraryCursorPosition = 128
		end
		--console("Selection "..librarySelectionStart.." "..librarySelectionEnd)
		updateLibraryEditorSelection()
	end
end