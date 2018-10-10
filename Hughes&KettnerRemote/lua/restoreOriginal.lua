--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
restoreOriginal = function(--[[ CtrlrModulator --]] mod, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	if not presetChanged then
		return
	end
	-- Restore original buffer
	editBuffer = copyPreset(originalBuffer)
	presets[currentPresetNumber] = copyPreset(editBuffer)

	-- Hide compare
	hideCompare()
	if libraryDirty and not lastPresetDirty then
		-- We are no longer dirty
		libraryDirty = false
		lastPresetDirty = false
		setLibraryFileName()
	end
	if not showOriginal then
		-- Restore original data
		sendEditBufferDump()
		if not connected then
			loadPreset(editBuffer,false)
		end
	end
end