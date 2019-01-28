--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
backupPresets = function(mod, value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	-- TODO Force ampPresets update before backup
	local fileToWrite = utils.saveFileWindow("Save Amp presets to disk", File(""), getAmpTypeExtension(), true)

	if fileToWrite:isValid() == false then
		utils.warnWindow ("\n\nSorry, selected file is not valid.", "Invalid target file.")
		return
	end

	-- Check if the file exists
	if fileToWrite:existsAsFile() == false then
		
		-- If file does not exist, then create it
		if fileToWrite:create() == false then

			-- If file cannot be created, then fail here
			utils.warnWindow ("\n\nSorry, the Editor failed to\nsave the library to disk!", "The file does not exist.")

			return
		end
	else
		-- TODO warn about existing file
	end
	-- Load all amp presets
	savePresetsToFile(fileToWrite:getFullPathName(),ampPresets)
end