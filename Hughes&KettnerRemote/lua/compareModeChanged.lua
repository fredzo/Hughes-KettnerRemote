--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
compareModeChanged = function(--[[ CtrlrModulator --]] mod, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(mod) then
		return
	end
	if value == 1 then
		showOriginal = false
	else
		showOriginal = true
	end
	console("Set compare mode : "..value)
	setCompareMode(true)
	if presetChanged then
		if showOriginal then
			sendOriginalBufferDump()
		else
			sendEditBufferDump()
		end
	end
end

function setModified(modified)
	if modified then
		panel:getModulator("compareSwitch"):setValue(1,true,true)
		presetChanged = true
	else
		panel:getModulator("compareSwitch"):setValue(0,true,true)
		presetChanged = false
	end
end

function setCompareMode(compare)
	if compare then
		compareMode = true
		showCompare()
	else
		compareMode = false
	end
end

function showCompare()
	-- Gain
	local editedValue = editBuffer["gain"]
	local originalValue = originalBuffer["gain"]
	local value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setKknobModulatorValue("channelGain",value,false,true,true)
	end
	-- Bass
	editedValue = editBuffer["bass"]
	originalValue = originalBuffer["bass"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setKknobModulatorValue("preampBass",value,false,true,true)
	end
	-- Mid
	editedValue = editBuffer["mid"]
	originalValue = originalBuffer["mid"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setKknobModulatorValue("preampMid",value,false,true,true)
	end
	-- Volume
	editedValue = editBuffer["volume"]
	originalValue = originalBuffer["volume"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setKknobModulatorValue("channelVolume",value,false,true,true)
	end
	-- Treble
	editedValue = editBuffer["treble"]
	originalValue = originalBuffer["treble"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setKknobModulatorValue("preampTreble",value,false,true,true)
	end
	-- Power EQ
	if not (powerEqGlobal == 1) then
		-- Resonance
		editedValue = editBuffer["resonance"]
		originalValue = originalBuffer["resonance"]
		value = getCompareValue(editedValue,originalValue)
		if editedValue ~= originalValue then
			setKknobModulatorValue("powerResonance",value,false,true,true)
		end
		-- Presence
		editedValue = editBuffer["presence"]
		originalValue = originalBuffer["presence"]
		value = getCompareValue(editedValue,originalValue)
		if editedValue ~= originalValue then
			setKknobModulatorValue("powerPresence",value,false,true,true)
		end
	end
	-- Reverb
	editedValue = editBuffer["reverb"]
	originalValue = originalBuffer["reverb"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setKknobModulatorValue("reverbLevel",value,false,true,true)
	end
	-- Delay level
	editedValue = editBuffer["delayLevel"]
	originalValue = originalBuffer["delayLevel"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setKknobModulatorValue("delayLevel",value,false,true,true)
	end
	-- Delay Time
	editedValue = editBuffer["delayTime"]
	originalValue = originalBuffer["delayTime"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		panel:getComponent("delayTime"):setPropertyString("uiImageSliderResource","knob-red")
		if not connected then
			setDelayTime(value,true,true,false,true)
		end
	end
	-- Delay Feedback
	editedValue = editBuffer["delayFeedback"]
	originalValue = originalBuffer["delayFeedback"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setKknobModulatorValue("delayFeedback",value,false,true,true)
	end
	-- Mod intensity
	editedValue = editBuffer["modIntensity"]
	originalValue = originalBuffer["modIntensity"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setKknobModulatorValue("modulationIntensity",value,false,true,true)
	end
	-- Mod rate / type
	editedValue = editBuffer["modType"]
	originalValue = originalBuffer["modType"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		-- Rate
		local editedRate = (editedValue % 64)
		local originalRate = (originalValue % 64)
		if editedRate ~= originalRate then
			panel:getComponent("modulationRate"):setPropertyString("uiImageSliderResource","knob-red")
		end
		-- Type
		local editedType = math.floor(editedValue / 64)
		local originalType = math.floor(originalValue / 64)
		if editedType ~= originalType then
			panel:getComponent("modulationType"):setPropertyString("uiImageSliderResource","rotary-red")
		end
		if not connected then
			setModulation(value,false,true)
		end
	end
	-- Preamp channel
	editedValue = editBuffer["channelType"]
	originalValue = originalBuffer["channelType"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		panel:getComponent("channelType"):setPropertyString("uiImageSliderResource","rotary-red")
		if not connected then
			setModulatorValue("channelType",value,false,false)
		end
	end
	-- Pream boost
	editedValue = editBuffer["channelBoost"]
	originalValue = originalBuffer["channelBoost"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setRedLedModulatorValue("channelBoost",value,true)
	end
	-- Fx loop
	editedValue = editBuffer["fxLoop"]
	originalValue = originalBuffer["fxLoop"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setBlueLedModulatorValue("fxLoopStatus",value,true)
	end
    if isBs200() then
        -- TODO Cab type
		-- Noise gate level
		editedValue = editBuffer["noiseGateLevel"]
		originalValue = originalBuffer["noiseGateLevel"]
		value = getCompareValue(editedValue,originalValue)
		if editedValue ~= originalValue then
			setKknobModulatorValue("noiseGateLevel",value,false,true,true)
		end
		-- Sagging
		editedValue = editBuffer["sagging"]
		originalValue = originalBuffer["sagging"]
		value = getCompareValue(editedValue,originalValue)
		if editedValue ~= originalValue then
			setKknobModulatorValue("sagging",value,false,true,true)
		end
		-- Reverb satus
		editedValue = editBuffer["reverbStatus"]
		originalValue = originalBuffer["reverbStatus"]
		value = getCompareValue(editedValue,originalValue)
		if editedValue ~= originalValue then
			setBlueLedModulatorValue("reverbStatus",value,true)
		end
		-- Delay satus
		editedValue = editBuffer["delayStatus"]
		originalValue = originalBuffer["delayStatus"]
		value = getCompareValue(editedValue,originalValue)
		if editedValue ~= originalValue then
			setBlueLedModulatorValue("delayStatus",value,true)
		end
		-- Modulation satus
		editedValue = editBuffer["modulationStatus"]
		originalValue = originalBuffer["modulationStatus"]
		value = getCompareValue(editedValue,originalValue)
		if editedValue ~= originalValue then
			setBlueLedModulatorValue("modulationStatus",value,true)
		end
    else
	    -- Power soak
	    if (not isLibrary and not isGm40()) or not (powerSoakGlobal == 1) then
		    editedValue = editBuffer["powerSoak"]
		    originalValue = originalBuffer["powerSoak"]
		    value = getCompareValue(editedValue,originalValue)
		    if editedValue ~= originalValue then
			    panel:getComponent("powerSoak"):setPropertyString("uiSliderTrackColour","FF7F0D13")
			    if not connected then
				    setModulatorValue("powerSoak",value,false,false)
			    end
		    end
	    end
    end
	-- Noise Gate
	editedValue = editBuffer["noiseGate"]
	originalValue = originalBuffer["noiseGate"]
	value = getCompareValue(editedValue,originalValue)
	if editedValue ~= originalValue then
		setBlueLedModulatorValue("noiseGateStatus",value,true)
	end
end

function getCompareValue(editedValue,originalValue)
	if showOriginal then
		return originalValue
	else
		return editedValue
	end
end

function hideCompare()
	-- Gain
	panel:getComponent("channelGain"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Bass
	panel:getComponent("preampBass"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Mid
	panel:getComponent("preampMid"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Volume
	panel:getComponent("channelVolume"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Treble
	panel:getComponent("preampTreble"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Resonance
	panel:getComponent("powerResonance"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Presence
	panel:getComponent("powerPresence"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Reverb
	panel:getComponent("reverbLevel"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Delay level
	panel:getComponent("delayLevel"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Delay Time
	panel:getComponent("delayTime"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Delay Feedback
	panel:getComponent("delayFeedback"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Mod intensity
	panel:getComponent("modulationIntensity"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Mod type
	panel:getComponent("modulationType"):setPropertyString("uiImageSliderResource","rotary")
	panel:getComponent("modulationRate"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Preamp channel
	panel:getComponent("channelType"):setPropertyString("uiImageSliderResource","rotary")
	-- Pream boost
	panel:getComponent("channelBoost"):setPropertyString("uiImageButtonResource","led-button-red")
	-- Fx loop
	panel:getComponent("fxLoopStatus"):setPropertyString("uiImageButtonResource","led-button-blue")
	-- Power soak
	panel:getComponent("powerSoak"):setPropertyString("uiSliderTrackColour","FF409FCB")
	-- Sagging
	panel:getComponent("sagging"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Noise gate level
	panel:getComponent("noiseGateLevel"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Cabinet type
	-- TODO panel:getComponent("cabinetType"):setPropertyString("uiImageSliderResource","knob-blue")
	-- Reverb led
	panel:getComponent("reverbStatus"):setPropertyString("uiImageButtonResource","led-button-blue")
	-- Delay led
	panel:getComponent("delayStatus"):setPropertyString("uiImageButtonResource","led-button-blue")
	-- Modulation led
	panel:getComponent("modulationStatus"):setPropertyString("uiImageButtonResource","led-button-blue")
	-- Noise Gate
	panel:getComponent("noiseGateStatus"):setPropertyString("uiImageButtonResource","led-button-blue")
	-- Disable compare
	compareMode = false
	-- Restore original switch
	setModified(false)
end

function highlight(paramName)
	if paramName == "gain" then
		panel:getComponent("channelGain"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "bass" then
		panel:getComponent("preampBass"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "mid" then
		panel:getComponent("preampMid"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "volume" then
		panel:getComponent("channelVolume"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "treble" then
		panel:getComponent("preampTreble"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "resonance" then
		panel:getComponent("powerResonance"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "presence" then
		panel:getComponent("powerPresence"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "reverb" then
		panel:getComponent("reverbLevel"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "delayLevel" then
		panel:getComponent("delayLevel"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "delayTime" then
		panel:getComponent("delayTime"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "delayFeedback" then
		panel:getComponent("delayFeedback"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "modIntensity" then
		panel:getComponent("modulationIntensity"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "modTypeKnob" then
		panel:getComponent("modulationType"):setPropertyString("uiImageSliderResource","rotary-red")
	elseif paramName == "modRateKnob" then
		panel:getComponent("modulationRate"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "channelType" then
		panel:getComponent("channelType"):setPropertyString("uiImageSliderResource","rotary-red")
	elseif paramName == "channelBoost" then
		panel:getComponent("channelBoost"):setPropertyString("uiImageButtonResource","led-button-red-red")
	elseif paramName == "fxLoop" then
		panel:getComponent("fxLoopStatus"):setPropertyString("uiImageButtonResource","led-button-blue-red")
	elseif paramName == "powerSoak" then
		if not isLibrary or not (powerSoakGlobal == 1) then
			panel:getComponent("powerSoak"):setPropertyString("uiSliderTrackColour","FF7F0D13")
		end
	elseif paramName == "reverbStatus" then
		panel:getComponent("reverbStatus"):setPropertyString("uiImageButtonResource","led-button-blue-red")
	elseif paramName == "delayStatus" then
		panel:getComponent("delayStatus"):setPropertyString("uiImageButtonResource","led-button-blue-red")
	elseif paramName == "modulationStatus" then
		panel:getComponent("modulationStatus"):setPropertyString("uiImageButtonResource","led-button-blue-red")
	elseif paramName == "sagging" then
		panel:getComponent("sagging"):setPropertyString("uiImageSliderResource","knob-red")
	elseif paramName == "noiseGateLevel" then
		panel:getComponent("noiseGateLevel"):setPropertyString("uiImageSliderResource","knob-red")
    -- TODO cab type
	elseif paramName == "noiseGate" then
		panel:getComponent("noiseGateStatus"):setPropertyString("uiImageButtonResource","led-button-blue-red")
	end
end

function setKknobModulatorValue(name,value,sendMidi,animate,red)
	if red then
		panel:getComponent(name):setPropertyString("uiImageSliderResource","knob-red")
	else
		panel:getComponent(name):setPropertyString("uiImageSliderResource","knob-blue")
	end
	if not connected then
		setModulatorValue(name,value,sendMidi,animate)
	end
end

function setRedLedModulatorValue(name,value,red)
	if red then
		panel:getComponent(name):setPropertyString("uiImageButtonResource","led-button-red-red")
	else
		panel:getComponent(name):setPropertyString("uiImageButtonResource","led-button-red")
	end
	if not connected then
		setStatusModulatorValue(name,value)
	end
end

function setBlueLedModulatorValue(name,value,red)
	if red then
		panel:getComponent(name):setPropertyString("uiImageButtonResource","led-button-blue-red")
	else
		panel:getComponent(name):setPropertyString("uiImageButtonResource","led-button-blue")
	end
	if not connected then
		setStatusModulatorValue(name,value)
	end
end