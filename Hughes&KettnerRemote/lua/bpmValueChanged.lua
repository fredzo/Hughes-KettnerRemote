--
-- Called when the contents of a Label are changed
-- @label
-- @newContent    a string that the label now contains
--

-- Global flag used to disable this callback when value is changed programmatically
stopBpmValueChangePropagation = false

bpmValueChanged = function(label, newContent)
	if stopBpmValueChangePropagation or panel:getBootstrapState() then
		return
	end
	local newDelayValue = currentDelayValue
	--console("currentDelayValue"..currentDelayValue)
	if newContent ~= "" then
		local value = tonumber(newContent)
		if value >= 44 and value <= 750 then
			--console("BPM"..value)
			delayTime = 60000 / value
			--console("Delay time ms "..delayTime)
			newDelayValue = math.floor((delayTime-51) / 5.13333)
		end
	end
	setDelayTime(newDelayValue,true,true,true,true)
end