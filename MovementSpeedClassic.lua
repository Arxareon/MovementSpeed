--DB tables, defaults & management utilities
local db --account-wide
local defaultDB = {
	position = {
		point = "TOPRIGHT",
		offset = {
			x = -68,
			y = -179,
		},
	},
	hidden = false,
	font = {
		family = "Fonts\\FRIZQT__.TTF",
		size = 11,
	},
}
local function dump(object)
	if type(object) == "table" then
		for k, v in pairs(object) do
			dump(v)
		end
	else
		print(object)
	end
end
local function clone(table)
	local copy = {}
	for k, v in pairs(table) do
		if type(v) == "table" then
			v = clone(v)
		end
		copy[k] = v
	end
	return copy
end

--String Colors
local colors = {
	lg = "|cFF" .. "8FD36E", --light green
	sg = "|cFF" .. "4ED836", --strong green
	ly = "|cFF" .. "FFFB99", --light yellow
	sy = "|cFF" .. "FFDD47", --strong yellow
}

--Strings
local strings = {
	addon = "Movement Speed",
	settingsDescription = "Customize Movement Speed to fit your needs. Type /movespeed for chat commands.",
	position = {
		title = "Position",
		description = "Hold SHIFT to drag the text display anywhere on the screen.",
	},
	visibility = {
		title = "Visibility",
		description = "Set the visibility of Movement Speed.",
	},
	font = {
		title = "Font",
		description = "Customize the font of the speed percentage text display.",
	},
	save = {
		label = "Save position",
		tooltip = "Save the current position of the text display as the preset location.",
	},
	reset = {
		label = "Reset position",
		tooltip = "Reset the position of the text display to the specified preset location.",
	},
	default = {
		label = "Default preset",
		tooltip = "Restore the default preset location of the text display.",
	},
	hidden = {
		label = "Hidden",
		tooltip = "Hide or show the Movement Speed text display.",
	},
	fontSize = {
		label = "Font size",
		tooltip = "Specify the font size of the displayed percentage value.\nDefault: 11",
	},
}

--Slash keyword and commands
local keyword = "/movespeed"
local commands = {
	["0help"] = {
		name = "help",
		description = "see the full command list",
	},
	["1resetPosition"] = {
		name = "reset",
		description = "set location to the specified preset location",
	},
	["2savePreset"] = {
		name = "save",
		description = "save the current location as the preset location",
	},
	["3defaultPreset"] = {
		name = "default",
		description = "set the preset location to the default location",
	},
	["4hideDisplay"] = {
		name = "hide",
		description = "hide the text display",
	},
	["5showDisplay"] = {
		name = "show",
		description = "show the text display",
	},
	["6fontSize"] = {
		name = "size",
		description = "change the font size (e.g. " .. colors.lg .. "size " .. defaultDB.font.size .. colors.ly .. ")",
	},
}

--Create the main frame & options panel and their elements
local movSpeed = CreateFrame("Frame", "MovementSpeed", UIParent)
local textDisplay = movSpeed:CreateFontString("TextDisplay", "HIGH")
local optionsPanel = CreateFrame("Frame", "MovementSpeedOptions", InterfaceOptionsFramePanelContainer)
local options = {
	position = {
		frame = CreateFrame("Frame", "PositionOptions", optionsPanel, "OptionsBoxTemplate"),
	},
	visibility = {
		frame = CreateFrame("Frame", "VisibilityOptions", optionsPanel, "OptionsBoxTemplate"),
	},
	font = {
		frame = CreateFrame("Frame", "FontOptions", optionsPanel, "OptionsBoxTemplate"),
	},
}
options.position.save = CreateFrame("Button", "ButtonSave", options.position.frame, "OptionsButtonTemplate")
options.position.reset = CreateFrame("Button", "ButtonReset", options.position.frame, "OptionsButtonTemplate")
options.position.default = CreateFrame("Button", "ButtonDefault", options.position.frame, "OptionsButtonTemplate")
options.visibility.hidden = CreateFrame("CheckButton", "CheckBoxHidden", options.visibility.frame, "InterfaceOptionsCheckButtonTemplate")
options.font.size = CreateFrame("Slider", "SliderFontSize", options.font.frame, "OptionsSliderTemplate")

--Register events
movSpeed:RegisterEvent("ADDON_LOADED")
movSpeed:RegisterEvent("PLAYER_LOGIN")
movSpeed:SetScript("OnEvent", function(self, event, ...) --Event handler
	return self[event] and self[event](self, ...)
end)

--Positioning utilities
local function ResetPosition()
	movSpeed:ClearAllPoints()
	movSpeed:SetUserPlaced(false)
	movSpeed:SetPoint(db.position.point, db.position.offset.x, db.position.offset.y)
	movSpeed:SetUserPlaced(true)
	print(colors.sg .. strings.addon .. ":" .. colors.ly .. " The location has been set to the preset location.")
end
local function SavePosition()
	local x local y db.position.point, x, y, db.position.offset.x, db.position.offset.y = movSpeed:GetPoint()
	print(colors.sg .. strings.addon .. ":" .. colors.ly .. " The current location was saved as the preset location.")
end
local function DefaultPreset()
	db.position = defaultDB.position
	print(colors.sg .. strings.addon .. ":" .. colors.ly .. " The preset location has been reset to the default location.")
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

--Chat control utilities
local function PrintStatus()
	local visibility
	if textDisplay:IsShown() then visibility = "The text display is visible." else visibility = "The text display is hidden." end
	print(colors.sg .. strings.addon .. ": " .. colors.ly .. visibility)
end
local function PrintHelp()
	print(colors.sy .. "Thank you for using " .. colors.sg .. strings.addon .. colors.sy .. "!")
	PrintStatus()
	print(colors.ly .. "Type " .. colors.lg .. keyword .. " " .. commands["0help"].name .. colors.ly .. " to " .. commands["0help"].description)
	print(colors.ly .. "Hold " .. colors.lg .. "SHIFT" .. colors.ly .. " to drag the Movement Speed display anywhere you like.")
end
local function PrintCommands()
	PrintStatus()
	print(colors.sg .. strings.addon .. colors.ly ..  " chat command list:")
	local temp = {}
	for key in pairs(commands) do table.insert(temp, key) end
	table.sort(temp)
	for n, key in ipairs(temp) do
		if n > 1 then --skip the first item (help command)
			print("    " .. colors.lg .. keyword .. " " .. commands[key].name .. colors.ly .. " - " .. commands[key]["description"])
		end
	end
end

--GUI options utilities
local function SetUpPanelTitle(panel, title, description)
	--Title
	local optionsTitle = panel:CreateFontString(panel:GetName() .. "Title", "ARTWORK", "GameFontNormalLarge")
	optionsTitle:SetPoint("TOPLEFT", 16, -16)
	optionsTitle:SetText(title)
	--Description
	local optionsDescription = panel:CreateFontString(panel:GetName() .. "Description", "ARTWORK", "GameFontHighlightSmall")
	optionsDescription:SetPoint("TOPLEFT", optionsTitle, "BOTTOMLEFT", 0, -8)
	optionsDescription:SetText(description)
	return optionsTitle, optionsDescription
end
local function SetUpCategoryTitle(panel, title, description)
	--Title
	local panelTitle = panel:CreateFontString(panel:GetName() .. "Title", "ARTWORK", "GameFontNormal")
	panelTitle:SetPoint("TOPLEFT", panel, "TOPLEFT", 10, 14)
	panelTitle:SetText(title)
	--Description
	local panelDescription = panel:CreateFontString(panel:GetName() .. "Description", "ARTWORK", "GameFontHighlightSmall")
	panelDescription:SetPoint("TOPLEFT", panel, "TOPLEFT", 10, -8)
	panelDescription:SetText(description)
end
local function SetUpCategory(frame, anchor, relativeTo, relativePoint, offsetX, offsetY, width, height, title, description)
	--Preferences
	if relativeTo == nil then
		frame:SetPoint(anchor, offsetX, offsetY)
	else
		frame:SetPoint(anchor, relativeTo, relativePoint, offsetX, offsetY)
	end
	frame:SetSize(width, height)
	frame:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 16,
		insets = {left = 0, right = 0, top = 0, bottom = 0},
	})
	frame:SetBackdropColor(0.4, 0.4, 0.4, 0.1)
	frame:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
	--Add title and description
	SetUpCategoryTitle(frame, title, description)
end
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
local function SetUpSliderValueBox(valueBox, slider, valueMin, valueMax, valueStep)
	--Preferences
	valueBox:SetPoint("TOP", slider, "BOTTOM", 0, 0)
	valueBox:SetSize(60, 14)
	valueBox:SetBackdrop( { 
		bgFile = "Interface/ChatFrame/ChatFrameBackground",
		edgeFile = "Interface/ChatFrame/ChatFrameBackground", tile = true, tileSize = 5, edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	  });
	valueBox:SetBackdropColor(0, 0, 0, 0.5)
	valueBox:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
	valueBox:SetFontObject("GameFontHighlightSmall")
	valueBox:SetAutoFocus(false)
	valueBox:SetJustifyH("CENTER")
	valueBox:SetMaxLetters(string.len(tostring(valueMax))+2)
	--Event handlers
	valueBox:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.8)
	end)
	valueBox:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
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

--Initialization utilities
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
local function SetUpOptions()
	local title local description = SetUpPanelTitle(optionsPanel, strings.addon, strings.settingsDescription)
	--Category panels
	local optionsWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 32
	SetUpCategory(options.position.frame, "TOPLEFT", description, "BOTTOMLEFT", 0, -48, optionsWidth, 56, strings.position.title, strings.position.description)
	SetUpCategory(options.visibility.frame, "TOPLEFT", options.position.frame, "BOTTOMLEFT", 0, -32, optionsWidth, 56, strings.visibility.title, strings.visibility.description)
	SetUpCategory(options.font.frame, "TOPLEFT", options.visibility.frame, "BOTTOMLEFT", 0, -32, optionsWidth, 80, strings.font.title, strings.font.description)
	--Button Save position
	SetUpButton(options.position.save, "TOPLEFT", nil, nil, 10, -24, 120, strings.save.label, strings.save.tooltip, function ()
		SavePosition()
	end)
	--Button: Reset position
	SetUpButton(options.position.reset, "TOPRIGHT", nil, nil, -134, -24, 120, strings.reset.label, strings.reset.tooltip, function ()
		ResetPosition()
	end)
	--Button Reset default position
	SetUpButton(options.position.default, "TOPRIGHT", nil, nil, -10, -24, 120, strings.default.label, strings.default.tooltip, function ()
		DefaultPreset()
	end)
	--Checkbox: Hidden
	SetUpButton(options.visibility.hidden, "TOPLEFT", nil, nil, 10, -24, nil, strings.hidden.label, strings.hidden.tooltip, function ()
		FlipVisibility(options.visibility.hidden:GetChecked())
	end)
	--Slider: Font size
	SetUpSlider(options.font.size, "TOPLEFT", nil, nil, 16, -38, strings.fontSize.label, strings.fontSize.tooltip, 8, 64, 1, function ()
		textDisplay:SetFont(db.font.family, options.font.size:GetValue(), "THINOUTLINE")
	end)
end

--Interface options utilities
local function Save()
	db.hidden = not textDisplay:IsShown();
	db.font.size = options.font.size:GetValue();
end
local function Cancel() --Refresh() is called automatically
	SetDisplayValues()
end
local function Default() --Refresh() is called automatically
	MovementSpeedDB = defaultDB
	db = clone(defaultDB)
	SetDisplayValues()
	print(colors.sg .. strings.addon .. ": " .. colors.ly .. "The default options have been reset.")
end
local function Refresh()
	options.visibility.hidden:SetChecked(db.hidden)
	options.font.size:SetValue(db.font.size)
end

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
	optionsPanel.okay = function () Save() end
	optionsPanel.cancel = function () Cancel() end
	optionsPanel.default = function () Default() end
	optionsPanel.refresh = function () Refresh() end
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
		SetUpOptions()
	end
end
function movSpeed:PLAYER_LOGIN()
	if not textDisplay:IsShown() then
		print(colors.sg .. strings.addon .. ": " .. colors.ly .. "The text display is hidden.")
	end
end

--Recalculate the movement speed value and update the displayed text
local function UpdateSpeed()
	textDisplay:SetText(string.format("%d%%", math.floor(GetUnitSpeed("player") / 7 * 100 + .5)))
end
movSpeed:SetScript("OnUpdate", function(self)
	UpdateSpeed()
end)

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

--Setting up slash commands
SLASH_MOVESPEED1 = keyword
function SlashCmdList.MOVESPEED(command)
	local name, value = strsplit(" ", command)
	if name == commands["0help"].name then
		PrintCommands()
	elseif name == commands["1resetPosition"].name then
		ResetPosition()
	elseif name == commands["2savePreset"].name then
		SavePosition()
	elseif name == commands["3defaultPreset"].name then
		DefaultPreset()
	elseif name == commands["4hideDisplay"].name then
		db.hidden = true
		textDisplay:Hide()
		PrintStatus()
	elseif name == commands["5showDisplay"].name then
		db.hidden = false
		textDisplay:Show()
		PrintStatus()
	elseif name == commands["6fontSize"].name then
		local size = tonumber(value)
		if size ~= nil then
			db.font.size = size
			textDisplay:SetFont(db.font.family, db.font.size, "THINOUTLINE")
			print(colors.sg .. strings.addon .. ": " .. colors.ly .. "The font size has been set to " .. size .. ".")
		else
			print(colors.sg .. strings.addon .. ": " .. colors.ly .. "The font size was not changed.")
			print(colors.ly .. "Please enter a valid number value (e.g. " .. colors.lg .. "/movespeed size 11" ..  colors.ly .. ").")
		end
	else
		PrintHelp()
	end
end