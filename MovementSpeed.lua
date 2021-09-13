--Addon namespace
local addonName, ns = ...


--[[ STRINGS & LOCALIZATION ]]

local strings = {
	addon = "Movement Speed",
}
--Load localization
local function LoadLocale()
	if (GetLocale() == "[N/A]") then
		--TODO: add support for other languages (locales: https://wowwiki-archive.fandom.com/wiki/API_GetLocale#Locales)
	else --English (UK & US)
		strings.options = ns.english.options
		strings.chat = ns.english.chat
	end
end
LoadLocale()

--Color palette for string formatting
local colors = {
	lg = "|cFF" .. "8FD36E", --light green
	sg = "|cFF" .. "4ED836", --strong green
	ly = "|cFF" .. "FFFB99", --light yellow
	sy = "|cFF" .. "FFDD47", --strong yellow
}


--[[ DB TABLES ]]

local db --account-wide
local defaultDB = {
	position = {
		point = "TOPRIGHT",
		offset = {x = -68, y = -179},
	},
	hidden = false,
	font = {
		family = "Fonts\\FRIZQT__.TTF",
		size = 11,
	},
}

--Table management utilities
local function Dump(object)
	if type(object) == "table" then
		for k, v in pairs(object) do
			Dump(v)
		end
	else
		print(object)
	end
end
local function Clone(table)
	local copy = {}
	for k, v in pairs(table) do
		if type(v) == "table" then
			v = Clone(v)
		end
		copy[k] = v
	end
	return copy
end


--[[ FRAMES ]]

--Create the main frame & options panel and their elements
local movSpeed = CreateFrame("Frame", "MovementSpeed", UIParent)
local textDisplay = movSpeed:CreateFontString("TextDisplay", "HIGH")
local optionsPanel = CreateFrame("Frame", "MovementSpeedOptions", InterfaceOptionsFramePanelContainer)
local options = {
	position = {frame = CreateFrame("Frame", "PositionOptions", optionsPanel, BackdropTemplateMixin and "BackdropTemplate" or nil)},
	visibility = {frame = CreateFrame("Frame", "VisibilityOptions", optionsPanel, BackdropTemplateMixin and "BackdropTemplate" or nil)},
	font = {frame = CreateFrame("Frame", "FontOptions", optionsPanel, BackdropTemplateMixin and "BackdropTemplate" or nil)},
}
options.position.save = CreateFrame("Button", "ButtonSave", options.position.frame, "OptionsButtonTemplate")
options.position.reset = CreateFrame("Button", "ButtonReset", options.position.frame, "OptionsButtonTemplate")
options.position.default = CreateFrame("Button", "ButtonDefault", options.position.frame, "OptionsButtonTemplate")
options.visibility.hidden = CreateFrame("CheckButton", "CheckBoxHidden", options.visibility.frame, "InterfaceOptionsCheckButtonTemplate")
options.font.size = CreateFrame("Slider", "SliderFontSize", options.font.frame, "OptionsSliderTemplate")

--Register events
movSpeed:RegisterEvent("ADDON_LOADED")
movSpeed:RegisterEvent("PLAYER_LOGIN")
--Event handler
movSpeed:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)


--[[ OPTIONS SETTERS & UTILITIES ]]

--Positioning utilities
local function ResetPosition()
	movSpeed:ClearAllPoints()
	movSpeed:SetUserPlaced(false)
	movSpeed:SetPoint(db.position.point, db.position.offset.x, db.position.offset.y)
	movSpeed:SetUserPlaced(true)
	print(colors.sg .. strings.addon .. ":" .. colors.ly .. " " .. strings.chat.reset.response)
end
local function SavePosition()
	local x local y db.position.point, x, y, db.position.offset.x, db.position.offset.y = movSpeed:GetPoint()
	print(colors.sg .. strings.addon .. ":" .. colors.ly .. " " .. strings.chat.save.response)
end
local function DefaultPreset()
	db.position = defaultDB.position
	print(colors.sg .. strings.addon .. ":" .. colors.ly .. " " .. strings.chat.default.response)
end

--Display visibility and font utilities
local function FlipVisibility(visible)
	if visible then
		textDisplay:Hide()
	else
		textDisplay:Show()
	end
end
local function SetDisplayValues()
	FlipVisibility(db.hidden)
	textDisplay:SetFont(db.font.family, db.font.size, "THINOUTLINE")
	textDisplay:SetTextColor(1,1,1,1)
end


--[[ CHAT CONTROL ]]

local keyword = "/movespeed"

--Print utilities
local function PrintStatus()
	local visibility
	if textDisplay:IsShown() then
		visibility = strings.chat.show.response
	else
		visibility = strings.chat.hide.response
	end
	print(colors.sg .. strings.addon .. ": " .. colors.ly .. visibility)
end
local function PrintHelp()
	print(colors.sy .. strings.chat.help.thanks:gsub("#", colors.sg .. strings.addon .. colors.sy))
	PrintStatus()
	print(colors.ly .. strings.chat.help.hint:gsub("#", colors.lg .. keyword .. " " .. strings.chat.help.command .. colors.ly))
	print(colors.ly .. strings.chat.help.move:gsub("#", colors.lg .. "SHIFT" .. colors.ly))
end
local function PrintCommands()
	PrintStatus()
	print(colors.sg .. strings.addon .. colors.ly .. " ".. strings.chat.help.list .. ":")
	--Index the commands (skipping the help command) and put replacement code segments in place
	local commands = {
		[0] = {
			command = strings.chat.reset.command,
			description = strings.chat.reset.description,
		},
		[1] = {
			command = strings.chat.save.command,
			description = strings.chat.save.description,
		},
		[2] = {
			command = strings.chat.default.command,
			description = strings.chat.default.description,
		},
		[3] = {
			command = strings.chat.hide.command,
			description = strings.chat.hide.description,
		},
		[4] = {
			command = strings.chat.show.command,
			description = strings.chat.show.description,
		},
		[5] = {
			command = strings.chat.size.command,
			description =  strings.chat.size.description:gsub("#", colors.lg .. strings.chat.size.command .. defaultDB.font.size .. colors.ly),
		},
	}
	--Print the list
	for i = 0, #commands do
		print("    " .. colors.lg .. keyword .. " " .. commands[i].command .. colors.ly .. " - " .. commands[i].description)
	end
end

--Slash command handler
SLASH_MOVESPEED1 = keyword
function SlashCmdList.MOVESPEED(line)
	local command, parameter = strsplit(" ", line)
	if command == strings.chat.help.command then
		PrintCommands()
	elseif command == strings.chat.reset.command then
		ResetPosition()
	elseif command == strings.chat.save.command then
		SavePosition()
	elseif command == strings.chat.default.command then
		DefaultPreset()
	elseif command == strings.chat.hide.command then
		db.hidden = true
		textDisplay:Hide()
		PrintStatus()
	elseif command == strings.chat.show.command then
		db.hidden = false
		textDisplay:Show()
		PrintStatus()
	elseif command == strings.chat.size.command then
		local size = tonumber(parameter)
		if size ~= nil then
			db.font.size = size
			textDisplay:SetFont(db.font.family, db.font.size, "THINOUTLINE")
			print(colors.sg .. strings.addon .. ": " .. colors.ly .. strings.chat.size.response:gsub("#", size))
		else
			print(colors.sg .. strings.addon .. ": " .. colors.ly .. strings.chat.size.unchanged)
			print(colors.ly .. strings.chat.size.error:gsub("#", colors.lg .. strings.chat.size.command .. defaultDB.font.size .. colors.ly))
		end
	else
		PrintHelp()
	end
end


--[[ GUI ELEMENT SETTERS ]]

--[[Parameters:
frame panel --The frame to add title and optionally a description to
table t
	title
		text --Text to be shown as the main title of the frame provided via the panel parameter
		offset --The offset from the TOPLEFT point of the specified frame given in the panel parameter
			x --Horizontal offset value
			y --Vertical offset value
		template --Template to be used for the FontString
	description [optional]
		text --Text to be shown as the subtitle/description of the frame provided via the panel parameter
		offset --The offset from the BOTTOMLEFT point of the main title FontString
			x --Horizontal offset value
			y --Vertical offset value
		template --Template to be used for the FontString
]]
local function SetUpTitle(panel, t)
	--Title
	local title = panel:CreateFontString(panel:GetName() .. "Title", "ARTWORK", t.title.template)
	title:SetPoint("TOPLEFT", t.title.offset.x, t.title.offset.y)
	title:SetText(t.title.text)
	if t.description == nil then
		return title
	end
	--Description
	local description = panel:CreateFontString(panel:GetName() .. "Description", "ARTWORK", t.description.template)
	description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", t.description.offset.x, t.description.offset.y)
	description:SetText(t.description.text)
	return title, description
end
--[[Parameters:

]]
local function SetUpCategory(frame, anchor, relativeTo, relativePoint, offsetX, offsetY, width, height, title, description)
	--Preferences
	if relativeTo == nil then
		frame:SetPoint(anchor, offsetX, offsetY)
	else
		frame:SetPoint(anchor, relativeTo, relativePoint, offsetX, offsetY)
	end
	frame:SetSize(width, height)
	frame:SetBackdrop({
		bgFile = "Interface/ChatFrame/ChatFrameBackground",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 5, edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	frame:SetBackdropColor(0, 0, 0, 0.3)
	frame:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8)
	--Add title and description
	SetUpTitle(frame, {
		title = {
			text = title,
			offset = {x = 10, y = 16},
			template = "GameFontNormal",
		},
		description = {
			text = description,
			offset = {x = 4, y = -16},
			template = "GameFontHighlightSmall",
		},
	})
end
--[[Parameters:

]]
local function SetUpButton(button, anchor, relativeTo, relativePoint, offsetX, offsetY, width, label, tooltip, onClick)
	--Preferences
	if relativeTo == nil then
		button:SetPoint(anchor, offsetX, offsetY)
	else
		button:SetPoint(anchor, relativeTo, relativePoint, offsetX, offsetY)
	end
	getglobal(button:GetName() .. "Text"):SetText(label)
	if button:GetObjectType() == "CheckButton" then
		getglobal(button:GetName() .. "Text"):SetFontObject("GameFontHighlight") --Different font for checkboxes
		button.tooltipRequirement = tooltip
	else
		button:SetWidth(width) --Custom width for simple buttons
		label = tooltip
	end
	button.tooltipText = label
	--Event handlers
	button:SetScript("OnClick", onClick)
end
--[[Parameters:

]]
local function SetUpSliderValueBox(valueBox, slider, valueMin, valueMax, valueStep)
	--Preferences
	valueBox:SetPoint("TOP", slider, "BOTTOM", 0, 0)
	valueBox:SetSize(60, 14)
	valueBox:SetBackdrop({
		bgFile = "Interface/ChatFrame/ChatFrameBackground",
		edgeFile = "Interface/ChatFrame/ChatFrameBackground",
		tile = true, tileSize = 5, edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	valueBox:SetBackdropColor(0, 0, 0, 0.5)
	valueBox:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8)
	valueBox:SetFontObject("GameFontHighlightSmall")
	valueBox:SetJustifyH("CENTER")
	valueBox:SetMaxLetters(string.len(tostring(valueMax))+2)
	valueBox:SetAutoFocus(false)
	--Event handlers
	valueBox:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0.7, 0.7, 0.7, 0.8)
	end)
	valueBox:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8)
	end)
	valueBox:SetScript("OnEscapePressed", function(self)
		self:SetText(slider:GetValue())
		self:ClearFocus()
	end)
	valueBox:SetScript("OnEnterPressed", function(self)
		local value = max(valueMin, min(valueMax, floor(self:GetNumber() * (1 / valueStep) + 0.5) / (1 / valueStep)))
		slider:SetValue(value)
		self:SetText(value)
		self:ClearFocus()
	end)
	valueBox:SetScript("OnChar", function(self)
		if math.floor(valueMin) == valueMin and math.floor(valueMax) == valueMax and math.floor(valueStep) == valueStep then
			self:SetText(self:GetText():gsub("[^%d]", ""))
		else
			self:SetText(self:GetText():gsub("[^%.%d]+", ""):gsub("(%..*)%.", "%1"))
		end
	end)
	slider:HookScript("OnValueChanged", function(self, value)
		valueBox:SetText(value)
	end)
end
--[[Parameters:

]]
local function SetUpSlider(slider, anchor, relativeTo, relativePoint, offsetX, offsetY, label, tooltip, valueMin, valueMax, valueStep, OnValueChanged)
	--Preferences
	if relativeTo == nil then
		slider:SetPoint(anchor, offsetX, offsetY)
	else
		slider:SetPoint(anchor, relativeTo, relativePoint, offsetX, offsetY)
	end
	getglobal(slider:GetName() .. "Text"):SetFontObject("GameFontNormal")
	getglobal(slider:GetName() .. "Text"):SetText(label)
	getglobal(slider:GetName() .. "Low"):SetText(tostring(valueMin))
	getglobal(slider:GetName() .. "High"):SetText(tostring(valueMax))
	slider.tooltipText = label
	slider.tooltipRequirement = tooltip
	slider:SetMinMaxValues(valueMin, valueMax)
	slider:SetObeyStepOnDrag(true)
	slider:SetValueStep(valueStep)
	--Event handlers
	slider:SetScript("OnValueChanged", OnValueChanged)
	--Add and set up the value box
	local valueBox = CreateFrame("EditBox", "SliderFontSizeValueBox", slider, BackdropTemplateMixin and "BackdropTemplate")
	SetUpSliderValueBox(valueBox, slider, valueMin, valueMax, valueStep)
end


--[[ GUI OPTIONS ]]

--Set up GUI options
local function SetUpInterfaceOptions()
	local title local description = SetUpTitle(optionsPanel, {
		title = {
			text = strings.addon,
			offset = {x = 16, y= -16},
			template = "GameFontNormalLarge",
		},
		description = {
			text = strings.options.description,
			offset = {x = 0, y= -8},
			template = "GameFontHighlightSmall",
		},
	})
	--Category panels
	local optionsWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 32
	SetUpCategory(options.position.frame, "TOPLEFT", description, "BOTTOMLEFT", 0, -48, optionsWidth, 64, strings.options.position.title, strings.options.position.description)
	SetUpCategory(options.visibility.frame, "TOPLEFT", options.position.frame, "BOTTOMLEFT", 0, -32, optionsWidth, 64, strings.options.visibility.title, strings.options.visibility.description)
	SetUpCategory(options.font.frame, "TOPLEFT", options.visibility.frame, "BOTTOMLEFT", 0, -32, optionsWidth, 86, strings.options.font.title, strings.options.font.description)
	--Button Save position
	SetUpButton(options.position.save, "TOPLEFT", nil, nil, 10, -32, 120, strings.options.position.save.label, strings.options.position.save.tooltip, function()
		SavePosition()
	end)
	--Button: Reset position
	SetUpButton(options.position.reset, "TOPRIGHT", nil, nil, -134, -32, 120, strings.options.position.reset.label, strings.options.position.reset.tooltip, function()
		ResetPosition()
	end)
	--Button Reset default position
	SetUpButton(options.position.default, "TOPRIGHT", nil, nil, -10, -32, 120, strings.options.position.default.label, strings.options.position.default.tooltip, function()
		DefaultPreset()
	end)
	--Checkbox: Hidden
	SetUpButton(options.visibility.hidden, "TOPLEFT", nil, nil, 10, -32, nil, strings.options.visibility.hidden.label, strings.options.visibility.hidden.tooltip, function()
		FlipVisibility(options.visibility.hidden:GetChecked())
	end)
	--Slider: Font size
	SetUpSlider(options.font.size, "TOPLEFT", nil, nil, 16, -44, strings.options.font.size.label, strings.options.font.size.tooltip, 8, 64, 1, function()
		textDisplay:SetFont(db.font.family, options.font.size:GetValue(), "THINOUTLINE")
	end)
end
--Interface options event handlers
local function Save()
	db.hidden = not textDisplay:IsShown();
	db.font.size = options.font.size:GetValue();
end
local function Cancel()
	SetDisplayValues()
end
local function Default()
	MovementSpeedDB = defaultDB
	db = Clone(defaultDB)
	SetDisplayValues()
	print(colors.sg .. strings.addon .. ": " .. colors.ly .. strings.options.defaults)
end
local function Refresh()
	options.visibility.hidden:SetChecked(db.hidden)
	options.font.size:SetValue(db.font.size)
end


--[[ DISPLAY FRAME SETUP ]]

--Set frame parameters
local function SetFrameParameters()
	--Main frame
	movSpeed:SetFrameStrata("HIGH")
	movSpeed:SetFrameLevel(0)
	movSpeed:SetSize(32, 10)
	if not movSpeed:IsUserPlaced() then
		movSpeed:ClearAllPoints()
		movSpeed:SetPoint(defaultDB.position.point, defaultDB.position.offset.x, defaultDB.position.offset.y)
		movSpeed:SetUserPlaced(true)
	end
	--Text display
	textDisplay:SetPoint("CENTER")
	SetDisplayValues()
end

--Making the frame moveable
movSpeed:SetMovable(true)
movSpeed:SetScript("OnMouseDown", function(self)
	if (IsShiftKeyDown() and not self.isMoving) then
		movSpeed:StartMoving()
		self.isMoving = true
	end
end)
movSpeed:SetScript("OnMouseUp", function(self)
	if (self.isMoving) then
		movSpeed:StopMovingOrSizing()
		self.isMoving = false
	end
end)


--[[ INITIALIZATION ]]

--Check and fix the DB
local oldData = {};
local function AddItems(dbToCheck, dbToSample) --Check for and fill in missing data
	if type(dbToCheck) ~= "table"  and type(dbToSample) ~= "table" then return end
	for k,v in pairs(dbToSample) do
		if dbToCheck[k] == nil then
			dbToCheck[k] = v;
		else
			AddItems(dbToCheck[k], dbToSample[k])
		end
	end
end
local function RemoveItems(dbToCheck, dbToSample) --Remove unused or outdated data while trying to keep any old data
	if type(dbToCheck) ~= "table"  and type(dbToSample) ~= "table" then return end
	for k,v in pairs(dbToCheck) do
		if dbToSample[k] == nil then
			oldData[k] = v;
			dbToCheck[k] = nil;
		else
			RemoveItems(dbToCheck[k], dbToSample[k])
		end
	end
end
local function RestoreOldData() --Restore old data to the DB
	for k,v in pairs(oldData) do
		if k == "offsetX" then
			db.position.offset.x = v
		elseif k == "offsetY" then
			db.position.offset.y = v
		end
	end
end

--Initialization
local function LoadDB()
	--First load
	if MovementSpeedDB == nil then
		MovementSpeedDB = defaultDB
		PrintHelp()
	end
	--Load the DB
	db = MovementSpeedDB
	AddItems(db, defaultDB) --Check for missing data
	RemoveItems(db, defaultDB) --Remove unneeded data
	RestoreOldData() --Save old data
end
local function LoadInterfaceOptions()
	optionsPanel.name = strings.addon;
	--Set event handlers
	optionsPanel.okay = function() Save() end
	optionsPanel.cancel = function() Cancel() end --refresh is called automatically
	optionsPanel.default = function() Default() end --refresh is called automatically
	optionsPanel.refresh = function() Refresh() end
	--Add the panel
	InterfaceOptions_AddCategory(optionsPanel);
end
function movSpeed:ADDON_LOADED(addon)
	if addon == "MovementSpeed" then
		movSpeed:UnregisterEvent("ADDON_LOADED")
		--Load and check the DB
		LoadDB()
		--Set up the UI  frame & text
		SetFrameParameters()
		--Set up Interface options
		LoadInterfaceOptions()
		SetUpInterfaceOptions()
	end
end
function movSpeed:PLAYER_LOGIN()
	if not textDisplay:IsShown() then
		print(colors.sg .. strings.addon .. ": " .. colors.ly .. strings.chat.hide.response)
	end
end


--[[ DISPLAY UPDATE ]]

--Recalculate the movement speed value and update the displayed text
local function UpdateSpeed()
	local unit = "player";
	if  UnitInVehicle("player") then
		unit = "vehicle"
	end
	textDisplay:SetText(string.format("%d%%", math.floor(GetUnitSpeed(unit) / 7 * 100 + .5)))
end
movSpeed:SetScript("OnUpdate", function(self)
	UpdateSpeed()
end)