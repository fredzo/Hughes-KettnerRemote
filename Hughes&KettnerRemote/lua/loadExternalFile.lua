--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
loadExternalFile = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(modulator) then
		return
	end
	local fileToRead = utils.openFileWindow("Load external file from disk", File(""), "*.gm36;*.gm36memory;*.gm40;*.gm40memory;*.bs200;*.bsmemory", true)

	-- Check if the file exists
	if fileToRead:existsAsFile() then
		currentExternalFile = fileToRead:getFullPathName()
		local oldExternalPresets = externalPresets
		externalPresets = loadFromFile(currentExternalFile,false)
		if externalPresets == nil then
			-- TODO alert : could not read file
			externalPresets = oldexternalPresets
		else
			externalPresetsLoaded = true
			libraryEditorExternal = true
			libraryEditorPresets = externalPresets
			setLibraryExternalToggle(libraryEditorExternal)
			initLibraryEditor()
		end
	else
		console("Could not open file "..fileToRead:getFullPathName())
	end
end