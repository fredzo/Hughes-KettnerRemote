-- Globals
animations = {}
animationDuration = 400
animationEndTime = 0
lastAnimationTimerCall = 0
ingoredVersionUpdate = nil

factoryPresetNamesGm36 =
{"Super Clean",
"Fat Clean",
"Bluesy Clean",
"Crunchy Clean",
"Clean Brett",
"Rhythn Crunch",
"Fat Crunch",
"Boosted Crunch",
"Low Gain Classic Lead",
"Boosted Classic Lead",
"Fat Classic Lead",
"High Gain Classic Lead",
"Classic Metal",
"High Gain Metal",
"Modern Metal",
"Deep Metal",
"Chorus Clean",
"Rotor Chorus Clean",
"Clean Flanger",
"Clean Phaser",
"Space Crunch 1",
"Space Crunch 2",
"Flanged Lead",
"World of Lead",
"Sixties Tremolo Crunch",
"British Tremolo Crunch",
"Shine on Like Crazy",
"Crunchy Flanger",
"Ultra Power Chord",
"Ultra Modulation",
"Small Ultra Deep",
"Ultra Deep Space",
"Dream Bell",
"Warm Cave",
"Funda Mental",
"Spirit",
"Fat Clean Drive (Single Coil)",
"Voxx Like  (Single Coil)",
"Country Boy 1 (Single Coil)",
"Country Boy 2 (Single Coil)",
"Running on the Moon (Single Coil)",
"You Too (Single Coil)",
"Volume Swell Pad (Single Coil)",
"Arpeggio Rick Chords (Single Coil)",
"My Tremolo",
"My Chorus",
"Funky phaser",
"Clean Flanger",
"Crunch!",
"Hot Crunch 1",
"Hot Crunch 2",
"Classic 2nd",
"Classic Lead",
"High Gain Solo 1",
"High Gain Solo 2",
"Ultra High Gain Solo",
"Modern Metal Rhythm",
"Modern Metal Lead",
"Paradise Clean",
"Paradise Rhythm",
"Paradise Lead",
"Black Hole Clean",
"Black Hole Weird",
"Bombtrack",
"Good Love",
"Love Solo",
"Modern Rock Rhythm",
"Modern Rock Lead"}

factoryPresetNamesGm40 =
{"Airey Clean",
"Dry Crunch",
"Rhythm Lead",
"Ultra Solo",
"Pumped Clean",
"Jim Crunch",
"Old Skool Lead",
"Luke Solo",
"Sound Of The Police",
"Chicken Slap",
"Comfortably Dump",
"Metalicious",
"Tremolo Solo",
"Chrunchy Bite",
"Jazzy Mumph",
"Deep Metal",
"Slowly Chorus Groove",
"The Truth In Crunch",
"Neck Pick Crunch No. 1",
"A 60s Classic Cloud",
"Lead By Dutch",
"Latin Rock Of The 70s",
"Fat Clean Drive",
"Voxx Like",
"Country Boy 1",
"Country Boy 2",
"Running on the Moon",
"You too",
"Volume Swell Pad",
"Arpeggio Rick Chords",
"My Tremolo",
"My Chorus",
"Funky Phaser",
"Clean Flanger",
"Crunch!",
"Hot Crunch 1",
"Hot Crunch 2",
"Classic 2nd",
"Classic Lead",
"High Gain Solo 1",
"High Gain Solo 2",
"Ultra High Gain Solo",
"Modern Metal Rhythm",
"Modern Metal Lead",
"Paradise Clean",
"Paradise Rhythm",
"Paradise Lead",
"Black Hole Clean",
"Black Hole Weird",
"Bombtrack",
"Good Love",
"Love Solo",
"Modern Rock Rhythm",
"Modern Rock Lead",
"Super Clean",
"Fat Clean",
"Bluesy Clean",
"Crunchy Clean",
"Clean Brett",
"Rhythm Crunch",
"Fat Crunch",
"Boosted Crunch",
"Low Gain Classic Lead",
"Boosted Classic Lead",
"Fat Classic Lead",
"High Gain Classic Lead",
"Classic Metal",
"High Gain Metal",
"Modern Metal",
"Deep Metal",
"Chorus Clean",
"Rotor Chorus Clean",
"Clean Flanger",
"Clean Phaser",
"Space Crunch 1",
"Space Crunch 2",
"Flanged Lead",
"World of Lead",
"Sixties Tremolo Clean",
"British Tremolo Crunch",
"Shine on like crazy",
"Crunchy Flanger",
"Ultra Power Chord",
"Ultra Modulation",
"Small Ultra Deep",
"Ultra Deep Space",
"Dream Bell",
"Warm Cave",
"Funda Mental",
"Free Spirit"}

factoryPresetNamesBs200 =
{"CLEAN",
"CRUNCH",
"LEAD",
"ULTRA",
"50´S OLD AMERICAN STYLE",
"60´S CRUNCH (USE CC PEDAL FOR GAIN)",
"CLASSIC AMERICAN TONE",
"MODERN AMERICAN CRUNCH",
"FRANKY CLEAN",
"MODERN CRUNCH",
"MODERN CRUNCH 2",
"POWER CRUNCH",
"LEAD BY DUTCH NO.1",
"CLASSIC LEAD",
"HEAVY LEAD",
"HEAVY LEAD 2",
"CLEAN SPHERE",
"ECHO PARTNER CLEAN",
"MID OF THE SEVENTIES",
"THE BEGINNING OF ROCK 'N' ROLL",
"SIXTIES SMALL CABINET",
"SIXTIES BIG CABINET",
"CARLOS LEAD",
"METALCORE 1",
"HANDRIX HI JOE INTRO",
"HANDRIX HI JOE SOLO",
"HANDRIX XOXY LADY RHYTHM",
"HANDRIX XOXY LADY SOLO",
"CLASSC BRITISH CRUNCH",
"MODERN BRITISH CRUNCH",
"METALCORE 2",
"METALCORE 3",
"MID CRUNCH 1",
"MID CRUNCH 2",
"RUNNING ON THE MOON",
"VOLUME SWELL PAD",
"ARPEGGIO RICK CHORDS",
"YOU TOO",
"MY TREMOLO",
"MY CHORUS",
"FUNKY PHASER",
"CLEAN FLANGER",
"SHINE ON LIKE CRAZY",
"LEAD BY DUTCH NO.2",
"COUNTRY BOY NO.1",
"COUNTRY BOY NO.2",
"LATIN ROCK OF THE 70´S",
"BOOSTED CRUNCH",
"DEATH METAL (EMG) NO.1",
"DEATH METAL (EMG) NO.2",
"DEATH METAL (EMG) NO.3",
"DEATH METAL (EMG) NO.4",
"CRAZY WINE",
"FAMOUS FOUR",
"SECOND SHINE",
"STICK IN THE HOLE",
"YYYYYYHAAAA",
"TEXAS SCREAM",
"WORK ZEN",
"INZENAME",
"CAT NAMED LOU",
"SO OR O?",
"YY POP",
"COME4PUMP",
"BASS GUITAR NO.1",
"BASS GUITAR NO.2",
"FOR ACOUSTIC GUITAR OVER FULL RANGE CAB 1",
"FOR ACOUSTIC GUITAR OVER FULL RANGE CAB 2",
"50´S OLD AMERICAN STYLE",
"60´S CRUNCH (USE CC pEDAL FOR GAIN)",
"CLASSIC AMERICAN TONE",
"MODERN AMERICAN CRUNCH",
"FRANKY CLEAN",
"MODERN CRUNCH",
"MODERN CRUNCH 2",
"POWER CRUNCH",
"LEAD BY DUTCH NO.1",
"CLASSIC LEAD",
"HEAVY LEAD",
"HEAVY LEAD 2",
"CLEAN SPHERE",
"ECHO PARTNER CLEAN",
"MID OF THE SEVENTIES",
"THE BEGINNING OF ROCK 'N' ROLL",
"SIXTIES SMALL CABINET",
"SIXTIES BIG CABINET",
"CARLOS LEAD",
"METALCORE 1",
"HANDRIX HI JOE INTRO",
"HANDRIX HI JOE SOLO",
"HANDRIX XOXY LADY RHYTHM",
"HANDRIX XOXY LADY SOLO",
"CLASSC BRITISH CRUNCH",
"MODERN BRITISH CRUNCH",
"METALCORE 2",
"METALCORE 3",
"MID CRUNCH 1",
"MID CRUNCH 2",
"RUNNING ON THE MOON",
"VOLUME SWELL PAD",
"ARPEGGIO RICK CHORDS",
"YOU TOO",
"MY TREMOLO",
"MY CHORUS",
"FUNKY PHASER",
"CLEAN FLANGER",
"SHINE ON LIKE CRAZY",
"LEAD BY DUTCH NO.2",
"COUNTRY BOY NO.1",
"COUNTRY BOY NO.2",
"LATIN ROCK OF THE 70´S",
"BOOSTED CRUNCH",
"DEATH METAL (EMG) NO.1",
"DEATH METAL (EMG) NO.2",
"DEATH METAL (EMG) NO.3",
"DEATH METAL (EMG) NO.4",
"CRAZY WINE",
"FAMOUS FOUR",
"SECOND SHINE",
"STICK IN THE HOLE",
"YYYYYYHAAAA",
"TEXAS SCREAM",
"WORK ZEN",
"INZENAME",
"CAT NAMED LOU",
"SO OR O?",
"YY POP",
"COME4PUMP"}

factoryPresetNames = factoryPresetNamesBs200

controllersGrandMeister = {
[1]="modIntensity",
[4]="delayTime",
[12]="modType",
[21]="bass",
[22]="mid",
[23]="treble",
[24]="resonance",
[25]="presence",
[27]="delayFeedback",
[28]="delayLevel",
[29]="reverb",
[30]="powerSoak",
[31]="channelType",
[55]="fxLoop",
[56]="gain",
[57]="volume",
[59]="sagging",
[62]="noiseGateLevel",
[63]="noiseGate",
[64]="channelBoost"
}

controllersBlackSpirit = {
[1]="modIntensity",
[4]="delayTime",
[12]="modType",
[21]="bass",
[22]="mid",
[23]="treble",
[24]="resonance",
[25]="presence",
[27]="delayFeedback",
[28]="delayLevel",
[29]="reverb",
[31]="channelType",
[52]="modulationStatus",
[53]="delayStatus",
[54]="reverbStatus",
[55]="fxLoop",
[56]="gain",
[57]="volume",
[58]="cabinetType",
[58]="sagging",
[62]="noiseGateLevel",
[63]="noiseGate",
[64]="channelBoost"
}

controllers = controllersBlackSpirit

-- Preset data
presets = {}
libraryPresets = {}
externalPresets = {}
ampPresets = {}
-- Presets to send
presetsToSend = nil
presetsToSendIndex = 0
presetsToSendSize = 0
uploadFinishedCallback = nil
-- Current Preset numbers
currentPresetNumber = 1
currentAmpPresetNumber = 1
currentLibraryPresetNumber = 1
-- System config data
omniMode=0
midiChannel=1
mutes=0x00
powerEqGlobal=0
powerSoakGlobal=0
globalPowerSoakValue=127 -- Default to 36W
cabinetTypeGlobal=0
midiLearn=0
speakerConnected=0
modified=0
fxAccess=0
globalResonance=0
globalPresence=0
globalCabinetType = 0

-- Edit buffer data
editBuffer = {}
originalBuffer = {}

-- Current library file
currentLibraryFile = nil

-- State
-- 0 = wait for config
-- 1 = wait for edit buffer
-- 2 = wait for all presets
-- 3 = idle
-- lastStateChangeTime = 0
state = 0

-- Connected state
connected = true
-- Synced state
synced = true
-- Library / Amp
isLibrary = true

libraryDirty = false
lastPresetDirty = false

ampType = "BS200"

firmwareVersion = "?"

-- Panel version
versionMajor = 0
versionMinor = 0
version = "?"

-- Compare mode management
presetChanged = false
compareMode = false
showOriginal = false

-- Library editor globals
libraryEditorBoxes = {}
librarySelectionStart = 1
librarySelectionEnd = 1
libraryCursorPosition = 1
libraryChanged = false
libraryClipboard = {}
libraryClipboardSourceIsLib = true
libraryClipboardStart = 0
libraryClipboardEnd = 0
libraryCliboardEmpty = true
libraryUndoContent = {}
libraryUndoEmpty = true
libraryUndoStart = 0
libraryListenPressed = false
libraryEditorPresets = {}
-- Current external file
currentExternalFile = nil
externalPresetsLoaded = false
libraryEditorExternal = false


--
-- Called when the panel has finished loading
--
initPanel = function()
	
	if currentLibraryFile == nil or currentLibraryFile == "" then
		-- Set default library file
		currentLibraryFile = File.getSpecialLocation(File.userHomeDirectory):getFullPathName().."/bs200/factory.bs200"
	end
		-- Init preset numbers
	currentPresetNumber = 1
	currentAmpPresetNumber = 1
	currentLibraryPresetNumber = 1
	-- Restore currentPresetNumber
	local modulator = panel:getModulator("presetStep")
	if modulator ~= nil then
		currentPresetNumber = sanitizePresetNumber(modulator:getValue())
	end
	-- Global power soak value
	local modulator = panel:getModulator("powerSoakMode")
	if modulator ~= nil then
		powerSoakGlobal = modulator:getValue()
	end
	-- Global cabinet type value
	local modulator = panel:getModulator("cabinetTypeMode")
	if modulator ~= nil then
		cabinetTypeGlobal = modulator:getValue()
	end
	-- Init presets
	initPresets()
	-- Hack to prevent sending preset dump on init : we mute preset combo change until timer triggers or connection is established
	mutePresetComboChange = true
	-- Init timers
	timer:setCallback(69, rotateTimerCallback)
	timer:setCallback(70, connectedTimerCallback)
	timer:setCallback(71, blinkMidiInLedTimerCallback)
	timer:setCallback(72, blinkMidiOutLedTimerCallback)
	timer:setCallback(73, checkForUpdateTimerCallback)
	timer:setCallback(74, syncedTimerCallback)
	-- Update modulators with current preset
	loadPreset(editBuffer,true)
	-- Make sure leds are off
	setLedModulatorValue("connectedLed",false)
	setLedModulatorValue("syncedLed",false)

	-- Init library editor 
	local currentListBoxName
	for i=1,32 do
		currentListBoxName = "bank"..i.."ListBox"
		libraryEditorBoxes[i]=panel:getComponent(currentListBoxName)
	end

	-- Init ui
	initUi()

	-- Init synced state
	setSynced(false)
	-- Arm connection timer
	setConnected(false)

	-- Start check for update timer
	timer:startTimer(73,2000)
	-- Read panel version
	readVersion()
end

function initPresets()
	ampPresets = loadAmpFromFile()
	libraryPresets = loadLibraryFromFile()
	-- current presets are library presets until we are connected
	presets = libraryPresets
	-- Point library editor to library presets
	libraryEditorPresets = libraryPresets
	setLibraryExternalToggle(libraryEditorExternal)
	initPresetCombo()
end

function initUi()
	-- Force library file name update
	libraryDirty = false
	setLibraryFileName(true)
	-- Init amp type
    updateAmpTypeSwitch()
	-- Init firmware version
	panel:getComponent("firmwareVersion"):setComponentText(firmwareVersion)
	-- Init power soak values
	setPowerSoakLabels()
end

function updateAmpTypeSwitch()
    local ampTypeSwitchValue
    if ampType == "GM36" then
        ampTypeSwitchValue = 0
    elseif ampType == "GM40" then
        ampTypeSwitchValue = 1
    else
        ampTypeSwitchValue = 2
    end
	panel:getModulator("ampTypeSwitch"):setValue(ampTypeSwitchValue,true,true)
    local ampTypeSwitchComponent = panel:getComponent("settingsLabels")
    if connected then
        ampTypeSwitchComponent:setEnabled(false)
    else
        ampTypeSwitchComponent:setEnabled(true)
    end
end


function updateSettingsLabel()
    local settingsText = panel:getComponent("settingsLabels"):getComponentText()
    local ampSwitchValue = panel:getModulator("ampTypeSwitch"):getValue()
    if ampSwitchValue == 2 then
        -- BS 200
        settingsText = settingsText:replace("Power Soak","Cabinet Type",false)
    else
        -- GrandMeisters
        settingsText = settingsText:replace("Cabinet Type","Power Soak",false)
    end
    panel:getComponent("settingsLabels"):setComponentText(settingsText)
end

initPresetCombo = function()
	local combo = getPresetCombo()
	if combo ~= nil then
		-- Amp mode => fill all 128 presets
		combo = modulator:getOwnedComboBox()
		combo:clear(0)
		if isLibrary then
			local size = 1
			-- Library mode => only setup available presets
			local presetName
			for i,v in ipairs(presets) do
				if v["name"] ~= nil then
					presetName = v["name"]
				else
					presetName = "Preset "..size
				end
				combo:addItem(""..i.." - "..presetName,size)
				size = size+1
			end
		else
			local size = 1
			while size <= 128 do
				local presetName
				if presets[size] == nil then
					if factoryPresetNames[size] ~= nil then
						presetName = factoryPresetNames[size]
					else
						presetName = "Preset "..size
					end
				else
					presetName = presets[size]["name"]
				end
				combo:addItem(""..size.." - "..presetName,size)
				size = size+1
			end
		end
	else
		console("Modulator not found for presetCombo")
	end
	-- Update preset
	setPresetNumber(currentPresetNumber,true)
end

getPresetCombo = function()
	modulator = panel:getComboComponent("presetCombo")
	if modulator ~= nil then
		combo = modulator:getOwnedComboBox()
		return combo
	else
		return nil
	end
end

function connectedTimerCallback (timerId)
	--console("timer id: "..timerId.." step: "..timerStep)
	if timerId ~= 70 then
		return
	end
	-- Hack to prevent sending preset dump on init : we mute preset combo change until timer triggers or connection is established
	mutePresetComboChange = false
	if not connected then
		--sendIdRequest()
		--sendEditBufferRequest()
		sendSystemConfigRequest()
	end
end

firstSyncedTimerCall = true
function syncedTimerCallback (timerId)
	--console("timer id: "..timerId.." step: "..timerStep)
	if timerId ~= 74 then
		return
	end
	if firstSyncedTimerCall then
		firstSyncedTimerCall = false
	else
		sendAllPresetsRequest()
		timer:stopTimer(timerId)
		firstSyncedTimerCall = true
	end
end

function readVersion()
	versionMajor = panel:getPropertyInt("panelVersionMajor")
	versionMinor = panel:getPropertyInt("panelVersionMinor")
	version = versionMajor.."."..versionMinor
	panel:getComponent("versionLabel"):setComponentText("Version "..version)
end

function checkForUpdateTimerCallback (timerId)
	--console("timer id: "..timerId.." step: "..timerStep)
	if timerId ~= 73 then
		return
	end
	-- Only check once per session
	timer:stopTimer(timerId)
	-- Call update url
	local url = URL("http://ctrlr.org/?ddownload=37209")
	latestVersionString = url:readEntireTextStream(false)
	if latestVersionString ~= nil then
		local latestVersion = tonumber(latestVersionString)
		if latestVersion ~= nil then
			local versionMajor = panel:getPropertyInt("panelVersionMajor")
			local versionMinor = panel:getPropertyInt("panelVersionMinor")
			local version = versionMajor.."."..versionMinor
			local currentVersion = tonumber(version)
			--console("Current version = "..currentVersion)
			--console("Latest version = "..latestVersion)
			if latestVersion > currentVersion then
				-- Check if this version has been marked ignored
				if latestVersionString == ingoredVersionUpdate then
					return
				end
				-- Ask user
				updateWindow = AlertWindow("A new version is available !", "Go to download page ?", AlertWindow.QuestionIcon)
				updateWindow:addButton("OK", 1, KeyPress(KeyPress.returnKey), KeyPress())
				updateWindow:addButton("Later", 0, KeyPress(KeyPress.escapeKey), KeyPress())
				updateWindow:addButton("Never", 2, KeyPress(), KeyPress())
				updateWindow:setModalHandler(updateWindowCallback)
			
				--  Never let Lua delete this window (3rd parameter), enter modal state
				updateWindow:runModalLoop()
			end		end
	end
end

function updateWindowCallback(result, window)
	if panel:getBootstrapState() or panel:getRestoreState() then
		return
	end
	window:setVisible (false)
	--console("\n\nwindowCallback result="..result)
	if result == 1 then
		local url = URL("http://ctrlr.org/hughes-kettner-grandmeister-36/")
		url:launchInDefaultBrowser()
	elseif result == 2 then
		-- TODO Update last checked version
		ingoredVersionUpdate = latestVersionString
	end
end

function notMouseOver(mod)
	local comp = mod:getComponent()
	local childComp = comp:getChildComponent(0)
	--what(comp)
	--what(childComp)
	--if (mod == nil or comp == nil or childComp == nil or (not childComp:isMouseOver(true) and not comp:isMouseOver(true))) then
	--	console("Is mouse over false")
	--else
	--	console("Is mouse over true")
	--end
	return (mod == nil or comp == nil or childComp == nil or (not childComp:isMouseOver(true)))
end


function switchToEditorTab()
	switchToTab(0)
	setSettingsVisible(true)
end

function switchToLibraryEditorTab()
	switchToTab(1)
	setSettingsVisible(false)
	setLibraryEditorPresets()
	initLibraryEditor()
end

function switchToProgressTab()
	switchToTab(2)
	setSettingsVisible(false)
end

function switchToSettingsTab()
    updateSettingsLabel()
	switchToTab(3)
	setSettingsVisible(false)
end

function switchToHelpTab()
	switchToTab(4)
	setSettingsVisible(false)
end

function switchToTab(value)
	panel:getComponent("tabs"):setProperty ("uiTabsCurrentTab", value, false)
end

function setSettingsVisible(visible)
	panel:getComponent("settings"):setVisible(visible)
	panel:getComponent("libraryEditor"):setVisible(visible)
end

function initPreset(presetNumber)
	local preset = {}
	preset["number"]=presetNumber
	if factoryPresetNames[presetNumber] ~= nil then
		preset["name"] = factoryPresetNames[presetNumber]
	else
		preset["name"] = "Preset "..presetNumber
	end
	for kk, vv in pairs(controllers) do
		preset[vv]=0
	end
	return preset
end

function sanitizePresetNumber(presetNumber)
	if not (type(presetNumber) == 'number') then
		presetNumber = tonumber(presetNumber)
	end
	if presetNumber == nil or presetNumber < 1 or presetNumber > 128 then
		presetNumber = 1
	end
	return presetNumber
end

function initLibraryEditor()
	-- Init list box labels
	local currentPresetIndex = 1
	local currentListBoxContent
	for i,currentListBox in ipairs(libraryEditorBoxes) do
		currentListBoxContent = ""
		for j=1,4 do
			currentListBoxContent = currentListBoxContent..libraryEditorPresets[currentPresetIndex]["name"]
			if j < 4 then
				currentListBoxContent = currentListBoxContent.."\n"
			end
			currentPresetIndex = currentPresetIndex + 1
		end
		currentListBox:setProperty ("uiListBoxContent", currentListBoxContent, false)
	end
	updateLibraryEditorSelection()
end

function updateLibraryEditorSelection()
	local currentSelectionIndex = 1
	for i,currentListBox in ipairs(libraryEditorBoxes) do
		currentListBox:deselectAllRows()
		for j=0,3 do
			if ((currentSelectionIndex >= librarySelectionStart) and (currentSelectionIndex <= librarySelectionEnd)) then
				-- grow selection
				currentListBox:selectRow(j,true,false)
			end
			currentSelectionIndex = currentSelectionIndex + 1
		end
	end
	updateLibraryControllers()
	updateLibraryClipboard()
	updateExternalModeDisplay()
	giveFocusToKeyLogger()
end

function updateLibraryControllers()
	if librarySelectionStart == librarySelectionEnd then
		-- Single selection
		local currentPreset = libraryEditorPresets[librarySelectionStart]
		if currentPreset ~= nil then
			-- Set name
			local component = panel:getComponent("libraryPresetName")
			if component ~= nil then
				component:setComponentText(currentPreset["name"])
				component:setPropertyString("uiLabelTextColour","FF409FCB")
				if libraryEditorExternal then
					component:setPropertyString("uiLabelEditOnSingleClick","false")
				else
					component:setPropertyString("uiLabelEditOnSingleClick","true")
				end
			end
			local modulator
			for k,v in pairs(controllers) do
				modulator = panel:getModulator("library-"..v)
				if modulator ~= nil then
					modulator:setValue(currentPreset[v],true,true)
				end
			end
		end
	else
		-- Multiple selection
		-- Set name
		local component = panel:getComponent("libraryPresetName")
		if component ~= nil then
			local selectionText
			if libraryEditorExternal then
				selectionText="Presets "..librarySelectionStart.." - "..librarySelectionEnd
				component:setPropertyString("uiLabelTextColour","FF409FCB")
			else
				selectionText="Bulk edit "..librarySelectionStart.." - "..librarySelectionEnd
				component:setPropertyString("uiLabelTextColour","FFFF0000")
			end
			component:setComponentText(selectionText)
			component:setPropertyString("uiLabelEditOnSingleClick","false")
		end
		for k,v in pairs(controllers) do
			-- See if value is the same for all selection
			local currentValue = libraryEditorPresets[librarySelectionStart][v]
			local allSame = true
			for i=(librarySelectionStart+1),librarySelectionEnd do
				if libraryEditorPresets[i][v]~=currentValue then
					allSame = false
					break
				end
			end

			local modulator = panel:getModulator("library-"..v)
			if modulator ~= nil then
				if allSame then
					modulator:setValue(currentValue,true,true)
				else
					modulator:setValue(0,true,true)
				end
				component = modulator:getComponent()
				-- Disable for external file
				if component ~= nil then
					component:setEnabled(not libraryEditorExternal)
				end
			end
		end
	end
	-- Listen button state
	local component = panel:getComponent("libraryEditorListen")
	if component ~= nil then
		component:setEnabled(connected and (librarySelectionStart == librarySelectionEnd))
	end
end

function updateLibraryClipboard()
	-- Set clipboard content label
	local component = panel:getComponent("libraryClipboardContent")
	if component ~= nil then
		local libraryClipboardLabel
		if libraryCliboardEmpty then
			libraryClipboardLabel = "Empty"
		else
			if libraryClipboardSourceIsLib then
				libraryClipboardLabel = "Library "
			else
				libraryClipboardLabel = "Extern "
			end
			libraryClipboardLabel = libraryClipboardLabel..libraryClipboardStart
			if libraryClipboardEnd > libraryClipboardStart then
				libraryClipboardLabel = libraryClipboardLabel.." - "..libraryClipboardEnd
			else
				libraryClipboardLabel = libraryClipboardLabel.." : "..libraryClipboard[1]["name"]
			end
		end
		component:setComponentText(libraryClipboardLabel)
	end
	-- Enable / disable paste button
	local component = panel:getComponent("libraryEditorPaste")
	if component ~= nil then
		component:setEnabled((not libraryCliboardEmpty) and (librarySelectionStart == librarySelectionEnd) and (not libraryEditorExternal))
	end
	-- Enable / disable undo button
	local component = panel:getComponent("libraryEditorUndo")
	if component ~= nil then
		component:setEnabled(not libraryUndoEmpty and not libraryEditorExternal)
	end
end

function updateExternalModeDisplay()
	-- Enable / disable edit buttons
	local component = panel:getComponent("libraryEditorDec4")
	if component ~= nil then
		component:setEnabled(not libraryEditorExternal)
	end
	component = panel:getComponent("libraryEditorDec1")
	if component ~= nil then
		component:setEnabled(not libraryEditorExternal)
	end
	component = panel:getComponent("libraryEditorInc1")
	if component ~= nil then
		component:setEnabled(not libraryEditorExternal)
	end
	component = panel:getComponent("libraryEditorInc4")
	if component ~= nil then
		component:setEnabled(not libraryEditorExternal)
	end
	-- Enable / disable toggle
	component = panel:getComponent("libraryExternalToggle")
	if component ~= nil then
		component:setEnabled(externalPresetsLoaded)
	end
	component = panel:getComponent("libraryExternalToggleLabel")
	if component ~= nil then
		component:setEnabled(externalPresetsLoaded)
	end
	-- Set file name
	component = panel:getComponent("libraryExternalFile")
	if component ~= nil then
		local externalFileName
		if externalPresetsLoaded then
			externalFileName = currentExternalFile
		else
			externalFileName = "<?>"
		end
		component:setComponentText(externalFileName)
	end
end

function giveFocusToKeyLogger()
	panel:getComponent("keyLogger"):grabKeyboardFocus()
end

function isGm40()
	if ampType == "GM40" then
 		return true
	else
 		return false
	end
end

function isBs200()
	if ampType == "BS200" then
 		return true
	else
 		return false
	end
end

function getAmpTypeExtension()
	if ampType == "GM40" then
		return "*.gm40"
	elseif ampType == "BS200" then
		return "*.bs200"
	else
		return "*.gm36"
	end
end

function switchAmpType(newAmpType)
	if newAmpType ~= ampType then
        local oldAmpWasBs200 = isBs200()
		ampType = newAmpType
		updateAmpTypeSwitch()
		-- Update factory preset names
		local originalLibraryFile = currentLibraryFile
		if isGm40() then
			factoryPresetNames = factoryPresetNamesGm40
            controllers = controllersGrandMeister
			currentLibraryFile = string.gsub(currentLibraryFile,"/gm36/factory%.gm36","/gm40/factory.gm40")
			currentLibraryFile = string.gsub(currentLibraryFile,"/bs200/factory%.bs200","/gm40/factory.gm40")
		elseif isBs200() then
			factoryPresetNames = factoryPresetNamesBs200
            controllers = controllersBlackSpirit
			currentLibraryFile = string.gsub(currentLibraryFile,"/gm36/factory%.gm36","/bs200/factory.bs200")
			currentLibraryFile = string.gsub(currentLibraryFile,"/gm40/factory%.gm40","/bs200/factory.bs200")
		else
			factoryPresetNames = factoryPresetNamesGm36
            controllers = controllersGrandMeister
			currentLibraryFile = string.gsub(currentLibraryFile,"/gm40/factory%.gm40","/gm36/factory.gm36")
			currentLibraryFile = string.gsub(currentLibraryFile,"/bs200/factory%.bs200","/gm36/factory.gm36")
		end
		-- Update library if needed
		--console("Current "..currentLibraryFile.." original "..originalLibraryFile)
		if currentLibraryFile ~= originalLibraryFile then
			libraryPresets = loadLibraryFromFile()
			ampPresets = loadAmpFromFile()
            if isLibrary then
                presets = libraryPresets
            else
                presets = ampPresets
            end
			setLibraryFileName()
		end
		-- Update combo
		initPresetCombo()
		-- Update Power Soak labels
		setPowerSoakLabels()
        -- If we change from BS 200 to GrandMeister or viceversa we need to update UI
        if (oldAmpWasBs200 or isBs200()) then
            updateUiForAmp()
        end
	end
end

function updateUiForAmp()
    local noiseGateLevelLabelComp = panel:getComponent("noiseGateLevelLabel")
    local noiseGateLevelComp = panel:getComponent("noiseGateLevel")
    local noiseGateStatusComp = panel:getComponent("noiseGateStatus")
    if isBs200() then
        noiseGateLevelLabelComp:setVisible(true)
        noiseGateLevelComp:setVisible(true)
        noiseGateStatusComp:setPropertyString("componentRectangle","2 2 35 35")
    else
        noiseGateLevelLabelComp:setVisible(false)
        noiseGateLevelComp:setVisible(false)
        noiseGateStatusComp:setPropertyString("componentRectangle","32 48 35 35")
    end
end

function setPowerSoakLabels()
	if isGm40() then
		panel:getComponent("powerSoakHalf"):setComponentText("20W")
		panel:getComponent("powerSoakFull"):setComponentText("40W")
	else
		panel:getComponent("powerSoakHalf"):setComponentText("18W")
		panel:getComponent("powerSoakFull"):setComponentText("36W")
	end
end