--Addon name, namespace
local addonNameSpace, ns = ...
local _, addon = GetAddOnInfo(addonNameSpace)


--[[ STRINGS & LOCALIZATION ]]

local strings = {}

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


--[[ ASSETS & RESOURCES ]]

--Color palette
local colors = {
	lg = "|cFF" .. "8FD36E", --light green
	sg = "|cFF" .. "4ED836", --strong green
	ly = "|cFF" .. "FFFB99", --light yellow
	sy = "|cFF" .. "FFDD47", --strong yellow
	ui = {
		normal = {},
		title = {},
	}
}
colors.ui.normal.r, colors.ui.normal.g, colors.ui.normal.b = HIGHLIGHT_FONT_COLOR:GetRGB()
colors.ui.title.r, colors.ui.title.g, colors.ui.title.b = NORMAL_FONT_COLOR:GetRGB()

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
local function RestoreOldData(dbToSaveTo) --Restore old data to the DB by matching removed items to known old keys
	for k,v in pairs(oldData) do
		if k == "offsetX" then
			dbToSaveTo.position.offset.x = v
		elseif k == "offsetY" then
			dbToSaveTo.position.offset.y = v
		elseif k == "hidden" then
			dbToSaveTo.appearance.hidden = v
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

---Convert RGB(A) color values (Range: 0 - 1) to HEX color code
---@param r number Red (Range: 0 - 1)
---@param g number Green (Range: 0 - 1)
---@param b number Blue (Range: 0 - 1)
---@param a? number Alpha (Range: 0 - 1)
---@return string hex Color code in HEX format (Examples: RGB - "#2266BB", RGBA - "#2266BBAA")
local function ColorToHex(r, g, b, a)
	local hex = "#" .. string.format("%02x", math.ceil(r * 255)) .. string.format("%02x", math.ceil(g * 255)) .. string.format("%02x", math.ceil(b * 255))
	if a ~= nil then hex = hex .. string.format("%02x", math.ceil(a * 255)) end
	return hex:upper()
end
---Convert a HEX color code into RGB or RGBA (Range: 0 - 1)
---@param hex string String in HEX color code format (Example: RGB - "#2266BB", RGBA - "#2266BBAA" where the "#" is optional)
---@return number r Red value (Range: 0 - 1)
---@return number g Green value (Range: 0 - 1)
---@return number b Blue value (Range: 0 - 1)
---@return number? a Alpha value (Range: 0 - 1)
local function HexToColor(hex)
	hex = hex:gsub("#", "")
	if hex:len() ~= 6 and hex:len() ~= 8 then return nil end
	local r = tonumber(hex:sub(1, 2), 16) / 255
	local g = tonumber(hex:sub(3, 4), 16) / 255
	local b = tonumber(hex:sub(5, 6), 16) / 255
	if hex:len() == 8 then
		local a = tonumber(hex:sub(7, 8), 16) / 255
		return r, g, b, a
	else
		return r, g, b
	end
end


--[[ OPTIONS SETTERS ]]

--Main frame positioning
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
	movSpeedBackdrop:SetSize(width, height)
end

---Set the backdrop of the main display
---@param toggle boolean Set or remove backdrop
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

---Set the visibility, backdrop, font family, size and color of the main display to the currently saved values
---@param data table DB table to set the main display values from
local function SetDisplayValues(data)
	--Visibility
	FlipVisibility(data.appearance.hidden)
	--Backdrop
	SetDisplaySize(data.font.size)
	SetDisplayBackdrop(
		data.appearance.backdrop.visible,
		data.appearance.backdrop.color.r,
		data.appearance.backdrop.color.g,
		data.appearance.backdrop.color.b,
		data.appearance.backdrop.color.a
	)
	--Font
	textDisplay:SetFont(data.font.family, data.font.size, "THINOUTLINE")
	textDisplay:SetTextColor(data.font.color.r, data.font.color.g, data.font.color.b, data.font.color.a)
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

--[ Custom Tooltip ]

---Set up a GameTooltip frame to be shown for a frame
---@param owner FrameType Owner frame the tooltip to be shown for
---@param anchor string [GameTooltip anchor](https://wowpedia.fandom.com/wiki/API_GameTooltip_SetOwner)
---@param title string String to be shown as the tooltip title
---@param text string String to be shown as the first line of tooltip summary
---@param textLines? table Numbered table containing additional string lines to be added to the tooltip text
--- - **text** string ― Text to be added to the line
--- - **color**? table *optional* ― RGB colors line
--- 	- **r** number ― Red (Range: 0 - 1)
--- 	- **g** number ― Green (Range: 0 - 1)
--- 	- **b** number ― Blue (Range: 0 - 1)
--- - **wrap**? boolean *optional* ― Allow wrapping the line (Default: true)
---@param offsetX? number (Default: 0)
---@param offsetY? number (Default: 0)
local function AddTooltip(tooltip, owner, anchor, title, text, textLines, offsetX, offsetY)
	--Position
	tooltip:SetOwner(owner, anchor, offsetX, offsetY)
	--Title
	tooltip:AddLine(title, colors.ui.title.r, colors.ui.title.g, colors.ui.title.b, true)
	--Summary
	tooltip:AddLine(text, colors.ui.normal.r, colors.ui.normal.g, colors.ui.normal.b, true)
	--Additional text lines
	if textLines ~= nil then
		--Empty line after the summary
		tooltip:AddLine(" ", nil, nil, nil, true) --TODO: Check why the third line has the title FontObject
		for i = 0, #textLines do
			--Add line
			local r = (textLines[i].color or {}).r or colors.ui.normal.r
			local g = (textLines[i].color or {}).g or colors.ui.normal.g
			local b = (textLines[i].color or {}).b or colors.ui.normal.b
			tooltip:AddLine(textLines[i].text, r, g, b, textLines[i].wrap == nil and true or textLines[i].wrap)
		end
	end
	--Show
	tooltip:Show() --Don't forget to hide later!
end

--[ Frame Title & Description (optional) Text ]

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

--[ Interface Options Category Frame ]

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

--[ Texture Image ]

---Create a texture/image
---@param t table Parameters are to be provided in this table
--- - **parent** [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) — The frame to set as the parent of the new button
--- - **name** string — Used for a unique name, it will not be visible
--- - **path** string — Path to the texture file, filename
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

--[ Popup Dialogue Box ]

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
	local key = "MOVESPEED_" .. t.name:gsub("%s+", "_"):upper()
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

--[ Button ]

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
--- 	- **color**? table *optional* ― RGB colors line
--- 		- **r** number ― Red (Range: 0 - 1)
--- 		- **g** number ― Green (Range: 0 - 1)
--- 		- **b** number ― Blue (Range: 0 - 1)
--- 	- **wrap**? boolean *optional* ― Allow wrapping the line (Default: true)
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

--[ Checkbox ]

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

--[[ EditBox ]]

---Create an edit box frame as a child of an options frame
---@param editBox EditBox Parent frame of [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) type
---@param t table Parameters are to be provided in this table
--- - **multiline** boolean — Set to true if the edit box should be support multiple lines for the string input
--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" (Default: "LEFT")
--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" (Default: "MIDDLE")
--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) (Default: 0 [no limit])
--- - **fontObject**? FontString *optional*— Font template object to use (Default: default font template based on the frame template)
--- - **text**? string *optional* — Text to be shown inside edit box on load
--- - **onChar**? function *optional* — The function to be called when a character is entered. Can be used for excluding characters via pattern matching.
--- - **onEnterPressed** function — The function to be called when an [OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed) event happens
--- - **onEscapePressed** function — The function to be called when an [OnEscapePressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEscapePressed) event happens
---@return EditBox editBox
local function SetEditBox(editBox, t)
	--Font & text
	editBox:SetMultiLine(t.multiline)
	if t.fontObject ~= nil then editBox:SetFontObject(t.fontObject) end
	if t.justify ~= nil then
		if t.justify.h ~= nil then editBox:SetJustifyH(t.justify.h) end
		if t.justify.v ~= nil then editBox:SetJustifyV(t.justify.v) end
	end
	if t.maxLetters ~= nil then editBox:SetMaxLetters(t.maxLetters) end
	--Events & behavior
	editBox:SetAutoFocus(false)
	editBox:SetScript("OnShow", function(self) self:SetText(t.text or "") end)
	editBox:SetScript("OnChar", t.onChar)
	editBox:SetScript("OnEnterPressed", t.onEnterPressed)
	editBox:HookScript("OnEnterPressed", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		self:ClearFocus()
	end)
	editBox:SetScript("OnEscapePressed", t.onEscapePressed)
	editBox:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
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
--- - **width** number
--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" (Default: "LEFT")
--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" (Default: "MIDDLE")
--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) (Default: 0 [no limit])
--- - **fontObject**? FontString *optional*— Font template object to use (Default: default font template based on the frame template)
--- - **text**? string *optional* — Text to be shown inside edit box on load
--- - **label** string — Name of the edit box to be shown as the tooltip title and optionally as the title text
--- - **title**? boolean *optional* — Whether or not to add a title above the edit box (Default: true)
--- - **tooltip** string — Text to be shown as the tooltip of the button
--- - **tooltipExtra**? table *optional* — Additional text lines to be added to the tooltip of the button
--- 	- **text** string ― Text to be added to the line
--- 	- **color**? table *optional* ― RGB colors line
--- 		- **r** number ― Red (Range: 0 - 1)
--- 		- **g** number ― Green (Range: 0 - 1)
--- 		- **b** number ― Blue (Range: 0 - 1)
--- 	- **wrap**? boolean *optional* ― Allow wrapping the line (Default: true)
--- - **onChar**? function *optional* — The function to be called when a character is entered. Can be used for excluding characters via pattern matching.
--- - **onEnterPressed** function — The function to be called when an [OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed) event happens
--- - **onEscapePressed** function — The function to be called when an [OnEscapePressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEscapePressed) event happens
---@return EditBox editBox
local function CreateEditBox(t)
	local editBox = CreateFrame("EditBox", t.parent:GetName() .. (t.title and t.label:gsub("%s+", "") or "") .. "EditBox", t.parent, "InputBoxTemplate")
	--Position & dimensions
	PositionFrame(editBox, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) - 18)
	editBox:SetSize(t.size.width, 17)
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
	--Set up the edit box
	SetEditBox(editBox, {
		multiline = false,
		justify = t.justify,
		maxLetters = t.maxLetters,
		fontObject = t.fontObject,
		text = t.text,
		onChar = t.onChar,
		onEnterPressed = t.onEnterPressed,
		onEscapePressed = t.onEscapePressed
	})
	return editBox
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
--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" (Default: "LEFT")
--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" (Default: "MIDDLE")
--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) (Default: 0 [no limit])
--- - **charCount**? boolean — Show or hide the remaining number of characters (Default: true)
--- - **fontObject**? FontString *optional*— Font template object to use (Default: default font template based on the frame template)
--- - **text**? string *optional* — Text to be shown inside edit box on load
--- - **label** string — Name of the edit box to be shown as the tooltip title and optionally as the title text
--- - **title**? boolean *optional* — Whether or not to add a title above the edit box (Default: true)
--- - **tooltip** string — Text to be shown as the tooltip of the button
--- - **tooltipExtra**? table *optional* — Additional text lines to be added to the tooltip of the button
--- 	- **text** string ― Text to be added to the line
--- 	- **color**? table *optional* ― RGB colors line
--- 		- **r** number ― Red (Range: 0 - 1)
--- 		- **g** number ― Green (Range: 0 - 1)
--- 		- **b** number ― Blue (Range: 0 - 1)
--- 	- **wrap**? boolean *optional* ― Allow wrapping the line (Default: true)
--- - **onChar**? function *optional* — The function to be called when a character is entered. Can be used for excluding characters via pattern matching.
--- - **onEnterPressed** function — The function to be called when an [OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed) event happens
--- - **onEscapePressed** function — The function to be called when an [OnEscapePressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEscapePressed) event happens
---@return EditBox
---@return Frame scrollFrame
local function CreateEditScrollBox(t)
	local scrollFrame = CreateFrame("ScrollFrame", t.parent:GetName() .. t.label:gsub("%s+", "") .. "EditBox", t.parent, "InputScrollFrameTemplate")
	--Position & dimensions
	PositionFrame(scrollFrame, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) - 20)
	scrollFrame:SetSize(t.size.width, t.size.height)
	local function ResizeEditBox()
		local scrollBarOffset = _G[scrollFrame:GetName().."ScrollBar"]:IsShown() and 16 or 0
		local counterOffset = t.charCount ~= false and tostring(t.maxLetters - scrollFrame.EditBox:GetText():len()):len() * 6 + 3 or 0
		scrollFrame.EditBox:SetWidth(scrollFrame:GetWidth() - scrollBarOffset - counterOffset)
	end
	ResizeEditBox()
	--Character counter
	if t.charCount == false then scrollFrame.CharCount:Hide() end
	scrollFrame.CharCount:SetFontObject("GameFontDisableTiny2")
	--Title
	if t.title ~= false then
		AddTitle({
			frame = scrollFrame,
			title = {
				text = t.label,
				offset = { x = -1, y = 20 },
				template = "GameFontNormal"
			}
		})
	end
	--Tooltip
	scrollFrame.EditBox:HookScript("OnEnter", function() AddTooltip(movSpeedTooltip, scrollFrame, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra, nil, nil) end)
	scrollFrame.EditBox:HookScript("OnLeave", function() movSpeedTooltip:Hide() end)
	--Set up the EditBox
	SetEditBox(scrollFrame.EditBox, {
		multiline = true,
		justify = t.justify,
		maxLetters = t.maxLetters,
		fontObject = t.fontObject or "ChatFontNormal",
		text = t.text,
		onChar = t.onChar,
		onEnterPressed = t.onEnterPressed,
		onEscapePressed = t.onEscapePressed
	})
	scrollFrame.EditBox:HookScript("OnTextChanged", ResizeEditBox)
	scrollFrame.EditBox:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
	scrollFrame.EditBox:HookScript("OnEditFocusLost", function(self) self:HighlightText(0, 0) end)
	return scrollFrame.EditBox, scrollFrame
end

--[ Value Slider ]

---Add a value box as a child to an existing slider frame
---@param slider Slider Parent frame of [Slider](https://wowpedia.fandom.com/wiki/UIOBJECT_Slider) type
---@param value table Parameters are to be provided in this table
--- - **min** number — Lower numeric value limit of the slider
--- - **max** number — Upper numeric value limit of the slider
--- - **step** number — Numeric value step of the slider
---@return EditBox valueBox
local function AddSliderValueBox(slider, value)
	local valueBox = CreateFrame("EditBox", slider:GetName() .. "ValueBox", slider, BackdropTemplateMixin and "BackdropTemplate")
	--Calculate the required number of fractal digits
	local fractionalDigits = max(
		tostring(value.min - math.floor(value.min)):gsub("0%.*([%d]*)", "%1"):len(),
		tostring(value.max - math.floor(value.max)):gsub("0%.*([%d]*)", "%1"):len(),
		tostring(value.step - math.floor(value.step)):gsub("0%.*([%d]*)", "%1"):len()
	)
	--Position & dimensions
	valueBox:SetPoint("TOP", slider, "BOTTOM")
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
	valueBox:SetMaxLetters(tostring(math.floor(value.max)):len() + (fractionalDigits + (fractionalDigits > 0 and 1 or 0))) --(+ 1) for the decimal point (if it's fractional)
	--Events & behavior
	valueBox:SetAutoFocus(false)
	valueBox:SetScript("OnShow", function(self) self:SetText(slider:GetValue()) end)
	valueBox:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(0.7, 0.7, 0.7, 0.8) end)
	valueBox:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8) end)
	valueBox:SetScript("OnEnterPressed", function(self)
		local value = max(value.min, min(value.max, floor(self:GetNumber() * (1 / value.step) + 0.5) / (1 / value.step)))
		self:SetText(value)
		slider:SetValue(value)
	end)
	valueBox:HookScript("OnEnterPressed", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		self:ClearFocus()
	end)
	valueBox:SetScript("OnEscapePressed", function(self) self:SetText(slider:GetValue()) end)
	valueBox:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
	valueBox:SetScript("OnChar", function(self)
		if fractionalDigits > 0 then
			self:SetText(self:GetText():gsub("([%d]*)([%.]?)([%d]*).*", "%1%2%3"))
		else
			self:SetText(self:GetText():gsub("%D", ""))
		end
	end)
	slider:HookScript("OnValueChanged", function(_, value) valueBox:SetText(value) end)
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
	local valueBox = AddSliderValueBox(slider, { min = t.value.min, max = t.value.max, step = t.value.step })
	return slider, valueBox
end

--[ Dropdown Menu ]

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
--- - **title**? boolean *optional* — Whether or not to add a title above the dropdown menu (Default: true)
--- - **tooltip** string — Text to be shown as the tooltip of the dropdown
--- - **tooltipExtra**? table *optional* — Additional text lines to be added to the tooltip of the dropdown
--- 	- **text** string ― Text to be added to the line
--- 	- **color**? table *optional* ― RGB colors line
--- 		- **r** number ― Red (Range: 0 - 1)
--- 		- **g** number ― Green (Range: 0 - 1)
--- 		- **b** number ― Blue (Range: 0 - 1)
--- 	- **wrap**? boolean *optional* ― Allow wrapping the line (Default: true)
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

--[ Color Picker ]

--Addon-scope data bust be used to stop the separate color pickers from interfering with each other through the global Blizzard Color Picker frame
local colorPickerData = {}

--Set up functions to clear the current colorPickerData when the Blizzard Color Picker is used
-- ColorPickerOkayButton:HookScript("OnClick", function() colorPickerData = {} end)
-- ColorPickerCancelButton:HookScript("OnClick", function() colorPickerData = {} end)

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
	local function ColorUpdate()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		colorPickerData.activeColorPicker:SetBackdropColor(r, g, b, OpacitySliderFrame:GetValue() or 1)
		_G[colorPickerData.activeColorPicker:GetName():gsub("Button", "EditBox")]:SetText(ColorToHex(r, g, b, OpacitySliderFrame:GetValue() or 1))
	end
	--RGB
	ColorPickerFrame:SetColorRGB(colorPickerData.startColors.r, colorPickerData.startColors.g, colorPickerData.startColors.b)
	ColorPickerFrame.func = function()
		ColorUpdate()
		colorPickerData.onColorUpdate()
	end
	--Alpha
	ColorPickerFrame.hasOpacity = colorPickerData.onOpacityUpdate ~= nil and colorPickerData.startColors.a ~= nil
	if ColorPickerFrame.hasOpacity then
		ColorPickerFrame.opacity = colorPickerData.startColors.a
		ColorPickerFrame.opacityFunc = function()
			ColorUpdate()
			colorPickerData.onOpacityUpdate()
		end
	end
	--Reset
	ColorPickerFrame.cancelFunc = function()
		colorPickerData.activeColorPicker:SetBackdropColor(
			colorPickerData.startColors.r,
			colorPickerData.startColors.g,
			colorPickerData.startColors.b,
			colorPickerData.startColors.a or 1
		) --Using colorPickerData.startColors[k] instead of ColorPickerFrame.previousValues[i]
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
--- - **onOpacityUpdate**? function *optional* — The function to be called when the opacity is changed
--- - **onCancel** function — The function to be called when the color change is cancelled
---@return Button pickerButton
local function AddColorPickerButton(t)
	local pickerButton = CreateFrame("Button", t.picker:GetName() .. "Button", t.picker, BackdropTemplateMixin and "BackdropTemplate")
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
	--Events & behavior
	pickerButton:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(0.7, 0.7, 0.7, 0.8) end)
	pickerButton:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8) end)
	pickerButton:SetScript("OnClick", function()
		local red, green, blue, alpha = pickerButton:GetBackdropColor()
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
--- 	- **color**? table *optional* ― RGB colors line
--- 		- **r** number ― Red (Range: 0 - 1)
--- 		- **g** number ― Green (Range: 0 - 1)
--- 		- **b** number ― Blue (Range: 0 - 1)
--- 	- **wrap**? boolean *optional* ― Allow wrapping the line (Default: true)
--- - **setColors** function — The function to be called to set the colors of the color picker on load or update
--- 	- @*return* **r** number ― Red (Range: 0 - 1)
--- 	- @*return* **g** number ― Green (Range: 0 - 1)
--- 	- @*return* **b** number ― Blue (Range: 0 - 1)
--- 	- @*return* **a**? number *optional* ― Opacity (Range: 0 - 1, Default: 1)
--- - **onColorUpdate** function — The function to be called when the color has been changed
--- - **onOpacityUpdate**? function *optional* — The function to be called when the opacity is changed
--- - **onCancel** function — The function to be called when the color change is cancelled
---@return Frame pickerFrame
---@return Button pickerButton
---@return EditBox pickerBox
local function CreateColorPicker(t)
	local pickerFrame = CreateFrame("Frame", t.parent:GetName() .. t.label:gsub("%s+", "") .. "ColorPicker", t.parent)
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
	local r, g, b, a = t.setColors()
	local alpha = a ~= nil and t.onOpacityUpdate ~= nil
	local hexBox = CreateEditBox({
		parent = pickerFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 44, y = 0 }
		},
		size = { width = frameWidth - 44 },
		maxLetters = 7 + (alpha and 2 or 0),
		fontObject = "GameFontWhiteSmall",
		text = ColorToHex(r, g, b, a),
		label = strings.color.hex.label,
		title = false,
		tooltip = strings.color.hex.tooltip .. "\n\n" .. strings.misc.example .. ": #2266BB" .. (alpha and "AA" or ""),
		onChar = function(self) self:SetText(self:GetText():gsub("^(#?)([%x]*).*", "%1%2")) end,
		onEnterPressed = function(self)
			pickerButton:SetBackdropColor(HexToColor(self:GetText()))
			t.onColorUpdate()
			if t.onOpacityUpdate ~= nil then t.onOpacityUpdate() end
			self:SetText(self:GetText():upper())
		end,
		onEscapePressed = function(self) self:SetText(ColorToHex(pickerButton:GetBackdropColor())) end
	})
	return pickerFrame, pickerButton, hexBox
end

--[[ GUI OPTIONS ]]

--Options frame references
local options = { appearance = { backdrop = { color = {} } }, font = { color = {} }, backup = {} }

--Backup management
local LoadData --Defined after interface options definitions

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
	local function UpdateBackdropColor()
		if movSpeedBackdrop:GetBackdrop() ~= nil then
			local r, g, b = ColorPickerFrame:GetColorRGB()
			movSpeedBackdrop:SetBackdropColor(r, g, b, OpacitySliderFrame:GetValue() or 1)
		end
	end
	_, options.appearance.backdrop.color.picker, options.appearance.backdrop.color.hex = CreateColorPicker({
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
		onColorUpdate = UpdateBackdropColor,
		onOpacityUpdate = UpdateBackdropColor,
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
		onClick = function(self) SetDisplayBackdrop(self:GetChecked(), options.appearance.backdrop.color.picker:GetBackdropColor()) end
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
	options.font.family = CreateDropdown({
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
			[2] = { text = "[WoW]\\Interface\\AddOns\\MovementSpeed\\Fonts\\", color = { r = 0.185, g = 0.72, b = 0.84 }, wrap = false },
			[3] = { text = strings.options.font.family.tooltip[3]:gsub("#FILE_CUSTOM", "CUSTOM.ttf") },
			[4] = { text = strings.options.font.family.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 } },
		},
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
	_, options.font.color.picker, options.font.color.hex = CreateColorPicker({
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
local function CreateBackupOptions(parentFrame)
	--Import & Export Box
	options.backup.string = CreateEditScrollBox({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			offset = { x = 18, y = -30 }
		},
		size = { width = 556, height = 38 },
		maxLetters = 512,
		fontObject = "GameFontDisableSmall",
		text = TableToString(db, true),
		label = strings.options.backup.box.label,
		tooltip = strings.options.backup.box.tooltip[0],
		tooltipExtra = {
			[0] = { text = strings.options.backup.box.tooltip[1] },
			[1] = { text = "\n" .. strings.options.backup.box.tooltip[2]:gsub("#ENTER", "ENTER") },
			[2] = { text = strings.options.backup.box.tooltip[3], color = { r = 0.89, g = 0.65, b = 0.40 } },
		},
		onEnterPressed = function(self) LoadData(self:GetText()) end,
		onEscapePressed = function(self) self:SetText(TableToString(db, true)) end
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
	---Backup
	local backupOptions = CreateCategory({
		parent = parentFrame,
		position = {
			anchor = "TOPLEFT",
			relativeTo = fontOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { x = 0, y = -32 }
		},
		size = { height = 104 },
		title = strings.options.backup.title,
		description = strings.options.backup.description
	})
	CreateBackupOptions(backupOptions)
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
	db.appearance.backdrop.color.r, db.appearance.backdrop.color.g, db.appearance.backdrop.color.b, db.appearance.backdrop.color.a = options.appearance.backdrop.color.picker:GetBackdropColor()
	--Font
	db.font.family = textDisplay:GetFont()
	db.font.size = options.font.size:GetValue()
	db.font.color.r, db.font.color.g, db.font.color.b, db.font.color.a = options.font.color.picker:GetBackdropColor()
end
local function Cancel() --Refresh() is called automatically
	SetDisplayValues(db)
end
local function Default() --Refresh() is called automatically
	MovementSpeedDB = Clone(defaultDB)
	db = Clone(defaultDB)
	SetDisplayValues(db)
	print(colors.sg .. addon .. ": " .. colors.ly .. strings.options.defaults)
end
---Update the interface option frames
---@param data table DB table to load the interface options from
local function Refresh(data)
	--Appearance
	options.appearance.hidden:SetChecked(data.appearance.hidden)
	options.appearance.backdrop.visible:SetChecked(data.appearance.backdrop.visible)
	options.appearance.backdrop.color.picker:SetBackdropColor(
		data.appearance.backdrop.color.r,
		data.appearance.backdrop.color.g,
		data.appearance.backdrop.color.b,
		data.appearance.backdrop.color.a
	)
	options.appearance.backdrop.color.hex:SetText(ColorToHex(
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
	options.font.color.hex:SetText(ColorToHex(data.font.color.r, data.font.color.g, data.font.color.b, data.font.color.a))
	--Backup
	options.backup.string:SetText(TableToString(data, true))
end

--Definition for loading data from an import string
LoadData = function(chunk)
	--Load from string to a temporary table
	local success, returned = pcall(loadstring("return " .. chunk))
	if success and type(returned) == "table" then
		local loadDB = returned
		--Run DB ckeckup on the loaded table
		RemoveEmpty(loadDB) --Strip empty and nil keys & items
		AddMissing(loadDB, db) --Check for missing data
		RemoveMismatch(loadDB, db) --Remove unneeded data
		RestoreOldData(loadDB) --Save old data
		--Update the interface options and the main display
		Refresh(loadDB)
		SetDisplayValues(loadDB)
	else print(colors.sg .. addon .. ": " .. colors.ly .. strings.options.backup.box.error) end
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
	optionsPanel.refresh = function() Refresh(db) end
	--Add the panel
	InterfaceOptions_AddCategory(optionsPanel)
end


--[[ CHAT CONTROL ]]

local keyword = "/movespeed"

--Print utilities
local function PrintStatus()
	print(colors.sg .. addon .. ": " .. colors.ly .. strings.chat.toggle.response:gsub("#HIDDEN", movSpeed:IsShown() and strings.chat.toggle.shown or strings.chat.toggle.hidden))
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
			command = strings.chat.options.command,
			description = strings.chat.options.description
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
			description =  strings.chat.size.description:gsub("#SIZE_DEFAULT", colors.lg .. strings.chat.size.command .. " " .. defaultDB.font.size .. colors.ly)
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
	elseif command == strings.chat.options.command then
		InterfaceOptionsFrame_OpenToCategory(addon)
	elseif command == strings.chat.save.command then
		SavePosition()
	elseif command == strings.chat.preset.command then
		ResetPosition()
	elseif command == strings.chat.reset.command then
		DefaultPreset()
	elseif command == strings.chat.toggle.command then
		FlipVisibility(movSpeed:IsVisible())
		db.appearance.hidden = not movSpeed:IsVisible()
		--Update the GUI option in case it was open
		options.appearance.hidden:SetChecked(db.appearance.hidden)
		--Response
		PrintStatus()
	elseif command == strings.chat.size.command then
		local size = tonumber(parameter)
		if size ~= nil then
			db.font.size = size
			textDisplay:SetFont(db.font.family, db.font.size, "THINOUTLINE")
			SetDisplaySize(size)
			--Update the GUI option in case it was open
			options.font.size:SetValue(size)
			--Response
			print(colors.sg .. addon .. ": " .. colors.ly .. strings.chat.size.response:gsub("#VALUE", size))
		else
			--Error
			print(colors.sg .. addon .. ": " .. colors.ly .. strings.chat.size.unchanged)
			print(colors.ly .. strings.chat.size.error:gsub("#SIZE_DEFAULT", colors.lg .. strings.chat.size.command .. " " .. defaultDB.font.size .. colors.ly))
		end
	else
		PrintHelp()
	end
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
	SetDisplayValues(db)
end
local function SetUpTooltip()
	movSpeedTooltip:SetFrameStrata("DIALOG")
	movSpeedTooltip:SetScale(0.9)
	--Title font
	movSpeedTooltip:AddFontStrings(
		movSpeedTooltip:CreateFontString(movSpeedTooltip:GetName() .. "TextLeft1", nil, "GameTooltipHeaderText"),
		movSpeedTooltip:CreateFontString(movSpeedTooltip:GetName() .. "TextRight1", nil, "GameTooltipHeaderText")
	)
	_G[movSpeedTooltip:GetName() .. "TextLeft1"]:SetFontObject(GameTooltipHeaderText) --TODO: It's not the right font object (too big), find another one that matches (or create a custom one)
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
movSpeedBackdrop:SetScript("OnMouseDown", function()
	if (IsShiftKeyDown() and not movSpeed.isMoving) then
		movSpeed:StartMoving()
		movSpeed.isMoving = true
	end
end)
movSpeedBackdrop:SetScript("OnMouseUp", function()
	if (movSpeed.isMoving) then
		movSpeed:StopMovingOrSizing()
		movSpeed.isMoving = false
	end
end)


--[[ INITIALIZATION ]]

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
	RestoreOldData(db) --Save old data
end
function movSpeed:ADDON_LOADED(addon)
	if addon ~= "MovementSpeed" then return end
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
function movSpeed:PLAYER_LOGIN()
	if not movSpeed:IsShown() then PrintStatus() end
end


--[[ DISPLAY UPDATE ]]

--Recalculate the movement speed value and update the displayed text
movSpeed:SetScript("OnUpdate", function()
	textDisplay:SetText(string.format("%d%%", math.floor(GetUnitSpeed("player") / 7 * 100 + .5)))
end)