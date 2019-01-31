--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
backupPresets = function(mod, value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
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
	ampBackupFile = fileToWrite
	-- Load all amp presets
	getAllPresetsAndSave()
end



getAllPresetsAndSave = function()
	-- Store callback
	progressFinishedCallback = getAllPresetsFinished
	-- Show progress dialog
	startProgress("Downloading presets...","Cancel")
	-- Send request
	sendAllPresetsRequest()
	-- Start progress bar and wait for midi message
	startDownloadProgressTimer()
end

function updateAmpBackupProgressWindow(value,message,finished,success)
	updateProgressValue(value)
	updateProgressStatus(message)
	if finished then
		if progressFinishedCallback ~= nil then
			progressFinishedCallback(success)
			progressFinishedCallback = nil
		end
		--switchToEditorTab()
		panel:getComponent("progressCancel"):setPropertyString("uiButtonContent","OK")
	end
end

function getAllPresetsFinished(complete)
	stopDownloadProgressTimer()
	if complete then
		savePresetsToFile(ampBackupFile:getFullPathName(),ampPresets)
		if connected then
			-- Force combo and preset name update even if we are already in amp mode
			isLibrary = true
			setPresetMode(1,false)
			changePresetMode(false,true)
		end
	end
	ampBackupFile = nil
end