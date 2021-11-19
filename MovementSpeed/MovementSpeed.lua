--Addon name, namespace
local addonNameSpace, ns = ...
local _, addon = GetAddOnInfo(addonNameSpace)

--WidgetTools reference
local wt = WidgetToolsTable


--[[ ASSETS & RESOURCES ]]

--Strings & Localization
local strings = ns.LoadLocale()
strings.chat.keyword = "/movespeed"

--Color palette
local colors = {
	lg = "|cFF" .. "8FD36E", --light green
	sg = "|cFF" .. "4ED836", --strong green
	ly = "|cFF" .. "FFFB99", --light yellow
	sy = "|cFF" .. "FFDD47", --strong yellow
}

--Fonts
local fonts = {
	[0] = { text = strings.misc.default, path = strings.options.font.family.default },
	[1] = { text = "Arbutus Slab", path = "Interface/AddOns/MovementSpeed/Fonts/ArbutusSlab.ttf" },
	[2] = { text = "Caesar Dressing", path = "Interface/AddOns/MovementSpeed/Fonts/CaesarDressing.ttf" },
	[3] = { text = "Germania One", path = "Interface/AddOns/MovementSpeed/Fonts/GermaniaOne.ttf" },
	[4] = { text = "Mitr", path = "Interface/AddOns/MovementSpeed/Fonts/Mitr.ttf" },
	[5] = { text = "Oxanium", path = "Interface/AddOns/MovementSpeed/Fonts/Oxanium.ttf" },
	[6] = { text = "Pattaya", path = "Interface/AddOns/MovementSpeed/Fonts/Pattaya.ttf" },
	[7] = { text = "Reem Kufi", path = "Interface/AddOns/MovementSpeed/Fonts/ReemKufi.ttf" },
	[8] = { text = "Source Code Pro", path = "Interface/AddOns/MovementSpeed/Fonts/SourceCodePro.ttf" },
	[9] = { text = strings.misc.custom, path = "Interface/AddOns/MovementSpeed/Fonts/CUSTOM.ttf" },
}

--Textures
local textures = {
	logo = "Interface/AddOns/MovementSpeed/Textures/Logo.tga"
}


--[[ DB TABLES ]]

local db --account-wide
local dbDefault = {
	position = {
		point = "TOPRIGHT",
		offset = { x = -67, y = -179 },
	},
	appearance = {
		hidden = false,
		frameStrata = "MEDIUM",
		backdrop = {
			visible = false,
			color = { r = 0, g = 0, b = 0, a = 0.5 },
		},
	},
	font = {
		family = fonts[0].path,
		size = 11,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}


--[[ FRAMES & EVENTS ]]

--Create the main frame & text display
local movSpeed = CreateFrame("Frame", addon:gsub("%s+", ""), UIParent)
local mainDisplay = CreateFrame("Frame", movSpeed:GetName() .. "MainDisplay", movSpeed, BackdropTemplateMixin and "BackdropTemplate")
local mainDisplayText = mainDisplay:CreateFontString(mainDisplay:GetName() .. "Text", "OVERLAY")

--Register events
movSpeed:RegisterEvent("ADDON_LOADED")
movSpeed:RegisterEvent("PET_BATTLE_OPENING_START")
movSpeed:RegisterEvent("PET_BATTLE_CLOSE")

--Event handler
movSpeed:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)


--[[ UTILITIES ]]

local function Dump(object)
	if type(object) ~= "table" then
		print(object)
		return
	end
	for _, v in pairs(object) do
		Dump(v)
	end
end

--Make a new deep copy (not reference) of a table
local function Clone(object)
	if type(object) ~= "table" then
		return object
	end
	local copy = {}
	for k, v in pairs(object) do
		copy[k] = Clone(v)
	end
	return copy
end

---Convert table to string chunk
--- - Note: append "return " to the start when loading via [load()](https://www.lua.org/manual/5.2/manual.html#lua_load).
---@param table table
---@param compact boolean
---@return string
local function TableToString(table, compact)
	local s = ((compact ~= true) and " " or "")
	local chunk = "{" .. s
	for k, v in pairs(table) do
		--Key
		chunk = chunk .. "[" .. (type(k) == "string" and "\"" or "") .. k .. (type(k) == "string" and "\"" or "") .. "]"
		--Add =
		chunk = chunk .. s .. "=" .. s
		--Value
		if type(v) == "table" then
			chunk = chunk .. TableToString(v, compact)
		elseif type(v) == "string" then
			chunk = chunk .. "\"" .. v .. "\""
		else
			chunk = chunk .. tostring(v)
		end
		--Add separator
		chunk = chunk .. "," .. s
	end
	return ((chunk .. "}"):gsub("," .. s .. "}",  s .. "}"))
end

--DB checkup and fix
local oldData = {}
local function CheckValidity(k, v) --Check the validity of the provided key value pair
	if k == "size" and v <= 0 then return true
	elseif (k == "r" or k == "g" or k == "b" or k == "a") and (v < 0 or v > 1) then return true
	else return false end
end
local function RemoveEmpty(dbToCheck) --Remove all nil and empty items from the table
	if type(dbToCheck) ~= "table" then return end
	for k, v in pairs(dbToCheck) do
		if type(v) == "table" then
			if next(v) == nil then --The subtable is empty
				dbToCheck[k] = nil --Remove the empty subtable
			else
				RemoveEmpty(v)
			end
		elseif v == nil or v == "" or CheckValidity(k, v) then --The value is invalid, empty or doesn't exist
			dbToCheck[k] = nil --Remove the key value pair
		end
	end
end
local function AddMissing(dbToCheck, dbToSample) --Check for and fill in missing data
	if type(dbToCheck) ~= "table" and type(dbToSample) ~= "table" then return end
	if next(dbToSample) == nil then return end --The sample table is empty
	for k, v in pairs(dbToSample) do
		if dbToCheck[k] == nil then --The sample key doesn't exist in the table to check
			if v ~= nil and v ~= "" then
				dbToCheck[k] = v --Add the item if the value is not empty or nil
			end
		else
			AddMissing(dbToCheck[k], dbToSample[k])
		end
	end
end
local function RemoveMismatch(dbToCheck, dbToSample) --Remove unused or outdated data while trying to keep any old data
	if type(dbToCheck) ~= "table" and type(dbToSample) ~= "table" then return end
	if next(dbToCheck) == nil then return end --The table to check is empty
	for k, v in pairs(dbToCheck) do
		if dbToSample[k] == nil then --The checked key doesn't exist in the sample table
			oldData[k] = v --Add the item to the old data to be restored
			dbToCheck[k] = nil --Remove the unneeded item
		else
			RemoveMismatch(dbToCheck[k], dbToSample[k])
		end
	end
end
local function RestoreOldData(dbToSaveTo) --Restore old data to an account-wide DB by matching removed items to known old keys
	for k, v in pairs(oldData) do
		if k == "point" then
			dbToSaveTo.position.point = v
			oldData.k = nil
		elseif k == "offsetX" then
			dbToSaveTo.position.offset.x = v
			oldData.k = nil
		elseif k == "offsetY" then
			dbToSaveTo.position.offset.y = v
			oldData.k = nil
		elseif k == "hidden" then
			dbToSaveTo.appearance.hidden = v
			oldData.k = nil
		end
	end
end

--Find the ID of the font provided
local function GetFontID(fontPath)
	local selectedFont = 0
	for i = 0, #fonts do
		if fonts[i].path == fontPath then
			selectedFont = i
			break
		end
	end
	return selectedFont
end


--[[ OPTIONS SETTERS ]]

--Main frame positioning
local function SavePreset()
	db.position.point, _, _, db.position.offset.x, db.position.offset.y = movSpeed:GetPoint()
	print(colors.sg .. addon .. ":" .. colors.ly .. " " .. strings.chat.save.response)
end
local function MoveToPreset()
	movSpeed:ClearAllPoints()
	movSpeed:SetUserPlaced(false)
	movSpeed:SetPoint(db.position.point, db.position.offset.x, db.position.offset.y)
	movSpeed:SetUserPlaced(true)
	print(colors.sg .. addon .. ":" .. colors.ly .. " " .. strings.chat.preset.response)
end
local function DefaultPreset()
	db.position = Clone(dbDefault.position)
	print(colors.sg .. addon .. ":" .. colors.ly .. " " .. strings.chat.reset.response)
	MoveToPreset()
end

---Set the visibility of the main display frame based on the flipped value of the input parameter
---@param visible boolean
local function FlipVisibility(visible)
	if visible then
		movSpeed:Hide()
	else
		movSpeed:Show()
	end
end

---Set the size of the main display
---@param height number
local function SetDisplaySize(height)
	--Set dimensions
	height = math.ceil(height) + 2
	local width = height * 3 - 4
	mainDisplay:SetSize(width, height)
end

---Set the backdrop of the main display
---@param enabled boolean Set or remove backdrop
---@param r? number Red (Range: 0 - 1, Default: db.appearance.backdrop.color.r)
---@param g? number Green (Range: 0 - 1, Default: db.appearance.backdrop.color.g)
---@param b? number Blue (Range: 0 - 1, Default: db.appearance.backdrop.color.b)
---@param a? number Opacity (Range: 0 - 1, Default: db.appearance.backdrop.color.a or 1)
local function SetDisplayBackdrop(enabled, r, g, b, a)
	if enabled then
		mainDisplay:SetBackdrop({
			bgFile = "Interface/ChatFrame/ChatFrameBackground",
			edgeFile = "Interface/ChatFrame/ChatFrameBackground",
			tile = true, tileSize = 5, edgeSize = 1,
			insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
		mainDisplay:SetBackdropColor(
			r or db.appearance.backdrop.color.r,
			g or db.appearance.backdrop.color.g,
			b or db.appearance.backdrop.color.b,
			a or db.appearance.backdrop.color.a or 1
		)
		mainDisplay:SetBackdropBorderColor(1, 1, 1, 0.4)
	else
		mainDisplay:SetBackdrop(nil)
	end
end

---Set the visibility, backdrop, font family, size and color of the main display to the currently saved values
---@param data table DB table to set the main display values from
local function SetDisplayValues(data)
	--Visibility
	movSpeed:SetFrameStrata(db.appearance.frameStrata)
	FlipVisibility(data.appearance.hidden)
	--Display
	SetDisplaySize(data.font.size)
	SetDisplayBackdrop(
		data.appearance.backdrop.visible,
		data.appearance.backdrop.color.r,
		data.appearance.backdrop.color.g,
		data.appearance.backdrop.color.b,
		data.appearance.backdrop.color.a
	)
	--Font
	mainDisplayText:SetFont(data.font.family, data.font.size, "THINOUTLINE")
	mainDisplayText:SetTextColor(data.font.color.r, data.font.color.g, data.font.color.b, data.font.color.a)
end


--[[ GUI OPTIONS ]]

--Options frame references
local options = { appearance = { backdrop = { color = {} } }, font = { color = {} }, backup = {} }

--Backup management
local LoadData --Defined after interface options definitions

--[ GUI elements ]

local function CreatePositionOptions(parentFrame)
	--Button & Popup: Save preset position
	local savePopup = wt.CreatePopup({
		name = strings.options.position.save.label,
		text = strings.options.position.save.warning,
		onAccept = function() SavePreset() end
	})
	wt.CreateButton({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 10, y = -30 }
		},
		width = 120,
		label = strings.options.position.save.label,
		tooltip = strings.options.position.save.tooltip,
		onClick = function() StaticPopup_Show(savePopup) end
	})
	--Button & Popup: Reset default preset position
	local resetPopup = wt.CreatePopup({
		name = strings.options.position.reset.label,
		text = strings.options.position.reset.warning,
		onAccept = function() DefaultPreset() end
	})
	local reset = wt.CreateButton({
		parent = parentFrame,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -30 }
		},
		width = 120,
		label = strings.options.position.reset.label,
		tooltip = strings.options.position.reset.tooltip,
		onClick = function() StaticPopup_Show(resetPopup) end
	})
	--Button & Popup: Set to preset position
	local presetPopup = wt.CreatePopup({
		name = strings.options.position.preset.label,
		text = strings.options.position.preset.warning,
		onAccept = function() MoveToPreset() end
	})
	wt.CreateButton({
		parent = parentFrame,
		position = {
			anchor = "TOPRIGHT",
			relativeTo = reset,
			relativePoint = "TOPLEFT",
			offset = { x = -4, y = 0 }
		},
		width = 120,
		label = strings.options.position.preset.label,
		tooltip = strings.options.position.preset.tooltip,
		onClick = function() StaticPopup_Show(presetPopup) end
	})
end
local function CreateAppearanceOptions(parentFrame)
	--Checkbox: Hidden
	options.appearance.hidden = wt.CreateCheckbox({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 8, y = -30 }
		},
		label = strings.options.appearance.hidden.label,
		tooltip = strings.options.appearance.hidden.tooltip:gsub("#ADDON", addon),
		onClick = function(self) FlipVisibility(self:GetChecked()) end
	})
	--Checkbox: Raise
	options.appearance.raise = wt.CreateCheckbox({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			relativeTo = options.appearance.hidden,
			relativePoint = "BOTTOMLEFT",
			offset = { x = 0, y = -4 }
		},
		label = strings.options.appearance.raise.label,
		tooltip = strings.options.appearance.raise.tooltip,
		onClick = function(self) movSpeed:SetFrameStrata(self:GetChecked() and "HIGH" or "MEDIUM") end
	})
	--Color Picker: Background color
	_, options.appearance.backdrop.color.picker, options.appearance.backdrop.color.hex = wt.CreateColorPicker({
		parent = parentFrame,
		position = {
			anchor = "TOP",
			offset = { x = 0, y = -93 }
		},
		label = strings.options.appearance.backdrop.color.label,
		opacity = true,
		setColors = function()
			if mainDisplay:GetBackdrop() ~= nil then return mainDisplay:GetBackdropColor() end
			return db.appearance.backdrop.color.r, db.appearance.backdrop.color.g, db.appearance.backdrop.color.b, db.appearance.backdrop.color.a
		end,
		onColorUpdate = function(r, g, b, a)
			if mainDisplay:GetBackdrop() ~= nil then
				mainDisplay:SetBackdropColor(r, g, b, a)
			end
		end,
		onCancel = function(r, g, b, a)
			if mainDisplay:GetBackdrop() ~= nil then
				mainDisplay:SetBackdropColor(r, g, b, a)
			end
		end
	})
	--Checkbox: Backdrop
	options.appearance.backdrop.visible = wt.CreateCheckbox({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			relativeTo = options.appearance.raise,
			relativePoint = "BOTTOMLEFT",
			offset = { x = 0, y = -4 }
		},
		label = strings.options.appearance.backdrop.label,
		tooltip = strings.options.appearance.backdrop.tooltip,
		onClick = function(self) SetDisplayBackdrop(self:GetChecked(), options.appearance.backdrop.color.picker:GetBackdropColor()) end
	})
end
local function CreateFontOptions(parentFrame)
	--Dropdown: Font family
	local fontItems = {}
	for i = 0, #fonts do
		fontItems[i] = fonts[i]
		fontItems[i].onSelect = function()
			mainDisplayText:SetFont(fonts[i].path, options.font.size:GetValue(), "THINOUTLINE")
			--Refresh the text so the font will be applied even if it's selected for the first time
			local text = mainDisplayText:GetText()
			mainDisplayText:SetText("")
			mainDisplayText:SetText(text)
		end
	end
	options.font.family = wt.CreateDropdown({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = -6, y = -30 }
		},
		label = strings.options.font.family.label,
		tooltip = strings.options.font.family.tooltip[0],
		tooltipExtra = {
			[0] = { text = strings.options.font.family.tooltip[1] },
			[1] = { text = "\n" .. strings.options.font.family.tooltip[2]:gsub("#OPTION_CUSTOM", strings.misc.custom):gsub("#FILE_CUSTOM", "CUSTOM.ttf") },
			[2] = { text = "[WoW]\\Interface\\AddOns\\" .. addonNameSpace .. "\\Fonts\\", color = { r = 0.185, g = 0.72, b = 0.84 }, wrap = false },
			[3] = { text = strings.options.font.family.tooltip[3]:gsub("#FILE_CUSTOM", "CUSTOM.ttf") },
			[4] = { text = strings.options.font.family.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 } },
		},
		items = fontItems,
	})
	--Slider: Font size
	options.font.size = wt.CreateSlider({
		parent = parentFrame,
		position = {
			anchor = "TOP",
			offset = { x = 0, y = -30 }
		},
		label = strings.options.font.size.label,
		tooltip = strings.options.font.size.tooltip .. "\n\n" .. strings.misc.default .. ": " .. dbDefault.font.size,
		value = { min = 8, max = 64, step = 1 },
		onValueChanged = function(self)
			mainDisplayText:SetFont(mainDisplayText:GetFont(), self:GetValue(), "THINOUTLINE")
			SetDisplaySize(self:GetValue())
		end
	})
	--Color Picker: Font color
	_, options.font.color.picker, options.font.color.hex = wt.CreateColorPicker({
		parent = parentFrame,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -12, y = -30 }
		},
		label = strings.options.font.color.label,
		opacity = true,
		setColors = function() return mainDisplayText:GetTextColor() end,
		onColorUpdate = function(r, g, b, a) mainDisplayText:SetTextColor(r, g, b, a) end,
		onCancel = function(r, g, b, a)mainDisplayText:SetTextColor(r, g, b, a) end
	})
end
local function CreateBackupOptions(parentFrame)
	--EditScrollBox & Popup: Import & Export
	local importPopup = wt.CreatePopup({
		name = strings.options.backup.box.import,
		text = strings.options.backup.box.warning,
		onAccept = function() LoadData(options.backup.string:GetText()) end
	})
	options.backup.string = wt.CreateEditScrollBox({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 18, y = -30 }
		},
		size = { width = 556, height = 57 },
		maxLetters = 512,
		fontObject = "GameFontWhiteSmall", --Grey: GameFontDisableSmall
		label = strings.options.backup.box.label,
		tooltip = strings.options.backup.box.tooltip[0],
		tooltipExtra = {
			[0] = { text = strings.options.backup.box.tooltip[1] },
			[1] = { text = "\n" .. strings.options.backup.box.tooltip[2]:gsub("#ENTER", strings.keys.enter) },
			[2] = { text = strings.options.backup.box.tooltip[3], color = { r = 0.89, g = 0.65, b = 0.40 } },
			[3] = { text = "\n" .. strings.options.backup.box.tooltip[4], color = { r = 0.92, g = 0.34, b = 0.23 } },
		},
		onEnterPressed = function() StaticPopup_Show(importPopup) end,
		onEscapePressed = function(self) self:SetText(TableToString(db, true)) end
	})
end

--Category frames
local function CreateMainCategoryPanels(parentFrame)
	--Position
	local positionOptions = wt.CreateCategory({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 16, y = -82 }
		},
		size = { height = 64 },
		title = strings.options.position.title,
		description = strings.options.position.description:gsub("#SHIFT", strings.keys.shift)
	})
	CreatePositionOptions(positionOptions)
	--Appearance
	local appearanceOptions = wt.CreateCategory({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			relativeTo = positionOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { x = 0, y = -32 }
		},
		size = { height = 142 },
		title = strings.options.appearance.title,
		description = strings.options.appearance.description:gsub("#ADDON", addon)
	})
	CreateAppearanceOptions(appearanceOptions)
	--Font
	local fontOptions = wt.CreateCategory({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			relativeTo = appearanceOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { x = 0, y = -32 }
		},
		size = { height = 86 },
		title = strings.options.font.title,
		description = strings.options.font.description
	})
	CreateFontOptions(fontOptions)
end
local function CreateAdvancedCategoryPanels(parentFrame)
	---Backup
	local backupOptions = wt.CreateCategory({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 16, y = -82 }
		},
		size = { height = 125 },
		title = strings.options.backup.title,
		description = strings.options.backup.description:gsub("#ADDON", addon)
	})
	CreateBackupOptions(backupOptions)
end

--[ Options panels & event handlers ]

local function SaveMain()
	--Appearance
	db.appearance.hidden = options.appearance.hidden:GetChecked()
	db.appearance.frameStrata = options.appearance.raise:GetChecked() and "HIGH" or "MEDIUM"
	db.appearance.backdrop.visible = options.appearance.backdrop.visible:GetChecked()
	db.appearance.backdrop.color.r, db.appearance.backdrop.color.g, db.appearance.backdrop.color.b, db.appearance.backdrop.color.a = options.appearance.backdrop.color.picker:GetBackdropColor()
	--Font
	db.font.family = mainDisplayText:GetFont()
	db.font.size = options.font.size:GetValue()
	db.font.color.r, db.font.color.g, db.font.color.b, db.font.color.a = options.font.color.picker:GetBackdropColor()
end
local function DefaultMain() --Refresh() is called automatically
	MovementSpeedDB = Clone(dbDefault)
	db = Clone(dbDefault)
	SetDisplayValues(db)
	MoveToPreset()
	print(colors.sg .. addon .. ": " .. colors.ly .. strings.options.defaults)
end
---Update the main interface option panel GUI frames
---@param data table DB table to load the interface options from
local function UpdateMain(data)
	--Appearance
	options.appearance.hidden:SetChecked(data.appearance.hidden)
	options.appearance.raise:SetChecked(data.appearance.frameStrata == "HIGH")
	options.appearance.backdrop.visible:SetChecked(data.appearance.backdrop.visible)
	options.appearance.backdrop.color.picker:SetBackdropColor(
		data.appearance.backdrop.color.r,
		data.appearance.backdrop.color.g,
		data.appearance.backdrop.color.b,
		data.appearance.backdrop.color.a
	)
	options.appearance.backdrop.color.hex:SetText(wt.ColorToHex(
		data.appearance.backdrop.color.r,
		data.appearance.backdrop.color.g,
		data.appearance.backdrop.color.b,
		data.appearance.backdrop.color.a
	))
	--Font
	UIDropDownMenu_SetSelectedValue(options.font.family, GetFontID(data.font.family))
	UIDropDownMenu_SetText(options.font.family, fonts[GetFontID(data.font.family)].text)
	options.font.size:SetValue(data.font.size)
	options.font.color.picker:SetBackdropColor(data.font.color.r, data.font.color.g, data.font.color.b, data.font.color.a)
	options.font.color.hex:SetText(wt.ColorToHex(data.font.color.r, data.font.color.g, data.font.color.b, data.font.color.a))
end
---Update the advanced interface option panel GUI frames
---@param data table DB table to load the interface options from
local function UpdateAdvanced(data)
	--Backup
	options.backup.string:SetText(TableToString(data, true))
end

--Create and add the options panels to the WoW Interface options
local function LoadInterfaceOptions()
	--Main options panel
	local mainOptions = wt.CreateOptionsPanel({
		title = addon,
		description = strings.options.main.description:gsub("#ADDON", addon):gsub("#KEYWORD", strings.chat.keyword),
		icon = textures.logo,
	})
	CreateMainCategoryPanels(mainOptions) --Add categories & GUI elements to the panel
	wt.AddOptionsPanel(mainOptions, { --Add as a category to the Interface options
		name = addon,
		okay = SaveMain,
		cancel = function() SetDisplayValues(db) end,
		default = function()
			DefaultMain()
			UpdateAdvanced(db)
		end,
		refresh = function() UpdateMain(db) end
	})
	--Advanced options panel
	local advancedOptions = wt.CreateOptionsPanel({
		title = strings.options.advanced.title,
		description = strings.options.advanced.description:gsub("#ADDON", addon),
		icon = textures.logo,
	})
	CreateAdvancedCategoryPanels(advancedOptions) --Add categories & GUI elements to the panel
	wt.AddOptionsPanel(advancedOptions, { --Add as a category to the Interface options
		parent = addon,
		name = strings.options.advanced.title,
		default = function()
			DefaultMain()
			UpdateMain(db)
		end,
		refresh = function() UpdateAdvanced(db) end
	})
end

--[ Definitions ]

--Definition for loading data from an import string
LoadData = function(chunk)
	--Load from string to a temporary table
	local success, returned = pcall(loadstring("return " .. chunk))
	if success and type(returned) == "table" then
		local loadDB = returned
		--Run DB checkup on the loaded table
		RemoveEmpty(loadDB) --Strip invalid, empty or nil keys & values
		AddMissing(loadDB, db) --Check for missing data
		RemoveMismatch(loadDB, db) --Remove unneeded data
		RestoreOldData(loadDB) --Save old data
		--Update the interface options and the main display
		UpdateMain(loadDB)
		UpdateAdvanced(loadDB)
		SetDisplayValues(loadDB)
	else print(colors.sg .. addon .. ": " .. colors.ly .. strings.options.backup.box.error) end
end


--[[ CHAT CONTROL ]]

--Print utilities
local function PrintVisibility()
	print(colors.sg .. addon .. ": " .. colors.ly .. strings.chat.toggle.response:gsub("#HIDDEN", movSpeed:IsShown() and strings.chat.toggle.shown or strings.chat.toggle.hidden))
end
local function PrintInfo()
	print(colors.sy .. strings.chat.help.thanks:gsub("#ADDON", colors.sg .. addon .. colors.sy))
	PrintVisibility()
	print(colors.ly .. strings.chat.help.hint:gsub("#HELP_COMMAND", colors.lg .. strings.chat.keyword .. " " .. strings.chat.help.command .. colors.ly))
	print(colors.ly .. strings.chat.help.move:gsub("#SHIFT", colors.lg .. strings.keys.shift .. colors.ly):gsub("#ADDON", addon))
end
local function PrintCommands()
	PrintVisibility()
	print(colors.sg .. addon .. colors.ly .. " ".. strings.chat.help.list .. ":")
	--Index the commands (skipping the help command) and put replacement code segments in place
	local commands = {
		[0] = {
			command = strings.chat.options.command,
			description = strings.chat.options.description:gsub("#ADDON", addon)
		},
		[1] = {
			command = strings.chat.save.command,
			description = strings.chat.save.description
		},
		[2] = {
			command = strings.chat.preset.command,
			description = strings.chat.preset.description
		},
		[3] = {
			command = strings.chat.reset.command,
			description = strings.chat.reset.description
		},
		[4] = {
			command = strings.chat.toggle.command,
			description = strings.chat.toggle.description
		},
		[5] = {
			command = strings.chat.size.command,
			description =  strings.chat.size.description:gsub("#SIZE_DEFAULT", colors.lg .. strings.chat.size.command .. " " .. dbDefault.font.size .. colors.ly)
		},
	}
	--Print the list
	for i = 0, #commands do
		print("    " .. colors.lg .. strings.chat.keyword .. " " .. commands[i].command .. colors.ly .. " - " .. commands[i].description)
	end
end

--Slash command handler
SLASH_MOVESPEED1 = strings.chat.keyword
function SlashCmdList.MOVESPEED(line)
	local command, parameter = strsplit(" ", line)
	if command == strings.chat.help.command then
		PrintCommands()
	elseif command == strings.chat.options.command then
		InterfaceOptionsFrame_OpenToCategory(addon)
		InterfaceOptionsFrame_OpenToCategory(addon) --Load twice to make sure the proper page and category is loaded
	elseif command == strings.chat.save.command then
		SavePreset()
	elseif command == strings.chat.preset.command then
		MoveToPreset()
	elseif command == strings.chat.reset.command then
		DefaultPreset()
	elseif command == strings.chat.toggle.command then
		FlipVisibility(movSpeed:IsVisible())
		db.appearance.hidden = not movSpeed:IsVisible()
		--Update the GUI option in case it was open
		options.appearance.hidden:SetChecked(db.appearance.hidden)
		--Response
		PrintVisibility()
	elseif command == strings.chat.size.command then
		local size = tonumber(parameter)
		if size ~= nil then
			db.font.size = size
			mainDisplayText:SetFont(db.font.family, db.font.size, "THINOUTLINE")
			SetDisplaySize(size)
			--Update the GUI option in case it was open
			options.font.size:SetValue(size)
			--Response
			print(colors.sg .. addon .. ": " .. colors.ly .. strings.chat.size.response:gsub("#VALUE", size))
		else
			--Error
			print(colors.sg .. addon .. ": " .. colors.ly .. strings.chat.size.unchanged)
			print(colors.ly .. strings.chat.size.error:gsub("#SIZE_DEFAULT", colors.lg .. strings.chat.size.command .. " " .. dbDefault.font.size .. colors.ly))
		end
	else
		PrintInfo()
	end
end


--[[ DISPLAY FRAME SETUP ]]

--Set frame parameters
local function SetUpMainDisplayFrame()
	--Main frame
	movSpeed:SetToplevel(true)
	movSpeed:SetSize(33, 10)
	if not movSpeed:IsUserPlaced() then
		movSpeed:ClearAllPoints()
		movSpeed:SetPoint(dbDefault.position.point, dbDefault.position.offset.x, dbDefault.position.offset.y)
		movSpeed:SetUserPlaced(true)
	end
	--Display
	SetDisplaySize(db.font.size)
	mainDisplay:SetPoint("CENTER")
	--Text
	mainDisplayText:SetPoint("CENTER") --TODO: Add font offset option to fine-tune the position (AND/OR, ad pre-tested offsets to keep each font in the center)
	--Visual elements
	SetDisplayValues(db)
end

--Making the frame moveable
movSpeed:SetMovable(true)
mainDisplay:SetScript("OnMouseDown", function()
	if (IsShiftKeyDown() and not movSpeed.isMoving) then
		movSpeed:StartMoving()
		movSpeed.isMoving = true
	end
end)
mainDisplay:SetScript("OnMouseUp", function()
	if (movSpeed.isMoving) then
		movSpeed:StopMovingOrSizing()
		movSpeed.isMoving = false
	end
end)

--Hide during Pet Battle
function movSpeed:PET_BATTLE_OPENING_START() mainDisplay:Hide() end
function movSpeed:PET_BATTLE_CLOSE() mainDisplay:Show() end


--[[ INITIALIZATION ]]

local function LoadDB()
	--First load
	if MovementSpeedDB == nil then
		MovementSpeedDB = dbDefault
		PrintInfo()
	end
	--Load the DB
	db = MovementSpeedDB
	--DB checkup & fix
	RemoveEmpty(db) --Strip empty and nil keys & items
	AddMissing(db, dbDefault) --Check for missing data
	RemoveMismatch(db, dbDefault) --Remove unneeded data
	RestoreOldData(db) --Save old data
end
function movSpeed:ADDON_LOADED(name)
	if name ~= addonNameSpace then return end
	movSpeed:UnregisterEvent("ADDON_LOADED")
	--Load & check the DB
	LoadDB()
	--Set up the main frame & text
	SetUpMainDisplayFrame()
	--Set up the interface options
	LoadInterfaceOptions()
	--Visibility notice
	if not movSpeed:IsShown() then PrintVisibility() end
end


--[[ DISPLAY UPDATE ]]

--Recalculate the movement speed value and update the displayed text
movSpeed:SetScript("OnUpdate", function()
	local unit = "player"
	if  UnitInVehicle("player") then
		unit = "vehicle"
	end
	mainDisplayText:SetText(string.format("%d%%", math.floor(GetUnitSpeed(unit) / 7 * 100 + .5)))
end)