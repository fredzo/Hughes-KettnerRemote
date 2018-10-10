currentDelayValue = 0
--
--
--
tapTempo = function(modulator, numericModulatorValue)
	if panel:getBootstrapState() or notMouseOver(modulator)  then
		return numericModulatorValue
	end
	newTapTime = Time.getMillisecondCounterHiRes()
	if lastTapTime ~= nil then
		delayTime = newTapTime - lastTapTime
		if delayTime >= 51 and delayTime <= 1360 then
			delayValue = (delayTime - 51) / 5.13333
			-- Round it for 7bit version
			delayValue = (math.floor(delayValue / 2))*2
			setDelayTime(delayValue,true,true,true,true)
		end		
	end
	lastTapTime = Time.getMillisecondCounterHiRes()
	return numericModulatorValue
end

setDelayTime = function(delayValue,updateModulator,updateDisplay,sendMidi,animate)
	--console("Delay value = "..delayValue)
	if delayValue < 0 then
		delayValue = 0
	elseif delayValue > 255 then
		delayValue = 255
	end
	currentDelayValue = delayValue
	if updateModulator then
		setModulatorValue("delayTime",delayValue,sendMidi,animate)
	end
	if updateDisplay then
		delayTime = math.floor((delayValue * 5.13333) + 51.5)
		bpm = math.floor(60000 / delayTime)
		--console("BPM = "..bpm)
		setBpm(bpm)
		setDelayTimeMs(delayTime)
	end
end

setBpm = function(bpmValue)
	component = panel:getComponent("delayBpm")
	if component ~= nil then
		--console("Set bpm Value = "..bpmValue)
		stopBpmValueChangePropagation = true
		component:setComponentText(""..bpmValue)
		stopBpmValueChangePropagation = false
	else
		console("Modulator not found delayBpm")
	end
end

setDelayTimeMs = function(timeValue)
	component = panel:getComponent("delayTimeMsLabel")
	if component ~= nil then
		--console("Set delay time ms Value = "..timeValue)
		component:setComponentText(""..timeValue.." ms")
	else
		console("Modulator not found delayBpm")
	end
end