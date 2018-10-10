--
-- Called when a modulator value changes
-- @mod   http://ctrlr.org/api/class_ctrlr_modulator.html
-- @value    new numeric value of the modulator
--
libraryExternalToggleChanged = function(--[[ CtrlrModulator --]] modulator, --[[ number --]] value)
	if panel:getBootstrapState() or notMouseOver(modulator) then
		return
	end
	if not externalPresetsLoaded then
		return
	end
	local newLibraryEditorExternal
	if value == 0 then
		newLibraryEditorExternal = false
	else
		newLibraryEditorExternal = true
	end
	if newLibraryEditorExternal ~= libraryEditorExternal then
		libraryEditorExternal = newLibraryEditorExternal
		setLibraryEditorPresets()
		initLibraryEditor()
	end
end

function setLibraryEditorPresets()
	if libraryEditorExternal then
		libraryEditorPresets = externalPresets
	else
		libraryEditorPresets = libraryPresets
	end
end

function setLibraryExternalToggle(boolValue)
	local modulator = panel:getModulator("libraryExternalToggle")	
	if modulator ~= nil then
		if boolValue then
			modulator:setValue(1,true,true)
		else
			modulator:setValue(0,true,true)
		end
	end
end
