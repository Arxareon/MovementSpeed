--Addon name, namespace
local addonNameSpace, ns = ...
local _, addon = GetAddOnInfo(addonNameSpace)


--[[ STRINGS & LOCALIZATION ]]

local strings = {}

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
		offset = { x = -68, y = -179 },
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


--[[ FRAMES & EVENTS ]]

--Create the main frame, text display and options panel
local movSpeed = CreateFrame("Frame", "MovementSpeed", UIParent)
local textDisplay = movSpeed:CreateFontString("MovementSpeedTextDisplay", "HIGH")
local optionsPanel = CreateFrame("Frame", "MovementSpeedOptions", InterfaceOptionsFramePanelContainer)
local options = { visibility = {}, font =  {} }

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
	print(colors.sg .. addon .. ":" .. colors.ly .. " " .. strings.chat.reset.response)
end
local function SavePosition()
	local x local y db.position.point, x, y, db.position.offset.x, db.position.offset.y = movSpeed:GetPoint()
	print(colors.sg .. addon .. ":" .. colors.ly .. " " .. strings.chat.save.response)
end
local function DefaultPreset()
	db.position = defaultDB.position
	print(colors.sg .. addon .. ":" .. colors.ly .. " " .. strings.chat.default.response)
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
	print(colors.sg .. addon .. ": " .. colors.ly .. visibility)
end
local function PrintHelp()
	print(colors.sy .. strings.chat.help.thanks:gsub("#", colors.sg .. addon .. colors.sy))
	PrintStatus()
	print(colors.ly .. strings.chat.help.hint:gsub("#", colors.lg .. keyword .. " " .. strings.chat.help.command .. colors.ly))
	print(colors.ly .. strings.chat.help.move:gsub("#", colors.lg .. "SHIFT" .. colors.ly))
end
local function PrintCommands()
	PrintStatus()
	print(colors.sg .. addon .. colors.ly .. " ".. strings.chat.help.list .. ":")
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
			print(colors.sg .. addon .. ": " .. colors.ly .. strings.chat.size.response:gsub("#", size))
		else
			print(colors.sg .. addon .. ": " .. colors.ly .. strings.chat.size.unchanged)
			print(colors.ly .. strings.chat.size.error:gsub("#", colors.lg .. strings.chat.size.command .. defaultDB.font.size .. colors.ly))
		end
	else
		PrintHelp()
	end
end


--[[ GUI ELEMENT SETTERS ]]

---Add a title and an optional description to an options frame
---@param t table Parameters are to be provided in this table
--- - **frame**: *[Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)* ― The frame panel to add the title and (optional) description to
--- - **title**: *table*
--- 	- **text**: *string* ― Text to be shown as the main title of the frame
--- 	- **offset**: *table* ― The offset from the TOPLEFT point of the specified frame
--- 		- **x**: *number* ― Horizontal offset value
--- 		- **y**: *number* ― Vertical offset value
--- 	- **template**: *string* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
--- - **description**?: *table* [optional]
--- 	- **text**: *string* ― Text to be shown as the subtitle/description of the frame
--- 	- **offset**: *table* ― The offset from the BOTTOMLEFT point of the main title [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
--- 		- **x**: *number* ― Horizontal offset value
--- 		- **y**: *number* ― Vertical offset value
--- 	- **template**: *string* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
---@return string|table title
---@return string|table? description
local function AddTitle(t)
	--Title
	local title = t.frame:CreateFontString(t.frame:GetName() .. "Title", "ARTWORK", t.title.template)
	title:SetPoint("TOPLEFT", t.title.offset.x, t.title.offset.y)
	title:SetText(t.title.text)
	if t.description == nil then
		return title
	end
	--Description
	local description = t.frame:CreateFontString(t.frame:GetName() .. "Description", "ARTWORK", t.description.template)
	description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", t.description.offset.x, t.description.offset.y)
	description:SetText(t.description.text)
	return title, description
end
---Create a new frame as an options category
---@param t table Parameters are to be provided in this table
--- - **parent**: *[Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)* — The main options frame to set as the parent of the new category
--- - **position**: *table* — Collection of parameters to call [Frame:SetPoint](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor**: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)*
--- 	- **relativeTo**?: *[Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)* [optional]
--- 	- **relativePoint**?: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)* [optional]
--- 	- **offset**: *table*
--- 		- **x**: *number*
--- 		- **y**: *number*
--- - **size**: *table*
--- 	- **width**: *number*
--- 	- **height**: *number*
--- - **title**: *string* — Text to be shown as the main title of the category
--- - **description**?: *string* [optional] — Text to be shown as the subtitle/description of the category
---@return Frame category
local function CreateCategory(t)
	local category = CreateFrame("Frame", t.parent:GetName() .. t.title:gsub("%s+", ""), t.parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	--Position & dimensions
	if t.position.relativeTo == nil then
		category:SetPoint(t.position.anchor, t.position.offset.x, t.position.offset.y)
	else
		category:SetPoint(t.position.anchor, t.position.relativeTo, t.position.relativePoint, t.position.offset.x, t.position.offset.y)
	end
	category:SetSize(t.size.width, t.size.height)
	--Art
	category:SetBackdrop({
		bgFile = "Interface/ChatFrame/ChatFrameBackground",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 5, edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	category:SetBackdropColor(0, 0, 0, 0.3)
	category:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8)
	--Title & description
	AddTitle({
		frame = category,
		title = {
			text = t.title,
			offset = {x = 10, y = 16},
			template = "GameFontNormal",
		},
		description = {
			text = t.description,
			offset = {x = 4, y = -16},
			template = "GameFontHighlightSmall",
		},
	})
	return category
end
---Create a button or checkbox frame as a child of an options frame
---@param t table Parameters are to be provided in this table
--- - **parent**: *[Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)* — The frame to set as the parent of the new button
--- - **checkbox**?: *any* [optional] — Set to any value when the frame type should be [CheckButton](https://wowpedia.fandom.com/wiki/UIOBJECT_CheckButton) insted of the default [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button) when the value nil (not set)
--- - **position**: *table* — Collection of parameters to call [Frame:SetPoint](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor**: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)*
--- 	- **relativeTo**?: *[Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* [optional]
--- 	- **relativePoint**?: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)* [optional]
--- 	- **offset**: *number*
--- 		- **x**: *number*
--- 		- **y**: *number*
--- - **width**: *number* — Horizontal size for [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button) type frames (not applicable for [CheckButton](https://wowpedia.fandom.com/wiki/UIOBJECT_CheckButton) types)
--- - **label**: *string* — Title text to be shown on the button and as the the tooltip label
--- - **tooltip**: *string* — Text to be shown as the tooltip of the button
--- - **onClick**: *function* — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
---@return Button button
local function CreateButton(t)
	local button
	if t.checkbox == nil then
		button = CreateFrame("Button", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Checkbox", t.parent, "UIPanelButtonTemplate")
	else
		button = CreateFrame("CheckButton", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Button", t.parent, "InterfaceOptionsCheckButtonTemplate")
	end
	--Position
	if t.position.relativeTo == nil then
		button:SetPoint(t.position.anchor, t.position.offset.x, t.position.offset.y)
	else
		button:SetPoint(t.position.anchor, t.position.relativeTo, t.position.relativePoint, t.position.offset.x, t.position.offset.y)
	end
	--Font & dimensions
	getglobal(button:GetName() .. "Text"):SetText(t.label)
	if button:GetObjectType() == "CheckButton" then
		getglobal(button:GetName() .. "Text"):SetFontObject("GameFontHighlight") --Different font for checkboxes
	else
		button:SetWidth(t.width) --Custom width for simple buttons
		t.label = t.tooltip --TODO: Remove line and fix not showing up on the tooltip for regular buttons
	end
	--Tooltip
	button.tooltipRequirement = t.tooltip
	button.tooltipText = t.label
	--Event handlers
	button:SetScript("OnClick", t.onClick)
	button:HookScript("OnClick", function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end)
	return button
end
---Add a value box as a child to an existing slider frame
---@param t table
--- - **parent**: *[Slider](https://wowpedia.fandom.com/wiki/UIOBJECT_Slider)* — The frame of "Slider" type to set as the parent frame
--- - **value**: *table*
--- 	- **min**: *number* — Lower numeric value limit of the slider
--- 	- **max**: *number* — Uppare numeric value limit of the slider
--- 	- **step**: *number* — Numeric value step of the slider
---@return EditBox valueBox
local function AddSliderValueBox(t)
	local valueBox = CreateFrame("EditBox", t.parent:GetName() .. "ValueBox", t.parent, BackdropTemplateMixin and "BackdropTemplate")
	--Position & dimensions
	valueBox:SetPoint("TOP", t.parent, "BOTTOM", 0, 0)
	valueBox:SetSize(60, 14)
	--Art
	valueBox:SetBackdrop({
		bgFile = "Interface/ChatFrame/ChatFrameBackground",
		edgeFile = "Interface/ChatFrame/ChatFrameBackground",
		tile = true, tileSize = 5, edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	valueBox:SetBackdropColor(0, 0, 0, 0.5)
	valueBox:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8)
	--Font
	valueBox:SetFontObject("GameFontHighlightSmall")
	valueBox:SetJustifyH("CENTER")
	valueBox:SetMaxLetters(string.len(tostring(t.value.max)))
	--Behaviour
	valueBox:SetAutoFocus(false)
	--Event handlers
	valueBox:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0.7, 0.7, 0.7, 0.8)
	end)
	valueBox:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8)
	end)
	valueBox:SetScript("OnEscapePressed", function(self)
		self:SetText(t.parent:GetValue())
		self:ClearFocus()
	end)
	valueBox:SetScript("OnEnterPressed", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		local value = max(t.value.min, min(t.value.max, floor(self:GetNumber() * (1 / t.value.step) + 0.5) / (1 / t.value.step)))
		t.parent:SetValue(value)
		self:SetText(value)
		self:ClearFocus()
	end)
	valueBox:SetScript("OnChar", function(self)
		if math.floor(t.value.min) == t.value.min and math.floor(t.value.max) == t.value.max and math.floor(t.value.step) == t.value.step then
			self:SetText(self:GetText():gsub("[^%d]", ""))
		else
			self:SetText(self:GetText():gsub("[^%.%d]+", ""):gsub("(%..*)%.", "%1"))
		end
	end)
	t.parent:HookScript("OnValueChanged", function(self, value)
		valueBox:SetText(value) --TODO: Fix text being out of bounds to the left on first text load
	end)
	return valueBox
end
---Create a new slider frame as a child of an options frame
---@param t table
--- - **parent**: *[Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)* — The frame to set as the parent of the new slider
--- - **position**: *table* — Collection of parameters to call [Frame:SetPoint](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor**: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)*
--- 	- **relativeTo**?: *[Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* [optional]
--- 	- **relativePoint**?: *[Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)* [optional]
--- 	- **offset**: *table*
--- 		- **x**: *number*
--- 		- **y**: *number*
--- - **label**: *string* — Title text to be shown above the slider and as the the tooltip label
--- - **tooltip**: *string* — Text to be shown as the tooltip of the slider
--- - **value**: *table*
--- 	- **min**: *number* — Lower numeric value limit
--- 	- **max**: *number* — Uppare numeric value limit
--- 	- **step**: *number* — Numeric value step
--- - **valueBox**?: *boolean* [optional] — Set to false when the frame type should NOT have an [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) added as a child frame
--- - **onValueChanged**: *function* — The function to be called when an [OnValueChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnValueChanged) event happens
---@return Slider slider
---@return EditBox? valueBox
local function CreateSlider(t)
	local slider = CreateFrame("Slider", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Slider", t.parent, "OptionsSliderTemplate")
	--Position & dimensions
	if t.position.relativeTo == nil then
		slider:SetPoint(t.position.anchor, t.position.offset.x, t.position.offset.y)
	else
		slider:SetPoint(t.position.anchor, t.position.relativeTo, t.position.relativePoint, t.position.offset.x, t.position.offset.y)
	end
	--Font
	getglobal(slider:GetName() .. "Text"):SetFontObject("GameFontNormal")
	getglobal(slider:GetName() .. "Text"):SetText(t.label)
	getglobal(slider:GetName() .. "Low"):SetText(tostring(t.value.min))
	getglobal(slider:GetName() .. "High"):SetText(tostring(t.value.max))
	--Tooltip
	slider.tooltipText = t.label
	slider.tooltipRequirement = t.tooltip
	--Value
	slider:SetMinMaxValues(t.value.min, t.value.max)
	slider:SetValueStep(t.value.step)
	slider:SetObeyStepOnDrag(true)
	--Event handlers
	slider:SetScript("OnValueChanged", t.onValueChanged)
	slider:HookScript("OnMouseUp", function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end)
	--Value box
	if t.valueBox == false then
		return slider
	end
	local valueBox = AddSliderValueBox({ parent = slider, value = { min = t.value.min, max = t.value.max, step = t.value.step } })
	return slider, valueBox
end


--[[ GUI OPTIONS ]]

--Set up GUI options
local function SetUpInterfaceOptions()
	local title local description = AddTitle({
		frame = optionsPanel,
		title = {
			text = addon,
			offset = { x = 16, y= -16 },
			template = "GameFontNormalLarge"
		},
		description = {
			text = strings.options.description,
			offset = { x = 0, y= -8 },
			template = "GameFontHighlightSmall"
		}
	})
	--Category panels
	local optionsWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 32
	local positionOptions = CreateCategory({
		parent = optionsPanel,
		position = {
			anchor = "TOPLEFT",
			relativeTo = description,
			relativePoint = "BOTTOMLEFT",
			offset = { x = 0, y = -48 }
		},
		size = { width = optionsWidth, height = 64 },
		title = strings.options.position.title,
		description = strings.options.position.description
	})
	local visibilityOptions = CreateCategory({
		parent = optionsPanel,
		position = {
			anchor = "TOPLEFT",
			relativeTo = positionOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { x = 0, y = -32 }
		},
		size = { width = optionsWidth, height = 64 },
		title = strings.options.visibility.title,
		description = strings.options.visibility.description
	})
	local fontOptions = CreateCategory({
		parent = optionsPanel,
		position = {
			anchor = "TOPLEFT",
			relativeTo = visibilityOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { x = 0, y = -32 }
		},
		size = { width = optionsWidth, height = 86 },
		title = strings.options.font.title,
		description = strings.options.font.description
	})
	--Button: Save preset position
	CreateButton({
		parent = positionOptions,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 10, y = -32 }
		},
		width = 120,
		label = strings.options.position.save.label,
		tooltip = strings.options.position.save.tooltip,
		onClick = function()
			SavePosition()
		end
	})
	--Button: Reset preset position
	CreateButton({
		parent = positionOptions,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -134, y = -32 }
		},
		width = 120,
		label = strings.options.position.reset.label,
		tooltip = strings.options.position.reset.tooltip,
		onClick = function()
			ResetPosition()
		end
	})
	--Button: Reset default preset position
	CreateButton({
		parent = positionOptions,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -32 }
		},
		width = 120,
		label = strings.options.position.default.label,
		tooltip = strings.options.position.default.tooltip,
		onClick = function()
			DefaultPreset()
		end
	})
	--Checkbox: Hidden
	options.visibility.hidden = CreateButton({
		parent = visibilityOptions,
		checkbox = true,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 10, y = -32 }
		},
		width = 120,
		label = strings.options.visibility.hidden.label,
		tooltip = strings.options.visibility.hidden.tooltip,
		onClick = function(self)
			FlipVisibility(self:GetChecked())
		end
	})
	--Slider: Font size
	options.font.size = CreateSlider({
		parent = fontOptions,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 16, y = -44 }
		},
		label = strings.options.font.size.label,
		tooltip = strings.options.font.size.tooltip,
		value = { min = 8, max = 64, step = 1 },
		onValueChanged = function(self)
			textDisplay:SetFont(db.font.family, self:GetValue(), "THINOUTLINE")
		end
	})
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
	print(colors.sg .. addon .. ": " .. colors.ly .. strings.options.defaults)
end
local function Refresh()
	options.visibility.hidden:SetChecked(db.hidden)
	options.font.size:SetValue(db.font.size)
end

--Add the options to the WoW Interface
local function LoadInterfaceOptions()
	optionsPanel.name = addon;
	--Set event handlers
	optionsPanel.okay = function() Save() end
	optionsPanel.cancel = function() Cancel() end --refresh is called automatically
	optionsPanel.default = function() Default() end --refresh is called automatically
	optionsPanel.refresh = function() Refresh() end
	--Add the panel
	InterfaceOptions_AddCategory(optionsPanel);
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
		print(colors.sg .. addon .. ": " .. colors.ly .. strings.chat.hide.response)
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