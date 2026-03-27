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


--[[ TABLE MANAGEMENT ]]

---Align all keys in a table to a reference table, filling missing values and removing mismatched or invalid pairs
---***
---@param targetTable table Reference to the table to get into alignment with the sample
---@param tableToSample table Reference to the table to sample keys & data from
---***
---@return table|any targetTable Reference to **targetTable** (it was already overwritten during the operation, no need for setting it again)
function wt.HarmonizeData(targetTable, tableToSample)
	if type(targetTable) ~= "table" then return tableToSample end

	return us.Pull(us.Filter(us.Prune(targetTable), tableToSample), tableToSample) --REPLACE with combined code
end


--[[ DATA MANAGEMENT ]]

--[ Position ]

--| Verification

--ADD position data verification utilities

--| Conversion

---Return a position table used by WidgetTools assembled from the provided values which are returned by [Region:GetPoint(...)](https://warcraft.wiki.gg/wiki/API_Region_GetPoint)
---***
---@param anchor? FramePoint Base anchor point | ***Default:*** "TOPLEFT"
---@param relativeTo? Frame Relative to this Frame or Region
---@param relativePoint? FramePoint Relative anchor point
---@param offsetX? number | ***Default:*** 0
---@param offsetY? number | ***Default:*** 0
---***
---@return positionData # Table containing the position values as used by WidgetTools
---<p></p>
function wt.PackPosition(anchor, relativeTo, relativePoint, offsetX, offsetY)
	return {
		anchor = type(anchor) == "string" and anchor or "TOPLEFT",
		relativeTo = us.IsFrame(relativeTo) and relativeTo or nil,
		relativePoint = type(relativePoint) == "string" and relativePoint or nil,
		offset = offsetX and offsetY and { x = type(offsetX) == "number" and offsetX or 0, y = type(offsetY) == "number" and offsetY or 0 } or nil
	}
end

---Extract, verify and return the position values used by [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) from a position table used by WidgetTools
---***
---@param t? positionData Table containing parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with
---***
---@return FramePoint anchor ***Default:*** "TOPLEFT"
---@return AnyFrameObject|nil relativeTo ***Default:*** "nil" *(anchor relative to screen dimensions)*<ul><li>***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).
---@return FramePoint? relativePoint
---@return number|nil offsetX ***Default:*** 0
---@return number|nil offsetY ***Default:*** 0
---<p></p>
function wt.UnpackPosition(t)
	if type(t) ~= "table" then return "TOPLEFT" end

	t.anchor = type(t.anchor) == "string" and t.anchor or "TOPLEFT"

	if t.relativeTo ~= "nil" then
		if type(t.relativeTo) == "string" then t.relativeTo = us.ToFrame(t.relativeTo) end
		if not us.IsFrame(t.relativeTo) or not (t.relativeTo or {}).GetPoint then t.relativeTo = nil end
	end

	if type(t.offset) ~= "table" then t.offset = {} else
		t.offset.x = type(t.offset.x) == "number" and t.offset.x or 0
		t.offset.y = type(t.offset.y) == "number" and t.offset.y or 0
	end

	return t.anchor, t.relativeTo, t.relativePoint, t.offset.x, t.offset.y
end

--[ Color ]

--| Verification

---Check if a variable is a valid color table
---@param t any
---@return boolean|colorData
function wt.IsColor(t)
	if type(t) ~= "table" then
		ds.Log("Invalid color table: " ..  us.TableToString(t))

		return false
	elseif type(t.r) ~= "number" or t.r < 0 or t.r > 1 then
		ds.Log("Invalid red color value: " .. tostring(t.r))

		return false
	elseif type(t.g) ~= "number" or t.g < 0 or t.g > 1 then
		ds.Log("Invalid green color value: " .. tostring(t.g))

		return false
	elseif type(t.b) ~= "number" or t.b < 0 or t.b > 1 then
		ds.Log("Invalid blue color value: " .. tostring(t.b))

		return false
	elseif (type(t.a) ~= "number" and t.a ~= nil) or t.a < 0 or t.a > 1 then
		ds.Log("Invalid alpha color value: " .. tostring(t.a))

		return false
	end

	return t
end

---Check & silently repair a color data table
---@param color any
---@return boolean|colorData
function wt.VerifyColor(color)
	if type(color) ~= "table" then return { r = 1, g = 1, b = 1, a = 1 } end

	color.r = type(color.r) == "number" and Clamp(color.r, 0, 1) or 1
	color.g = type(color.g) == "number" and Clamp(color.g, 0, 1) or 1
	color.b = type(color.b) == "number" and Clamp(color.b, 0, 1) or 1
	color.a = type(color.a) == "number" and Clamp(color.a, 0, 1) or color.a ~= nil and 1 or nil

	return color
end

--| Conversion

---Return a table constructed from color values
---***
---@param red? number Red | ***Range:*** (0, 1) | ***Default:*** 1
---@param green? number Green | ***Range:*** (0, 1) | ***Default:*** 1
---@param blue? number Blue | ***Range:*** (0, 1) | ***Default:*** 1
---@param alpha? number Opacity | ***Range:*** (0, 1) | ***Default:*** 1
---***
---@return colorData # Table containing the color values
function wt.PackColor(red, green, blue, alpha)
	return {
		r = type(red) == "number" and Clamp(red, 0, 1) or 1,
		g = type(green) == "number" and Clamp(green, 0, 1) or 1,
		b = type(blue) == "number" and Clamp(blue, 0, 1) or 1,
		a = type(alpha) == "number" and Clamp(alpha, 0, 1) or 1
	}
end

---Extract, verify and return the color values found in a table
---***
---@param color? colorData|colorRGBA Table containing the color values | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
---@param alpha? boolean Specify whether to return the full RGBA set or just the RGB values | ***Default:*** true
---***
---@return number r Red | ***Range:*** (0, 1) | ***Default:*** 1
---@return number g Green | ***Range:*** (0, 1) | ***Default:*** 1
---@return number b Blue | ***Range:*** (0, 1) | ***Default:*** 1
---@return number|nil a Opacity | ***Range:*** (0, 1) | ***Default:*** 1
function wt.UnpackColor(color, alpha)
	if type(color) ~= "table" then return 1, 1, 1, 1 end

	local r = type(color.r) == "number" and Clamp(color.r, 0, 1) or 1
	local g = type(color.g) == "number" and Clamp(color.g, 0, 1) or 1
	local b = type(color.b) == "number" and Clamp(color.b, 0, 1) or 1
	local a = type(color.a) == "number" and Clamp(color.a, 0, 1) or 1

	if alpha ~= false then return r, g, b, a else return r, g, b end
end

---Convert RGB(A) color values in Range: (0, 1) to HEX color code
---***
---@param color? colorData|colorRGBA The RGB(A) color data with all channels in Range: (0, 1) | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
---@param alphaFirst? boolean Put the alpha value first: ARGB output instead of RGBA | ***Default:*** false
---@param hashtag? boolean Whether to add a "#" to the beginning of the color description | ***Default:*** true
---***
---@return string hex Color code in HEX format<ul><li>***Examples:***<ul><li>**RGB:** "#2266BB"</li><li>**RGBA:** "#2266BBAA"</li></ul></li></ul>
function wt.ColorToHex(color, alphaFirst, hashtag)
	local hex = hashtag ~= false and "#" or ""

	if type(color) ~= "table" then return hex .. "FFFFFFFF" end

	local r = type(color.r) == "number" and string.format("%02x", math.ceil(color.r * 255)) or "FF"
	local g = type(color.g) == "number" and string.format("%02x", math.ceil(color.g * 255)) or "FF"
	local b = type(color.b) == "number" and string.format("%02x", math.ceil(color.b * 255)) or "FF"
	local a = type(color.a) == "number" and string.format("%02x", math.ceil(color.a * 255)) or "FF"

	if alphaFirst then hex = hex .. a end
	hex = hex .. r .. g .. b
	if not alphaFirst then hex = hex .. a end

	return hex:upper()
end

---Convert a HEX color code into RGB or RGBA in Range: (0, 1)
---***
---@param hex string String in HEX color code format<ul><li>***Examples:***<ul><li>**RGB:** "#2266BB" (where the "#" is optional)</li><li>**RGBA:** "#2266BBAA" (where the "#" is optional)</li></ul></li></ul>
---***
---@return number r Red | ***Range:*** (0, 1) | ***Default:*** 1
---@return number g Green  | ***Range:*** (0, 1) | ***Default:*** 1
---@return number b Blue | ***Range:*** (0, 1) | ***Default:*** 1
---@return number|nil a Alpha | ***Range:*** (0, 1)
function wt.HexToColor(hex)
	if type(hex) ~= "string" then return 1, 1, 1 else hex = hex:gsub("#", "") end

	local r = tonumber(hex:sub(1, 2), 16) / 255
	local g = tonumber(hex:sub(3, 4), 16) / 255
	local b = tonumber(hex:sub(5, 6), 16) / 255

	if hex:len() == 8 then return r, g, b, tonumber(hex:sub(7, 8), 16) / 255 else return r, g, b end
end

---Brighten or darken the RGB values of a color by an exponent
---***
---@param color colorData|colorRGBA|any Table containing the color values
---@param exponent? number ***Default:*** 0.55<ul><li>***Note:*** Values greater than 1 darken, smaller than 1 brighten the color.</li></ul>
---***
---@return colorData|colorRGBA|any color Reference to **color** (it was already updated during the operation, no need for setting it again)
function wt.AdjustGamma(color, exponent)
	if type(color) ~= "table" then return color end

	exponent = type(exponent) == "number" and exponent or 0.55

	if type(color.r) == "number" then color.r = color.r ^ exponent end
	if type(color.g) == "number" then color.g = color.g ^ exponent end
	if type(color.b) == "number" then color.b = color.b ^ exponent end

	return color
end


--[[ FORMATTING ]]

--[ Escape Sequences ]

---Create a markup texture string snippet via escape sequences based on the specified values
---***
---@param path string Path to the specific texture file relative to the root directory of the specific WoW client<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
---@param width? number ***Default:*** *width of the texture file*
---@param height? number ***Default:*** **width**
---@param offsetX? number | ***Default:*** 0
---@param offsetY? number | ***Default:*** 0
---@param t? table Additional parameters are to be provided in this table
---***
---@return string # ***Default:*** ""
function wt.Texture(path, width, height, offsetX, offsetY, t)
	if type(path) ~= "string" then return "" end

	if type(width) ~= "number" then width = nil end
	if type(height) ~= "number" then width = nil end
	if type(offsetX) ~= "number" then width = nil end
	if type(offsetY) ~= "number" then width = nil end

	if type(t) == "table" then
		return CreateSimpleTextureMarkup(path, height, width, offsetX, offsetY) --REPLACE with [CreateTextureMarkup](https://warcraft.wiki.gg/wiki/FrameXML_functions#:~:text=(role)-,CreateTextureMarkup,-(file%2C%20fileWidth)
	else return CreateSimpleTextureMarkup(path, height, width, offsetX, offsetY) end
end

---Remove most visual formatting (like coloring) & other (like hyperlink) [escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences) from a string
--- - ***Note:*** *Grammar* escape sequences are not yet supported, and will not be removed.
---@param s string
---@return string s
function wt.Clear(s)
	if type(s) ~= "string" then return s end

	s = s:gsub(
		"|c%x%x%x%x%x%x%x%x", ""
	):gsub(
		"|r", ""
	):gsub(
		"|H.-|h(.-)|h", "%1"
	):gsub(
		"|H.-|h", ""
	):gsub(
		"|T.-|t", ""
	):gsub(
		"|n", "\n"
	):gsub(
		"||", "|"
	):gsub(
		"{%a+}", ""
	):gsub(
		"{rt%d}", ""
	)

	return s
end

---Get an assembled & fully formatted string of a specifically assembled changelog table
---***
---@param changelog { [table[]] : string[] } String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included<ul><li>***Note:*** The first line in version tables is expected to be the title containing the version number and/or the date of release.</li><li>***Note:*** Version tables are expected to be listed in descending order by date of release (latest release first).</li><li>***Examples:***<ul><li>**Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)</li><li>**Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)</li><li>**Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)</li><li>**Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)</li><li>**Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)</li><li>**Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
---@param latest? boolean Whether to get the update notes of the latest version or the entire changelog | ***Default:*** false<ul><li>***Note:*** If true, the first line (expected to be the title containing the version number and/or release date) of the of the last version table will be omitted from the final formatted text returned, only including the update notes themselves.</li></ul>
---***
---@return string c # ***Default:*** ""
function wt.FormatChangelog(changelog, latest)
	local highlight = "FFFFFFFF"
	local new = "FF66EE66"
	local fix = "FFEE4444"
	local change = "FF8888EE"
	local note = "FFEEEE66"

	local c = ""

	if type(changelog) == "table" then for i = 1, #changelog do
		local firstLine = latest and 2 or 1

		for j = firstLine, #changelog[i] do
			c = c .. (j > firstLine and "\n\n" or "") .. changelog[i][j]:gsub(
				"#V_(.-)_#", (i > 1 and "\n\n\n" or "") .. "|c" .. highlight .. "• %1|r"
			):gsub(
				"#N_(.-)_#", "|c".. new .. "%1|r"
			):gsub(
				"#F_(.-)_#", "|c".. fix .. "%1|r"
			):gsub(
				"#C_(.-)_#", "|c".. change .. "%1|r"
			):gsub(
				"#O_(.-)_#", "|c".. note .. "%1|r"
			):gsub(
				"#H_(.-)_#", "|c".. highlight .. "%1|r"
			)
		end

		if latest then break end
	end end

	return c
end

--[ Hyperlinks ]

---Format a clickable hyperlink text via escape sequences
---***
---@param linkType ExtendedHyperlinkType [Type of the hyperlink](https://warcraft.wiki.gg/wiki/Hyperlinks#Types) determining how it's being handled and what payload it carries
---@param content? string A colon-separated chain of parameters determined by **type** (Example: "content1:content2:content3") | ***Default:*** ""
---@param text string Clickable text to be displayed as the hyperlink
---***
---@return string # ***Default:*** ""
---<p></p>
function wt.Hyperlink(linkType, content, text)
	if not linkType or not content or not text then return "" else return "\124H" .. linkType .. ":" .. (content or "") .. "\124h" .. text .. "\124h" end
end

---Format a custom clickable addon hyperlink text via escape sequences
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param type? string A unique key signifying the type of the hyperlink specific to the addon (if the addon handles multiple different custom types of hyperlinks) in order to be able to set unique hyperlink click handlers via ***WidgetToolbox*.SetHyperlinkHandler(...)** | ***Default:*** "-"
---@param content? string A colon-separated chain of data strings carried by the hyperlink to be provided to the handler function (Example: "content1:content2:content3") | ***Default:*** ""
---@param text string Clickable text to be displayed as the hyperlink
function wt.CustomHyperlink(addon, type, content, text)
	if not addon then return "" else return wt.Hyperlink("addon", addon .. ":" .. (type or "-") .. ":" .. (content or ""), text) end
end

--Hyperlink handler script registry
local hyperlinkHandlers = {}

---Register a function to handle custom hyperlink clicks
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)<ul><li>***Note:*** Duplicate addon key that already had rules registered under will be overwritten.</li></ul>
---@param linkType? string Unique custom hyperlink type key used to identify the specific handler function | ***Default:*** "-"
---@param handler fun(...) Function to be called with the list of content data strings carried by the hyperlink returned one by one when clicking on a hyperlink text created via ***WidgetToolbox*.CustomHyperlink(...)**
function wt.SetHyperlinkHandler(addon, linkType, handler)
	if type(addon) ~= "string" or type(handler) ~= "function" then return end

	---Call the handler function if it has been registered
	---@param addonID string
	---@param handlerID string
	---@param payload string
	local function callHandler(addonID, handlerID, payload)
		local handlerFunction = us.FindValue(us.FindValue(hyperlinkHandlers, addonID), handlerID)

		if handlerFunction then handlerFunction(strsplit(":", payload)) end
	end

	--Hook the hyperlink handler caller
	if not next(hyperlinkHandlers) then
		if wt.classic then hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(_, ...)
			local _, addonID, handlerID, payload = strsplit(":", ..., 4)

			callHandler(addonID, handlerID, payload)
		end) else EventRegistry:RegisterCallback("SetItemRef", function(_, ...)
			local type, addonID, handlerID, payload = strsplit(":", ..., 4)

			if type == "addon" then callHandler(addonID, handlerID, payload) end
		end) end
	end

	--Add the hyperlink handler function to the registry
	if not hyperlinkHandlers[addon] then hyperlinkHandlers[addon] = {} end
	hyperlinkHandlers[addon][linkType or "-"] = handler
end


--[[ WIDGET MANAGEMENT ]]

---Check if a variable is a recognizable WidgetTools custom table
---@param t any
---***
---@return boolean|AnyTypeName # Return the type name of the object if recognized, false if not
---<p></p>
function wt.IsWidget(t)
	return type(t) == "table" and t.isType and t.getType and t.getType() or false
end


--[[ FRAME MANAGEMENT ]]

--| Position

--Used for a transitional step to avoid anchor family connections during safe frame positioning
local positioningAid

---Set the position and anchoring of a frame when it is unknown which parameters will be nil
---***
---@param frame AnyFrameObject Reference to the frame to be moved
---@param position? positionData Table of parameters to call **frame**:[SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
---@param unlink? boolean If true, unlink the position of **frame** from **position.relativeTo** (preventing anchor family connections) by moving a positioning aid frame to **position** first, convert its position to absolute, breaking relative links (making it relative to screen points instead), then move **frame** to the position of the aid | ***Default:*** false
---@param userPlaced? boolean Remember the position if **frame**:[IsMovable()](https://warcraft.wiki.gg/wiki/API_Frame_IsMovable) | ***Default:*** true
function wt.SetPosition(frame, position, unlink, userPlaced)
	if not us.IsFrame(frame) or not frame.SetPoint then return end

	local anchor, relativeTo, relativePoint, offsetX, offsetY = wt.UnpackPosition(position)
	relativeTo = relativeTo ~= "nil" and relativeTo or nil

	--Set the position
	if relativeTo and unlink then
		if not positioningAid then
			positioningAid = CreateFrame("Frame", rs.addon .. "PositioningAid", UIParent)

			positioningAid:Hide()
		end

		positioningAid:SetSize(frame:GetSize())

		--[ Position the Aid ]

		positioningAid:ClearAllPoints()

		if (not relativeTo and not relativePoint) and (not offsetX and not offsetY) then positioningAid:SetPoint(anchor)
		elseif not relativeTo and not relativePoint then positioningAid:SetPoint(anchor, offsetX, offsetY)
		elseif not offsetX and not offsetY then positioningAid:SetPoint(anchor, relativeTo, relativePoint or anchor)
		else positioningAid:SetPoint(anchor, relativeTo, relativePoint or anchor, offsetX, offsetY) end

		wt.ConvertToAbsolutePosition(positioningAid, true)

		--[ Position the Frame ]

		frame:ClearAllPoints()

		frame:SetPoint(positioningAid:GetPoint())
	else
		frame:ClearAllPoints()

		if (not relativeTo and not relativePoint) and (not offsetX and not offsetY) then frame:SetPoint(anchor)
		elseif not relativeTo and not relativePoint then frame:SetPoint(anchor, offsetX, offsetY)
		elseif not offsetX and not offsetY then frame:SetPoint(anchor, relativeTo, relativePoint or anchor)
		else frame:SetPoint(anchor, relativeTo, relativePoint or anchor, offsetX, offsetY) end
	end

	--Set user placed
	if frame.SetUserPlaced and frame:IsMovable() then frame:SetUserPlaced(userPlaced ~= false) end
end

---Set the anchor of a frame while keeping its positioning by updating its relative offsets
---***
---@param frame AnyFrameObject Reference to the frame to be update
---@param anchor FramePoint New anchor point to set
---***
---@return number? offsetX The new horizontal offset value | ***Default:*** nil
---@return number? offsetY The new vertical offset value | ***Default:*** nil
---<p></p>
function wt.SetAnchor(frame, anchor)
	if not us.IsFrame(frame) or type(anchor) ~= "string" then return end

	local oldAnchor, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
	local x, y = 0, 0

	if oldAnchor:find("LEFT") then
		if anchor:find("RIGHT") then x = -frame:GetWidth() elseif anchor == "CENTER" or anchor == "TOP" or anchor == "BOTTOM" then x = -frame:GetWidth() / 2 end
	elseif oldAnchor:find("RIGHT") then
		if anchor:find("LEFT") then x = frame:GetWidth() elseif anchor == "CENTER" or anchor == "TOP" or anchor == "BOTTOM" then x = frame:GetWidth() / 2 end
	elseif oldAnchor == "CENTER" or oldAnchor == "TOP" or oldAnchor == "BOTTOM" then
		if anchor:find("LEFT") then x = frame:GetWidth() / 2 elseif anchor:find("RIGHT") then x = -frame:GetWidth() / 2 end
	end
	if oldAnchor:find("TOP") then
		if anchor:find("BOTTOM") then y = frame:GetHeight() elseif anchor == "CENTER" or anchor == "LEFT" or anchor == "RIGHT" then y = frame:GetHeight() / 2 end
	elseif oldAnchor:find("BOTTOM") then
		if anchor:find("TOP") then y = -frame:GetHeight() elseif anchor == "CENTER" or anchor == "LEFT" or anchor == "RIGHT" then y = -frame:GetHeight() / 2 end
	elseif oldAnchor == "CENTER" or oldAnchor == "LEFT" or oldAnchor == "RIGHT" then
		if anchor:find("TOP") then y = -frame:GetHeight() / 2 elseif anchor:find("BOTTOM") then y = frame:GetHeight() / 2 end
	end

	offsetX = offsetX - x
	offsetY = offsetY - y

	frame:SetPoint(anchor, relativeTo, relativePoint, offsetX, offsetY)

	return offsetX, offsetY
end

---Convert the position of a frame positioned relative to another to absolute position (making it relative to screen points, the UIParent instead)
---***
---@param frame AnyFrameObject Reference to the frame the position of which to be converted to absolute position
---@param keepAnchor? boolean If true, restore the original anchor of **frame** (as its closest anchor to the nearest screen point will be chosen after conversion) | ***Default:*** true
function wt.ConvertToAbsolutePosition(frame, keepAnchor)
	if not us.IsFrame(frame) or not frame.IsMovable then return end

	local movable = frame:IsMovable()
	local oldAnchor = frame:GetPoint()

	--Unlink relative anchoring
	frame:SetMovable(true)
	frame:StartMoving()
	frame:StopMovingOrSizing()

	--Restore movability
	frame:SetMovable(movable)

	if keepAnchor == false then return end

	--Restore frame anchoring
	wt.SetAnchor(frame, oldAnchor)
end

---Arrange the child frames of a container frame into stacked rows based on the parameters provided
--- - ***Note:*** The frames will be arranged into columns based on the the number of child frames assigned to a given row, anchored to "TOPLEFT", "TOP" and "TOPRIGHT" in order (by default) up to 3 frames. Columns in rows with more frames will be attempted to be spaced out evenly between the frames placed at the main 3 anchors.
---***
---@param container Frame Reference to the parent container frame the child frames of which are to be arranged based on the description in **arrangement**
---@param t? arrangementData Arrange the child frames of **container** based on the specifications provided in this table
function wt.ArrangeContent(container, t)
	if not us.IsFrame(container) then return end

	t = type(t) == "table" and t or {}
	t.margins = t.margins or {}
	t.margins = { l = t.margins.l or 12, r = t.margins.r or 12, t = t.margins.t or 12, b = t.margins.b or 12 }
	if t.flip then
		local temp = t.margins.l
		t.margins.l = t.margins.r
		t.margins.r = temp
	end
	t.gaps = t.gaps or 8
	local flipper = t.flip and -1 or 1
	local height = t.margins.t

	---@class arrangedFrame
	---@field arrangementInfo? arrangementRules These parameters specify how to position the panel within its parent container frame during automatic content arrangement

	---@type (arrangedFrame|Frame)[]
	local frames = { container:GetChildren() }

	--Assemble the arrangement descriptions
	if not t.order then
		t.order = {}

		--Check the child frames for descriptions
		for i = 1, #frames do if frames[i].arrangementInfo then
			if frames[i].arrangementInfo.newRow ~= false or #t.order == 0 then table.insert(t.order, { i })
			elseif t.margins.l + t.margins.r + #t.order * t.gaps + frames[i]:GetWidth() >= container:GetWidth() then table.insert(t.order, { i }) else
				--Assign row
				frames[i].arrangementInfo.row = frames[i].arrangementInfo.row and (
					frames[i].arrangementInfo.row < #t.order and frames[i].arrangementInfo.row
				) or #t.order

				--Assign column
				frames[i].arrangementInfo.column = frames[i].arrangementInfo.column and (
					frames[i].arrangementInfo.column <= #t.order[frames[i].arrangementInfo.row or 1] and frames[i].arrangementInfo.column
				) or #t.order[frames[i].arrangementInfo.row or 1] + 1

				--To be place in the specified spot
				table.insert(t.order[frames[i].arrangementInfo.row], frames[i].arrangementInfo.column, i)
			end
		end end
	end

	--Arrange the frames in each row
	for i = 1, #t.order do
		local rowHeight = 0

		--Find the tallest widget
		for j = 1, #t.order[i] do
			local frameHeight = frames[t.order[i][j]]:GetHeight()
			if frameHeight > rowHeight then rowHeight = frameHeight end

			--Clear positions
			frames[t.order[i][j]]:ClearAllPoints()
		end

		--Increase the content height by the space between rows
		height = height + (i > 1 and t.gaps or 0)

		--First frame goes to the top left (or right if flipped)
		frames[t.order[i][1]]:SetPoint(t.flip and "TOPRIGHT" or "TOPLEFT", t.margins.l * flipper, -height)

		--Place the rest of the frames
		if #t.order[i] > 1 then
			local odd = #t.order[i] % 2 ~= 0

			--Middle frame goes to the top center
			local two = #t.order[i] == 2
			if odd or two then frames[t.order[i][two and 2 or math.ceil(#t.order[i] / 2)]]:SetPoint("TOP", container, "TOP", 0, -height) end

			if #t.order[i] > 2 then
				--Last frame goes to the top right (or left if flipped)
				frames[t.order[i][#t.order[i]]]:SetPoint(t.flip and "TOPLEFT" or "TOPRIGHT", -t.margins.r * flipper, -height)

				--Fill the space between the main anchor points with the remaining frames
				if #t.order[i] > 3 then
					local shift = odd and 0 or 0.5
					local w = container:GetWidth() / 2
					local n = (#t.order[i] - (odd and 1 or 0)) / 2 - shift
					local leftFillWidth = (w - frames[t.order[i][1]]:GetWidth() / 2 - t.margins.l) / -n * flipper
					local rightFillWidth = (w - frames[t.order[i][#t.order[i]]]:GetWidth() / 2 - t.margins.r) / n * flipper

					--Fill the left half
					local last = math.floor(#t.order[i] / 2)
					for j = 2, last do frames[t.order[i][j]]:SetPoint("TOP", leftFillWidth * (math.abs(last - j) + (1 - shift)), -height) end

					--Fill the right half
					local first = math.ceil(#t.order[i] / 2) + 1
					for j = first, #t.order[i] - 1 do frames[t.order[i][j]]:SetPoint("TOP", rightFillWidth * (math.abs(first - j) + (1 - shift)), -height) end
				end
			end
		end

		--Increase the content height by the row height
		height = height + rowHeight
	end

	--Set the height of the container frame
	if t.resize ~= false then container:SetHeight(height + t.margins.b) end
end

---Set the movability of a frame based in the specified values
---***
---@param frame AnyFrameObject Reference to the frame to make movable/unmovable
---@param movable? boolean Whether to make the frame movable or unmovable | ***Default:*** false
---@param t? movabilityData When specified, set **frame** as movable, dynamically updating the position settings widgets when it's moved by the user
function wt.SetMovability(frame, movable, t)
	if not us.IsFrame(frame) or not frame.SetMovable then return end

	movable = movable == true
	t = type(t) == "table" and t or {}
	local triggers = type(t.triggers) == "table" and t.triggers or { frame }
	local events = type(t.events) == "table" and t.events or {}
	local modifier = type(t.modifier) == "string" and t.modifier or nil
	local cursor = t.cursor
	if type(cursor) ~= "boolean" then cursor = t.modifier ~= nil end
	local position

	frame:SetMovable(movable)

	if movable then
		local hadEvent, isMoving

		position = wt.PackPosition(frame:GetPoint())

		--Toggle movement cursor
		if modifier then
			hadEvent = frame:IsEventRegistered("MODIFIER_STATE_CHANGED")

			frame:HookScript("OnEvent", function(_, event, key, down) if event == "MODIFIER_STATE_CHANGED" and key:find(modifier) then
				if down > 0 then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") else SetCursor(nil) end
			end end)
		end

		for i = 1, #triggers do
			triggers[i]:EnableMouse(true)

			--| Cursor

			--Set movement cursor
			triggers[i]:HookScript("OnEnter", function()
				if not cursor or not frame:IsMovable() then return end

				if not modifier then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") else
					if us.isKeyDown[modifier]() then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") end

					frame:RegisterEvent("MODIFIER_STATE_CHANGED")
				end
			end)

			--Reset cursor
			triggers[i]:HookScript("OnLeave", function()
				if not cursor or not frame:IsMovable() then return end

				SetCursor(nil)

				if modifier and not hadEvent then frame:UnregisterEvent("MODIFIER_STATE_CHANGED") end
			end)


			--| Movement

			triggers[i]:HookScript("OnMouseDown", function()
				if not frame:IsMovable() or isMoving then return end
				if modifier and not us.isKeyDown[modifier]() then return end

				--Store position
				position = wt.PackPosition(frame:GetPoint())

				--Start moving
				frame:StartMoving()
				isMoving = true
				if type(events.onStart) == "function" then events.onStart() end

				--| Start the movement updates

				if triggers[i]:HasScript("OnUpdate") then triggers[i]:SetScript("OnUpdate", function()
					if type(events.onMove) == "function" then events.onMove() end

					--Check if the modifier key is pressed
					if modifier then
						if us.isKeyDown[modifier]() then return end

						--Cancel when the modifier key is released
						frame:StopMovingOrSizing()
						isMoving = false
						if type(events.onCancel) == "function" then events.onCancel() end

						--Reset the position
						wt.SetPosition(frame, position)

						--Stop checking if the modifier key is pressed
						triggers[i]:SetScript("OnUpdate", nil)
					end
				end) end
			end)

			triggers[i]:HookScript("OnMouseUp", function()
				if not frame:IsMovable() or not isMoving then return end

				--Stop moving
				frame:StopMovingOrSizing()
				isMoving = false
				if type(events.onStop) == "function" then events.onStop() end

				--Stop the movement updates
				if triggers[i]:HasScript("OnUpdate") then triggers[i]:SetScript("OnUpdate", nil) end
			end)

			triggers[i]:HookScript("OnHide", function()
				if not frame:IsMovable() or not isMoving then return end

				--Cancel moving
				frame:StopMovingOrSizing()
				isMoving = false
				if type(events.onCancel) == "function" then events.onCancel() end

				--Reset the position
				wt.SetPosition(frame, position)

				--Stop the movement updates
				if triggers[i]:HasScript("OnUpdate") then triggers[i]:SetScript("OnUpdate", nil) end
			end)
		end
	else for i = 1, #triggers do triggers[i]:EnableMouse(false) end end
end

--| Visibility

---Set the visibility of a frame based on the value provided
---***
---@param frame AnyFrameObject Reference to the frame to hide or show
---@param visible? boolean If false, hide the frame, show it if true | ***Default:*** false
function wt.SetVisibility(frame, visible)
	if not us.IsFrame(frame) then return end

	if visible then frame:Show() else frame:Hide() end
end

--| Backdrop

---Set the backdrop of a frame with BackdropTemplate with the specified parameters
---***
---@param frame backdropFrame|AnyFrameObject Reference to the frame to set the backdrop of<ul><li>***Note:*** The template of **frame** must have been set as: `BackdropTemplateMixin and "BackdropTemplate"`.</li></ul>
---@param backdrop? backdropData Parameters to set the custom backdrop with | ***Default:*** nil *(remove the backdrop)*
---@param updates? backdropUpdateRule[] Table of backdrop update rules, modifying the specified parameters on trigger<ul><li>***Note:*** All update rules are additive, calling ***WidgetToolbox*.SetBackdrop(...)** multiple times with **updates** specified *will not* override previously set update rules. The base **backdrop** values used for these old rules *will not* change by setting a new backdrop via ***WidgetToolbox*.SetBackdrop(...)** either!</li></ul>
function wt.SetBackdrop(frame, backdrop, updates)
	if not us.IsFrame(frame) or not frame.SetBackdrop then return end

	--[ Set Backdrop ]

	---@param t? backdropData
	local function setBackdrop(t)
		if type(t) ~= "table" then
			frame:ClearBackdrop()

			return
		end

		t.background = type(t.background) == "table" and t.background or {}
		t.border = type(t.border) == "table" and t.border or {}
		t.background.texture = type(t.background.texture) == "table" and t.background.texture or {}
		t.background.texture.insets = type(t.background.texture.insets) == "table" and t.background.texture.insets or {}
		t.border.texture = type(t.border.texture) == "table" and t.border.texture or {}

		if next(t.background.texture) or next(t.border.texture) then frame:SetBackdrop({
			bgFile = next(t.background.texture) and (t.background.texture.path or "Interface/ChatFrame/ChatFrameBackground") or nil,
			tile = t.background.texture.tile ~= false,
			tileSize = t.background.texture.size,
			insets = {
				left = t.background.texture.insets.l or 0,
				right = t.background.texture.insets.r or 0,
				top = t.background.texture.insets.t or 0,
				bottom = t.background.texture.insets.b or 0
			},
			edgeFile = next(t.border.texture) and (t.border.texture.path or "Interface/Tooltips/UI-Tooltip-Border") or nil,
			edgeSize = t.border.texture.width
		}) end
		if t.background.color then frame:SetBackdropColor(wt.UnpackColor(t.background.color)) end
		if t.border.color then frame:SetBackdropBorderColor(wt.UnpackColor(t.border.color)) end
	end

	--Set the base backdrop
	setBackdrop(backdrop)

	--[ Backdrop Updates ]

	if type(updates) == "table" then for i = 1, #updates do
		if type(updates[i].triggers) ~= "table" or not next(updates[i].triggers) then updates[i].triggers = { frame } end

		for key, value in pairs(updates[i].rules) do
			local function updater(self, ...)
				--Unconditional: Restore the base backdrop on event trigger
				if type(value) ~= "function" then
					setBackdrop(backdrop)

					return
				end

				--Conditional: Evaluate the rule
				local backdropUpdate, fill = value(frame, self, ...)

				--Remove the backdrop
				if type(backdropUpdate) ~= "table" then
					setBackdrop(nil)

					return
				end

				--Restore the base backdrop or do nothing on evaluation
				if not next(backdropUpdate) then if fill then
					setBackdrop(backdrop)

					return
				else return end end

				--Fill defaults
				if fill then
					--Fill backdrop update table with the base backdrop values
					backdropUpdate = backdrop and us.Fill(backdropUpdate, backdrop) or nil
				else
					--Fill backdrop update table with the current values
					if frame.backdropInfo then
						--Background
						backdropUpdate.background = backdropUpdate.background or {}
						backdropUpdate.background.texture = backdropUpdate.background.texture or us.Fill(backdropUpdate.background.texture, {
							path = frame.backdropInfo.bgFile,
							size = frame.backdropInfo.tileSize,
							tile = frame.backdropInfo.tile,
							insets = {
								l = frame.backdropInfo.insets.left,
								r = frame.backdropInfo.insets.right,
								t = frame.backdropInfo.insets.top,
								b = frame.backdropInfo.insets.bottom
							}
						})
						backdropUpdate.background.color = backdropUpdate.background.color or wt.PackColor(frame:GetBackdropColor())

						--Border
						backdropUpdate.border = backdropUpdate.border or {}
						backdropUpdate.border.texture = backdropUpdate.border.texture or us.Fill(backdropUpdate.border.texture, {
							path = frame.backdropInfo.edgeFile,
							width = frame.backdropInfo.edgeSize,
						})
						backdropUpdate.border.color = backdropUpdate.border.color or wt.PackColor(frame:GetBackdropColor())
					else backdropUpdate = nil end
				end

				--Update the backdrop
				setBackdrop(backdropUpdate)
			end

			for j = 1, #updates[i].triggers do if updates[i].triggers[j]:HasScript(key) then updates[i].triggers[j]:HookScript(key, updater) end end
		end
	end end
end

--| Dependencies

---Assign dependency rule listeners from a defined a ruleset
---***
---@param rules dependencyRule[] Indexed table containing the dependency rules to add
---@param setState fun(state: boolean) Function to call to set the state of the frame, enabling it on a true, or disabling it on a false input
function wt.AddDependencies(rules, setState)
	if type(rules) ~= "table" or type(setState) ~= "function" then return end

	--Update utility
	local setter = function() setState(wt.CheckDependencies(rules)) end

	--Set listeners
	for i = 1, #rules do if rules[i].frame then
		local t

		if us.IsFrame(rules[i].frame) then t = rules[i].frame:GetObjectType() else
			t = wt.IsWidget(rules[i].frame)

			--Watch value load events
			if t then rules[i].frame.setListener.loaded(function(_, success) if success then setter() end end) end
		end

		--Watch value change events
		if t == "CheckButton" then rules[i].frame:HookScript("OnClick", setter)
		elseif t == "EditBox" then rules[i].frame:HookScript("OnTextChanged", setter)
		elseif t == "Slider" then rules[i].frame:HookScript("OnValueChanged", setter)
		elseif t == "Toggle" then rules[i].frame.setListener.toggled(setter)
		elseif t == "Selector" or t == "Multiselector" or t == "SpecialSelector" then rules[i].frame.setListener.selected(setter)
		elseif t == "Textbox" or t == "Numeric" then rules[i].frame.setListener.changed(setter) end
	end end

	--Initialize state
	setter()
end

---Check and evaluate all dependencies in a ruleset
---***
---@param rules dependencyRule[] Indexed table containing the dependency rules to check
---@return boolean? state
function wt.CheckDependencies(rules)
	if type(rules) ~= "table" then return end

	local state = true

	for i = 1, #rules do
		if us.IsFrame(rules[i].frame) then --Base Blizzard frame objects
			if rules[i].frame:IsObjectType("CheckButton") then state = rules[i].evaluate and rules[i].evaluate(rules[i].frame:GetChecked()) or rules[i].frame:GetChecked()
			elseif rules[i].frame:IsObjectType("EditBox") then state = rules[i].evaluate(rules[i].frame:GetText())
			elseif rules[i].frame:IsObjectType("Slider") then state = rules[i].evaluate(rules[i].frame:GetValue())
			end
		elseif rules[i].frame.isType then --Custom WidgetTools widgets
			if rules[i].frame.isType("Toggle") then if rules[i].evaluate then state = rules[i].evaluate(rules[i].frame.getState()) else state = rules[i].frame.getState() end
			elseif rules[i].frame.isType("Selector") then state = rules[i].evaluate(rules[i].frame.getSelected())
			elseif rules[i].frame.isType("SpecialSelector") then state = rules[i].evaluate(rules[i].frame.getSelected())
			elseif rules[i].frame.isType("Multiselector") then state = rules[i].evaluate(rules[i].frame.getSelections())
			elseif rules[i].frame.isType("Textbox") then state = rules[i].evaluate(rules[i].frame.getText())
			elseif rules[i].frame.isType("Numeric") then state = rules[i].evaluate(rules[i].frame.getNumber())
			end
		end

		if not state then break end
	end

	return state
end


--[[ TOOLTIP MANAGEMENT ]]

--Default reusable tooltip frame
local defaultTooltip

---Tooltip data registry
---@type AnyTooltipData[]
local tooltipData = {}

---Register tooltip data and set up a GameTooltip for a frame to be toggled on hover
---***
---@param frame AnyFrameObject Owner frame the tooltip to be registered for<ul><li>***Note:*** If tooltip data for **owner** has already been added to the registry, it will be fully overwritten with **t**.</li><ul><li>***Note:*** Duplicate triggers may still be added if **duplicate** is set to true.</li></ul></li></ul>
---@param t? tooltipData The tooltip parameters are to be provided in this table
---@param toggle? tooltipToggleData Additional toggle rule parameters are to be provided in this table
---@param duplicate? boolean If true, execute even if tooltip data has already been registered for **owner**, potentially adding duplicate toggle triggers, or, automatically call ***WidgetToolbox*.UpdateTooltipData(...)** instead to avoid this | ***Default:*** false
---***
---@return tooltipData|nil # Reference to the tooltip data table registered for **owner** to display the tooltip info by | ***Default:*** nil
function wt.AddTooltip(frame, t, toggle, duplicate)
	if not us.IsFrame(frame) then return nil end

	--| Register tooltip data

	local id = us.GetID(frame)

	if duplicate ~= true and type(tooltipData[id]) == "table" then return wt.UpdateTooltipData(frame, t) end

	tooltipData[id] = type(t) == "table" and t or {}

	wt.UpdateTooltipData(frame)

	--| Toggle events

	toggle = type(toggle) == "table" and toggle or {}
	toggle.triggers = type(toggle.triggers) == "table" and toggle.triggers or {}

	table.insert(toggle.triggers, frame)

	for i = 1, #toggle.triggers do
		--Show tooltip
		if toggle.triggers[i] ~= frame and toggle.replace == false then
			toggle.triggers[i]:HookScript("OnEnter", function()
				if type(tooltipData[id]) == "table" then if not tooltipData[id].tooltip:IsVisible() then wt.UpdateTooltip(frame) end end
			end)
		else toggle.triggers[i]:HookScript("OnEnter", function() wt.UpdateTooltip(frame) end) end

		--Hide tooltip
		if toggle.triggers[i] ~= frame and toggle.checkParent ~= false then
			toggle.triggers[i]:HookScript("OnLeave", function()
				if not frame:IsMouseOver() then if type(tooltipData[id]) == "table" then tooltipData[id].tooltip:Hide() end end
			end)
		else toggle.triggers[i]:HookScript("OnLeave", function() if type(tooltipData[id]) == "table" then tooltipData[id].tooltip:Hide() end end) end
	end

	--| Hide with owner

	frame:HookScript("OnHide", function() if type(tooltipData[id]) == "table" then tooltipData[id].tooltip:Hide() end end)

	return tooltipData[id]
end

---Update and show a GameTooltip already set up to be toggled for a frame
---***
---@param frame AnyFrameObject Owner frame the tooltip to be updated for<ul><li>***Note:*** If no entry has been registered for **owner** in the tooltip data registry via ***WidgetToolbox*.AddTooltip(...)** yet, no tooltip will be shown.</li></ul>
---@param t? tooltipUpdateData|tooltipData Use this set of parameters to update the tooltip for **owner** with | ***Default:*** *(fill values from the data in the registry)*
function wt.UpdateTooltip(frame, t)
	if not us.IsFrame(frame) then return end

	--| Verify the tooltip data

	local id = us.GetID(frame)

	if type(tooltipData[id]) ~= "table" then return end

	if type(t) ~= "table" then t = tooltipData[id] else us.Pull(t, tooltipData[id]) end

	--| Position

	if t.anchor == "ANCHOR_NONE" then
		t.tooltip:SetOwner(frame, t.anchor)
		wt.SetPosition(t.tooltip, t.position)
	else t.tooltip:SetOwner(frame, t.anchor, t.position.offset.x or 0, t.position.offset.y or 0) end

	--| Title

	local titleColor = t.flipColors and NORMAL_FONT_COLOR or HIGHLIGHT_FONT_COLOR

	t.tooltip:AddLine(t.title, titleColor.r, titleColor.g, titleColor.b, true)

	--| Textlines

	if type(t.lines) == "table" then
		for i = 1, #t.lines do

			--| Set FontString

			local left = t.tooltip:GetName() .. "TextLeft" .. i + 1
			local right = t.tooltip:GetName() .. "TextRight" .. i + 1
			local font = t.lines[i].font or "GameTooltipText"

			if not _G[left] or not _G[right] then
				t.tooltip:AddFontStrings(t.tooltip:CreateFontString(left, nil, font), t.tooltip:CreateFontString(right, nil, font))
			end

			_G[left]:SetFontObject(font)
			_G[left]:SetJustifyH("LEFT")
			_G[right]:SetFontObject(font)
			_G[right]:SetJustifyH("RIGHT")

			--| Add textline

			local color = t.lines[i].color or (t.flipColors and HIGHLIGHT_FONT_COLOR or NORMAL_FONT_COLOR)

			t.tooltip:AddLine(t.lines[i].text, color.r, color.g, color.b, t.lines[i].wrap ~= false)
		end
	end

	--| Display the tooltip

	t.tooltip:Show()
	t.tooltip:SetScale(UIParent:GetScale())
end

---Verify and update the tooltip data values stored in the registry for a frame
---***
---@param frame AnyFrameObject Owner frame the tooltip data to be updated for<ul><li>***Note:*** If no entry has been registered for **owner** in the tooltip data registry via ***WidgetToolbox*.AddTooltip(...)** yet, no data will be changed.</li></ul>
---@param t? tooltipUpdateData|tooltipData The parameters to update the tooltip with are to be provided in this table | ***Default:*** *(fill values from the data in the registry or use default values for required values missing from the registry)*
---@param linesUpdate? boolean|nil If true, replace the full set of lines in the registry with **t.lines**, or if explicitly false, append the lines to the current list of lines, or if nil or something else, adjust the values of existing lines at matching indexes instead without adding or removing lines | ***Default:*** nil
---***
---@return tooltipData|nil # Reference to the tooltip data table registered for **owner** to display the tooltip info by | ***Default:*** nil
function wt.UpdateTooltipData(frame, t, linesUpdate)
	if not us.IsFrame(frame) then return nil end

	t = type(t) == "table" and t or {}

	--| Verify & update the tooltip data

	local id = us.GetID(frame)

	if type(tooltipData[id]) ~= "table" then return nil end

	--Tooltip frame
	if us.IsFrame(t.tooltip) and t.tooltip:IsObjectType("GameTooltip") then tooltipData[id].tooltip = t.tooltip
	elseif not tooltipData[id].tooltip or not (us.IsFrame(tooltipData[id].tooltip) and tooltipData[id].tooltip:IsObjectType("GameTooltip")) then
		--Create the default reusable tooltip
		if not defaultTooltip then
			local name = "WidgetToolbox" .. C_AddOns.GetAddOnMetadata(rs.addon, "X-WidgetTools-ToolboxVersion"):gsub("[^%w]", "_") .. "GameTooltip"

			defaultTooltip = CreateFrame("GameTooltip", name, nil, "GameTooltipTemplate")

			--| Visibility

			defaultTooltip:SetFrameStrata("TOOLTIP")
			defaultTooltip:SetScale(UIParent:GetScale())

			--| Title

			_G[defaultTooltip:GetName() .. "TextLeft" .. 1]:SetFontObject("GameFontNormalMed1")
			_G[defaultTooltip:GetName() .. "TextRight" .. 1]:SetFontObject("GameFontNormalMed1")
		end

		tooltipData[id].tooltip = defaultTooltip
	end
	t.tooltip = nil

	--Update textlines
	if linesUpdate == true then us.Filter(tooltipData[id].lines, t.lines)
	elseif linesUpdate == false and type(t.lines) == "table" then
		if type(tooltipData[id].lines) ~= "table" then tooltipData[id].lines = {} end

		for i = 1, #t.lines do table.insert(tooltipData[id].lines, t.lines[i]) end

		t.lines = nil
	end

	tooltipData[id] = us.Pull(tooltipData[id], t)

	--Position
	tooltipData[id].position = tooltipData[id].position or {}
	tooltipData[id].position.offset = tooltipData[id].offset or {}
	if not tooltipData[id].anchor then tooltipData[id].anchor = "ANCHOR_CURSOR" end

	--Title
	if type(tooltipData[id].title) ~= "string" then tooltipData[id].title = frame:GetName() or tostring(us.GetID(frame)) end

	return tooltipData[id]
end

---Add default value and utility menu hint tooltip lines to widget tooltip tables
---***
---@param frames AnyFrameObject[] List of reference to the frames to add the tooltip lines to<ul><li>***Note:*** If no entry has been registered for a frame in the list in the tooltip data registry via ***WidgetToolbox*.AddTooltip(...)** yet, no changes will be made for that frame.</li></ul>
---@param default? string Default value, formatted | ***Default:*** *(don't show default value)*
---@param utilityNote? boolean Is true, add a note for the utility context menu | ***Default:*** true
function wt.AddWidgetTooltipLines(frames, default, utilityNote)
	if type(default) ~= "string" or utilityNote == false then return end

	---@type tooltipData
	local tooltip = { lines = { { text = " ", }, } }

	if type(default) == "string" then table.insert(tooltip.lines, { text = crc(DEFAULT .. ": ", "FF66FF66") .. default, } ) end
	if utilityNote ~= false then table.insert(tooltip.lines, { text = wt.strings.value.note, font = GameFontNormalSmall, color = rs.colors.grey[1], }) end

	for i = 1, #frames do wt.UpdateTooltipData(frames[i], tooltip, false) end
end


--[[ POPUP MANAGEMENT ]]

---Create a popup dialog with an accept function and cancel button
---***
---@param addon? string The name of the addon's folder (the addon namespace, not its displayed title) | ***Default:*** "WidgetTools" *(register as global)*
---@param key? string Unique string appended to **addon** to be used as the identifier key in the global **StaticPopupDialogs** table | ***Default:*** "DIALOG"<ul><li>***Note:*** Dialog data registered under existing keys will be overwritten.</li><li>***Note:*** Space characters will be replaced with "_".</li></ul>
---@param t? popupDialogData Parameters are to be provided in this table
---***
---@return string key The unique identifier key created for this popup in the global **StaticPopupDialogs** table used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
function wt.RegisterPopupDialog(addon, key, t)
	t = type(t) == "table" and t or {}
	key = (type(addon) == "string" and addon or "WidgetTools"):upper() .. "_" .. (type(key) == "string" and key:gsub("%s+", "_"):upper() or "DIALOG")

	StaticPopupDialogs[key] = {
		text = t.text or "",
		button1 = t.accept or ACCEPT,
		button2 = t.cancel or CANCEL,
		button3 = t.alt,
		OnAccept = t.onAccept,
		OnCancel = t.onCancel,
		OnAlt = t.onAlt,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = STATICPOPUPS_NUMDIALOGS
	}

	return key
end

---Update already existing popup dialog data
---***
---@param key string The unique identifier key representing the defaults warning popup dialog in the global **StaticPopupDialogs** table, and used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
---@param t? popupDialogData Parameters are to be provided in this table
---***
---@return string? key The unique identifier key created for this popup in the global **StaticPopupDialogs** table used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide) | ***Default:*** nil
function wt.UpdatePopupDialog(key, t)
	if not StaticPopupDialogs[key] then return end

	t = type(t) == "table" and t or {}

	if t.text then StaticPopupDialogs[key].text = t.text end
	if t.accept then StaticPopupDialogs[key].button1 = t.accept end
	if t.cancel then StaticPopupDialogs[key].button2 = t.cancel end
	if t.alt then StaticPopupDialogs[key].button3 = t.alt end
	if t.onAccept then StaticPopupDialogs[key].OnAccept = t.onAccept end
	if t.onCancel then StaticPopupDialogs[key].OnCancel = t.onCancel end
	if t.onAlt then StaticPopupDialogs[key].OnAlt = t.onAlt end

	return key
end


--[[ ADDON COMPARTMENT ]]

---Set up the [Addon Compartment](https://warcraft.wiki.gg/wiki/Addon_compartment#Automatic_registration) functionality by registering global functions for call
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param calls? addonCompartmentFunctions Functions to call wrapped in a table<ul><li>***Note:*** `AddonCompartmentFunc`, `AddonCompartmentFuncOnEnter` and/or `AddonCompartmentFuncOnLeave` must be set in the specified **addon**'s TOC file to enable this functionality, defining the names of the global functions to be set for call.</li></ul>
---@param tooltip? addonCompartmentTooltipData|tooltipData List of text lines to be added to the tooltip of the addon compartment button displayed when mousing over it<ul><li>***Note:*** Both `AddonCompartmentFuncOnEnter` and `AddonCompartmentFuncOnLeave` must be set in the specified **addon**'s TOC file to enable this functionality, defining the names of the global functions to be overloaded.</li></ul>
function wt.SetUpAddonCompartment(addon, calls, tooltip)
	if type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) then return end

	calls = type(calls) == "table" and calls or {}

	local onClickName = C_AddOns.GetAddOnMetadata(addon, "AddonCompartmentFunc")
	local onEnterName = C_AddOns.GetAddOnMetadata(addon, "AddonCompartmentFuncOnEnter")
	local onLeaveName = C_AddOns.GetAddOnMetadata(addon, "AddonCompartmentFuncOnLeave")

	if onClickName and type(calls.onClick) == "function" then _G[onClickName] = calls.onClick end

	if type(tooltip) == "table" and onEnterName and onLeaveName then
		if not tooltip.tooltip then tooltip.tooltip = defaultTooltip end
		tooltip.title = tooltip.title or C_AddOns.GetAddOnMetadata(addon, "Title")
		tooltip.anchor = "ANCHOR_BOTTOMRIGHT"

		_G[onEnterName] = function(addonNamespace, frame)
			--Set tooltip
			local id = us.GetID(frame)
			if type(tooltipData[id]) ~= "table" then tooltipData[id] = tooltip end
			wt.UpdateTooltipData(frame)

			--Call handler
			if type(calls.onEnter) == "function" then calls.onEnter(addonNamespace, frame) end

			--Show tooltip
			wt.UpdateTooltip(frame)
		end

		_G[onLeaveName] = function(addonNamespace, frame)
			--Call handler
			if type(calls.onLeave) == "function" then calls.onLeave(addonNamespace, frame) end

			--Hide tooltip
			local id = us.GetID(frame)
			if type(tooltipData[id]) == "table" and tooltipData[id].tooltip then tooltipData[id].tooltip:Hide() end
		end
	else
		if onEnterName and type(calls.onEnter) == "function" then _G[onEnterName] = calls.onEnter end
		if onLeaveName and type(calls.onLeave) == "function" then _G[onLeaveName] = calls.onLeave end
	end
end


--[[ CHAT CONTROL ]]

---Register a list of chat keywords and related commands for use
---***
---@param addon string The name of the addon's folder (the addon namespace not the display title)
---@param keywords string[] List of addon-specific keywords to register to listen to when typed as slash commands<ul><li>***Note:*** A slash character (`/`) will appended before each keyword specified here during registration, it doesn't need to be included.</li></ul>
---@param t chatCommandManagerCreationData Parameters are to be provided in this table
---***
---@return chatCommandManager? manager Table containing command handler functions | ***Default:*** nil
function wt.RegisterChatCommands(addon, keywords, t)
	if type(addon) ~= "string" or not C_AddOns.IsAddOnLoaded(addon) or type(keywords) ~= "table" then return end

	t = type(t) == "table" and t or {}

	local logo = C_AddOns.GetAddOnMetadata(addon, "IconTexture")
	logo = logo and (wt.Texture(logo, 11, 11) .. " ") or ""
	local addonTitle = wt.Clear(select(2, C_AddOns.GetAddOnInfo(addon))):gsub("^%s*(.-)%s*$", "%1")
	local branding = logo .. addonTitle .. ": "

	---@class chatCommandManager
	local manager = {}

	addon = addon:upper()

	--Register the keywords
	for i = 1, #keywords do
		keywords[i] = "/" .. keywords[i]
		_G["SLASH_" .. addon .. i] = keywords[i]
	end

	--| Utilities

	---Print out a formatted chat message
	---@param message string Message content
	---@param title? string Title to start the message with | ***Default:*** *(**addon** title)*<ul><li>***Note:*** If "IconTexture" is specified in the TOC file of **addon**, a logo will also be included at the start of the message.</li></ul>
	---@param contentColor? chatCommandColorNames|colorData|colorRGBA ***Default:*** "content"
	---@param titleColor? chatCommandColorNames|colorData|colorRGBA ***Default:*** "title"
	function manager.print(message, title, titleColor, contentColor)
		title = type(title) == "string" and title or branding
		titleColor = type(titleColor) == "table" and titleColor or t.colors[type(titleColor) == "string" and titleColor or "title"]
		contentColor = type(contentColor) == "table" and contentColor or t.colors[type(contentColor) == "string" and contentColor or "content"]

		if type(message) == "string" then print(cr(title, titleColor) .. cr(message, contentColor)) end
	end

	--Print a welcome message with a hint about chat keywords
	function manager.welcome()
		local keyword = cr(keywords[1], t.colors.command)
		if #keywords > 1 then
			if #keywords > 2 then for i = 2, #keywords - 1 do keyword = " " .. keyword .. "," .. cr(keywords[i], t.colors.command) end end
			keyword = wt.strings.chat.welcome.keywords:gsub("#KEYWORD_ALTERNATE", cr(keywords[#keywords], t.colors.command)):gsub("#KEYWORD", keyword)
		end

		print(cr(logo .. wt.strings.chat.welcome.thanks:gsub("#ADDON", cr(addonTitle, t.colors.title)), t.colors.content))
		print(cr(wt.strings.chat.welcome.hint:gsub("#KEYWORD", keyword), t.colors.description))

		if type(t.onWelcome) == "function" then t.onWelcome() end
	end

	--Trigger a help command, listing all registered chat commands with their specified descriptions, calling their onHelp handlers
	function manager.help()
		print(cr(wt.strings.chat.help.list:gsub("#ADDON", cr(logo .. addonTitle, t.colors.title)), t.colors.content))

		for i = 1, #t.commands do
			if not t.commands[i].hidden then
				local description = type(t.commands[i].description) == "function" and t.commands[i].description() or t.commands[i].description

				print(cr("    " .. keywords[1] .. " ".. t.commands[i].command, t.colors.command) .. (
					type(description) == "string" and cr(" • " .. description, t.colors.description) or ""
				))
			end

			if type(t.commands[i].onHelp) == "function" then t.commands[i].onHelp() end
		end
	end

	---Find and a specific command by its name and call its handler script
	---***
	---@param command string Name of the slash command word (no spaces)
	---@param ... any Any further arguments are used as the payload of the command, passed over to its handler
	---***
	---@return boolean # Whether the command was found and the handler called successfully
	function manager.handleCommand(command, ...)
		--Find the command
		for i = 1, #t.commands do if command == t.commands[i].command then
			--Call command handler
			if t.commands[i].handler then
				local results = { t.commands[i].handler(manager, ...) }

				--Response
				if results[1] == true then
					local message = type(t.commands[i].success) == "function" and t.commands[i].success(unpack(results, 2)) or t.commands[i].success

					--Print response message
					if type(message) == "string" then manager.print(message) end

					--Call handler
					if type(t.commands[i].onSuccess) == "function" then t.commands[i].onSuccess(manager, unpack(results, 2)) end
				elseif results[1] == false then
					local message = type(t.commands[i].error) == "function" and t.commands[i].error(unpack(results, 2)) or t.commands[i].error

					--Print response message
					if type(message) == "string" then manager.print(message) end

					--Call handler
					if type(t.commands[i].onError) == "function" then t.commands[i].onError(manager, unpack(results, 2)) end
				end
			end

			if t.commands[i].help then manager.help() end

			return true
		end end

		return false
	end

	--| Set global keyword handler

	SlashCmdList[addon] = function(line)
		local payload = { strsplit(" ", line) }
		local command = payload[1]

		--Find and handle the specific command or call the default handler script
		if not manager.handleCommand(command, unpack(payload, 2)) then
			if type(t.defaultHandler) == "function" then t.defaultHandler(manager, command, unpack(payload, 2)) end

			--List (non-hidden) commands
			manager.help()
		end
	end

	return manager
end


--[[ SETTINGS MANAGEMENT ]]

---Register the settings page to the Settings window if it wasn't already
--- - ***Note:*** No settings page will be registered if **WidgetToolsDB.lite** is true.
---@param page settingsPage Reference to the settings page to register to Settings
---@param parent? settingsPage Reference to the parent settings page to set **page** as a child category page of | ***Default:*** *set as a parent category page*
---@param icon? boolean If true, append the icon set for the settings page to its button title in the AddOns list of the Settings window as well | ***Default:*** true if **parent** == nil
function wt.RegisterSettingsPage(page, parent, icon)
	if WidgetToolsDB.lite or wt.IsWidget(page) ~= "SettingsPage" or page.category then return end

	parent = wt.IsWidget(parent) == "SettingsPage" and parent or nil
	if icon == nil then icon = parent == nil end

	local iconTexture = (icon and type(page.iconTexture) == "string" and (" |T" .. page.iconTexture .. ":14:14:3:-1|t") or "")
	local title = (type(page.title) == "table" and type(page.title.GetText) == "function" and page.title:GetText() or "") .. iconTexture

	page.canvas.OnCommit = function() page.save(true) end
	page.canvas.OnRefresh = function() page.load(nil, true) end
	page.canvas.OnDefault = function() page.reset(true) end

	if parent and type(parent.category) == "table" then page.category = Settings.RegisterCanvasLayoutSubcategory(parent.category, page.canvas, title)
	else page.category = Settings.RegisterCanvasLayoutCategory(page.canvas, title) end

	Settings.RegisterAddOnCategory(page.category)
end

--| Settings data

--Settings data management rule registry
---@class settingsRegistry
---@field rules table<string, settingsRule[]> Collection of rules describing where to save/load settings data to/from, and what change handlers to call in the process linked to each specific settings category under an addon
---@field changeHandlers table<string, function> List of pairs of addon-specific unique keys and change handler scripts
local settingsData = { rules = {}, changeHandlers = {} }

---Register a settings data management entry for a settings widget to the settings data management registry for batched data handling
---***
---@param widget AnyWidgetType|AnyGUIWidgetType Reference to the widget to be saved & loaded data to/from with defined **widget.loadData()** & **widget.saveData()** functions
---@param t settingsData Parameters are to be provided in this table
---***
---@return integer|nil index The index for the new entry for **widget** where it ended up in the settings data management registry | ***Default:*** nil
function wt.AddSettingsDataManagementEntry(widget, t)
	if not wt.IsWidget(widget) or type(t) ~= "table" then return nil end

	t.category = type(t.category) == "string" and t.category or "WidgetTools"
	local key = t.category .. (type(t.key) == "string" and t.key or "")

	settingsData.rules[key] = settingsData.rules[key] or {}

	--Add onChange handlers
	if type(t.onChange) == "table" then
		local newKeys = {}

		for k, v in pairs(t.onChange) do if type(k) == "string" and type(v) == "function" then
			--Store the function
			settingsData.changeHandlers[t.category .. k] = v

			--Remove the function definitions, save their keys
			t.onChange[k] = nil
			table.insert(newKeys, k)
		end end

		--Add saved new keys
		for i = 1, #newKeys do table.insert(t.onChange, newKeys[i]) end
	end

	t.index = type(t.index) == "number" and Clamp(us.Round(t.index), 1, #settingsData.rules[key] + 1) or #settingsData.rules[key] + 1

	--Add to the registry
	table.insert(settingsData.rules[key], t.index, { widget = widget, onChange = t.onChange })

	return t.index
end

---Load all data from storage to the widgets specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].loadData(...)** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
---@param handleChanges? boolean If true, also call all registered change handlers | ***Default:*** false
function wt.LoadSettingsData(category, key, handleChanges)
	category = type(category) == "string" and category or "WidgetTools"
	key = category .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	local changeHandlers = handleChanges == true and {} or nil

	for i = 1, #settingsData.rules[key] do
		settingsData.rules[key][i].widget.loadData(false)

		--Register onChange handlers for call
		if changeHandlers and type(settingsData.rules[key][i].onChange) == "table" then
			for j = 1, #settingsData.rules[key][i].onChange do changeHandlers[category .. settingsData.rules[key][i].onChange[j]] = true end
		end
	end

	--Call registered onChange handlers
	if changeHandlers then for k in pairs(changeHandlers) do settingsData.changeHandlers[k]() end end
end

---Save all data from the widgets to storage specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].saveData(...)** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.SaveSettingsData(category, key)
	key = (type(category) == "string" and category or "WidgetTools") .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	for i = 1, #settingsData.rules[key] do settingsData.rules[key][i].widget.saveData() end
end

---Call all **onChange** handlers registered in the settings data management registry in the specified **category** under the specified **key**
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.ApplySettingsData(category, key)
	category = type(category) == "string" and category or "WidgetTools"
	key = category .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	local handlers = {}

	--Register onChange handlers for call
	for i = 1, #settingsData.rules[key] do if type(settingsData.rules[key][i].onChange) == "table" then
		for j = 1, #settingsData.rules[key][i].onChange do handlers[category .. settingsData.rules[key][i].onChange[j]] = true end
	end end

	--Call registered onChange handlers
	if handlers then for k in pairs(handlers) do settingsData.changeHandlers[k]() end end
end

---Set a data snapshot for each widget specified in the settings data management registry in the specified **category** under the specified **key** calling **[*widget*].revertData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.SnapshotSettingsData(category, key)
	key = (type(category) == "string" and category or "WidgetTools") .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	for i = 1, #settingsData.rules[key] do settingsData.rules[key][i].widget.snapshotData() end
end

---Set & load the stored data managed by each widget specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].revertData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.RevertSettingsData(category, key)
	category = type(category) == "string" and category or "WidgetTools"
	key = category .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	local applyChanges = {}

	for i = 1, #settingsData.rules[key] do
		settingsData.rules[key][i].widget.revertData(false)

		--Register onChange handlers for call
		if type(settingsData.rules[key][i].onChange) == "table" then
			for j = 1, #settingsData.rules[key][i].onChange do applyChanges[category .. settingsData.rules[key][i].onChange[j]] = true end
		end
	end

	--Call registered onChange handlers
	if applyChanges then for k in pairs(applyChanges) do settingsData.changeHandlers[k]() end end
end

---Set & load the default data managed by each widget specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].resetData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.ResetSettingsData(category, key)
	category = type(category) == "string" and category or "WidgetTools"
	key = category .. (type(key) == "string" and key or "")

	if not settingsData.rules[key] then return end

	local applyChanges = {}

	for i = 1, #settingsData.rules[key] do
		settingsData.rules[key][i].widget.resetData(false)

		--Register onChange handlers for call
		if type(settingsData.rules[key][i].onChange) == "table" then
			for j = 1, #settingsData.rules[key][i].onChange do applyChanges[category .. settingsData.rules[key][i].onChange[j]] = true end
		end
	end

	--Call registered onChange handlers
	if applyChanges then for k in pairs(applyChanges) do settingsData.changeHandlers[k]() end end
end

---Handle changes for widgets in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].onChange()** for each
---@param index integer Filter the call of change handlers to only include the list under the specified index not each list in the specified **category** under the specified **key**
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.HandleWidgetChanges(index, category, key)
	category = type(category) == "string" and category or "WidgetTools"
	key = category .. (type(key) == "string" and key or "")

	if type(settingsData.rules[key]) ~= "table" or type(settingsData.rules[key][index]) ~= "table" or type(settingsData.rules[key][index].onChange) ~= "table" then return end

	--Call registered onChange handlers
	for i = 1, #settingsData.rules[key][index].onChange do settingsData.changeHandlers[category .. settingsData.rules[key][index].onChange[i]]() end
end