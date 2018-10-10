
--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
savePresetsForIpad = function(mod, value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end

	local binaryLibraryFile = string.gsub(currentLibraryFile,"%.gm36","")
	binaryLibraryFile = string.gsub(binaryLibraryFile,"%.gm40","")
	local extension = "*.gm36memory"
	if isGm40() then
		extension = "*.gm40memory"
	end
	local fileToWrite = utils.saveFileWindow("Save iPad library to disk", File(binaryLibraryFile), extension, true)

	if fileToWrite:isValid() == false then
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
	end
	saveLibraryForIpad(fileToWrite:getFullPathName())
end