--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
loadPresets = function(mod, value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end

	local fileToRead = utils.openFileWindow("Load library from disk", File(""), "*.gm36;*.gm36memory;*.gm40;*.gm40memory", true)

	-- Check if the file exists
	if fileToRead:existsAsFile() then
		currentLibraryFile = fileToRead:getFullPathName()
		local oldLibraryPresets = libraryPresets
		libraryPresets = loadLibraryFromFile()
		if libraryPresets == nil then
			-- TODO alert : could not read file
			libraryPresets = oldLibraryPresets
		else
			updateDisplayAfterLibraryLoad()
		end
	else
		console("Could not open file "..fileToRead:getFullPathName())
	end
end

function updateDisplayAfterLibraryLoad()
	libraryDirty = false
	lastPresetDirty = false
	setLibraryFileName()
	-- Make sure we force the preset mode update
	if isLibrary then
		isLibrary = false
		currentLibraryPresetNumber = currentPresetNumber
		currentPresetNumber = currentAmpPresetNumber
	end
	setPresetMode(0,false)
	changePresetMode(true,true)
end