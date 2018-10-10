--
-- Called when the contents of a Label are changed
-- @label
-- @newContent    a string that the label now contains
--

presetNameChanged = function(label, newContent)
	if panel:getBootstrapState() or panel:getRestoreState() then
		return
	end
	-- Get the presetsName array value for the current presetNumber
	local presetName
	if presets[currentPresetNumber] ~= nil then
		presetName = presets[currentPresetNumber]["name"]
	else
		presets[currentPresetNumber] = {}
	end
	if newContent ~= presetName then
		-- Preset name was edited => update the presetNames array
		--console("Preset name updated for index "..currentPresetNumber)
		-- Update edit buffer
		editBuffer["name"] = newContent
		-- And current preset
		presets[currentPresetNumber]["name"] = newContent
		-- And update combo content
		combo = getPresetCombo()
		if combo ~= nil then
			combo:changeItemText(currentPresetNumber,""..currentPresetNumber.." - "..newContent)
			setComboSelection()
		end
		-- Update dirty state
		if isLibrary and not libraryDirty then
			libraryDirty = true
			setLibraryFileName()
		end
	end
end