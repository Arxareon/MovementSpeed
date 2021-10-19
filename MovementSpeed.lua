--Addon name, namespace
local addonNameSpace, ns = ...
local _, addon = GetAddOnInfo(addonNameSpace)


--[[ ASSETS, STRINGS & LOCALIZATION ]]

local strings = { options = {}, chat = {}, misc = {} }

--Load localization
local function LoadLocale()
	if (GetLocale() == "") then
		--TODO: Add localization for other languages (locales: https://wowwiki-archive.fandom.com/wiki/API_GetLocale#Locales)
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
local movSpeedBackdrop = CreateFrame("Frame", "MovementSpeedBackdrop", movSpeed, BackdropTemplateMixin and "BackdropTemplate")
local textDisplay = movSpeedBackdrop:CreateFontString("MovementSpeedTextDisplay", "OVERLAY")
local movSpeedTooltip = CreateFrame("GameTooltip", "MovementSpeedTooltip", nil, "GameTooltipTemplate")

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
---Set the visibility of the text display frame based on the flipped value of the input parameter
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
	movSpeedBackdrop:SetSize(width, height)
end
---Set the backdrop of the main display
---@param toggle boolean
---@param r? number Red (Range: 0 - 1, Default: db.appearance.backdrop.color.r)
---@param g? number Green (Range: 0 - 1, Default: db.appearance.backdrop.color.g)
---@param b? number Blue (Range: 0 - 1, Default: db.appearance.backdrop.color.b)
---@param a? number Opacity (Range: 0 - 1, Default: db.appearance.backdrop.color.a or 1)
local function SetDisplayBackdrop(toggle, r, g, b, a)
	if toggle then
		movSpeedBackdrop:SetBackdrop({
			bgFile = "Interface/ChatFrame/ChatFrameBackground",
			edgeFile = "Interface/ChatFrame/ChatFrameBackground",
			tile = true, tileSize = 5, edgeSize = 1,
			insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
		movSpeedBackdrop:SetBackdropColor(
			r or db.appearance.backdrop.color.r,
			g or db.appearance.backdrop.color.g,
			b or db.appearance.backdrop.color.b,
			a or db.appearance.backdrop.color.a or 1
		)
		movSpeedBackdrop:SetBackdropBorderColor(1, 1, 1, 0.4)
	else
		movSpeedBackdrop:SetBackdrop(nil)
	end
end
--Set the visibility, backdrop, font family, size and color of the main display to the currently saved values
local function SetDisplayValues()
	--Visibility
	FlipVisibility(db.appearance.hidden)
	--Backdrop
	SetDisplaySize(db.font.size)
	SetDisplayBackdrop(db.appearance.backdrop.visible)
	--Font
	textDisplay:SetFont(db.font.family, db.font.size, "THINOUTLINE")
	textDisplay:SetTextColor(db.font.color.r, db.font.color.g, db.font.color.b, db.font.color.a)
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
		db.appearance.hidden = true
		movSpeed:Hide()
		PrintStatus()
	elseif command == strings.chat.show.command then
		db.appearance.hidden = false
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
---Set up a GameTooltip frame to be shown for a frame
---@param owner FrameType Owner frame the tooltip to be shown for
---@param anchor string [GameTooltip anchor](https://wowpedia.fandom.com/wiki/API_GameTooltip_SetOwner)
---@param title string String to be shown as the tooltip title
---@param text string String to be shown as the first line of tooltip summary
---@param textLines? table Numbered table containing additional string lines to be added to the tooltip text
--- - **text** string ― Text to be added to the line
--- - **wrap** boolean ― Append the text in a new line or not
--- - **color**? table *optional* ― RGB colors line
--- 	- **r** number ― Red (Range: 0 - 1)
--- 	- **g** number ― Green (Range: 0 - 1)
--- 	- **b** number ― Blue (Range: 0 - 1)
---@param offsetX? number (Default: 0)
---@param offsetY? number (Default: 0)
local function AddTooltip(tooltip, owner, anchor, title, text, textLines, offsetX, offsetY)
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
			local r = (textLines[i].color or {}).r or colors.normal.r
			local g = (textLines[i].color or {}).g or colors.normal.g
			local b = (textLines[i].color or {}).b or colors.normal.b
			tooltip:AddLine(textLines[i].text, r, g, b, textLines[i].wrap)
		end
	end
	--Show
	tooltip:Show() --Don't forget to hide later!
end
---Add a title and an optional description to an options frame
---@param t table Parameters are to be provided in this table
--- - **frame** [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) ― The frame panel to add the title and (optional) description to
--- - **title** table
--- 	- **text** string ― Text to be shown as the main title of the frame
--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― (Default: "TOPLEFT")
--- 	- **offset**? table *optional* ― The offset from the anchor point relative to the specified frame
--- 		- **x** number ― Horizontal offset value
--- 		- **y** number ― Vertical offset value
--- 	- **template** string ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
--- - **description**? table *optional*
--- 	- **text** string ― Text to be shown as the subtitle/description of the frame
--- 	- **offset**? table *optional* ― The offset from the BOTTOMLEFT point of the main title [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
--- 		- **x** number ― Horizontal offset value
--- 		- **y** number ― Vertical offset value
--- 	- **template** string ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
---@return string|table title
---@return string|table? description
local function AddTitle(t)
	--Title
	local title = t.frame:CreateFontString(t.frame:GetName() .. "Title", "ARTWORK", t.title.template)
	title:SetPoint(t.title.anchor or "TOPLEFT", (t.title.offset or {}).x, (t.title.offset or {}).y)
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
--- - **parent** [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) — The main options frame to set as the parent of the new category
--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
--- 	- **relativeTo**? [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
--- 	- **offset**? table *optional*
--- 		- **x** number
--- 		- **y** number
--- - **size** table
--- 	- **width**? number *optional* — (Default: parent frame width - 32)
--- 	- **height** number
--- - **title** string — Text to be shown as the main title of the category
--- - **description**? string *optional* — Text to be shown as the subtitle/description of the category
---@return Frame category
local function CreateCategory(t)
	local category = CreateFrame("Frame", t.parent:GetName() .. t.title:gsub("%s+", ""), t.parent, BackdropTemplateMixin and "BackdropTemplate")
	--Position & dimensions
	PositionFrame(category, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y)
	category:SetSize(t.size.width or t.parent:GetWidth() - 32, t.size.height)
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
--- - **parent** [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) — The frame to set as the parent of the new button
--- - **name** string — Used for a unique name, it will not be visible
--- - **path** string — Path to the texture file, filenamey
--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
--- 	- **offset**? table *optional*
--- 		- **x** number
--- 		- **y** number
--- - **size** table
--- 	- **width** number
--- 	- **height** number
--- - **tile**? number *optional*
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
--- - **name** string — The name of the action which will call this popup. Each name must be unique between all popups!
--- - **text** string — The text to display as the message in the popup window
--- - **accept**? string *optional* — The text to display as the label of the accept button (Default: *name*)
--- - **cancel**? string *optional* — The text to display as the label of the cancel button (Default: *strings.misc.cancel*)
--- - **onAccept** function — The function to be called when the accept button is pressed and an OnAccept event happens
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
--- - **parent** [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) — The frame to set as the parent of the new button
--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
--- 	- **offset**? table *optional*
--- 		- **x** number
--- 		- **y** number
--- - **width**? number *optional*
--- - **label** string — Title text to be shown on the button and as the the tooltip label
--- - **tooltip** string — Text to be shown as the tooltip of the button
--- - **tooltipExtra**? table *optional* — Additional text lines to be added to the tooltip of the button
--- 	- **text** string ― Text to be added to the line
--- 	- **wrap** boolean ― Append the text in a new line or not
---	 	- **color**? table *optional* ― RGB colors line
--- 		- **r** number ― Red (Range: 0 - 1)
--- 		- **g** number ― Green (Range: 0 - 1)
--- 		- **b** number ― Blue (Range: 0 - 1)
--- - **onClick** function — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
---@return Button button
local function CreateButton(t)
	local button = CreateFrame("Button", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Button", t.parent, "UIPanelButtonTemplate")
	--Position & dimensions
	PositionFrame(button, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y)
	if t.width ~= nil then button:SetWidth(t.width) end
	--Font
	getglobal(button:GetName() .. "Text"):SetText(t.label)
	--Tooltip
	button:HookScript("OnEnter", function() AddTooltip(movSpeedTooltip, button, "ANCHOR_TOPLEFT", t.label, t.tooltip, t.tooltipExtra, 20, nil)	end)
	button:HookScript("OnLeave", function() movSpeedTooltip:Hide() end)
	--Event handlers
	button:SetScript("OnClick", t.onClick)
	button:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
	return button
end
---Create a checkbox frame as a child of an options frame
---@param t table Parameters are to be provided in this table
--- - **parent** [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) — The frame to set as the parent of the new checkbox
--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
--- 	- **offset**? table *optional*
--- 		- **x** number
--- 		- **y** number
--- - **label** string — Title text to be shown on the button and as the the tooltip label
--- - **tooltip** string — Text to be shown as the tooltip of the button
--- - **onClick** function — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
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
--- - **parent** [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) — The frame to set as the parent of the edit box
--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
--- 	- **offset**? table *optional*
--- 		- **x** number
--- 		- **y** number
--- - **size** table
--- 	- **width** number
--- 	- **height**? number *optional* — (Default: 17)
--- - **multiline**? boolean *optional* — Set to true if the edit box should be support multiple lines for the string input (Default: false)
--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" (Default: "LEFT")
--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" (Default: "MIDDLE")
--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) (Default: 0 [no limit])
--- - **text**? string *optional* — Text to be shown inside edit box on load
--- - **label** string — Name of the edit box to be shown as the tooltip title and optionally as the title text
--- - **title**? boolean *optional* — Wether ot not to add a title above the edit box (Default: true)
--- - **tooltip** string — Text to be shown as the tooltip of the button
--- - **tooltipExtra**? table *optional* — Additional text lines to be added to the tooltip of the button
--- 	- **text** string ― Text to be added to the line
--- 	- **wrap** boolean ― Append the text in a new line or not
---	 	- **color**? table *optional* ― RGB colors line
--- 		- **r** number ― Red (Range: 0 - 1)
--- 		- **g** number ― Green (Range: 0 - 1)
--- 		- **b** number ― Blue (Range: 0 - 1)
--- - **onEnterPressed** function — The function to be called when an [OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed) event happens
--- - **onEscapePressed** function — The function to be called when an [OnEscapePressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEscapePressed) event happens
---@return EditBox editBox
local function CreateEditBox(t)
	local editBox = CreateFrame("EditBox", t.parent:GetName() .. t.label:gsub("%s+", "") .. "EditBox", t.parent, "InputBoxTemplate")
	--Position & dimensions
	PositionFrame(editBox, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) - 18)
	editBox:SetSize(t.size.width, t.size.height or 17)
	--Font & text
	editBox:SetMultiLine(t.multiline or false) --TODO: Fix multiline support to be visible on the GUI (the current art template doesn't have multiline support)
	editBox:SetFontObject("GameFontHighlight")
	if t.justify ~= nil then
		if t.justify.h ~= nil then editBox:SetJustifyH(t.justify.h) end
		if t.justify.v ~= nil then editBox:SetJustifyV(t.justify.v) end
	end
	if t.maxLetters ~= nil then editBox:SetMaxLetters(t.maxLetters) end
	--Title
	if t.title ~= false then
		AddTitle({
			frame = editBox,
			title = {
				text = t.label,
				offset = { x = -1, y = 18 },
				template = "GameFontNormal"
			}
		})
	end
	--Tooltip
	editBox:HookScript("OnEnter", function() AddTooltip(movSpeedTooltip, editBox, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra, nil, nil) end)
	editBox:HookScript("OnLeave", function() movSpeedTooltip:Hide() end)
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
---Add a value box as a child to an existing slider frame
---@param t table Parameters are to be provided in this table
--- - **slider** [Slider](https://wowpedia.fandom.com/wiki/UIOBJECT_Slider) — The frame of "Slider" type to set as the parent frame
--- - **value** table
--- 	- **min** number — Lower numeric value limit of the slider
--- 	- **max** number — Upper numeric value limit of the slider
--- 	- **step** number — Numeric value step of the slider
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
--- - **parent** [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) — The frame to set as the parent of the new slider
--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
--- 	- **relativePoint**? [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
--- 	- **offset**? table *optional*
--- 		- **x** number
--- 		- **y** number
--- - **width**? number *optional*
--- - **label** string — Title text to be shown above the slider and as the the tooltip label
--- - **tooltip** string — Text to be shown as the tooltip of the slider
--- - **value** table
--- 	- **min** number — Lower numeric value limit
--- 	- **max** number — Upper numeric value limit
--- 	- **step** number — Numeric value step
--- - **valueBox**? boolean *optional* — Set to false when the frame type should NOT have an [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) added as a child frame
--- - **onValueChanged** function — The function to be called when an [OnValueChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnValueChanged) event happens
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
--- - **parent** [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) — The frame to set as the parent of the new dropdown
--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
--- 	- **relativePoint**? [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
--- 	- **offset**? table *optional*
--- 		- **x** number
--- 		- **y** number
--- - **width**? number *optional* — (currently unsupported)
--- - **label** string — Name of the dropdown shown as the tooltip title and optionally as the title text
--- - **title**? boolean *optional* — Wether ot not to add a title above the dropdown menu (Default: true)
--- - **tooltip** string — Text to be shown as the tooltip of the dropdown
--- - **tooltipExtra**? table *optional* — Additional text lines to be added to the tooltip of the dropdown
--- 	- **text** string ― Text to be added to the line
--- 	- **wrap** boolean ― Append the text in a new line or not
--- 	- **color**? table *optional* ― RGB colors line
--- 		- **r** number ― Red (Range: 0 - 1)
--- 		- **g** number ― Green (Range: 0 - 1)
--- 		- **b** number ― Blue (Range: 0 - 1)
--- - **items** table — Numbered/indexed table containing the dropdown items
--- 	- **text** string — Text to represent the items within the dropdown frame
--- 	- **onSelect** function — The function to be called when a dropdown item is selected
--- - **selected?** number *optional* — The currently selected item of the dropdown menu
---@return Frame dropdown
local function CreateDropdown(t)
	local dropdown = CreateFrame("Frame", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Dropdown", t.parent, "UIDropDownMenuTemplate")
	--Position & dimensions
	PositionFrame(dropdown, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) - 16)
	if t.width ~= nil then UIDropDownMenu_SetWidth(dropdown, t.width) end
	--Tooltip
	dropdown:HookScript("OnEnter", function() AddTooltip(movSpeedTooltip, dropdown, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra, nil, nil) end)
	dropdown:HookScript("OnLeave", function() movSpeedTooltip:Hide() end)
	--Title
	if t.title ~= false then
		AddTitle({
			frame = dropdown,
			title = {
				text = t.label,
				offset = { x = 22, y = 16 },
				template = "GameFontNormal"
			}
		})
	end
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
--Addon-scope data bust be used to stop the separate color pickers from interfering with each other through the global Blizzard Color Picker frame
local colorPickerData = {}
---Set up and open the built-in Color Picker frame
---
---Using **colorPickerData** table, it must be set before call:
--- - **activeColorPicker** Button
--- - **startColors** table ― Color values are to be provided in this table
--- 	- **r** number ― Red (Range: 0 - 1)
--- 	- **g** number ― Green (Range: 0 - 1)
--- 	- **b** number ― Blue (Range: 0 - 1)
--- 	- **a**? number *optional* ― Opacity (Range: 0 - 1, Default: 1)
--- - **onColorUpdate** function
--- - **onOpacityUpdate**? function *optional*
--- - **onCancel** function
local function OpenColorPicker()
	--Color picker button background update function
	local function PickerButtonUpdate()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		colorPickerData.activeColorPicker:SetBackdropColor(r, g, b, OpacitySliderFrame:GetValue() or 1)
	end
	--RGB
	ColorPickerFrame:SetColorRGB(colorPickerData.startColors.r, colorPickerData.startColors.g, colorPickerData.startColors.b)
	ColorPickerFrame.func = function()
		PickerButtonUpdate()
		colorPickerData.onColorUpdate()
	end
	--Alpha
	ColorPickerFrame.hasOpacity = colorPickerData.onOpacityUpdate ~= nil and colorPickerData.startColors.a ~= nil
	if ColorPickerFrame.hasOpacity then
		ColorPickerFrame.opacity = colorPickerData.startColors.a
		ColorPickerFrame.opacityFunc = function()
			PickerButtonUpdate()
			colorPickerData.onOpacityUpdate()
		end
	end
	--Reset
	ColorPickerFrame.cancelFunc = function() --Using colorPickerData.startColors instead of ColorPickerFrame.previousValues[i]
		colorPickerData.activeColorPicker:SetBackdropColor(
			colorPickerData.startColors.r,
			colorPickerData.startColors.g,
			colorPickerData.startColors.b,
			colorPickerData.startColors.a or 1
		)
		colorPickerData.onCancel()
	end
	--Ready
	ColorPickerFrame:Show()
end
---Add a color picker button child to a custom color picker frame
---@param t table Parameters are to be provided in this table
--- - **picker** [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) — The frame to set as the parent of the new color picker button
--- - **setColors** function — The function to be called to set the colors of the color picker on load or update
--- 	- @*return* **r** number ― Red (Range: 0 - 1)
--- 	- @*return* **g** number ― Green (Range: 0 - 1)
--- 	- @*return* **b** number ― Blue (Range: 0 - 1)
--- 	- @*return* **a**? number *optional* ― Opacity (Range: 0 - 1, Default: 1)
--- - **onColorUpdate** function — The function to be called when the color has been changed
--- - **onOpacityUpdate**? function *optinal* — The function to be called when the opacity is changed
--- - **onCancel** function — The function to be called when the color change is cancelled
---@return Button pickerButton
local function AddColorPickerButton(t)
	local pickerButton = CreateFrame("Button", t.picker:GetName() .. "ColorPicker", t.picker, BackdropTemplateMixin and "BackdropTemplate")
	--Position & dimensions
	pickerButton:SetPoint("TOPLEFT", 0, -18)
	pickerButton:SetSize(34, 18)
	--Art
	local r, g, b, a = t.setColors()
	pickerButton:SetBackdrop({
		bgFile = "Interface/ChatFrame/ChatFrameBackground",
		edgeFile = "Interface/ChatFrame/ChatFrameBackground",
		tile = true, tileSize = 5, edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	pickerButton:SetBackdropColor(r, g, b, a or 1)
	pickerButton:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8)
	--Events & behaviour
	pickerButton:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(0.7, 0.7, 0.7, 0.8) end)
	pickerButton:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8) end)
	pickerButton:SetScript("OnClick", function()
		local red, green, blue, alpha = t.setColors()
		colorPickerData = {
			activeColorPicker = pickerButton,
			startColors = { r = red, g = green, b = blue, a = alpha },
			onColorUpdate = t.onColorUpdate,
			onOpacityUpdate = t.onOpacityUpdate,
			onCancel = t.onCancel
		}
		OpenColorPicker()
	end)
	pickerButton:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
	--Tooltip
	pickerButton:HookScript("OnEnter", function()
		local tooltip = strings.color.picker.tooltip
		if a ~= nil and t.onOpacityUpdate ~= nil then
			tooltip = strings.color.picker.tooltip:gsub("#ALPHA", strings.color.picker.alpha)
		else
			tooltip = strings.color.picker.tooltip:gsub("#ALPHA", "")
		end
		AddTooltip(movSpeedTooltip, pickerButton, "ANCHOR_TOPLEFT", strings.color.picker.label, tooltip, nil, 20, nil)
	end)
	pickerButton:HookScript("OnLeave", function() movSpeedTooltip:Hide() end)
	return pickerButton
end
---Set up the built-in Color Picker and create a button as a child of an options frame to open it
---@param t table Parameters are to be provided in this table
--- - **parent** [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) — The frame to set as the parent of the new color picker button
--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
--- 	- **offset**? table *optional*
--- 		- **x** number
--- 		- **y** number
--- - **size**? table *optional*
--- 	- **width**? number *optional* ― (Default: 120)
--- 	- **height**? number *optional* ― (Default: 24)
--- - **label** string — Title text to be shown above the color picker button and as the the tooltip label
--- - **tooltip**? table *optional* — Additional text lines to be added to the tooltip of the color picker button
--- 	- **text** string ― Text to be added to the line
--- 	- **wrap** boolean ― Append the text in a new line or not
---	 	- **color**? table *optional* ― RGB colors line
--- 		- **r** number ― Red (Range: 0 - 1)
--- 		- **g** number ― Green (Range: 0 - 1)
--- 		- **b** number ― Blue (Range: 0 - 1)
--- - **setColors** function — The function to be called to set the colors of the color picker on load or update
--- 	- @*return* **r** number ― Red (Range: 0 - 1)
--- 	- @*return* **g** number ― Green (Range: 0 - 1)
--- 	- @*return* **b** number ― Blue (Range: 0 - 1)
--- 	- @*return* **a**? number *optional* ― Opacity (Range: 0 - 1, Default: 1)
--- - **onColorUpdate** function — The function to be called when the color has been changed
--- - **onOpacityUpdate**? function *optinal* — The function to be called when the opacity is changed
--- - **onCancel** function — The function to be called when the color change is cancelled
---@return Frame pickerFrame
---@return Button pickerButton
---@return EditBox pickerBox
local function CreateColorPicker(t)
	local pickerFrame = CreateFrame("Frame", t.parent:GetName() .. t.label:gsub("%s+", "") .. "PickerFrame", t.parent)
	--Position & dimensions
	local frameWidth = (t.size or {}).width or 120
	PositionFrame(pickerFrame, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y)
	pickerFrame:SetSize(frameWidth, (t.size or {}).height or 36)
	--Title
	AddTitle({
		frame = pickerFrame,
		title = {
			text = t.label,
			offset = { x = 4, y = 0 },
			template = "GameFontNormal"
		}
	})
	--Add color picker button to open the Blizzard Color Picker
	local pickerButton = AddColorPickerButton({
		picker = pickerFrame,
		setColors = t.setColors,
		onColorUpdate = t.onColorUpdate,
		onOpacityUpdate = t.onOpacityUpdate,
		onCancel = t.onCancel
	})
	--Add edit box to change the color via HEX code
	local _, _, x, aa = t.setColors()
	if aa ~= nil and t.onOpacityUpdate ~= nil then
		x = 2
		aa = "AA"
	else
		x = 0
		aa = ""
	end
	local pickedBox = CreateEditBox({
		parent = pickerFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 44, y = 0 }
		},
		size = { width = frameWidth - 44 },
		maxLetters = 7 + x,
		text = "#" .. "", --TODO: Set the text to the current color
		label = strings.color.hex.label,
		title = false,
		tooltip = strings.color.hex.tooltip .. "\n\n" .. strings.misc.example .. ": #2266BB" .. aa,
		onEnterPressed = function(self)
			--TODO: Update the color with the code entered
		end,
		onEscapePressed = function(self)
			self:SetText("") --TODO: Update text with the current color
		end
	})
	return pickerFrame, pickerButton, pickedBox
end

--[[ GUI OPTIONS ]]

--Options frame
local options = { appearance = { backdrop = {} }, font = {} }

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
	--Button & Popup: Reset default preset position
	local defaultPopup = CreatePopup({
		name = strings.options.position.default.label,
		text = strings.options.position.default.warning,
		onAccept = function() DefaultPreset() end
	})
	local default = CreateButton({
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
	--Button & Popup: Set to preset position
	local resetPopup = CreatePopup({
		name = strings.options.position.reset.label,
		text = strings.options.position.reset.warning,
		onAccept = function() ResetPosition() end
	})
	CreateButton({
		parent = parentFrame,
		position = {
			anchor = "TOPRIGHT",
			relativeTo = default,
			relativePoint = "TOPLEFT",
			offset = { x = -4, y = 0 }
		},
		width = 120,
		label = strings.options.position.reset.label,
		tooltip = strings.options.position.reset.tooltip,
		onClick = function() StaticPopup_Show(resetPopup) end
	})
end
local function CreateAppearanceOptions(parentFrame)
	--Checkbox: Hidden
	options.appearance.hidden = CreateCheckbox({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 8, y = -30 }
		},
		label = strings.options.appearance.hidden.label,
		tooltip = strings.options.appearance.hidden.tooltip,
		onClick = function(self) FlipVisibility(self:GetChecked()) end
	})
	--Color Picker: Background color
	local function UpdateFontColor()
		if movSpeedBackdrop:GetBackdrop() ~= nil then
			local r, g, b = ColorPickerFrame:GetColorRGB()
			movSpeedBackdrop:SetBackdropColor(r, g, b, OpacitySliderFrame:GetValue() or 1)
		end
	end
	_, options.appearance.backdrop.color = CreateColorPicker({
		parent = parentFrame,
		position = {
			anchor = "TOP",
			offset = { x = 0, y = -64 }
		},
		label = strings.options.appearance.backdrop.color.label,
		opacity = true,
		setColors = function()
			if movSpeedBackdrop:GetBackdrop() ~= nil then return movSpeedBackdrop:GetBackdropColor() end
			return db.appearance.backdrop.color.r, db.appearance.backdrop.color.g, db.appearance.backdrop.color.b, db.appearance.backdrop.color.a
		end,
		onColorUpdate = UpdateFontColor,
		onOpacityUpdate = UpdateFontColor,
		onCancel = function()
			if movSpeedBackdrop:GetBackdrop() ~= nil then
				movSpeedBackdrop:SetBackdropColor(
					db.appearance.backdrop.color.r,
					db.appearance.backdrop.color.g,
					db.appearance.backdrop.color.b,
					db.appearance.backdrop.color.a
				)
			end
		end
	})
	--Checkbox: Backdrop
	options.appearance.backdrop.visible = CreateCheckbox({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			relativeTo = options.appearance.hidden,
			relativePoint = "BOTTOMLEFT",
			offset = { x = 0, y = -4 }
		},
		label = strings.options.appearance.backdrop.label,
		tooltip = strings.options.appearance.backdrop.tooltip,
		onClick = function(self) SetDisplayBackdrop(self:GetChecked(), options.appearance.backdrop.color:GetBackdropColor()) end
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
		onValueChanged = function(self)
			textDisplay:SetFont(textDisplay:GetFont(), self:GetValue(), "THINOUTLINE")
			SetDisplaySize(self:GetValue())
		end
	})
	--Color Picker: Font color
	local function UpdateFontColor()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		textDisplay:SetTextColor(r, g, b, OpacitySliderFrame:GetValue() or 1)
	end
	_, options.font.color = CreateColorPicker({
		parent = parentFrame,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -12, y = -30 }
		},
		label = strings.options.font.color.label,
		opacity = true,
		setColors = function() return textDisplay:GetTextColor() end,
		onColorUpdate = UpdateFontColor,
		onOpacityUpdate = UpdateFontColor,
		onCancel = function() textDisplay:SetTextColor(db.font.color.r, db.font.color.g, db.font.color.b, db.font.color.a) end
	})
end
--Category frames
local function CreateCategoryPanels(parentFrame)
	--Position
	local positionOptions = CreateCategory({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 16, y = -82 }
		},
		size = { height = 64 },
		title = strings.options.position.title,
		description = strings.options.position.description
	})
	CreatePositionOptions(positionOptions)
	--Appearance
	local appearanceOptions = CreateCategory({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			relativeTo = positionOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { x = 0, y = -32 }
		},
		size = { height = 112 },
		title = strings.options.appearance.title,
		description = strings.options.appearance.description
	})
	CreateAppearanceOptions(appearanceOptions)
	--Font
	local fontOptions = CreateCategory({
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
--Main options frame
local function CreateOptionsPanel()
	local optionsPanel = CreateFrame("Frame", "MovementSpeedOptions", InterfaceOptionsFramePanelContainer)
	optionsPanel:SetSize(InterfaceOptionsFramePanelContainer:GetSize())
	optionsPanel:SetPoint("TOPLEFT") --Preload the frame
	optionsPanel:Hide()
	--Title & description
	local _, description = AddTitle({
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
	--Appearance
	db.appearance.hidden = options.appearance.hidden:GetChecked()
	db.appearance.backdrop.visible = options.appearance.backdrop.visible:GetChecked()
	db.appearance.backdrop.color.r, db.appearance.backdrop.color.g, db.appearance.backdrop.color.b, db.appearance.backdrop.color.a = options.appearance.backdrop.color:GetBackdropColor()
	--Font
	db.font.family = textDisplay:GetFont()
	db.font.size = options.font.size:GetValue()
	db.font.color.r, db.font.color.g, db.font.color.b, db.font.color.a = options.font.color:GetBackdropColor()
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
	--Appearance
	options.appearance.hidden:SetChecked(db.appearance.hidden)
	options.appearance.backdrop.visible:SetChecked(db.appearance.backdrop.visible)
	options.appearance.backdrop.color:SetBackdropColor(
		db.appearance.backdrop.color.r,
		db.appearance.backdrop.color.g,
		db.appearance.backdrop.color.b,
		db.appearance.backdrop.color.a
	)
	--Font
	UIDropDownMenu_SetSelectedValue(options.font.family, GetFontID(db.font.family))
	UIDropDownMenu_SetText(options.font.family, fonts[GetFontID(db.font.family)].text)
	options.font.size:SetValue(db.font.size)
	options.font.color:SetBackdropColor(db.font.color.r, db.font.color.g, db.font.color.b, db.font.color.a)
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
	movSpeed:SetFrameStrata(db.appearance.frameStrata)
	movSpeed:SetToplevel(true)
	movSpeed:SetSize(33, 10)
	if not movSpeed:IsUserPlaced() then
		movSpeed:ClearAllPoints()
		movSpeed:SetPoint(defaultDB.position.point, defaultDB.position.offset.x, defaultDB.position.offset.y)
		movSpeed:SetUserPlaced(true)
	end
	--Backdrop
	SetDisplaySize(db.font.size)
	movSpeedBackdrop:SetPoint("CENTER")
	--Text
	textDisplay:SetPoint("CENTER") --TODO: Add font offset option to fine-tune the position (AND/OR, ad pre-tested offsets to keep each font in the center)
	--Visual elements
	SetDisplayValues()
end
local function SetUpTooltip()
	movSpeedTooltip:SetFrameStrata("DIALOG")
	movSpeedTooltip:SetScale(0.9)
	--Title font
	movSpeedTooltip:AddFontStrings(
		movSpeedTooltip:CreateFontString(movSpeedTooltip:GetName() .. "TextLeft1", nil, "GameTooltipHeaderText"),
		movSpeedTooltip:CreateFontString(movSpeedTooltip:GetName() .. "TextRight1", nil, "GameTooltipHeaderText")
	)
	_G[movSpeedTooltip:GetName() .. "TextLeft1"]:SetFontObject(GameTooltipHeaderText) --TODO: It's not the right font object (too big), find another one that mathces (or create a custom one)
	_G[movSpeedTooltip:GetName() .. "TextRight1"]:SetFontObject(GameTooltipHeaderText)
	--Text font
	movSpeedTooltip:AddFontStrings(
		movSpeedTooltip:CreateFontString(movSpeedTooltip:GetName() .. "TextLeft" .. 2, nil, "GameTooltipTextSmall"),
		movSpeedTooltip:CreateFontString(movSpeedTooltip:GetName() .. "TextRight" .. 2, nil, "GameTooltipTextSmall")
	)
	_G[movSpeedTooltip:GetName() .. "TextLeft" .. 2]:SetFontObject(GameTooltipTextSmall)
	_G[movSpeedTooltip:GetName() .. "TextRight" .. 2]:SetFontObject(GameTooltipTextSmall)
end

--Making the frame moveable
movSpeed:SetMovable(true)
movSpeedBackdrop:SetScript("OnMouseDown", function(self)
	if (IsShiftKeyDown() and not self.isMoving) then
		movSpeed:StartMoving()
		self.isMoving = true
	end
end)
movSpeedBackdrop:SetScript("OnMouseUp", function(self)
	if (self.isMoving) then
		movSpeed:StopMovingOrSizing()
		self.isMoving = false
	end
end)

--Hide during Pet Battle
function movSpeed:PET_BATTLE_OPENING_START()
	movSpeedBackdrop:Hide()
end
function movSpeed:PET_BATTLE_CLOSE()
	movSpeedBackdrop:Show()
end


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
		elseif k == "hidden" then
			db.appearance.hidden = v
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
	local unit = "player"
	if  UnitInVehicle("player") then
		unit = "vehicle"
	end
	textDisplay:SetText(string.format("%d%%", math.floor(GetUnitSpeed(unit) / 7 * 100 + .5)))
end
movSpeed:SetScript("OnUpdate", function(self)
	UpdateSpeed()
end)