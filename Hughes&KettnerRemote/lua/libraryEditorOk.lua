--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
libraryEditorOk = function(--[[ CtrlrModulator --]] mod, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	if libraryChanged or libraryListenPressed then
		libraryListenPressed = false
		-- Restore edit buffers
		--console("Restore preset #"..currentPresetNumber.." name = "..presets[currentPresetNumber]['name'].." channel "..presets[currentPresetNumber]["channelType"])
		editBuffer = copyPreset(presets[currentPresetNumber])
		originalBuffer = copyPreset(presets[currentPresetNumber])
		-- Restore preset
		loadPreset(editBuffer,true)
		if connected then
			-- Send preset to amp
			sendEditBufferDump()
		end
	end
	if libraryChanged then
		if isLibrary then
			initPresetCombo()
		end
		-- Library is now dirty
		libraryDirty = true
		setLibraryFileName()
		libraryChanged = false
	end
	switchToEditorTab()
end