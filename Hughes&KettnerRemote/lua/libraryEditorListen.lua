--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
libraryEditorListen = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(modulator) then
		return
	end
	if connected then
		editBuffer = copyPreset(libraryEditorPresets[librarySelectionStart])
		-- Send preset to amp
		sendEditBufferDump()
		libraryListenPressed = true
	end
end