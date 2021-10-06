--Addon name, namespace
local addonNameSpace, ns = ...
local _, addon = GetAddOnInfo(addonNameSpace)


--[[ ASSETS, STRINGS & LOCALIZATION ]]

local strings = { options = {}, chat = {}, misc = {} }

--Load localization
local function LoadLocale()
	if (GetLocale() == "") then
		--TODO: add support for other languages (locales: https://wowwiki-archive.fandom.com/wiki/API_GetLocale#Locales)
		--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml
	else
		strings = ns.english --English (UK & US)
		strings.options.font.family.default = "Fonts/FRIZQT__.TTF"
	end
end
LoadLocale()

--Color palette for string formatting
local colors = {
	lg = "|cFF" .. "8FD36E", --light green
	sg = "|cFF" .. "4ED836", --strong green
	ly = "|cFF" .. "FFFB99", --light yellow
	sy = "|cFF" .. "FFDD47", --strong yellow
	normal = { r = nil, g = nil, b = nil },
	title = { r = nil, g = nil, b = nil },
}
colors.normal.r, colors.normal.g, colors.normal.b = HIGHLIGHT_FONT_COLOR:GetRGB()
colors.title.r, colors.title.g, colors.title.b = NORMAL_FONT_COLOR:GetRGB()

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
	if type(object) ~= "table" then
		print(object)
		return
	end
	for _, v in pairs(object) do
		Dump(v)
	end
end
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


--[[ FRAMES & EVENTS ]]

--Create the main frame, text display and tooltip
local movSpeed = CreateFrame("Frame", "MovementSpeed", UIParent)
local textDisplay = movSpeed:CreateFontString("MovementSpeedTextDisplay", "OVERLAY")
local tooltip = CreateFrame("GameTooltip", "MovementSpeedTooltip", nil, "GameTooltipTemplate")

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
	print(colors.sy .. strings.chat.help.thanks:gsub("#ADDON", colors.sg .. addon .. colors.sy))
	PrintStatus()
	print(colors.ly .. strings.chat.help.hint:gsub("#HELP_COMMAND", colors.lg .. keyword .. " " .. strings.chat.help.command .. colors.ly))
	print(colors.ly .. strings.chat.help.move:gsub("#SHIFT", colors.lg .. "SHIFT" .. colors.ly))
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
			description =  strings.chat.size.description:gsub("#SIZE_DEFAULT", colors.lg .. strings.chat.size.command .. " " .. defaultDB.font.size .. colors.ly),
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
			print(colors.sg .. addon .. ": " .. colors.ly .. strings.chat.size.response:gsub("#VALUE", size))
		else
			print(colors.sg .. addon .. ": " .. colors.ly .. strings.chat.size.unchanged)
			print(colors.ly .. strings.chat.size.error:gsub("#SIZE_DEFAULT", colors.lg .. strings.chat.size.command .. " " .. defaultDB.font.size .. colors.ly))
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
---@param offsetX? number (Default: 0)
---@param offsetY? number (Default: 0)
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
---Set up the default GameTooltip to be shown for a frame
---@param owner FrameType Owner frame the tooltip to be shown for
---@param anchor string [GameTooltip anchor](https://wowpedia.fandom.com/wiki/API_GameTooltip_SetOwner)
---@param title string String to be shown as the tooltip title
---@param text string String to be shown as the first line of tooltip summary
---@param textLines? table Numbered table containing additional string lines to be added to the tooltip text
--- - **text**: *string* ― Text to be added to the line
--- - **wrap**: boolean ― Append the text in a new line or not
--- - **color**?: *table* [optional] ― RGB colors line
--- 	- **r**: number ― Red
--- 	- **g**: number ― Green
--- 	- **b**: number ― Blue
---@param offsetX? number (Default: 0)
---@param offsetY? number (Default: 0)
local function AddTooltip(owner, anchor, title, text, textLines, offsetX, offsetY)
	--Position
	tooltip:SetOwner(owner, anchor, offsetX, offsetY)
	--Title
	tooltip:AddLine(title, colors.title.r, colors.title.g, colors.title.b, true)
	--Summary
	tooltip:AddLine(text, colors.normal.r, colors.normal.g, colors.normal.b, true)
	--Additional text lines
	if textLines ~= nil then 
		--Empty line after the summary
		tooltip:AddLine(" ", nil, nil, nil, true) --TODO: Check why the third line has the title FontObject
		for i = 0, #textLines do
			--Add line
			tooltip:AddLine(textLines[i].text, (textLines[i].color or {}).r or colors.normal.r, (textLines[i].color or {}).g or colors.normal.g, (textLines[i].color or {}).b or colors.normal.b, textLines[i].wrap)
		end
	end
	--Show
	tooltip:Show() --Don't forget to hide later!
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
	title:SetPoint("TOPLEFT", (t.title.offset or {}).x, (t.title.offset or {}).y)
	title:SetText(t.title.text)
	if t.description == nil then return title end
	--Description
	local description = t.frame:CreateFontString(t.frame:GetName() .. "Description", "ARTWORK", t.description.template)
	description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", (t.description.offset or {}).x, (t.description.offset or {}).y)
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
	PositionFrame(category, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y)
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
---Create a texture/image
---@param t table Parameters are to be provided in this table
--- - **parent**: *[FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* — The frame to set as the parent of the new button
--- - **name**: *string* — Used for a unique name, it will not be visible
--- - **path**: *string* — Path to the texture file, filenamey
--- - **position**: *table* — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor**: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)*
--- 	- **relativeTo**?: *[Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)* [optional]
--- 	- **relativePoint**?: *[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)* [optional]
--- 	- **offset**?: *table* [optional]
--- 		- **x**: *number*
--- 		- **y**: *number*
--- - **size**: *table*
--- 	- **width**: *number*
--- 	- **height**: *number*
--- - **tile**?: *number* [optional]
---@return any
local function CreateTexture(t)
	local holder = CreateFrame("Frame", t.parent:GetName() .. t.name:gsub("%s+", ""), t.parent)
	local texture = holder:CreateTexture(holder:GetName() .. "Texture")
	--Position & dimensions
	PositionFrame(holder, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y)
	holder:SetSize(t.size.width, t.size.height)
	texture:SetPoint("CENTER")
	texture:SetSize(t.size.width, t.size.height)
	--Set asset
	if t.tile ~= nil then
		texture:SetTexture(t.path, t.tile)
	else
		texture:SetTexture(t.path)
	end
	return holder, texture
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
--- - **tooltipExtra**?: *table* [optional] — Additional text lines to be added to the tooltip of the dropdown
--- 	- **text**: *string* ― Text to be added to the line
--- 	- **wrap**: boolean ― Append the text in a new line or not
---	 	- **color**?: *table* [optional] ― RGB colors line
--- 		- **r**: number ― Red
--- 		- **g**: number ― Green
--- 		- **b**: number ― Blue
--- - **onClick**: *function* — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
---@return Button button
local function CreateButton(t)
	local button = CreateFrame("Button", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Button", t.parent, "UIPanelButtonTemplate")
	--Position & dimensions
	PositionFrame(button, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y)
	if t.width ~= nil then button:SetWidth(t.width) end
	--Font
	getglobal(button:GetName() .. "Text"):SetText(t.label)
	--Tooltip
	button:HookScript("OnEnter", function() AddTooltip(button, "ANCHOR_TOPLEFT", t.label, t.tooltip, t.tooltipExtra, 20, nil)	end)
	button:HookScript("OnLeave", function() tooltip:Hide() end)
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
	PositionFrame(checkbox, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y)
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
	local editBox = CreateFrame("EditBox", t.parent:GetName() .. t.title:gsub("%s+", "") .. "EditBox", t.parent, "InputBoxTemplate") --This template doesn't have multiline art
	--Position & dimensions
	PositionFrame(editBox, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) - 18)
	editBox:SetSize(t.size.width, t.size.height or 17)
	--Font & text
	editBox:SetMultiLine(t.multiline or false) --TODO: Fix multiline support to be visible on the GUI (the EditBox is currently only one line tall)
	editBox:SetFontObject("GameFontHighlight")
	if t.justify ~= nil then
		if t.justify.h ~= nil then editBox:SetJustifyH(t.justify.h) end
		if t.justify.v ~= nil then editBox:SetJustifyV(t.justify.v) end
	end
	if t.maxLetters ~= nil then editBox:SetMaxLetters(t.maxLetters) end
	--Title
	AddTitle({
		frame = editBox,
		title = {
			text = t.title,
			offset = { x = -1, y = 18 },
			template = "GameFontNormal"
		}
	})
	--Events & behavior
	editBox:SetAutoFocus(false)
	editBox:SetScript("OnShow", function(self) self:SetText(t.text or "") end)
	editBox:SetScript("OnEnterPressed", t.onEnterPressed)
	editBox:HookScript("OnEnterPressed", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		self:ClearFocus()
	end)
	editBox:SetScript("OnEscapePressed", t.onEscapePressed)
	editBox:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
	return editBox
end
--FIXME: Fix the text being offset to the left on first load

---Add a value box as a child to an existing slider frame
---@param t table Parameters are to be provided in this table
--- - **slider**: *[Slider](https://wowpedia.fandom.com/wiki/UIOBJECT_Slider)* — The frame of "Slider" type to set as the parent frame
--- - **value**: *table*
--- 	- **min**: *number* — Lower numeric value limit of the slider
--- 	- **max**: *number* — Upper numeric value limit of the slider
--- 	- **step**: *number* — Numeric value step of the slider
---@return EditBox valueBox
local function AddSliderValueBox(t)
	local valueBox = CreateFrame("EditBox", t.slider:GetName() .. "ValueBox", t.slider, BackdropTemplateMixin and "BackdropTemplate")
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
	valueBox:SetJustifyH("CENTER")
	valueBox:SetMaxLetters(string.len(tostring(t.value.max)))
	--Events & behavior
	valueBox:SetAutoFocus(false)
	valueBox:SetScript("OnShow", function(self) self:SetText(t.slider:GetValue()) end)
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
	PositionFrame(slider, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) - 12)
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
--- - **width**?: *number* [optional] — (currently unsupported)
--- - **label**: *string* — Title text to be shown above the dropdown and as the the tooltip label
--- - **tooltip**: *string* — Text to be shown as the tooltip of the dropdown
--- - **tooltipExtra**?: *table* [optional] — Additional text lines to be added to the tooltip of the dropdown
--- 	- **text**: *string* ― Text to be added to the line
--- 	- **wrap**: boolean ― Append the text in a new line or not
--- 	- **color**?: *table* [optional] ― RGB colors line
--- 		- **r**: number ― Red
--- 		- **g**: number ― Green
--- 		- **b**: number ― Blue
--- - **items**: *table* — Numbered/indexed table containing the dropdown items
--- 	- **text**: *string* — Text to represent the items within the dropdown frame
--- 	- **onSelect**: *function* — The function to be called when a dropdown item is selected
--- - **selected?**: *number* [optional] — The currently selected item of the dropdown menu
---@return Frame dropdown
local function CreateDropdown(t)
	local dropdown = CreateFrame("Frame", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Dropdown", t.parent, "UIDropDownMenuTemplate")
	--Position & dimensions
	PositionFrame(dropdown, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0)- 16)
	if t.width ~= nil then UIDropDownMenu_SetWidth(dropdown, t.width) end
	--Tooltip
	dropdown:HookScript("OnEnter", function() AddTooltip(dropdown, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra, nil, nil) end)
	dropdown:HookScript("OnLeave", function() tooltip:Hide() end)
	--Title
	AddTitle({
		frame = dropdown,
		title = {
			text = t.label,
			offset = { x = 22, y = 16 },
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
	if t.selected ~= nil then
		UIDropDownMenu_SetSelectedValue(dropdown, t.selected)
		UIDropDownMenu_SetText(dropdown, t.items[t.selected].text)
	end
	return dropdown
end


--[[ GUI OPTIONS ]]

--Options frame
local options = { visibility = {}, font = {} }

--GUI elements
local function CreatePositionOptions(parentFrame)
	--Button & Popup: Save preset position
	local savePopup = CreatePopup({
		name = strings.options.position.save.label,
		text = strings.options.position.save.warning,
		onAccept = function() SavePosition() end
	})
	CreateButton({
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
	--Button & Popup: Reset preset position
	local resetPopup = CreatePopup({
		name = strings.options.position.reset.label,
		text = strings.options.position.reset.warning,
		onAccept = function() ResetPosition() end
	})
	CreateButton({
		parent = parentFrame,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -134, y = -30 }
		},
		width = 120,
		label = strings.options.position.reset.label,
		tooltip = strings.options.position.reset.tooltip,
		onClick = function() StaticPopup_Show(resetPopup) end
	})
	--Button & Popup: Reset default preset position
	local defaultPopup = CreatePopup({
		name = strings.options.position.default.label,
		text = strings.options.position.default.warning,
		onAccept = function() DefaultPreset() end
	})
	CreateButton({
		parent = parentFrame,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -30 }
		},
		width = 120,
		label = strings.options.position.default.label,
		tooltip = strings.options.position.default.tooltip,
		onClick = function() StaticPopup_Show(defaultPopup) end
	})
end
local function CreateVisibilityOptions(parentFrame)
	--Checkbox: Hidden
	options.visibility.hidden = CreateCheckbox({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 8, y = -30 }
		},
		width = 120,
		label = strings.options.visibility.hidden.label,
		tooltip = strings.options.visibility.hidden.tooltip,
		onClick = function(self) FlipVisibility(self:GetChecked()) end
	})
end
local function CreateFontOptions(parentFrame)
	--Dropdown: Font family
	local fontItems = {}
	for i = 0, #fonts do
		fontItems[i] = fonts[i]
		fontItems[i].onSelect = function()
			textDisplay:SetFont(fonts[i].path, options.font.size:GetValue(), "THINOUTLINE")
		end
	end
	local tooltipLines = {
		[0] = { text = strings.options.font.family.tooltip[1], wrap = true },
		[1] = { text = strings.options.font.family.tooltip[2]:gsub("#OPTION_CUSTOM", strings.misc.custom):gsub("#FILE_CUSTOM", "CUSTOM.ttf"), wrap = true },
		[2] = { text = "[WoW]\\Interface\\AddOns\\MovementSpeed\\Fonts\\", wrap = false, color = { r = 0.185, g = 0.72, b = 0.84 } },
		[3] = { text = strings.options.font.family.tooltip[3]:gsub("#FILE_CUSTOM", "CUSTOM.ttf"), wrap = true },
		[4] = { text = strings.options.font.family.tooltip[4], wrap = true, color = { r = 0.89, g = 0.65, b = 0.40 } },
	}
	options.font.family = CreateDropdown({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = -6, y = -30 }
		},
		label = strings.options.font.family.label,
		tooltip = strings.options.font.family.tooltip[0],
		tooltipExtra = tooltipLines,
		items = fontItems,
	})
	--Slider: Font size
	options.font.size = CreateSlider({
		parent = parentFrame,
		position = {
			anchor = "TOP",
			offset = { x = 0, y = -30 }
		},
		label = strings.options.font.size.label,
		tooltip = strings.options.font.size.tooltip .. "\n\n" .. strings.misc.default .. ": " .. defaultDB.font.size,
		value = { min = 8, max = 64, step = 1 },
		onValueChanged = function(self) textDisplay:SetFont(textDisplay:GetFont(), self:GetValue(), "THINOUTLINE") end
	})
	--TEST
	options.font.test = CreateEditBox({
		parent = parentFrame,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -12, y = -30 }
		},
		size = { width = 120 },
		maxLetters = 300,
		text = "TTTEEESSSTTTtest",
		title = "[PH]Test edit box",
		onEnterPressed = function(self) print(self:GetText()) end,
		onEscapePressed = function(self) self:SetText(strings.options.font.family.tooltip:gsub("#OPTION_CUSTOM", strings.misc.custom) :gsub("#FILE_CUSTOM", "CUSTOM.ttf"):gsub("#PATH_CUSTOM", "[WoW]\\Interface\\AddOns\\MovementSpeed\\Fonts\\"):gsub("#NAME_CUSTOM", "CUSTOM")) end
	})
end
--Category frames
local function CreateCategoryPanels(parentFrame, titleFrame)
	--Position
	local optionsWidth = InterfaceOptionsFramePanelContainer:GetWidth() - 32
	local positionOptions = CreateCategory({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			relativeTo = titleFrame,
			relativePoint = "BOTTOMLEFT",
			offset = { x = 0, y = -48 }
		},
		size = { width = optionsWidth, height = 64 },
		title = strings.options.position.title,
		description = strings.options.position.description
	})
	CreatePositionOptions(positionOptions)
	--Visibility
	local visibilityOptions = CreateCategory({
		parent = parentFrame,
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
	CreateVisibilityOptions(visibilityOptions)
	--Font
	local fontOptions = CreateCategory({
		parent = parentFrame,
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
	CreateFontOptions(fontOptions)
end
--Main options frame
local function CreateOptionsPanel()
	local optionsPanel = CreateFrame("Frame", "MovementSpeedOptions", InterfaceOptionsFramePanelContainer)
	--Title & description
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
	--Logo
	CreateTexture({
		parent = optionsPanel,
		name = "Logo",
		path = textures.logo,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -16, y = -16 }
		},
		size = { width = 36, height = 36 }
	})
	--Categories & GUI elements
	CreateCategoryPanels(optionsPanel, description)
	return optionsPanel
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
	UIDropDownMenu_SetText(options.font.family, fonts[GetFontID(db.font.family)].text)
	options.font.test:SetText("TEStestTESTtest")
end

--Add the options to the WoW interface
local function LoadInterfaceOptions()
	--Set up the GUI
	local optionsPanel = CreateOptionsPanel()
	--Set up the options panel
	optionsPanel.name = addon
	--Set event handlers
	optionsPanel.okay = function() Save() end
	optionsPanel.cancel = function() Cancel() end --refresh is called automatically
	optionsPanel.default = function() Default() end --refresh is called automatically
	optionsPanel.refresh = function() Refresh() end
	--Add the panel
	InterfaceOptions_AddCategory(optionsPanel)
end


--[[ DISPLAY FRAME SETUP ]]

--Set frame parameters
local function SetUpMainDisplayFrame()
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
local function SetUpTooltip()
	tooltip:SetFrameStrata("DIALOG")
	tooltip:SetScale(0.9)
	--Title font
	tooltip:AddFontStrings(
		tooltip:CreateFontString(tooltip:GetName() .. "TextLeft1", nil, "GameTooltipHeaderText"),
		tooltip:CreateFontString(tooltip:GetName() .. "TextRight1", nil, "GameTooltipHeaderText")
	)
	_G[tooltip:GetName() .. "TextLeft1"]:SetFontObject(GameTooltipHeaderText) --TODO: It's not the right font object (too big), find another one that mathces (or create a custom one)
	_G[tooltip:GetName() .. "TextRight1"]:SetFontObject(GameTooltipHeaderText)
	--Text font
	tooltip:AddFontStrings(
		tooltip:CreateFontString(tooltip:GetName() .. "TextLeft" .. 2, nil, "GameTooltipTextSmall"),
		tooltip:CreateFontString(tooltip:GetName() .. "TextRight" .. 2, nil, "GameTooltipTextSmall")
	)
	_G[tooltip:GetName() .. "TextLeft" .. 2]:SetFontObject(GameTooltipTextSmall)
	_G[tooltip:GetName() .. "TextRight" .. 2]:SetFontObject(GameTooltipTextSmall)
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
local oldData = {}
local function RemoveEmpty(dbToCheck) --Remove all nil and empty items from the table
	if type(dbToCheck) ~= "table" then return end
	for k, v in pairs(dbToCheck) do
		if type(v) == "table" then
			if next(v) == nil then --The subtable is empty
				dbToCheck[k] = nil --Remove the empty subtable
			else
				RemoveEmpty(v)
			end
		elseif v == nil or v == "" then --The value is empty or doesn't exist
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
local function RestoreOldData() --Restore old data to the DB by matching removed items to known old keys
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
	--DB checkup & fix
	RemoveEmpty(db) --Strip empty and nil keys & items
	AddMissing(db, defaultDB) --Check for missing data
	RemoveMismatch(db, defaultDB) --Remove unneeded data
	RestoreOldData() --Save old data
end
function movSpeed:ADDON_LOADED(addon)
	if addon == "MovementSpeed" then
		movSpeed:UnregisterEvent("ADDON_LOADED")
		--Load & check the DB
		LoadDB()
		--Set up the main frame & text
		SetUpMainDisplayFrame()
		--Set up the addon tooltip
		SetUpTooltip()
		--Set up the interface options
		LoadInterfaceOptions()
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
	textDisplay:SetText(string.format("%d%%", math.floor(GetUnitSpeed("player") / 7 * 100 + .5)))
end
movSpeed:SetScript("OnUpdate", function(self)
	UpdateSpeed()
end)