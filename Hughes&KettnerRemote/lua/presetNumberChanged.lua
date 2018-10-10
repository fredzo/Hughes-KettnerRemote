--
-- Called when the contents of a Label are changed
-- @label
-- @newContent    a string that the label now contains
--

presetNumberChanged = function(label, newContent)
	if stopBpmValueChangePropagation or panel:getBootstrapState() then
		return
	end
	--console("New preset number "..newContent)
	local newPresetValue = nil
	if newContent ~= "" then
		local value = tonumber(newContent)
		if value ~= nil and value >= 1 and value <= 128 then
			newPresetValue = value
		else
			newPresetValue = nil
		end
	end
	if newPresetValue ~= nil and newPresetValue ~= currentPresetNumber then
		changePresetNumber(newPresetValue)
	else
		local component = panel:getComponent("presetNumber")
		if component ~= nil then
			component:setComponentText(""..currentPresetNumber)
		else
	   		console("Modulator not found: presetName")
		end
	end
end