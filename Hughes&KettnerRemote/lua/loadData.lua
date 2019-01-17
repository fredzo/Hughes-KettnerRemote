--
-- Called when data is restored
--
loadData = function(stateData)
	local value = stateData:getProperty("currentPresetNumber")
	if value ~= nil and value ~= "" then
		currentPresetNumber = sanitizePresetNumber(value)
	end
	value = stateData:getProperty("ingoredVersionUpdate")
	if value ~= nil and value ~= "" then
		ingoredVersionUpdate = value
	end
	local value = stateData:getProperty("globalPowerSoak")
	if value ~= nil and value ~= "" then
		globalPowerSoakValue = tonumber(value)
	end

	currentLibraryFile = stateData:getProperty("currentLibraryFile")
	currentExternalFile = stateData:getProperty("currentLibraryFile")
	-- Restore ampType if available
	local value = stateData:getProperty("ampType")
	if value ~= nil and value ~= "" then
		ampType = value
	end
	--loadFromFile(presets)
	
	-- Init presets and ui again now that we have restored data (we need to do it twice since load data is not called on first launch
	initPresets()
	initUi()
end

loadAmpFromFile = function()
	if isGm40() then
		return loadFromFile(File.getSpecialLocation(File.userHomeDirectory):getFullPathName().."/gm40/amp.store",false)
	else
		return loadFromFile(File.getSpecialLocation(File.userHomeDirectory):getFullPathName().."/gm36/amp.store",false)
	end
end

loadLibraryFromFile = function()
	return loadFromFile(currentLibraryFile,true)
end

loadFromFile = function(path,saveIfBinary)
	local data
	local isBinary = false
	local file = File(path)
	local shouldSave = false
    local isBlackSpirit = string.ends(path,".bsmemory")
	if file:exists() then
		if string.ends(path,".gm36memory") or string.ends(path,".gm40memory") or isBlackSpirit then
			data = MemoryBlock(file:getSize())
			file:loadFileAsData(data)
			isBinary = true
		else
			-- Load from default location
			data = file:loadFileAsString()
		end
	else
		-- Load factory
		local factoryResource
		if isGm40() then
			factoryResource = resources:getResource("factory40")
		else
			factoryResource = resources:getResource("factory")
		end
		data = factoryResource:getFile():loadFileAsString()
		shouldSave = true
	end
	local result
	if isBinary then
		result = loadFromBinary(data,isBlackSpirit)
		if ((result ~= nil) and saveIfBinary) then
			-- Binary is only for library
			currentLibraryFile = string.gsub(currentLibraryFile,"%.gm36memory",".gm36")
			currentLibraryFile = string.gsub(currentLibraryFile,"%.gm40memory",".gm40")
			currentLibraryFile = string.gsub(currentLibraryFile,"%.bsmemory",".bs200")
			savePresetsToFile(currentLibraryFile,result)
			libraryDirty = false
			lastPresetDirty = false
			setLibraryFileName()
		end
	else
		if data:starts("{") then
			result = loadFromJSon(data)
		else
 			result = loadFromText(data)
		end
	end
	if shouldSave then
		savePresetsToFile(path,result)
	end
	return result
end

loadFromText = function(data)
	local myPresets = {}
	--console(data)
	local myPreset = nil
	local myPresetNumnber = nil
	for line in data:gmatch("[^\r\n]+") do 
		--console("Processing line: "..line)
		if line:starts("[preset]") then
			--console("Found preset !")
			if myPreset ~= nil and myPresetNumber ~= nil then
				--console("Stored preset "..myPresetNumber.." name = "..myPresets[myPresetNumber]["name"])
				myPresets[myPresetNumber]=myPreset
			end
			myPreset = {}
			myPresetNumber = nil
		elseif line:starts("#") then
			-- Comment => ignore
		elseif myPreset ~= nil then
			-- Split with "="
			local kvp = line:split("=")
			local key = kvp[1]
			local value = kvp[2]
			if key ~= nil and value ~= nil then
			--console("Kvp : "..key.." = "..value)
				if key == "name" then
					myPreset[key]=value
				else
					-- For backward compatiblity..
					if key == "treeble" then
						key = "treble"
					end
					myPreset[key]=tonumber(value)
					if key == "number" then
						myPresetNumber = tonumber(value)
					end
				end
			end
		end
	end
	if myPreset ~= nil and myPresetNumber ~= nil then
	--	console("Storing preset "..myPresetNumber)
		myPresets[myPresetNumber]=myPreset
	end
	-- Fill in the blanks
	for i=1,128 do
		if myPresets[i] == nil then
			myPresets[i] = initPreset(i)
		end
	end
	return myPresets
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string:split(sep)
	local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function copyPresets(t)
	if t == nil then
		return nil
	end
	local u = { }
	for k, v in pairs(t) do 
		u[k] = copyPreset(v) 
	end
	return setmetatable(u, getmetatable(t))
end

function copyPreset(t)
	if t == nil then
		return nil
	end
	local u = { }
	for k, v in pairs(t) do 
		u[k] = v 
	end
	return setmetatable(u, getmetatable(t))
end

function setLibraryFileName(force)
	if currentLibraryFile ~= nil then
		local component = panel:getComponent("libraryFileName")
		if component ~= nil then
			local value = currentLibraryFile:gsub("\\","/")
			if libraryDirty and not force then
				value = value.." (*)"
			end
			component:setComponentText(value)
		else
	   		console("Modulator not found: libraryFileName")
		end
	end
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

-- Load bp list code

offsetTable = {}
offsetSize = 0
objectRefSize = 0
numObjects = 0
topObject = 0
offsetTableOffset = 0


function loadFromBinary(data,isBlackSpirit)
	local magic = data:getRange(0,8)
	local magicString = magic:toString()
	-- console("Magic :"..magicString)
	if not string.starts(magicString,"bplist") then
		return nil
	end

	local myPresets = {}
	local myPreset = nil
	local myPresetNumnber = nil

    -- trailer is last 32 bytes of data
	local trailer = data:getRange(data:getSize()-32,32)

	-- console("trailer "..trailer:toHexString(2))

	offsetTable = {}
    offsetSize = extractByte(trailer,6)
    objectRefSize = extractByte(trailer, 7)
    numObjects = extractLong(trailer,8)
    topObject = extractLong(trailer,16)
    offsetTableOffset = extractLong(trailer,24)

	--console("offsetSize = "..offsetSize)
	--console("objectRefSize = "..objectRefSize)
	--console("Num objects = "..numObjects)
	--console("topObject = "..topObject)
	--console("offsetTableOffset = "..offsetTableOffset)
    
    for i = 0, numObjects, 1 do
      local offsetBytes = extractData(data,offsetTableOffset + i * offsetSize, offsetSize)
      offsetTable[i] = offsetBytes;
	  --console("Objec "..i.." = "..offsetBytes)
    end

    local t = parseObject(data,topObject)

    -- build_tree(t)
	-- Get $objects from root dictionnary and iterate on it
	-- console("type t "..type(t))
	if type(t) == 'table' then
		local top = t['$top']
	if top ~= nil then
		local rootIndex = top['root']
		-- console("Root : "..rootIndex)
	if rootIndex ~= nil then
		local objects = t['$objects']
		-- console("type objects "..type(objects))
		if objects ~= nil and type(objects) == 'table' then
			-- Get root dict
			local rootDict = objects[rootIndex+1]
			--console("type rootDict "..type(rootDict))
			-- Get preset dict
			local presetIndex = rootDict['presets']
		if presetIndex ~= nil then
			local presetsDict = objects[presetIndex+1]
		if presetsDict ~= nil and type(presetsDict) == 'table' then
			local presetsArray = presetsDict["NS.objects"]
		if presetsArray ~= nil and type(presetsArray) == 'table' then
			-- console("Found presets !")
			-- Iterate on objects
			for i,v in ipairs(presetsArray) do
				-- console("Found preset index "..v)
				local presetDict = objects[v+1]
    			if presetDict ~= nil and type(presetDict) == 'table' then
					-- Is this a preset ?
					myPresetNumnber = presetDict["presetNumber"]
					-- console("Found preset dict for number"..myPresetNumnber)
					if myPresetNumnber ~= nil then
						-- This is a preset
						myPreset = {}
						myPresetNumnber = tonumber(myPresetNumnber)+1
						myPreset["number"]=myPresetNumnber
						-- Try and get preset name
						local name = nil
						local nameIndex = presetDict["name"]
						if nameIndex ~= nil then
							name = objects[nameIndex+1]
						end
						if name == nil or not (type(name) == "string") then
							name = "Preset "..myPresetNumnber
						end
						myPreset["name"]=name
						-- console("Preset("..myPresetNumnber..")= "..name)
						-- Gain
						local value = convertValue255(presetDict["gain"],isBlackSpirit)
						myPreset["gain"]=value

						-- Bass
						value = convertValue255(presetDict["bass"],isBlackSpirit)
						myPreset["bass"]=value

						-- Mid
						value = convertValue255(presetDict["mid"],isBlackSpirit)
						myPreset["mid"]=value

						-- Volume
						value = convertValue255(presetDict["volume"],isBlackSpirit)
						myPreset["volume"]=value

						-- Treble
						value = convertValue255(presetDict["treble"],isBlackSpirit)
						myPreset["treble"]=value

						-- Resonance
						value = convertValue255(presetDict["resonance"],isBlackSpirit)
						myPreset["resonance"]=value

						-- Presence
						value = convertValue255(presetDict["presence"],isBlackSpirit)
						myPreset["presence"]=value

						-- Reverb
						value = convertValue255(presetDict["reverbLevel"],isBlackSpirit)
						myPreset["reverb"]=value

						-- Delay level
						value = convertValue255(presetDict["delayLevel"],isBlackSpirit)
						myPreset["delayLevel"]=value

						-- Delay Time
						-- Min val = 51, max val = 1360 => range = 1309
						value = math.floor(((presetDict["delayTime"]-51)*255/1309)+0.5)
						myPreset["delayTime"]=value

						-- Delay Feedback
						value = convertValue255(presetDict["delayFeedback"],isBlackSpirit)
						myPreset["delayFeedback"]=value

                        if presetDict["modIntensity"] ~= nil then
                            -- Grandmeister style => modIntensity + modType + modRate
						    -- Mod intensity
						    value = convertValue255(presetDict["modIntensity"],isBlackSpirit)
						    myPreset["modIntensity"]=value

						    -- Mod rate / type
						    value = presetDict["modType"]*64+convertValue63(presetDict["modRate"])
						    myPreset["modType"]=value
                        else
                            -- BlackSpirit style => modulationIntensity + modulationType + modulationRate
						    -- Mod intensity
						    value = convertValue255(presetDict["modulationIntensity"],isBlackSpirit)
						    myPreset["modIntensity"]=value

						    -- Mod rate / type
						    value = presetDict["modulationType"]*64+convertValue63(presetDict["modulationRate"])
						    myPreset["modType"]=value
                        end

						-- Preamp channel
						value = convertValue4(presetDict["soundChannel"])
						myPreset["channelType"]=value

						-- Pream boost
                        if presetDict["boost"] ~= nil then
                            -- Grandmeister style
						    value = convertValue2(presetDict["boost"])
						    myPreset["channelBoost"]=value
                        else
                            -- BlackSpirit style
						    value = convertValue2(presetDict["boostEnabled"])
						    myPreset["channelBoost"]=value
                        end

						-- Fx loop
                        if presetDict["fxLoop"] ~= nil then
                            -- Grandmeister style
						    value = convertValue2(presetDict["fxLoop"])
						    myPreset["fxLoop"]=value
                        else
                            -- BlackSpirit style
						    value = convertValue2(presetDict["fxLoopEnabled"])
						    myPreset["fxLoop"]=value
                        end

						-- Power soak
                        if presetDict["speakerPower"] ~= nil then
    						if presetDict["speakerOff"] then
							    myPreset["powerSoak"]=0
						    else
							    myPreset["powerSoak"]=convertValue5(presetDict["speakerPower"]+1)
						    end
                        else
						    myPreset["powerSoak"]=0
                        end
						
						-- Noise Gate
                        if presetDict["noiseGate"] ~= nil then
                            -- Grandmeister style
						    value = convertValue2(presetDict["noiseGate"])
						    myPreset["noiseGate"]=value
                        else
                            -- BlackSpirit style
						    value = convertValue2(presetDict["noiseGateEnabled"])
						    myPreset["noiseGate"]=value
                        end

                        -- Noise Gate Level
                        if presetDict["noiseGateLevel"] ~= nil then
                            -- BlackSpirit
						    value = convertValue255(presetDict["noiseGateLevel"],isBlackSpirit)
						    myPreset["noiseGateLevel"]=value
                        else
                            -- Grandmeister
						    myPreset["noiseGateLevel"]=0
                        end

                        -- Sagging
                        if presetDict["sagging"] ~= nil then
                            -- BlackSpirit
						    value = convertValue8(presetDict["sagging"])
						    myPreset["sagging"]=value
                        else
                            -- Grandmeister
						    myPreset["sagging"]=0
                        end

						-- Store preset
						myPresets[myPresetNumnber]=myPreset
					end
				end
  			end
		end -- presetsArray
		end -- presetsIndex
		end -- presets
		end -- objects
	end -- root
	end -- top
	end
	
	-- Fill in the blanks
	for i=1,128 do
		if myPresets[i] == nil then
			-- console("init preset #"..i)
			myPresets[i] = initPreset(i)
		end
	end
	
	return myPresets
end

function convertValue255(value,isBlackSpirit)
    if isBlackSpirit then
	    return math.floor(value*255)
    else
	    return math.floor((value*255/100)+0.5)
    end
end

function convertValue63(value)
	return math.floor((value*63/100)+0.5)
end

function convertValue4(value)
	return value*42
end

function convertValue5(value)
	return value*31
end

function convertValue8(value)
	return value*36
end

function convertValue2(value)
	if value then
		return 127
	else
		return 0
	end
end


function extractData(data,start,length)
	if length <= 1 then
		return extractByte(data,start)
	elseif length <= 2 then
		return extractChar(data,start)
	elseif length <= 4 then
		return extractInt(data,start)
	else
		return extractLong(data,start)
	end
end

function extractReal(data,start,length)
	if length <= 4 then
		return extractFloat(data,start)
	else
		-- Double not supported for now
		return 0
	end
end

function extractByte(data,start)
	local result = data:getByte(start)
	return result
end

function extractChar(data,start)
	local result = data:getByte(start)
	result = result * 256
	result = result + data:getByte(start + 1)
	return result
end

function extractInt(data,start)
	local result = data:getByte(start)
	result = result * 256
	result = result + data:getByte(start + 1)
	result = result * 256
	result = result + data:getByte(start + 2)
	result = result * 256
	result = result + data:getByte(start + 3)
	return result
end

function extractLong(data,start)
	local result = data:getByte(start)
	result = result * 256
	result = result + data:getByte(start + 1)
	result = result * 256
	result = result + data:getByte(start + 2)
	result = result * 256
	result = result + data:getByte(start + 3)
	result = result * 256
	result = result + data:getByte(start + 4)
	result = result * 256
	result = result + data:getByte(start + 5)
	result = result * 256
	result = result + data:getByte(start + 6)
	result = result * 256
	result = result + data:getByte(start + 7)
	return result
end

function extractFloat(data,start)
  -- Change to b4,b3,b2,b1 to unpack an LSB float
  local b1 = data:getByte(start)
  local b2 = data:getByte(start+1)
  local b3 = data:getByte(start+2)
  local b4 = data:getByte(start+3)
  local exponent = (b1 % 128) * 2 + math.floor(b2 / 128)
  if exponent == 0 then return 0 end
  local sign = (b1 > 127) and -1 or 1
  local mantissa = ((b2 % 128) * 256 + b3) * 256 + b4
  mantissa = (math.ldexp(mantissa, -23) + 1) * sign
  return math.ldexp(mantissa, exponent - 127)
end

  function parseObject(data,tableOffset)

    local startPos = offsetTable[tableOffset];
	--console("Start pos = "..startPos)
	--console("Data = "..data:getRange(startPos-4,16):toHexString(1))

  -- each table entry starts with single byte header, indicating type and extra info
    local typeData = extractByte(data,startPos)
    local objType = bit.rshift(typeData, 4) 
    local objInfo = bit.band(typeData, 0x0F)
	--console("type = "..type)
	--console("objType = "..objType)
	--console("objInfo = "..objInfo)

-- null
    if objType == 0x0 and objInfo == 0x0 then -- null
      return nil

-- false          
    elseif objType == 0x0 and objInfo == 0x8 then -- false
      return false

-- true          
    elseif objType == 0x0 and objInfo == 0x9 then -- true
      return true

-- filler          
    elseif objType == 0x0 and objInfo == 0xF then -- filler byte
      return nil

-- integer
-- UID
    elseif objType == 0x1 or
           objType == 0x8 then
      local length = 2 ^ objInfo
      return extractData(data,startPos + 1, length)

-- real        
    elseif objType == 0x2 then -- real
      local length = 2 ^ objInfo
      return extractReal(data,startPos + 1, length)

-- date        
    elseif objType == 0x3 then -- date
      if (objInfo ~= 0x3) then
          console("Error: Unknown date type :"..objInfo)
      end
    return extractFloat(data,startPos + 1) -- TODO: Format correctly

-- data        
    elseif objType == 0x4 then -- data
      local length = objInfo
      local dataOffset = 1
      if(objInfo == 0xF) then -- 1111
        local int_type = extractByte(data,startPos + 1)
        local intType = bit.band(int_type, 0xF0) / 0x10;
        if intType ~= 0x1 then
          console("Error : 0x6 Unexpected length - int-type"..intType)
        end
        intInfo = bit.band(int_type, 0x0F)
        intLength = 2 ^ intInfo
        dataOffset = 2 + intLength
        length = extractData(data,startPos + 2, intLength)
      end

-- how to determine which one to use?        
--        print(buffer(startPos + dataOffset, length):bytes())
-- 0x7B is {
--      print("===== data ===== ", buffer(startPos + dataOffset, length):string())
      return data:getRange(startPos + dataOffset, length):toString()

-- ASCII String        
    elseif objType == 0x5 then -- ASCII
      local length = objInfo
      local strOffset = 1
      if(objInfo == 0xF) then -- 1111
        local int_type = extractByte(data,startPos + 1)
        local intType = bit.band(int_type, 0xF0) / 0x10;
        if intType ~= 0x1 then
          console("Error : 0x6 Unexpected length - int-type"..intType)
        end
        intInfo = bit.band(int_type, 0x0F)
        intLength = 2 ^ intInfo
        strOffset = 2 + intLength
        length = extractData(data,startPos + 2, intLength)
      end
      return data:getRange(startPos + strOffset, length):toString()

-- UTF16 String        
    elseif objType == 0x6 then -- UTF-16
      local length = objInfo
      local strOffset = 1
      if(objInfo == 0xF) then -- 1111
        local int_type = extractByte(data,startPos + 1)
        local intType = bit.band(int_type, 0xF0) / 0x10;
        if intType ~= 0x1 then
          console("Error : 0x6 Unexpected length - int-type"..intType)
        end
        intInfo = bit.band(int_type, 0x0F)
        intLength = 2 ^ intInfo
        strOffset = 2 + intLength
        length = extractData(data,startPos + 2, intLength)
      end
      length = length * 2
--      print("===== UTF16 String =====")
--      print("length: ", length)
--      print(buffer(startPos + strOffset, length):len())
--      print(buffer(startPos + strOffset, length):ustring())
--      return "UTF16String"
      local utf16String = ""
      for i = 0, length-1, 2 do
        local wch = extractChar(data,startPos + strOffset + i)
        utf16String = utf16String..toUtf8String(wch)
      end
      --console("UTF-16 String start pos: "..startPos.." offset "..strOffset.." length "..length.." content "..utf16String)
      
      return utf16String

-- UTF8 String        
    elseif objType == 0x7 then -- UTF-8
      local length = objInfo
      local strOffset = 1
      if(objInfo == 0xF) then -- 1111
        local int_type = extractByte(data,startPos + 1)
        local intType = bit.band(int_type, 0xF0) / 0x10;
        if intType ~= 0x1 then
          console("Error : 0x6 Unexpected length - int-type"..intType)
        end
        intInfo = bit.band(int_type, 0x0F)
        intLength = 2 ^ intInfo
        strOffset = 2 + intLength
        length = extractData(data,startPos + 2, intLength)
      end

      --console("UTF-8 String :"..(data:getRange(startPos + strOffset, length):toString()))
      return data:getRange(startPos + strOffset, length):toString()

-- Array        
    elseif objType == 0xA then
      local length = objInfo
      local arrayOffset = 1
      if(objInfo == 0xF) then -- 1111
        local int_type = extractByte(data,startPos + 1)
        local intType = bit.band(int_type, 0xF0) / 0x10;
        if intType ~= 0x1 then
          console("Error : 0xA Unexpected length - int-type"..intType)
        end
        intInfo = bit.band(int_type, 0x0F)
        intLength = 2 ^ intInfo
        arrayOffset = 2 + intLength
        length = extractData(data,startPos + 2, intLength)
      end
      local array = {}
      for i = 0, length - 1, 1 do
        objRef = extractData(data,startPos + arrayOffset + i * objectRefSize, objectRefSize)
        array[i+1] = parseObject(data,objRef)
      end
      return array

-- Set
    elseif objType == 0xC then
--      print("===== Set =====")  
      return "TODO: Add in Set!!!" -- TODO

-- Dictionary        
    elseif objType == 0xD then
      local length = objInfo
      local dictOffset = 1
      if(objInfo == 0xF) then -- 1111
        local int_type = extractByte(data,startPos + 1)
        local intType = bit.band(int_type, 0xF0) / 0x10;
        if intType ~= 0x1 then
          console("Error : 0xD Unexpected length - int-type"..intType)
        end
        intInfo = bit.band(int_type, 0x0F)
        intLength = 2 ^ intInfo
        dictOffset = 2 + intLength
        length = extractData(data,startPos + 2, intLength)
      end
      local dict = {}
      for i = 0, length - 1, 1 do
        local keyRef = extractData(data,(startPos + dictOffset) + (i * objectRefSize), objectRefSize)
        local valRef = extractData(data,(startPos + dictOffset + (length * objectRefSize)) + (i * objectRefSize), objectRefSize)
        local key = parseObject(data,keyRef);
        local val = parseObject(data,valRef);
		--console("StartPos = "..startPos)
		--console("DictOffset = "..dictOffset)
		--console("keyRef = "..keyRef)
		--console("valRef = "..valRef)
        --console("key: "..key)
		--console("type: "..type(val))
		--if type(val) == "string" then
        --	console("val: "..val)
		--end
        dict[key] = val
      end
      return dict
    end

-- Unkown type return error message
    return "Error : Unknown object type - " .. objType

  end

  function toUtf8String(decimal)
    if decimal<256 then return string.char(decimal) end
    return "'"
  end


loadFromJSon = function(data)
	local myPresets = {}
	local myPreset = nil
	local myPresetNumnber = nil
	local jSonPreset
	for line in data:gmatch("[^\r\n]+") do 
		jSonPreset = json.decode(line)
		myPreset = {}
		myPresetNumnber = tonumber(jSonPreset["nr"])+1
		--console("Processing preset: "..myPresetNumnber.. " / "..jSonPreset["name"])
		myPreset["number"]=myPresetNumnber
		myPreset["name"]=jSonPreset["name"]
		myPreset["modIntensity"]=jSonPreset["modIntensity"]
		myPreset["delayTime"]=jSonPreset["delTime"]
		myPreset["modType"]=jSonPreset["modRate"]
		myPreset["bass"]=jSonPreset["peqBass"]
		myPreset["mid"]=jSonPreset["peqMid"]
		myPreset["treble"]=jSonPreset["peqTreble"]
		myPreset["resonance"]=jSonPreset["paeResonance"]
		myPreset["presence"]=jSonPreset["paePresence"]
		myPreset["delayFeedback"]=jSonPreset["delFeedback"]
		myPreset["delayLevel"]=jSonPreset["delLevel"]
		myPreset["reverb"]=jSonPreset["revLevel"]
		myPreset["powerSoak"]=jSonPreset["power4state"]
		myPreset["channelType"]=jSonPreset["cha4state"]
		if jSonPreset["fxloop"] then
			myPreset["fxLoop"]=127
		else
			myPreset["fxLoop"]=0
		end
		myPreset["gain"]=jSonPreset["chaGain"]
		myPreset["volume"]=jSonPreset["chaVolume"]
		if jSonPreset["noisegate"] then
			myPreset["noiseGate"]=127
		else
			myPreset["noiseGate"]=0
		end
		if jSonPreset["boost"] then
			myPreset["channelBoost"]=127
		else
			myPreset["channelBoost"]=0
		end

		myPresets[myPresetNumnber]=myPreset
	end
	-- Fill in the blanks
	for i=1,128 do
		if myPresets[i] == nil then
			myPresets[i] = initPreset(i)
			console("Initing preset : "..i)
		end
	end
	return myPresets
end

