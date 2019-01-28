--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
cancel = function(--[[ CtrlrModulator --]] mod, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	local completed = presetsToSendIndex >= presetsToSendSize
	presetsToSend = nil
	presetsToSendIndex = 0
	presetsToSendSize = 0
	if progressFinishedCallback ~= nil then
		progressFinishedCallback(completed)
		progressFinishedCallback = nil
	end
	switchToEditorTab()
end

function startProgress(progressLabel,cancelLabel)
	panel:getComponent("progressLabel"):setComponentText(progressLabel)
	panel:getComponent("progressCancel"):setPropertyString("uiButtonContent",cancelLabel)
	updateProgressStatus("")
	updateProgressValue(0)
	switchToProgressTab()
end

function updateProgressStatus(status)
	panel:getComponent("progressStatus"):setComponentText(status)
end

function updateProgressValue(value)
	panel:getComponent("progressBar"):setComponentValue(value,true)
end