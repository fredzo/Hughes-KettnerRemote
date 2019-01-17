--
-- Called when data needs saving
--
saveData = function(stateData)
	stateData:setProperty("currentPresetNumber",currentPresetNumber,nil)
	stateData:setProperty("currentLibraryFile",currentLibraryFile,nil)
	stateData:setProperty("ingoredVersionUpdate",ingoredVersionUpdate,nil)
	stateData:setProperty("globalPowerSoak",globalPowerSoakValue,nil)
	stateData:setProperty("currentExternalFile",currentExternalFile,nil)
	stateData:setProperty("ampType",ampType,nil)

	-- TODO save on store and presetNameChanged instead
	saveAmpToFile()
	-- Save library if dirty
	if libraryDirty then
		local backupLibraryFileName = currentLibraryFile
		backupLibraryFileName = string.gsub(backupLibraryFileName,"%.gm36",".backup.gm36")
		backupLibraryFileName = string.gsub(backupLibraryFileName,"%.gm40",".backup.gm40")
		savePresetsToFile(backupLibraryFileName,libraryPresets)
	end
end

saveAmpToFile = function()
	if isGm40() then
		savePresetsToFile(File.getSpecialLocation(File.userHomeDirectory):getFullPathName().."/gm40/amp.store",ampPresets)
	else
		savePresetsToFile(File.getSpecialLocation(File.userHomeDirectory):getFullPathName().."/gm36/amp.store",ampPresets)
	end
end

saveLibraryToFile = function()
	savePresetsToFile(currentLibraryFile,libraryPresets)
	libraryDirty = false
	lastPresetDirty = false
	setLibraryFileName()
end

saveLibraryAs = function(newFilePath)
	currentLibraryFile = newFilePath
	savePresetsToFile(newFilePath,libraryPresets)
	libraryDirty = false
	lastPresetDirty = false
	setLibraryFileName()
end

saveLibraryForIpad = function(newFilePath)
	saveToBinary(newFilePath,libraryPresets)
end

savePresetsToFile = function(path,presetsToSave)
	--if panel:getBootstrapState() or panel:getRestoreState() then
	--	return
	--end
	--console("Saving...")
	local file = File(path)
	-- Create parent dir if needed
	local parent = file:getParentDirectory()
	if not parent:exists() then
		parent:createDirectory()
	end
	local content = ""
	local presetName = ""
	for i,v in ipairs(presetsToSave) do
		content = content.."[preset]\n"
		-- First save preset number
		content = content.."number".."="..(v["number"]).."\n"
		-- Then preset name
		if v["name"] ~= nil then
			presetName = v["name"]
		else
			presetName = "Preset "..i
		end
		content = content.."name".."="..presetName.."\n"
		-- And finally iterate on controllers
		for kk, vv in pairs(controllers) do
			content = content..vv.."="..(v[vv]).."\n"
		end
	end
	if content ~= "" then
		--console(content)
		if file:replaceWithText (content, false, false) == false then
			utils.warnWindow ("File write", "Failed to write data to file: "..file:getFullPathName())
		end
	endend


-- Save bp list code


function saveToBinary(path,presetsToSave)
	--console("Saving...")
	local file = File(path)
	-- Create parent dir if needed
	local parent = file:getParentDirectory()
	if not parent:exists() then
		parent:createDirectory()
	end

	-- Get library name from file path
	local libraryName = file:getFileName()
	if libraryName ~= nil then
		libraryName = string.gsub(libraryName, "%.gm36memory", "")
		libraryName = string.gsub(libraryName, "%.gm40memory", "")
	else
		libraryName = "Desktop remote library"
	end
	-- write object
	if file:replaceWithData(MemoryBlock(convertToBinary(presetsToSave,libraryName))) == false then
		utils.warnWindow ("File write", "Failed to write data to file: "..file:getFullPathName())
	end

end

-- Global buffer and counter
entries = {}
reversedEntries = {}
entriesIndex = 0
data = {0}
dataIndex = 0
idSizeInBytes = 0
offsetSizeInBytes = 0
offsets = {}

function convertToBinary(presetsToSave,libraryName)
	local rootDict = convertToDict(presetsToSave,libraryName)
	return serializeDict(rootDict)
end

function convertToDict(presetsToSave,libraryName)

	local rootDict = {}
	local rootDictObjects = {}
	local rootObjectsIndex = 1
	rootDict["$version"] = 100000
	rootDict["$objects"] = rootDictObjects
	rootDict["$archiver"] = "NSKeyedArchiver"
	local topDict = {}
	topDict["root"] = {}
 	topDict["root"]=Uid(1)
	rootDict["$top"] = topDict
	-- Add nil string [0]
	rootDictObjects[rootObjectsIndex]="$null"
	rootObjectsIndex = rootObjectsIndex+1
	-- Add gm36memory object [1]
	local gmMemory = {}
	rootDictObjects[rootObjectsIndex]=gmMemory
	rootObjectsIndex = rootObjectsIndex+1
	-- Add presets array [2]
	local presetsArrayObject = {}
	rootDictObjects[rootObjectsIndex]=presetsArrayObject
	rootObjectsIndex = rootObjectsIndex+1
	-- Add Class to objects : GM36Preset [3] / NSMutableArray [4] / GM36Memory [5]
	-- TODO handle GM40 format ?
	rootDictObjects[rootObjectsIndex]=createClass("GM36Preset","NSObject")
	rootObjectsIndex = rootObjectsIndex+1
	rootDictObjects[rootObjectsIndex]=createClass("NSMutableArray","NSArray", "NSObject")
	rootObjectsIndex = rootObjectsIndex+1
	rootDictObjects[rootObjectsIndex]=createClass("GM36Memory","NSObject")
	rootObjectsIndex = rootObjectsIndex+1
	-- Add library name [6]
	rootDictObjects[rootObjectsIndex]=libraryName
	rootObjectsIndex = rootObjectsIndex+1
	-- Build GM36 memory object
	gmMemory["presets"]=Uid(2)
	gmMemory["$class"]=Uid(5)
	gmMemory["readOnly"]=false
	gmMemory["name"]=Uid(6)
	gmMemory["activePresetNumber"]=0
	gmMemory["version"]=1
	-- Build ns array object
	presetsArrayObject["$class"]=Uid(4)
	local presetsArray = {}
	presetsArrayObject["NS.objects"]= presetsArray
	-- Build presets array
	local presetNameIndex
	local presetIndex
	local currentPreset
	for i,preset in ipairs(presetsToSave) do
		--if i > 125 then break end
		presetNameIndex = rootObjectsIndex-1
		-- Add preset name to objects
		rootDictObjects[rootObjectsIndex]=preset["name"]
		presetIndex = rootObjectsIndex
		rootObjectsIndex = rootObjectsIndex+1
		-- Add preset to objects
		currentPreset = {}
		presetsArray[i]=Uid(presetIndex)
		rootDictObjects[rootObjectsIndex]=currentPreset
		rootObjectsIndex = rootObjectsIndex+1
		-- Pream boost
		value = convertDictValue2(preset["channelBoost"])
		currentPreset["boost"]=value
		-- Delay Time
		-- Min val = 51, max val = 1360 => range = 1309
		value = (((preset["delayTime"]*1309)/255)+51)
		currentPreset["delayTime"]=Float(value)
		-- Volume
		value = convertDictValue255(preset["volume"])
		currentPreset["volume"]=value
		-- Bass
		value = convertDictValue255(preset["bass"])
		currentPreset["bass"]=value
		-- Presence
		value = convertDictValue255(preset["presence"])
		currentPreset["presence"]=value
		-- Mid
		value = convertDictValue255(preset["mid"])
		currentPreset["mid"]=value
		-- Speaker off
		if preset["powerSoak"]==0 then
			currentPreset["speakerOff"] = true
		else
			currentPreset["speakerOff"] = false
		end
		-- Resonance
		value = convertDictValue255(preset["resonance"])
		currentPreset["resonance"]=value
		-- Preset number
		currentPreset["presetNumber"]=preset["number"]-1
		-- Class
		currentPreset["$class"]=Uid(3)
		-- Preamp channel
		value = convertDictValue4(preset["channelType"])
		currentPreset["soundChannel"]=value
		-- Reverb
		value = convertDictValue255(preset["reverb"])
		currentPreset["reverbLevel"]=value
		-- Version
		currentPreset["version"]=1
		-- Preset name
		currentPreset["name"]=Uid(presetNameIndex)
		-- Mod rate
		value = convertDictValue63(preset["modType"]%64)
		currentPreset["modRate"]=value
		-- Fx loop
		value = convertDictValue2(preset["fxLoop"])
		currentPreset["fxLoop"]=value
		-- Treble
		value = convertDictValue255(preset["treble"])
		currentPreset["treble"]=value
		-- Mod rate / type
		value = math.floor(preset["modType"]/64)
		currentPreset["modType"]=value
		-- Delay level
		value = convertDictValue255(preset["delayLevel"])
		currentPreset["delayLevel"]=value
		-- Preset bank
		currentPreset["presetBank"]=127
		-- Noise Gate
		value = convertDictValue2(preset["noiseGate"])
		currentPreset["noiseGate"]=value
		-- Power soak
		if preset["powerSoak"]==0 then
			currentPreset["speakerPower"] = 3
		else
			currentPreset["speakerPower"] = convertDictValue5(preset["powerSoak"]-1)
		end
		-- Gain
		value = convertDictValue255(preset["gain"])
		currentPreset["gain"]=value
		-- Delay Feedback
		value = convertDictValue255(preset["delayFeedback"])
		currentPreset["delayFeedback"]=value
		-- Mod intensity
		value = convertDictValue255(preset["modIntensity"])
		currentPreset["modIntensity"]=value
		--currentPreset["author"]=Uid(presetNameIndex)
		currentPreset["author"]=Uid(0)
	end
	return rootDict
end

function convertDictValue255(value)
	return Float(value*100/255)
end

function convertDictValue63(value)
	return Float(value*100/63)
end

function convertDictValue4(value)
	return math.floor(value/42)
end

function convertDictValue5(value)
	return math.floor(value/31)
end

function convertDictValue2(value)
	if value >= 63 then
		return true
	else
		return false
	end
end



function createClass(className,parentClassName,grandParentClassName)
	local classDict = {}
	if grandParentClassName == nil then
		classDict["$classes"] = {className , parentClassName}
	else
		classDict["$classes"] = {className , parentClassName, grandParentClassName}
	end
	classDict["$classname"] = className
	return classDict
end

function serializeDict(rootDict)
	-- Init globals
	entries = {}
	reversedEntries = {}
	entriesIndex = 1
	data = {0x62, 0x70, 0x6c, 0x69, 0x73, 0x74, 0x30, 0x30}
	dataIndex = 9
	idSizeInBytes = 0
	offsetSizeInBytes = 0
	offsets = {}

	dictToEntry(rootDict)

	idSizeInBytes = computeIdSizeInBytes(entriesIndex)

	for i,entry in ipairs(entries) do
		--console("wrinting entry "..i)
		offsets[i] = dataIndex-1
		writeEntry(entry)
	end
 	
	--console("Write offsetTable")
	writeOffsetTable()
	--console("Write trailer")
	writeTrailer()
	
	return data
end

function toEntries(object)
	if type(object) == 'table' then
		if object.isFloat then
			return addEntry(object)
		elseif object.isUid then
			return addEntry(object)
		elseif isArray(object) then
      		return arrayToEntry(object)
		else
      		return dictToEntry(object)
		end
	elseif type(object) == 'string' then
      return addEntry(object)
	elseif type(object) == 'number' then
      return addEntry(object);
	elseif type(object) == 'boolean' then
      return addEntry(object);
	else
      return addEntry(object);
	end
end

function isArray(table)
	for k,v in pairs(table) do
		-- Acceptable approximation : a table with a numeric key is an array
		if type(k) == 'number' then
			return true
		else
			return false
		end
	end
	return true
end

function dictToEntry(dict)
	local dictEntry = {}
	local dictIndex = addEntry(dictEntry)
	for k,v in pairs(dict) do
		local kIndex = addEntry(k)
		local vIndex = toEntries(v)
      	dictEntry[kIndex]=vIndex
		--console("Adding key "..kIndex.." value "..vIndex)
	end
	return dictIndex
end

function arrayToEntry(array)
	--console("Adding array ")
	local arrayEntry = {}
	setmetatable(arrayEntry, {__isarray = true})
	local arrayIndex = addEntry(arrayEntry)
	for i,v in ipairs(array) do
		local vIndex = toEntries(v)
      	arrayEntry[i]=vIndex
		--console("Adding array item "..i)
	end
	return arrayIndex
end

function addEntry(entry)
	--console("Add entry "..entriesIndex.." of type "..type(entry))
	local previousIndex = reversedEntries[entry]
	if previousIndex ~= nil then
		return previousIndex
	else
		local entryIndex = entriesIndex - 1
		entries[entriesIndex] = entry
		reversedEntries[entry] = entryIndex
		entriesIndex = entriesIndex + 1
		return entryIndex
	end
end

function writeEntry(entry)
	if type(entry) == 'table' then
		if (getmetatable(entry) ~= nil and getmetatable(entry).__isarray) then
			--console("write array entry")
      		writeArray(entry)
		elseif entry.isFloat then
			--console("write float")
      		writeNumber(entry.floatValue,false);
		elseif entry.isUid then
			--console("write uid")
      		writeUid(entry.uidValue,entry.uidSize);
		else
			--console("write dict entry")
      		writeDict(entry)
		end
	elseif type(entry) == 'string' then
      writeString(entry)
	elseif type(entry) == 'number' then
      writeNumber(entry,true);
	elseif type(entry) == 'boolean' then
      writeBoolean(entry);
	else
      writeData(entry);
	end
end

function writeDict(entry)
    writeIntHeader(0xD, tablelength(entry))
	for i,v in pairs(entry) do
      writeID(i)
	end
	for i,v in pairs(entry) do
      writeID(v)
	end
end

function writeArray(entry)
    writeIntHeader(0xA, tablelength(entry));
	for i,v in ipairs(entry) do
		--console("Writing array entry id "..v)
      writeID(v)
	end
end

function writeNumber(entry,isInt)
    if isInt then -- integer case
      if entry < 0 then
        writeByte(0x13)
        writeBytes(entry, 8)
      elseif (entry <= 0xff) then
        writeByte(0x10)
        writeBytes(entry, 1)
      elseif (entry <= 0xffff) then
        writeByte(0x11);
        writeBytes(entry, 2)
      elseif (entry <= 0xffffffff) then
        writeByte(0x12)
        writeBytes(entry, 4)
      else
        writeByte(0x13)
        writeBytes(entry, 8)
      end
    else 
      writeByte(0x22);
      writeFloat(entry)
    end
end

function writeUid(entry,size)
    if size == 1 then
    	writeIntHeader(0x8, 0x0)
    elseif size == 2 then
    	writeIntHeader(0x8, 0x1)
    elseif size == 4 then
    	writeIntHeader(0x8, 0x2)
    else
    	writeIntHeader(0x8, 0x3)
    end
    writeBytes(entry,size)
end

function writeString(entry)
	--console("wrinting string "..entry)
    local hasUtf = false
	for i = 1, string.len(entry) do
    	if string.byte(entry,i) >=  128 then 
            hasUtf = true
            break
        end
	end
    if hasUtf then
	    --console("wrinting UTF string "..entry)
        -- Use UTF16 format
  	    writeIntHeader(0x6, string.len(entry));
	    for i = 1, string.len(entry) do
    	    writeByte(0x00)
    	    writeByte(string.byte(entry,i))
            --console("Wringing UTF char : "..string.byte(entry,i))
	    end
    else
        -- Use ASCII format
        writeIntHeader(0x5, string.len(entry));
	    for i = 1, string.len(entry) do
    	    writeByte(string.byte(entry,i))
	    end
    end
end

function writeData(entry)
    writeIntHeader(0x4, tablelength(entry));
    -- TODObuffer.write(entry.value);
end

function writeLong(l)
    writeBytes(l, 8)
end

function writeByte(b)
    -- TODO buffer.write(new Buffer([b]));
	data[dataIndex] = b
	dataIndex = dataIndex + 1
	--console("Writing byte "..b)
end

function writeFloat(n)
	--console("Writing float "..n)
	if n == 0.0 then 
        writeBytes(0x00,4)
	else
    	local sign = 0
    	if n < 0.0 then
        	sign = 0x80
        	n = -n
    	end

    	local mant, expo = math.frexp(n)

    	if mant ~= mant then
			writeBytes(0xFF800000,4)
    	elseif mant == math.huge or expo > 0x80 then
        	if sign == 0 then
				writeBytes(0x7F800000,4)
        	else
				writeBytes(0xFF800000,4)
        	end
    	elseif (mant == 0.0 and expo == 0) or expo < -0x7E then
			writeByte(sign)
			writeByte(0x00)
			writeByte(0x00)
			writeByte(0x00)
		else
			--console("Writing mant "..mant.."expo "..expo)
        	expo = expo + 0x7E
        	mant = (mant * 2.0 - 1.0) * math.ldexp(0.5, 24)
			writeByte(sign + math.floor(expo / 0x2))
			writeByte((expo % 0x2) * 0x80 + math.floor(mant / 0x10000))
			writeByte(math.floor(mant / 0x100) % 0x100)
			writeByte(math.floor(mant % 0x100))
    	end
	end
end

function writeIntHeader(kind, value)
    if (value < 15) then
      	writeByte(bit.lshift(kind, 4) + value)
    elseif (value < 256) then
      	writeByte(bit.lshift(kind,4) + 15)
      	writeByte(0x10)
      	writeBytes(value, 1)
    elseif (value < 65536) then
      	writeByte(bit.lshift(kind,4) + 15)
      	writeByte(0x11)
      	writeBytes(value, 2)
    else
      	writeByte(bit.lshift(kind,4) + 15)
      	writeByte(0x12)
      	writeBytes(value, 4)
    end
end

function writeBoolean(entry)
	if entry then
    	writeByte(0x09);
	else
    	writeByte(0x08);
	end
end

function writeID(id)
    writeBytes(id, idSizeInBytes)
end

function writeBytes(value, bytes)
	-- write low-order bytes big-endian style
	local byteIndex = bytes - 1
    -- doesn't handle large numbers
	for i=1,bytes do
		if byteIndex >= 4 then
			writeByte(0x00)
		else
			writeByte(bit.band(bit.rshift(value,(8 * byteIndex)), 0xFF))
		end
		byteIndex =  byteIndex-1
	end
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


function computeOffsetSizeInBytes(maxOffset) 
	-- console("Max offset = "..maxOffset)
  if (maxOffset < 256) then
    return 1
  end
  if (maxOffset < 65536) then
    return 2
  end
  if (maxOffset < 4294967296) then
    return 4
  end
  return 8
end



function computeIdSizeInBytes(numberOfIds) 
  -- console("Num of ids = "..numberOfIds)
  if (numberOfIds < 256) then
    return 1
  end
  if (numberOfIds < 65536) then
    return 2
  end
  return 4
end

function writeTrailer()
    -- 6 null bytes
	--console("write nulls")
	writeByte(0)
	writeByte(0)
	writeByte(0)
	writeByte(0)
	writeByte(0)
	writeByte(0)

	--console("write offsetsize")
    -- size of an offset
    writeByte(offsetSizeInBytes);

	--console("write ref size")
    -- size of a ref
    writeByte(idSizeInBytes);

	--console("write obj numbers :"..tablelength(entries))
    -- number of objects
    writeLong(tablelength(entries));

	--console("write top object")
    -- top object
    writeLong(0);

	--console("write offsetTableOfset "..offsetTableOffset)
    -- offset table offset
    writeLong(offsetTableOffset);
end

function writeOffsetTable()
    offsetTableOffset = dataIndex - 1
    offsetSizeInBytes = computeOffsetSizeInBytes(offsetTableOffset)
	--console("offsetTableOfset = "..offsetTableOffset.." in bytes "..offsetSizeInBytes)
	for i,offset in ipairs(offsets) do
 		writeBytes(offset, offsetSizeInBytes)
	end
end

function Float(value)
  local self = { isFloat=true, floatValue=value }
  -- return the instance
  return self
end

function Uid(value, size)
	size = size or 2
  	local self = { isUid=true, uidValue=value, uidSize=size}
  	-- return the instance
  	return self
end
