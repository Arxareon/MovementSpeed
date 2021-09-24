--Addon name, namespace
local addonNameSpace, ns = ...
local _, addon = GetAddOnInfo(addonNameSpace)


--[[ STRINGS & LOCALIZATION ]]

local strings = { options = {}, chat = {}, misc = {} }

--Load localization
local function LoadLocale()
	if (GetLocale() == "") then
		--TODO: add support for other languages (locales: https://wowwiki-archive.fandom.com/wiki/API_GetLocale#Locales)
	else strings = ns.english end--English (UK & US)
end
LoadLocale()

--Color palette for string formatting
local colors = {
	lg = "|cFF" .. "8FD36E", --light green
	sg = "|cFF" .. "4ED836", --strong green
	ly = "|cFF" .. "FFFB99", --light yellow
	sy = "|cFF" .. "FFDD47", --strong yellow
}

--Fonts
local fonts = {
	[0] = { text = "Default", path = strings.options.font.family.default },
}


--[[ DB TABLES ]]

local db --account-wide
local defaultDB = {
	position = {
		point = "TOPRIGHT",
		offset = { x = -68, y = -179 },
	},
	visibility = {
		hidden = false,
		frameStrata = "MEDIUM",
	},
	font = {
		family = fonts[0].path,
		size = 11,
	},
}

--Table management utilities
local function Dump(object)
	if type(object) == "table" then
		for _, v in pairs(object) do
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
local textDisplay = movSpeed:CreateFontString("MovementSpeedTextDisplay", "OVERLAY")
local optionsPanel = CreateFrame("Frame", "MovementSpeedOptions", InterfaceOptionsFramePanelContainer)
local options = { visibility = {}, font = {} }

--Register events
movSpeed:RegisterEvent("ADDON_LOADED")
movSpeed:RegisterEvent("PLAYER_LOGIN")
movSpeed:RegisterEvent("PET_BATTLE_OPENING_START")
movSpeed:RegisterEvent("PET_BATTLE_CLOSE")
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
	db.position.point, _, _, db.position.offset.x, db.position.offset.y = movSpeed:GetPoint()
	print(colors.sg .. addon .. ":" .. colors.ly .. " " .. strings.chat.save.response)
end
local function DefaultPreset()
	db.position = Clone(defaultDB.position)
	print(colors.sg .. addon .. ":" .. colors.ly .. " " .. strings.chat.default.response)
end

---Set the visibility of the text display frame based on the flipped value of the input parameter
---@param visible boolean
local function FlipVisibility(visible)
	if visible then
		movSpeed:Hide()
	else
		movSpeed:Show()
	end
end
--Find the ID of the font provided
local function GetFontID(font)
	local selectedFont = 0
	for i = 0, #fonts do
		if fonts[i] == font then
			selectedFont = i
			break
		end
	end
	return selectedFont
end
--Set the visibility and the font family, size and color of the textDisplay
local function SetDisplayValues()
	FlipVisibility(db.visibility.hidden)
	textDisplay:SetFont(db.font.family, db.font.size, "THINOUTLINE")
	textDisplay:SetTextColor(1,1,1,1)
end


--[[ CHAT CONTROL ]]

local keyword = "/movespeed"

--Print utilities
local function PrintStatus()
	local visibility
	if movSpeed:IsShown() then
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
		db.visibility.hidden = true
		movSpeed:Hide()
		PrintStatus()
	elseif command == strings.chat.show.command then
		db.visibility.hidden = false
		movSpeed:Show()
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


--[[ GUI WIDGET CONSTRUCTORS & SETTERS ]]

---Set the position and anchoring of a frame when it is unknown which parameters will be nil when calling [Region:SetPoint()](https://wowpedia.fandom.com/wiki/API_Region_SetPoint)
---@param frame FrameType
---@param anchor AnchorPoint Base anchor point
---@param relativeTo FrameType (Default: parent frame or the entire screen)
---@param relativePoint AnchorPoint (Default: *anchor*)
---@param offsetX number (Default: 0)
---@param offsetY number (Default: 0)
local function PositionFrame(frame, anchor, relativeTo, relativePoint, offsetX, offsetY)
	if (relativeTo == nil or relativePoint == nil) and (offsetX == nil or offsetY == nil) then
		frame:SetPoint(anchor)
	elseif relativeTo == nil or relativePoint == nil then
		frame:SetPoint(anchor, offsetX, offsetY)
	elseif offsetX == nil or offsetY == nil then
		frame:SetPoint(anchor, relativeTo, relativePoint)
	else
		frame:SetPoint(anchor, relativeTo, relativePoint, offsetX, offsetY)
	end
end
---Add a title and an optional description to an options frame
---@param t table Parameters are to be provided in this table
--- - **frame**: *[FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* ― The frame panel to add the title and (optional) description to
--- - **title**: *table*
--- 	- **text**: *string* ― Text to be shown as the main title of the frame
--- 	- **offset**?: *table* [optional] ― The offset from the TOPLEFT point of the specified frame
--- 		- **x**: *number* ― Horizontal offset value
--- 		- **y**: *number* ― Vertical offset value
--- 	- **template**: *string* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
--- - **description**?: *table* [optional]
--- 	- **text**: *string* ― Text to be shown as the subtitle/description of the frame
--- 	- **offset**?: *table* [optional] ― The offset from the BOTTOMLEFT point of the main title [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
--- 		- **x**: *number* ― Horizontal offset value
--- 		- **y**: *number* ― Vertical offset value
--- 	- **template**: *string* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
---@return string|table title
---@return string|table? description
local function AddTitle(t)
	--Title
	local title = t.frame:CreateFontString(t.frame:GetName() .. "Title", "ARTWORK", t.title.template)
	title:SetPoint("TOPLEFT", (t.title.offset or _).x, (t.title.offset or _).y)
	title:SetText(t.title.text)
	if t.description == nil then return title end
	--Description
	local description = t.frame:CreateFontString(t.frame:GetName() .. "Description", "ARTWORK", t.description.template)
	description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", (t.description.offset or _).x, (t.description.offset or _).y)
	description:SetText(t.description.text)
	return title, description
end
---Create a new frame as an options category
---@param t table Parameters are to be provided in this table
--- - **parent**: *[FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* — The main options frame to set as the parent of the new category
--- - **position**: *table* — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor**: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)*
--- 	- **relativeTo**?: *[FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* [optional]
--- 	- **relativePoint**?: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)* [optional]
--- 	- **offset**?: *table* [optional]
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
	PositionFrame(category, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or _).x, (t.position.offset or _).y)
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
			offset = { x = 10, y = 16 },
			template = "GameFontNormal",
		},
		description = {
			text = t.description,
			offset = { x = 4, y = -16 },
			template = "GameFontHighlightSmall",
		},
	})
	return category
end
---Create a button frame as a child of an options frame
---@param t table Parameters are to be provided in this table
--- - **parent**: *[FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* — The frame to set as the parent of the new button
--- - **position**: *table* — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor**: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)*
--- 	- **relativeTo**?: *[Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* [optional]
--- 	- **relativePoint**?: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)* [optional]
--- 	- **offset**?: *table* [optional]
--- 		- **x**: *number*
--- 		- **y**: *number*
--- - **width**?: *number* [optional]
--- - **label**: *string* — Title text to be shown on the button and as the the tooltip label
--- - **tooltip**: *string* — Text to be shown as the tooltip of the button
--- - **onClick**: *function* — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
---@return Button button
local function CreateButton(t)
	local button = CreateFrame("Button", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Button", t.parent, "UIPanelButtonTemplate")
	--Position & dimensions
	PositionFrame(button, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or _).x, (t.position.offset or _).y)
	if t.width ~= nil then button:SetWidth(t.width) end
	--Font
	getglobal(button:GetName() .. "Text"):SetText(t.label)
	--Tooltip
	t.label = t.tooltip --TODO: Remove line and fix not showing up on the tooltip for regular buttons
	button.tooltipText = t.label
	button.tooltipRequirement = t.tooltip
	--Event handlers
	button:SetScript("OnClick", t.onClick)
	button:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
	return button
end
---Create a checkbox frame as a child of an options frame
---@param t table Parameters are to be provided in this table
--- - **parent**: *[FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* — The frame to set as the parent of the new checkbox
--- - **position**: *table* — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor**: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)*
--- 	- **relativeTo**?: *[Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* [optional]
--- 	- **relativePoint**?: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)* [optional]
--- 	- **offset**?: *table* [optional]
--- 		- **x**: *number*
--- 		- **y**: *number*
--- - **label**: *string* — Title text to be shown on the button and as the the tooltip label
--- - **tooltip**: *string* — Text to be shown as the tooltip of the button
--- - **onClick**: *function* — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
---@return CheckButton checkbox
local function CreateCheckbox(t)
	local checkbox = CreateFrame("CheckButton", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Checkbox", t.parent, "InterfaceOptionsCheckButtonTemplate")
	--Position
	PositionFrame(checkbox, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or _).x, (t.position.offset or _).y)
	--Font
	getglobal(checkbox:GetName() .. "Text"):SetFontObject("GameFontHighlight")
	getglobal(checkbox:GetName() .. "Text"):SetText(t.label)
	--Tooltip
	checkbox.tooltipText = t.label
	checkbox.tooltipRequirement = t.tooltip
	--Event handlers
	checkbox:SetScript("OnClick", t.onClick)
	checkbox:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
	return checkbox
end
---Create a popup dialogue with an accept function and cancel button
---comment
---@param t table Parameters are to be provided in this table
--- - **name**: *string* — The name of the action which will call this popup. Each name must be unique between all popups!
--- - **text**: *string* — The text to display as the message in the popup window
--- - **accept**?: *string* [optional] — The text to display as the label of the accept button (Default: *name*)
--- - **cancel**?: *string* [optional] — The text to display as the label of the cancel button (Default: *strings.misc.cancel*)
--- - **onAccept**: *function* — The function to be called when the accept button is pressed and an OnAccept event happens
---@return string key Used as the parameter when calling [StaticPopup_Show()](https://wowwiki-archive.fandom.com/wiki/Creating_simple_pop-up_dialog_boxes#Displaying_the_popup) or [StaticPopup_Hide()](https://wowwiki-archive.fandom.com/wiki/Creating_simple_pop-up_dialog_boxes#Hiding_the_popup)
local function CreatePopup(t)
	local key = "MOVESPEED_" .. string.upper(t.name:gsub("%s+", "_"))
	StaticPopupDialogs[key] = {
		text = t.text,
		button1 = t.accept or t.name,
		button2 = t.cancel or strings.misc.cancel,
		OnAccept = t.onAccept,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = STATICPOPUPS_NUMDIALOGS
	}
	return key
end
---Create an edit box frame as a child of an options frame
---@param t table Parameters are to be provided in this table
--- - **parent**: *[FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* — The frame to set as the parent of the edit box
--- - **position**: *table* — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor**: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)*
--- 	- **relativeTo**?: *[Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* [optional]
--- 	- **relativePoint**?: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)* [optional]
--- 	- **offset**?: *table* [optional]
--- 		- **x**: *number*
--- 		- **y**: *number*
--- - **size**: *table*
--- 	- **width**: *number*
--- 	- **height**?: *number* [optional] — (Default: 17)
--- - **multiline**?: *boolean* [optional] — Set to true if the edit box should be support multiple lines for the string input (false if nil)
--- - **justify**?: *table* [optional] — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
--- 	- **h**?: *string* [optional] — Horizontal: "LEFT"|"RIGHT"|"CENTER" (Default: "LEFT")
--- 	- **v**?: *string* [optional] — Vertical: "TOP"|"BOTTOM"|"MIDDLE" (Default: "MIDDLE")
--- - **maxLetters**?: *number* [optional] — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) (Default: 0 [no limit])
--- - **text**?: *string* [optional] — Text to be shown inside edit box on load
--- - **title**: *string* — Title text to be shown above the edit box
--- - **onEnterPressed**: *function* — The function to be called when an [OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed) event happens
--- - **onEscapePressed**: *function* — The function to be called when an [OnEscapePressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEscapePressed) event happens
---@return EditBox editBox
local function CreateEditBox(t)
	local editBox = CreateFrame("EditBox", t.parent:GetName() .. "EditBox", t.parent, "InputBoxTemplate") --This template doesn't have multiline art
	--Position & dimensions
	if (t.position.offset or _).y ~= nil then (t.position.offset or _).y = (t.position.offset or _).y - 18 end
	PositionFrame(editBox, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or _).x, (t.position.offset or _).y)
	editBox:SetSize(t.size.width, t.size.height or 17)
	--Font & text
	editBox:SetMultiLine(t.multiline or false)
	editBox:SetFontObject("GameFontHighlight")
	if t.justify ~= nil then
		if t.justify.h ~= nil then editBox:SetJustifyH(t.justify.h) end
		if t.justify.v ~= nil then editBox:SetJustifyV(t.justify.v) end
	end
	if t.maxLetters ~= nil then editBox:SetMaxLetters(t.maxLetters) end
	editBox:SetText(t.text or "")
	--Title
	AddTitle({
		frame = editBox,
		title = {
			text = t.title,
			offset = { x = 0, y = 18 },
			template = "GameFontNormal"
		}
	})
	--Events & behavior
	editBox:SetAutoFocus(false)
	editBox:SetScript("OnEnterPressed", t.onEnterPressed)
	editBox:HookScript("OnEnterPressed", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		self:ClearFocus()
	end)
	editBox:SetScript("OnEscapePressed", t.onEscapePressed)
	editBox:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
	return editBox
end
--TODO: Fix the text being offset to the left on first load

---Add a value box as a child to an existing slider frame
---@param t table Parameters are to be provided in this table
--- - **slider**: *[Slider](https://wowpedia.fandom.com/wiki/UIOBJECT_Slider)* — The frame of "Slider" type to set as the parent frame
--- - **value**: *table*
--- 	- **min**: *number* — Lower numeric value limit of the slider
--- 	- **max**: *number* — Upper numeric value limit of the slider
--- 	- **step**: *number* — Numeric value step of the slider
---@return EditBox valueBox
local function AddSliderValueBox(t)
	local valueBox = CreateFrame("EditBox", t.slider:GetName() .. "EditBox", t.slider, BackdropTemplateMixin and "BackdropTemplate")
	--Position & dimensions
	valueBox:SetPoint("TOP", t.slider, "BOTTOM")
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
	--Font & text
	valueBox:SetFontObject("GameFontHighlightSmall")
	valueBox:SetText("GameFontHighlightSmall")
	valueBox:SetJustifyH("CENTER")
	valueBox:SetMaxLetters(string.len(tostring(t.value.max)))
	--Tooltip
	valueBox.tooltipText = t.label
	valueBox.tooltipRequirement = t.tooltip
	--Events & behavior
	valueBox:SetAutoFocus(false)
	valueBox:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(0.7, 0.7, 0.7, 0.8) end)
	valueBox:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8) end)
	valueBox:SetScript("OnEnterPressed", function(self)
		local value = max(t.value.min, min(t.value.max, floor(self:GetNumber() * (1 / t.value.step) + 0.5) / (1 / t.value.step)))
		t.slider:SetValue(value)
		self:SetText(value)
	end)
	valueBox:HookScript("OnEnterPressed", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		self:ClearFocus()
	end)
	valueBox:SetScript("OnEscapePressed", function(self) self:SetText(t.slider:GetValue()) end)
	valueBox:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
	valueBox:SetScript("OnChar", function(self)
		if math.floor(t.value.min) == t.value.min and math.floor(t.value.max) == t.value.max and math.floor(t.value.step) == t.value.step then
			self:SetText(self:GetText():gsub("[^%d]", ""))
		else
			self:SetText(self:GetText():gsub("[^%.%d]+", ""):gsub("(%..*)%.", "%1"))
		end
	end)
	t.slider:HookScript("OnValueChanged", function(_, value) valueBox:SetText(value) end)
	return valueBox
end
---Create a new slider frame as a child of an options frame
---@param t table Parameters are to be provided in this table
--- - **parent**: *[FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* — The frame to set as the parent of the new slider
--- - **position**: *table* — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor**: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)*
--- 	- **relativeTo**?: *[Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* [optional]
--- 	- **relativePoint**?: *[FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* [optional]
--- 	- **offset**?: *table* [optional]
--- 		- **x**: *number*
--- 		- **y**: *number*
--- - **width**?: *number* [optional]
--- - **label**: *string* — Title text to be shown above the slider and as the the tooltip label
--- - **tooltip**: *string* — Text to be shown as the tooltip of the slider
--- - **value**: *table*
--- 	- **min**: *number* — Lower numeric value limit
--- 	- **max**: *number* — Upper numeric value limit
--- 	- **step**: *number* — Numeric value step
--- - **valueBox**?: *boolean* [optional] — Set to false when the frame type should NOT have an [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) added as a child frame
--- - **onValueChanged**: *function* — The function to be called when an [OnValueChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnValueChanged) event happens
---@return Slider slider
---@return EditBox? valueBox
local function CreateSlider(t)
	local slider = CreateFrame("Slider", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Slider", t.parent, "OptionsSliderTemplate")
	--Position
	PositionFrame(slider, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or _).x, (t.position.offset or _).y)
	if t.width ~= nil then slider:SetWidth(t.width) end
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
	slider:HookScript("OnMouseUp", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
	--Value box
	if t.valueBox == false then return slider end
	local valueBox = AddSliderValueBox({ slider = slider, value = { min = t.value.min, max = t.value.max, step = t.value.step } })
	return slider, valueBox
end
---Create a dropdown frame as a child of an options frame
---@param t table Parameters are to be provided in this table
--- - **parent**: *[FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* — The frame to set as the parent of the new dropdown
--- - **position**: *table* — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor**: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)*
--- 	- **relativeTo**?: *[Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* [optional]
--- 	- **relativePoint**?: *[FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* [optional]
--- 	- **offset**?: *table* [optional]
--- 		- **x**: *number*
--- 		- **y**: *number*
--- - **width**?: *number* [optional]
--- - **label**: *string* — Title text to be shown above the dropdown and as the the tooltip label
--- - **tooltip**: *string* — Text to be shown as the tooltip of the dropdown
--- - **items**: *table* — Table containing the dropdown items
--- - **selected**: *number* — The currently selected item of the dropdown menu
---@return Frame dropdown
local function CreateDropdown(t)
	local dropdown = CreateFrame("Frame", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Dropdown", t.parent, "UIDropDownMenuTemplate")
	--Position
	PositionFrame(dropdown, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or _).x, (t.position.offset or _).y)
	if t.width ~= nil then dropdown:SetWidth(t.width) end
	--Tooltip
	dropdown.tooltipText = t.label
	dropdown.tooltipRequirement = t.tooltip
	--Title
	AddTitle({
		frame = dropdown,
		title = {
			text = t.label,
			offset = { x = 0, y = 16 },
			template = "GameFontNormal"
		}
	})
	--Initialize
	UIDropDownMenu_Initialize(dropdown, function()
		for i = 0, #t.items do
			local info = UIDropDownMenu_CreateInfo()
			info.text = t.items[i].text
			info.value = i
			info.func = function(self)
				t.items[i].onSelect()
				UIDropDownMenu_SetSelectedValue(dropdown, self.value)
			end
			UIDropDownMenu_AddButton(info)
		end
	end)
	UIDropDownMenu_SetSelectedValue(dropdown, t.selectedy)
	return dropdown
end


--[[ GUI OPTIONS ]]

--Set up GUI options
local function SetUpInterfaceOptions()
	local _ local description = AddTitle({
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
	local savePopup = CreatePopup({
		name = strings.options.position.save.label,
		text = strings.options.position.save.warning,
		onAccept = function() SavePosition() end
	})
	CreateButton({
		parent = positionOptions,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 10, y = -32 }
		},
		width = 120,
		label = strings.options.position.save.label,
		tooltip = strings.options.position.save.tooltip,
		onClick = function() StaticPopup_Show(savePopup) end
	})
	--Button: Reset preset position
	local resetPopup = CreatePopup({
		name = strings.options.position.reset.label,
		text = strings.options.position.reset.warning,
		onAccept = function() ResetPosition() end
	})
	CreateButton({
		parent = positionOptions,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -134, y = -32 }
		},
		width = 120,
		label = strings.options.position.reset.label,
		tooltip = strings.options.position.reset.tooltip,
		onClick = function() StaticPopup_Show(resetPopup) end
	})
	--Button: Reset default preset position
	local defaultPopup = CreatePopup({
		name = strings.options.position.default.label,
		text = strings.options.position.default.warning,
		onAccept = function() DefaultPreset() end
	})
	CreateButton({
		parent = positionOptions,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -32 }
		},
		width = 120,
		label = strings.options.position.default.label,
		tooltip = strings.options.position.default.tooltip,
		onClick = function() StaticPopup_Show(defaultPopup) end
	})
	--Checkbox: Hidden
	options.visibility.hidden = CreateCheckbox({
		parent = visibilityOptions,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 8, y = -32 }
		},
		width = 120,
		label = strings.options.visibility.hidden.label,
		tooltip = strings.options.visibility.hidden.tooltip,
		onClick = function(self) FlipVisibility(self:GetChecked()) end
	})
	--Dropdown: Font family
	local fontItems = {}
	for i = 0, #fonts do
		fontItems[i] = fonts[i]
		fontItems[i].onSelect = function()
			textDisplay:SetFont(fonts[i].path, db.font.size, "THINOUTLINE")
		end
	end
	options.font.family = CreateDropdown({
		parent = fontOptions,
		position = {
			anchor = "TOPLEFT",
			offset = { x = -6, y = -48 }
		},
		label = strings.options.font.family.label,
		tooltip = strings.options.font.family.tooltip,
		items = fontItems,
		selected = GetFontID(db.font.family)
	})
	--Slider: Font size
	options.font.size = CreateSlider({
		parent = fontOptions,
		position = {
			anchor = "TOP",
			offset = { x = 0, y = -44 }
		},
		label = strings.options.font.size.label,
		tooltip = strings.options.font.size.tooltip,
		value = { min = 8, max = 64, step = 1 },
		onValueChanged = function(self) textDisplay:SetFont(db.font.family, self:GetValue(), "THINOUTLINE") end
	})
	--TEST
	options.visibility.strata = CreateEditBox({
		parent = fontOptions,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -12, y = -32 }
		},
		size = { width = 120 },
		maxLetters = 300,
		text = "movSpeed:GetFrameStrata()",
		title = strings.options.font.family.label,
		onEnterPressed = function(self) print(self:GetText()) end,
		onEscapePressed = function(self) self:SetText("movSpeed:GetFrameStrata()") end
	})
end

--Interface options event handlers
local function Save()
	db.visibility.hidden = not movSpeed:IsShown()
	db.font.size = options.font.size:GetValue()
	db.font.family = textDisplay:GetFont()
end
local function Cancel() --Refresh() is called automatically
	SetDisplayValues()
end
local function Default() --Refresh() is called automatically
	MovementSpeedDB = Clone(defaultDB)
	db = Clone(defaultDB)
	SetDisplayValues()
	print(colors.sg .. addon .. ": " .. colors.ly .. strings.options.defaults)
end
local function Refresh()
	options.visibility.hidden:SetChecked(db.visibility.hidden)
	options.font.size:SetValue(db.font.size)
	UIDropDownMenu_SetSelectedValue(options.font.family, GetFontID(db.font.family))
	options.visibility.strata:SetText("db.font.family")
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
	movSpeed:SetFrameStrata(db.visibility.frameStrata)
	movSpeed:SetToplevel(true)
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

--Hide during Pet Battle
function movSpeed:PET_BATTLE_OPENING_START()
	movSpeed:Hide()
end
function movSpeed:PET_BATTLE_CLOSE()
	if db.visibility.hidden == false then movSpeed:Show() end
end


--[[ INITIALIZATION ]]

--Check and fix the DB
local oldData = {};
local function AddItems(dbToCheck, dbToSample) --Check for and fill in missing data
	if type(dbToCheck) ~= "table" and type(dbToSample) ~= "table" then return end
	for k, v in pairs(dbToSample) do
		if dbToCheck[k] == nil then
			dbToCheck[k] = v;
		else
			AddItems(dbToCheck[k], dbToSample[k])
		end
	end
end
local function RemoveItems(dbToCheck, dbToSample) --Remove unused or outdated data while trying to keep any old data
	if type(dbToCheck) ~= "table" and type(dbToSample) ~= "table" then return end
	for k, v in pairs(dbToCheck) do
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
	if not movSpeed:IsShown() then
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