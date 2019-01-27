--
--
--
generateMidi = function(modulator, numericModulatorValue)
	if panel:getBootstrapState() or panel:getRestoreState() then
		return numericModulatorValue
	end
	local paramNumber = modulator:getPropertyInt("modulatorCustomIndex")
	--console("Generate midi for "..paramNumber.." value "..numericModulatorValue)
	local paramName = controllers[paramNumber]
	local preventModify = false
	if paramName ~= nil then
		-- Update edit buffer
		editBuffer[paramName]=numericModulatorValue
		-- Set global power soak if needed
		if paramName == "powerSoak" then
			if (isLibrary or isGm40()) and (powerSoakGlobal == 1) then
				globalPowerSoakValue = numericModulatorValue
				preventModify = true
			end
		end
		if (paramName == "resonance") or (paramName == "presence") then
			if (powerEqGlobal == 1) then
				preventModify = true
			end
		end
		if paramName == "cabinetType" then
			if (cabinetTypeGlobal == 1) then
				preventModify = true
			end
		end
		-- Reverb, delay and modulation status are only modifiable per preset for Bs200
		if (paramName == "reverbStatus") or (paramName == "delayStatus") or (paramName == "modulationStatus") then
			if not isBs200() then
				preventModify = true
			end
		end
		-- In library mode we update current preset too
		if isLibrary then
			if not preventModify and (presets[currentPresetNumber] ~= nil) then
				presets[currentPresetNumber][paramName]=numericModulatorValue
				if not libraryDirty then
					libraryDirty = true
					setLibraryFileName()
				end
			end
		end
		if not preventModify then
			-- Set modified status
			setModified(true)
			-- Highligt modulator
			if compareMode then
				highlight(paramName)
			end
		end
        -- Handle BlackSpirit chanel type specific values (0-256 instead of 0-127)
        if isBs200() then
            if paramName == "channelType" then
                numericModulatorValue = numericModulatorValue*2
            end
        end
	end
	sendParameter(paramNumber, numericModulatorValue)
	return numericModulatorValue
end

sendParameter = function(parameterNumber,parameterValue)
	local message= {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x05, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0xF7 }
	if isGm40() then
 		message[8] = 0x09
    elseif isBs200() then
 		message[8] = 0x0B
        message[10] = 0x44
	end
	message[11] = parameterNumber
	local msb = math.floor(parameterValue / 128)
	local lsb = parameterValue % 128
	message[12] = msb
	message[13] = lsb
	local checksum = 0
	for i=1,13 do
		checksum = (bxor(checksum,message[i]))
	end
	message[14] = checksum % 128
	local storeMessage = CtrlrMidiMessage(message)
	panel:sendMidiMessageNow (storeMessage)
	blinkMidiOutLed()
end

sendAllPresetsRequest = function()
	local message
	if isGm40() then
		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x09, 0x00, 0x01, 0x0C, 0xF7 }
	elseif isBs200() then
		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x0B, 0x00, 0x01, 0x0E, 0xF7 }
	else
		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x05, 0x00, 0x01, 0x00, 0xF7 }
	end
	local requestMessage = CtrlrMidiMessage(message)
	panel:sendMidiMessageNow (requestMessage)
	blinkMidiOutLed()
end

sendPresetRequest = function(presetNumber)
	local message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF7 }
	if isGm40() then
 		message[8] = 0x09 
	elseif isBs200() then
 		message[8] = 0x0B 
	end
	message[13] = presetNumber % 128
	local checksum = 0
	for i=1,13 do
		checksum = (bxor(checksum,message[i]))
	end
	message[14] = checksum % 128
	local requestMessage = CtrlrMidiMessage(message)
	panel:sendMidiMessageNow (requestMessage)
	blinkMidiOutLed()
end

sendEditBufferRequest = function()
	local message
	if isGm40() then
 		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x09, 0x00, 0x00, 0x7F, 0x7F, 0x00, 0x0D, 0xF7 } 
	elseif isBs200() then
 		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x0B, 0x00, 0x00, 0x7F, 0x7F, 0x00, 0x0F, 0xF7 } 
	else
 		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x05, 0x00, 0x00, 0x7F, 0x7F, 0x00, 0x01, 0xF7 }
	end
	local requestMessage = CtrlrMidiMessage(message)
	panel:sendMidiMessageNow (requestMessage)
	blinkMidiOutLed()
end

sendSystemConfigRequest = function()
	sendSystemConfigRequestForAmpType("GM36")
	sendSystemConfigRequestForAmpType("GM40")
	sendSystemConfigRequestForAmpType("BS200")
end

sendSystemConfigRequestForAmpType = function(ampTypeToCheck)
	local message
	if ampTypeToCheck == "GM40" then
 		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x09, 0x00, 0x10, 0x1D, 0xF7 }
	elseif ampTypeToCheck == "BS200" then
 		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x0B, 0x00, 0x10, 0x1F, 0xF7 }
	else
 		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x05, 0x00, 0x10, 0x11, 0xF7 }
	end
	local requestMessage = CtrlrMidiMessage(message)
	panel:sendMidiMessageNow (requestMessage)
	blinkMidiOutLed()
end

sendSystemConfig = function()
    if isBs200() then
		sendSystemConfigBlackSpirit()
    else
		sendSystemConfigMeister()
    end
end


sendSystemConfigMeister = function()
	local message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x05, 0x00, 0x50, 
	-- Data
	0x00, 0x00, 0x00, 0x00,
	-- Footer
	0x00, 0xF7 }
	if isGm40() then
 		message[8] = 0x09 
	end
	-- Set data
	message[11] = (midiChannel-1) + (omniMode*16)
	message[12] = mutes
	message[13] = midiLearn + ((powerEqGlobal%2)*4) + ((powerSoakGlobal%2)*32)
	-- Checksum
	local checksum = 0
	for i=1,14 do
		checksum = (bxor(checksum,message[i]))
	end
	message[15] = checksum % 128
	local requestMessage = CtrlrMidiMessage(message)
	panel:sendMidiMessageNow (requestMessage)
	blinkMidiOutLed()
end

sendSystemConfigBlackSpirit = function()
	local message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x0B, 0x00, 0x50, 
	-- Data
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	-- Footer
	0x00, 0xF7 }
	-- Set data
	message[11] = (midiChannel-1) + (omniMode*16)
	-- In Bs200 mode, powerSoakGlobal controller is used for cabinetType global status
	message[12] = (powerEqGlobal%2) + ((powerSoakGlobal%2)*2) + ((globalCabinetType%8)*4)
	writeIntToBuffer(globalResonance,message,13);
	writeIntToBuffer(globalPresence,message,15);
	-- Checksum
	local checksum = 0
	for i=1,16 do
		checksum = (bxor(checksum,message[i]))
	end
	message[17] = checksum % 128
	local requestMessage = CtrlrMidiMessage(message)
	panel:sendMidiMessageNow (requestMessage)
	blinkMidiOutLed()
end

sendIdRequest = function()
	local message = {0xF0, 0x7E, 0x7F, 0x06, 0x01, 0xF7 }
	local requestMessage = CtrlrMidiMessage(message)
	panel:sendMidiMessageNow (requestMessage)
	blinkMidiOutLed()
end

function bxor (a,b)
	local r = 0
	for i = 0, 8 do
		local x = a / 2 + b / 2
		if x ~= floor (x) then
			r = r + 2^i
		end
		a = floor (a / 2)
		b = floor (b / 2)
	end
	return r
end

sendEditBufferDump = function()
	sendPresetBufferDump(editBuffer,true)
end

sendOriginalBufferDump = function()
	sendPresetBufferDump(originalBuffer,true)
end

sendPresetBufferDump = function(preset,isEditBuffer)
	-- Header
	local message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x05, 0x00, 0x40,
	-- Preset number
 	0x00, 0x00, 0x00, 
	-- Data
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	-- Footer
	0x00, 0xF7 }
	if isGm40() then
 		message[8] = 0x09 
	elseif isBs200() then
 		message[8] = 0x0B 
	end
	-- Write preset number
	if isEditBuffer then
		message[11]=0x7F
		message[12]=0x7F
		message[13]=0x00
	else
		message[11]=0x00
		message[12]=0x00
		message[13]=((preset["number"]-1)%128)
	end
	-- Load data
	writePresetToBuffer(preset,message,14, (isEditBuffer and isLibrary and (powerSoakGlobal == 1)))
	-- Checksum
	local checksum = 0
	for i=1,45 do
		--console("bxor index "..i.." : "..message[i])
		checksum = (bxor(checksum,message[i]))
	end
	message[46] = checksum % 128
	local requestMessage = CtrlrMidiMessage(message)
	panel:sendMidiMessageNow (requestMessage)
	blinkMidiOutLed()
end

sendPresetsBufferDump = function(presetsToUpload,callback)
	if panel:getBootstrapState() then
    	return false
	end
	presetsToSend = {}
	presetsToSendIndex = 1
	presetsToSendSize = 1
	for k, v in pairs(presetsToUpload) do
		presetsToSend[presetsToSendSize] = copyPreset(v)
		presetsToSendSize = presetsToSendSize+1
	end
	presetsToSendSize = presetsToSendSize-1
	-- Store callback
	uploadFinishedCallback = callback
	-- Send first preset
	sendPresetBufferDump(presetsToSend[presetsToSendIndex],false)
	-- Show progress dialog
	startProgress("Sending presets...","Abort")
end

function updateProgressWindow()
	if presetsToSendSize == 0 or presetsToSendIndex == 0 or presetsToSend == nil then
		return
	end
	local progressValue = (presetsToSendIndex-1) / presetsToSendSize
	--progress:setProgress(progressValue)
	updateProgressValue(progressValue)
	local currentPreset = presetsToSend[presetsToSendIndex]
	if currentPreset ~= nil then
		local message = "Preset "..currentPreset["number"]..": "..currentPreset["name"]
		updateProgressStatus(message)
	end
	if presetsToSendIndex > presetsToSendSize then
		if uploadFinishedCallback ~= nil then
			uploadFinishedCallback(true)
			uploadFinishedCallback = nil
		end
		switchToEditorTab()
	end
end

getMidiOutChannel = function()
	local midiOutputChannel = panel:getPropertyInt("panelMidiOutputChannelDevice")
	if midiOutputChannel == nil then
		midiOutputChannel = 1
	end
	return midiOutputChannel
end

sendPresetChangeRequest = function(presetNumber)
	-- First send Program Change
	local presetValue = (presetNumber-1)
	local firstByte = 0xc0 + (getMidiOutChannel()-1)
	patchNumberMessage = CtrlrMidiMessage({firstByte, presetValue})
	panel:sendMidiMessageNow (patchNumberMessage)
	blinkMidiOutLed()
	-- Then send SysEx message for parameter "0x5A" (Preset Number) / device number is always 0x05 for FSM (even if amp is GM40)
	local message= {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x05, 0x00, 0x04, 0x5A, 0x00, 0x00, 0x00, 0xF7 }
	message[13] = presetValue
	local checksum = 0
	for i=1,13 do
		checksum = (bxor(checksum,message[i]))
	end
	message[14] = checksum % 128
	local storeMessage = CtrlrMidiMessage(message)
	panel:sendMidiMessageNow (storeMessage)
	blinkMidiOutLed()
end

sendStoreRequest = function(presetNumber)
	-- Send the store message
	local message
	if isGm40() then
 		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x09, 0x00, 0x04, 0x50, 0x00, 0x7F, 0x26, 0xF7 } 
	elseif isBs200() then
 		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x0B, 0x00, 0x04, 0x50, 0x00, 0x7F, 0x28, 0xF7 } 
	else
 		message = {0xF0, 0x00, 0x20, 0x44, 0x00, 0x10, 0x00, 0x05, 0x00, 0x04, 0x50, 0x00, 0x7F, 0x2A, 0xF7 }
	end
	storeMessage = CtrlrMidiMessage(message)
	panel:sendMidiMessageNow (storeMessage)
	-- Send the patch number
	-- console("Patch number: "..presetNumber)
	local firstByte = 0xc0 + (getMidiOutChannel()-1)
	patchNumberMessage = CtrlrMidiMessage({firstByte, (presetNumber-1)})
	panel:sendMidiMessageNow (patchNumberMessage)
	blinkMidiOutLed()
end

writePresetToBuffer = function(preset,buffer,startIndex,withGlobalSoak)
	-- Gain
	local value = preset["gain"]
	writeIntToBuffer(value,buffer,startIndex);
	-- Bass
	value = preset["bass"]
	writeIntToBuffer(value,buffer,startIndex+2);
	-- Mid
	value = preset["mid"]
	writeIntToBuffer(value,buffer,startIndex+4);
	-- Volume
	value = preset["volume"]
	writeIntToBuffer(value,buffer,startIndex+6);
	-- Treble
	value = preset["treble"]
	writeIntToBuffer(value,buffer,startIndex+8);
	-- Resonance
	value = preset["resonance"]
	writeIntToBuffer(value,buffer,startIndex+10);
	-- Presence
	value = preset["presence"]
	writeIntToBuffer(value,buffer,startIndex+12);
	-- Reverb
	value = preset["reverb"]
	writeIntToBuffer(value,buffer,startIndex+14);
	-- Delay level
	value = preset["delayLevel"]
	writeIntToBuffer(value,buffer,startIndex+16);
	-- Delay Time
	value = preset["delayTime"]
	writeIntToBuffer(value,buffer,startIndex+18);
	-- Delay Feedback
	value = preset["delayFeedback"]
	writeIntToBuffer(value,buffer,startIndex+20);
	-- Mod intensity
	value = preset["modIntensity"]
	writeIntToBuffer(value,buffer,startIndex+22);
	-- Mod type
	value = preset["modType"]
	writeIntToBuffer(value,buffer,startIndex+24);

	-- Preamp channel
	value = preset["channelType"]
	local channelType = math.floor(value/42)
	-- Pream boost
	value = preset["channelBoost"]
	local channelBoost = math.floor(value/127)
	-- Fx loop
	value = preset["fxLoop"]
	local fxLoop = math.floor(value/127)
	-- Nois Gate
    value = preset["noiseGate"]
    local noiseGate = math.floor(value/127)
    if isBs200() then
		-- Noise Gate Level
		value = preset["noiseGateLevel"]
		writeIntToBuffer(value,buffer,startIndex+26);
		-- Sagging
		value = preset["sagging"]
		local sagging = math.floor((value/36)+0.5)
		-- Cab type
		value = preset["cabinetType"]
		local cabinetType = math.floor((value/36)+0.5)
		-- Mutes
	    value = preset["reverbStatus"]
		local reverbStatus = math.floor(value/127)
	    value = preset["modulationStatus"]
		local modulationStatus = math.floor(value/127)
	    value = preset["delayStatus"]
		local delayStatus = math.floor(value/127)
        -- Config 1/2
		local config2LByte = sagging + (cabinetType*8)
		local config1HByte = noiseGate
		local config1LByte = channelType + (channelBoost*4) + (fxLoop*8) + (reverbStatus*16) + (delayStatus*32) + (modulationStatus*64)
	    buffer[startIndex+29]=config2LByte
	    buffer[startIndex+30]=config1HByte
	    buffer[startIndex+31]=config1LByte
    else
		local qqByte
		local rrByte

	    -- Power soak
	    if withGlobalSoak then
		    value = globalPowerSoakValue
	    else
		    value = preset["powerSoak"]
	    end
	    local powerSoak = math.floor(value/31)

	    rrByte = channelType + (channelBoost*4) + (fxLoop*8) + (powerSoak*16)

	    -- Noise Gate
	    qqByte = noiseGate

	    buffer[startIndex+30]=qqByte
	    buffer[startIndex+31]=rrByte
    end
end

writeIntToBuffer = function(value,buffer,startIndex)
	local lsb = value % 128;
	local msb = math.floor(value / 128);
	buffer[startIndex]=msb;
	buffer[startIndex+1]=lsb;
end

