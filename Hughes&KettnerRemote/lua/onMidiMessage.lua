--
-- Called when a panel receives a midi message (does not need to match any modulator mask)
-- @midi   http://ctrlr.org/api/class_ctrlr_midi_message.html
--

onMidiMessage = function(midi)
	-- Blink Midi In Led
	blinkMidiInLed()
	local messageType = midi:getType()
	--console("Message type"..messageType)
	if messageType == 5 then
		local midiData = midi:getData()
		if midiData:getSize() >= 13 
			and midiData:getByte(0) == 0xF0
			and midiData:getByte(1) == 0x00
			and midiData:getByte(2) == 0x20
			and midiData:getByte(3) == 0x44
			and midiData:getByte(4) == 0x00
			and midiData:getByte(5) == 0x10
			and midiData:getByte(6) == 0x00
			and ((midiData:getByte(7) == 0x06) or (midiData:getByte(7) == 0x0A) or (midiData:getByte(7) == 0x0C))
			and midiData:getByte(8) == 0x00 then
			-- Detect command type
			commandType = midiData:getByte(9)
			if (commandType == 0x04) or (commandType == 0x44) then
				-- Parameter change
				--console("Param change")
				paramType = midiData:getByte(10)
				--console("ParamType="..paramType)
				if paramType == 0x01 then
					--console("Modulation Intensity")
					modulator = panel:getModulator("modulationIntensity")
				elseif paramType == 0x04 then
					--console("Delay time")
					msb = midiData:getByte(11)
					lsb = midiData:getByte(12)
					value = convertToInt(msb,lsb)
					setDelayTime(value,true,true,false,false)
					modulator = nil
				elseif paramType == 0x09 then
					--console("GLobal mute")
					msb = midiData:getByte(11)
					lsb = midiData:getByte(12)
					value = convertToInt(msb,lsb)
					setStatusModulatorValue("globalMute",value)
					modulator = nil
				elseif paramType == 0x0C then
					--console("Mod type")
					msb = midiData:getByte(11)
					lsb = midiData:getByte(12)
					value = convertToInt(msb,lsb)
					setModulation(value,false,false)
					modulator = nil
				elseif paramType == 0x15 then
					--console("Preamp bass")
					modulator = panel:getModulator("preampBass")
				elseif paramType == 0x16 then
					--console("Preamp mid")
					modulator = panel:getModulator("preampMid")
				elseif paramType == 0x17 then
					--console("Preamp Treble")
					modulator = panel:getModulator("preampTreble")
				elseif paramType == 0x18 then
					--console("Power Amp Resonance")
					modulator = panel:getModulator("powerResonance")
				elseif paramType == 0x19 then
					--console("Power Amp Presence")
					modulator = panel:getModulator("powerPresence")
				elseif paramType == 0x1B then
					--console("Delay Feedback")
					modulator = panel:getModulator("delayFeedback")
				elseif paramType == 0x1C then
					--console("Delay level")
					modulator = panel:getModulator("delayLevel")
				elseif paramType == 0x1D then
					--console("Reverb level")
					modulator = panel:getModulator("reverbLevel")
				elseif paramType == 0x1E then
					--console("Power soak")
					modulator = panel:getModulator("powerSoak")
				elseif paramType == 0x34 then
					--console("GLobal mute")
					msb = midiData:getByte(11)
					lsb = midiData:getByte(12)
					value = convertToInt(msb,lsb)
					setStatusModulatorValue("modulationStatus",value)
					modulator = nil
				elseif paramType == 0x35 then
					--console("GLobal mute")
					msb = midiData:getByte(11)
					lsb = midiData:getByte(12)
					value = convertToInt(msb,lsb)
					setStatusModulatorValue("delayStatus",value)
					modulator = nil
				elseif paramType == 0x36 then
					--console("GLobal mute")
					msb = midiData:getByte(11)
					lsb = midiData:getByte(12)
					value = convertToInt(msb,lsb)
					setStatusModulatorValue("reverbStatus",value)
					modulator = nil
				elseif paramType == 0x37 then
					--console("Fx Loop")
					msb = midiData:getByte(11)
					lsb = midiData:getByte(12)
					value = convertToInt(msb,lsb)
					setStatusModulatorValue("fxLoopStatus",value)
					modulator = nil
				elseif paramType == 0x38 then
					--console("Channel Gain")
					modulator = panel:getModulator("channelGain")
				elseif paramType == 0x39 then
					--console("Channel Volume")
					modulator = panel:getModulator("channelVolume")
				elseif paramType == 0x3F then
					--console("Noise Gate")
					msb = midiData:getByte(11)
					lsb = midiData:getByte(12)
					value = convertToInt(msb,lsb)
					setStatusModulatorValue("noiseGateStatus",value)
					modulator = nil
				elseif paramType == 0x40 then
					--console("Channel Boost")
					msb = midiData:getByte(11)
					lsb = midiData:getByte(12)
					value = convertToInt(msb,lsb)
					setStatusModulatorValue("channelBoost",value)
					modulator = nil
				else
					modulator = nil
				end
				if modulator ~= nil then
					msb = midiData:getByte(11)
					lsb = midiData:getByte(12)
					value = convertToInt(msb,lsb)
					--console("Value = "..value)
					modulator:setValue(value,true,true)
				else
					-- console("Modulator not found for paramType = "..paramType)
				end
				local paramName = controllers[paramType]
				if paramName ~= nil then
					if value ~= nil then
						-- Update edit buffer
						editBuffer[paramName]=value
						-- In library mode we update current preset too
						if isLibrary then
							if presets[currentPresetNumber] ~= nil then
								presets[currentPresetNumber][paramName]=value
								if not libraryDirty then
									libraryDirty = true
									setLibraryFileName()
								end
							end
						end
					end
					local presetModified = true
					if (paramName == "resonance") or (paramName == "presence") then
						if not isLibrary and (powerEqGlobal == 1) then
							-- Preset is not modified since we are in glabal mode
							presetModified = false
						end
					end
					if (paramName == "powerSoak") then
						if (isLibrary or isGm40()) and (powerSoakGlobal == 1) then
							-- Preset is not modified since we are in glabal mode
							presetModified = false
						end
					end
					if presetModified then
						-- Set modified status
						setModified(true)
						-- Highligt modulator
						if compareMode then
							highlight(paramName)
						end
					end
				end
			elseif commandType == 0x40 then
				--console("Preset dump")
 				--local now = Time.getMillisecondCounterHiRes()
				--if now > (lastStateChangeTime + 10000) then
					-- reset state
				--	state = 0
				--end
				local preset = readPreset(midiData)
				if state == 1 then
					-- Request for a full presets dump (wait 500 ms to give time for the GM36 to boot)
					state = 2
					timer:startTimer (74, 1000)
				end
			elseif commandType == 0x41 then
				if midiData:getSize() >= 4108 then
					-- All presets dump (header = 10 bytes, cks + F7 = 2 bytes, 128 * 32 bytes per preset)
					local preset
					local startIndex = 10
					for i=1,128 do
						preset = readPresetBuffer(i,midiData,startIndex,true)
						startIndex = startIndex + 32
					end
					setSynced(true)
				end
				if state == 2 then
					-- Go to idle mode
					state = 3
				end
			elseif commandType == 0x4F then
				-- Ack or Nack
				local status = midiData:getByte(10)
				if status == 0x7F then
					-- Ack
					--console("Ack received...")
					--console("PTSI ="..presetsToSendIndex)
					if presetsToSend ~= nil then
						presetsToSendIndex = presetsToSendIndex+1
						updateProgressWindow()
						if presetsToSendIndex <= presetsToSendSize then
							sendPresetBufferDump(presetsToSend[presetsToSendIndex],false)
						else
							presetsToSend = nil
							presetsToSendIndex = 0
							presetsToSendSize = 0
						end
					end
				else 
					-- Nak => try to send again
					if presetsToSend ~= nil then
						if presetsToSendIndex <= presetsToSendSize then
							sendPresetBufferDump(presetsToSend[presetsToSendIndex],false)
						end
					end
					--console("Something went wrong !...")
				end
			elseif commandType == 0x50 then
				-- System config dump
				-- Detect amp type
				local ampId = midiData:getByte(7)
				if ampId == 0x0A then
					switchAmpType("GM40")
                elseif ampId == 0x0C then
					switchAmpType("BS200")
				else
					switchAmpType("GM36")
				end
				local midi = midiData:getByte(10)
				mutes = midiData:getByte(11)
				local mode = midiData:getByte(12)
				local configState = midiData:getByte(13)
				omniMode=(math.floor(midi/16) % 2)
				midiChannel=((midi % 16)+1)
				powerEqGlobal=(math.floor(mode/4) % 2)
				if isGm40() then
					powerSoakGlobal=(math.floor(mode/32) % 2)
				end
				midiLearn=(mode % 2)
				speakerConnected=(configState % 2)
				modified=(math.floor(configState/2) % 2)
				fxAccess=(math.floor(configState/4) % 2)
				-- Update modulators
				panel:getModulator("omniMode"):setValue(omniMode,true,true)
				panel:getModulator("midiChannel"):setValue(midiChannel,true,true)
				panel:getModulator("powerEqMode"):setValue(powerEqGlobal,true,true)
				if isGm40() then
					panel:getModulator("powerSoakMode"):setValue(powerSoakGlobal,true,true)
				end
				-- Process mutes
				local fxMute = (mutes % 2)
				local delayMute = (math.floor(mutes/2) % 2)
				local reverbMute = (math.floor(mutes/4) % 2)
				local globalMute = (math.floor(mutes/8) % 2)
				setStatusModulatorValue("globalMute",globalMute)
				setStatusModulatorValue("modulationStatus",opposite(fxMute))
				setStatusModulatorValue("delayStatus",opposite(delayMute))
				setStatusModulatorValue("reverbStatus",opposite(reverbMute))
				-- Send id request now
				--sendIdRequest()
				if state == 0 then
					-- Request edit buffer after config on connection start
					state = 1
					sendEditBufferRequest()
				end
			end
			-- We are connected
			setConnected(true)
		elseif midiData:getSize() >= 17 
			and midiData:getByte(0) == 0xF0
			and midiData:getByte(1) == 0x7E
			and midiData:getByte(2) == 0x00
			and midiData:getByte(3) == 0x06
			and midiData:getByte(4) == 0x02
			and midiData:getByte(5) == 0x00
			and midiData:getByte(6) == 0x20
			and midiData:getByte(7) == 0x44
			and midiData:getByte(8) == 0x10
			and midiData:getByte(9) == 0x00
			and midiData:getByte(10) == 0x06
			and midiData:getByte(11) == 0x00 then
			-- Id reply
			setConnected(true)
			local fw1 = midiData:getByte(12) - 0x30
			local fw2 = midiData:getByte(14) - 0x30
			local fw3 = midiData:getByte(15) - 0x30
			firmwareVersion = ""..fw1.."."..fw2..fw3
			--console("FW Version = "..firmwareVersion)
			panel:getComponent("firmwareVersion"):setComponentText(firmwareVersion)
		end
	end
end

readPreset = function(midiData)
	local bankLsb = midiData:getByte(10)
	local bankMsb = midiData:getByte(11)
	local number
	local updateEditBuffer = false
	local updatePrests = true
	local isEditBuffer = false
	if bankLsb == 0x7F and bankMsb == 0x7F then
		-- Edit buffer
		isEditBuffer = true
		if not connected then
			-- First connection => get amp preset number
 			number = midiData:getByte(12)+1
			currentAmpPresetNumber = sanitizePresetNumber(number)
			updateEditBuffer = true
		else
			-- Edit buffer => keep current preset numner
 			number = currentPresetNumber
		end
		-- Don't update presets for edit buffer
		updatePrests = false
	else
		if isLibrary then
			-- We receive a preset number while in library mode (use of the FSM) => switch to amp mode
			setPresetMode(1,false)
			changePresetMode(false,false)
		end
 		number = midiData:getByte(12)+1
		updateEditBuffer = true
	end
	local preset = readPresetBuffer(number,midiData,13,updatePrests)
	if updateEditBuffer then
		-- Update edit buffer
		editBuffer = copyPreset(preset)
		originalBuffer = copyPreset(preset)
	end
	if isEditBuffer then
		if isGm40() and (powerSoakGlobal == 1) then
			-- Get globalPowerSoakValue from edit buffer
			globalPowerSoakValue = preset["powerSoak"]
		end
	end
	loadPreset(preset,updateEditBuffer)
	return preset
end

readPresetBuffer = function(number,midiData,startIndex,updatePresets)
	local preset = {}
	-- Number
	preset["number"]=number
	-- Restore name
	preset["name"]=computePresetName(number)
	-- Gain
	local value = convertToInt(midiData:getByte(startIndex),midiData:getByte(startIndex+1))
	preset["gain"]=value
	-- Bass
	value = convertToInt(midiData:getByte(startIndex+2),midiData:getByte(startIndex+3))
	preset["bass"]=value
	-- Mid
	value = convertToInt(midiData:getByte(startIndex+4),midiData:getByte(startIndex+5))
	preset["mid"]=value
	-- Volume
	value = convertToInt(midiData:getByte(startIndex+6),midiData:getByte(startIndex+7))
	preset["volume"]=value
	-- Treble
	value = convertToInt(midiData:getByte(startIndex+8),midiData:getByte(startIndex+9))
	preset["treble"]=value
	-- Resonance
	value = convertToInt(midiData:getByte(startIndex+10),midiData:getByte(startIndex+11))
	preset["resonance"]=value
	-- Presence
	value = convertToInt(midiData:getByte(startIndex+12),midiData:getByte(startIndex+13))
	preset["presence"]=value
	-- Reverb
	value = convertToInt(midiData:getByte(startIndex+14),midiData:getByte(startIndex+15))
	preset["reverb"]=value
	-- Delay level
	value = convertToInt(midiData:getByte(startIndex+16),midiData:getByte(startIndex+17))
	preset["delayLevel"]=value
	-- Delay Time
	value = convertToInt(midiData:getByte(startIndex+18),midiData:getByte(startIndex+19))
	preset["delayTime"]=value
	-- Delay Feedback
	value = convertToInt(midiData:getByte(startIndex+20),midiData:getByte(startIndex+21))
	preset["delayFeedback"]=value
	-- Mod intensity
	value = convertToInt(midiData:getByte(startIndex+22),midiData:getByte(startIndex+23))
	preset["modIntensity"]=value
	-- This is global setting, not preset
	-- setStatusModulatorValue("modulationStatus",value)
	-- Mod type
	value = convertToInt(midiData:getByte(startIndex+24),midiData:getByte(startIndex+25))
	preset["modType"]=value
	local qqByte = midiData:getByte(startIndex+30)
	local rrByte = midiData:getByte(startIndex+31)
	-- Preamp channel
	value = (rrByte % 4) * 42
	preset["channelType"]=value
	-- Pream boost
	value = (math.floor(rrByte/4) % 2) * 127
	preset["channelBoost"]=value
	-- Fx loop
	value = (math.floor(rrByte/8) % 2) * 127
	preset["fxLoop"]=value
	-- Power soak
	value = (math.floor(rrByte/16) % 8) * 31
	preset["powerSoak"]=value
	-- Noise Gate
	value = (qqByte % 2) * 127
	preset["noiseGate"]=value
	if updatePresets then
		presets[number]=preset
	end
	return preset
end

computePresetName = function(presetNumber)
	local result
	if presets[presetNumber] ~= nil and presets[presetNumber]["name"] ~= nil then
		result = presets[presetNumber]["name"]
	else
		result = "Preset "..presetNumber
	end
	return result
end

loadPreset = function(preset,setNumber)
	-- Sanity check
	if preset == nil then return end
	-- Preset Number
	local value = preset["number"]
	--console("Load preset "..value)
	if setNumber then
		setPresetNumber(value)
	end
	-- Gain
	value = preset["gain"]
	setModulatorValue("channelGain",value,false,true)
	-- Bass
	value = preset["bass"]
	setModulatorValue("preampBass",value,false,true)
	-- Mid
	value = preset["mid"]
	setModulatorValue("preampMid",value,false,true)
	-- Volume
	value = preset["volume"]
	setModulatorValue("channelVolume",value,false,true)
	-- Treble
	value = preset["treble"]
	setModulatorValue("preampTreble",value,false,true)
	-- Resonance
	value = preset["resonance"]
	setModulatorValue("powerResonance",value,false,true)
	-- Presence
	value = preset["presence"]
	setModulatorValue("powerPresence",value,false,true)
	-- Reverb
	value = preset["reverb"]
	setModulatorValue("reverbLevel",value,false,true)
	-- This is global setting, not preset
	--setStatusModulatorValue("reverbStatus",value)
	-- Delay level
	value = preset["delayLevel"]
	setModulatorValue("delayLevel",value,false,true)
	-- This is global setting, not preset
	-- setStatusModulatorValue("delayStatus",value)
	-- Delay Time
	value = preset["delayTime"]
	setDelayTime(value,true,true,false,true)
	-- Delay Feedback
	value = preset["delayFeedback"]
	setModulatorValue("delayFeedback",value,false,true)
	-- Mod intensity
	value = preset["modIntensity"]
	setModulatorValue("modulationIntensity",value,false,true)
	-- This is global setting, not preset
	-- setStatusModulatorValue("modulationStatus",value)
	-- Mod type
	value = preset["modType"]
	setModulation(value,false,true)
	-- Preamp channel
	value = preset["channelType"]
	setModulatorValue("channelType",value,false,false)
	-- Pream boost
	value = preset["channelBoost"]
	setStatusModulatorValue("channelBoost",value)
	-- Fx loop
	value = preset["fxLoop"]
	setStatusModulatorValue("fxLoopStatus",value)
	-- Power soak
	if (isLibrary or isGm40()) and (powerSoakGlobal == 1) then
		value = globalPowerSoakValue
	else
		value = preset["powerSoak"]
	end
	setModulatorValue("powerSoak",value,false,false)
	-- Noise Gate
	value = preset["noiseGate"]
	setStatusModulatorValue("noiseGateStatus",value)
	--console("Load preset done")
end

convertToInt = function(msb,lsb)
	local value = 128*msb+lsb
	return value
end

setModulatorValue = function(modulatorName, modulatorValue, sendMidi, animate)
	local modulator = panel:getModulator(modulatorName)
	if modulator ~= nil then
		--console("Set "..modulatorName..": Value = "..modulatorValue)
		if animate then
			local currentValue = modulator:getValue()
			animations[modulatorName] = {modulator,currentValue,modulatorValue,sendMidi}
			if not timer:isTimerRunning(69) then
				animationEndTime = Time.getMillisecondCounterHiRes() + animationDuration
				lastAnimationTimerCall = 0
				timer:startTimer (69, 1)
			end
		else
			modulator:setValue(modulatorValue,true,not sendMidi)
		end
	else
		console("Modulator not found for "..modulatorName)
	end

end

setStatusModulatorValue = function(modulatorName, modulatorValue)
	local modulator = panel:getModulator(modulatorName)
	if modulator ~= nil then
		if modulatorValue ~= 0 then
			modulatorValue = 1
		end
		--console("Set "..modulatorName..": Value = "..modulatorValue)
		modulator:setValue(modulatorValue,true,true)
	else
		console("Modulator not found for "..modulatorName)
	end
end

setModulation = function(modulationValue,sendMidi,animate)
	--console("Modulation value"..modulationValue)
	local modulationTypeModulator = panel:getModulator("modulationType")
	local type = math.floor(modulationValue / 64)
	if modulationTypeModulator ~= nil then
		--console("Set modulation type Value = "..type)
		modulationTypeModulator:setValue(type,true,true)
	else
		console("Modulator not found modulation type")
	end
	local modulationRateModulator = panel:getModulator("modulationRate")
	local rate
	if modulationValue == 255 then
		rate = 64
	else
		rate = (modulationValue % 64)
	end
	setModulatorValue("modulationRate",rate,sendMidi,animate)
end

function rotateTimerCallback (timerId)
	--console("timer id: "..timerId.." step: "..timerStep)
	if timerId ~= 69 then
		return
	end
	if animations == nil then
		return
	end

	--what(animations)

	local now = Time.getMillisecondCounterHiRes()
	local timerDuration
	if lastAnimationTimerCall > 0 then
		timerDuration = now - lastAnimationTimerCall
	else
		timerDuration = 1
	end
	local remainingSteps = (animationEndTime - now) / timerDuration
	lastAnimationTimerCall = now
	if remainingSteps > 0 then
		for k,v in pairs(animations) do
			local currentValue = v[2]
			local finalValue = v[3]
			local increment = (finalValue - currentValue) / remainingSteps
			local newValue = currentValue + increment
 			v[1]:setValue(math.floor(newValue),true,true)
			v[2] = newValue
			if increment > 0 then
				if newValue >= finalValue then
					animations[k] = nil
					v[1]:setValue(finalValue,true,not v[4])
				end
			else
				if newValue <= finalValue then
					animations[k] = nil
					v[1]:setValue(finalValue,true,not v[4])
				end
			end
		end
	else
		timer:stopTimer(timerId)
		timerStep = 0
		for k,v in pairs(animations) do
			local finalValue = v[3]
 			v[1]:setValue(finalValue,true,not v[4])
		end
		animations = {}
	end
end

setConnected = function(value)
	if connected ~= value then
		connected = value
		setLedModulatorValue("connectedLed",connected)
		if not connected then
			synced = false
			setLedModulatorValue("syncedLed",false)
		end
		local component = panel:getComponent("presetMode")
		local component2 = panel:getComponent("presetModeLibrary")
		local component3 = panel:getComponent("presetModeAmp")
		if connected then
			-- Hack to prevent sending preset dump on init : we mute preset combo change until timer triggers or connection is established
			mutePresetKomboChange = false
			-- Stop connection timer
			timer:stopTimer(70)
			-- Enable presetMode controller
			component:setEnabled(true)
			component:setPropertyString("uiImageButtonResource","switch-toggle-led")
			component2:setEnabled(true)
			component3:setEnabled(true)
			-- Swicth to amp
			setPresetMode(1,false)
			changePresetMode(false,false)
		else
			-- Switch to library
			setPresetMode(0,false)
			changePresetMode(true,false)
			-- Disable preset mode controller
			component:setEnabled(false)
			component:setPropertyString("uiImageButtonResource","switch-toggle-led-dis")
			component2:setEnabled(false)
			component3:setEnabled(false)
			-- Start connection timer
			timer:startTimer(70,1000)
		end
	end
end

setSynced = function(value)
	if synced ~= value then
		synced = value
		setLedModulatorValue("syncedLed",synced)
		local component = panel:getComponent("ampBackup")
		if synced then
			-- Enable amp backup button
			component:setEnabled(true)
		else
			-- Disable amp backup button
			component:setEnabled(false)
		end
	end
end

setPresetMode = function(value,sendMidi)
	local modulator = panel:getModulator("presetMode")
	if modulator ~= nil then
		if value ~= 0 then
			value = 1
		end
		modulator:setValue(value,true,not sendMidi)
	else
		console("Preset mode modulator not found")
	end
end

setLedModulatorValue = function(modulatorName,value)
	local modulator = panel:getModulator(modulatorName)
	if modulator ~= nil then
		--console("Set "..modulatorName..": Value = "..modulatorValue)
		local modValue
 		if value then 
			modValue = 1
		else
			modValue = 0
		end
		--modulator:setValue(modValue,true,true)
		modulator:setPropertyInt("modulatorValue",modValue)
	else
		console("Led modulator not found for "..modulatorName)
	end
end

getLedModulatorValue = function(modulatorName)
	local modulator = panel:getModulator(modulatorName)
	local result
	if modulator ~= nil then
		--console("Set "..modulatorName..": Value = "..modulatorValue)
		result = modulator:getValue()
	else
		console("Led modulator not found for "..modulatorName)
		result = 0
	end
	if result == 1 then
		return true
	else
		return false
	end
end

blinkMidiInLed = function(modulatorName)
	setLedModulatorValue("midiInLed",true)
	timer:startTimer (71, 100)
end

blinkMidiOutLed = function(modulatorName)
	setLedModulatorValue("midiOutLed",true)
	timer:startTimer (72, 100)
end

function blinkMidiInLedTimerCallback(timerId)
	--console("timer id: "..timerId.." step: "..timerStep)
	if timerId ~= 71 then
		return
	end
	setLedModulatorValue("midiInLed",false)
	timer:stopTimer(timerId)
end

function blinkMidiOutLedTimerCallback(timerId)
	--console("timer id: "..timerId.." step: "..timerStep)
	if timerId ~= 72 then
		return
	end
	setLedModulatorValue("midiOutLed",false)
	timer:stopTimer(timerId)
end

function opposite(value)
	if value == 1 then
		return 0
	else
		return 1
	end
end