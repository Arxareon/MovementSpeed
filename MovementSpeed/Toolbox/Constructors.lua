--[[ REFERENCES ]]

--[ Toolbox ]

---@class widgetToolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "X-WidgetTools-ToolboxVersion")]

if not wt then return end

--[ Shortcuts ]

---@type widgetToolsResources
local rs = WidgetTools.resources

---@type widgetToolsUtilities
local us = WidgetTools.utilities

---@type widgetToolsDebugging
local ds = WidgetTools.debugging

local cr = WrapTextInColor
local crc = WrapTextInColorCode


--[[ TOOLTIP ]]

---Create and set up a new custom GameTooltip frame
---***
---@param name string Unique string piece to place in the name of the the tooltip to distinguish it from other tooltips (use the addon namespace string as an example)
---@return GameTooltip tooltip
function wt.CreateGameTooltip(name)
	local tooltip = CreateFrame("GameTooltip", name .. "GameTooltip", nil, "GameTooltipTemplate")

	--| Visibility

	tooltip:SetFrameStrata("TOOLTIP")
	tooltip:SetScale(UIParent:GetScale())

	--| Title

	_G[tooltip:GetName() .. "TextLeft" .. 1]:SetFontObject("GameFontNormalMed1")
	_G[tooltip:GetName() .. "TextRight" .. 1]:SetFontObject("GameFontNormalMed1")

	return tooltip
end


--[[ POPUP ]]

--| Input Box

local customPopupInputBoxFrame

---Show a movable input window with a textbox, accept and cancel buttons
---***
---@param t? popupInputBoxData Optional parameters
function wt.CreatePopupInputBox(t)
	t = type(t) == "table" and t or {}
	t.position = type(t.position) == "table" and t.position or {
		anchor = "TOP",
		offset = { y = -320 }
	}
	t.text = type(t.text) == "string" and t.text or ""
	t.title = type(t.title) == "string" and t.title or nil

	--[ Frame Setup ]

	customPopupInputBoxFrame = customPopupInputBoxFrame or { accept = t.accept, cancel = t.cancel }

	if customPopupInputBoxFrame.panel then
		wt.SetPosition(customPopupInputBoxFrame.panel, t.position)

		--Update textbox
		customPopupInputBoxFrame.textbox.setText(t.text)
		if t.title then
			if customPopupInputBoxFrame.textbox.label then customPopupInputBoxFrame.textbox.label:SetText(t.title) else
				customPopupInputBoxFrame.textbox.label = wt.CreateTitle(customPopupInputBoxFrame.textbox.frame, {
					offset = { x = -1, },
					text = t.title,
				})
			end
		end

		--Update arrangement
		if (t.title ~= nil) ~= (customPopupInputBoxFrame.textbox.label ~= nil) then wt.ArrangeContent(customPopupInputBoxFrame.panel) end

		customPopupInputBoxFrame.panel:Show()

		return
	end

	--| Utilities

	local function accept()
		if type(customPopupInputBoxFrame.accept) == "function" then customPopupInputBoxFrame.accept(customPopupInputBoxFrame.textbox.getText()) end

		customPopupInputBoxFrame.panel:Hide()
	end

	local function cancel()
		if type(customPopupInputBoxFrame.cancel) == "function" then customPopupInputBoxFrame.cancel() end

		customPopupInputBoxFrame.panel:Hide()
	end

	--| Main panel

	customPopupInputBoxFrame.panel = wt.CreatePanel({
		parent = UIParent,
		name = "WidgetToolsPopupInputBox",
		label = false,
		position = t.position,
		keepInBounds = true,
		size = { w = 240, h = 90 },
		visible = false,
		frameStrata = "DIALOG",
		keepOnTop = true,
		background = { color = { a = 0.9 }, },
		arrangement = {},
		initialize = function(panel)

			--[ Textbox ]

			---@type customEditbox|textbox
			customPopupInputBoxFrame.textbox = wt.CreateEditbox({
				parent = panel,
				name = "TextInputBox",
				title = t.title,
				label = t.title ~= nil,
				tooltip = { title = wt.strings.popupInput.title, lines = { { text = wt.strings.popupInput.tooltip }, } },
				size = { w = panel:GetWidth() - 24, },
				focusOnShow = true,
				events = {
					OnEnterPressed = accept,
					OnEscapePressed = cancel,
				},
				arrange = {},
				value = t.text,
				showDefault = false,
				utilityMenu = false,
			})

			--[ Buttons ]

			wt.CreateButton({
				parent = panel,
				name = "AcceptButton",
				title = ACCEPT ,
				arrange = {},
				size = { w = 110, },
				action = accept,
			})

			wt.CreateButton({
				parent = panel,
				name = "CancelButton",
				title = CANCEL,
				position = {
					anchor = "BOTTOMRIGHT",
					offset = { x = -12, y = 12 }
				},
				size = { w = 90, },
				action = cancel,
			})
		end,
	})

	--| Position & dimensions

	wt.SetMovability(customPopupInputBoxFrame.panel, true)

	--| Visibility

	customPopupInputBoxFrame.panel:Show()
end

--| Reload Notice

local reloadFrame

---Show a movable reload notice window on screen with a reload now and cancel button
---***
---@param t? reloadFrameData Optional parameters
---***
---@return Frame reload Reference to the reload notice panel frame
function wt.CreateReloadNotice(t)
	t = type(t) == "table" and t or {}

	if reloadFrame then
		wt.SetPosition(reloadFrame, type(t.position) == "table" and t.position or {
			anchor = "TOPRIGHT",
			offset = { x = -300, y = -100 }
		})
		reloadFrame:Show()

		return reloadFrame
	end

	--[ Frame Setup ]

	reloadFrame = wt.CreatePanel({
		parent = UIParent,
		name = "WidgetToolsReloadNotice",
		title = t.title or wt.strings.reload.title,
		position = t.position or {
			anchor = "TOPRIGHT",
			offset = { x = -300, y = -100 }
		},
		keepInBounds = true,
		size = { w = 240, h = 102 },
		frameStrata = "DIALOG",
		keepOnTop = true,
		background = { color = { a = 0.9 }, },
		lite = false,
	})

	--| Position & dimensions

	wt.SetMovability(reloadFrame, true)

	--| Title & description

	reloadFrame.title:SetPoint("TOPLEFT", 14, -14)

	wt.CreateText({
		parent = reloadFrame,
		name = "Description",
		position = {
			anchor = "TOPLEFT",
			offset = { x = 14, y = -38 }
		},
		width = 214,
		justify = { h = "LEFT", },
		text = t.message or wt.strings.reload.description,
	})

	--| Buttons

	wt.CreateButton({
		parent = reloadFrame,
		name = "ReloadButton",
		title = wt.strings.reload.accept.label,
		tooltip = { lines = { { text = wt.strings.reload.accept.tooltip, }, } },
		position = {
			anchor = "BOTTOMLEFT",
			offset = { x = 12, y = 12 }
		},
		size = { w = 120, },
		action = function() ReloadUI() end,
		lite = false,
	})

	wt.CreateButton({
		parent = reloadFrame,
		name = "CancelButton",
		title = wt.strings.reload.cancel.label,
		tooltip = { lines = { { text = wt.strings.reload.cancel.tooltip, }, } },
		position = {
			anchor = "BOTTOMRIGHT",
			offset = { x = -12, y = 12 }
		},
		action = function() reloadFrame:Hide() end,
		lite = false,
	})

	return reloadFrame
end


--[[ TEXT ]]

--[ Font ]

---Create a new [Font](https://warcraft.wiki.gg/wiki/UIOBJECT_Font) object to be used when setting the look of a [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) using a [FontInstance](https://warcraft.wiki.gg/wiki/UIOBJECT_FontInstance)
---***
---@param name string A unique identifier name to set for the hew font object to be accessed by and referred to later<ul><li>***Note:*** If a font object with that name already exists, it will *not* be overwritten and its reference key will be returned.</li><li>***Example:*** Access the reference to the font object created via the globals table: `local customFont = _G["CustomFontName"]`.</li></ul>
---@param t? fontCreationData Optional parameters
---***
---@return string name, Font font ***Default*** *(on invalid input)****:*** "GameFontNormal", **GameFontNormal**
function wt.CreateFont(name, t)
	t = type(t) == "table" and t or {}

	if type(name) ~= "string" or name == "" then return "GameFontNormal", GameFontNormal end
	if _G[name] then return name, _G[name] end

	--[ Font Setup ]

	local font = CreateFont(name)
	if type(t.template) == "string" then font:CopyFontObject(t.template) end

	--Set display font
	if t.font then font:SetFont(t.font.path, t.font.size, t.font.style) end

	--Set appearance
	if type(t.color) == "table" then font:SetTextColor(wt.UnpackColor(us.Fill(t.color, { r = 1, g = 1, b = 1 }))) end
	if type(t.spacing) == "number" then font:SetSpacing(t.spacing) end
	if type(t.shadow) == "table" then
		font:SetShadowOffset(t.shadow.offset.x or 1, t.shadow.offset.y)
		font:SetShadowColor(wt.UnpackColor(us.Fill(t.shadow.color, { r = 0, g = 0, b = 0 })))
	end

	--Set text positioning
	if  type(t.justify) == "table" then
		if t.justify.h then font:SetJustifyH(t.justify.h) end
		if t.justify.v then font:SetJustifyV(t.justify.v) end
	end
	if t.wrap == true then font:SetIndentedWordWrap(true) elseif t.wrap == false then font:SetIndentedWordWrap(false) end

	return name, font
end

--| Create custom fonts for Classic

if wt.classic then
	wt.CreateFont("GameFontDisableMed2", {
		template = "GameFontHighlightMedium",
		color = wt.PackColor(GameFontDisable:GetTextColor()),
	})

	wt.CreateFont("NumberFont_Shadow_Large", { font = { path = "Fonts/ARIALN.TTF", size = 20, style = "OUTLINE" }, })
end

--[ Textline ]

---Create a text object ([FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString)) with the specified parameters
---***
---@param t? textCreationData Optional parameters
---@return FontString text
function wt.CreateText(t)
	t = type(t) == "table" and t or {}
	t.parent = us.IsFrame(t.parent) and t.parent or UIParent

	local text = t.parent:CreateFontString((t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Text"), t.layer, t.font and t.font or "GameFontNormal")

	--| Position & dimensions

	wt.SetPosition(text, t.position)

	if type(t.width) == "number" then text:SetWidth(t.width) end
	if type(t.height) == "number" then text:SetHeight(t.height) end

	--| Font & text

	if t.color then text:SetTextColor(wt.UnpackColor(t.color)) end
	if t.justify then
		if t.justify.h then text:SetJustifyH(t.justify.h) end
		if t.justify.v then text:SetJustifyV(t.justify.v) end
	end
	if t.wrap == false then text:SetWordWrap(false) end
	if t.text then text:SetText(t.text) end

	return text
end

---Add a title to a frame
---***
---@param frame AnyFrameObject Reference to the frame to add the title textline to
---@param t? titleCreationData Optional parameters
---***
---@return FontString? # ***Default:*** nil
function wt.CreateTitle(frame, t)
	t = type(t) == "table" and t or {}

	if not us.IsFrame(frame) then return end

	return wt.CreateText({
		parent = frame,
		name = "Title",
		position = {
			anchor = t.anchor,
			offset = t.offset,
		},
		width = t.width,
		layer = "ARTWORK",
		text = t.text,
		font = t.font or "GameFontHighlight",
		color = t.color,
		justify = { h = t.justify or "LEFT", },
	})
end

---Add a description to a titled frame
---***
---@param title FontString Reference to the already existing title textline to place the description next to
---@param t? descriptionCreationData Table of parameters to create a description
---***
---@return FontString? # ***Default:*** nil
function wt.CreateDescription(title, t)
	t = type(t) == "table" and t or {}

	if type(title) ~= "table" or type(title.GetFont) ~= "function" then return end

	local parent = title:GetParent()

	if not us.IsFrame(parent) then return end

	t.justify = type(t.justify) == "string" and t.justify or "LEFT"
	local anchor = t.justify ~= "RIGHT" and "LEFT" or "RIGHT"
	local relativePoint = t.justify ~= "RIGHT" and "RIGHT" or "LEFT"
	t.offset = type(t.offset) == "table" and t.offset or {}
	t.offset.x = type(t.offset.x) == "number" and t.offset.x or 0
	t.offset.y = type(t.offset.y) == "number" and t.offset.y or 1
	t.spacer = (type(t.spacer) == "number" and t.spacer or 5) * (t.justify ~= "LEFT" and -1 or 1)
	t.color = type(t.color) == "table" and t.color or us.Fill({ a = 0.55 }, HIGHLIGHT_FONT_COLOR)

	local separator = wt.CreateText({
		parent = parent,
		name = "Separator",
		position = {
			anchor = anchor,
			relativeTo = title,
			relativePoint = relativePoint,
			offset = { x = t.spacer, }
		},
		layer = "ARTWORK",
		text = "•",
		font = title:GetFontObject():GetName(),
		color = t.color,
	})

	return wt.CreateText({
		parent = parent,
		name = "Description",
		position = {
			anchor = anchor,
			relativeTo = separator,
			relativePoint = relativePoint,
			offset = { x = t.offset.x + t.spacer + 4, y = t.offset.y }
		},
		width = t.width or parent:GetWidth() - title:GetWidth() - separator:GetWidth() - t.spacer * 2 + (t.widthOffset or 0),
		layer = "ARTWORK",
		text = t.text,
		font = t.font or "GameFontHighlightSmall2",
		color = t.color,
		justify = { h = t.justify, v = "MIDDLE", },
	})
end


--[[ TEXTURE ]]

---Create a [Texture](https://warcraft.wiki.gg/wiki/UIOBJECT_Texture) image [TextureBase](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) object
---***
---@param frame AnyFrameObject Reference to the frame to set as the parent of the new texture
---@param t textureCreationData Optional parameters
---@param updates? table<AnyScriptType, textureUpdateRule> Table of key, value pairs containing the list of events to link texture changes to, and what parameters to change
---***
---@return Texture? texture ***Default:*** nil
function wt.CreateTexture(frame, t, updates)
	if not us.IsFrame(frame) then return end

	t = type(t) == "table" and t or {}

	local texture = frame:CreateTexture((frame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Texture"))

	--[ Set Texture Utility ]

	---@param data textureUpdateData|textureCreationData
	local function setTexture(data)

		--| Position & dimensions

		wt.SetPosition(texture, data.position)

		texture:SetSize(data.size.w or t.size.w or frame:GetWidth(), data.size.h or t.size.h or frame:GetHeight())

		--| Asset & color

		if t.atlas then texture:SetAtlas(t.atlas, true) else
			texture:SetTexture(data.path or t.path, data.wrap.h or t.wrap.h, data.wrap.v or t.wrap.v, data.filterMode or t.filterMode)
		end
		if data.layer then if data.level then texture:SetDrawLayer(data.layer, data.level) else texture:SetDrawLayer(data.layer) end end
		if data.flip then texture:SetTexCoord(t.flip.h and 1 or 0, t.flip.h and 0 or 1, t.flip.v and 1 or 0, t.flip.v and 0 or 1) end
		if data.color then texture:SetVertexColor(wt.UnpackColor(data.color)) end
		if data.tile then
			texture:SetHorizTile(data.tile.h ~= nil and data.tile.h)
			texture:SetVertTile(data.tile.v ~= nil and data.tile.v)
		end
		if data.edges then
			texture:SetTexCoord(data.edges.l or 0, data.edges.r or 1, data.edges.t or 0, data.edges.b or 1)
		elseif data.vertices then
			data.vertices.topLeft = data.vertices.topLeft or {}
			data.vertices.topRight = data.vertices.topRight or {}
			data.vertices.bottomLeft = data.vertices.bottomLeft or {}
			data.vertices.bottomRight = data.vertices.bottomRight or {}

			texture:SetTexCoord(
				data.vertices.topLeft.x or 0,
				data.vertices.topLeft.y or 0,
				data.vertices.topRight.x or 1,
				data.vertices.topRight.y or 0,
				data.vertices.bottomLeft.x or 0,
				data.vertices.bottomLeft.y or 1,
				data.vertices.bottomRight.x or 1,
				data.vertices.bottomRight.y or 1
			)
		end
	end

	--| Set the base texture

	t.path = type(t.path) == "string" and t.path or "Interface/ChatFrame/ChatFrameBackground"
	t.size = type(t.size) == "table" and t.size or {}
	t.wrap = type(t.wrap) == "table" and t.wrap or {}
	t.tile = type(t.tile) == "table" and t.tile or {}

	setTexture(t)

	--[ Events ]

	--Register script event handlers
	if type(t.events) == "table" then for key, value in pairs(t.events) do
		if key == "attribute" then texture:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else texture:HookScript(key, value) end
	end end

	--[ Texture Updates ]

	if updates then for key, value in pairs(updates) do
		value.frame = value.frame or frame

		--Set the script
		if value.frame:HasScript(key) then value.frame:HookScript(key, function(self, ...)
			--Unconditional: Restore the base backdrop on trigger
			if not value.rule then
				setTexture(t)

				return
			end

			--Conditional: Evaluate the rule & fill texture update date with the base values
			local data = us.Fill(value.rule(self, ...), t)

			--Update the texture
			setTexture(data)
		end) end
	end end

	return texture
end

---Create a [Line](https://warcraft.wiki.gg/wiki/UIOBJECT_Line) [TextureBase](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) object
---***
---@param frame AnyFrameObject Reference to the frame to set as the parent of the new line
---@param t lineCreationData Optional parameters
---***
---@return Line? line ***Default:*** nil
function wt.CreateLine(frame, t)
	t = type(t) == "table" and t or {}

	if not us.IsFrame(frame) then return end

	t.startPosition.offset = t.startPosition.offset or {}
	t.endPosition.offset = t.endPosition.offset or {}

	local line = frame:CreateLine((frame:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Line"), t.layer, nil, t.level)

	--Positions
	line:ClearAllPoints()
	line:SetStartPoint(t.startPosition.relativePoint, t.startPosition.relativeTo, t.startPosition.offset.x, t.startPosition.offset.y)
	line:SetEndPoint(t.endPosition.relativePoint, t.endPosition.relativeTo, t.endPosition.offset.x, t.endPosition.offset.y)

	--Color & thickness
	if t.thickness then line:SetThickness(t.thickness) end
	if t.color then line:SetColorTexture(wt.UnpackColor(t.color)) end

	return line
end


--[[ CONTAINER FRAME ]]

---Set the parameters of a frame
---@param frame Frame
---@param t frameCreationData
local function setUpFrame(frame, t)
	t.size = t.size or {}
	t.size.w = t.size.w or 0
	t.size.h = t.size.h or 0

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(frame, t.position) end
	wt.SetArrangementDirective(frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	if t.keepInBounds then frame:SetClampedToScreen(true) end

	if t.size then frame:SetSize(t.size.w, t.size.h) end

	--| Visibility

	wt.SetVisibility(frame, t.visible ~= false)

	if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else frame:HookScript(key, value) end
	end end

	--| Global events

	if type(t.onEvent) == "table" then for event, handler in pairs(t.onEvent) do if type(handler) == "function" then us.SetListener(frame, event, handler) end end end

	--[ Initialization ]

	--Add content, performs tasks
	if type(t.initialize) == "function" then
		t.initialize(frame, t.size.w, t.size.h, t.name)

		--Arrange content
		if t.arrangement and frame then wt.ArrangeContent(frame, t.arrangement) end
	end
end

--[ Base Frame ]

---Create & set up a new base frame
---***
---@param t? frameCreationData Optional parameters
---@return Frame frame
function wt.CreateFrame(t)
	t = type(t) == "table" and t or {}

	--[ Frame Setup ]

	local name = t.name and ((t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. t.name:gsub("%s+", "")) or nil
	local frame = CreateFrame("Frame", name, t.parent)

	--| Shared setup

	setUpFrame(frame, t)

	return frame
end

---Create & set up a new customizable frame with BackdropTemplate
---***
---@param t? frameCreationData Optional parameters
---@return Frame|BackdropTemplate frame
function wt.CreateCustomFrame(t)
	t = type(t) == "table" and t or {}

	--[ Frame Setup ]

	local name = t.name and ((t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. t.name:gsub("%s+", "")) or nil
	local frame = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

	--| Shared setup

	setUpFrame(frame, t)

	return frame
end

--[ Scrollframe ]

---Create an empty vertically scrollable frame
---***
---@param t? scrollframeCreationData Optional parameters
---@return Frame scrollChild
---@return ScrollFrame scrollframe
function wt.CreateScrollframe(t)
	t = type(t) == "table" and t or {}
	t.scrollSize = type(t.scrollSize) == "table" and t.scrollSize or {}

	--[ Frame Setup ]

	local parentName = t.parent and t.parent:GetName() or ""
	local name = t.name and t.name:gsub("%s+", "")

	local scrollframe = CreateFrame("ScrollFrame", parentName .. (name or "") .. "ScrollParent", t.parent, ScrollControllerMixin and "ScrollFrameTemplate")

	--| Position & dimensions

	t.size = t.size or t.parent and { w = t.parent:GetWidth(), h = t.parent:GetHeight() } or { w = 0, h = 0 }

	wt.SetPosition(scrollframe, t.position)

	scrollframe:SetSize(t.size.w, t.size.h)

	--Scrollbar
	wt.SetPosition(scrollframe.ScrollBar, {
		anchor = "RIGHT",
		relativeTo = scrollframe,
		relativePoint = "RIGHT",
		offset = { x = -4, y = 1 }
	})
	scrollframe.ScrollBar:SetHeight(t.size.h - 10)

	--[ Scroll Child ]

	--Create scrollable child frame
	local scrollChild = wt.CreateFrame({
		parent = scrollframe,
		name = parentName .. (name or "Scroller"),
		append = false,
		size = { w = t.scrollSize.w or scrollframe:GetWidth() - (wt.classic and 32 or 16), h = t.scrollSize.h },
		initialize = t.initialize,
		arrangement = t.arrangement
	})

	--Register for scroll
	scrollframe:SetScrollChild(scrollChild)

	--Update scroll speed
	t.scrollSpeed = (t.scrollSpeed or 0.25)

	--Override the built-in update function
	scrollframe.ScrollBar.SetPanExtentPercentage = function() --WATCH: Change when Blizzard provides a better way to overriding the built-in update function
		local height = scrollframe:GetHeight()
		scrollframe.ScrollBar.panExtentPercentage = height * t.scrollSpeed / math.abs(scrollChild:GetHeight() - height)
	end

	return scrollChild, scrollframe
end

--[ Panel ]

---Create a new simple panel frame
---***
---@param t? panelCreationData Optional parameters
---***
---@return panel|Frame panel Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame) overloaded with custom fields or none if **WidgetToolsDB.lite** is true**
function wt.CreatePanel(t)
	t = type(t) == "table" and t or {}

	if WidgetToolsDB.lite and t.lite ~= false then return wt.CreateFrame(t) end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Panel")

	---@class panel : Frame
	---@field title? FontString Reference to the title textline appearing above the panel
	---@field description? FontString Reference to the description textline appearing in the panel
	local panel = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

	--| Position & dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or t.parent and t.parent:GetWidth() - 20 or 0
	t.size.h = t.size.h or 0
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(panel, t.position) end
	wt.SetArrangementDirective(panel, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	if t.keepInBounds then panel:SetClampedToScreen(true) end

	panel:SetSize(t.size.w, t.size.h)

	--| Visibility

	wt.SetVisibility(panel, t.visible ~= false)

	if t.frameStrata then panel:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then panel:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then panel:SetToplevel(t.keepOnTop) end

	--| Title & description

	panel.title = t.label ~= false and wt.CreateTitle(panel, {
		offset = { x = 7, y = 27 },
		text = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Panel",
		font = "GameFontHighlightLarge",
	}) or nil

	if type(t.description) == "string" then panel.description = wt.CreateDescription(panel.title, {
		widthOffset = -22,
		text = t.description,
	}) end

	--| Backdrop

	wt.SetBackdrop(panel, {
		background = us.Fill(t.background, {
			texture = {
				size = 5,
				insets = { l = 4, r = 4, t = 4, b = 4 },
			},
			color = { r = 0.175, g = 0.175, b = 0.175, a = 0.65 }
		}),
		border = us.Fill(t.border, {
			texture = { width = 16, },
			color = { r = 0.75, g = 0.75, b = 0.75, a = 0.5 }
		})
	})

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then panel:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else panel:HookScript(key, value) end
	end end

	--[ Initialization ]

	--Add content, performs tasks
	if type(t.initialize) == "function" then
		t.initialize(panel, t.size.w, t.size.h, t.name or "Panel")

		--Arrange content
		if t.arrangement then wt.ArrangeContent(panel, t.arrangement) end
	end

	return panel
end


--[[ CONTEXT MENU ]]

---Create a Blizzard context menu
---***
---@param t? contextMenuCreationData Optional parameters
---***
---@return contextMenu menu Table containing a reference to the root description of the context menu
function wt.CreateContextMenu(t)
	t = type(t) == "table" and t or {}

	--[ Menu Setup ]

	---@class contextMenu
	---@field rootDescription RootMenuDescriptionProxy Container of menu elements (such as titles, widgets, dividers or other frames)
	local menu = {}

	--| Utilities

	---Open the context menu
	---***
	---@param trigger? integer Index of the trigger to activate to have the menu opened defined in **t.triggers** | ***Default:*** 1
	---@param action "click"|"hover"|nil The action that prompted the menu to be opened | ***Default:*** *no action:* `nil`
	function menu.open(trigger, action)
		trigger = type(trigger) == "number" and Clamp(trigger, 1, #t.triggers) or 1

		if type(t.triggers[trigger].condition) == "function" and not t.triggers[trigger].condition(action) then return end

		MenuUtil.CreateContextMenu(t.triggers[trigger].frame, function(_, rootDescription)
			menu.rootDescription = rootDescription

			--Adding items
			if type(t.initialize) == "function" then t.initialize(menu) end
		end)
	end

	--| Trigger events

	if type(t.triggers) ~= "table" then t.triggers = { { frame = UIParent, }, } else for i = 1, #t.triggers do
		if not us.IsFrame(t.triggers[i].frame) then t.triggers[i].frame = UIParent end

		if t.triggers[i].rightClick ~= false or t.triggers[i].leftClick then t.triggers[i].frame:HookScript("OnMouseUp", function(_, button, isInside)
			if not isInside or (button == "RightButton" and t.triggers[i].rightClick == false) or (button == "LeftButton" and not t.triggers[i].leftClick) then return end

			menu.open(i, "click")
		end) end

		if t.triggers[i].hover then t.triggers[i].frame:HookScript("OnEnter", function() menu.open(i, "hover") end) end
	end end

	return menu
end

---Create a Blizzard context menu attached to a custom button frame to open it
---***
---@param t? popupMenuCreationData Optional parameters
---***
---@return Frame menu Table containing a reference to the root description of the context menu
---@return contextMenu menu Table containing a reference to the root description of the context menu
function wt.CreatePopupMenu(t)
	t = type(t) == "table" and t or {}
	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 26

	local buttonFrame = wt.CreateCustomFrame({
		parent = t.parent,
		name = t.name or "PopupMenu",
		position = t.position,
		arrange = t.arrange,
		size = t.size,
		events = t.events,
		onEvent = t.onEvent,
		initialize = function(frame)
			local label = wt.CreateText({
				parent = frame,
				name = "Label",
				text = t.title,
				position = { anchor = "LEFT", offset = { x = 12, }, },
				justify = { h = "LEFT", },
				width = t.size.w - 48,
				font = "GameFontNormal",
			})

			local arrow = wt.CreateText({
				parent = frame,
				name = "Arrow",
				text = "►",
				position = { anchor = "RIGHT", offset = { x = -12, }, },
				justify = { h = "RIGHT", },
				width = 16,
				font = "ChatFontNormal",
				color = NORMAL_FONT_COLOR,
			})

			if type(t.tooltip) == "table" then wt.AddTooltip(frame, {
				title = t.tooltip.title or t.title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			}) end

			wt.SetBackdrop(frame, {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 14, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			{ { rules = {
				OnEnter = function()
					local r, g, b = HIGHLIGHT_FONT_COLOR:GetRGB()

					label:SetTextColor(r, g, b)
					arrow:SetTextColor(r, g, b)

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function()
					local r, g, b = NORMAL_FONT_COLOR:GetRGB()

					label:SetTextColor(r, g, b)
					arrow:SetTextColor(r, g, b)

					return {}, true
				end,
				OnMouseDown = function() return IsMouseButtonDown("LeftButton") and {
					background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
					border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
				} or {} end,
			}, }, })
		end
	})

	local menu = wt.CreateContextMenu({
		triggers = { {
			frame = buttonFrame,
			leftClick = true,
			rightClick = false,
		}, },
		initialize = t.initialize,
	})

	return buttonFrame, menu
end

---Create a submenu item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new submenu to
---@param t? contextSubmenuCreationData Optional parameters
---***
---@return contextSubmenu|nil menu Table containing a reference to the root description of the context menu
function wt.CreateSubmenu(menu, t)
	if type(menu) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	--[ Menu Setup ]

	---@class contextSubmenu
	---@field rootDescription ElementMenuDescriptionProxy Container of menu elements (such as titles, widgets, dividers or other frames)
	---@diagnostic disable-next-line: missing-parameter
	local submenu = { rootDescription = menu.rootDescription:CreateButton(t.title or "Submenu") }

	--Adding items
	if type(t.initialize) == "function" then t.initialize(submenu) end

	return submenu
end

---Create a textline item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? menuTextlineCreationData Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil textline Reference to the context textline UI object
function wt.CreateMenuTextline(menu, t)
	if type(menu) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	return t.queue ~= true and menu.rootDescription:CreateTitle(t.text or "Title") or menu.rootDescription:QueueTitle(t.text or "Title")
end

---Create a divider item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? queuedMenuItem Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil divider Reference to the context divider UI object
function wt.CreateMenuDivider(menu, t)
	if type(menu) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	return t.queue ~= true and menu.rootDescription:CreateDivider() or menu.rootDescription:QueueDivider()
end

---Create a spacer item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? queuedMenuItem Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil spacer Reference to the context spacer UI object
function wt.CreateMenuSpacer(menu, t)
	if type(menu) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	return t.queue ~= true and menu.rootDescription:CreateSpacer() or menu.rootDescription:QueueSpacer()
end

---Create a button item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? menuButtonCreationData Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil button Reference to the context button UI object
function wt.CreateMenuButton(menu, t)
	if type(menu) ~= "table" then return nil end

	t = type(t) == "table" and t or {}

	return menu.rootDescription:CreateButton(t.title or "Button", t.action)
end


--[[ SETTINGS PAGE ]]

---Create an new Settings Panel frame and add it to the Options
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param t? settingsPageCreationData Optional parameters
---***
---@return settingsPage|nil page Table containing references to the settings canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions
function wt.CreateSettingsPage(addon, t)
	if type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) then return nil end

	t = type(t) == "table" and t or {}
	t.name = t.name and t.name:gsub("%s+", "")
	if type(t.dataManagement) == "table" then
		t.dataManagement.category = t.dataManagement.category or addon
		t.dataManagement.keys = type((t.dataManagement.keys or {})[1]) == "string" and t.dataManagement.keys or { t.name or addon }
	end
	local width, height = 0, 0

	---@type string, actionButton, actionButton, FontString
	local resetWarning, resetButton, revertButton, saveNotice

	---@class settingsPage
	---@field canvas? canvasFrame|Frame The settings page main canvas frame
	---@field category? table The registered settings category page
	---@field content? Frame The content frame to house the settings widgets or other page content
	---@field header? Frame The header frame containing the page title, description and icon
	local page = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "SettingsPage"
	---<p></p>
	function page.getType() return "SettingsPage" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function page.isType(type) return type == "SettingsPage" end

	---Toggle the availability of the reset defaults and revert changes cancel buttons for this page
	---***
	---@param state boolean? ***Default:*** `true`
	function page.setStatic(state)
		state = state == false

		resetButton.setEnabled(state)
		revertButton.setEnabled(state)

		if state then saveNotice:Show() else saveNotice:Hide() end
	end

	---Returns the unique identifier key representing the reset defaults warning popup dialog in the global **StaticPopupDialogs** table, and used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
	---@return string
	function page.getResetPopupKey() return resetWarning end

	--| Utilities

	---Open the Settings window to this category page
	--- - ***Note:*** No category page will be opened if **WidgetToolsDB.lite** is true.
	function page.open()
		if WidgetToolsDB.lite or not page.category then
			print(cr(wt.Texture(rs.textures.logo, 9) .. " " .. rs.title, rs.colors.gold[1]) .. " " .. cr(rs.strings.chat.lite.reminder:gsub(
				"#HINT", cr(rs.strings.chat.lite.hint:gsub(
					"#COMMAND", cr("/" .. rs.chat.keyword .. " " .. rs.chat.commands.lite, { r = 1, g = 1, b = 1, })
				), rs.colors.grey[1])
			), rs.colors.gold[2]))

			return
		end

		Settings.OpenToCategory(page.category:GetID())
	end

	--| Batched settings data management

	---Force update all linked settings widgets in this category page
	---***
	---@param handleChanges? boolean If true, also call all registered change handlers | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	function page.load(handleChanges, user)
		--Update settings widgets
		if t.autoLoad ~= false and type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do
			wt.LoadSettingsData(t.dataManagement.category, t.dataManagement.keys[i], handleChanges)
			wt.SnapshotSettingsData(t.dataManagement.category, t.dataManagement.keys[i])
		end end

		--Call listener
		if type(t.onLoad) == "function" then t.onLoad(user == true) end
	end

	---Force save all settings data of this category page from all linked widgets
	---***
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	function page.save(user)
		--Retrieve data from settings widgets and commit to storage
		if t.autoSave ~= false and type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do
			wt.SaveSettingsData(t.dataManagement.category, t.dataManagement.keys[i])
		end end

		--Call listener
		if type(t.onSave) == "function" then t.onSave(user == true) end
	end

	---Apply settings data of this category page by calling all registered **onChange** handlers of all linked widgets
	---***
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	function page.apply(user)
		if type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do wt.ApplySettingsData(t.dataManagement.category, t.dataManagement.keys[i]) end end

		--Call listener
		if type(t.onApply) == "function" then t.onApply(user == true) end
	end

	---Revert any changes made in this category page and reload all linked widget data
	---***
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	function page.revert(user)
		--Update settings widgets
		if type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do wt.RevertSettingsData(t.dataManagement.category, t.dataManagement.keys[i]) end end

		--Call listener
		if type(t.onCancel) == "function" then t.onCancel(user == true) end
	end

	---Reset all settings data of this category page to default values
	---***
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	function page.reset(user)
		--Update with default values
		if type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do wt.ResetSettingsData(t.dataManagement.category, t.dataManagement.keys[i]) end end

		--Call listener
		if type(t.onDefault) == "function" then t.onDefault(user == true, false) end
	end

	--[ Settings Page ]

	if not WidgetToolsDB.lite or t.lite == false then

		--[ Canvas Frame ]

		width, height = SettingsPanel.Container.SettingsCanvas:GetSize()

		page.canvas = wt.CreateFrame({
			name = (t.append ~= false and t.name and addon or "") .. (t.name or addon) .. "Page",
			size = { w = width, h = height },
			visible = false,
		})

		page.content = t.scroll and wt.CreateScrollframe({
			parent = page.canvas,
			name = "Content",
			size = { w = width - 8, h = height - 51 },
			position = { offset = { y = -52 }, },
			scrollSize = { w = width - 24, h = t.scroll.height, },
			scrollSpeed = t.scroll.speed,
		}) or wt.CreateFrame({
			parent = page.canvas,
			name = "Content",
			size = { w = width - 12, h = height - 52 },
			position = { offset = { y = -52 }, },
		})

		--| Title & description

		local title = type(t.title) == "string" and t.title or C_AddOns.GetAddOnMetadata(addon, "title")

		page.title = wt.CreateTitle(page.canvas, {
			name = "Title",
			offset = { x = 7, y = -22 },
			text = title,
			font = "GameFontHighlightHuge",
		})

		if type(t.description) == "string" then page.description = wt.CreateDescription(page.title, {
			widthOffset = -161,
			spacer = 7,
			text = t.description,
		}) end

		--| Icon texture

		page.iconTexture = type(t.icon) == "string" and t.icon or C_AddOns.GetAddOnMetadata(addon, "IconTexture")

		page.icon = wt.CreateTexture(page.canvas, {
			name = "Icon",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = SettingsPanel.Container,
				relativePoint = "TOPLEFT",
				offset = { x = 8, }
			},
			size = { w = 42, h = 42 },
			path = page.iconTexture,
		})

		--| Divider texture

		wt.CreateTexture(page.canvas, {
			atlas = "Options_HorizontalDivider",
			position = { anchor = "TOP", offset = { y = -50 } },
		})

		--[ Utility Widgets ]

		--| Defaults button

		resetWarning = wt.RegisterPopupDialog(addon .. "_" .. (t.name or "") .. "DEFAULT", {
			text = wt.strings.settings.warningSingle:gsub("#PAGE", cr(title, NORMAL_FONT_COLOR)),
			accept = ACCEPT,
			onAccept = function() page.reset(true) end,
		})

		---@type actionButton
		resetButton = wt.CreateButton({
			parent = page.canvas,
			name = "Defaults",
			title = DEFAULTS,
			tooltip = { lines = { { text = wt.strings.settings.defaults.tooltip, }, } },
			position = {
				anchor = "TOPRIGHT",
				offset = { x = -36, y = -16 }
			},
			size = { w = 96, },
			action = function() StaticPopup_Show(resetWarning) end,
			disabled = t.static,
		})

		--| Revert Changes button

		revertButton = wt.CreateButton({
			parent = page.canvas,
			name = "Cancel",
			title = wt.strings.settings.cancel.label,
			tooltip = { lines = { { text = wt.strings.settings.cancel.tooltip, }, } },
			position = {
				anchor = "BOTTOMLEFT",
				offset = { x = -18, y = -31 }
			},
			size = { w = 140, },
			action = function() page.revert(true) end,
			disabled = t.static,
		})

		--Add save notice text
		saveNotice = wt.CreateText({
			parent = page.canvas,
			name = "SaveNotice",
			position = {
				anchor = "BOTTOMRIGHT",
				offset = { x = -96, y = -26.75 }
			},
			text = wt.strings.settings.save,
			justify = { h = "RIGHT", },
		})

		if t.static then saveNotice:Hide() end
	end

	--[ Category Resources ]

	page.categorySyncer = { onDefault = t.onDefault, dataManagement = t.dataManagement, titleIcon = t.titleIcon } --REPLACE temporary solution

	--[ Initialization ]

	--Register to the Settings panel
	if t.register then
		local parent = type(t.register) == "table" and type(t.register.isType) == "function" and t.register.isType("SettingsPage") and t.register or nil

		wt.RegisterSettingsPage(page, parent, t.titleIcon)
	end

	--Add content, performs tasks
	if type(t.initialize) == "function" then
		t.initialize(page.content, width, height, (t.dataManagement or {}).category, (t.dataManagement or {}).keys, t.name or addon)

		--Arrange content
		if t.arrangement and page.content then wt.ArrangeContent(page.content, us.Fill(t.arrangement, {
			margins = { l = 10, r = 10, t = 54, b = 10 },
			gaps = 54,
			resize = t.scroll ~= nil
		})) end
	end

	return page
end

---Create an new Settings category with a parent page, its child pages, and set up shared settings data management for them
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param parent settingsPageCreationData|settingsPage Settings page creation parameters to create, or reference to an existing *unregistered* settings page to set as the parent page for the new category<ul><li>***Note:*** If the provided parent candidate page is already registered (containing a **category** value), it will be dismissed and no new category will be created at all.</li></ul>
---@param pages? settingsPageCreationData[]|settingsPage[] List of settings page creation parameters to create, or references to an existing *unregistered* settings pages to add as subcategories under **parent**<ul><li>***Note:*** Already registered pages (which contain a **category** value) will be skipped and won't be included in the new category.</li></ul>
---@param t? settingsCategoryCreationData Optional parameters
---***
---@return settingsCategory|nil category Table containing references to settings pages and utility functions or nil if the specified **parent** was invalid
function wt.CreateSettingsCategory(addon, parent, pages, t)
	if not addon or not C_AddOns.IsAddOnLoaded(addon) or wt.IsWidget(parent) ~= "SettingsPage" and not parent.category then return nil end

	t = type(t) == "table" and t or {}

	---@class settingsCategory
	---@field pages settingsPage[]
	local category = { pages = {} }

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "SettingsCategory"
	---<p></p>
	function category.getType() return "SettingsCategory" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function category.isType(type) return type == "SettingsCategory" end

	--[ Utilities ]

	--| Batched settings data management

	---Force update the settings widgets for all pages in this category
	---***
	---@param handleChanges? boolean If true, also call all registered change handlers | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	function category.load(handleChanges, user)
		for i = 1, #category.pages do category.pages[i].load(handleChanges, user) end

		--Call listener
		if t.onLoad then t.onLoad(user == true) end
	end

	---Reset all settings data to their default values for all pages in this category
	---***
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param callListeners? boolean If true, call the **onDefault** listeners (if set) of each individual category page separately | ***Default:*** `true`
	function category.defaults(user, callListeners)
		for i = 1, #category.pages do
			local dataManagement = category.pages[i].categorySyncer.dataManagement --REPLACE
			local onDefault = callListeners ~= false and category.pages[i].categorySyncer.onDefault or nil --REPLACE

			--Update with default values
			if type(dataManagement) == "table" and type(dataManagement.keys) == "table" then for j = 1, #dataManagement.keys do
				wt.ResetSettingsData(dataManagement.category, dataManagement.keys[j])
			end end

			--Call listeners
			if type(onDefault) == "function" then onDefault(user == true, true) end
		end

		--Call listener
		if type(t.onDefaults) == "function" then t.onDefaults(user == true) end
	end

	--[ Category Pages ]

	--| Parent

	local parentTitle = parent.title and parent.title:GetText() or ""

	table.insert(category.pages, parent)

	wt.RegisterSettingsPage(parent)

	--Override defaults warning and add all defaults option to dialog
	wt.UpdatePopupDialog(parent.getResetPopupKey(), {
		text = wt.strings.settings.warning:gsub("#CATEGORY", cr(parentTitle, NORMAL_FONT_COLOR)):gsub("#PAGE", cr(parentTitle, NORMAL_FONT_COLOR)),
		accept = ALL_SETTINGS,
		alt = CURRENT_SETTINGS,
		onAccept = function() category.defaults(true) end,
		onAlt = function() parent.reset(true) end,
	})

	--| Subcategories

	if type(pages) == "table" then for i = 1, #pages do if type(pages[i]) == "table" and not pages[i].category then
		if type(pages[i].isType) ~= "function" and not pages[i].isType("SettingsPage") then pages[i] = wt.CreateSettingsPage(addon, pages[i]) end

		table.insert(category.pages, pages[i])

		wt.RegisterSettingsPage(pages[i], parent, pages[i].categorySyncer.titleIcon) --REPLACE

		--Override defaults warning and add all defaults option to dialog
		wt.UpdatePopupDialog(pages[i].getResetPopupKey(), {
			text = wt.strings.settings.warning:gsub("#CATEGORY", cr(parentTitle, NORMAL_FONT_COLOR)):gsub(
				"#PAGE", cr(pages[i].title and pages[i].title:GetText() or "", NORMAL_FONT_COLOR)
			),
			accept = ALL_SETTINGS,
			alt = CURRENT_SETTINGS,
			onAccept = function() category.defaults(true) end,
			onAlt = function() pages[i].reset(true) end,
		})
	end end end

	return category
end


--[[ DATA MANAGER WIDGETS ]]

--| Value clipboard

---@class clipboard
---@field toggle boolean|nil Toggle value
---@field selection wrappedInteger|nil Selector index
---@field selections wrappedBooleanArray|nil Multiselector data
---@field anchor wrappedAnchor|nil Frame Anchor Point
---@field justifyH wrappedJustifyH|nil Horizontal text alignment value
---@field justifyV wrappedJustifyV|nil Vertical text alignment value
---@field strata wrappedStrata|nil Frame Strata value
---@field text string|nil Text value
---@field numeric number|nil Number value
---@field color colorData|nil RGB(A) color value
wt.clipboard = {}

--| Utilities

---Register a handler as a listener for **event**
---@param listeners table<string, function[]>
---@param event string
---@param listener function
---@param callIndex integer
local function addListener(listeners, event, listener, callIndex)
	if not listeners[event] then listeners[event] = {} end

	local l = listeners[event]

	if type(callIndex) ~= "number" then table.insert(l, listener) else table.insert(l, Clamp(math.floor(callIndex), 1, #l + 1), listener) end
end

---Call registered listeners for **event**
---@param widget AnyWidgetType
---@param listeners table<string, function[]>
---@param event string
---@param ... any
local function callListeners(widget, listeners, event, ...)
	local l = listeners[event]

	if not l then return end

	for i = 1, #l do l[i](widget, ...) end
end

--[ Button ]

---Create a non-GUI action widget
---***
---@param t? actionCreationData Optional parameters
---***
---@return action action Reference to the new action widget, utility functions and more wrapped in a table
function wt.CreateAction(t)
	t = type(t) == "table" and t or {}

	---@class action
	local action = {}

	--[ Properties ]

	--| State

	local enabled = t.disabled ~= true

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "Action"
	---<p></p>
	function action.getType() return "Action" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function action.isType(type) return type == "Action" end

	--| Event handling

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	action.invoke = {
		enabled = function() callListeners(action, listeners, "enabled", enabled) end,

		trigger = function(user) callListeners(action, listeners, "trigger", user) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(action, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	action.setListener = {
		---@param listener ButtonEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener ButtonEventHandler_trigger Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		trigger = function(listener, callIndex) addListener(listeners, "trigger", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener ButtonEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function action.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
	function action.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then action.invoke.enabled() end
	end

	--| Action

	---Trigger the action registered for the button (if it is enabled)
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "trigger" event and call registered listeners | ***Default:*** `false`
	function action.trigger(user, silent)
		if enabled and t.action then t.action(action, user) end

		if not silent then action.invoke.trigger(user) end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then action.setListener._(v[i].event, v[i].handler, v[i].callIndex) else action.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, action.setEnabled) end

	return action
end

--| GUI

---Set the parameters of a GUI button widget frame
---@param button actionButton|customButton
---@param t actionButtonCreationData|customButtonCreationData
---@param name string
---@param title string
---@param useHighlight boolean
local function setUpButtonFrame(button, t, name, title, useHighlight)

	--[ Frame Setup ]

	--| Position & dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or 80
	t.size.h = t.size.h or 22
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(button.widget, t.position) end
	wt.SetArrangementDirective(button.widget, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	button.widget:SetSize(t.size.w, t.size.h)

	--| Visibility

	wt.SetVisibility(button.widget, t.visible ~= false)

	if t.frameStrata then button.widget:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then button.widget:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then button.widget:SetToplevel(t.keepOnTop) end

	--| Hover target

	button.frame = CreateFrame("Frame", name .. "HoverTarget", button.widget)
	button.frame:SetPoint("TOPLEFT")
	button.frame:SetSize(button.widget:GetSize())

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then button.widget:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else button.widget:HookScript(key, value) end
	end end

	--| UX

	button.widget:HookScript("OnClick", function(_, mouseButton)
		if mouseButton ~= "LeftButton" or not button.widget:IsEnabled() then return end

		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

		button.trigger(true)
	end)

	--Linked mouse interactions
	button.frame:HookScript("OnEnter", function() if button.widget:IsEnabled() then
		button.widget:LockHighlight()
		if IsMouseButtonDown("LeftButton") then button.widget:SetButtonState("PUSHED") end
		if button.label and useHighlight then button.label:SetFontObject(t.font.highlight) end
	end end)
	button.frame:HookScript("OnLeave", function() if button.widget:IsEnabled() then
		button.widget:UnlockHighlight()
		button.widget:SetButtonState("NORMAL")
		if button.label and useHighlight then button.label:SetFontObject(t.font.normal) end
	end end)
	button.frame:HookScript("OnMouseDown", function(_, b) if button.widget:IsEnabled() and b == "LeftButton" then
		button.widget:SetButtonState("PUSHED")
	end end)
	button.frame:HookScript("OnMouseUp", function(_, b, isInside) if button.widget:IsEnabled() then
		button.widget:SetButtonState("NORMAL")

		if isInside and b == "LeftButton" then button.widget:Click(b) end
	end end)

	--| Tooltip

	if type(t.tooltip) == "table" then wt.AddTooltip(button.frame, {
		title = t.tooltip.title or title,
		lines = t.tooltip.lines,
		anchor = "ANCHOR_TOPLEFT",
		offset = { x = 20, },
	}, { triggers = { button.frame, }, }) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ actionButton
	---@param state boolean
	local function updateState(_, state)
		button.widget:SetEnabled(state)

		if button.label then if state then
			if useHighlight and button.widget:IsMouseOver() then button.label:SetFontObject(t.font.highlight) else button.label:SetFontObject(t.font.normal) end
		else button.label:SetFontObject(t.font.disabled) end end
	end

	--Set up starting state
	updateState(button, button.isEnabled())

	--Handle widget updates
	button.setListener.enabled(updateState, 1)
end

---Create a Blizzard button GUI frame with enhanced widget functionality
---***
---@param t? actionButtonCreationData Optional parameters
---@param action? action Reference to an already existing action manager to mutate into a button instead of creating a new base widget
---***
---@return actionButton|action # References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table
function wt.CreateButton(t, action)
	t = type(t) == "table" and t or {}
	action = action and action.isType and action.isType("Action") and action or wt.CreateAction(t)

	if WidgetToolsDB.lite and t.lite ~= false then return action end

	---@class actionButton : action
	---@field frame Frame Frame to catch mouse interactions and serve as a hover trigger to be able to show the tooltip or when the button is disabled
	local button = action

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Action"
	---@return "Button"
	---<p></p>
	function button.getType() return "Action", "Button" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function button.isType(type) return type == "Action" or type == "Button" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Button")

	button.widget = CreateFrame("Button", name, t.parent, "UIPanelButtonTemplate")

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Button"
	local customFonts = t.font ~= nil
	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontNormal"
	t.font.highlight = t.font.highlight or "GameFontHighlight"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	if t.label ~= false then
		if customFonts then
			button.label = wt.CreateText({
				parent = button.widget,
				name = "Label",
				position = { anchor = "CENTER", },
				width = t.size.w,
				font = t.font.normal,
			})

			--Hide the built-in template label
			_G[name .. "Text"]:Hide()
		else button.label = _G[name .. "Text"] end

		if t.titleOffset then button.label:SetPoint("CENTER", t.titleOffset.x or 0, t.titleOffset.y or 0) end

		button.label:SetText(title)
	else _G[name .. "Text"]:Hide() end

	--| Shared setup

	setUpButtonFrame(button, t, name, title, t.font.highlight ~= nil)

	return button
end

---Create a Blizzard button GUI frame with customizable backdrop and enhanced widget functionality
---***
---@param t? customButtonCreationData Optional parameters
---@param action? action Reference to an already existing action button to mutate into a custom button instead of creating a new base widget
---***
---@return customButton|action # References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button) (inheriting [BackdropTemplate](https://warcraft.wiki.gg/wiki/BackdropTemplate)), utility functions and more wrapped in a table
function wt.CreateCustomButton(t, action)
	t = type(t) == "table" and t or {}
	action = action and action.isType and action.isType("Action") and action or wt.CreateAction(t)

	if WidgetToolsDB.lite and t.lite ~= false then return action end

	---@class customButton : action
	---@field frame Frame Frame to catch mouse interactions and serve as a hover trigger to be able to show the tooltip or when the button is disabled
	local button = action

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Action"
	---@return "CustomButton"
	---<p></p>
	function button.getType() return "Action", "CustomButton" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function button.isType(type) return type == "Action" or type == "CustomButton" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Button")

	button.widget = CreateFrame("Button", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Button"
	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontNormal"
	t.font.highlight = t.font.highlight or "GameFontHighlight"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	if t.label ~= false then
		button.label = wt.CreateText({
			parent = button.widget,
			name = "Label",
			position = { anchor = "CENTER", },
			width = t.size.w,
			font = t.font.normal,
		})

		if t.titleOffset then button.label:SetPoint("CENTER", t.titleOffset.x or 0, t.titleOffset.y or 0) end

		button.label:SetText(title)
	end

	--| Shared setup

	setUpButtonFrame(button, t, name, title, true)

	--| Backdrop

	if type(t.backdropUpdates) == "table" then for i = 1, #t.backdropUpdates do
		if type(t.backdropUpdates[i].triggers) ~= "table" then t.backdropUpdates[i].triggers = {} end
		table.insert(t.backdropUpdates[i].triggers, button.frame)
	end end

	wt.SetBackdrop(button.widget, t.backdrop, t.backdropUpdates)

	return button
end

--[ Toggle ]

---Create a non-GUI toggle widget with boolean data management logic
---***
---@param t? toggleCreationData Optional parameters
---***
---@return toggle toggle Reference to the new toggle widget, utility functions and more wrapped in a table
function wt.CreateToggle(t)
	t = type(t) == "table" and t or {}

	--[ Wrapper table ]

	---@class toggle
	local toggle = {}

	--[ Properties ]

	--| Data

	local default = t.default == true
	local value = t.value
	if type(value) ~= "boolean" then if type(t.getData) == "function" then value = t.getData() else value = default end end
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "Toggle"
	---<p></p>
	function toggle.getType() return "Toggle" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function toggle.isType(type) return type == "Toggle" end

	--| Event handling

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	toggle.invoke = {
		enabled = function() callListeners(toggle, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(toggle, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(toggle, listeners, "saved", success) end,

		---@param user boolean
		toggled = function(user) callListeners(toggle, listeners, "toggled", value, user) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(toggle, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	toggle.setListener = {
		---@param listener ToggleEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener ToggleEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener ToggleEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener ToggleEventHandler_toggled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		toggled = function(listener, callIndex) addListener(listeners, "toggled", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener ToggleEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function toggle.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			toggle.setState(t.getData(), handleChanges, silent)

			if not silent then toggle.invoke.loaded(true) end
		else
			if handleChanges and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then toggle.invoke.loaded(false) end
		end
	end

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param state? boolean Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
	function toggle.saveData(state, silent)
		if type(t.saveData) == "function" then
			if state == nil then state = value end

			t.saveData(state == true)

			if not silent then toggle.invoke.saved(true) end
		elseif not silent then toggle.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return boolean|nil
	function toggle.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param state? boolean Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function toggle.setData(state, handleChanges, silent)
		toggle.saveData(state, silent)
		toggle.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return boolean default
	function toggle.getDefault() return default end

	---Set the default value
	---@param state? boolean ***Default:*** `false`
	function toggle.setDefault(state) default = state == true end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function toggle.resetData(handleChanges, silent) toggle.setData(default, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **toggle.revertData()**
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function toggle.snapshotData(stored) if stored == true then snapshot = toggle.getData() else snapshot = value end end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **toggle.snapshotData()**
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function toggle.revertData(handleChanges, silent) toggle.setData(snapshot, handleChanges, silent) end

	---Returns the current toggle state of the widget
	---@return boolean
	function toggle.getState() return value end

	---Verify and set the toggle value of the widget to the provided state
	---***
	---@param state? boolean ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "toggled" event and call registered listeners | ***Default:*** `false`
	function toggle.setState(state, user, silent)
		value = state == true

		if not silent then toggle.invoke.toggled(user == true) end

		if user and t.instantSave ~= false then toggle.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	---Flip the current toggle state of the widget
	---***
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "toggled" event and call registered listeners | ***Default:*** `false`
	function toggle.toggleState(user, silent) toggle.setState(not value, user, silent) end

	---Utility turn a toggle state value into formatted string
	---***
	---@param state? boolean ***Default:*** *(current value)*
	---@return string
	function toggle.formatValue(state)
		if type(state) ~= "boolean" then state = value end

		return crc((state and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), state and "FFAAAAFF" or "FFFFAA66")
	end

	--| State & dependencies

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function toggle.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
	function toggle.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then toggle.invoke.enabled() end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then toggle.setListener._(v[i].event, v[i].handler, v[i].callIndex) else toggle.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(toggle, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, toggle.setEnabled) end

	--Set starting value
	toggle.setState(value, false, true)

	return toggle
end

--| GUI

---Create a Blizzard checkbox GUI frame with enhanced widget functionality
---***
---@param t? checkboxCreationData Optional parameters
---@param toggle? toggle Reference to an already existing toggle to mutate into a checkbox instead of creating a new base widget
---***
---@return checkbox|toggle # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateCheckbox(t, toggle)
	t = type(t) == "table" and t or {}
	toggle = toggle and toggle.isType and toggle.isType("Toggle") and toggle or wt.CreateToggle(t)

	if WidgetToolsDB.lite and t.lite ~= false then return toggle end

	---@class checkbox: toggle
	---@field label FontString|nil
	local checkbox = toggle

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Toggle"
	---@return "Checkbox"
	---<p></p>
	function checkbox.getType() return "Toggle", "Checkbox" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function checkbox.isType(type) return type == "Toggle" or type == "Checkbox" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")

	checkbox.frame = CreateFrame("Frame", name, t.parent)
	checkbox.button = CreateFrame("CheckButton", name .. "Checkbox", checkbox.frame, "SettingsCheckboxTemplate")

	--| Position & dimensions

	t.size = t.size or {}
	t.size.h = t.size.h or checkbox.button:GetHeight()
	t.size.w = t.label == false and t.size.h * (30 / 29) or t.size.w or 190
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(checkbox.frame, t.position) end
	wt.SetArrangementDirective(checkbox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	checkbox.button:SetPoint("LEFT")
	wt.SetPosition(checkbox.button.HoverBackground, {
		anchor = "LEFT",
		offset = { x = -2, },
	})

	checkbox.frame:SetSize(t.size.w, t.size.h)
	checkbox.button:SetSize(t.size.h * (30 / 29), t.size.h)
	checkbox.button.HoverBackground:SetSize(t.size.w + 2, t.size.h)

	--| Visibility

	wt.SetVisibility(checkbox.frame, t.visible ~= false)

	if t.frameStrata then checkbox.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then checkbox.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then checkbox.frame:SetToplevel(t.keepOnTop) end

	--| Label

	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontNormal"
	t.font.highlight = t.font.highlight or "GameFontHighlight"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle"

	checkbox.label = t.label ~= false and wt.CreateTitle(checkbox.frame, {
		offset = { x = t.size.h * (30 / 29) + 6, },
		text = title,
		anchor = "LEFT",
		font = t.font.normal,
	}) or nil

	--| Texture

	checkbox.button:GetPushedTexture():SetVertexColor(.6, .6, .6, 1)

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then checkbox.button:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnClick" then checkbox.button:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
		else checkbox.button:HookScript(key, value) end
	end end

	--| UX

	---Update the widget UI based on the toggle state
	---@param _ any
	---@param state boolean
	local function updateToggleState(_, state) checkbox.button:SetChecked(state) end

	--Handle widget updates
	checkbox.setListener.toggled(updateToggleState, 1)

	checkbox.button:HookScript("OnClick", function(self)
		local state = self:GetChecked()

		PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

		checkbox.setState(state, true)
	end)

	--Linked mouse interactions
	checkbox.frame:HookScript("OnEnter", function() if checkbox.isEnabled() then
		checkbox.button.HoverBackground:Show()
		if IsMouseButtonDown("LeftButton") then checkbox.button:SetButtonState("PUSHED") end
	end end)
	checkbox.frame:HookScript("OnLeave", function() if checkbox.isEnabled() then
		checkbox.button.HoverBackground:Hide()
		checkbox.button:SetButtonState("NORMAL")
	end end)
	checkbox.frame:HookScript("OnMouseDown", function(_, button) if checkbox.isEnabled() and button == "LeftButton" or (button == "RightButton") then
		checkbox.button:SetButtonState("PUSHED")
	end end)
	checkbox.frame:HookScript("OnMouseUp", function(_, button, isInside) if checkbox.isEnabled() then
		checkbox.button:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" then checkbox.button:Click(button) end
	end end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(checkbox.button, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_NONE",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = checkbox.button,
				relativePoint = "TOPRIGHT",
			},
		}, { triggers = { checkbox.frame, }, })

		wt.AddWidgetTooltipLines({ checkbox.button }, t.showDefault ~= false and checkbox.formatValue(checkbox.getDefault()), t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = checkbox.frame,
				condition = checkbox.isEnabled,
			},
			{
				frame = checkbox.button,
				condition = checkbox.isEnabled,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.toggle = checkbox.getState() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				checkbox.setState(wt.clipboard.toggle, true)
			end }):SetEnabled(wt.clipboard.toggle ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() checkbox.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() checkbox.resetData() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		checkbox.button:SetEnabled(state)
		checkbox.button:EnableMouse(state)

		if checkbox.label then checkbox.label:SetFontObject(state and t.font.normal or t.font.disabled) end
	end

	--Handle widget updates
	checkbox.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set starting toggle state
	updateToggleState(nil, checkbox.getState())

	--Set up starting state
	updateState(nil, checkbox.isEnabled())

	return checkbox
end

---Set the parameters of a GUI toggle frame
---@param toggle checkbox|radiobutton
---@param title string
---@param t checkboxCreationData
local function setUpToggleFrame(toggle, title, t)

	--[ Frame Setup ]

	--| Position & dimensions

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(toggle.frame, t.position) end
	wt.SetArrangementDirective(toggle.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	toggle.button:SetPoint("LEFT", (t.size.h - 16) / 2, 0)

	toggle.frame:SetSize(t.size.w, t.size.h)
	toggle.button:SetSize(16, 16)

	--| Visibility

	wt.SetVisibility(toggle.frame, t.visible ~= false)

	if t.frameStrata then toggle.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then toggle.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then toggle.frame:SetToplevel(t.keepOnTop) end

	--Update the frame order
	toggle.frame:SetFrameLevel(toggle.frame:GetFrameLevel() + 1)
	toggle.button:SetFrameLevel(toggle.button:GetFrameLevel() - 2)

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then toggle.button:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnClick" then toggle.button:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
		else toggle.button:HookScript(key, value) end
	end end

	--| UX

	---Update the widget UI based on the toggle state
	---@param _ any
	---@param state boolean
	local function updateToggleState(_, state) toggle.button:SetChecked(state) end

	--Handle widget updates
	toggle.setListener.toggled(updateToggleState, 1)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(toggle.frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_NONE",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = toggle.button,
				relativePoint = "TOPRIGHT",
			},
		}, { triggers = { toggle.button, }, })

		wt.AddWidgetTooltipLines({ toggle.frame }, t.showDefault ~= false and toggle.formatValue(toggle.getDefault()), t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = toggle.frame,
				condition = toggle.isEnabled,
			},
			{
				frame = toggle.button,
				condition = toggle.isEnabled,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.toggle = toggle.getState() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				toggle.setState(wt.clipboard.toggle, true)
			end }):SetEnabled(wt.clipboard.toggle ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() toggle.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() toggle.resetData() end }) end
		end
	}) end

	--[ Initialization ]

	--Set starting toggle state
	updateToggleState(nil, toggle.getState())
end

---Create a classic Blizzard checkbox GUI frame with enhanced widget functionality
---***
---@param t? checkboxCreationData Optional parameters
---@param toggle? toggle Reference to an already existing toggle to mutate into a checkbox instead of creating a new base widget
---***
---@return checkbox|toggle # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateClassicCheckbox(t, toggle)
	t = type(t) == "table" and t or {}
	toggle = toggle and toggle.isType and toggle.isType("Toggle") and toggle or wt.CreateToggle(t)

	if WidgetToolsDB.lite and t.lite ~= false then return toggle end

	---@type checkbox|toggle
	local checkbox = toggle

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Toggle"
	---@return "ClassicCheckbox"
	---<p></p>
	function checkbox.getType() return "Toggle", "ClassicCheckbox" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function checkbox.isType(type) return type == "Toggle" or type == "ClassicCheckbox" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")

	--Click target
	checkbox.frame = CreateFrame("Frame", name, t.parent)

	--Checkbox
	checkbox.button = CreateFrame("CheckButton", name .. "Checkbox", checkbox.frame, "InterfaceOptionsCheckButtonTemplate")

	--| Label

	t.font = t.font or {}
	t.font.normal = t.font.normal or "GameFontHighlight"
	t.font.highlight = t.font.highlight or "GameFontNormal"
	t.font.disabled = t.font.disabled or "GameFontDisable"

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle"

	if t.label ~= false then
		checkbox.label = _G[name .. "CheckboxText"]

		checkbox.label:SetPoint("LEFT", checkbox.button, "RIGHT", 2, 0)
		checkbox.label:SetFontObject(t.font.normal)

		checkbox.label:SetText(title)
	else _G[name .. "CheckboxText"]:Hide() end

	--| Shared setup

	t.size = t.size or {}
	t.size.h = t.size.h or 26
	t.size.w = t.label == false and t.size.h or t.size.w or 180

	setUpToggleFrame(checkbox, title, t)

	--[ Events ]

	--| UX

	checkbox.button:HookScript("OnClick", function(self)
		local state = self:GetChecked()

		PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

		checkbox.setState(state, true)
	end)

	--Linked mouse interactions
	checkbox.frame:HookScript("OnEnter", function() if checkbox.isEnabled() then
		checkbox.button:LockHighlight()
		if IsMouseButtonDown("LeftButton") or (IsMouseButtonDown("RightButton")) then checkbox.button:SetButtonState("PUSHED") end
	end end)
	checkbox.frame:HookScript("OnLeave", function() if checkbox.isEnabled() then
		checkbox.button:UnlockHighlight()
		checkbox.button:SetButtonState("NORMAL")
	end end)
	checkbox.frame:HookScript("OnMouseDown", function(_, button) if checkbox.isEnabled() and button == "LeftButton" or (button == "RightButton") then
		checkbox.button:SetButtonState("PUSHED")
	end end)
	checkbox.frame:HookScript("OnMouseUp", function(_, button, isInside) if checkbox.isEnabled() then
		checkbox.button:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" or (button == "RightButton") then checkbox.button:Click(button) end
	end end)

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		checkbox.button:SetEnabled(state)

		if checkbox.label then checkbox.label:SetFontObject(state and t.font.normal or t.font.disabled) end
	end

	--Handle widget updates
	checkbox.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, checkbox.isEnabled())

	return checkbox
end

---Create a Blizzard radio button GUI frame with enhanced widget functionality
---***
---@param t? radiobuttonCreationData Optional parameters
---@param toggle? toggle Reference to an already existing toggle to mutate into a radio button instead of creating a new base widget
---***
---@return radiobutton|toggle # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateRadiobutton(t, toggle)
	t = type(t) == "table" and t or {}
	toggle = toggle and toggle.isType and toggle.isType("Toggle") and toggle or wt.CreateToggle(t)

	if WidgetToolsDB.lite and t.lite ~= false then return toggle end

	---@class radiobutton: toggle
	---@field label? FontString
	local radiobutton = toggle

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Toggle"
	---@return "Radiobutton"
	---<p></p>
	function radiobutton.getType() return "Toggle", "Radiobutton" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function radiobutton.isType(type) return type == "Toggle" or type == "Radiobutton" end

	--[ Properties ]

	local clearable = t.clearable

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")

	--Click target
	radiobutton.frame = CreateFrame("Frame", name, t.parent)

	--Radio button
	radiobutton.button = CreateFrame("CheckButton", name .. "RadioButton", radiobutton.frame, "UIRadioButtonTemplate")

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle"

	if t.label ~= false then
		radiobutton.label = _G[name .. "RadioButtonText"]

		radiobutton.label:SetPoint("LEFT", radiobutton.button, "RIGHT", 3, 0)
		radiobutton.label:SetFontObject("GameFontNormal")

		radiobutton.label:SetText(title)
	else _G[name .. "RadioButtonText"]:Hide() end

	--| Shared setup

	t.size = t.size or {}
	t.size.h = t.size.h or 18
	t.size.w = t.label == false and t.size.h or t.size.w or 180

	setUpToggleFrame(radiobutton, title, t)

	--[ Events ]

	--| UX

	radiobutton.button:HookScript("OnClick", function(_, button)
		if button == "LeftButton" then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

			radiobutton.setState(true, true)
		elseif clearable and button == "RightButton" then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

			radiobutton.setState(false, true)
		end
	end)

	--Linked mouse interactions
	radiobutton.frame:HookScript("OnEnter", function() if radiobutton.button:IsEnabled() then
		radiobutton.button:LockHighlight()
		if IsMouseButtonDown("LeftButton") or (clearable and IsMouseButtonDown("RightButton")) then radiobutton.button:SetButtonState("PUSHED") end
	end end)
	radiobutton.frame:HookScript("OnLeave", function() if radiobutton.button:IsEnabled() then
		radiobutton.button:UnlockHighlight()
		radiobutton.button:SetButtonState("NORMAL")
	end end)
	radiobutton.frame:HookScript("OnMouseDown", function(_, button) if radiobutton.button:IsEnabled() and button == "LeftButton" or (clearable and button == "RightButton") then
		radiobutton.button:SetButtonState("PUSHED")
	end end)
	radiobutton.frame:HookScript("OnMouseUp", function(_, button, isInside) if radiobutton.button:IsEnabled() then
		radiobutton.button:SetButtonState("NORMAL")

		if isInside and button == "LeftButton" or (clearable and button == "RightButton") then radiobutton.button:Click(button) end
	end end)

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		radiobutton.button:SetEnabled(state)

		if radiobutton.label then radiobutton.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
	end

	--Handle widget updates
	radiobutton.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, radiobutton.isEnabled())

	return radiobutton
end

--[ Selector ]

local itemsets = {
	anchor = {
		{ name = wt.strings.points.top.left, value = "TOPLEFT" },
		{ name = wt.strings.points.top.center, value = "TOP" },
		{ name = wt.strings.points.top.right, value = "TOPRIGHT" },
		{ name = wt.strings.points.left, value = "LEFT" },
		{ name = wt.strings.points.center, value = "CENTER" },
		{ name = wt.strings.points.right, value = "RIGHT" },
		{ name = wt.strings.points.bottom.left, value = "BOTTOMLEFT" },
		{ name = wt.strings.points.bottom.center, value = "BOTTOM" },
		{ name = wt.strings.points.bottom.right, value = "BOTTOMRIGHT" },
	},
	justifyH = {
		{ name = wt.strings.points.left, value = "LEFT" },
		{ name = wt.strings.points.center, value = "CENTER" },
		{ name = wt.strings.points.right, value = "RIGHT" },
	},
	justifyV = {
		{ name = wt.strings.points.top.center, value = "TOP" },
		{ name = wt.strings.points.center, value = "MIDDLE" },
		{ name = wt.strings.points.bottom.center, value = "BOTTOM" },
	},
	strata = {
		{ name = wt.strings.strata.lowest, value = "BACKGROUND" },
		{ name = wt.strings.strata.lower, value = "LOW" },
		{ name = wt.strings.strata.low, value = "MEDIUM" },
		{ name = wt.strings.strata.lowMid, value = "HIGH" },
		{ name = wt.strings.strata.highMid, value = "DIALOG" },
		{ name = wt.strings.strata.high, value = "FULLSCREEN" },
		{ name = wt.strings.strata.higher, value = "FULLSCREEN_DIALOG" },
		{ name = wt.strings.strata.highest, value = "TOOLTIP" },
	}
}

---@class selectorToggle : toggle
---@field index integer The index of this toggle item inside a selector widget

---Create a non-GUI selector widget (managing a collection of toggle widgets) with integer (selection index) data management logic
---***
---@param t? selectorCreationData Optional parameters
---***
---@return selector selector Reference to the new selector widget, utility functions and more wrapped in a table
function wt.CreateSelector(t)
	t = type(t) == "table" and t or {}

	--[ Wrapper table ]

	---@class selector
	local selector = {}

	--[ Properties ]

	local clearable = t.clearable

	--| Toggle items

	---@type (toggle|selectorToggle)[]
	selector.toggles = {}

	---@type (toggle|selectorToggle)[]
	local inactive = {}

	--| Data

	local default = 1

	---Data verification utility
	---@param v any
	---@return integer|nil
	local function verify(v)
		v = type(v) == "number" and Clamp(math.floor(v), 1, #t.items) or nil

		return v and v or not clearable and default or nil
	end

	default = verify(t.default)
	local value = verify(t.value or type(t.getData) == "function" and t.getData() or nil)
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "Selector"
	---<p></p>
	function selector.getType() return "Selector" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function selector.isType(type) return type == "Selector" end

	--| Event handling

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	selector.invoke = {
		enabled = function() callListeners(selector, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(selector, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(selector, listeners, "saved", success) end,

		---@param user boolean
		selected = function(user) callListeners(selector, listeners, "selected", value, user) end,

		updated = function() callListeners(selector, listeners, "updated") end,

		added = function(toggle) callListeners(selector, listeners, "added", toggle) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(selector, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	selector.setListener = {
		---@param listener SelectorEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener SelectorEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener SelectorEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener SelectorEventHandler_selected Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		selected = function(listener, callIndex) addListener(listeners, "selected", listener, callIndex) end,

		---@param listener SelectorEventHandler_updated Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		updated = function(listener, callIndex) addListener(listeners, "updated", listener, callIndex) end,

		---@param listener SelectorEventHandler_added Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		added = function(listener, callIndex) addListener(listeners, "added", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener SelectorEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Toggle items

	---Register, update or set up a new toggle widget item
	---***
	---@param index integer
	---@param silent? boolean ***Default:*** `false`
	local function setToggle(index, silent)
		local new = false

		if wt.IsWidget(t.items[index]) == "Toggle" then
			--| Register the already defined toggle widget

			new = true
			selector.toggles[index] = t.items[index]
		elseif index > #selector.toggles then
			if #inactive > 0 then
				--| Reenable an inactive toggle widget

				selector.toggles[index] = inactive[#inactive]
				table.remove(inactive, #inactive)
			else
				--| Create a new toggle widget

				new = true
				selector.toggles[index] = wt.CreateToggle({ listeners = { toggled = { { handler = function (_, state, user)
					if state and user and type(t.items[selector.toggles[index].index].onSelect) == "function" then t.items[selector.toggles[index].index].onSelect() end
				end, }, }, },  })
			end
		end

		selector.toggles[index].index = index

		if new and not silent then selector.invoke.added(selector.toggles[index]) end
	end

	---Update the list of items currently set for the selector widget, updating its parameters and toggle widgets
	--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
	--- - ***Note:*** The currently selected item may not be the same after an item was removed. In that case, the item at the same index will be selected instead. If one or more items from the last indexes were removed, the new last item at the reduced count index will be selected. Make sure to use **selector.setSelected(...)** to correct the selection if needed!
	---***
	---@param newItems (selectorItem|toggle|selectorToggle)[] Table containing subtables with data used to update the toggle widgets, or already existing toggle widgets
	---@param silent? boolean If false, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
	function selector.updateItems(newItems, silent)
		t.items = newItems

		--Update the toggle widgets
		for i = 1, #newItems do
			setToggle(i, silent)

			if not silent then selector.toggles[i].invoke._("activated", true) end
		end

		--Deactivate extra toggle widgets
		while #newItems < #selector.toggles do
			selector.toggles[#selector.toggles].setState(false)

			if not silent then selector.toggles[#selector.toggles].invoke._("activated", false) end

			table.insert(inactive, selector.toggles[#selector.toggles])
			table.remove(selector.toggles, #selector.toggles)
		end

		if not silent then selector.invoke.updated() end

		selector.setSelected(value, nil, silent)
	end

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function selector.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			selector.setSelected(t.getData(), handleChanges)

			if not silent then selector.invoke.loaded(true) end
		else
			if handleChanges then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then selector.invoke.loaded(false) end
		end
	end

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param data? wrappedInteger If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function selector.saveData(data, silent)
		if type(t.saveData) == "function" then
			t.saveData(type(data) == "table" and verify(data.index) or value)

			if not silent then selector.invoke.saved(true) end
		elseif not silent then selector.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return integer|nil
	function selector.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param data? wrappedInteger If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.setData(data, handleChanges, silent)
		selector.saveData(data, silent)
		selector.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return integer|nil default
	function selector.getDefault() return default end

	---Set the default value
	---@param index integer|nil | ***Default:*** *no change*
	function selector.setDefault(index) default = verify(index) end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.resetData(handleChanges, silent) selector.setData({ index = default }, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function selector.snapshotData(stored) snapshot = stored and selector.getData() or value end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.revertData(handleChanges, silent) selector.setData({ index = snapshot }, handleChanges, silent) end

	---Returns the index of the currently selected item or nil if there is no selection
	---@return integer|nil index
	function selector.getSelected() return value end

	---Verify and set the specified item as selected
	---***
	---@param index? integer ***Default:*** nil *(no selection)*
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "selected" event and call registered listeners | ***Default:*** `false`
	function selector.setSelected(index, user, silent)
		value = verify(index)

		for i = 1, #selector.toggles do selector.toggles[i].setState(i == value, user, silent) end

		if user and t.instantSave ~= false then selector.saveData(nil, silent) end

		if not silent then selector.invoke.selected(user == true) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function selector.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
	function selector.setEnabled(state, silent)
		enabled = state ~= false

		--Update toggle items
		for i = 1, #selector.toggles do selector.toggles[i].setEnabled(state, silent) end

		if not silent then selector.invoke.enabled() end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then selector.setListener._(v[i].event, v[i].handler, v[i].callIndex) else selector.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register starting items
	for i = 1, #t.items do setToggle(i) end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(selector, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, selector.setEnabled) end

	--Set starting value
	selector.setSelected(value, false, true)

	return selector
end

---Create a non-GUI special selector widget (managing a collection of toggle widgets) with data management logic specific to the specified **itemset**
---***
---@param itemset SpecialSelectorItemset Specify what type of selector should be created
---@param t? specialSelectorCreationData Optional parameters
---***
---@return specialSelector selector Reference to the new selector widget, utility functions and more wrapped in a table
function wt.CreateSpecialSelector(itemset, t)
	t = type(t) == "table" and t or {}

	--[ Wrapper table ]

	---@class specialSelector
	local selector = {}

	--[ Properties ]

	local clearable = t.clearable

	--| Toggle items

	---@diagnostic disable-next-line: inject-field --REPLACE when changing t references to locals
	t.items = {}
	for i = 1, #itemsets[itemset] do
		t.items[i] = {}
		t.items[i].title = itemsets[itemset][i].name
		t.items[i].tooltip = { lines = { { text = "(" .. itemsets[itemset][i].value .. ")", }, } }
	end

	---@type (toggle|selectorToggle)[]
	selector.toggles = {}

	---@type (toggle|selectorToggle)[]
	local inactive = {}

	--| Data

	local default = 1

	---Data verification utility
	---@param v any
	---@return integer|nil
	local function verify(v)
		if type(v) == "number" then return Clamp(math.floor(v), 1, #itemsets[itemset]) end

		if type(v) == "table" and type(v.value) == "string" then v = v.value end
		if type(v) == "string" then for i = 1, #itemsets[itemset] do if itemsets[itemset][i].value == v then return i end end end

		return not clearable and default or nil
	end

	default = verify(t.default)
	local value = verify(t.value or type(t.getData) == "function" and t.getData() or nil)
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "SpecialSelector"
	---<p></p>
	function selector.getType() return "SpecialSelector" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function selector.isType(type) return type == "SpecialSelector" end

	---Return the itemset type specified for this special selector on creation
	---@return SpecialSelectorItemset itemset
	function selector.getItemset() return itemset end

	--| Event handling

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	selector.invoke = {
		enabled = function() callListeners(selector, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(selector, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(selector, listeners, "saved", success) end,

		---@param user boolean
		selected = function(user) callListeners(selector, listeners, "selected", value, user) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(selector, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	selector.setListener = {
		---@param listener SpecialSelectorEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener SpecialSelectorEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener SpecialSelectorEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener SpecialSelectorEventHandler_selected Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		selected = function(listener, callIndex) addListener(listeners, "selected", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener SpecialSelectorEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function selector.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			selector.setSelected(t.getData(), handleChanges)

			if not silent then selector.invoke.loaded(true) end
		else
			if handleChanges then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then selector.invoke.loaded(false) end
		end
	end

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function selector.saveData(data, silent)
		if type(t.saveData) == "function" then
			t.saveData(itemsets[itemset][verify(data or value)].value)

			if not silent then selector.invoke.saved(true) end
		elseif not silent then selector.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return specialSelectorValueTypes|nil
	function selector.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.setData(data, handleChanges, silent)
		selector.saveData(data, silent)
		selector.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return specialSelectorValueTypes|nil default
	function selector.getDefault() return itemsets[itemset][default] and itemsets[itemset][default].value or nil end

	---Set the default value
	---***
	---@param selected integer|specialSelectorValueTypes|nil | ***Default:*** *no change*
	---<p></p>
	function selector.setDefault(selected) default = verify(selected) end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.resetData(handleChanges, silent) selector.setData(default, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
	---***
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function selector.snapshotData(stored) snapshot = stored and selector.getData() or value end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.revertData(handleChanges, silent) selector.setData(snapshot, handleChanges, silent) end

	---Returns the value of the currently selected item or nil if there is no selection
	---@return specialSelectorValueTypes|nil selected
	---<p></p>
	function selector.getSelected() return itemsets[itemset][value] and itemsets[itemset][value].value or nil end

	---Set the specified item as selected
	---***
	---@param selected integer|specialSelectorValueTypes|nil The index or the value of the item to be set as selected | ***Default:*** *no selection:* `nil`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "selected" event and call registered listeners | ***Default:*** `false`
	---<p></p>
	function selector.setSelected(selected, user, silent)
		value = verify(selected)

		for i = 1, #selector.toggles do selector.toggles[i].setState(i == value, user, silent) end

		if user and t.instantSave ~= false then selector.saveData(nil, silent) end

		if not silent then selector.invoke.selected(user == true) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function selector.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
	function selector.setEnabled(state, silent)
		enabled = state ~= false

		--Update toggle items
		for i = 1, #selector.toggles do selector.toggles[i].setEnabled(state, silent) end

		if not silent then selector.invoke.enabled() end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then selector.setListener._(v[i].event, v[i].handler, v[i].callIndex) else selector.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register starting items
	for i = 1, #t.items do if type(t.items[i]) == "table" then
		if t.items[i].isType and t.items[i].isType("Toggle") then
			--| Register the already defined toggle widget

			selector.toggles[i] = t.items[i]
		elseif #inactive > 0 then
			--| Reenable an inactive toggle widget

			selector.toggles[i] = inactive[#inactive]
			table.remove(inactive, #inactive)
		else
			--| Create a new toggle widget

			selector.toggles[i] = wt.CreateToggle({ listeners = { toggled = { { handler = function (_, state, user)
				if type(t.items[selector.toggles[i].index].onSelect) == "function" and user and state then t.items[selector.toggles[i].index].onSelect() end
			end, }, }, }, })
		end

		selector.toggles[i].index = i
	end end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(selector, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, selector.setEnabled) end

	--Set starting value
	selector.setSelected(value, false, true)

	return selector
end

---Create a non-GUI multiselector widget (managing a collection of toggle widgets) with boolean mask data management logic
---***
---@param t? multiselectorCreationData Optional parameters
---***
---@return multiselector selector Reference to the new multiselector widget, utility functions and more wrapped in a table
function wt.CreateMultiselector(t)
	t = type(t) == "table" and t or {}

	---@class multiselector
	local selector = {}

	--[ Properties ]

	--| Toggle items

	t.items = type(t.items) == "table" and us.Clone(t.items) or {}
	t.limits = t.limits or {}
	t.limits.min = t.limits.min or 1
	t.limits.max = t.limits.max or #t.items

	---@type (toggle|selectorToggle)[]
	selector.toggles = {}

	---@type (toggle|selectorToggle)[]
	local inactive = {}

	--| Data

	local default = {}

	for i = 1, #t.items do default[i] = false end

	---Data verification utility
	---@param v any
	---@return boolean[]
	local function verify(v)
		return us.Fill(us.Prune(type(v) == "table" and us.Clone(v) or {}, function(_, itemValue) return type(itemValue) == "boolean" end), default)
	end

	default = verify(t.default)
	local value = verify(t.value or type(t.getData) == "function" and t.getData() or nil)

	---@type boolean[]
	local snapshot = us.Clone(value)

	--| State

	local enabled = t.disabled ~= true

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "Multiselector"
	---<p></p>
	function selector.getType() return "Multiselector" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function selector.isType(type) return type == "Multiselector" end

	--| Event handling

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	selector.invoke = {
		enabled = function() callListeners(selector, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(selector, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(selector, listeners, "saved", success) end,

		---@param user boolean
		selected = function(user) callListeners(selector, listeners, "selected", value, user) end,

		updated = function() callListeners(selector, listeners, "updated") end,

		added = function(toggle) callListeners(selector, listeners, "added", toggle) end,

		---@param count integer
		limited = function(count) callListeners(selector, listeners, "limited", count <= t.limits.min, count < t.limits.min) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(selector, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	selector.setListener = {
		---@param listener MultiselectorEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener MultiselectorEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener MultiselectorEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener MultiselectorEventHandler_selected Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		selected = function(listener, callIndex) addListener(listeners, "selected", listener, callIndex) end,

		---@param listener MultiselectorEventHandler_updated Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		updated = function(listener, callIndex) addListener(listeners, "updated", listener, callIndex) end,

		---@param listener SelectorEventHandler_added Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		added = function(listener, callIndex) addListener(listeners, "added", listener, callIndex) end,

		---@param listener MultiselectorEventHandler_limited Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		limited = function(listener, callIndex) addListener(listeners, "limited", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener SelectorEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Toggle items

	---Register, update or set up a new toggle widget item
	---***
	---@param item toggle|selectorToggle
	---@param index integer
	---@param silent? boolean ***Default:*** `false`
	local function setToggle(item, index, silent)
		if type(item) ~= "table" then return end

		local new = false

		if item.isType and item.isType("Toggle") then
			--| Register the already defined toggle widget

			new = true
			selector.toggles[index] = item
		elseif #inactive > 0 then
			--| Reenable an inactive toggle widget

			selector.toggles[index] = inactive[#inactive]
			table.remove(inactive, #inactive)
		else
			--| Create a new toggle widget

			new = true
			selector.toggles[index] = wt.CreateToggle({ listeners = { toggled = { { handler = function (_, state, user)
				if type(t.items[selector.toggles[index].index].onSelect) == "function" and user and state then t.items[selector.toggles[index].index].onSelect() end
			end, }, }, }, })
		end

		selector.toggles[index].index = index

		if new and not silent then selector.invoke.added(selector.toggles[index]) end
	end

	---Update the list of items currently set for the selector widget, updating its parameters and toggle widgets
	--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
	--- - ***Note:*** The currently selected item may not be the same after item were removed. In that case, the new item at the same index will be selected instead. If one or more items from the last indexes were removed, the new last item at the reduced count index will be selected. Make sure to use **selector.setSelected(...)** to correct the selection if needed!
	---***
	---@param newItems (selectorItem|toggle|selectorToggle)[] Table containing subtables with data used to update the toggle widgets, or already existing toggle widgets
	---@param silent? boolean If false, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
	function selector.updateItems(newItems, silent)
		t.items = newItems

		--Update the toggle widgets
		for i = 1, #newItems do
			setToggle(newItems[i], i, silent)

			if not silent then selector.toggles[i].invoke._("activated", true) end
		end

		--Deactivate extra toggle widgets
		while #newItems < #selector.toggles do
			selector.toggles[#selector.toggles].setState(nil, nil, silent)

			if not silent then selector.toggles[#selector.toggles].invoke._("activated", false) end

			table.insert(inactive, selector.toggles[#selector.toggles])
			table.remove(selector.toggles, #selector.toggles)
		end

		if not silent then selector.invoke.updated() end

		--Update limits
		if t.limits.min > #t.items then t.limits.min = #t.items end
		if t.limits.max > #t.items then t.limits.max = #t.items end

		selector.setSelections(value, nil, silent)
	end

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function selector.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			selector.setSelections(t.getData(), handleChanges)

			if not silent then selector.invoke.loaded(true) end
		else
			if handleChanges then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then selector.invoke.loaded(false) end
		end
	end

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param data? wrappedBooleanArray If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function selector.saveData(data, silent)
		if type(t.saveData) == "function" then
			t.saveData(type(data) == "table" and verify(data.states) or value)

			if not silent then selector.invoke.saved(true) end
		elseif not silent then selector.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return boolean[]|nil
	function selector.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param data? wrappedBooleanArray If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.setData(data, handleChanges, silent)
		selector.saveData(data, silent)
		selector.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return boolean[] default
	function selector.getDefault() return default end

	---Set the default value
	---@param selections? boolean[] | ***Default:*** *no selected items: `false[]`*
	function selector.setDefault(selections) default = verify(selections) end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.revertData(handleChanges, silent) selector.setData({ states = us.Clone(snapshot) }, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function selector.snapshotData(stored) us.CopyValues(snapshot, stored and selector.getData() or value) end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function selector.resetData(handleChanges, silent) selector.setData({ states = us.Clone(default) }, handleChanges, silent) end

	---Returns the list of all items and their current states
	---***
	---@return boolean[] selections Indexed list of item states
	function selector.getSelections() return us.Clone(value) end

	---Set the specified items as selected
	---***
	---@param selections? boolean[] Indexed list of item states | ***Default:*** *no selected items: `false[]`*
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke "selected" and "limited" events and call registered listeners | ***Default:*** `false`
	function selector.setSelections(selections, user, silent)
		value = verify(selections)

		for i = 1, #selector.toggles do selector.toggles[i].setState(value and value[i], user, silent) end

		if user and t.instantSave ~= false then selector.saveData(nil, silent) end

		if not silent then
			selector.invoke.selected(user == true)

			--| Check limits

			local count = 0

			for _, v in pairs(value) do if v then count = count + 1 end end

			selector.invoke.limited(count)
		end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	---Set the specified item as selected
	---***
	---@param index integer Index of the item | ***Range:*** (1, #selector.toggles)
	---@param selected? boolean If true, set the item at this index as selected | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke "selected" and "limited" events and call registered listeners | ***Default:*** `false`
	function selector.setSelected(index, selected, user, silent)
		if not selector.toggles[index] then return end

		value[index] = selected == true

		selector.toggles[index].setState(selected, user, silent)

		if user and t.instantSave ~= false then selector.saveData(nil, silent) end

		if not silent then
			selector.invoke.selected(user == true)

			--| Check limits

			local count = 0

			for _, v in pairs(value) do if v then count = count + 1 end end

			selector.invoke.limited(count)
		end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function selector.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
	function selector.setEnabled(state, silent)
		enabled = state ~= false

		--Update toggle items
		for i = 1, #selector.toggles do selector.toggles[i].setEnabled(state, silent) end

		if not silent then selector.invoke.enabled() end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then selector.setListener._(v[i].event, v[i].handler, v[i].callIndex) else selector.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register starting items
	for i = 1, #t.items do setToggle(t.items[i], i) end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(selector, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, selector.setEnabled) end

	--Set starting value
	selector.setSelections(value, false, true)

	return selector
end

--| GUI

---Item naming utility
---@param parentName string
---@param index integer
---@return string name
local function findName(parentName, index)
	local name = "Item" .. index

	while _G[parentName .. name] do name = name .. "_" .. index end

	return name
end

---Set the parameters of a GUI selector widget frame
---@param selector radiogroup|checkgroup
---@param t radiogroupCreationData|checkgroupCreationData
---@param name string
---@param title string
local function setUpSelectorFrame(selector, t, name, title)

	--[ Frame Setup ]

	selector.frame = CreateFrame("Frame", name, t.parent)

	--| Position & dimensions

	t.columns = t.columns or 1
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(selector.frame, t.position) end
	wt.SetArrangementDirective(selector.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	selector.frame:SetWidth(t.width or max(t.label ~= false and 160 or 0, (t.labels ~= false and 160 or 16) * t.columns))
	selector.frame:SetHeight(math.ceil((#t.items) / t.columns) * 16 + (t.label ~= false and 14 or 0))

	--| Visibility

	wt.SetVisibility(selector.frame, t.visible ~= false)

	if t.frameStrata then selector.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then selector.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then selector.frame:SetToplevel(t.keepOnTop) end

	--| Label

	selector.label = t.label ~= false and wt.CreateTitle(selector.frame, {
		offset = { x = 4, },
		text = title,
	}) or nil

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then selector.frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else selector.frame:HookScript(key, value) end
	end end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state) if selector.label then selector.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end end

	--Handle widget updates
	selector.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, selector.isEnabled())
end

---Create a radio button selector GUI frame to pick one out of multiple options with enhanced widget functionality
---***
---@param t? radiogroupCreationData Optional parameters
---@param selector? selector|specialSelector Reference to an already existing selector to mutate into a radio selector instead of creating a new base widget
---***
---@return radiogroup|specialRadiogroup|selector|specialSelector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
function wt.CreateRadiogroup(t, selector)
	t = type(t) == "table" and t or {}
	local selectorType = wt.IsWidget(selector)
	selector = (selectorType == "Selector" or selectorType == "SpecialSelector") and selector or wt.CreateSelector(t)

	if WidgetToolsDB.lite and t.lite ~= false then return selector end

	---@class selectorRadiobutton : selectorToggle, radiobutton

	local radiogroup
	if selectorType == "Selector" then --WATCH replace branching with a better solution to assign the right annotations
		---@class radiogroup : selector
		---@field frame Frame|table
		---@field label FontString|nil
		---@field toggles? selectorRadiobutton[] The list of radio button widgets linked together in this selector
		radiogroup = selector
	else
		---@class specialRadiogroup : specialSelector
		---@field frame Frame|table
		---@field label FontString|nil
		---@field toggles? selectorRadiobutton[] The list of radio button widgets linked together in this selector
		radiogroup = selector
	end

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Selector"
	---@return "Radiogroup"
	---<p></p>
	function radiogroup.getType() return "Selector", "Radiogroup" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function radiogroup.isType(type) return type == "Selector" or type == "Radiogroup" end

	--[ Properties ]

	local clearable = t.clearable

	--[ Frame Setup ]

	--| Shared setup

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Selector")
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Selector"

	setUpSelectorFrame(radiogroup, t, name, title)

	--| Radio button items

	---Set up or create new radio button item
	---@param item selectorToggle|selectorRadiobutton|checkbox|radiobutton|toggle
	---@param active boolean
	local function setRadioButton(item, active)
		if active and not us.IsFrame(item.frame) then
			local sameRow = (item.index - 1) % t.columns > 0

			wt.CreateRadiobutton({
				parent = radiogroup.frame,
				name = findName(name, item.index),
				title = t.items[item.index].title,
				label = t.labels,
				tooltip = t.items[item.index].tooltip,
				position = {
					relativeTo = item.index ~= 1 and radiogroup.toggles[sameRow and item.index - 1 or item.index - t.columns].frame or radiogroup.label,
					relativePoint = item.index > 1 and (sameRow and "TOPRIGHT" or "BOTTOMLEFT") or (radiogroup.label and "BOTTOMLEFT" or nil),
					offset = { x = radiogroup.label and item.index == 1 and -4 or 0, y = radiogroup.label and item.index == 1 and -2 or 0}
				},
				size = { w = (t.width and t.columns == 1) and t.width or nil, },
				clearable = clearable,
				events = { OnClick = function(_, _, button)
					if button == "LeftButton" then radiogroup.setSelected(item.index, true)
					elseif clearable and button == "RightButton" and not radiogroup.getSelected() then radiogroup.setSelected(nil, true) end
				end, },
				showDefault = false,
				utilityMenu = false,
			}, item)
		elseif active then
			--Update label
			if item.label then item.label:SetText(t.items[item.index].title) end

			--Update tooltip
			if type(t.items[item.index].tooltip) == "table" then wt.AddTooltip(item.frame, {
				title = type(t.items[item.index].tooltip.title) == "string" and t.items[item.index].tooltip.title or type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle",
				lines = t.items[item.index].tooltip.lines,
				anchor = "ANCHOR_NONE",
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = item.button,
					relativePoint = "TOPRIGHT",
				},
			}, { triggers = { item.button, }, }) end

			wt.SetVisibility(item.frame, true)
		else wt.SetVisibility(item.frame, false) end
	end

	--Set up current items
	for i = 1, #radiogroup.toggles do
		setRadioButton(radiogroup.toggles[i], true)

		--Handle item updates
		radiogroup.toggles[i].setListener._("activated", function(self, active) setRadioButton(self, active) end)
	end

	--Handle item list updates
	if radiogroup.setListener.updated and radiogroup.setListener.added then
		radiogroup.setListener.updated(function() radiogroup.frame:SetHeight(math.ceil((#radiogroup.toggles) / t.columns) * 18 + (t.label ~= false and 14 or 0)) end, 1)
		radiogroup.setListener.added(function (_, toggle)
			setRadioButton(toggle, true)

			--Handle item updates
			toggle.setListener._("activated", function(self, active) setRadioButton(self, active) end)
		end)
	end

	--[ Events ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(radiogroup.frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			local default = radiogroup.getDefault()
			defaultValue = crc(default and t.items[default].title or tostring(default), "FFFFFFFF")
		end

		local frames = { radiogroup.frame }
		for i = 1, #radiogroup.toggles do table.insert(frames, radiogroup.toggles[i].frame) end

		wt.AddWidgetTooltipLines(frames, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	local openTriggers = { {
		frame = radiogroup.frame,
		condition = radiogroup.isEnabled,
	}, }

	for i = 1, #radiogroup.toggles do table.insert(openTriggers, {
		frame = radiogroup.toggles[i].frame,
		condition = radiogroup.isEnabled,
	}) end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = openTriggers,
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.selection = { index = radiogroup.getSelected() } end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				radiogroup.setSelected(wt.clipboard.selection.index, true)
			end }):SetEnabled(wt.clipboard.selection ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() radiogroup.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() radiogroup.resetData() end }) end
		end
	}) end

	return radiogroup
end

---Create a dropdown radio button selector GUI frame to pick one out of multiple options with enhanced widget functionality
---***
---@param t? dropdownRadiogroupCreationData Optional parameters
---@param selector? selector Reference to an already existing selector to mutate into a radio selector instead of creating a new base widget
---***
---@return dropdownRadiogroup|selector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, a toggle [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table
function wt.CreateDropdownRadiogroup(t, selector)
	t = type(t) == "table" and t or {}
	selector = wt.IsWidget(selector) == "Selector" and selector or wt.CreateSelector(t)

	if WidgetToolsDB.lite and t.lite ~= false then return selector end

	--[ Properties ]

	local clearable = t.clearable

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Drorpdown")

	local holderFrame = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

	--| Position & dimensions

	t.width = t.width or 180
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(holderFrame, t.position) end
	wt.SetArrangementDirective(holderFrame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	holderFrame:SetSize(t.width + 4, 44)

	--| Visibility

	wt.SetVisibility(holderFrame, t.visible ~= false)

	if t.frameStrata then holderFrame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then holderFrame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then holderFrame:SetToplevel(t.keepOnTop) end

	--| Scroll

	t.scrollThreshold = t.scrollThreshold or 15

	--[ Dropdown Menu ]

	---@class dropdownRadiogroup : radiogroup
	---@field holderFrame Frame Main holder frame for the dropdown toggle, buttons and title
	---@field menu panel|Frame Panel frame holding the dropdown selector widget
	local dropdown = wt.CreateRadiogroup({
		name = name,
		append = false,
		label = false,
		width = t.width - (#t.items > t.scrollThreshold and 28 or 12),
		items = t.items,
		clearable = clearable,
		listeners = t.listeners,
		dependencies = t.dependencies,
		getData = t.getData,
		saveData = t.saveData,
		default = t.default,
		instantSave = t.instantSave,
		dataManagement = t.dataManagement,
		utilityMenu = false,
	}, selector)

	dropdown.holderFrame = holderFrame

	dropdown.menu = wt.CreatePanel({
		parent = UIParent,
		name = dropdown.frame:GetName() .. "Menu",
		label = false,
		position = {
			anchor = "TOP",
			relativeTo = dropdown.holderFrame,
			relativePoint = "BOTTOM",
			offset = { y = 3 }
		},
		visible = false,
		frameStrata = "DIALOG",
		keepInBound = true,
		background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
		border =  { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } },
		size = { w = t.width, h = 12 + min(#t.items, t.scrollThreshold) * dropdown.toggles[1].frame:GetHeight() },
	})

	dropdown.menu:SetClampedToScreen(true)

	dropdown.content = #t.items > t.scrollThreshold and wt.CreateScrollframe({
		parent = dropdown.menu,
		position = { anchor = "CENTER", },
		size = { w = dropdown.menu:GetWidth() - 12, h = dropdown.menu:GetHeight() - 12 },
		scrollSize = { h = dropdown.frame:GetHeight() },
		scrollSpeed = 0.38,
	}) or dropdown.menu

	dropdown.frame:SetParent(dropdown.content)
	wt.SetPosition(dropdown.frame, {
		relativeTo = dropdown.content,
		offset = #t.items <= t.scrollThreshold and { x = 6, y = -6 } or nil
	})

	--| Label

	local title = t.title or name or "Dropdown"

	dropdown.label = t.label ~= false and wt.CreateTitle(dropdown.holderFrame, {
		anchor = "TOP",
		offset = { y = -1, },
		text = title,
		font = "GameFontNormal",
	}) or nil

	--| Toggle button

	local open = false

	dropdown.toggle = wt.CreateCustomButton({
		parent = dropdown.holderFrame,
		name = "Toggle",
		append = t.append,
		title = "…",
		tooltip = { lines = {
			{ text = wt.strings.dropdown.selected, },
			{ text = "\n" .. wt.strings.dropdown.open, },
		} },
		position = { anchor = "BOTTOM", offset = { y = 2 }, },
		size = { w = t.width - (t.cycleButtons ~= false and 46 or 0), h = 24 },
		font = {
			normal = "GameFontNormal",
			highlight = "GameFontHighlight",
			disabled = "GameFontDisable",
		},
		backdrop = {
			background = {
				texture = {
					size = 5,
					insets = { l = 3, r = 3, t = 3, b = 3 },
				},
				color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
			},
			border = {
				texture = { width = 14, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
			}
		},
		backdropUpdates = {
			{ rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or (open and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					})
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					if open then return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.6, g = 0.6, b = 0.6, a = 0.9 } }
					} end
					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, _, button)
					if not frame:IsEnabled() or button == "LeftButton" then return {} end

					return (open and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					})
				end,
			}, },
			{
				triggers = { dropdown.holderFrame },
				rules = { OnAttributeChanged = function(frame, _, attribute, state)
					if not frame:IsEnabled() or attribute ~= "open" then return {} end

					if dropdown.toggle.widget:IsMouseOver() then return state and {
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} end
					return {}, true
				end, },
			},
		},
		events = clearable and t.utilityMenu == false and { OnMouseUp = function(_, button, isInside)
			if button == "RightButton" and isInside and dropdown.toggle.widget:IsEnabled() then dropdown.setText(nil, true) end
		end, } or nil,
		dependencies = t.dependencies
	})

	--| Cycle buttons

	local previousDependencies, nextDependencies

	if t.cycleButtons ~= false then

		--| Create a custom fonts

		wt.CreateFont("ChatFontGold", {
			template = "ChatFontNormal",
			color = wt.PackColor(GameFontNormal:GetTextColor()),
		})

		wt.CreateFont("ChatFontDisable", {
			template = "ChatFontNormal",
			color = wt.PackColor(GameFontDisable:GetTextColor()),
		})

		--| Previous item

		previousDependencies = { { frame = dropdown, evaluate = function(value)
			if not value then return true end
			return value > 1
		end }, }

		dropdown.previous = wt.CreateCustomButton({
			parent = dropdown.holderFrame,
			name = "SelectPrevious",
			title = "◄",
			titleOffset = { x = -1, },
			tooltip = {
				title = wt.strings.dropdown.previous.label,
				lines = { { text = wt.strings.dropdown.previous.tooltip, }, },
			},
			position = { anchor = "BOTTOMLEFT", offset = { x = 2, y = 2 }, },
			size = { w = 24, h = 24 },
			font = {
				normal = "ChatFontGold",
				highlight = "ChatFontNormal",
				disabled = "ChatFontDisable",
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function()
				local selected = dropdown.getSelected()

				dropdown.setSelected(selected and selected - 1 or #dropdown.toggles, true)
			end,
			dependencies = previousDependencies
		})

		--| Next item

		nextDependencies = { { frame = dropdown, evaluate = function(value)
			if not value then return true end
			return value < #t.items
		end }, }

		dropdown.next = wt.CreateCustomButton({
			parent = dropdown.holderFrame,
			name = "SelectNext",
			title = "►",
			titleOffset = { x = 1, },
			tooltip = {
				title = wt.strings.dropdown.next.label,
				lines = { { text = wt.strings.dropdown.next.tooltip, }, }
			},
			position = { anchor = "BOTTOMRIGHT", offset = { x = -2, y = 2 }, },
			size = { w = 24, h = 24 },
			font = {
				normal = "ChatFontGold",
				highlight = "ChatFontNormal",
				disabled = "ChatFontDisable",
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown("LeftButton") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function()
				local selected = dropdown.getSelected()

				dropdown.setSelected(selected and selected + 1 or 1, true)
			end,
			dependencies = nextDependencies
		})
	end

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Selector"
	---@return "Radiogroup"
	---@return "DropdownRadiogroup"
	---<p></p>
	function dropdown.getType() return "Selector", "Radiogroup", "DropdownRadiogroup" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function dropdown.isType(type) return type == "Selector" or type == "Radiogroup" or type == "DropdownRadiogroup" end

	---Set the text displayed on the label of the toggle button
	---***
	---@param text? string ***Default:*** **t.items[*index*].title** *(the title of the currently selected item)* or "…" *(if there is no selection)*
	---@param silent? boolean If false, invoke a "labeled" event and call registered listeners | ***Default:*** `false`
	function dropdown.setText(text, silent)
		local index = dropdown.getSelected()
		local item = t.items[index] or {}
		text = type(text) == "string" and text or item.title or "…"

		dropdown.toggle.label:SetText(text)
		wt.UpdateTooltipData(dropdown.toggle.frame, { title = text, })

		if not silent then dropdown.invoke._("labeled", text) end
	end

	---Toggle the dropdown menu
	---@param state? boolean ***Default:*** not **selector.list:IsVisible()**
	function dropdown.toggleMenu(state)
		if state == nil then open = not dropdown.menu:IsVisible() else open = state end

		wt.SetVisibility(dropdown.menu, open)

		if open then dropdown.menu:RegisterEvent("GLOBAL_MOUSE_DOWN") else dropdown.menu:UnregisterEvent("GLOBAL_MOUSE_UP") end

		dropdown.invoke._("open", open)
	end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then dropdown.holderFrame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else dropdown.holderFrame:HookScript(key, value) end
	end end

	--| UX

	us.SetListener(dropdown.menu, "GLOBAL_MOUSE_DOWN", function(f)
		if dropdown.toggle.widget:IsMouseOver() then return end

		f:UnregisterEvent("GLOBAL_MOUSE_DOWN")
		f:RegisterEvent("GLOBAL_MOUSE_UP")
	end)

	us.SetListener(dropdown.menu, "GLOBAL_MOUSE_UP", function(f, button)
		if (button ~= "LeftButton" and button ~= "RightButton") or f:IsMouseOver() then return end

		dropdown.toggleMenu(false)
	end, false)

	--Handle widget updates
	dropdown.toggle.setListener.trigger(function() dropdown.toggleMenu() end)
	dropdown.setListener.selected(function()
		dropdown.setText()

		if t.autoClose then dropdown.toggleMenu(false) end
	end, 1)
	dropdown.setListener._("open", function(state)
		dropdown.holderFrame:SetAttribute("open", state)
		if not state then PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF) end
	end)
	dropdown.setListener.updated(function(self) self.menu:SetHeight(#self.toggles * 18 + 12) end, 1) --TODO add size & scroll update

	--| Backdrop

	wt.SetBackdrop(dropdown.holderFrame, { background = {
		texture = { size = 5, },
		color = { r = 1, g = 1, b = 1, a = 0 }
	}, }, { {
		triggers = { dropdown.holderFrame, dropdown.toggle.frame, dropdown.previous.frame, dropdown.next.frame, },
		rules = {
			OnEnter = function() return dropdown.isEnabled() and { background = { color = { a = 0.1 } } } or {} end,
			OnLeave = "",
		},
	}, })

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(dropdown.holderFrame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			local default = dropdown.getDefault()
			defaultValue = crc(default and t.items[default].title or tostring(default), "FFFFFFFF")
		end

		wt.AddWidgetTooltipLines({ dropdown.holderFrame, dropdown.toggle.widget, dropdown.previous.widget, dropdown.next.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = dropdown.holderFrame,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.toggle.frame,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.previous.frame,
				condition = dropdown.isEnabled,
			},
			{
				frame = dropdown.next.frame,
				condition = dropdown.isEnabled,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.selection = { index = dropdown.getSelected() } end })
			if clearable then wt.CreateMenuButton(menu, { title = wt.strings.dropdown.clear, action = function() dropdown.setText(nil, true) end }) end
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				dropdown.setSelected(wt.clipboard.selection.index, true)
			end }):SetEnabled(wt.clipboard.selection ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() dropdown.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() dropdown.resetData() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		if dropdown.label then dropdown.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

		dropdown.toggle.setEnabled(state)

		if t.cycleButtons ~= false then
			dropdown.previous.setEnabled(state and wt.CheckDependencies(previousDependencies))
			dropdown.next.setEnabled(state and wt.CheckDependencies(nextDependencies))
		end

		dropdown.menu:Hide()
	end

	dropdown.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, dropdown.isEnabled())

	--Set up starting selection
	dropdown.setText(t.text, true)

	return dropdown
end

---Create a special radio button selector GUI frame to pick an Anchor Point, a horizontal or vertical text alignment or Frame Strata value with enhanced widget functionality
---***
---@param itemset SpecialSelectorItemset Specify what type of selector should be created
---@param t? specialRadiogroupCreationData Optional parameters
---@param selector? specialSelector|selector Reference to an already existing special selector widget to mutate into a special selector frame instead of creating a new base widget
---***
---@return specialSelector|specialRadiogroup # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
function wt.CreateSpecialRadiogroup(itemset, t, selector)
	t = type(t) == "table" and t or {}
	selector = wt.IsWidget(selector) == "SpecialSelector" and selector or wt.CreateSpecialSelector(itemset, t)

	if WidgetToolsDB.lite and t.lite ~= false then return selector end

	--[ Properties ]

	local showDefault = t.showDefault ~= false
	local utilityMenu = t.utilityMenu ~= false

	---@type specialRadiogroupCreationData|radiogroupCreationData
	t = us.Pull(t or {}, {
		labels = false,
		columns = itemset == "strata" and 8 or 3,
		showDefault = false,
		utilityMenu = false,
	})

	--[ Frame Setup ]

	---@type specialRadiogroup
	local radiogroup = wt.CreateRadiogroup(t, selector)

	--| Tooltip

	if type(t.tooltip) == "table" then
		local defaultValue
		if showDefault then defaultValue = crc(radiogroup.getDefault(), "FFFFFFFF") end

		local frames = { radiogroup.frame }
		for i = 1, #radiogroup.toggles do table.insert(frames, radiogroup.toggles[i].frame) end

		wt.AddWidgetTooltipLines(frames, defaultValue, utilityMenu)
	end

	--| Utility menu

	if utilityMenu then wt.CreateContextMenu({
		triggers = { {
			frame = radiogroup.frame,
			condition = radiogroup.isEnabled,
		}, },
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Selector" })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard[radiogroup.getItemset()] = { value = radiogroup.getSelected() } end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				radiogroup.setSelected(wt.clipboard[radiogroup.getItemset()].value, true)
			end }):SetEnabled(wt.clipboard[radiogroup.getItemset()] ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() radiogroup.revertData() end })
			if showDefault then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() radiogroup.resetData() end }) end
		end
	}) end

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "SpecialSelector"
	---@return "SpecialRadiogroup"
	---<p></p>
	function radiogroup.getType() return "SpecialSelector", "SpecialRadiogroup" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function radiogroup.isType(type) return type == "SpecialSelector" or type == "SpecialRadiogroup" end

	return radiogroup
end

---Create a checkbox selector GUI frame to pick multiple options out of a list with enhanced widget functionality
---***
---@param t? checkgroupCreationData Optional parameters
---@param selector? multiselector Reference to an already existing selector to mutate into a multiple selector instead of creating a new base widget
---***
---@return checkgroup|multiselector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
function wt.CreateCheckgroup(t, selector)
	t = type(t) == "table" and t or {}
	selector = wt.IsWidget(selector) == "Multiselector" and selector or wt.CreateMultiselector(t)

	if WidgetToolsDB.lite and t.lite ~= false then return selector end

	---@class selectorCheckbox : selectorToggle, checkbox

	---@class checkgroup : multiselector
	---@field frame Frame|table
	---@field label FontString|nil
	---@field toggles? selectorCheckbox[] The list of checkbox widgets linked together in this selector
	local checkgroup = selector

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Multiselector"
	---@return "Checkgroup"
	---<p></p>
	function checkgroup.getType() return "Multiselector", "Checkgroup" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function checkgroup.isType(type) return type == "Multiselector" or type == "Checkgroup" end

	--[ Frame Setup ]

	--| Shared setup

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Selector")
	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Selector"

	setUpSelectorFrame(checkgroup, t, name, title)

	--| Checkbox items

	---Update the lock state of a checkbox item
	---@param item selectorCheckbox
	---@param limited boolean
	local function setLock(item, limited)
		if limited then
			item.setEnabled(false, true)
			item.button:SetAlpha(0.4)
		elseif checkgroup.isEnabled() then
			item.setEnabled(true, true)
			item.button:SetAlpha(1)
		end
	end

	---Set up or create new checkbox item
	---@param item selectorToggle|selectorCheckbox|checkbox|radiobutton|toggle
	---@param active boolean
	local function setCheckbox(item, active)
		if active and not item.frame then
			local sameRow = (item.index - 1) % t.columns > 0

			wt.CreateClassicCheckbox({
				parent = checkgroup.frame,
				name = findName(name, item.index),
				title = t.items[item.index].title,
				label = t.labels,
				tooltip = t.items[item.index].tooltip,
				position = {
					relativeTo = item.index ~= 1 and checkgroup.toggles[sameRow and item.index - 1 or item.index - t.columns].frame or checkgroup.label,
					relativePoint = sameRow and "TOPRIGHT" or "BOTTOMLEFT",
					offset = { x = checkgroup.label and item.index == 1 and -4 or 0, y = checkgroup.label and item.index == 1 and -2 or 0}
				},
				size = { w = (t.width and t.columns == 1) and t.width or 160, h = 16 },
				events = { OnClick = function(self) checkgroup.setSelected(item.index, self:GetChecked(), true) end, },
				showDefault = false,
				utilityMenu = false,
			}, item)

			if item.label then item.label:SetIgnoreParentAlpha(true) end

			--Handle limit updates
			checkgroup.setListener.limited(function(_, min, max)
				local state = item.getState()

				setLock(item, (min and state) or (max and not state))
			end, item.index)
		elseif active then
			--Update label
			if item.label then item.label:SetText(t.items[item.index].title) end

			--Update tooltip
			if type(t.items[item.index].tooltip) == "table" then wt.AddTooltip(item.frame, {
				title = type(t.items[item.index].tooltip.title) == "string" and t.items[item.index].tooltip.title or type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Toggle",
				lines = t.items[item.index].tooltip.lines,
				anchor = "ANCHOR_NONE",
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = item.button,
					relativePoint = "TOPRIGHT",
				},
			}, { triggers = { item.button, }, }) end
		else wt.SetVisibility(item.frame, false) end
	end

	--Set up starting items
	for i = 1, #checkgroup.toggles do
		setCheckbox(checkgroup.toggles[i], true)

		--Handle item updates
		checkgroup.toggles[i].setListener._("activated", function(self, active) setCheckbox(self, active) end)
	end

	--Handle item list updates
	checkgroup.setListener.updated(function() checkgroup.frame:SetHeight(math.ceil((#checkgroup.toggles) / t.columns) * 16 + (t.label ~= false and 14 or 0)) end, 1)
	checkgroup.setListener.added(function (_, toggle)
		setCheckbox(toggle, true)

		--Handle item updates
		toggle.setListener._("activated", function(self, active) setCheckbox(self, active) end)
	end)

	--[ Events ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(checkgroup.frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			defaultValue = ""
			local default = checkgroup.getDefault()

			for i = 1, #t.items do
				defaultValue = defaultValue .. "\n" .. crc(t.items[i].title, "FFFFFFFF") .. crc(": ", "FF999999") .. crc(
					(default[i] and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), default[i] and "FFAAAAFF" or "FFFFAA66"
				)
			end
		end

		local frames = { checkgroup.frame }
		for i = 1, #checkgroup.toggles do table.insert(frames, checkgroup.toggles[i].frame) end

		wt.AddWidgetTooltipLines(frames, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	local openTriggers = { {
		frame = checkgroup.frame,
		condition = checkgroup.isEnabled,
	}, }

	for i = 1, #checkgroup.toggles do table.insert(openTriggers, {
		frame = checkgroup.toggles[i].button,
		condition = checkgroup.isEnabled,
	}) end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = openTriggers,
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.selections = { states = checkgroup.getSelections() } end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				checkgroup.setSelections(wt.clipboard.selections.states, true)
			end }):SetEnabled(wt.clipboard.selections ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() checkgroup.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() checkgroup.resetData() end }) end
		end
	}) end

	return checkgroup
end

--[ Textbox ]

---Create a non-GUI textbox widget with string data management logic
---***
---@param t? textboxCreationData Optional parameters
---***
---@return textbox textbox Reference to the new textbox widget, utility functions and more wrapped in a table
function wt.CreateTextbox(t)
	t = type(t) == "table" and t or {}

	--[ Wrapper table ]

	---@class textbox
	local textbox = {}

	--[ Properties ]

	--| Data

	t.default = type(t.default) == "string" and t.default or ""
	local default = t.default
	local value = type(t.value) == "string" and t.value or type(t.getData) == "function" and t.getData() or nil
	value = type(value) == "string" and value or default
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "Textbox"
	---<p></p>
	function textbox.getType() return "Textbox" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function textbox.isType(type) return type == "Textbox" end

	--| Event handling

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	textbox.invoke = {
		enabled = function() callListeners(textbox, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(textbox, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(textbox, listeners, "saved", success) end,

		---@param user boolean
		changed = function(user) callListeners(textbox, listeners, "changed", value, user) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(textbox, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	textbox.setListener = {
		---@param listener TextboxEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener TextboxEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener TextboxEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener TextboxEventHandler_changed Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		changed = function(listener, callIndex) addListener(listeners, "changed", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener TextboxEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function textbox.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			textbox.setText(t.getData(), handleChanges, silent)

			if not silent then textbox.invoke.loaded(true) end
		else
			if handleChanges and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then textbox.invoke.loaded(false) end
		end
	end

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param text? string Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
	function textbox.saveData(text, silent)
		if type(t.saveData) == "function" then
			t.saveData(type(text) == "string" and text or value)

			if not silent then textbox.invoke.saved(true) end
		elseif not silent then textbox.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return string|nil
	function textbox.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param text? string Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function textbox.setData(text, handleChanges, silent)
		textbox.saveData(text, silent)
		textbox.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return string default
	function textbox.getDefault() return default end

	---Set the default value
	---@param text string | ***Default:*** `""`
	function textbox.setDefault(text) default = type(text) == "string" and text or "" end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **textbox.snapshotData()**
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function textbox.revertData(handleChanges, silent) textbox.setData(snapshot, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **textbox.revertData()**
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function textbox.snapshotData(stored) snapshot = stored and textbox.getData() or value end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function textbox.resetData(handleChanges, silent) textbox.setData(default, handleChanges, silent) end

	---Returns the current text value of the widget
	---@return string
	function textbox.getText() return value end

	---Set the text value of the widget
	---***
	---@param text? string ***Default:*** ""
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
	function textbox.setText(text, user, silent)
		value = type(text) == "string" and text or ""

		if not silent then textbox.invoke.changed(user == true) end

		if user and t.instantSave ~= false then textbox.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| State & dependencies

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function textbox.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
	function textbox.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then textbox.invoke.enabled() end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then textbox.setListener._(v[i].event, v[i].handler, v[i].callIndex) else textbox.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(textbox, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, textbox.setEnabled) end

	--Set starting value
	textbox.setText(t.color and cr(value, t.color) or value, false, true)

	return textbox
end

--| GUI

---Set the parameters of a GUI textbox widget frame
---@param editbox customEditbox|customEditbox|multilineEditbox
---@param t editboxCreationData
local function setUpEditboxFrame(editbox, t)

	--[ Frame Setup ]

	--| Visibility

	wt.SetVisibility(editbox.frame, t.visible ~= false)

	if t.frameStrata then editbox.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then editbox.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then editbox.frame:SetToplevel(t.keepOnTop) end

	--[ Font & Text ]

	t.font = t.font or {}
	t.insets = t.insets or {}
	t.insets = { l = t.insets.l or 0, r = t.insets.r or 0, t = t.insets.t or 0, b = t.insets.b or 0 }

	editbox.widget:SetTextInsets(t.insets.l, t.insets.r, t.insets.t, t.insets.b)

	if t.font.normal then editbox.widget:SetFontObject(t.font.normal) end

	if t.justify then
		if t.justify.h then editbox.widget:SetJustifyH(t.justify.h) end
		if t.justify.v then editbox.widget:SetJustifyV(t.justify.v) end
	end

	if t.charLimit then editbox.widget:SetMaxLetters(t.charLimit) end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then editbox.widget:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		elseif key == "OnChar" then editbox.widget:SetScript("OnChar", function(self, char) value(self, char, self:GetText()) end)
		elseif key == "OnTextChanged" then editbox.widget:SetScript("OnTextChanged", function(self, user) value(self, self:GetText(), user) end)
		elseif key == "OnEnterPressed" then editbox.widget:SetScript("OnEnterPressed", function(self) value(self, self:GetText()) end)
		else editbox.widget:HookScript(key, value) end
	end end

	--| UX

	local scriptEvent = false

	---Update the widget UI based on the text value
	---@param _ any
	---@param text string
	local function updateText(_, text) if not scriptEvent then
		editbox.widget:SetText(text)

		if t.resetCursor ~= false then editbox.widget:SetCursorPosition(0) end
	else scriptEvent = false end end

	--Handle widget updates
	editbox.setListener.changed(updateText, 1)

	--Link value changes
	editbox.widget:HookScript("OnTextChanged", function(self, user)
		scriptEvent = true

		editbox.setText(self:GetText(), user)
	end)

	editbox.widget:SetAutoFocus(t.keepFocused)

	if t.focusOnShow then editbox.widget:HookScript("OnShow", function(self) self:SetFocus() end) end

	if t.unfocusOnEnter ~= false then editbox.widget:HookScript("OnEnterPressed", function(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

		self:ClearFocus()
	end) end

	editbox.widget:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)

	editbox.widget:HookScript("OnEnter", function(self) if editbox.isEnabled() and t.font.highlight then self:SetFontObject(t.font.highlight) end end)
	editbox.widget:HookScript("OnLeave", function(self) if editbox.isEnabled() and t.font.normal then self:SetFontObject(t.font.normal) end end)

	--| State

	--Inherit setter
	editbox.widget.setEnabled = editbox.setEnabled

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		if t.readOnly then editbox.widget:Disable() else editbox.widget:SetEnabled(state) end

		if state then
			if editbox.widget:IsMouseOver() and t.font.highlight then editbox.widget:SetFontObject(t.font.highlight)
			elseif t.font.normal then editbox.widget:SetFontObject(t.font.normal) end
		elseif t.font.disabled then editbox.widget:SetFontObject(t.font.disabled) end

		if editbox.label then editbox.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
	end

	--Handle widget updates
	editbox.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, editbox.isEnabled())

	--Set up starting text
	updateText(nil, editbox.getText())
end

---Set the parameters of a single-line GUI textbox widget frame
---@param editbox customEditbox|customEditbox
---@param title string
---@param t editboxCreationData
local function setUpEditbox(editbox, title, t)

	--Set as single line
	editbox.widget:SetMultiLine(false)

	--| Position

	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(editbox.frame, t.position) end
	wt.SetArrangementDirective(editbox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	editbox.widget:SetPoint("BOTTOMRIGHT")

	--| Shared setup

	setUpEditboxFrame(editbox, t)

	--[ Events ]

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(editbox.widget, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(editbox.getDefault(), "FF55DD55") end

		wt.AddWidgetTooltipLines({ editbox.frame, editbox.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = { {
			frame = editbox.widget,
			condition = function() return editbox.isEnabled() and not t.readOnly end,
		}, },
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.text = editbox.getText() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				editbox.setText(wt.clipboard.text, true)
			end }):SetEnabled(wt.clipboard.text ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() editbox.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() editbox.resetData() end }) end
		end
	}) end
end

---Create a default single-line Blizzard editbox GUI frame with enhanced widget functionality
---***
---@param t? editboxCreationData Optional parameters
---@param textbox? textbox Reference to an already existing textbox to mutate into an editbox instead of creating a new base widget
---***
---@return customEditbox|textbox # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateEditbox(t, textbox)
	t = type(t) == "table" and t or {}
	textbox = wt.IsWidget(textbox) == "Textbox" and textbox or wt.CreateTextbox(t)

	if WidgetToolsDB.lite and t.lite ~= false then return textbox end

	---@class customEditbox : textbox
	local editbox = textbox

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Textbox"
	---@return "Editbox"
	---<p></p>
	function editbox.getType() return "Textbox", "Editbox" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function editbox.isType(type) return type == "Textbox" or type == "Editbox" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Textbox")

	editbox.frame = CreateFrame("Frame", name, t.parent)
	editbox.widget = CreateFrame("EditBox", name .. "EditBox", editbox.frame, "InputBoxTemplate")

	--| Dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 18

	editbox.frame:SetSize(t.size.w, t.size.h + (t.label ~= false and 18 or 0))
	editbox.widget:SetSize(t.size.w - 6, t.size.h - 1)

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Textbox"

	editbox.label = t.label ~= false and wt.CreateTitle(editbox.frame, {
		offset = { x = -1, },
		text = title,
	}) or nil

	--| Shared setup

	setUpEditbox(editbox, title, t)

	return editbox
end

---Create a single-line Blizzard editbox frame with custom GUI and enhanced widget functionality
---***
---@param t? customEditboxCreationData Optional parameters
---@param textbox? textbox Reference to an already existing textbox to mutate into a customizable editbox instead of creating a new base widget
---***
---@return customEditbox|textbox # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateCustomEditbox(t, textbox)
	t = type(t) == "table" and t or {}
	textbox = wt.IsWidget(textbox) == "Textbox" and textbox or wt.CreateTextbox(t)

	if WidgetToolsDB.lite and t.lite ~= false then return textbox end

	---@class customEditbox : textbox
	local editbox = textbox

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Textbox"
	---@return "CustomEditbox"
	---<p></p>
	function editbox.getType() return "Textbox", "CustomEditbox" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function editbox.isType(type) return type == "Textbox" or type == "CustomEditbox" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Textbox")

	editbox.frame = CreateFrame("Frame", name, t.parent)
	editbox.widget = CreateFrame("EditBox", name .. "EditBox", editbox.frame, BackdropTemplateMixin and "BackdropTemplate")

	--| Dimensions

	t.size = t.size or {}
	t.size.w = t.size.w or 180
	t.size.h = t.size.h or 18

	editbox.frame:SetSize(t.size.w, t.size.h - (t.label ~= false and -18 or 0))
	editbox.widget:SetSize(t.size.w, t.size.h)

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Textbox"

	editbox.label = t.label ~= false and wt.CreateTitle(editbox.frame, {
		offset = { x = -1, },
		text = title,
	}) or nil

	--| Backdrop

	wt.SetBackdrop(editbox.widget, t.backdrop, t.backdropUpdates)

	--| Shared setup

	setUpEditbox(editbox, title, t)

	--[ Events ]

	--| UX

	editbox.widget:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
	editbox.widget:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)

	return editbox
end

---Create a default multiline Blizzard editbox GUI frame with enhanced widget functionality
---***
---@param t? multilineEditboxCreationData Optional parameters
---@param textbox? textbox Reference to an already existing textbox to mutate into a multiline editbox instead of creating a new base widget
---***
---@return multilineEditbox|textbox # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateMultilineEditbox(t, textbox)
	t = type(t) == "table" and t or {}
	textbox = wt.IsWidget(textbox) == "Textbox" and textbox or wt.CreateTextbox(t)

	if WidgetToolsDB.lite and t.lite ~= false then return textbox end

	---@class multilineEditbox : textbox
	local editbox = textbox

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Textbox"
	---@return "MultilineEditbox"
	---<p></p>
	function editbox.getType() return "Textbox", "MultilineEditbox" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function editbox.isType(type) return type == "Textbox" or type == "MultilineEditbox" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Textbox")

	editbox.frame = CreateFrame("Frame", name, t.parent)
	editbox.scrollframe = CreateFrame("ScrollFrame", name .. "ScrollFrame", editbox.frame, ScrollControllerMixin and "InputScrollFrameTemplate")

	---@type EditBox|nil
	editbox.widget = editbox.scrollframe.EditBox

	--Set as multiline
	editbox.widget:SetMultiLine(true)

	--| Position & dimensions

	local scrollframeHeight = t.size.h - (t.label ~= false and 28 or 10)
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(editbox.frame, t.position) end
	wt.SetArrangementDirective(editbox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	editbox.scrollframe:SetPoint("BOTTOM", 0, 5)
	wt.SetPosition(editbox.scrollframe.ScrollBar, {
		anchor = "RIGHT",
		relativeTo = editbox.scrollframe,
		relativePoint = "RIGHT",
		offset = { x = -4, y = 0 }
	})

	editbox.frame:SetSize(t.size.w, t.size.h)
	editbox.scrollframe:SetSize(t.size.w - 10, scrollframeHeight)
	editbox.scrollframe.ScrollBar:SetHeight(scrollframeHeight - 4)
	editbox.scrollframe.EditBox:SetWidth(editbox.scrollframe:GetWidth())

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Textbox"

	editbox.label = t.label ~= false and wt.CreateTitle(editbox.frame, {
		offset = { x = 3, },
		text = title,
	}) or nil

	--| Scroll speed

	t.scrollSpeed = t.scrollSpeed or 0.25

	editbox.scrollframe.ScrollBar.SetPanExtentPercentage = function() --WATCH: Change when Blizzard provides a better way to overriding the built-in update function
		local height = editbox.scrollframe:GetHeight()

		editbox.scrollframe.ScrollBar.panExtentPercentage = height * t.scrollSpeed / math.abs(editbox.widget:GetHeight() - height)
	end

	--| Character counter

	editbox.scrollframe.CharCount:SetFontObject("GameFontDisableTiny2")
	if t.charCount == false or (t.charLimit or 0) == 0 then editbox.scrollframe.CharCount:Hide() end

	---@diagnostic disable-next-line: inject-field
	editbox.widget.cursorOffset = 0 --WATCH: Remove when the character counter gets fixed..

	--| Shared setup

	setUpEditboxFrame(editbox, t)

	--[ Events ]

	--| UX

	editbox.widget:HookScript("OnTextChanged", function(_, _, user) if not user and t.scrollToTop then editbox.scrollframe:SetVerticalScroll(0) end end)
	editbox.widget:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
	editbox.widget:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)

	---Update the width of the editbox
	---@param scrolling boolean
	local function resizeEditbox(scrolling)
		local scrollBarOffset = scrolling and (wt.classic and 32 or 16) or 0
		local charCountWidth = t.charCount ~= false and (t.charLimit or 0) > 0 and tostring(t.charLimit - editbox.getText():len()):len() * 6 + 3 or 0

		editbox.widget:SetWidth(editbox.scrollframe:GetWidth() - scrollBarOffset - charCountWidth)

		--Update the character counter
		if editbox.scrollframe.CharCount:IsVisible() and t.charLimit then --WATCH: Remove when the character counter gets fixed..
			editbox.scrollframe.CharCount:SetWidth(charCountWidth)
			editbox.scrollframe.CharCount:SetText(t.charLimit - editbox.getText():len())
			editbox.scrollframe.CharCount:SetPoint("BOTTOMRIGHT", editbox.scrollframe, "BOTTOMRIGHT", -scrollBarOffset + 1, 0)
		end
	end

	--Resize updates
	editbox.scrollframe.ScrollBar:HookScript("OnShow", function() resizeEditbox(true) end)
	editbox.scrollframe.ScrollBar:HookScript("OnHide", function() resizeEditbox(false) end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(editbox.scrollframe, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { editbox.frame, editbox.widget }, })

		if t.readOnly ~= true then
			local defaultValue
			if t.showDefault ~= false then defaultValue = crc(editbox.getDefault(), "FF55DD55") end

			wt.AddWidgetTooltipLines({ editbox.scrollframe, editbox.widget }, defaultValue, t.utilityMenu)
		end
	end

	--| Utility menu

	---Utility menu opening condition checker
	---@return boolean
	local function openCondition() return editbox.isEnabled() and not t.readOnly end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = editbox.frame,
				condition = openCondition,
			},
			{
				frame = editbox.widget,
				condition = openCondition,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.text = editbox.getText() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				editbox.setText(wt.clipboard.text, true)
			end }):SetEnabled(wt.clipboard.text ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() editbox.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() editbox.resetData() end }) end
		end
	}) end

	return editbox
end

---Create a custom button with a toggled textline & editbox from which text can be copied
---***
---@param t? copyboxCreationData Optional parameters
---***
---@return copybox copybox References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), its child widgets & their custom values, utility functions and more wrapped in a table
function wt.CreateCopybox(t)
	t = type(t) == "table" and t or {}
	local text = type(t.value) == "string" and t.value or ""

	---@class copybox
	local copybox = {}

	--[ GUI Widget ]

	if not WidgetToolsDB.lite or t.lite == false then

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Copybox")

		copybox.frame = CreateFrame("Frame", name, t.parent)

		--| Position & dimensions

		t.size = t.size or {}
		t.size.w = t.size.w or 180
		t.size.h = t.size.h or 18
		local arrange = type(t.arrange) == "table" and t.arrange or {}

		if not t.arrange and t.position then wt.SetPosition(copybox.frame, t.position) end
		wt.SetArrangementDirective(copybox.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

		copybox.frame:SetSize(t.size.w, t.size.h + (t.label ~= false and 12 or 0))

		--| Visibility

		wt.SetVisibility(copybox.frame, t.visible ~= false)

		if t.frameStrata then copybox.frame:SetFrameStrata(t.frameStrata) end
		if t.frameLevel then copybox.frame:SetFrameLevel(t.frameLevel) end
		if t.keepOnTop then copybox.frame:SetToplevel(t.keepOnTop) end

		--| Label

		local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Copybox"

		copybox.label = t.label ~= false and wt.CreateTitle(copybox.frame, {
			offset = { x = -1, },
			width = t.size.w,
			text = title,
			font = "GameFontNormal",
		}) or nil

		--| Textbox

		t.font = t.font or "GameFontNormalSmall"
		t.color = t.color or { r = 0.6, g = 0.8, b = 1, a = 1 }
		t.colorOnMouse = t.colorOnMouse or { r = 0.8, g = 0.95, b = 1, a = 1 }

		copybox.textbox = wt.CreateCustomEditbox({
			parent = copybox.frame,
			name = "Textline",
			title = title,
			label = false,
			tooltip = { lines = { { text = wt.strings.copyBox, }, } },
			position = { anchor = "BOTTOMLEFT", },
			size = t.size,
			font = { normal = t.font, disabled = t.font },
			color = t.color,
			justify = { h = t.justify, },
			events = {
				OnTextChanged = function(self, _, user)
					if not user then return end

					self:SetText(cr(text, t.colorOnMouse))
					self:SetCursorPosition(0)
					self:HighlightText()
				end,
				OnEnter = function(self)
					self:SetText(cr(text, t.colorOnMouse))
					self:SetCursorPosition(0)
					self:HighlightText()
					self:SetFocus()
				end,
				OnLeave = function(self)
					self:SetText(cr(text, t.color))
					self:SetCursorPosition(0)
					self:ClearHighlightText()
					self:ClearFocus()
				end,
				OnMouseUp = function(self)
					self:SetCursorPosition(0)
					self:HighlightText()
				end,
			},
			value = text,
			showDefault = false,
			utilityMenu = false,
		})
	end

	return copybox
end

--[ Numeric ]

---Create a non-GUI numeric widget with number data management logic
---***
---@param t? numericCreationData Optional parameters
---***
---@return numeric numeric Reference to the new numeric widget, utility functions and more wrapped in a table
function wt.CreateNumeric(t)
	t = type(t) == "table" and t or {}

	--[ Wrapper table ]

	---@class numeric
	local numeric = {}

	--[ Properties ]

	local limitMin = type(t.min) == "number" and t.min or 0
	local limitMax = type(t.max) == "number" and t.max or 100
	local step = max(type(t.step) == "number" and t.step or ((limitMin - limitMax) / 10), 0)
	local altStep = type(t.altStep) == "number" and max(t.altStep, 0) or nil
	local hardStep = t.hardStep ~= false

	--| Data

	local default = limitMin

	---Data verification utility
	---@param v any
	---@return number
	local function verify(v)
		v = type(v) == "number" and v or default

		if hardStep then v = limitMin + floor((v - limitMin) / step + 0.5) * step end

		return Clamp(v, limitMin, limitMax)
	end

	default = verify(t.default)
	local value = verify(t.value or type(t.getData) == "function" and t.getData() or nil)
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "Numeric"
	---<p></p>
	function numeric.getType() return "Numeric" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function numeric.isType(type) return type == "Numeric" end

	--| Event handling

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	numeric.invoke = {
		enabled = function() callListeners(numeric, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(numeric, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(numeric, listeners, "saved", success) end,

		---@param user boolean
		changed = function(user) callListeners(numeric, listeners, "changed", value, user) end,

		min = function() callListeners(numeric, listeners, "min", limitMin) end,

		max = function() callListeners(numeric, listeners, "max", limitMax) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(numeric, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	numeric.setListener = {
		---@param listener NumericEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener NumericEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener NumericEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener NumericEventHandler_changed Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		changed = function(listener, callIndex) addListener(listeners, "changed", listener, callIndex) end,

		---@param listener NumericEventHandler_min Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		min = function(listener, callIndex) addListener(listeners, "min", listener, callIndex) end,

		---@param listener NumericEventHandler_max Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		max = function(listener, callIndex) addListener(listeners, "max", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener NumericEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function numeric.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			numeric.setNumber(t.getData(), handleChanges, silent)

			if not silent then numeric.invoke.loaded(true) end
		else
			if handleChanges and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then numeric.invoke.loaded(false) end
		end
	end

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param number? number Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
	function numeric.saveData(number, silent)
		if type(t.saveData) == "function" then
			t.saveData(number and verify(number) or value)

			if not silent then numeric.invoke.saved(true) end
		elseif not silent then numeric.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return number|nil
	function numeric.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param number? number Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function numeric.setData(number, handleChanges, silent)
		numeric.saveData(number, silent)
		numeric.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return number default
	function numeric.getDefault() return default end

	---Set the default value
	---@param number number | ***Default:*** *no change*
	function numeric.setDefault(number) default = verify(number) end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **numeric.snapshotData()**
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function numeric.revertData(handleChanges, silent) numeric.setData(snapshot, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **numeric.revertData()**
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function numeric.snapshotData(stored) snapshot = stored and numeric.getData() or value end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function numeric.resetData(handleChanges, silent) numeric.setData(default, handleChanges, silent) end

	---Returns the current value of the widget
	---@return number
	function numeric.getNumber() return value end

	---Set the value of the widget
	---***
	---@param number? number A valid number value within the specified **t.min**, **t.max** range | ***Default:*** **t.min**
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	function numeric.setNumber(number, user, silent)
		value = verify(number)

		if not silent then numeric.invoke.changed(user == true) end

		if user and t.instantSave ~= false then numeric.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	---Decrease the value of the widget by the specified step or alt step amount
	---@param alt? boolean If true, use alt step instead of step to decrease the value by | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
	function numeric.decrease(alt, user, silent) numeric.setNumber(value - (alt and altStep or step), user, silent) end

	---Increase the value of the widget by the specified step or alt step amount
	---@param alt? boolean If true, use alt step instead of step to increase the value by | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
	function numeric.increase(alt, user, silent) numeric.setNumber(value + (alt and altStep or step), user, silent) end

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function numeric.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
	function numeric.setEnabled(state, silent)
		enabled = state ~= false

		if not silent then numeric.invoke.enabled() end
	end

	--| Value limits

	---Return the current lower value limit of the widget
	---@return number
	function numeric.getMin() return limitMin end

	---Set the lower value limit of the widget
	---***
	---@param number number Updates the lower limit value | ***Range:*** (any, *current upper limit*) *capped automatically*
	---@param silent? boolean If false, invoke a "min" event and call registered listeners | ***Default:*** `false`
	function numeric.setMin(number, silent)
		limitMin = min(number, limitMax)

		if not silent then numeric.invoke.min() end
	end

	---Return the current upper value limit of the widget
	---@return number
	function numeric.getMax() return limitMax end

	---Set the upper value limit of the widget
	---***
	---@param number number Updates the upper limit value | ***Range:*** (*current lower limit*, any) *floored automatically*
	---@param silent? boolean If false, invoke a "max" event and call registered listeners | ***Default:*** `false`
	function numeric.setMax(number, silent)
		limitMax = max(limitMin, number)

		if not silent then numeric.invoke.max() end
	end

	--| Value step

	---Return the current value step of the widget
	---@return number
	function numeric.getStep() return step end

	---Return the current alternative value step of the widget
	---@return number|nil
	function numeric.getAltStep() return altStep end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then numeric.setListener._(v[i].event, v[i].handler, v[i].callIndex) else numeric.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(numeric, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, numeric.setEnabled) end

	--Set starting value
	numeric.setNumber(value, false, true)

	return numeric
end

--| GUI

---Create a Blizzard slider GUI frame with enhanced widget functionality
---***
---@param t? sliderCreationData Optional parameters
---@param numeric? numeric Reference to an already existing numeric widget to mutate into a slider instead of creating a new base widget
---***
---@return customSlider|numeric # References to the new [Slider](https://warcraft.wiki.gg/wiki/UIOBJECT_Slider), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), child widgets, utility functions and more wrapped in a table
function wt.CreateSlider(t, numeric)
	t = type(t) == "table" and t or {}
	numeric = wt.IsWidget(numeric) == "Numeric" and numeric or wt.CreateNumeric(t)

	if WidgetToolsDB.lite and t.lite ~= false then return numeric end

	---@class customSlider : numeric
	local slider = numeric

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Numeric"
	---@return "Slider"
	---<p></p>
	function slider.getType() return "Numeric", "Slider" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function slider.isType(type) return type == "Numeric" or type == "Slider" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Slider")

	slider.frame = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

	---@class blizzardSlider : Frame
	---@field Slider Slider Main slider frame
	---@field Back Button Decrease value button
	---@field Forward Button Increase value button
	---@field TopText FontString Title text
	---@field MinText FontString Min value text
	---@field MaxText FontString Max value text
	slider.widget = CreateFrame("Slider", name .. "Frame", slider.frame, "MinimalSliderWithSteppersTemplate")

	--| Position & dimensions

	t.width = t.width or 180
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(slider.frame, t.position) end
	wt.SetArrangementDirective(slider.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	slider.widget:SetPoint("TOP", 0, -8)

	slider.frame:SetSize(t.width, t.valuebox ~= false and 64 or 52)
	slider.widget:SetWidth(t.width)

	--| Visibility

	wt.SetVisibility(slider.frame, t.visible ~= false)

	if t.frameStrata then slider.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then slider.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then slider.frame:SetToplevel(t.keepOnTop) end

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Slider"

	if t.label ~= false then
		slider.widget.TopText:SetPoint("TOP", slider.frame, "TOP", 0, 4)
		slider.widget.TopText:SetText(title)
		slider.widget.TopText:Show()
	end

	slider.widget.MinText:Show()
	slider.widget.MaxText:Show()

	--| Value step

	if t.hardStep ~= false then
		slider.widget.Slider:SetValueStep(slider.getStep())
		slider.widget.Slider:SetObeyStepOnDrag(true)
	end

	--| Decrease button

	wt.AddTooltip(slider.widget.Back, {
		title = wt.strings.slider.decrease.label,
		lines = {
			{ text = wt.strings.slider.decrease.tooltip[1]:gsub("#VALUE", slider.getStep()), },
			slider.getAltStep() and { text = wt.strings.slider.decrease.tooltip[2]:gsub("#VALUE", slider.getAltStep()), } or nil,
		},
		anchor = "ANCHOR_TOPLEFT",
	})

	slider.widget.Back:HookScript("OnClick", function() slider.decrease(IsAltKeyDown(), true) end)

	--| Increase button

	wt.AddTooltip(slider.widget.Forward, {
		title = wt.strings.slider.increase.label,
		lines = {
			{ text = wt.strings.slider.increase.tooltip[1]:gsub("#VALUE", slider.getStep()), },
			slider.getAltStep() and { text = wt.strings.slider.increase.tooltip[2]:gsub("#VALUE", slider.getAltStep()), } or nil,
		},
		anchor = "ANCHOR_TOPLEFT",
	})

	slider.widget.Forward:HookScript("OnClick", function() slider.increase(IsAltKeyDown(), true) end)

	--| Valuebox

	local minValue, maxValue = slider.getMin(), slider.getMax()

	if t.valuebox ~= false then

		--| Calculate the required number of fractal digits, assemble string patterns for value validation

		local decimals = type(t.fractional) == "number" and floor(t.fractional + 0.5) or max(
			(tostring(minValue):match("%.(%d+)") or ""):len(),
			(tostring(maxValue):match("%.(%d+)") or ""):len(),
			(tostring(slider.getStep()):match("%.(%d+)") or ""):len()
		)
		local decimalPattern = ""
		for _ = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end
		local matchPattern = "(" .. (minValue < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
		local replacePattern = "%1" .. (decimals > 0 and "%2" or "")

		--| Frame setup

		slider.valuebox = wt.CreateCustomEditbox({
			parent = slider.frame,
			name = "Valuebox",
			label = false,
			tooltip = {
				title = wt.strings.slider.value.label,
				lines = { { text = wt.strings.slider.value.tooltip, }, }
			},
			position = {
				anchor = "TOP",
				offset = { y = 6 },
				relativeTo = slider.widget.Slider,
				relativePoint = "BOTTOM",
			},
			size = { w = 80, h = 20 },
			font = {
				normal = "GameFontNormalSmall2",
				highlight = "GameFontHighlightSmall2",
				disabled = "GameFontDisableSmall2",
			},
			justify = { h = "CENTER", },
			charLimit = max(tostring(math.floor(slider.getStep())):len(), tostring(math.floor(minValue)):len(), tostring(math.floor(maxValue)):len()) + (decimals > 0 and decimals + 1 or 0),
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 }
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame) return frame:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end,
				OnLeave = "",
			}, }, },
			events = {
				OnChar = function(frame, _, text) frame:SetText(text:gsub(matchPattern, replacePattern)) end,
				OnEnterPressed = function(frame) slider.setNumber(frame:GetNumber(), true) end,
				OnEscapePressed = function(frame) frame:SetText(tostring(us.Round(slider.widget.Slider:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
			},
			value = tostring(slider.getNumber()):gsub(matchPattern, replacePattern),
			showDefault = false,
			utilityMenu = false,
		})

		--| UX

		--Handle widget updates
		slider.setListener.changed(function(_, number) slider.valuebox.setText(tostring(us.Round(number, decimals)):gsub(matchPattern, replacePattern)) end)
	end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then slider.widget.Slider:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else slider.widget.Slider:HookScript(key, value) end
	end end

	--| UX

	local scriptEvent = false

	---Update the widget UI based on the number value
	---***
	---@param _ any
	---@param number number
	---@param user? boolean ***Default:*** `false`
	local function updateNumber(_, number, user) if not scriptEvent then slider.widget.Slider:SetValue(number, user) else scriptEvent = false end end

	---Update the min/max limits of the slider
	---@param limitMin? number
	---@param limitMax? number
	local function updateLimits(limitMin, limitMax)
		if limitMin then slider.widget.MinText:SetText(tostring(limitMin)) else limitMin = slider.getMin() end
		if limitMax then slider.widget.MaxText:SetText(tostring(limitMax)) else limitMax = slider.getMax() end

		slider.widget.Slider:SetMinMaxValues(limitMin, limitMax)
	end

	--Handle widget updates
	slider.setListener.changed(updateNumber, 1)
	slider.setListener.min(function(_, limitMin) updateLimits(limitMin) end, 1)
	slider.setListener.max(function(_, limitMax) updateLimits(nil, limitMax) end, 1)

	--Link value changes
	slider.widget.Slider:HookScript("OnValueChanged", function(_, number, user)
		if not IsMouseButtonDown("LeftButton") then slider.widget.Slider:SetValue(slider.getNumber()) return end

		scriptEvent = true

		slider.setNumber(number, user)
	end)

	--| Backdrop

	wt.SetBackdrop(slider.frame, { background = {
		texture = { size = 5, },
		color = { r = 1, g = 1, b = 1, a = 0 }
	}, }, { {
		triggers = { slider.frame, slider.widget.Slider, slider.widget.Forward, slider.widget.Back, t.valuebox ~= false and slider.valuebox.widget or nil },
		rules = {
			OnEnter = function() return slider.isEnabled() and { background = { color = { a = 0.1 } } } or {} end,
			OnLeave = "",
		},
	}, })

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(slider.widget.Slider, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { slider.frame } })

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(tostring(slider.getDefault()), "FFDDDD55") end

		wt.AddWidgetTooltipLines({ slider.frame, slider.widget.Slider, slider.widget.Back, slider.widget.Forward, slider.valuebox.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = slider.frame,
				condition = slider.isEnabled,
			},
			{
				frame = slider.widget.Slider,
				condition = slider.isEnabled,
			},
			{
				frame = slider.widget.Back,
				condition = slider.isEnabled,
			},
			{
				frame = slider.widget.Forward,
				condition = slider.isEnabled,
			},
			t.valuebox ~= false and {
				frame = slider.valuebox.widget,
				condition = slider.isEnabled,
			} or nil,
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.numeric = slider.getNumber() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				slider.setNumber(wt.clipboard.numeric, true)
			end }):SetEnabled(wt.clipboard.numeric ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() slider.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() slider.resetData() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		slider.widget.Slider:SetEnabled(state)

		slider.widget.TopText:SetFontObject(state and "GameFontNormal" or "GameFontDisable")
		slider.widget.MinText:SetFontObject(state and "GameFontNormalSmall" or "GameFontDisableSmall")
		slider.widget.MaxText:SetFontObject(state and "GameFontNormalSmall" or "GameFontDisableSmall")

		if t.valuebox ~= false then slider.valuebox.setEnabled(state) end

		slider.widget.Back:SetEnabled(state and wt.CheckDependencies({ { frame = slider.widget.Slider, evaluate = function(value) return value > slider.getMin() end }, }))
		slider.widget.Forward:SetEnabled(state and wt.CheckDependencies({ { frame = slider.widget.Slider, evaluate = function(value) return value < slider.getMax() end }, }))
	end

	slider.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, slider.isEnabled())

	--Set up the limits
	updateLimits(minValue, maxValue)

	-- Set up slider value
	updateNumber(nil, slider.getNumber(), false)

	return slider
end

---Create a classic Blizzard slider GUI frame with enhanced widget functionality
---***
---@param t? classicSliderCreationData Optional parameters
---@param numeric? numeric Reference to an already existing numeric widget to mutate into a slider instead of creating a new base widget
---***
---@return classicSlider|numeric # References to the new [Slider](https://warcraft.wiki.gg/wiki/UIOBJECT_Slider), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), child widgets, utility functions and more wrapped in a table
function wt.CreateClassicSlider(t, numeric)
	t = type(t) == "table" and t or {}
	numeric = wt.IsWidget(numeric) == "Numeric" and numeric or wt.CreateNumeric(t)

	if WidgetToolsDB.lite and t.lite ~= false then return numeric end

	---@class classicSlider : numeric
	local slider = numeric

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Numeric"
	---@return "ClassicSlider"
	---<p></p>
	function slider.getType() return "Numeric", "ClassicSlider" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function slider.isType(type) return type == "Numeric" or type == "ClassicSlider" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Slider")

	slider.frame = CreateFrame("Frame", name, t.parent)

	---@class classicBlizzardSlider : Slider
	slider.widget = CreateFrame("Slider", name .. "Frame", slider.frame, "OptionsSliderTemplate")

	slider.min = _G[name .. "FrameLow"]
	slider.max = _G[name .. "FrameHigh"]

	--| Position & dimensions

	t.width = t.width or 160
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(slider.frame, t.position) end
	wt.SetArrangementDirective(slider.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	slider.widget:SetPoint("TOP", 0, -15)
	slider.min:SetPoint("TOPLEFT", slider.widget, "BOTTOMLEFT")
	slider.max:SetPoint("TOPRIGHT", slider.widget, "BOTTOMRIGHT")

	slider.frame:SetSize(t.width, t.valuebox ~= false and 48 or 31)
	slider.widget:SetWidth(t.width - (t.sideButtons ~= false and 40 or 0))

	--| Visibility

	wt.SetVisibility(slider.frame, t.visible ~= false)

	if t.frameStrata then slider.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then slider.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then slider.frame:SetToplevel(t.keepOnTop) end

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Slider"

	if t.label ~= false then
		slider.label = _G[name .. "FrameText"]

		slider.label:SetPoint("TOP", slider.frame, "TOP", 0, 2)
		slider.label:SetFontObject("GameFontNormal")

		slider.label:SetText(title)
	else _G[name .. "FrameText"]:Hide() end

	--| Value step

	if t.hardStep ~= false then
		slider.widget:SetValueStep(slider.getStep())
		slider.widget:SetObeyStepOnDrag(true)
	end

	--| Valuebox

	local minValue, maxValue = slider.getMin(), slider.getMax()

	if t.valuebox ~= false then

		--| Calculate the required number of fractal digits, assemble string patterns for value validation
		local decimals = type(t.fractional) == "number" and floor(t.fractional + 0.5) or max(
			(tostring(minValue):match("%.(%d+)") or ""):len(),
			(tostring(maxValue):match("%.(%d+)") or ""):len(),
			(tostring(slider.getStep()):match("%.(%d+)") or ""):len()
		)
		local decimalPattern = ""
		for _ = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end
		local matchPattern = "(" .. (minValue < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
		local replacePattern = "%1" .. (decimals > 0 and "%2" or "")

		--| Frame setup

		slider.valuebox = wt.CreateCustomEditbox({
			parent = slider.frame,
			name = "Valuebox",
			label = false,
			tooltip = {
				title = wt.strings.slider.value.label,
				lines = { { text = wt.strings.slider.value.tooltip, }, }
			},
			position = {
				anchor = "TOP",
				relativeTo = slider.widget,
				relativePoint = "BOTTOM",
			},
			size = { w = 64, },
			font = {
				normal = "GameFontHighlightSmall",
				disabled = "GameFontDisableSmall",
			},
			justify = { h = "CENTER", },
			charLimit = max(tostring(math.floor(slider.getStep())):len(), tostring(math.floor(minValue)):len(), tostring(math.floor(maxValue)):len()) + (decimals > 0 and decimals + 1 or 0),
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 }
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame) return frame:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end,
				OnLeave = "",
			}, }, },
			events = {
				OnChar = function(frame, _, text) frame:SetText(text:gsub(matchPattern, replacePattern)) end,
				OnEnterPressed = function(frame) slider.setNumber(frame:GetNumber(), true) end,
				OnEscapePressed = function(frame) frame:SetText(tostring(us.Round(slider.widget:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
			},
			value = tostring(slider.getNumber()):gsub(matchPattern, replacePattern),
			showDefault = false,
			utilityMenu = false,
		})

		--| UX

		--Handle widget updates
		slider.setListener.changed(function(_, number) slider.valuebox.setText(tostring(us.Round(number, decimals)):gsub(matchPattern, replacePattern)) end)
	end

	--| Side buttons

	if t.sideButtons ~= false then

		--| Decrease

		slider.decreaseButton = wt.CreateCustomButton({
			parent = slider.frame,
			name = "SelectPrevious",
			title = "-",
			tooltip = {
				title = wt.strings.slider.decrease.label,
				lines = {
					{ text = wt.strings.slider.decrease.tooltip[1]:gsub("#VALUE", slider.getStep()), },
					slider.getAltStep() and { text = wt.strings.slider.decrease.tooltip[2]:gsub("#VALUE", slider.getAltStep()), } or nil,
				}
			},
			position = {
				anchor = "LEFT",
				relativeTo = slider.widget,
				relativePoint = "LEFT",
				offset = { x = -21, }
			},
			size = { w = 20, h = 20 },
			font = {
				normal = "GameFontHighlightMedium",
				highlight = "GameFontHighlightMedium",
				disabled = "GameFontDisableMed2"
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function() slider.decrease(IsAltKeyDown(), true) end,
			dependencies = { { frame = slider.widget, evaluate = function(value) return value > slider.getMin() end }, }
		})

		--| Increase

		slider.increaseButton = wt.CreateCustomButton({
			parent = slider.frame,
			name = "SelectNext",
			title = "+",
			tooltip = {
				title = wt.strings.slider.increase.label,
				lines = {
					{ text = wt.strings.slider.increase.tooltip[1]:gsub("#VALUE", slider.getStep()), },
					slider.getAltStep() and { text = wt.strings.slider.increase.tooltip[2]:gsub("#VALUE", slider.getAltStep()), } or nil,
				}
			},
			position = {
				anchor = "RIGHT",
				relativeTo = slider.widget,
				relativePoint = "RIGHT",
				offset = { x = 21, }
			},
			size = { w = 20, h = 20 },
			font = {
				normal = "GameFontHighlightMedium",
				highlight = "GameFontHighlightMedium",
				disabled = "GameFontDisableMed2",
			},
			backdrop = {
				background = {
					texture = {
						size = 5,
						insets = { l = 3, r = 3, t = 3, b = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			},
			backdropUpdates = { { rules = {
				OnEnter = function(frame)
					if not frame:IsEnabled() then return {} end

					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end,
				OnLeave = function(frame)
					if not frame:IsEnabled() then return {} end

					return {}, true
				end,
				OnMouseDown = function(frame)
					if not frame:IsEnabled() then return {} end

					return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end,
				OnMouseUp = function(frame, self)
					if not frame:IsEnabled() then return {} end

					return self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end,
			}, }, },
			action = function() slider.increase(IsAltKeyDown(), true) end,
			dependencies = { { frame = slider.widget, evaluate = function(value) return value < slider.getMax() end }, }
		})
	end

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then slider.widget:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else slider.widget:HookScript(key, value) end
	end end

	--| UX

	local scriptEvent = false

	---Update the widget UI based on the number value
	---***
	---@param _ any
	---@param number number
	---@param user? boolean ***Default:*** `false`
	local function updateNumber(_, number, user) if not scriptEvent then slider.widget:SetValue(number, user) else scriptEvent = false end end

	---Update the min/max limits of the slider
	---@param limitMin? number
	---@param limitMax? number
	local function updateLimits(limitMin, limitMax)
		if limitMin then slider.min:SetText(tostring(limitMin)) else limitMin = slider.getMin() end
		if limitMax then slider.max:SetText(tostring(limitMax)) else limitMax = slider.getMax() end

		slider.widget:SetMinMaxValues(limitMin, limitMax)
	end

	--Handle widget updates
	slider.setListener.changed(updateNumber, 1)
	slider.setListener.min(function(_, limitMin) updateLimits(limitMin) end, 1)
	slider.setListener.max(function(_, limitMax) updateLimits(nil, limitMax) end, 1)

	--Link value changes
	slider.widget:HookScript("OnValueChanged", function(_, number, user)
		scriptEvent = true

		slider.setNumber(number, user)

		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(slider.widget, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { slider.frame } })

		local defaultValue
		if t.showDefault ~= false then defaultValue = crc(tostring(slider.getDefault()), "FFDDDD55") end

		wt.AddWidgetTooltipLines({ slider.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = { {
			frame = slider.frame,
			condition = slider.isEnabled,
		}, },
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.numeric = slider.getNumber() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				slider.setNumber(wt.clipboard.numeric, true)
			end }):SetEnabled(wt.clipboard.numeric ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() slider.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() slider.resetData() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		slider.widget:SetEnabled(state)

		if slider.label then slider.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

		if t.valuebox ~= false then slider.valuebox.setEnabled(state) end

		if t.sideButtons ~= false then
			slider.decreaseButton.setEnabled(state and wt.CheckDependencies({ { frame = slider.widget, evaluate = function(value) return value > slider.getMin() end }, }))
			slider.increaseButton.setEnabled(state and wt.CheckDependencies({ { frame = slider.widget, evaluate = function(value) return value < slider.getMax() end }, }))
		end
	end

	slider.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, slider.isEnabled())

	--Set up the limits
	updateLimits(minValue, maxValue)

	--Set up slider value
	updateNumber(nil, slider.getNumber(), false)

	return slider
end

--[ Color Picker ]

---Create a non-GUI color pick manager widget with color data management logic
---***
---@param t? colormanagerCreationData Optional parameters
---***
---@return colormanager colorer Reference to the new color pick manager widget, utility functions and more wrapped in a table
function wt.CreateColormanager(t)
	t = type(t) == "table" and t or {}

	--[ Wrapper table ]

	---@class colormanager
	local colormanager = {}

	--[ Properties ]

	local active = false

	--| Data

	local default = wt.PackColor(wt.UnpackColor(t.default))
	local value = t.value or type(t.getData) == "function" and t.getData() or nil
	value = wt.PackColor(wt.UnpackColor(value))
	local snapshot = value

	--| State

	local enabled = t.disabled ~= true

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "Colormanager"
	---<p></p>
	function colormanager.getType() return "Colormanager" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function colormanager.isType(type) return type == "Colormanager" end

	--| Event handling

	--Call all registered listeners for a custom widget event
	colormanager.invoke = {
		enabled = function() callListeners(colormanager, listeners, "enabled", enabled) end,

		---@param success boolean
		loaded = function(success) callListeners(colormanager, listeners, "loaded", success) end,

		---@param success boolean
		saved = function(success) callListeners(colormanager, listeners, "saved", success) end,

		---@param user boolean
		colored = function(user) callListeners(colormanager, listeners, "colored", value, user) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(colormanager, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	colormanager.setListener = {
		---@param listener ColorpickerEventHandler_enabled Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

		---@param listener ColorpickerEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener ColorpickerEventHandler_saved Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

		---@param listener ColorpickerEventHandler_colored Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		colored = function(listener, callIndex) addListener(listeners, "colored", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener ColorpickerEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Options data management

	---Read the data from storage then verify and load it to the widget
	---***
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
	function colormanager.loadData(handleChanges, silent)
		handleChanges = handleChanges ~= false

		if type(t.getData) == "function" then
			colormanager.setColor(t.getData(), handleChanges, silent)

			if not silent then colormanager.invoke.loaded(true) end
		else
			if handleChanges and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end

			if not silent then colormanager.invoke.loaded(false) end
		end
	end

	---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
	---***
	---@param color? colorData|colorRGBA Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
	function colormanager.saveData(color, silent)
		if type(t.saveData) == "function" then
			t.saveData(color and wt.PackColor(wt.UnpackColor(color)) or value)

			if not silent then colormanager.invoke.saved(true) end
		elseif not silent then colormanager.invoke.saved(false) end
	end

	---Get the currently stored data via **t.getData()**
	---@return colorData|nil
	function colormanager.getData() return type(t.getData) == "function" and t.getData() or nil end

	---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
	---***
	---@param color? colorData|colorRGBA Data to be saved | ***Default:*** *the currently set value of the widget*
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function colormanager.setData(color, handleChanges, silent)
		colormanager.saveData(color, silent)
		colormanager.loadData(handleChanges, silent)
	end

	---Get the currently set default value
	---@return colorData default
	function colormanager.getDefault() return us.Clone(default) end

	---Set the default value
	---@param color? colorData | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
	function colormanager.setDefault(color) default = wt.PackColor(wt.UnpackColor(color)) end

	---Set and load the stored data managed by the widget to the last saved data snapshot set via **colormanager.snapshotData()**
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function colormanager.revertData(handleChanges, silent) colormanager.setData(snapshot, handleChanges, silent) end

	---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **colormanager.revertData()**
	---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
	function colormanager.snapshotData(stored) us.CopyValues(snapshot, stored and colormanager.getData() or value) end

	---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
	---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
	---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
	function colormanager.resetData(handleChanges, silent) colormanager.setData(default, handleChanges, silent) end

	---Returns the currently set channel values wrapped in a color table
	---@return colorData
	function colormanager.getColor() return us.Clone(value) end

	---Set the managed color values
	---***
	---@param color? colorData|colorRGBA ***Default:*** { r = 1, g = 1, b = 1, a = 1 } *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke a "colored" event and call registered listeners | ***Default:*** `false`
	function colormanager.setColor(color, user, silent)
		value = wt.PackColor(wt.UnpackColor(color))

		if not silent then colormanager.invoke.colored(user == true) end

		if user and t.instantSave ~= false then colormanager.saveData(nil, silent) end

		if user and type(t.dataManagement) == "table" then wt.HandleWidgetChanges(t.dataManagement.index, t.dataManagement.category, t.dataManagement.key) end
	end

	--| Color wheel

	--Color wheel value update utility
	local function colorUpdate()
		if not enabled then return end

		local r, g, b = ColorPickerFrame:GetColorRGB()

		colormanager.setColor(wt.PackColor(r, g, b, ColorPickerFrame:GetColorAlpha()), true)
	end

	---Open the the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) for this color picker
	function colormanager.openColorPicker()
		local r, g, b, a = wt.UnpackColor(value)

		--Set this color picker as the active one
		active = true

		ColorPickerFrame:SetupColorPickerAndShow({
			r = r,
			g = g,
			b = b,
			opacity = a,
			hasOpacity = true,
			swatchFunc = colorUpdate,
			opacityFunc = colorUpdate,
			cancelFunc = function()
				colormanager.setColor(wt.PackColor(r, g, b, a), true)

				if t.onCancel then t.onCancel() end
			end
		})
	end

	---Return the active status of this color picker, whether the main color wheel window was opened for and is currently updating the color of this widget
	---@return boolean active True, if the color wheel has been opened for this color picker widget
	function colormanager.isActive() return active end

	--| State

	---Return the current enabled state of the widget
	---@return boolean enabled True, if the widget is enabled
	function colormanager.isEnabled() return enabled end

	---Enable or disable the widget based on the specified value
	---***
	---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
	---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
	function colormanager.setEnabled(state, silent)
		enabled = state ~= false

		--Update the color when re-enabled
		if active then colorUpdate() end

		if not silent then colormanager.invoke.enabled() end
	end

	--[ Color Wheel Toggle ]

	--Button to open the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) on action with
	colormanager.button = wt.CreateAction({ action = colormanager.openColorPicker, })

	--Deactivate on close
	ColorPickerFrame:HookScript("OnHide", function() active = false end)

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then colormanager.setListener._(v[i].event, v[i].handler, v[i].callIndex) else colormanager.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Register to settings data management
	if t.dataManagement then wt.AddSettingsDataManagementEntry(colormanager, t.dataManagement) end

	--Assign dependencies
	if t.dependencies then wt.AddDependencies(t.dependencies, colormanager.setEnabled) end

	--Set starting value
	colormanager.setColor(value, false, true)

	return colormanager
end

--| GUI

---Create a color picker GUI frame with HEX(A) & RGB(A) input while utilizing the [ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame) wheel
---***
---@param t? colorpickerCreationData Optional parameters
---@param colormanager? colormanager Reference to an already existing color data manager to mutate into a colorpicker instead of creating a new base widget
---***
---@return colorpicker|colormanager # Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateColorpicker(t, colormanager)
	t = type(t) == "table" and t or {}
	colormanager = wt.IsWidget(colormanager) == "Colorpicker" and colormanager or wt.CreateColormanager(t)

	if WidgetToolsDB.lite and t.lite ~= false then return colormanager end

	---@class colorpickerButton : customButton
	---@field gradient Texture
	---@field checker Texture

	---@class colorpicker : colormanager
	---@field button colorpickerButton|customButton|action
	local colorpicker = colormanager

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Colormanager"
	---@return "Colorpicker"
	---<p></p>
	function colormanager.getType() return "Colormanager", "Colorpicker" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function colormanager.isType(type) return type == "Colormanager" or type == "Colorpicker" end

	--[ Frame Setup ]

	local name = (t.append ~= false and t.parent and t.parent ~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Colorpicker")

	colorpicker.frame = CreateFrame("Frame", name, t.parent)

	--| Position & dimensions

	t.width = t.width or 120
	local arrange = type(t.arrange) == "table" and t.arrange or {}

	if not t.arrange and t.position then wt.SetPosition(colorpicker.frame, t.position) end
	wt.SetArrangementDirective(colorpicker.frame, arrange.index, arrange.wrap ~= false, t.arrange == nil)

	colorpicker.frame:SetSize(t.width, 36)

	--| Visibility

	wt.SetVisibility(colorpicker.frame, t.visible ~= false)

	if t.frameStrata then colorpicker.frame:SetFrameStrata(t.frameStrata) end
	if t.frameLevel then colorpicker.frame:SetFrameLevel(t.frameLevel) end
	if t.keepOnTop then colorpicker.frame:SetToplevel(t.keepOnTop) end

	--| Label

	local title = type(t.title) == "string" and t.title or type(t.name) == "string" and t.name or "Colorpicker"

	colorpicker.label = t.label ~= false and wt.CreateTitle(colorpicker.frame, {
		offset = { x = 4, },
		text = title,
	}) or nil

	--| Color wheel toggle button

	---Toggle the interactability of the color picker elements when [ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame) is opened
	---@param unlocked boolean
	local function setLock(unlocked)
		colorpicker.button.widget:EnableMouse(unlocked)
		colorpicker.hexBox.widget:EnableMouse(unlocked)

		--| Fade inactive color pickers

		local opacity = (unlocked or colorpicker.isActive()) and 1 or 0.4

		colorpicker.label:SetAlpha(opacity)
		colorpicker.hexBox.widget:SetAlpha(opacity)
	end

	if not t.value and t.getData then t.value = us.Clone(t.getData()) else t.value = {} end

	if not colorpicker.button.widget then wt.CreateCustomButton({
		parent = colorpicker.frame,
		name = "PickerButton",
		label = false,
		tooltip = {
			title = wt.strings.color.picker.label,
			lines = { { text = wt.strings.color.picker.tooltip:gsub("#ALPHA", t.value.a and wt.strings.color.picker.alpha or ""), }, }
		},
		position = { offset = { y = -14 } },
		size = { w = 34, h = 22 },
		backdrop = {
			background = {
				texture = {
					size = 5,
					insets = { l = 2.5, r = 2.5, t = 2.5, b = 2.5 },
				},
				color = { r = t.value.r or 1, g = t.value.g or 1, b = t.value.b or 1, a = t.value.a or 1 }
			},
			border = {
				texture = { width = 11, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
			}
		},
		backdropUpdates = { { rules = {
			OnEnter = function(frame)
				if not frame:IsEnabled() then return {} end

				return IsMouseButtonDown() and {
					border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
				} or {
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				}
			end,
			OnLeave = function(frame)
				if not frame:IsEnabled() then return {} end

				return { border = { color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 } } }
			end,
			OnMouseDown = function(frame)
				if not frame:IsEnabled() then return {} end

				return { border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } } }
			end,
			OnMouseUp = function(frame, self)
				if not frame:IsEnabled() then return {} end

				return self:IsMouseOver() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {}
			end,
		}, }, },
	}, colorpicker.button) end

	colorpicker.button.gradient = wt.CreateTexture(colorpicker.button.widget, {
		name = "ColorGradient",
		position = { offset = { x = 2.5, y = -2.5 } },
		size = { w = 17, h = 17 },
		path = rs.textures.gradientBG,
		layer = "BACKGROUND",
		level = -7,
	})

	colorpicker.button.checker = wt.CreateTexture(colorpicker.button.widget, {
		name = "AlphaBG",
		position = { offset = { x = 2.5, y = -2.5 } },
		size = { w = 29, h = 17 },
		path = rs.textures.alphaBG,
		layer = "BACKGROUND",
		level = -8,
		tile = { h = true, v = true },
		wrap = { h = true, v = true },
	})

	--| HEX textbox

	colorpicker.hexBox = wt.CreateCustomEditbox({
		parent = colorpicker.frame,
		name = "HEXBox",
		title = wt.strings.color.hex.label,
		label = false,
		tooltip = { lines = { {
			text = wt.strings.color.hex.tooltip .. "\n\n" .. crc(wt.strings.example .. ": ", "FF66FF66") .. crc(
				"#2266BB" .. (t.value.a and "AA" or ""), "FFFFFFFF"
			),
		}, } },
		position = {
			relativeTo = colorpicker.button.widget,
			relativePoint = "TOPRIGHT",
		},
		size = { w = t.width - colorpicker.button.widget:GetWidth(), h = colorpicker.button.widget:GetHeight() },
		insets = { l = 6, },
		font = {
			normal = "GameFontNormalSmall2",
			highlight = "GameFontHighlightSmall2",
			disabled = "GameFontDisableSmall2",
		},
		charLimit = 7 + (t.value.a and 2 or 0),
		backdrop = {
			background = {
				texture = {
					size = 5,
					insets = { l = 3, r = 3, t = 3, b = 3 },
				},
				color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 }
			},
			border = {
				texture = { width = 12, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
			}
		},
		backdropUpdates = { { rules = {
			OnEnter = function(frame) return frame:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end,
			OnLeave = "",
		}, }, },
		events = {
			OnChar = function(frame, _, text) frame:SetText(text:gsub("^(#?)([%x]*).*", "%1%2"), false) end,
			OnEnterPressed = function(_, text) colorpicker.setColor(wt.PackColor(wt.HexToColor(text)), true) end,
			OnEscapePressed = function(self) self.setText(wt.ColorToHex(colorpicker.getColor())) end,
		},
		showDefault = false,
		utilityMenu = false,
	})

	--| RGBA textboxes

	--ADD textboxes

	--[ Events ]

	--Register script event handlers
	if t.events then for key, value in pairs(t.events) do
		if key == "attribute" then colorpicker.frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
		else colorpicker.frame:HookScript(key, value) end
	end end

	--| UX

	---Update the widget UI based on the color value
	---@param color colorData|colorRGBA
	local function updateColor(color)
		colorpicker.button.widget:SetBackdropColor(color.r, color.g, color.b, color.a)
		colorpicker.button.gradient:SetVertexColor(color.r, color.g, color.b, 1)
		colorpicker.hexBox.setText(wt.ColorToHex(color))
	end

	--Handle widget updates
	colorpicker.setListener.colored(function(_, color) updateColor(color) end)

	--Color wheel toggle updates
	ColorPickerFrame:HookScript("OnShow", function() setLock(false) end)
	ColorPickerFrame:HookScript("OnHide", function() setLock(true) end)

	--| Tooltip

	if type(t.tooltip) == "table" then
		wt.AddTooltip(colorpicker.frame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		})

		local defaultValue
		if t.showDefault ~= false then
			local default = colorpicker.getDefault()
			local r, g, b = wt.UnpackColor(default)

			local texture = "|TInterface/ChatFrame/ChatFrameBackground:12:12:0:0:16:16:0:16:0:16:" .. (r * 255) .. ":" .. (g * 255) .. ":" .. (b * 255) .. "|t "
			defaultValue = texture .. crc(wt.ColorToHex(default), "FFFFFFFF")
		end

		wt.AddWidgetTooltipLines({ colorpicker.frame, colorpicker.button.widget, colorpicker.hexBox.widget }, defaultValue, t.utilityMenu)
	end

	--| Utility menu

	---Utility menu opening condition checker
	---@return boolean
	local function openCondition() return colorpicker.isEnabled() and not ColorPickerFrame:IsVisible() end

	if t.utilityMenu ~= false then wt.CreateContextMenu({
		triggers = {
			{
				frame = colorpicker.frame,
				condition = openCondition,
			},
			{
				frame = colorpicker.button.frame,
				condition = openCondition,
			},
			{
				frame = colorpicker.hexBox.widget,
				condition = openCondition,
			},
		},
		initialize = function(menu)
			wt.CreateMenuTextline(menu, { text = title })
			wt.CreateMenuButton(menu, { title = wt.strings.value.copy, action = function() wt.clipboard.color = colorpicker.getColor() end })
			wt.CreateMenuButton(menu, { title = wt.strings.value.paste, action = function()
				colorpicker.setColor(wt.clipboard.color, true)
			end }):SetEnabled(wt.clipboard.color ~= nil)
			wt.CreateMenuButton(menu, { title = wt.strings.value.revert, action = function() colorpicker.revertData() end })
			if t.showDefault ~= false then wt.CreateMenuButton(menu, { title = wt.strings.value.restore, action = function() colorpicker.resetData() end }) end
		end
	}) end

	--| State

	---Update the widget UI based on its enabled state
	---@param _ any
	---@param state boolean
	local function updateState(_, state)
		colorpicker.button.setEnabled(state)
		colorpicker.hexBox.setEnabled(state)

		if colorpicker.label then colorpicker.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

		if ColorPickerFrame:IsVisible() then setLock(false) end
	end

	colorpicker.setListener.enabled(updateState, 1)

	--[ Initialization ]

	--Set up starting state
	updateState(nil, colorpicker.isEnabled())

	--Set up coloring
	updateColor(colorpicker.getColor())

	return colorpicker
end

--[ Profile Data Manager ]

---Create a non-GUI profile data manager widget with live database management and profile selection logic
---***
---@param accountData profileStorage|table Reference to the account-bound SavedVariables addon database where profile data is to be stored<ul><li>***Note:*** A subtable will be created under the key `profiles` if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).</li></ul>
---@param characterData characterProfileData|table Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified<ul><li>***Note:*** An integer value will be created under the key `activeProfile` if it doesn't already exist in this table.</li></ul>
---@param defaultData table A static table containing all default settings values to be cloned when creating a new profile or resetting one
---@param t? profilemanagerCreationData Optional parameters
---***
---@return profilemanager? profilemanager Reference to the new profile data manager widget, utility functions and more wrapped in a table | ***Default:*** nil
function wt.CreateProfilemanager(accountData, characterData, defaultData, t)
	if type(accountData) ~= "table" or type(characterData) ~= "table" or type(defaultData) ~= "table" then return end

	t = type(t) == "table" and t or {}
	t.category = type(t.category) == "string" and t.category or ""

	--[ Wrapper table ]

	---@class profilemanager
	---@field data table Reference to live data table of the currently active profile
	---@field firstLoad boolean True, if the `accountData.profiles` table did not exist yet
	---@field newCharacter boolean True, if the `characterData.activeProfile` integer did not exist yet
	local profilemanager = {
		firstLoad = type(accountData.profiles) ~= "table",
		newCharacter = type(characterData.activeProfile) ~= "number"
	}

	--[ Properties ]

	local category = t.category:len() > 0 and t.category or "Addon"
	local valueChecker = t.valueChecker
	local onRecovery = t.onRecovery
	local recoveryMap = t.recoveryMap

	--| Data

	local activeIndex = 1

	--| Utilities

	--Profile delete confirmation
	local deleteProfilePopup = wt.RegisterPopupDialog(category .. "_DELETE_PROFILE", { accept = DELETE, })

	--Profile reset confirmation
	local resetProfilePopup = wt.RegisterPopupDialog(category .. "RESET_PROFILE")

	--| Events

	---@type table<string, function[]>
	local listeners = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "Profilemanager"
	---<p></p>
	function profilemanager.getType() return "Profilemanager" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function profilemanager.isType(type) return type == "Profilemanager" end

	--| Event handling

	--Get a trigger function to call all registered listeners for the specified custom widget event with
	profilemanager.invoke = {
		---@param user boolean
		loaded = function(user) callListeners(profilemanager, listeners, "loaded", user) end,

		---@param success boolean
		---@param user boolean
		activated = function(success, user) callListeners(profilemanager, listeners, "activated", activeIndex, accountData.profiles[activeIndex].title, success, user) end,

		---@param index integer
		---@param title string
		---@param user boolean
		created = function(index, title, user) callListeners(profilemanager, listeners, "created", index, title, user) end,

		---@param success boolean
		---@param user boolean
		---@param index any
		---@param title? string
		renamed = function(success, user, index, title) callListeners(profilemanager, listeners, "renamed", success, index, title, user) end,

		---@param success boolean
		---@param user boolean
		---@param index any
		---@param title? string
		deleted = function(success, user, index, title) callListeners(profilemanager, listeners, "deleted", success, index, title, user) end,

		---@param success boolean
		---@param user boolean
		---@param index any
		---@param title? string
		reset = function(success, user, index, title) callListeners(profilemanager, listeners, "reset", success, index, title, user) end,

		---@param event string Custom event tag
		---@param ... any
		_ = function(event, ...) callListeners(profilemanager, listeners, event, ...) end
	}

	--Hook a handler function as a listener for a custom widget event
	profilemanager.setListener = {
		---@param listener ProfilemanagerEventHandler_loaded Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

		---@param listener ProfilemanagerEventHandler_activated Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		activated = function(listener, callIndex) addListener(listeners, "activated", listener, callIndex) end,

		---@param listener ProfilemanagerEventHandler_created Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		created = function(listener, callIndex) addListener(listeners, "created", listener, callIndex) end,

		---@param listener ProfilemanagerEventHandler_renamed Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		renamed = function(listener, callIndex) addListener(listeners, "created", listener, callIndex) end,

		---@param listener ProfilemanagerEventHandler_deleted Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		deleted = function(listener, callIndex) addListener(listeners, "deleted", listener, callIndex) end,

		---@param listener ProfilemanagerEventHandler_reset Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		reset = function(listener, callIndex) addListener(listeners, "reset", listener, callIndex) end,

		---@param event string Custom event tag
		---@param listener ProfilemanagerEventHandler_any Handler function to set
		---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
		_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
	}

	--| Utilities

	---Set the active profile
	---@param index? integer ***Default:*** `activeIndex` or `1`
	local function setActiveProfile(index)
		index = Clamp(type(index) == "number" and type(accountData.profiles[index]) == "table" and math.floor(index) or activeIndex, 1, #accountData.profiles)

		activeIndex = index
		profilemanager.data = accountData.profiles[index].data

		--Update selected profile in the character-specific data
		characterData.activeProfile = index
	end

	---Activate the specified settings profile
	---***
	---@param index? integer Index of the profile to set as the currently active settings profile | ***Default:*** *currently active profile index* or `1`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "applied" event and call registered listeners | ***Default:*** `false`
	---***
	---@return integer? index The index of the active profile | ***Default:*** `nil`
	function profilemanager.activate(index, user, silent)
		if type(index) ~= "number" then
			--Call listeners
			if not silent then profilemanager.invoke.activated(false, user == true) end

			return nil
		end

		setActiveProfile(index)

		--Call listeners
		if not silent then profilemanager.invoke.activated(true, user == true) end

		return activeIndex
	end

	---Find a profile by its display title and return its index
	---***
	---@param title string Name of the profile to find
	---@param skipFirst? boolean Set to `true` to find duplicate `title` | ***Default:*** `false`
	---@return integer? index
	function profilemanager.findIndex(title, skipFirst)
		for i = 1, #accountData.profiles do if accountData.profiles[i].title == title then if skipFirst then skipFirst = false else return i end end end
	end

	---Find an unused profile name to be able to use it as an identifying display title
	---***
	---@param name? string ***Default:*** "Profile"
	---@param number? integer ***Default:*** 2
	---@param skipFirst? boolean ***Default:*** `false`
	---@return string title
	local function checkName(name, number, skipFirst)
		name = name or wt.strings.profiles.select.profile
		local title = name .. (number and (" " .. number) or "")

		--Find an unused name for the new profile
		if profilemanager.findIndex(title, skipFirst) then
			number = (number and number or 2)
			title = name .. " " .. number

			while profilemanager.findIndex(title) do
				number = number + 1
				title = name .. " " .. number
			end
		end

		return title
	end

	---Create a new settings profile
	---***
	---@param name? string Name tag to use when setting the display title of the new profile | ***Default:*** `duplicate` and **accountData.profiles[duplicate].title** or "Profile"
	---@param number? integer Starting value for the incremented number appended to `name` if it's used | ***Default:*** 2
	---@param duplicate? integer Index of the profile to create the new profile as a duplicate of instead of using default data values
	---@param apply? boolean Whether to immediately set the new profile as the active profile or not | ***Default:*** `true`
	---@param index? integer Place the new profile under this specified index in **accountData.profile** instead of the end of the list | ***Range:*** (1, #**accountData.profiles** + 1)
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "created" event and call registered listeners | ***Default:*** `false`
	function profilemanager.create(name, number, duplicate, index, apply, user, silent)
		index = Clamp(type(index) == "number" and math.floor(index) or #accountData.profiles + 1, 1, #accountData.profiles + 1)
		local d = type(accountData.profiles[duplicate]) == "table" and accountData.profiles[duplicate] or nil

		--Create profile data
		table.insert(accountData.profiles, index, {
			title = checkName(d and d.title or name, number),
			data = us.Clone(d and d.data or defaultData)
		})

		--Call listeners
		if not silent then profilemanager.invoke.created(index, accountData.profiles[index].title, user == true) end

		--Activate the new profile
		if apply ~= false then profilemanager.activate(index, user, silent) end
	end

	---Rename the specified profile
	---@param index? integer Index of the profile to rename | ***Default:*** *currently active profile index*
	---@param name? string The new title of the profile to set | ***Default:*** "Profile"
	---@param number? integer Starting value for the incremented number appended to `name` if it's used | ***Default:*** 2
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "renamed" event and call registered listeners | ***Default:*** `false`
	---***
	---@return boolean # True on success, false if the operation failed
	function profilemanager.rename(index, name, number, user, silent)
		if index and not accountData.profiles[index] then
			--Call listeners
			if not silent then profilemanager.invoke.renamed(false, user == true, index) end

			return false
		end

		index = index or activeIndex
		local title = checkName(name, number)

		accountData.profiles[index].title = title

		--Call listeners
		if not silent then profilemanager.invoke.renamed(true, user == true, index, title) end

		return true
	end

	---Delete the specified profile
	---***
	---@param index? integer Index of the profile to delete | ***Default:*** *currently active profile index*
	---@param unsafe? boolean If false, show a popup confirmation before attempting to delete the specified profile | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "deleted" event and call registered listeners | ***Default:*** `false`
	---***
	---@return boolean # True on success, false if the operation failed
	function profilemanager.delete(index, unsafe, user, silent)
		if index and not accountData.profiles[index] then
			--Call listeners
			if not silent then profilemanager.invoke.deleted(false, user == true, index) end

			return false
		end

		index = index or activeIndex
		local title = accountData.profiles[index].title

		local delete = function()
			--Delete profile data
			table.remove(accountData.profiles, index)

			--Call listeners
			if not silent then profilemanager.invoke.deleted(true, user == true, index, title) end

			--Activate the replacement profile
			if activeIndex == index then profilemanager.activate(index, user, silent) end
		end

		if unsafe then delete() else StaticPopup_Show(wt.UpdatePopupDialog(deleteProfilePopup, {
			text = wt.strings.profiles.delete.warning:gsub("#PROFILE", cr(accountData.profiles[index].title, NORMAL_FONT_COLOR)):gsub("#ADDON", category),
			onAccept = delete,
		})) end

		return true
	end

	---Reset the specified profile data to default values
	---***
	---@param index? integer Index of the profile to restore to defaults | ***Default:*** *currently active profile index*
	---@param unsafe? boolean If false, show a popup confirmation before attempting to reset the specified profile | ***Default:*** `false`
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "reset" event and call registered listeners | ***Default:*** `false`
	---***
	---@return boolean # True on success, false if the operation failed
	function profilemanager.reset(index, unsafe, user, silent)
		if index and not accountData.profiles[index] then
			--Call listeners
			if not silent then profilemanager.invoke.reset(false, user == true, index) end

			return false
		end

		index = index or activeIndex

		local function reset()
			--Update the profile in storage (without breaking table references)
			us.CopyValues(accountData.profiles[index].data, defaultData)

			--Call listeners
			if not silent then profilemanager.invoke.reset(true, user == true, index, accountData.profiles[index].title) end
		end

		if unsafe then reset() else StaticPopup_Show(wt.UpdatePopupDialog(resetProfilePopup, {
			text = wt.strings.profiles.reset.warning:gsub("#PROFILE", cr(accountData.profiles[index].title, NORMAL_FONT_COLOR)):gsub("#ADDON", category),
			onAccept = reset,
		}))end

		return true
	end

	---Check & fix a profile data table based on the specified sample profile
	---***
	---@param profileData table Profile data table to check
	---@param compareWith? table  Profile data table to sample | ***Default:*** `defaultData`
	---***
	---@return table profileData Reference to `profileData` (it was already updated during the operation, no need for setting it again)
	function profilemanager.validate(profileData, compareWith)
		if type(profileData) ~= "table" then return profileData end

		compareWith = type(compareWith) == "table" and compareWith or defaultData

		us.Prune(profileData, valueChecker)
		us.Fill(profileData, compareWith)
		us.Filter(profileData, compareWith, recoveryMap, onRecovery)

		return profileData
	end

	---Clean up a profile list table
	---@param list profile[]
	local function validateProfiles(list)
		local index = 1

		--Check profile list
		for key, value in us.SortedPairs(list) do
			if key == index and type(value) == "table" then
				--Check profile data
				if type(list[index].data) == "table" then profilemanager.validate(list[index].data) else list[index].data = us.Clone(defaultData) end
			else
				--Remove invalid entry
				list[key] = nil
			end

			index = index + 1
		end

		--Fill with default profile
		if not list[1] then list[1] = { title = wt.strings.profiles.select.main, data = us.Clone(defaultData) } end

		--Check profile names
		for i = 1, #list do list[i].title = checkName(list[i].title, nil, true) end
	end

	---Load profiles data
	---***
	---@param p? profileStorage Table holding the list of profiles to store | ***Default:*** *validate* **accountData** *(if the data is missing or invalid, set up a default profile)*
	---@param activeProfile? integer Index of the active profile to set | ***Default:*** *currently active profile index*
	---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
	---@param silent? boolean If false, invoke an "loaded" event and call registered listeners | ***Default:*** `false`
	function profilemanager.load(p, activeProfile, user, silent)

		--| Profile list

		if type(p) == "table" then
			p.profiles = type(p.profiles) == "table" and p.profiles or {}

			validateProfiles(p.profiles)

			--Update the profile list in storage (without breaking table references)
			for i = 1, #p.profiles do
				accountData.profiles[i].title = p.profiles[i].title
				us.CopyValues(accountData.profiles[i].data, p.profiles[i].data)
			end
		else
			accountData.profiles = type(accountData.profiles) == "table" and accountData.profiles or {}

			validateProfiles(accountData.profiles)
		end

		--| Activate profile

		setActiveProfile(activeProfile or activeIndex)

		--| Recover misplaced data

		local recovered = {}

		--Remove & save misplaced possibly valuable data
		for key, value in pairs(accountData) do if key ~= "profiles" then
			recovered[key] = value
			accountData[key] = nil
		end end

		if next(recovered) then
			--Pack recovered data into the active profile data table (to be removed later if found irrelevant or invalid during validation)
			us.Pull(profilemanager.data, recovered)

			--Validate active profile data
			profilemanager.validate(profilemanager.data)

			ds.Log("Recovered misplaced data:" .. us.TableToString(recovered), "Profilemanager (" .. category .. ") loadProfiles")
		end

		--| Call listeners

		if not silent then
			user = user == true

			profilemanager.invoke.loaded(user)
			profilemanager.invoke.activated(true, user)
		end
	end

	--[ Initialization ]

	--Register event handlers
	if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
		if k == "_" then profilemanager.setListener._(v[i].event, v[i].handler, v[i].callIndex) else profilemanager.setListener[k](v[i].handler, v[i].callIndex) end
	end end end end

	--Load starting data
	profilemanager.load(nil, nil, false, true)

	return profilemanager
end

--| GUI

---Create and set up a new settings page with profile data handling and advanced backup management options
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param accountData profileStorage|table Reference to the account-bound SavedVariables addon database where profile data is to be stored<ul><li>***Note:*** A subtable will be created under the key `profiles` if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).</li></ul>
---@param characterData characterProfileData|table Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified<ul><li>***Note:*** An integer value will be created under the key `activeProfile` if it doesn't already exist in this table.</li></ul>
---@param defaultData table A static table containing all default settings values to be cloned when creating a new profile or resetting one
---@param settingsData backupboxSettingsData|table Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from<ul><li>***Note:*** A boolean value will be created under the key `compactBackup` if it didn't already exist in this table.</li></ul>
---@param t? profilesPageCreationData Optional parameters
---@param profilemanager? profilemanager Reference to an already existing profile data manager to mutate into a profile management settings page instead of creating a new base widget
---***
---@return profilemanager|profilesPage? profilesPage Table containing references to the settings page, settings widgets grouped in subtables and utility functions by category | ***Default:*** nil
function wt.CreateProfilesPage(addon, accountData, characterData, defaultData, settingsData, t, profilemanager)
	profilemanager = wt.IsWidget(profilemanager) == "Profilemanager" and profilemanager or wt.CreateProfilemanager(accountData, characterData, defaultData, t)

	if not profilemanager or type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) or type(settingsData) ~= "table" then return profilemanager end

	t = type(t) == "table" and t or {}

	---@class profilesPage : profilemanager
	---@field widgets? table Collection of profiles settings widgets
	---@field backup? table Collection of backup settings widgets
	---@field backupAll? table Collection of all profiles backup settings widgets
	local profiles = profilemanager

	--[ Getters & Setters ]

	---Returns all object types of this mutated widget
	---***
	---@return "Profilemanager"
	---@return "ProfilesPage"
	---<p></p>
	function profiles.getType() return "Profilemanager", "ProfilesPage" end

	---Checks and returns if the a type of this mutated widget matches the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function profiles.isType(type) return type == "Profilemanager" or type == "ProfilesPage" end

	--[ Properties ]

	local addonTitle = C_AddOns.GetAddOnMetadata(addon, "Title")
	local onDefault = type(t.onDefault) == "function" and t.onDefault or nil

	--[ Settings Page ]

	profiles.settings = wt.CreateSettingsPage(addon, {
		register = t.register,
		name = t.name or "DataManagement",
		title = t.title or wt.strings.dataManagement.title,
		description = t.description or wt.strings.dataManagement.description:gsub("#ADDON", addonTitle),
		dataManagement = {
			category = addon,
			keys = { "Backup" },
		},
		onSave = t.onSave,
		onLoad = t.onLoad,
		onCancel = t.onCancel,
		onDefault = onDefault and function(user, category)
			if not category then profiles.reset() end
			onDefault(user, category)
		end or function(_, category) if not category then profiles.reset() end end,
		arrangement = {},
		initialize = function(canvas, _, _, category, keys) if not WidgetToolsDB.lite or t.lite == false then

			--[ Profiles ]

			profiles.widgets = {}

			local profilesPanel = wt.CreatePanel({
				parent = canvas,
				name = "Profiles",
				title = wt.strings.profiles.title,
				description = wt.strings.profiles.description:gsub("#ADDON", addonTitle),
				arrange = {},
				arrangement = {},
				initialize = function(panel)

					--[ Frame Setup ]

					profiles.widgets.activate = wt.CreateDropdownRadiogroup({
						parent = panel,
						title = wt.strings.profiles.select.label,
						tooltip = { lines = { { text = wt.strings.profiles.select.tooltip, }, } },
						arrange = {},
						width = 180,
						items = accountData.profiles,
						value = characterData.activeProfile,
						listeners = { selected = { { handler = function(_, index, user) profiles.activate(index, user) end, }, }, },
					})

					profiles.widgets.create = wt.CreateButton({
						parent = panel,
						name = "New",
						title = wt.strings.profiles.new.label,
						tooltip = { lines = { { text = wt.strings.profiles.new.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							offset = { x = -312, y = -21 }
						},
						size = { w = 112, h = 26 },
						action = function() profiles.create(nil, #accountData.profiles + 1, nil, nil, nil, true) end,
					})

					profiles.widgets.duplicate = wt.CreateButton({
						parent = panel,
						name = "Duplicate",
						title = wt.strings.profiles.duplicate.label,
						tooltip = { lines = { { text = wt.strings.profiles.duplicate.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							offset = { x = -192, y = -21 }
						},
						size = { w = 112, h = 26 },
						action = function() profiles.create(nil, nil, characterData.activeProfile, nil, nil, true) end,
					})

					profiles.widgets.rename = wt.CreateButton({
						parent = panel,
						name = "Rename",
						title = wt.strings.profiles.rename.label,
						tooltip = { lines = { { text = wt.strings.profiles.rename.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							offset = { x = -92, y = -21 }
						},
						size = { w = 92, h = 26 },
						action = function()
							local title = accountData.profiles[characterData.activeProfile].title

							wt.CreatePopupInputBox({
								title = wt.strings.profiles.rename.description:gsub("#PROFILE", crc(title, "FFFFFFFF")),
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -92, y = -21 },
									relativeTo = panel,
								},
								text = title,
								accept = function(text) profiles.rename(nil, text, nil, true) end,
							})
						end,
					})

					profiles.widgets.delete = wt.CreateButton({
						parent = panel,
						name = "Delete",
						title = DELETE,
						tooltip = { lines = { { text = wt.strings.profiles.delete.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							offset = { x = -12, y = -21 }
						},
						size = { w = 72, h = 26 },
						action = function() profiles.delete(nil, nil, true) end,
						dependencies = { { frame = profiles.widgets.activate, evaluate = function() return #accountData.profiles > 1 end }, }
					})

					--[ Events ]

					--| UX

					--Update the activation widget UI based on profile data changes
					profiles.setListener.activated(function(_, index) profiles.widgets.activate.setSelected(index, false, true) end)
					profiles.setListener.created(function() profiles.widgets.activate.updateItems(accountData.profiles) end)
					profiles.setListener.renamed(function() profiles.widgets.activate.updateItems(accountData.profiles) end)
					profiles.setListener.deleted(function() profiles.widgets.activate.updateItems(accountData.profiles) end)
					profiles.setListener.reset(function() profiles.widgets.activate.updateItems(accountData.profiles) end)
					profiles.setListener.loaded(function() profiles.widgets.activate.updateItems(accountData.profiles) end)
				end,
			})

			--[ Backup ]

			profiles.backup = {}
			profiles.backupAll = {}

			wt.CreatePanel({
				parent = canvas,
				name = keys[1],
				title = wt.strings.backup.title,
				description = wt.strings.backup.description:gsub("#ADDON", addonTitle),
				arrange = {},
				size = { h = canvas:GetHeight() - profilesPanel:GetHeight() - 118 },
				arrangement = { resize = false, },
				initialize = function(panel)

					--[ Utilities ]

					--Update the backup box and load the current profile data of the selected scope to the backup string, formatted based on the compact setting
					function profiles.backup.refresh()
						profiles.backup.box.setText(us.TableToString(profiles.data, settingsData.compactBackup))

						--Set focus after text change to set the scroll to the top and refresh the position character counter
						profiles.backup.box.scrollframe.EditBox:SetFocus()
						profiles.backup.box.scrollframe.EditBox:ClearFocus()
					end

					--Update the backup box and load all addon profile data of the selected scope to the backup string, formatted based on the compact setting
					function profiles.backupAll.refresh()
						profiles.backupAll.box.setText(us.TableToString({
							activeProfile = characterData.activeProfile,
							profiles = accountData.profiles
						}, settingsData.compactBackup))

						--Set focus after text change to set the scroll to the top and refresh the position character counter
						profiles.backupAll.box.scrollframe.EditBox:SetFocus()
						profiles.backupAll.box.scrollframe.EditBox:ClearFocus()
					end

					--[ Active Profile ]

					profiles.backup.box = wt.CreateMultilineEditbox({
						parent = panel,
						name = "ImportExport",
						title = wt.strings.backup.box.label,
						tooltip = { lines = {
							{ text = wt.strings.backup.box.tooltip[1], },
							{ text = "\n" .. wt.strings.backup.box.tooltip[2], },
							{ text = "\n" .. wt.strings.backup.box.tooltip[3], },
							{ text = wt.strings.backup.box.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 }, },
							{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
						}, },
						arrange = {},
						size = { w = panel:GetWidth() - 24, h = panel:GetHeight() - 60 },
						font = { normal = "GameFontWhiteSmall", },
						scrollSpeed = 0.2,
						scrollToTop = false,
						unfocusOnEnter = false,
						dataManagement = {
							category = category,
							key = keys[1],
						},
						listeners = { loaded = { { handler = profiles.backup.refresh, }, }, },
						showDefault = false,
					})

					profiles.backup.compact = wt.CreateCheckbox({
						parent = panel,
						name = "Compact",
						title = wt.strings.backup.compact.label,
						tooltip = { lines = { { text = wt.strings.backup.compact.tooltip, }, } },
						arrange = {},
						getData = function() return settingsData.compactBackup end,
						saveData = function(state) settingsData.compactBackup = state end,
						dataManagement = {
							category = addon,
							key = keys[1],
							onChange = { RefreshBackupBox = profiles.backup.refresh },
						},
						listeners = { loaded = { { handler = function() profiles.backupAll.compact.button:SetChecked(settingsData.compactBackup) end, }, }, },
						events = { OnClick = function(_, state) profiles.backupAll.compact.button:SetChecked(state) end },
						showDefault = false,
						utilityMenu = false,
					})

					local importPopup = wt.RegisterPopupDialog(addon .. "_IMPORT", {
						text = wt.strings.backup.warning,
						accept = wt.strings.backup.import,
						onAccept = function()
							local success, load = pcall(loadstring("return " .. wt.Clear(profiles.backup.box.getText())))
							success = success and type(load) == "table"

							if success then
								profiles.validate(load, profiles.data)
								us.CopyValues(profiles.data, load)
							end

							t.onImport(success, load)
						end,
					})

					profiles.backup.load = wt.CreateButton({
						parent = panel,
						name = "Load",
						title = wt.strings.backup.load.label,
						tooltip = { lines = {
							{ text = wt.strings.backup.load.tooltip, },
							{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
						} },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = profiles.backup.box.frame,
							relativePoint = "BOTTOMRIGHT",
							offset = { y = -8 }
						},
						size = { h = 26 },
						action = function() StaticPopup_Show(importPopup) end,
					})

					profiles.backup.reset = wt.CreateButton({
						parent = panel,
						name = "Reset",
						title = RESET,
						tooltip = { lines = { { text = wt.strings.backup.reset.tooltip, }, } },
						position = {
							anchor = "RIGHT",
							relativeTo = profiles.backup.load.widget,
							relativePoint = "LEFT",
							offset = { x = -8, }
						},
						size = { h = 26 },
						action = profiles.backup.refresh,
					})

					--[ All Profiles ]

					local allProfilesBackupFrame = wt.CreatePanel({
						parent = canvas,
						name = addon .. "AllProfilesBackup",
						append = false,
						title = wt.strings.backup.allProfiles.label,
						position = { anchor = "BOTTOMRIGHT", offset = { x = 12, y = 1 }, },
						keepInBounds = true,
						size = { w = 678, h = 609 },
						frameStrata = "DIALOG",
						keepOnTop = true,
						background = { color = { a = 0.9 }, },
						arrangement = {
							margins = { l = 16, r = 16, t = 42, b = 16 },
							resize = false,
						},
						initialize = function(windowPanel)
							profiles.backupAll.box = wt.CreateMultilineEditbox({
								parent = windowPanel,
								name = "ImportExportAllProfiles",
								title = wt.strings.backup.allProfiles.label,
								label = false,
								tooltip = { lines = {
									{ text = wt.strings.backup.allProfiles.tooltipLine, },
									{ text = "\n" .. wt.strings.backup.box.tooltip[2], },
									{ text = "\n" .. wt.strings.backup.box.tooltip[3], },
									{ text = wt.strings.backup.box.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 }, },
									{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
								}, },
								arrange = {},
								size = { w = windowPanel:GetWidth() - 32, h = windowPanel:GetHeight() - 92 },
								font = { normal = "GameFontWhiteSmall", },
								scrollSpeed = 0.2,
								scrollToTop = false,
								unfocusOnEnter = false,
								dataManagement = {
									category = category,
									key = keys[1],
								},
								listeners = { loaded = { { handler = profiles.backupAll.refresh, }, }, },
								showDefault = false,
							})

							profiles.backupAll.compact = wt.CreateCheckbox({
								parent = windowPanel,
								name = "Compact",
								title = wt.strings.backup.compact.label,
								tooltip = { lines = { { text = wt.strings.backup.compact.tooltip, }, } },
								arrange = {},
								events = { OnClick = function()
									profiles.backup.compact.toggleState(true)
									profiles.backupAll.refresh()
								end },
								showDefault = false,
								utilityMenu = false,
							})

							wt.CreateButton({
								parent = windowPanel,
								name = "CloseButton",
								title = CLOSE,
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -12, y = -12 },
								},
								size = { w = 96, },
								action = function() windowPanel:Hide() end,
							})

							_G[windowPanel:GetName() .. "Title"]:SetPoint("TOPLEFT", 18, -18)

							windowPanel:EnableMouse(true)
							windowPanel:Hide()
						end,
					})

					wt.CreateButton({
						parent = panel,
						name = "AllProfilesButton",
						title = wt.strings.backup.allProfiles.open.label,
						tooltip = { lines = { { text = wt.strings.backup.allProfiles.open.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = profiles.backup.box.frame,
							relativePoint = "TOPRIGHT",
							offset = { x = -1, y = 2 }
						},
						size = { w = 100, h = 17 },
						frameLevel = profiles.backup.box.frame:GetFrameLevel() + 1, --Make sure it's on top to be clickable
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
						},
						action = function()
							allProfilesBackupFrame:Show()

							profiles.backupAll.compact.setState(settingsData.compactBackup, nil, true)

							profiles.backupAll.refresh()
						end,
					})

					local allProfilesImportPopup = wt.RegisterPopupDialog(addon .. "_IMPORT_ALL", {
						text = wt.strings.backup.warning,
						accept = wt.strings.backup.import,
						onAccept = function()
							local success, data = pcall(loadstring("return " .. wt.Clear(profiles.backupAll.box.getText())))
							data = type(data) == "table" and data or {}

							if success then profiles.load(data.profiles, data.activeProfile, true) end

							t.onImportAllProfiles(success and type(data) == "table", data)
						end,
					})

					profiles.backupAll.load = wt.CreateButton({
						parent = allProfilesBackupFrame,
						name = "Load",
						title = wt.strings.backup.load.label,
						tooltip = { lines = {
							{ text = wt.strings.backup.load.tooltip, },
							{ text = "\n" .. wt.strings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
						} },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = profiles.backupAll.box.frame,
							relativePoint = "BOTTOMRIGHT",
							offset = { y = -8 }
						},
						size = { h = 26 },
						action = function() StaticPopup_Show(allProfilesImportPopup) end,
					})

					profiles.backupAll.reset = wt.CreateButton({
						parent = allProfilesBackupFrame,
						name = "Reset",
						title = RESET,
						tooltip = { lines = { { text = wt.strings.backup.reset.tooltip, }, } },
						position = {
							anchor = "RIGHT",
							relativeTo = profiles.backupAll.load.widget,
							relativePoint = "LEFT",
							offset = { x = -8, }
						},
						size = { h = 26 },
						action = profiles.backupAll.refresh,
					})
				end,
			})
		end end,
	})

	return profiles
end

--[ Addon Manager ]

--| GUI --TODO create utility logical core, add addon-wide preset management capability

---Create and set up a new settings page with about into for an addon
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param t? aboutPageCreationData Optional parameters
---***
---@return settingsPage|nil aboutPage Table containing references to the canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions | ***Default:*** nil
function wt.CreateAboutPage(addon, t)
	if type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) then return nil end

	t = type(t) == "table" and t or {}
	local data = {
		title = C_AddOns.GetAddOnMetadata(addon, "Title"),
		version = C_AddOns.GetAddOnMetadata(addon, "Version"),
		day = C_AddOns.GetAddOnMetadata(addon, "X-Day"),
		month = C_AddOns.GetAddOnMetadata(addon, "X-Month"),
		year = C_AddOns.GetAddOnMetadata(addon, "X-Year"),
		category = C_AddOns.GetAddOnMetadata(addon, "Category"),
		notes = C_AddOns.GetAddOnMetadata(addon, "Notes"),
		author = C_AddOns.GetAddOnMetadata(addon, "Author"),
		license = C_AddOns.GetAddOnMetadata(addon, "X-License"),
		curse = C_AddOns.GetAddOnMetadata(addon, "X-CurseForge"),
		wago = C_AddOns.GetAddOnMetadata(addon, "X-Wago"),
		repo = C_AddOns.GetAddOnMetadata(addon, "X-Repository"),
		issues = C_AddOns.GetAddOnMetadata(addon, "X-Issues"),
		sponsors = C_AddOns.GetAddOnMetadata(addon, "X-Sponsors"),
		topSponsors = C_AddOns.GetAddOnMetadata(addon, "X-TopSponsors"),
		logo = C_AddOns.GetAddOnMetadata(addon, "IconTexture"),
	}

	--[ Settings Page ]

	return wt.CreateSettingsPage(addon, not WidgetToolsDB.lite and next(data) and {
		register = t.register,
		name = t.name or "About",
		title = t.title or data.title,
		description = t.description or data.notes,
		static = t.static ~= false,
		arrangement = {},
		initialize = function(canvas)

			--[ About ]

			wt.CreatePanel({
				parent = canvas,
				name = "About",
				title = wt.strings.about.title,
				description = wt.strings.about.description:gsub("#ADDON", data.title),
				arrange = {},
				size = { h = 240 },
				arrangement = {
					flip = true,
					resize = false
				},
				initialize = function(panel)

					--[ Information ]

					local position = { offset = { x = 16, y = -14 } }

					if data.version then
						local version = wt.CreateText({
							parent = panel,
							name = "VersionTitle",
							position = position,
							width = 48,
							text = wt.strings.about.version,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
							wrap = false,
						})

						wt.CreateText({
							parent = panel,
							name = "Version",
							position = {
								relativeTo = version,
								relativePoint = "TOPRIGHT",
								offset = { x = 5 }
							},
							width = 140,
							text = data.version .. (data.day and data.month and data.year and crc(" ( " .. wt.strings.about.date .. ": " .. cr(wt.strings.date:gsub(
								"#DAY", data.day
							):gsub(
								"#MONTH", data.month
							):gsub(
								"#YEAR", data.year
							), NORMAL_FONT_COLOR) .. ")", "FFFFFFFF") or ""),
							font = "GameFontNormalSmall",
							justify = { h = "LEFT", },
							wrap = false,
						})

						position.relativeTo = version
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -6
					end

					if data.category then
						local category = wt.CreateText({
							parent = panel,
							name = "Category",
							position = position,
							width = 48,
							text = CATEGORY,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
							wrap = false,
						})

						wt.CreateText({
							parent = panel,
							name = "Category",
							position = {
								relativeTo = category,
								relativePoint = "TOPRIGHT",
								offset = { x = 5 }
							},
							width = 140,
							text = data.category,
							font = "GameFontNormalSmall",
							justify = { h = "LEFT", },
						})

						position.relativeTo = category
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -6
					end

					if data.author then
						local author = wt.CreateText({
							parent = panel,
							name = "AuthorTitle",
							position = position,
							width = 48,
							text = wt.strings.about.author,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
						})

						wt.CreateText({
							parent = panel,
							name = "Author",
							position = {
								relativeTo = author,
								relativePoint = "TOPRIGHT",
								offset = { x = 5 }
							},
							width = 140,
							text = data.author,
							font = "GameFontNormalSmall",
							justify = { h = "LEFT", },
							wrap = false,
						})

						position.relativeTo = author
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -6
					end

					if data.license then
						local license = wt.CreateText({
							parent = panel,
							name = "LicenseTitle",
							position = position,
							width = 48,
							text = wt.strings.about.license,
							font = "GameFontHighlightSmall",
							justify = { h = "RIGHT", },
							wrap = false,
						})

						wt.CreateText({
							parent = panel,
							name = "License",
							position = {
								relativeTo = license,
								relativePoint = "TOPRIGHT",
								offset = { x = 5 }
							},
							width = 140,
							text = data.license,
							font = "GameFontNormalSmall",
							justify = { h = "LEFT", },
							wrap = false,
						})

						position.relativeTo = license
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
					end

					--[ Links ]

					if position.relativeTo then position.offset.y = -14 end

					if data.curse then
						local curse = wt.CreateCopybox({
							parent = panel,
							name = "CurseForge",
							title = wt.strings.about.curseForge,
							position = position,
							size = { w = 190, },
							value = data.curse,
						})

						position.relativeTo = curse.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if data.wago then
						local wago = wt.CreateCopybox({
							parent = panel,
							name = "Wago",
							title = wt.strings.about.wago,
							position = position,
							size = { w = 190, },
							value = data.wago,
						})

						position.relativeTo = wago.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if data.repo then
						local repo = wt.CreateCopybox({
							parent = panel,
							name = "Repository",
							title = wt.strings.about.repository,
							position = position,
							size = { w = 190, },
							value = data.repo,
						})

						position.relativeTo = repo.frame
						position.relativePoint = "BOTTOMLEFT"
						position.offset.x = 0
						position.offset.y = -8
					end

					if data.issues then wt.CreateCopybox({
						parent = panel,
						name = "Issues",
						title = wt.strings.about.issues,
						position = position,
						size = { w = 190, },
						value = data.issues,
					}) end

					--[ Changelog ]

					if not t.changelog then return end

					local changelog = wt.CreateMultilineEditbox({
						parent = panel,
						name = "Changelog",
						title = wt.strings.about.changelog.label,
						tooltip = { lines = { { text = wt.strings.about.changelog.tooltip:gsub("#VERSION", crc(data.version, "FFFFFFFF")), }, } },
						arrange = {},
						size = { w = panel:GetWidth() - 225, h = panel:GetHeight() - 25 },
						font = { normal = "GameFontDisableSmall", },
						color = rs.colors.grey[2],
						value = wt.FormatChangelog(t.changelog, true),
						readOnly = true,
					})

					local fullChangelogFrame

					wt.CreateButton({
						parent = panel,
						name = "ChangelogButton",
						title = wt.strings.about.fullChangelog.open.label,
						tooltip = { lines = { { text = wt.strings.about.fullChangelog.open.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = changelog.frame,
							relativePoint = "TOPRIGHT",
							offset = { x = -1, y = 2 }
						},
						size = { w = 100, h = 17 },
						frameLevel = changelog.frame:GetFrameLevel() + 1, --Make sure it's on top to be clickable
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
						},
						action = function() if fullChangelogFrame then fullChangelogFrame:Show() else fullChangelogFrame = wt.CreatePanel({
							parent = canvas,
							name = addon .. "Changelog",
							append = false,
							title = wt.strings.about.fullChangelog.label:gsub("#ADDON", data.title),
							position = { anchor = "BOTTOMRIGHT", offset = { x = 12, y = 1 }, },
							keepInBounds = true,
							size = { w = 678, h = 609 },
							frameStrata = "DIALOG",
							keepOnTop = true,
							background = { color = { a = 0.9 }, },
							arrangement = {
								margins = { l = 16, r = 16, t = 42, b = 16 },
								resize = false,
							},
							initialize = function(windowPanel)
								wt.CreateMultilineEditbox({
									parent = windowPanel,
									name = "FullChangelog",
									title = wt.strings.about.fullChangelog.label:gsub("#ADDON", data.title),
									label = false,
									tooltip = { lines = { { text = wt.strings.about.fullChangelog.tooltip, }, } },
									arrange = {},
									size = { w = windowPanel:GetWidth() - 32, h = windowPanel:GetHeight() - 58 },
									font = { normal = "GameFontDisable", },
									color = rs.colors.grey[2],
									value = wt.FormatChangelog(t.changelog),
									readOnly = true,
									scrollSpeed = 0.2,
								})

								wt.CreateButton({
									parent = windowPanel,
									name = "CloseButton",
									title = CLOSE,
									position = {
										anchor = "TOPRIGHT",
										offset = { x = -12, y = -12 },
									},
									size = { w = 96, },
									action = function() windowPanel:Hide() end,
								})

								_G[windowPanel:GetName() .. "Title"]:SetPoint("TOPLEFT", 18, -18)

								windowPanel:EnableMouse(true)
							end,
						}) end end,
					})
				end,
			})

			--[ Sponsors ]

			if data.topSponsors or data.sponsors then
				local sponsorsPanel = wt.CreatePanel({
					parent = canvas,
					name = "Sponsors",
					title = wt.strings.sponsors.title,
					description = wt.strings.sponsors.description,
					arrange = {},
					size = { h = 46 + (data.topSponsors and data.sponsors and 24 or 0) },
					initialize = function(panel)
						if data.topSponsors then wt.CreateText({
							parent = panel,
							name = "Top",
							position = { offset = { x = 16, y = -12 } },
							width = panel:GetWidth() - 46,
							text = data.topSponsors:gsub("|", " • "),
							font = "GameFontNormalLarge",
							justify = { h = "LEFT", },
						}) end

						if data.sponsors then wt.CreateText({
							parent = panel,
							name = "Normal",
							position = { offset = { x = 16, y = -16 -(data.topSponsors and 24 or 0) } },
							width = panel:GetWidth() - 46,
							text = data.sponsors:gsub("|", " • "),
							font = "GameFontNormalMed1",
							justify = { h = "LEFT", },
						}) end
					end,
				})

				wt.CreateText({
					parent = sponsorsPanel,
					name = "DescriptionHeart",
					position = {
						anchor = "TOPRIGHT",
						offset = { x = -14, y = -12 }
					},
					text = "♥",
					font = "NumberFont_Shadow_Large",
					color = { r = 1, g = 0.4, b = 0.4, }, 
					justify = { h = "LEFT", },
				})
			end
		end,
	} or nil)
end

--[ Position Manager ]

local positioningVisualAids = {}

--| GUI --TODO separate logical core

---Create and set up position management for a specified frame within a panel frame
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param frame AnyFrameObject Reference to the frame to create the settings for
---@param getData fun(): table: positionPresetData Return a reference to the table within a SavedVariables(PerCharacter) addon database where data is committed to
---@param defaultData positionPresetData Reference to the table containing the default values<ul><li>***Note:*** The defaults table should contain values under matching keys to the values within *t.getData()*.</li></ul>
---@param settingsData positionOptionsSettingsData|table Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from<ul><li>***Note:*** A boolean value will be created under the key **keepInPlace** if it didn't already exist in this table.</li></ul>
---@param t positionManagementCreationData Optional parameters
---***
---@return positionPanel? table Components of the settings panel wrapped in a table | ***Default:*** nil
function wt.CreatePositionOptions(addon, frame, getData, defaultData, settingsData, t)
	if not addon or not C_AddOns.IsAddOnLoaded(addon) or not us.IsFrame(frame) or type(t) ~= "table" then return end

	if type(t.name) ~= "string" then t.name = frame:GetName() end
	t.dataManagement = t.dataManagement or {}
	t.dataManagement.category = t.dataManagement.category or addon
	t.dataManagement.key = t.dataManagement.key or "Position"

	---@class positionPanel
	---@field widgets table
	---@field presets? table
	local panel = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "PositionOptions" string
	---<p></p>
	function panel.getType() return "PositionOptions" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function panel.isType(type) return type == "PositionOptions" end

	--[ Visual Aids ]

	if WidgetToolsDB.positioningAids then
		positioningVisualAids.frame = positioningVisualAids.frame or wt.CreateFrame({
			name = "WidgetToolsPositioningVisualAids",
			position = { anchor = "CENTER", },
			size = { w = GetScreenWidth() - 14, h = GetScreenHeight() - 14 },
			visible = false,
			frameStrata = "BACKGROUND",
			initialize = function(container)

				--[ Textures ]

				positioningVisualAids.anchor = positioningVisualAids.anchor or wt.CreateTexture(container, {
					name = "Anchor",
					size = { w = 14, h = 14 },
					path = wt.classic and "Interface/CharacterFrame/TempPortraitAlphaMask" or "Interface/Common/common-mask-diamond",
				})

				positioningVisualAids.relativePoint = positioningVisualAids.relativePoint or wt.CreateTexture(container, {
					name = "RelativePoint",
					size = { w = 14, h = 14 },
					path = not wt.classic and "Interface/Common/common-iconmask" or nil,
				})

				positioningVisualAids.line = positioningVisualAids.line or wt.CreateLine(container, {
					name = "Line",
					startPosition = {
						relativeTo = positioningVisualAids.anchor,
						relativePoint = "CENTER"
					},
					endPosition = {
						relativeTo = positioningVisualAids.relativePoint,
						relativePoint = "CENTER"
					},
					thickness = 2,
					color = { r = 1, g = 1, b = 1, a = 1 }
				})

				--[ Utilities ]

				---Update the visual aid positions
				---@param target AnyFrameObject
				---@param position positionData_base
				function positioningVisualAids.update(target, position)
					--Anchor
					wt.SetPosition(positioningVisualAids.anchor, {
						anchor = "CENTER",
						relativeTo = target,
						relativePoint = position.anchor,
					})

					--Relative Point
					wt.SetPosition(positioningVisualAids.relativePoint, {
						anchor = "CENTER",
						relativeTo = positioningVisualAids.frame,
						relativePoint = position.relativePoint,
					})
				end

				---Show the positioning visual aids for the specified target frame
				---@param target AnyFrameObject
				---@param position positionData_base
				function positioningVisualAids.show(target, position)
					positioningVisualAids.frame:Show()

					--Dimensions
					positioningVisualAids.frame:SetSize(GetScreenWidth() - 14, GetScreenHeight() - 14)
					positioningVisualAids.frame:SetScale(UIParent:GetScale())

					--Points
					positioningVisualAids.update(target, position)
				end
			end
		})

		--[ Toggle ]

		if not WidgetToolsDB.lite then
			t.canvas:HookScript("OnShow", function() positioningVisualAids.show(frame, getData().position) end)
			t.canvas:HookScript("OnHide", function() positioningVisualAids.frame:Hide() end)
		end

		--[ Update Size ]

		us.SetListener(positioningVisualAids.frame, "UI_SCALE_CHANGED", function(f)
			f:SetSize(GetScreenWidth() - 14, GetScreenHeight() - 14)
			f:SetScale(UIParent:GetScale())
		end)
	end

	--[ Options Panel ]

	panel.frame = wt.CreatePanel({
		parent = t.canvas,
		name = "Position",
		title = wt.strings.position.title,
		description = wt.strings.position.description[t.setMovable and "movable" or "static"]:gsub("#FRAME", t.name),
		arrange = {},
		arrangement = {},
		initialize = function(panelFrame)
			panel.widgets = {}

			--[ Presets ]

			if t.presets then
				panel.widgets.presets = {}
				panel.presets = t.presets.items

				--| Utilities

				local applyPreset = function(_, i)
					if not (panel.presets[i] or {}).data then
						--Call the specified handler
						if t.presets.onPreset then t.presets.onPreset(i) end

						return
					end

					--Position
					if type(panel.presets[i].data.position) == "table" then
						--Update the frame
						wt.SetPosition(frame, panel.presets[i].data.position, true)

						--Update the storage
						us.CopyValues(getData().position, wt.PackPosition(frame:GetPoint()))

						--Update the settings widgets
						panel.widgets.position.anchor.loadData(false)
						panel.widgets.position.relativePoint.loadData(false)
						-- panel.widgets.position.relativeTo.loadData(false)
						panel.widgets.position.offset.x.loadData(false)
						panel.widgets.position.offset.y.loadData(false)
					end

					--Keep in bounds
					if panel.presets[i].data.keepInBounds ~= nil then
						frame:SetClampedToScreen(panel.presets[i].data.keepInBounds) --Update the frame
						getData().keepInBounds = panel.presets[i].data.keepInBounds --Update the storage
						if panel.widgets.position.keepInBounds then panel.widgets.position.keepInBounds.loadData(false) end --Update the settings widget
					end

					--Screen Layer
					if type(panel.presets[i].data.layer) == "table" then
						--Frame strata
						if panel.presets[i].data.layer.strata then
							frame:SetFrameStrata(panel.presets[i].data.layer.strata) --Update the frame
							getData().layer.strata = panel.presets[i].data.layer.strata --Update the storage
							if panel.widgets.layer.strata then panel.widgets.layer.strata.loadData(false) end --Update the settings widget
						end

						--Keep on top
						if panel.presets[i].data.layer.keepOnTop ~= nil then
							frame:SetToplevel(panel.presets[i].data.layer.keepOnTop) --Update the frame
							getData().layer.keepOnTop = panel.presets[i].data.layer.keepOnTop --Update the storage
							if panel.widgets.layer.keepOnTop then panel.widgets.layer.keepOnTop.loadData(false) end --Update the settings widget
						end

						--Frame level
						if panel.presets[i].data.layer.level then
							frame:SetFrameLevel(panel.presets[i].data.layer.level) --Update the frame
							getData().layer.level = panel.presets[i].data.layer.level --Update the storage
							if panel.widgets.layer.level then panel.widgets.layer.level.loadData(false) end --Update the settings widget
						end
					end

					--Update the positioning visual aids
					if WidgetToolsDB.positioningAids then positioningVisualAids.update(frame, getData().position) end

					--Call the specified handler
					if t.presets.onPreset then t.presets.onPreset(i) end
				end

				---Apply a specific preset
				--- - ***Note:*** If the addon database position table doesn't contain relative frame and point key, value pairs, the position will be converted to absolute position after being applied.
				---***
				---@param i integer Index of the preset to be applied
				---***
				---@return boolean success Whether or not the preset under the specified index exists and it could be applied
				function panel.applyPreset(i)
					if not i or i < 1 or i > #panel.presets then return false end

					--Apply the preset data to the frame & update the settings widgets
					applyPreset(nil, i)

					return true
				end

				--| Options widgets

				panel.widgets.presets.applyButton, panel.widgets.presets.applyMenu = wt.CreatePopupMenu({
					parent = panelFrame,
					name = "ApplyPreset",
					title = wt.strings.presets.apply.label,
					tooltip = { lines = { { text = wt.strings.presets.apply.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = {},
					initialize = function(menu)
						wt.CreateMenuTextline(menu, { text = wt.strings.presets.apply.select, })

						for i = 1, #panel.presets do wt.CreateMenuButton(menu, {
							title = panel.presets[i].title,
							action = function() panel.applyPreset(i) end,
						}) end
					end,
				})

				--[ Custom Preset ]

				if t.presets.custom then
					t.presets.custom.index = t.presets.custom.index or 1
					t.presets.items[t.presets.custom.index].data = t.presets.custom.getData()

					--| Utilities

					---Save the current position & visibility to the custom preset
					--- - ***Note:*** If the custom preset position data doesn't contain relative frame and point key, value pairs, the position will be converted to absolute position when saved.
					function panel.saveCustomPreset()
						--Update the custom preset
						panel.presets[t.presets.custom.index].data.position = wt.PackPosition(frame:GetPoint())
						if panel.presets[t.presets.custom.index].data.keepInBounds then
							panel.presets[t.presets.custom.index].data.keepInBounds = frame:IsClampedToScreen()
						end
						if (panel.presets[t.presets.custom.index].data.layer or {}).strata then
							panel.presets[t.presets.custom.index].data.layer.strata = frame:GetFrameStrata()
						end
						if (panel.presets[t.presets.custom.index].data.layer or {}).keepOnTop then
							panel.presets[t.presets.custom.index].data.layer.keepOnTop = frame:IsToplevel()
						end
						if (panel.presets[t.presets.custom.index].data.layer or {}).level then
							panel.presets[t.presets.custom.index].data.layer.level = frame:GetFrameLevel()
						end

						--Save the custom preset
						us.CopyValues(t.presets.custom.getData(), panel.presets[t.presets.custom.index].data)
						if t.presets.custom.getData() then us.CopyValues(t.presets.custom.getData(), t.presets.custom.getData()) end

						--Call the specified handler
						if t.presets.custom.onSave then t.presets.custom.onSave() end
					end

					--Reset the custom preset to its default state
					function panel.resetCustomPreset()
						--Reset the custom preset
						panel.presets[t.presets.custom.index].data = us.Clone(t.presets.custom.defaultsTable)

						--Save the custom preset
						us.CopyValues(t.presets.custom.getData(), panel.presets[t.presets.custom.index].data)
						if t.presets.custom.getData() then us.CopyValues(t.presets.custom.getData(), t.presets.custom.getData()) end

						--Call the specified handler
						if t.presets.custom.onReset then t.presets.custom.onReset() end

						--Apply the custom preset
						panel.applyPreset(t.presets.custom.index)
					end

					--| Options Widgets

					local savePopup = wt.RegisterPopupDialog(addon .. "_SAVE_PRESET", {
						text = wt.strings.presets.save.warning:gsub("#CUSTOM", cr(panel.presets[t.presets.custom.index].title, NORMAL_FONT_COLOR)),
						accept = wt.strings.override,
						onAccept = panel.saveCustomPreset,
					})

					panel.widgets.presets.save = wt.CreateButton({
						parent = panelFrame,
						name = "SavePreset",
						title = wt.strings.presets.save.label:gsub("#CUSTOM", panel.presets[t.presets.custom.index].title),
						tooltip = { lines = {
							{ text = wt.strings.presets.save.tooltip:gsub("#FRAME", t.name):gsub("#CUSTOM", panel.presets[t.presets.custom.index].title), },
						} },
						arrange = { wrap = false, },
						size = { w = 170, h = 26 },
						action = function() StaticPopup_Show(savePopup) end,
						dependencies = t.dependencies
					})

					local resetPopup = wt.RegisterPopupDialog(addon .. "_RESET_PRESET_" .. panelFrame:GetName(), {
						text = wt.strings.presets.reset.warning:gsub("#CUSTOM", cr(panel.presets[t.presets.custom.index].title, NORMAL_FONT_COLOR)),
						accept = wt.strings.override,
						onAccept = panel.resetCustomPreset,
					})

					panel.widgets.presets.reset = wt.CreateButton({
						parent = panelFrame,
						name = "ResetPreset",
						title = wt.strings.presets.reset.label:gsub("#CUSTOM", panel.presets[t.presets.custom.index].title),
						tooltip = { lines = { { text = wt.strings.presets.reset.tooltip:gsub("#CUSTOM", panel.presets[t.presets.custom.index].title), }, } },
						arrange = { wrap = false, },
						size = { w = 170, h = 26 },
						action = function() StaticPopup_Show(resetPopup) end,
					})
				end
			end

			--[ Position ]

			panel.widgets.position = { offset = {}, }

			--| Options widgets

			panel.widgets.position.relativePoint = wt.CreateSpecialRadiogroup("anchor", {
				parent = panelFrame,
				name = "RelativePoint",
				title = wt.strings.position.relativePoint.label,
				tooltip = { lines = { { text = wt.strings.position.relativePoint.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = {},
				width = 140,
				dependencies = t.dependencies,
				getData = function() return getData().position.relativePoint end,
				saveData = function(value) getData().position.relativePoint = value end,
				default = defaultData.position.relativePoint,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					onChange = {
						CustomPositionChangeHandler = function() if type(t.onChangePosition) == "function" then t.onChangePosition() end end,
						UpdateFramePosition = function() wt.SetPosition(frame, getData().position, true) end,
						UpdatePositioningVisualAids = function() if WidgetToolsDB.positioningAids then positioningVisualAids.update(frame, getData().position) end end,
					},
				},
			})

			panel.widgets.position.anchor = wt.CreateSpecialRadiogroup("anchor", {
				parent = panelFrame,
				name = "AnchorPoint",
				title = wt.strings.position.anchor.label,
				tooltip = { lines = { { text = wt.strings.position.anchor.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = { wrap = false, },
				width = 140,
				dependencies = t.dependencies,
				getData = function() return getData().position.anchor end,
				saveData = function(value) getData().position.anchor = value end,
				default = defaultData.position.anchor,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					index = 1,
					onChange = {
						"CustomPositionChangeHandler",
						UpdateFrameOffsetsAndPosition = function() if not settingsData.keepInPlace then wt.SetPosition(frame, getData().position, true) else
							local x, y = wt.SetAnchor(frame, getData().position.anchor)

							--Update offsets
							panel.widgets.position.offset.x.setData(x, false)
							panel.widgets.position.offset.y.setData(y, false)
						end end,
						"UpdatePositioningVisualAids"
					},
				},
			})

			panel.widgets.position.keepInPlace = wt.CreateCheckbox({
				parent = panelFrame,
				name = "KeepInPlace",
				title = wt.strings.position.keepInPlace.label,
				tooltip = { lines = { { text = wt.strings.position.keepInPlace.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = { wrap = false, },
				dependencies = t.dependencies,
				getData = function() return settingsData.keepInPlace end,
				saveData = function(state) settingsData.keepInPlace = state end,
				default = true,
				showDefault = false,
				utilityMenu = false,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
				},
			})

			panel.widgets.position.offset.x = wt.CreateSlider({
				parent = panelFrame,
				name = "OffsetX",
				title = wt.strings.position.offsetX.label,
				tooltip = { lines = { { text = wt.strings.position.offsetX.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = {},
				min = -500,
				max = 500,
				fractional = 2,
				step = 1,
				altStep = 25,
				hardStep = false,
				dependencies = t.dependencies,
				getData = function() return getData().position.offset.x end,
				saveData = function(value) getData().position.offset.x = value end,
				default = defaultData.position.offset.x,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					index = 3,
					onChange = {
						"CustomPositionChangeHandler",
						"UpdateFramePosition",
					},
				},
			})

			panel.widgets.position.offset.y = wt.CreateSlider({
				parent = panelFrame,
				name = "OffsetY",
				title = wt.strings.position.offsetY.label,
				tooltip = { lines = { { text = wt.strings.position.offsetY.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = { wrap = false, },
				min = -500,
				max = 500,
				fractional = 2,
				step = 1,
				altStep = 25,
				hardStep = false,
				dependencies = t.dependencies,
				getData = function() return getData().position.offset.y end,
				saveData = function(value) getData().position.offset.y = value end,
				default = defaultData.position.offset.y,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					index = 4,
					onChange = {
						"CustomPositionChangeHandler",
						"UpdateFramePosition",
					},
				},
			})

			if getData().keepInBounds ~= nil then panel.widgets.position.keepInBounds = wt.CreateCheckbox({
				parent = panelFrame,
				name = "KeepInBounds",
				title = wt.strings.position.keepInBounds.label,
				tooltip = { lines = { { text = wt.strings.position.keepInBounds.tooltip:gsub("#FRAME", t.name), }, } },
				arrange = { wrap = false, },
				dependencies = t.dependencies,
				getData = function() return getData().keepInBounds end,
				saveData = function(state) getData().keepInBounds = state end,
				default = defaultData.keepInBounds,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					onChange = {
						CustomKeepInBoundsChangeHandler = function() if type(t.onChangeKeepInBounds) == "function" then t.onChangeKeepInBounds() end end,
						UpdateScreenClamp = function() frame:SetClampedToScreen(getData().keepInBounds) end,
					},
				},
			}) end

			--[ Screen Layer ]

			if getData().layer and next(getData().layer) then
				panel.widgets.layer = {}

				--| Options widgets

				if getData().layer.strata then panel.widgets.layer.strata = wt.CreateSpecialRadiogroup("strata", {
					parent = panelFrame,
					name = "FrameStrata",
					title = wt.strings.layer.strata.label,
					tooltip = { lines = { { text = wt.strings.layer.strata.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = {},
					width = 140,
					dependencies = t.dependencies,
					getData = function() return getData().layer.strata end,
					saveData = function(value) getData().layer.strata = value end,
					default = defaultData.layer.strata,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomStrataChangeHandler = function() if type(t.onChangeStrata) == "function" then t.onChangeStrata() end end,
							UpdateFrameStrata = function() frame:SetFrameStrata(getData().layer.strata) end,
						},
					},
				}) end

				if getData().layer.keepOnTop ~= nil then panel.widgets.layer.keepOnTop = wt.CreateCheckbox({
					parent = panelFrame,
					name = "KeepOnTop",
					title = wt.strings.layer.keepOnTop.label,
					tooltip = { lines = { { text = wt.strings.layer.keepOnTop.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = { wrap = false, },
					dependencies = t.dependencies,
					getData = function() return getData().layer.keepOnTop end,
					saveData = function(state) getData().layer.keepOnTop = state end,
					default = defaultData.layer.keepOnTop,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomKeepOnTopChangeHandler = function() if type(t.onChangeKeepOnTop) == "function" then t.onChangeKeepOnTop() end end,
							UpdateTopLevel = function() frame:SetToplevel(getData().layer.keepOnTop) end,
						},
					},
				}) end

				if getData().layer.level then panel.widgets.layer.level = wt.CreateSlider({
					parent = panelFrame,
					name = "FrameLevel",
					title = wt.strings.layer.level.label,
					tooltip = { lines = { { text = wt.strings.layer.level.tooltip:gsub("#FRAME", t.name), }, } },
					arrange = { wrap = false, },
					min = 0,
					max = 10000,
					step = 1,
					altStep = 100,
					dependencies = t.dependencies,
					getData = function() return getData().layer.level end,
					saveData = function(value) getData().layer.level = value end,
					default = defaultData.layer.level,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomLevelChangeHandler = function() if type(t.onChangeLevel) == "function" then t.onChangeLevel() end end,
							UpdateFrameLevel = function() frame:SetFrameLevel(getData().layer.level) end,
						},
					},
				}) end
			end
		end,
	})

	--[ Movability ]

	if t.setMovable and type(t.setMovable) == "table" then
		t.setMovable.events = t.setMovable.events or {}

		wt.SetMovability(frame, true, {
			modifier = t.setMovable.modifier or "SHIFT",
			triggers = t.setMovable.triggers,
			events = {
				onStart = t.setMovable.events.onStart,
				onMove = t.setMovable.events.onMove,
				onStop = function()
					--Update the storage
					us.CopyValues(getData().position, wt.PackPosition(frame:GetPoint()))

					--Update the settings widgets
					panel.widgets.position.anchor.loadData(false)
					panel.widgets.position.relativePoint.loadData(false)
					-- panel.widgets.position.relativeTo.loadData(false)
					panel.widgets.position.offset.x.loadData(false)
					panel.widgets.position.offset.y.loadData(false)

					--Update the positioning visual aids
					if WidgetToolsDB.positioningAids then positioningVisualAids.update(frame, getData().position) end

					--Call the specified handler
					if t.setMovable.events.onStop then t.setMovable.events.onStop() end
				end,
				onCancel = function()
					--Reset the position
					wt.SetPosition(frame, getData().position, true)

					--Call the specified handler
					if t.setMovable.events.onCancel then t.setMovable.events.onCancel() end
				end
			}
		})
	end

	return panel
end

--[ Font Manager ]

local fonts, fontItems

--| GUI --TODO separate logical core

---Create and set up font management for a specified text object ([FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString)) including access to a font family selector dropdown to pick a custom font from the Widget Tools fonts list
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param textline FontString Reference to the text object to create font options for
---@param getData fun(): table: fontOptionsData Return a reference to the table within a SavedVariables(PerCharacter) addon database where data is committed to
---@param defaultData fontOptionsData Reference to the table containing the default values
---@param t fontManagementCreationData Optional parameters
---***
---@return fontPanel? table References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, a toggle [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table | ***Default:*** nil
function wt.CreateFontOptions(addon, textline, getData, defaultData, t)
	if not addon or not C_AddOns.IsAddOnLoaded(addon) or type(textline) ~= "table" or type(textline.GetFont) ~= "function" or type(t) ~= "table" then return end

	if type(t.name) ~= "string" then t.name = textline:GetName() end
	t.dataManagement = t.dataManagement or {}
	t.dataManagement.category = t.dataManagement.category or addon
	t.dataManagement.key = t.dataManagement.key or "Font"

	---@class fontPanel
	---@field widgets table
	local panel = {}

	--[ Getters & Setters ]

	---Returns the type of this object
	---***
	---@return "FontOptions" string
	---<p></p>
	function panel.getType() return "FontOptions" end

	---Checks and returns if the type of this object is equal to the string provided
	---@param type string|AnyTypeName
	---@return boolean
	---<p></p>
	function panel.isType(type) return type == "FontOptions" end

	--[ Options Panel ]

	panel.frame = wt.CreatePanel({
		parent = t.canvas,
		name = "Font",
		title = wt.strings.font.title,
		arrange = {},
		arrangement = {},
		initialize = function(panelFrame)
			panel.widgets = {}
			local widgetCount = 0

			--| Font family

			if not fonts or not fontItems then
				fontItems = {}

				--| Add base fonts

				fonts = us.Clone(rs.fonts)

				table.insert(fonts, 1, {
					name = wt.strings.font.path.default.label,
					path = STANDARD_TEXT_FONT:gsub("\\", "/"),
				})

				for i = 1, #fonts do
					fontItems[i] = {}
					fontItems[i].title = fonts[i].name
					fontItems[i].tooltip = {
						title = fonts[i].name,
						lines = {
							{ text = fonts[i].path:match(rs.addon) and wt.strings.font.path.otf or wt.strings.font.path.base },
							{ text = "\n" .. wt.strings.font.path.file:gsub("#PATH", crc(fonts[i].path, "FFFFFFFF")), color = { r = 0.4, g = 1, b = 0.4 }, },
						}
					}
				end
				fontItems[1].tooltip.lines[1] = { text = wt.strings.font.path.default.tooltip, }

				--| Add custom fonts

				if type(WidgetToolsDB.customFonts) == "table" then
					for i = 1, #WidgetToolsDB.customFonts do table.insert(fonts, {
						name = WidgetToolsDB.customFonts[i],
						path = "Fonts/" .. WidgetToolsDB.customFonts[i] .. ".ttf",
					}) end

					for i = #fonts - #WidgetToolsDB.customFonts + 1, #fonts do
						fontItems[i] = {}
						fontItems[i].title = fonts[i].name
						fontItems[i].tooltip = {
							title = fonts[i].name,
							lines = {
								{ text = wt.strings.font.path.custom, },
								{ text = "\n" .. wt.strings.font.path.replace:gsub( --TODO update the tooltip when full custom font management support is added
									"#FONTS_DIRECTORY", cr("[WoW]\\Fonts\\", { r = 0.185, g = 0.72, b = 0.84 })
								):gsub("#FILE_CUSTOM", "CUSTOM.ttf") },
								{ text = "\n" .. wt.strings.font.path.reminder, color = { r = 0.89, g = 0.65, b = 0.40 }, }, --TODO update the tooltip when full custom font management support is added
								{ text = "\n" .. wt.strings.font.path.file:gsub("#PATH", crc(fonts[i].path, "FFFFFFFF")), color = { r = 0.4, g = 1, b = 0.4 }, },
							}
						}
					end
				end
			end

			panel.widgets.path = wt.CreateDropdownRadiogroup({
				parent = panelFrame,
				name = "Path",
				title = wt.strings.font.path.label,
				tooltip = { lines = { { text = wt.strings.font.path.tooltip, }, } },
				width = 184,
				arrange = {},
				items = fontItems,
				dependencies = t.dependencies,
				getData = function() return us.FindIndex(fonts, getData().path) end,
				saveData = function(value) getData().path = fonts[value].path end,
				default = us.FindIndex(fonts, defaultData.path),
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					onChange = {
						CustomFontChangeHandler = function() if type(t.onChangeFont) == "function" then t.onChangeFont() end end,
						UpdateTextFont = function() textline:SetFont(getData().path, getData().size, "OUTLINE") end,
						UpdateFontDropdownText = not WidgetToolsDB.lite and function()
							--Update the font of the dropdown toggle button label
							local _, size, flags = panel.widgets.path.toggle.label:GetFont()
							panel.widgets.path.toggle.label:SetFont(fonts[panel.widgets.path.getSelected() or 1].path, size, flags)
						end or nil,
					},
				},
				events = { OnShow = function()
					--Update the font of the dropdown toggle button label
					local _, size, flags = panel.widgets.path.toggle.label:GetFont()
					panel.widgets.path.toggle.label:SetFont(fonts[panel.widgets.path.getSelected() or 1].path, size, flags)
				end },
			})

			--Update the font of the dropdown items
			if panel.widgets.path.frame then
				for i = 1, #panel.widgets.path.toggles do if panel.widgets.path.toggles[i].label then
					local _, size, flags = panel.widgets.path.toggles[i].label:GetFont()
					panel.widgets.path.toggles[i].label:SetFont(fonts[i].path, size, flags)
				end end

				if panel.widgets.path.toggles[1].label then panel.widgets.path.toggles[1].label:SetTextColor(0.4, 1, 0.4) end

				if type(WidgetToolsDB.customFonts) == "table" then for i = #fonts - #WidgetToolsDB.customFonts + 1, #fonts do
					if panel.widgets.path.toggles[i].label then panel.widgets.path.toggles[i].label:SetTextColor(1, 0.4, 0.4) end
				end end
			end

			widgetCount = widgetCount + 1

			--| Size

			panel.widgets.size = wt.CreateSlider({
				parent = panelFrame,
				name = "Size",
				title = wt.strings.font.size.label,
				tooltip = { lines = { { text = wt.strings.font.size.tooltip, }, } },
				arrange = { wrap = false, },
				min = 8,
				max = 64,
				step = 1,
				altStep = 3,
				dependencies = t.dependencies,
				getData = function() return getData().size end,
				saveData = function(value) getData().size = value end,
				default = defaultData.size,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					onChange = {
						CustomSizeChangeHandler = function() if type(t.onChangeSize) == "function" then t.onChangeSize() end end,
						"UpdateTextFont",
					},
				},
			})

			widgetCount = widgetCount + 1

			--| Alignment

			panel.widgets.alignment = {}

			panel.widgets.alignment = wt.CreateSpecialRadiogroup("justifyH", {
				parent = panelFrame,
				name = "Alignment",
				title = wt.strings.font.alignment.label,
				tooltip = { lines = { { text = wt.strings.font.alignment.tooltip, }, } },
				arrange = { wrap = false, },
				width = 140,
				dependencies = t.dependencies,
				getData = function() return getData().alignment end,
				saveData = function(value) getData().alignment = value end,
				default = defaultData.alignment,
				dataManagement = {
					category = t.dataManagement.category,
					key = t.dataManagement.key,
					onChange = {
						CustomAlignmentChangeHandler = function() if type(t.onChangeAlignment) == "function" then t.onChangeAlignment() end end,
						UpdateTextAlignment = function() textline:SetJustifyH(getData().alignment) end,
					},
				},
			})

			widgetCount = widgetCount + 1

			--| Font color

			if type(t.colors) ~= "table" then t.colors = {} end
			local wrapper
			for k, v in pairs(t.colors) do if v.index == 1 then wrapper = k break end end

			---@type (colormanager|colorpicker)[]
			panel.widgets.colors = {}

			for key in pairs(getData().colors) do
				if type(t.colors[key]) ~= "table" then t.colors[key] = {} end

				local name = t.colors[key].name == "string" and t.colors[key].name or (key:sub(1,1):upper() .. key:sub(2))
				local index = type(t.colors[key].index) == "number" and t.colors[key].index + widgetCount or not next(panel.widgets.colors)

				panel.widgets.colors[key] = wt.CreateColorpicker({
					parent = panelFrame,
					name = name .. "Colorpicker",
					title = wt.strings.font.color.label:gsub("#COLOR_TYPE", name),
					tooltip = { lines = { { text = wt.strings.font.color.tooltip:gsub("#COLOR_TYPE", name), }, } },
					arrange = { wrap = wrapper == nil and not next(panel.widgets.colors) or key == wrapper , index = index },
					dependencies = t.dependencies,
					getData = function() return getData().colors[key] end,
					saveData = function(value) getData().colors[key] = value end,
					default = defaultData.colors[key],
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomColorChangeHandler = function() if type(t.onChangeColor) == "function" then t.onChangeColor(key) end end,
							UpdateTextColor = function() textline:SetTextColor(wt.UnpackColor(getData().colors[key])) end,
						},
					},
				})
			end
		end,
	})

	return panel
end