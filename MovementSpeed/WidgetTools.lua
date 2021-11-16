if not WidgetToolsTable then
	--Global Reference Table
	WidgetToolsTable = {}


	--[ LOCALIZATIONS ]

	local english = {
		color = {
			picker = {
				label = "Pick a color",
				tooltip = "Click to open the color picker to customize the color#ALPHA.", --# flags will be replaced with code
				alpha = " and change the opacity",
			},
			hex = {
				label = "Add via HEX color code",
				tooltip = "You may change the color via HEX code instead of using the color picker.",
			}
		},
		misc = {
			cancel = "Cancel",
			example = "Example",
		},
	}


	--[[ ASSETS & RESOURCES ]]

	--Strings & Localization
	local function LoadLocale()
		local strings
		if (GetLocale() == "") then
			--TODO: Add localization for other languages (locales: https://wowwiki-archive.fandom.com/wiki/API_GetLocale#Locales)
			--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml
		else --Default: English (UK & US)
			strings = english
		end
		return strings
	end
	local strings = LoadLocale()

	--Color palette
	local colors = {
		normal = {},
		title = {},
	}
	colors.normal.r, colors.normal.g, colors.normal.b = HIGHLIGHT_FONT_COLOR:GetRGB()
	colors.title.r, colors.title.g, colors.title.b = NORMAL_FONT_COLOR:GetRGB()


	--[[ CONSTRUCTORS & SETTERS ]]

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

	--Create and set up a new custom Game Tooltip frame
	local function CreateGameTooltip(name)
		local tooltip = CreateFrame("GameTooltip", name .. "GameTooltip", nil, "GameTooltipTemplate")
		tooltip:SetFrameStrata("DIALOG")
		tooltip:SetScale(0.9)
		--Title font
		tooltip:AddFontStrings(
			tooltip:CreateFontString(tooltip:GetName() .. "TextLeft1", nil, "GameTooltipHeaderText"),
			tooltip:CreateFontString(tooltip:GetName() .. "TextRight1", nil, "GameTooltipHeaderText")
		)
		_G[tooltip:GetName() .. "TextLeft1"]:SetFontObject(GameTooltipHeaderText) --TODO: It's not the right font object (too big), find another one that matches (or create a custom one)
		_G[tooltip:GetName() .. "TextRight1"]:SetFontObject(GameTooltipHeaderText)
		--Text font
		tooltip:AddFontStrings(
			tooltip:CreateFontString(tooltip:GetName() .. "TextLeft" .. 2, nil, "GameTooltipTextSmall"),
			tooltip:CreateFontString(tooltip:GetName() .. "TextRight" .. 2, nil, "GameTooltipTextSmall")
		)
		_G[tooltip:GetName() .. "TextLeft" .. 2]:SetFontObject(GameTooltipTextSmall)
		_G[tooltip:GetName() .. "TextRight" .. 2]:SetFontObject(GameTooltipTextSmall)
		return tooltip
	end
	
	local customTooltip = CreateGameTooltip("WidgetToolsCustom")

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
	WidgetToolsTable.AddTooltip = function(tooltip, owner, anchor, title, text, textLines, offsetX, offsetY)
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
	--- 	- **template** string ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― (Default: "TOPLEFT")
	--- 	- **offset**? table *optional* ― The offset from the anchor point relative to the specified frame
	--- 		- **x** number ― Horizontal offset value
	--- 		- **y** number ― Vertical offset value
	--- 	- **width**? number *optional*
	--- 	- **justify**? table *optional* — Set the horizontal justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance): "LEFT"|"RIGHT"|"CENTER"
	--- - **description**? table *optional*
	--- 	- **text** string ― Text to be shown as the subtitle/description of the frame
	--- 	- **template** string ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
	--- 	- **offset**? table *optional* ― The offset from the BOTTOMLEFT point of the main title [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
	--- 		- **x** number ― Horizontal offset value
	--- 		- **y** number ― Vertical offset value
	--- 	- **width**? number *optional*
	--- 	- **justify**? table *optional* — Set the horizontal justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance): "LEFT"|"RIGHT"|"CENTER"
	---@return string|table title
	---@return string|table? description
	WidgetToolsTable.AddTitle = function(t)
		--Title
		local title = t.frame:CreateFontString(t.frame:GetName() .. "Title", "ARTWORK", t.title.template)
		title:SetPoint(t.title.anchor or "TOPLEFT", (t.title.offset or {}).x, (t.title.offset or {}).y)
		if t.title.width ~= nil then title:SetWidth(t.title.width) end
		if t.title.justify ~= nil then title:SetJustifyH(t.title.justify) end
		title:SetText(t.title.text)
		if t.description == nil then return title end
		--Description
		local description = t.frame:CreateFontString(t.frame:GetName() .. "Description", "ARTWORK", t.description.template)
		description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", (t.description.offset or {}).x, (t.description.offset or {}).y)
		if t.description.width ~= nil then description:SetWidth(t.description.width) end
		if t.description.justify ~= nil then description:SetJustifyH(t.description.justify) end
		description:SetText(t.description.text)
		return title, description
	end

	--[ Settings Category Frame ]

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
	WidgetToolsTable.CreateCategory = function(t)
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
		WidgetToolsTable.AddTitle({
			frame = category,
			title = {
				text = t.title,
				template = "GameFontNormal",
				offset = { x = 10, y = 16 }
			},
			description = {
				text = t.description,
				template = "GameFontHighlightSmall",
				offset = { x = 4, y = -16 }
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
	WidgetToolsTable.CreateTexture = function(t)
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
	WidgetToolsTable.CreatePopup = function(t)
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
	WidgetToolsTable.CreateButton = function(t)
		local button = CreateFrame("Button", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Button", t.parent, "UIPanelButtonTemplate")
		--Position & dimensions
		PositionFrame(button, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y)
		if t.width ~= nil then button:SetWidth(t.width) end
		--Font
		getglobal(button:GetName() .. "Text"):SetText(t.label)
		--Tooltip
		button:HookScript("OnEnter", function() WidgetToolsTable.AddTooltip(customTooltip, button, "ANCHOR_TOPLEFT", t.label, t.tooltip, t.tooltipExtra, 20, nil)	end)
		button:HookScript("OnLeave", function() customTooltip:Hide() end)
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
	WidgetToolsTable.CreateCheckbox = function(t)
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

	--[ EditBox ]

	---Create an edit box frame as a child of an options frame
	---@param editBox EditBox Parent frame of [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) type
	---@param t table Parameters are to be provided in this table
	--- - **multiline** boolean — Set to true if the edit box should be support multiple lines for the string input
	--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
	--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" (Default: "LEFT")
	--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" (Default: "MIDDLE")
	--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) (Default: 0 [no limit])
	--- - **fontObject**? FontString *optional*— Font template object to use (Default: default font template based on the frame template)
	--- - **text**? string *optional* — Text to be shown inside edit box, loaded whenever the text box is shown
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
		if t.text ~= nil then editBox:SetScript("OnShow", function(self) self:SetText(t.text) end) end
		if t.onChar ~= nil then editBox:SetScript("OnChar", t.onChar) end
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
	--- - **text**? string *optional* — Text to be shown inside edit box, loaded whenever the text box is shown
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
	WidgetToolsTable.CreateEditBox = function(t)
		local editBox = CreateFrame("EditBox", t.parent:GetName() .. (t.title and t.label:gsub("%s+", "") or "") .. "EditBox", t.parent, "InputBoxTemplate")
		--Position & dimensions
		PositionFrame(editBox, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) - 18)
		editBox:SetSize(t.size.width, 17)
		--Title
		if t.title ~= false then
			WidgetToolsTable.AddTitle({
				frame = editBox,
				title = {
					text = t.label,
					template = "GameFontNormal",
					offset = { x = -1, y = 18 }
				}
			})
		end
		--Tooltip
		editBox:HookScript("OnEnter", function() WidgetToolsTable.AddTooltip(customTooltip, editBox, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra, nil, nil) end)
		editBox:HookScript("OnLeave", function() customTooltip:Hide() end)
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
	--- - **text**? string *optional* — Text to be shown inside edit box, loaded whenever the text box is shown
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
	WidgetToolsTable.CreateEditScrollBox = function(t)
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
			WidgetToolsTable.AddTitle({
				frame = scrollFrame,
				title = {
					text = t.label,
					template = "GameFontNormal",
					offset = { x = -1, y = 20 }
				}
			})
		end
		--Tooltip
		scrollFrame.EditBox:HookScript("OnEnter", function() WidgetToolsTable.AddTooltip(customTooltip, scrollFrame, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra, nil, nil) end)
		scrollFrame.EditBox:HookScript("OnLeave", function() customTooltip:Hide() end)
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
	WidgetToolsTable.CreateSlider = function(t)
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
	WidgetToolsTable.CreateDropdown = function(t)
		local dropdown = CreateFrame("Frame", t.parent:GetName() .. t.label:gsub("%s+", "") .. "Dropdown", t.parent, "UIDropDownMenuTemplate")
		--Position & dimensions
		PositionFrame(dropdown, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) - 16)
		if t.width ~= nil then UIDropDownMenu_SetWidth(dropdown, t.width) end
		--Tooltip
		dropdown:HookScript("OnEnter", function() WidgetToolsTable.AddTooltip(customTooltip, dropdown, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra, nil, nil) end)
		dropdown:HookScript("OnLeave", function() customTooltip:Hide() end)
		--Title
		if t.title ~= false then
			WidgetToolsTable.AddTitle({
				frame = dropdown,
				title = {
					text = t.label,
					template = "GameFontNormal",
					offset = { x = 22, y = 16 }
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

	---Convert RGB(A) color values (Range: 0 - 1) to HEX color code
	---@param r number Red (Range: 0 - 1)
	---@param g number Green (Range: 0 - 1)
	---@param b number Blue (Range: 0 - 1)
	---@param a? number Alpha (Range: 0 - 1)
	---@return string hex Color code in HEX format (Examples: RGB - "#2266BB", RGBA - "#2266BBAA")
	WidgetToolsTable.ColorToHex = function(r, g, b, a)
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
	WidgetToolsTable.HexToColor = function(hex)
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
	--- 	- @*param* **r** number ― Red (Range: 0 - 1)
	--- 	- @*param* **g** number ― Green (Range: 0 - 1)
	--- 	- @*param* **b** number ― Blue (Range: 0 - 1)
	--- 	- @*param* **a**? number *optional* ― Opacity (Range: 0 - 1, Default: 1)
	--- - **onCancel** function
	--- 	- @*param* **r** number ― Red (Range: 0 - 1)
	--- 	- @*param* **g** number ― Green (Range: 0 - 1)
	--- 	- @*param* **b** number ― Blue (Range: 0 - 1)
	--- 	- @*param* **a**? number *optional* ― Opacity (Range: 0 - 1, Default: 1)
	local function OpenColorPicker()
		--Color picker button background update function
		local function ColorUpdate()
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = OpacitySliderFrame:GetValue() or 1
			colorPickerData.activeColorPicker:SetBackdropColor(r, g, b, a)
			_G[colorPickerData.activeColorPicker:GetName():gsub("Button", "EditBox")]:SetText(WidgetToolsTable.ColorToHex(r, g, b, a))
			colorPickerData.onColorUpdate(r, g, b, a)
		end
		--RGB
		ColorPickerFrame:SetColorRGB(colorPickerData.startColors.r, colorPickerData.startColors.g, colorPickerData.startColors.b)
		ColorPickerFrame.func = function() ColorUpdate() end
		--Alpha
		ColorPickerFrame.hasOpacity = colorPickerData.startColors.a ~= nil
		if ColorPickerFrame.hasOpacity then
			ColorPickerFrame.opacity = colorPickerData.startColors.a
			ColorPickerFrame.opacityFunc = function() ColorUpdate() end
		end
		--Reset
		ColorPickerFrame.cancelFunc = function() --Using colorPickerData.startColors[k] instead of ColorPickerFrame.previousValues[i]
			colorPickerData.activeColorPicker:SetBackdropColor(
				colorPickerData.startColors.r,
				colorPickerData.startColors.g,
				colorPickerData.startColors.b,
				colorPickerData.startColors.a or 1
			)
			_G[colorPickerData.activeColorPicker:GetName():gsub("Button", "EditBox")]:SetText(WidgetToolsTable.ColorToHex(
				colorPickerData.startColors.r,
				colorPickerData.startColors.g,
				colorPickerData.startColors.b,
				colorPickerData.startColors.a or 1
			))
			colorPickerData.onCancel(colorPickerData.startColors.r, colorPickerData.startColors.g, colorPickerData.startColors.b, colorPickerData.startColors.a)
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
	--- 	- @*return* **a**? number *optional* ― Opacity (Range: 0 - 1)
	--- - **onColorUpdate** function — The function to be called when the color is changed
	--- 	- @*param* **r** number ― Red (Range: 0 - 1)
	--- 	- @*param* **g** number ― Green (Range: 0 - 1)
	--- 	- @*param* **b** number ― Blue (Range: 0 - 1)
	--- 	- @*param* **a**? number *optional* ― Opacity (Range: 0 - 1, Default: 1)
	--- - **onCancel** function — The function to be called when the color change is cancelled
	--- 	- @*param* **r** number ― Red (Range: 0 - 1)
	--- 	- @*param* **g** number ― Green (Range: 0 - 1)
	--- 	- @*param* **b** number ― Blue (Range: 0 - 1)
	--- 	- @*param* **a**? number *optional* ― Opacity (Range: 0 - 1, Default: 1)
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
				onCancel = t.onCancel
			}
			OpenColorPicker()
		end)
		pickerButton:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		--Tooltip
		pickerButton:HookScript("OnEnter", function()
			local tooltip = strings.color.picker.tooltip
			if a ~= nil then
				tooltip = strings.color.picker.tooltip:gsub("#ALPHA", strings.color.picker.alpha)
			else
				tooltip = strings.color.picker.tooltip:gsub("#ALPHA", "")
			end
			WidgetToolsTable.AddTooltip(customTooltip, pickerButton, "ANCHOR_TOPLEFT", strings.color.picker.label, tooltip, nil, 20, nil)
		end)
		pickerButton:HookScript("OnLeave", function() customTooltip:Hide() end)
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
	--- - **onColorUpdate** function — The function to be called when the color is changed
	--- 	- @*param* **r** number ― Red (Range: 0 - 1)
	--- 	- @*param* **g** number ― Green (Range: 0 - 1)
	--- 	- @*param* **b** number ― Blue (Range: 0 - 1)
	--- 	- @*param* **a**? number *optional* ― Opacity (Range: 0 - 1, Default: 1)
	--- - **onCancel** function — The function to be called when the color change is cancelled
	--- 	- @*param* **r** number ― Red (Range: 0 - 1)
	--- 	- @*param* **g** number ― Green (Range: 0 - 1)
	--- 	- @*param* **b** number ― Blue (Range: 0 - 1)
	--- 	- @*param* **a**? number *optional* ― Opacity (Range: 0 - 1, Default: 1)
	---@return Frame pickerFrame
	---@return Button pickerButton
	---@return EditBox pickerBox
	WidgetToolsTable.CreateColorPicker = function(t)
		local pickerFrame = CreateFrame("Frame", t.parent:GetName() .. t.label:gsub("%s+", "") .. "ColorPicker", t.parent)
		--Position & dimensions
		local frameWidth = (t.size or {}).width or 120
		PositionFrame(pickerFrame, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y)
		pickerFrame:SetSize(frameWidth, (t.size or {}).height or 36)
		--Title
		WidgetToolsTable.AddTitle({
			frame = pickerFrame,
			title = {
				text = t.label,
				template = "GameFontNormal",
				offset = { x = 4, y = 0 }
			}
		})
		--Add color picker button to open the Blizzard Color Picker
		local pickerButton = AddColorPickerButton({
			picker = pickerFrame,
			setColors = t.setColors,
			onColorUpdate = t.onColorUpdate,
			onCancel = t.onCancel
		})
		--Add edit box to change the color via HEX code
		local red, green, blue, alpha = t.setColors()
		local hexBox = WidgetToolsTable.CreateEditBox({
			parent = pickerFrame,
			position = {
				anchor = "TOPLEFT",
				offset = { x = 44, y = 0 }
			},
			size = { width = frameWidth - 44 },
			maxLetters = 7 + (alpha ~= nil and 2 or 0),
			fontObject = "GameFontWhiteSmall",
			label = strings.color.hex.label,
			title = false,
			tooltip = strings.color.hex.tooltip .. "\n\n" .. strings.misc.example .. ": #2266BB" .. (alpha ~= nil and "AA" or ""),
			onChar = function(self) self:SetText(self:GetText():gsub("^(#?)([%x]*).*", "%1%2")) end,
			onEnterPressed = function(self)
				local r, g, b, a = WidgetToolsTable.HexToColor(self:GetText())
				pickerButton:SetBackdropColor(r, g, b, a or 1)
				t.onColorUpdate(r, g, b, a or 1)
				self:SetText(self:GetText():upper())
			end,
			onEscapePressed = function(self) self:SetText(WidgetToolsTable.ColorToHex(pickerButton:GetBackdropColor())) end
		})
		return pickerFrame, pickerButton, hexBox
	end

	--[[ Interface Options Category Panel ]]

	---Create an new Interface Options Panel frame
	--- - Note: The new panel will need to be added to the Interface options via WidgetToolsTable.AddOptionsPanel()
	---@param t table Parameters are to be provided in this table
	--- - **title** string — Title text to be shown as the title of the options panel
	--- - **description** string — Title text to be shown as the description below the title of the options panel
	--- - **icon**? string *optional* — Path to the texture file to be added as an icon to the top right corner of the panel
	---@return Frame optionsPanel
	WidgetToolsTable.CreateOptionsPanel = function(t)
		local optionsPanel = CreateFrame("Frame", t.title:gsub("%s+", "") .. "Options", InterfaceOptionsFramePanelContainer)
		optionsPanel:SetSize(InterfaceOptionsFramePanelContainer:GetSize())
		optionsPanel:SetPoint("TOPLEFT") --Preload the frame
		optionsPanel:Hide()
		--Title & description
		WidgetToolsTable.AddTitle({
			frame = optionsPanel,
			title = {
				text = t.title,
				template = "GameFontNormalLarge",
				offset = { x = 16, y= -16 },
				width = optionsPanel:GetWidth() - (t.icon ~= nil and 62 or 0),
				justify = "LEFT"
			},
			description = {
				text = t.description,
				template = "GameFontHighlightSmall",
				offset = { x = 0, y= -8 },
				width = optionsPanel:GetWidth() - (t.icon ~= nil and 62 or 0),
				justify = "LEFT"
			}
		})
		--Icon texture
		if t.icon ~= nil then
			WidgetToolsTable.CreateTexture({
				parent = optionsPanel,
				name = "Icon",
				path = t.icon,
				position = {
					anchor = "TOPRIGHT",
					offset = { x = -16, y = -16 }
				},
				size = { width = 36, height = 36 }
			})
		end
		return optionsPanel
	end

	---Set up and add an existing options panel to the Interface options
	---@param optionsPanel Frame
	---@param t table Parameters are to be provided in this table
	--- - **parent**? string *optional* — The name of the options category to set as the parent category (Default: set as a main category)
	--- - **name** string — Name to be shown as the name of the Interface options panel category
	--- - **okay**? function *optional* — The function to be called then the "Okay" button is clicked
	--- - **cancel**? function *optional* — The function to be called then the "Cancel" button is clicked
	--- - **default**? function *optional* — The function to be called then the "Default" button is clicked (refresh will be called automatically afterwards)
	--- - **refresh**? function *optional* — The function to be called then the interface panel is loaded
	---@return Frame optionsPanel
	WidgetToolsTable.AddOptionsPanel = function(optionsPanel, t)
		--Set up the options panel
		optionsPanel.name = t.name
		--Set event handlers
		if t.okay ~= nil then optionsPanel.okay = t.okay end
		if t.cancel ~= nil then optionsPanel.cancel = t.cancel end
		if t.default ~= nil then optionsPanel.default = t.default end
		if t.refresh ~= nil then optionsPanel.refresh = t.refresh end
		--Set as a subcategory of a parent panel
		if t.parent ~= nil then optionsPanel.parent = t.parent end
		--Add the panel to the Interface options
		InterfaceOptions_AddCategory(optionsPanel)
		return optionsPanel
	end
end