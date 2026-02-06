--[[ NAMESPACE ]]

---@class WidgetToolsNamespace
local ns = select(2, ...)


--[[ INITIALIZATION ]]

if not ns.WidgetToolboxInitialization then return end

---@class wt
local wt = ns.WidgetToolbox


--[[ GENERAL ]]

---Get the sorted key, value pairs of a table ([Documentation: Sort](https://www.lua.org/pil/19.3.html))
---***
---@param t table Table to be sorted (in an ascending order and/or alphabetically, based on the `<` operator)
---***
---@return function iterator Function returning the key, value pairs of the table in order
function wt.SortedPairs(t)
	local a = {}

	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, function(x, y) if type(x) == "number" and type(y) == "number" then return x < y else return tostring(x) < tostring(y) end end)

	local i = 0
	local iterator = function ()
		i = i + 1
		if a[i] == nil then return nil else return a[i], t[a[i]] end
	end

	return iterator
end

---Convert and format an input object to string to be dumped to the in-game chat
---***
---@param object any Object to dump out
---@param outputTable table Table to put the formatted output lines in
---@param name? any Value to print out as name string | ***Default:*** **object** as string
---@param blockrule? fun(key: integer|string): boolean Manually filter further exploring subtables under specific keys, skipping it if the value returned is true
---@param depth? integer How many levels of subtables to print out (root level: 0) | ***Default:*** *full depth*
---@param digTables? boolean ***Default:*** true
---@param digFrames? boolean ***Default:*** false
---@param currentKey? string
---@param currentLevel? integer
local function getDumpOutput(object, outputTable, name, blockrule, depth, digTables, digFrames, currentKey, currentLevel)
	--Check whether the current key is to be skipped
	local skip = false
	if currentKey and type(blockrule) == "function" then skip = blockrule(currentKey) end

	--Calculate indentation based on the current depth level
	currentLevel = currentLevel or 0
	local indentation = ""
	for i = 1, currentLevel do indentation = indentation .. "    " end

	--Format the name and key
	currentKey = currentKey and indentation .. "|cFFACD1EC" .. currentKey .. "|r" or nil
	name = name and "|cFF69A6F8" .. tostring(name) .. "|r" or wt.ToString(object)

	--Add the line to the output
	if type(object) == "table" and (digFrames or not wt.IsFrame(object)) then
		local s = (currentKey and (currentKey .. " (") or "Dump (") .. name .. "):"

		--Stop at the max depth or if the key is skipped
		if skip or currentLevel >= (depth or currentLevel + 1) then
			table.insert(outputTable, s .. " {…}")

			return
		end

		table.insert(outputTable, s .. (digTables == false and " {…}" or ""))

		--Convert & format the subtable
		for k, v in wt.SortedPairs(object) do getDumpOutput(v, outputTable, nil, blockrule, depth, digTables, digFrames, k, currentLevel + 1) end
	elseif digTables == false then return else
		local line = (currentKey and currentKey .. " = " or "Dump " .. name .. " value: ") .. (skip and "…" or wt.ToString(object))

		table.insert(outputTable, line)

		return
	end
end

---Dump an object and its contents to the in-game chat
---***
---@param object any Object to dump out
---@param name? string A name to print out | ***Default:*** *the dumped object will not be named* | ***Default:*** true
---@param depth? integer How many levels of subtables to print out (root level: 0) | ***Default:*** *full depth*
---@param blockrule? fun(key: integer|string): boolean Manually filter further exploring subtables under specific keys, skipping it if the value returned is true
--- - ***Example:*** **Match:** Skip a specific matching key
--- 	```
--- 	function(key) return key == "skip_key" end
--- 	```
--- - ***Example:*** **Comparison:** Skip an index key based the result of a comparison
--- 	```
--- 	function(key)
--- 		if type(key) == "number" then --check if the key is an index to avoid issues with mixed tables
--- 			return key < 10
--- 		end
--- 		return true --or false whether to allow string keys in mixed tables
--- 	end
--- 	```
--- - ***Example:*** **Blocklist:** Iterate through an array (indexed table) containing keys, the values of which are to be skipped
--- 	```
--- 	function(key)
--- 		local blocklist = {
--- 			"skip_key",
--- 			1,
--- 		}
--- 		for i = 1, #blocklist do
--- 			if key == blocklist[i] then
--- 			return true --or false to invert the functionality and treat the blocklist as an allowlist
--- 		end
--- 	end
--- 		return false --or true to invert the functionality and treat the blocklist as an allowlist
--- 	end
--- 	```
---@param digTables? boolean If true, explore and dump the non-subtable values of table objects | ***Default:*** true
---@param digFrames? boolean If true, explore and dump the insides of objects recognized as frames | ***Default:*** false
---@param linesPerMessage? integer Print the specified number of output lines in a single chat message to be able to display more message history and allow faster scrolling | ***Default:*** 2
--- - ***Note:*** Set to 0 to print all lines in a single message.
function wt.Dump(object, name, blockrule, depth, digTables, digFrames, linesPerMessage)
	--| Get the output lines

	local output = {}

	getDumpOutput(object, output, name, blockrule, depth, digTables, digFrames)

	--| Print the output

	local lineCount = 0
	local message = ""

	for i = 1, #output do
		lineCount = lineCount + 1
		message = message .. ((lineCount > 1 and i > 1) and "\n" .. output[i]:sub(5) or output[i])

		if lineCount == (linesPerMessage or 2) or i == #output then
			print(message)

			lineCount = 0
			message = ""
		end
	end
end

---Access a Blizzard modifier key down checking function via a modifier key string
---***
---@param modifier ModifierKey Which checker function to get
--- - ***Note:*** When set to "any" [IsModifierKeyDown()](https://warcraft.wiki.gg/wiki/API_IsModifierKeyDown) is used, otherwise the corresponding key down checker is returned.
---***
---@return boolean|fun(): isDown: boolean checker Checks if the **modifier** key is currently being pressed down, returning true
--- - ***Note:*** Always returns true when an invalid **modifier** string was provided.
---***
---<p></p>
function wt.GetModifierChecker(modifier)
	if modifier == "any" then return IsModifierKeyDown end
	if modifier == "CTRL" then return IsControlKeyDown end
	if modifier == "SHIFT" then return IsShiftKeyDown end
	if modifier == "ALT" then return IsAltKeyDown end
	if modifier == "LCTRL" then return IsLeftControlKeyDown end
	if modifier == "RCTRL" then return IsRightControlKeyDown end
	if modifier == "LSHIFT" then return IsLeftShiftKeyDown end
	if modifier == "RSHIFT" then return IsRightShiftKeyDown end
	if modifier == "LALT" then return IsLeftAltKeyDown end
	if modifier == "RALT" then return IsRightAltKeyDown end
	return function() return true end
end


--[[ MATH ]]

---Round a decimal fraction to the specified number of digits
---***
---@param number number A fractional number value to round
---@param decimals? number Specify the number of decimal places to round the number to | ***Default:*** 0
---@return number
function wt.Round(number, decimals)
	local multiplier = 10 ^ (decimals or 0)

	return math.floor(number * multiplier + 0.5) / multiplier
end


--[[ CONVERSION ]]

---Convert the object to an appropriately formatted and colored string based on its type
---***
---@param object any Object to convert to a formatted text
---***
---@return string s Formatted output string
---@return "Frame"|"FrameScriptObject"|"table"|"boolean"|"number"|"string"|"any" t Recognized object type
function wt.ToString(object)
	local t = type(object)

	if t == "table" then
		local s = wt.IsFrame(object)

		if s then
			if type(s) == "string" then return WrapTextInColorCode(s, "FFDD99FF"), "Frame" end --Frame reference (purple)
			return WrapTextInColorCode(tostring(object), "FFFF4444"), "FrameScriptObject" --Unidentifiable UI object reference (red)
		end

		return WrapTextInColorCode(tostring(object), "FFFF9999"), t --table reference (pink)
	end
	if t == "boolean" then return WrapTextInColorCode(tostring(object), object and "FFAAAAFF" or "FFFFAA66"), t end --boolean value (true: blue, false: orange)
	if t == "number" then return WrapTextInColorCode(tostring(object), "FFDDDD55"), t end --number value (yellow)
	if t == "string" then return WrapTextInColorCode("\"" .. object .. "\"", "FF55DD55"), t end --string value (green)

	return WrapTextInColorCode(tostring(object), "FFFF4444"), "any" --Miscellaneous value (red)
end

---Find a frame or region by its name (or a subregion if a key is included in the input string)
---***
---@param s string Name of the frame to find (and the key of its child region appended to it after a period character)
---***
---@return AnyFrameObject|nil frame Reference to the object
function wt.ToFrame(s)
	local frame = nil

	--Find the global reference
	for name in s:gmatch("[^.]+") do frame = frame and frame[name] or _G[name] end

	return wt.IsFrame(frame) and frame or nil
end

---Return a position table used by WidgetTools assembled from the provided values which are returned by [Region:GetPoint(...)](https://warcraft.wiki.gg/wiki/API_Region_GetPoint)
---***
---@param anchor? FramePoint Base anchor point | ***Default:*** "TOPLEFT"
---@param relativeTo? Frame Relative to this Frame or Region
---@param relativePoint? FramePoint Relative anchor point
---@param offsetX? number | ***Default:*** 0
---@param offsetY? number | ***Default:*** 0
---***
---@return positionData # Table containing the position values as used by WidgetTools
---<hr><p></p>
function wt.PackPosition(anchor, relativeTo, relativePoint, offsetX, offsetY)
	return {
		anchor = anchor or "TOPLEFT",
		relativeTo = relativeTo,
		relativePoint = relativePoint,
		offset = offsetX and offsetY and { x = offsetX or 0, y = offsetY or 0 } or nil
	}
end

---Returns the position values used by [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) from a position table used by WidgetTools
---***
---@param t? positionData Table containing parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with
---***
---@return FramePoint anchor ***Default:*** "TOPLEFT"
--- - ***Note:*** Default to "TOPLEFT" when an invalid input is provided.
---@return AnyFrameObject|nil relativeTo ***Default:*** "nil" *(anchor relative to screen dimensions)*
--- - ***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).
--- - ***Note:*** Default to nil when an invalid frame name is provided.
---@return FramePoint? relativePoint
---@return number|nil offsetX ***Default:*** 0
---@return number|nil offsetY ***Default:*** 0
---<hr><p></p>
function wt.UnpackPosition(t)
	if type(t) ~= "table" then return "TOPLEFT" end

	t.anchor = t.anchor or "TOPLEFT"

	if t.relativeTo ~= "nil" then
		if type(t.relativeTo) == "string" then t.relativeTo = wt.ToFrame(t.relativeTo) end
		if not wt.IsFrame(t.relativeTo) or not (t.relativeTo or {}).GetPoint then t.relativeTo = nil end
	end

	if not t.offset then t.offset = {} else
		t.offset.x = t.offset.x or 0
		t.offset.y = t.offset.y or 0
	end

	return t.anchor, t.relativeTo, t.relativePoint, t.offset.x, t.offset.y
end

---Return a table constructed from color values
---***
---@param red? number ***Range:*** (0, 1) | ***Default:*** 1
---@param green? number ***Range:*** (0, 1) | ***Default:*** 1
---@param blue? number ***Range:*** (0, 1) | ***Default:*** 1
---@param alpha? number Opacity | ***Range:*** (0, 1) | ***Default:*** 1
---***
---@return colorData # Table containing the color values
function wt.PackColor(red, green, blue, alpha)
	return { r = red or 1, g = green or 1, b = blue or 1, a = alpha or 1 }
end

---Returns the color values found in a table
---***
---@param t colorData Table containing the color values
---@param alpha? boolean Specify whether to return the full RGBA set or just the RGB values | ***Default:*** true
---***
---@return number r
--- - ***Note:*** Default to 1 when an invalid input is provided or **t.r** is not set.
---@return number g
--- - ***Note:*** Default to 1 when an invalid or input is provided or **t.g** is not set.
---@return number b
--- - ***Note:*** Default to 1 when an invalid input is provided or **t.b** is not set.
---@return number|nil a
--- - ***Note:*** Default to 1 when an invalid input is provided or **t.a** is not set.
function wt.UnpackColor(t, alpha)
	if type(t) ~= "table" then return 1, 1, 1, 1 end
	if alpha ~= false then return t.r or 1, t.g or 1, t.b or 1, t.a or 1 else return t.r, t.g, t.b end
end

---Convert RGB(A) color values in Range: (0, 1) to HEX color code
---***
---@param r number Red | ***Range:*** (0, 1)
---@param g number Green | ***Range:*** (0, 1)
---@param b number Blue | ***Range:*** (0, 1)
---@param a? number Alpha | ***Range:*** (0, 1) | ***Default:*** *no alpha*
---@param alphaFirst? boolean Put the alpha value first: ARGB output instead of RGBA | ***Default:*** false
---@param hashtag? boolean Whether to add a "#" to the beginning of the color description | ***Default:*** true
---***
---@return string hex Color code in HEX format
--- - ***Examples:***
--- 	- **RGB:** "#2266BB"
--- 	- **RGBA:** "#2266BBAA"
function wt.ColorToHex(r, g, b, a, alphaFirst, hashtag)
	local hex = hashtag ~= false and "#" or ""
	if a and alphaFirst then hex = hex .. string.format("%02x", math.ceil(a * 255)) end
	hex = hex .. string.format("%02x", math.ceil(r * 255)) .. string.format("%02x", math.ceil(g * 255)) .. string.format("%02x", math.ceil(b * 255))
	if a and not alphaFirst then hex = hex .. string.format("%02x", math.ceil(a * 255)) end

	return hex:upper()
end

---Convert a HEX color code into RGB or RGBA in Range: (0, 1)
---***
---@param hex string String in HEX color code format
--- - ***Examples:***
--- 	- **RGB:** "#2266BB" (where the "#" is optional)
--- 	- **RGBA:** "#2266BBAA" (where the "#" is optional)
---***
---@return number r Red | ***Range:*** (0, 1)
--- - ***Note:*** Default to 1 when an invalid input is provided.
---@return number g Green  | ***Range:*** (0, 1)
--- - ***Note:*** Default to 1 when an invalid input is provided.
---@return number b Blue | ***Range:*** (0, 1)
--- - ***Note:*** Default to 1 when an invalid input is provided.
---@return number|nil a Alpha | ***Range:*** (0, 1)
function wt.HexToColor(hex)
	hex = hex:gsub("#", "")
	if hex:len() ~= 6 and hex:len() ~= 8 then return 1, 1, 1 end

	local r = tonumber(hex:sub(1, 2), 16) / 255
	local g = tonumber(hex:sub(3, 4), 16) / 255
	local b = tonumber(hex:sub(5, 6), 16) / 255

	if hex:len() == 8 then return r, g, b, tonumber(hex:sub(7, 8), 16) / 255 else return r, g, b end
end


--[[ FORMATTING ]]

---Format a number string with thousands separation and optional value rounding
---***
---@param value number Number value to turn into a string with thousand separation
---@param decimals? number Specify the number of decimal places to display if the number is a fractional value | ***Default:*** 0
---@param round? boolean Round the number value to the specified number of decimal places | ***Default:*** true
---@param trim? boolean Trim trailing zeros in decimal places | ***Default:*** true
---@return string
function wt.Thousands(value, decimals, round, trim)
	value = round == false and value or wt.Round(value, decimals)
	local sign = value < 0 and "-" or ""
	local fraction = math.abs(value) % 1
	local integer = tostring(math.abs(value) - fraction)
	local decimalText = tostring(fraction):sub(3, (decimals or 0) + 2)
	local leftover

	while true do
		integer, leftover = string.gsub(integer, "^(-?%d+)(%d%d%d)", '%1' .. wt.strings.separator .. '%2')
		if leftover == 0 then break end
	end
	if trim == false then for i = 1, (decimals or 0) - #decimalText do decimalText = decimalText .. "0" end end

	return sign .. integer .. (((decimals or 0) > 0 and (fraction ~= 0 or trim == false)) and wt.strings.decimal .. decimalText or "")
end

--[ Escape sequences ]

---Create a colored string from the provided value via escape sequences
---***
---@param value string|number Value to add coloring to
---@param color colorData Table containing the color values
---@return string
function wt.Color(value, color)
	local r, g, b, a = wt.UnpackColor(color)

	return WrapTextInColorCode(value, wt.ColorToHex(r, g, b, a, true, false))
end

---Create a markup texture string snippet via escape sequences based on the specified values
---@param path string Path to the specific texture file relative to the root directory of the specific WoW client<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
---@param width? number ***Default:*** *width of the texture file*
---@param height? number ***Default:*** **width**
---@param offsetX? number | ***Default:*** 0
---@param offsetY? number | ***Default:*** 0
---@param t? table Additional parameters are to be provided in this table
---@return string
function wt.Texture(path, width, height, offsetX, offsetY, t)
	if t then
		return CreateSimpleTextureMarkup(path, height, width, offsetX, offsetY) --REPLACE with [CreateTextureMarkup](https://warcraft.wiki.gg/wiki/FrameXML_functions#:~:text=(role)-,CreateTextureMarkup,-(file%2C%20fileWidth)
	else return CreateSimpleTextureMarkup(path, height, width, offsetX, offsetY) end
end

---Remove all recognized formatting (like coloring) & other (like hyperlink) escape sequences from a string
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
		"|K.-|k", ""
	):gsub(
		"|n", "\n"
	):gsub(
		"||", "|"
	):gsub(
		"{star}", ""
	):gsub(
		"{circle}", ""
	):gsub(
		"{diamond}", ""
	):gsub(
		"{triangle}", ""
	):gsub(
		"{moon}", ""
	):gsub(
		"{square}", ""
	):gsub(
		"{cross}", ""
	):gsub(
		"{skull}", ""
	):gsub(
		"{rt%d}", ""
	)

	return s
end

---Format a table as a string with colored values appropriate to their type
---***
---@param table table Reference to the table to convert
---@param compact? boolean Whether spaces and indentations should be trimmed or not | ***Default:*** false
---@param space string Character(s) to add for additional spacing between non-atomic elements
---@param newLine string Character(s) to add for breaking lines (or not)
---@param indentation string Chain of characters to use as the indentation for subtables
---@return string
local function formatTableString(table, compact, space, newLine, indentation)
	if wt.IsFrame(table) then return (wt.ToString(table)) end

	local tableString = "{"

	for key, value in wt.SortedPairs(table) do
		--Key
		tableString = tableString .. newLine .. (compact and "" or indentation) .. (
			type(key) == "string" and (
				key:match("^%a%w*$") and WrapTextInColorCode(key, "FFFFFFFF") or "[" .. WrapTextInColorCode("\"" .. key .. "\"", "FFFFFFFF") .. "]"
			) or "[" .. WrapTextInColorCode(tostring(key), "FFFFFFFF") .. "]"
		) .. space .. "="

		--Value
		local valueString, valueType = wt.ToString(value)
		if valueType == "table" then valueString = formatTableString(value, compact, space, newLine, indentation .. (compact and "" or "    ")) end

		tableString = tableString .. space .. valueString

		--Add separator
		tableString = tableString .. ","
	end

	return WrapTextInColorCode((tableString:sub(1, -2)) .. newLine .. indentation:sub(1, -5) .. "}", "FF999999") --base color (grey)
end

---Convert a table into a formatted and colored string (appearing as a functional LUA code chunk but including coloring escape sequences)
--- - ***Example:*** Turning back into a loadable code chunk to then be useable as a table:
--- 	```
--- 	local success, loadedTable = pcall(loadstring("return " .. wt.Clear(tableAsString)))
--- 	```
---***
---@param table table Reference to the table to convert
---@param compact? boolean Whether spaces and indentations should be trimmed or not | ***Default:*** false
---@return string
function wt.TableToString(table, compact)
	if type(table) ~= "table" then return (wt.ToString(table)) end

	return formatTableString(table, compact, compact and "" or " ", compact and "" or "\n", "    ")
end

---Get an assembled & fully formatted string of a specifically assembled changelog table
---***
---@param changelog { [table[]] : string[] } String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included
--- - ***Note:*** The first line in version tables is expected to be the title containing the version number and/or the date of release.
--- - ***Note:*** Version tables are expected to be listed in descending order by date of release (latest release first).
--- - ***Examples:***
--- 	- **Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)
--- 	- **Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)
--- 	- **Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)
--- 	- **Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)
--- 	- **Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)
--- 	- **Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)
---@param latest? boolean Whether to get the update notes of the latest version or the entire changelog | ***Default:*** false
--- - ***Note:*** If true, the first line (expected to be the title containing the version number and/or release date) of the of the last version table will be omitted from the final formatted text returned, only including the update notes themselves.
---@return string c
function wt.FormatChangelog(changelog, latest)
	--Colors
	local highlight = "FFFFFFFF"
	local new = "FF66EE66"
	local fix = "FFEE4444"
	local change = "FF8888EE"
	local note = "FFEEEE66"

	--Assemble the changelog
	local c = ""

	for i = 1, #changelog do
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
	end

	return c
end

--[ Hyperlinks ]

---Format a clickable hyperlink text via escape sequences
---***
---@param type ExtendedHyperlinkType [Type of the hyperlink](https://warcraft.wiki.gg/wiki/Hyperlinks#Types) determining how it's being handled and what payload it carries
---@param content? string A colon-separated chain of parameters determined by **type** (Example: "content1:content2:content3") | ***Default:*** ""
---@param text string Clickable text to be displayed as the hyperlink
---@return string
---<hr><p></p>
function wt.Hyperlink(type, content, text)
	return "\124H" .. type .. ":" .. (content or "") .. "\124h" .. text .. "\124h"
end

---Format a custom clickable addon hyperlink text via escape sequences
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param type? string A unique key signifying the type of the hyperlink specific to the addon (if the addon handles multiple different custom types of hyperlinks) in order to be able to set unique hyperlink click handlers via ***WidgetToolbox*.SetHyperlinkHandler(...)** | ***Default:*** "-"
---@param content? string A colon-separated chain of data strings carried by the hyperlink to be provided to the handler function (Example: "content1:content2:content3") | ***Default:*** ""
---@param text string Clickable text to be displayed as the hyperlink
function wt.CustomHyperlink(addon, type, content, text)
	return wt.Hyperlink("addon", addon .. ":" .. (type or "-") .. ":" .. (content or ""), text)
end

--Hyperlink handler script registry
local hyperlinkHandlers = {}

---Register a function to handle custom hyperlink clicks
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param linkType? string Unique custom hyperlink type key used to identify the specific handler function | ***Default:*** "-"
---@param handler fun(...) Function to be called with the list of content data strings carried by the hyperlink returned one by one when clicking on a hyperlink text created via ***WidgetToolbox*.CustomHyperlink(...)**
function wt.SetHyperlinkHandler(addon, linkType, handler)
	if not addon or type(handler) ~= "function" then return end

	---Call the handler function if it has been registered
	---@param addonID string
	---@param handlerID string
	---@param payload string
	local function callHandler(addonID, handlerID, payload)
		local handlerFunction = wt.FindValueByKey(wt.FindValueByKey(hyperlinkHandlers, addonID), handlerID)

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


--[[ TABLE MANAGEMENT ]]

---Make a new deep copy (not reference) of an object (non-frame table)
---***
---@param object any Reference to the object to create a copy of
---***
---@return any copy Returns **object** if it's not a table or if it is a frame reference
function wt.Clone(object)
	if type(object) ~= "table" or wt.IsFrame(object) then return object end

	local copy = {}
	for k, v in pairs(object) do copy[k] = wt.Clone(v) end

	return copy
end

---Find and return the value at the first matching key via a deep search
---***
---@param tableToCheck table Reference to the table to find a value at a certain key in
---@param keyToFind any Key to look for in **tableToCheck** (including all subtables, recursively)
---***
---@return any|nil match The first match of the value found at **keyToFind**, or nil if no match was found
function wt.FindValueByKey(tableToCheck, keyToFind)
	if type(tableToCheck) ~= "table" then return nil end

	for k, v in pairs(tableToCheck) do
		if k == keyToFind then return v end

		local match = wt.FindValueByKey(v, keyToFind)

		if match ~= nil then return match end
	end

	return nil
end

---Find the first matching value and return its key via a deep search
---***
---@param tableToCheck table Reference to the table to find a value at a certain key in
---@param valueToFind any Value to look for in **tableToCheck** (including all subtables, recursively)
---***
---@return any|nil match The first match of the key of the found **valueToFind**, or nil if no match was found
function wt.FindKeyByValue(tableToCheck, valueToFind)
	if type(tableToCheck) ~= "table" then return nil end

	for k, v in pairs(tableToCheck) do
		if v == valueToFind then return k end

		local match = wt.FindKeyByValue(v, valueToFind)

		if match ~= nil then return match end
	end

	return nil
end

---Get a copy of the strings table or a subtable/value at the specified key used by this WidgetToolbox
---***
---@param key any Get the strings subtable/value at this key
---***
---@return table|string|nil # nil if **key** is specified but no match was found
function wt.GetStrings(key)
	return wt.Clone(wt.FindValueByKey(wt.strings, key))
end

---Merge a table to another table, deep copying all its values over under new integer keys
---***
---@param targetTable table Table to add the values to
---@param tableToMerge table Table to copy all values from
---***
---@return table targetTable Reference to **targetTable** (it was already overwritten during the operation, no need for setting it again)
function wt.MergeTable(targetTable, tableToMerge)
	if type(targetTable) ~= "table" and type(tableToMerge) ~= "table" then return targetTable end

	for _, v in pairs(tableToMerge) do table.insert(targetTable, wt.Clone(v)) end

	return targetTable
end

---Copy all values at matching keys from a sample table to another table while preserving all table references
---***
---@param targetTable table Reference to the table to copy the values to
---@param tableToCopy table Reference to the table to copy the values from
---***
---@return table|nil targetTable Reference to **targetTable** (the values were already overwritten during the operation, no need to set it again)
function wt.CopyValues(targetTable, tableToCopy)
	if type(tableToCopy) ~= "table" or type(targetTable) ~= "table" or wt.IsFrame(tableToCopy) or wt.IsFrame(targetTable) then return end
	if next(targetTable) == nil then return end

	for k, v in pairs(targetTable) do
		if tableToCopy[k] == nil then return end

		if type(v) == "table" then wt.CopyValues(v, tableToCopy[k]) else targetTable[k] = tableToCopy[k] end
	end

	return targetTable
end

---Remove all nil, empty or otherwise invalid items from a data table
---***
---@param tableToCheck table Reference to the table to prune
---@param valueChecker? fun(k: number|string, v: any): boolean Helper function for validating values, returning true if the value is to be accepted as valid
---***
---@return table|nil tableToCheck Reference to **tableToCheck** (it was already overwritten during the operation, no need for setting it again)
function wt.RemoveEmpty(tableToCheck, valueChecker)
	if type(tableToCheck) ~= "table" or wt.IsFrame(tableToCheck) then return end

	for k, v in pairs(tableToCheck) do
		if type(v) == "table" then
			if next(v) == nil then tableToCheck[k] = nil else wt.RemoveEmpty(v, valueChecker) end --Remove the subtable if it's empty
		else
			local remove = v == nil or v == "" --The value is empty or doesn't exist

			if valueChecker and not remove then remove = not valueChecker(k, v) end --Check if the value is invalid
			if remove then tableToCheck[k] = nil end --Remove the value
		end
	end

	return tableToCheck
end

---Compare two tables to check for and fill in missing data from one to the other (missing data will be cloned, breaking table references)
---***
---@param tableToCheck table|any Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already "table")
---@param tableToSample table Reference to the table to sample data from
---***
---@return table|nil tableToCheck Reference to **tableToCheck** (it was already updated during the operation, no need for setting it again)
function wt.AddMissing(tableToCheck, tableToSample)
	if not (type(tableToSample) == "table" and next(tableToSample) ~= nil) then return end

	if wt.IsFrame(tableToSample) then tableToCheck = tableToSample else
		for k, v in pairs(tableToSample) do
			tableToCheck = type(tableToCheck) == "table" and tableToCheck or {}

			--Add the missing item if the value is not empty or nil
			if tableToCheck[k] == nil and v ~= nil and v ~= "" then tableToCheck[k] = wt.Clone(v) else wt.AddMissing(tableToCheck[k], tableToSample[k]) end
		end
	end

	return tableToCheck
end

---Remove unused or outdated data from a table while comparing it to another table and assemble the list of removed keys
---***
---@param tableToCheck table|nil Reference to the table to remove unused key, value pairs from
---@param tableToSample table|nil Reference to the table to sample data from
---@param recoveredData? table
---@param recoveredKey? string
---***
---@return table recoveredData Table containing the removed key, value pairs (nested keys chained together with period characters in-between)
local function cleanTable(tableToCheck, tableToSample, recoveredData, recoveredKey)
	recoveredData = recoveredData or {}
	local tc, ts = type(tableToCheck), type(tableToSample)

	--| Utilities

	---Go deeper to fully map out recoverable keys
	---@param ttc table
	---@param rck string
	local function goDeeper(ttc, rck)
		if type(ttc) ~= "table" then return end

		for k, v in pairs(ttc) do
			if type(v) == "table" then goDeeper(v, rck .. (type(k) == "number" and ("[" .. k .. "]") or ("." .. k)))
			else recoveredData[(rck .. (type(k) == "number" and ("[" .. k .. "]") or ("." .. k))):sub(2)] = v end
		end
	end

	--| Compare types

	if tc ~= ts then
		local rk = (recoveredKey or "") .. (type(recoveredKey) == "number" and ("[" .. recoveredKey .. "]") or ("." .. recoveredKey))

		--Save the old item to the recovered data container
		if tc ~= "table" then recoveredData[rk:sub(2)] = tableToCheck else goDeeper(tableToCheck, rk) end

		--Remove the unneeded item
		tableToCheck = nil

		return recoveredData
	end

	--| Check subtables

	if tc ~= "table" or ts ~= "table" or wt.IsFrame(tableToCheck) or wt.IsFrame(tableToSample) then return recoveredData end
	if next(tableToCheck) == nil then return recoveredData end

	for key, value in pairs(tableToCheck) do
		local rk = (recoveredKey or "") .. (type(key) == "number" and ("[" .. key .. "]") or ("." .. key))

		if tableToSample[key] == nil then
			--Save the old item to the recovered data container
			if type(value) ~= "table" then recoveredData[rk:sub(2)] = value else goDeeper(value, rk) end

			--Remove the unneeded item
			tableToCheck[key] = nil
		else recoveredData = cleanTable(tableToCheck[key], tableToSample[key], recoveredData, rk) end
	end

	return recoveredData
end

---Remove unused or outdated data from a table while comparing it to another table while restoring any removed values
---***
---@param tableToCheck table Reference to the table to remove unused key, value pairs from
---@param tableToSample table Reference to the table to sample data from
---@param recoveryMap? table<string, recoveryData>|fun(tableToCheck: table, recoveredData: recoveredData): recoveryMap: table<string, recoveryData>|nil Static map or function returning a dynamically creatable map for removed but recoverable data
---@param onRecovery? fun(tableToCheck: table) Function called after the data has been has been recovered via the **recoveryMap**
---***
---@return table tableToCheck Reference to **tableToCheck** (it was already overwritten during the operation, no need for setting it again)
function wt.RemoveMismatch(tableToCheck, tableToSample, recoveryMap, onRecovery)
	local recoveredData = cleanTable(tableToCheck, tableToSample)

	if next(recoveredData) then
		if type(recoveryMap) == "function" then recoveryMap = recoveryMap(tableToCheck, recoveredData) end

		if type(recoveryMap) == "table" then for key, value in pairs(recoveredData) do
			if recoveryMap[key] then for i = 1, #recoveryMap[key].saveTo do
				recoveryMap[key].saveTo[i][recoveryMap[key].saveKey] = recoveryMap[key].convertSave and recoveryMap[key].convertSave(value) or value
			end end
		end end

		if type(onRecovery) == "function" then onRecovery(tableToCheck) end
	end

	return tableToCheck
end


--[[ FRAME MANAGEMENT ]]

--Used for a transitional step to avoid anchor family connections during safe frame positioning
local positioningAid

---Check if a table is a frame (or a backdrop object)
---@param t table
---***
---@return boolean|string # If **t** is recognized as a [FrameScriptObject](https://warcraft.wiki.gg/wiki/UIOBJECT_FrameScriptObject), return true, or, return the frame name if named or the debug name if unnamed but recognized as a UI [Object](https://warcraft.wiki.gg/wiki/UIOBJECT_Object) with a parent, otherwise, return false
function wt.IsFrame(t)
	if type(t) ~= "table" then return false end

	return t.GetObjectType and t.IsObjectType and
	(t.GetName and t:GetName() or t.GetParent and t:GetParent() and t.GetDebugName and t:GetDebugName() or true) or false
end

---Set the position and anchoring of a frame when it is unknown which parameters will be nil
---***
---@param frame AnyFrameObject Reference to the frame to be moved
---@param position? positionData Table of parameters to call **frame**:[SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
---@param unlink? boolean If true, unlink the position of **frame** from **position.relativeTo** (preventing anchor family connections) by moving a positioning aid frame to **position** first, convert its position to absolute, breaking relative links (making it relative to screen points instead), then move **frame** to the position of the aid | ***Default:*** false
---@param userPlaced? boolean Remember the position if **frame**:[IsMovable()](https://warcraft.wiki.gg/wiki/API_Frame_IsMovable) | ***Default:*** true
function wt.SetPosition(frame, position, unlink, userPlaced)
	if not frame.SetPoint then return end

	local anchor, relativeTo, relativePoint, offsetX, offsetY = wt.UnpackPosition(position)
	relativeTo = relativeTo ~= "nil" and relativeTo or nil

	--Set the position
	if relativeTo and unlink then
		if not positioningAid then
			positioningAid = CreateFrame("Frame", ns.name .. "PositioningAid", UIParent)

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
---@param frame AnyFrameObject Reference to the frame to be update
---@param anchor FramePoint New anchor point to set
---@return number offsetX The new horizontal offset value
---@return number offsetY The new vertical offset value
function wt.SetAnchor(frame, anchor)
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
	if not frame.IsMovable then return end

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
	t = t or {}
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
			--Add the description to the list
			if frames[i].arrangementInfo.newRow ~= false or #t.order == 0 then
				--To be placed in a new row
				table.insert(t.order, { i })
			else
				--Assign row
				local rowCount = #t.order
				frames[i].arrangementInfo.row = frames[i].arrangementInfo.row and (
					frames[i].arrangementInfo.row < rowCount and frames[i].arrangementInfo.row
				) or rowCount

				--Assign column
				local columnCount = #t.order[frames[i].arrangementInfo.row or 1]
				frames[i].arrangementInfo.column = frames[i].arrangementInfo.column and (
					frames[i].arrangementInfo.column <= columnCount and frames[i].arrangementInfo.column
				) or columnCount + 1

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
---<hr><p></p>
function wt.SetMovability(frame, movable, t)
	if not frame.SetMovable then return end

	movable = movable == true
	t = t or {}
	t.triggers = t.triggers or { frame }
	if t.cursor == nil then t.cursor = t.modifier ~= nil end
	local modifier = t.modifier and wt.GetModifierChecker(t.modifier) or nil
	local position

	frame:SetMovable(movable)

    if movable then
		local hadEvent, isMoving

		position = wt.PackPosition(frame:GetPoint())

		--Toggle movement cursor
		if modifier then
			hadEvent = frame:IsEventRegistered("MODIFIER_STATE_CHANGED")

			frame:HookScript("OnEvent", function(_, event, key, down) if event == "MODIFIER_STATE_CHANGED" and key:find(t.modifier) then
				if down > 0 then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") else SetCursor(nil) end
			end end)
		end

		for i = 1, #t.triggers do
            t.triggers[i]:EnableMouse(true)

			--| Cursor

			--Set movement cursor
			t.triggers[i]:HookScript("OnEnter", function()
				if not t.cursor or not frame:IsMovable() then return end

				if not modifier then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") else
					if modifier() then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") end

					frame:RegisterEvent("MODIFIER_STATE_CHANGED")
				end
			end)

			--Reset cursor
			t.triggers[i]:HookScript("OnLeave", function()
				if not t.cursor or not frame:IsMovable() then return end

				SetCursor(nil)

				if modifier and not hadEvent then frame:UnregisterEvent("MODIFIER_STATE_CHANGED") end
			end)


            --| Movement

			t.triggers[i]:HookScript("OnMouseDown", function()
				if not frame:IsMovable() or isMoving then return end
				if modifier and not modifier() then return end

				--Store position
				position = wt.PackPosition(frame:GetPoint())

				--Start moving
				frame:StartMoving()
				isMoving = true
				if (t.events or {}).onStart then t.events.onStart() end

				--| Start the movement updates

				if t.triggers[i]:HasScript("OnUpdate") then t.triggers[i]:SetScript("OnUpdate", function()
					if (t.events or {}).onMove then t.events.onMove() end

					--Check if the modifier key is pressed
					if modifier then
						if modifier() then return end

						--Cancel when the modifier key is released
						frame:StopMovingOrSizing()
						isMoving = false
						if (t.events or {}).onCancel then t.events.onCancel() end

						--Reset the position
						wt.SetPosition(frame, position)

						--Stop checking if the modifier key is pressed
						t.triggers[i]:SetScript("OnUpdate", nil)
					end
				end) end
			end)

			t.triggers[i]:HookScript("OnMouseUp", function()
				if not frame:IsMovable() or not isMoving then return end

				--Stop moving
				frame:StopMovingOrSizing()
				isMoving = false
				if (t.events or {}).onStop then t.events.onStop() end

				--Stop the movement updates
				if t.triggers[i]:HasScript("OnUpdate") then t.triggers[i]:SetScript("OnUpdate", nil) end
			end)

			t.triggers[i]:HookScript("OnHide", function()
				if not frame:IsMovable() or not isMoving then return end

				--Cancel moving
				frame:StopMovingOrSizing()
				isMoving = false
				if (t.events or {}).onCancel then t.events.onCancel() end

				--Reset the position
				wt.SetPosition(frame, position)

				--Stop the movement updates
				if t.triggers[i]:HasScript("OnUpdate") then t.triggers[i]:SetScript("OnUpdate", nil) end
			end)
		end
	else for i = 1, #t.triggers do t.triggers[i]:EnableMouse(false) end end
end

---Set the visibility of a frame based on the value provided
---***
---@param frame AnyFrameObject Reference to the frame to hide or show
---@param visible? boolean If false, hide the frame, show it if true | ***Default:*** false
function wt.SetVisibility(frame, visible)
	if visible then frame:Show() else frame:Hide() end
end

---Set the backdrop of a frame with BackdropTemplate with the specified parameters
---***
---@param frame backdropFrame|AnyFrameObject Reference to the frame to set the backdrop of
--- - ***Note:*** The template of **frame** must have been set as: `BackdropTemplateMixin and "BackdropTemplate"`.
---@param backdrop? backdropData Parameters to set the custom backdrop with | ***Default:*** nil *(remove the backdrop)*
---@param updates? table<AnyScriptType, backdropUpdateRule> Table of key, value pairs containing the list of events to set listeners for assigned to **updates[*key*].frame**, linking backdrop changes to it, modifying the specified parameters on trigger
--- - ***Note:*** All update rules are additive, calling ***WidgetToolbox*.SetBackdrop(...)** multiple times with **updates** specified *will not* override previously set update rules. The base **backdrop** values used for these old rules *will not* change by setting a new backdrop via ***WidgetToolbox*.SetBackdrop(...)** either!
function wt.SetBackdrop(frame, backdrop, updates)
	if not frame.SetBackdrop then return end

	--[ Set Backdrop ]

	---@param t? backdropData
	local function setBackdrop(t)
		if not t then
			frame:ClearBackdrop()

			return
		end

		t.background = t.background or {}
		t.border = t.border or {}
		t.background.texture = t.background.texture or {}
		t.background.texture.insets = t.background.texture.insets or {}
		t.border.texture = t.border.texture or {}

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

	if updates then for key, value in pairs(updates) do
		value.trigger = value.trigger or frame
		if value.trigger:HasScript(key) then value.trigger:HookScript(key, function(self, ...)
			--Unconditional: Restore the base backdrop on event trigger
			if not value.rule then
				setBackdrop(backdrop)

				return
			end

			--Conditional: Evaluate the rule
			local backdropUpdate, fill = value.rule(self, ...)

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
				backdropUpdate = backdrop and wt.AddMissing(backdropUpdate, backdrop) or nil
			else
				--Fill backdrop update table with the current values
				if frame.backdropInfo then
					--Background
					backdropUpdate.background = backdropUpdate.background or {}
					backdropUpdate.background.texture = backdropUpdate.background.texture or wt.AddMissing(backdropUpdate.background.texture, {
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
					backdropUpdate.border.texture = backdropUpdate.border.texture or wt.AddMissing(backdropUpdate.border.texture, {
						path = frame.backdropInfo.edgeFile,
						width = frame.backdropInfo.edgeSize,
					})
					backdropUpdate.border.color = backdropUpdate.border.color or wt.PackColor(frame:GetBackdropColor())
				else backdropUpdate = nil end
			end

			--Update the backdrop
			setBackdrop(backdropUpdate)
		end) end
	end end
end

---Check and evaluate all dependencies in a ruleset
---***
---@param rules dependencyRule[] Indexed table containing the dependency rules to check
---@return boolean? state
function wt.CheckDependencies(rules)
	if not type(rules) == "table" then return end

	local state = true

	for i = 1, #rules do
		if wt.IsFrame(rules[i].frame) then --Base Blizzard frame objects
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

---Assign dependency rule listeners from a defined a ruleset
---***
---@param rules dependencyRule[] Indexed table containing the dependency rules to add
---@param setState fun(state: boolean) Function to call to set the state of the frame, enabling it on a true, or disabling it on a false input
function wt.AddDependencies(rules, setState)
	if not type(rules) == "table" or not type(setState) == "function" then return end

	--Update utility
	local setter = function() setState(wt.CheckDependencies(rules)) end

	--Set listeners
	for i = 1, #rules do if rules[i].frame then
		if wt.IsFrame(rules[i].frame) then --Base Blizzard frames
			--Watch value change events
			if rules[i].frame:IsObjectType("CheckButton") then rules[i].frame:HookScript("OnClick", setter)
			elseif rules[i].frame:IsObjectType("EditBox") then rules[i].frame:HookScript("OnTextChanged", setter)
			elseif rules[i].frame:IsObjectType("Slider") then rules[i].frame:HookScript("OnValueChanged", setter)
			end
		elseif rules[i].frame.isType then --Custom WidgetTools widgets
			--Watch value load events
			rules[i].frame.setListener.loaded(function(_, success) if success then setter() end end)

			--Watch value change events
			if rules[i].frame.isType("Toggle") then rules[i].frame.setListener.toggled(setter)
			elseif rules[i].frame.isType("Selector") or rules[i].frame.isType("Multiselector") or rules[i].frame.isType("SpecialSelector") then
				rules[i].frame.setListener.selected(setter)
			elseif rules[i].frame.isType("Textbox") or rules[i].frame.isType("Numeric") then rules[i].frame.setListener.changed(setter)
			end
		end
	end end

	--Initialize state
	setter()
end


--[[ SETTINGS DATA MANAGEMENT ]]

--Settings data management rule registry
---@class settingsRegistry
---@field rules table<string, settingsRule[]> Collection of rules describing where to save/load settings data to/from, and what change handlers to call in the process linked to each specific settings category under an addon
---@field changeHandlers table<string, function> List of pairs of addon-specific unique keys and change handler scripts
wt.settingsTable = { rules = {}, changeHandlers = {} }

---Register a settings data management entry for a settings widget to the settings data management registry for batched data handling
---***
---@param widget checkbox|radioButton|radioSelector|checkboxSelector|specialSelector|dropdownSelector|textbox|multilineEditbox|numericSlider|colorPicker Reference to the widget to be saved & loaded data to/from with defined **widget.loadData()** & **widget.saveData()** functions
---@param t settingsData Parameters are to be provided in this table
function wt.AddSettingsDataManagementEntry(widget, t)
	if not widget or not type(t) == "table" then return end

	t.category = t.category or "WidgetTools"
	t.key = t.key or ""
	local key = t.category .. t.key

	wt.settingsTable.rules[key] = wt.settingsTable.rules[key] or {}

	--Add onChange handlers
	if type(t.onChange) == "table" then
		local newKeys = {}

		for k, v in pairs(t.onChange) do if type(k) == "string" and type(v) == "function" then
			--Store the function
			wt.settingsTable.changeHandlers[t.category .. k] = v

			--Remove the function definitions, save their keys
			t.onChange[k] = nil
			table.insert(newKeys, k)
		end end

		--Add saved new keys
		for i = 1, #newKeys do table.insert(t.onChange, newKeys[i]) end
	end

	--Add to the registry
	if type(t.index) ~= "number" then table.insert(wt.settingsTable.rules[key], { widget = widget, onChange = t.onChange })
	else table.insert(wt.settingsTable.rules[key], Clamp(wt.Round(t.index), 1, #wt.settingsTable.rules[key] + 1), { widget = widget, onChange = t.onChange }) end
end

---Load all data from storage to the widgets specified in in the settings data management registry referenced by the specified settings category under the specified key by calling **[*widget*].loadData(...)** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
---@param applyChanges? any If not nil, apply changes by calling all registered **onChange** handlers | ***Default:*** nil
function wt.LoadSettingsData(category, key, applyChanges)
	category = category or "WidgetTools"
	key = category .. (key or "")

	if not wt.settingsTable.rules[key] then return end

	if applyChanges then applyChanges = {} end

	for i = 1, #wt.settingsTable.rules[key] do
		wt.settingsTable.rules[key][i].widget.loadData(false)

		--Register onChange handlers for call
		if applyChanges and type(wt.settingsTable.rules[key][i].onChange) == "table" then
			for j = 1, #wt.settingsTable.rules[key][i].onChange do applyChanges[category .. wt.settingsTable.rules[key][i].onChange[j]] = true end
		end
	end

	--Call registered onChange handlers
	if applyChanges then for k in pairs(applyChanges) do wt.settingsTable.changeHandlers[k]() end end
end

---Save all data from the widgets to storage specified in in the settings data management registry referenced by the specified settings category under the specified key by calling **[*widget*].saveData(...)** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.SaveSettingsData(category, key)
	key = (category or "WidgetTools") .. (key or "")

	if not wt.settingsTable.rules[key] then return end

	for i = 1, #wt.settingsTable.rules[key] do wt.settingsTable.rules[key][i].widget.saveData() end
end

---Call all **onChange** handlers registered in in the settings data management registry referenced by the specified settings category under the specified key
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.ApplySettingsData(category, key)
	category = category or "WidgetTools"
	key = category .. (key or "")

	if not wt.settingsTable.rules[key] then return end

	local handlers = {}

	--Register onChange handlers for call
	for i = 1, #wt.settingsTable.rules[key] do if type(wt.settingsTable.rules[key][i].onChange) == "table" then
		for j = 1, #wt.settingsTable.rules[key][i].onChange do handlers[category .. wt.settingsTable.rules[key][i].onChange[j]] = true end
	end end

	--Call registered onChange handlers
	if handlers then for k in pairs(handlers) do wt.settingsTable.changeHandlers[k]() end end
end

---Set a data snapshot for each widget specified in in the settings data management registry referenced by the specified settings category by under the specified key calling **[*widget*].revertData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.SnapshotSettingsData(category, key)
	key = (category or "WidgetTools") .. (key or "")

	if not wt.settingsTable.rules[key] then return end

	for i = 1, #wt.settingsTable.rules[key] do wt.settingsTable.rules[key][i].widget.snapshotData() end
end

---Set & load the stored data managed by each widget specified in in the settings data management registry referenced by the specified settings category under the specified key by calling **[*widget*].revertData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.RevertSettingsData(category, key)
	category = category or "WidgetTools"
	key = category .. (key or "")

	if not wt.settingsTable.rules[key] then return end

	local applyChanges = {}

	for i = 1, #wt.settingsTable.rules[key] do
		wt.settingsTable.rules[key][i].widget.revertData(false)

		--Register onChange handlers for call
		for i = 1, #wt.settingsTable.rules[key] do if applyChanges and type(wt.settingsTable.rules[key][i].onChange) == "table" then
			for j = 1, #wt.settingsTable.rules[key][i].onChange do applyChanges[category .. wt.settingsTable.rules[key][i].onChange[j]] = true end
		end end
	end

	--Call registered onChange handlers
	if applyChanges then for k in pairs(applyChanges) do wt.settingsTable.changeHandlers[k]() end end
end

---Set & load the default data managed by each widget specified in in the settings data management registry referenced by the specified settings category under the specified key by calling **[*widget*].resetData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.ResetSettingsData(category, key)
	category = category or "WidgetTools"
	key = category .. (key or "")

	if not wt.settingsTable.rules[key] then return end

	local applyChanges = {}

	for i = 1, #wt.settingsTable.rules[key] do
		wt.settingsTable.rules[key][i].widget.resetData(false)

		--Register onChange handlers for call
		for i = 1, #wt.settingsTable.rules[key] do if applyChanges and type(wt.settingsTable.rules[key][i].onChange) == "table" then
			for j = 1, #wt.settingsTable.rules[key][i].onChange do applyChanges[category .. wt.settingsTable.rules[key][i].onChange[j]] = true end
		end end
	end

	--Call registered onChange handlers
	if applyChanges then for k in pairs(applyChanges) do wt.settingsTable.changeHandlers[k]() end end
end


--[[ SETTINGS PAGE MANAGEMENT ]]

---Register the settings page to the Settings window if it wasn't already
--- - ***Note:*** No settings page will be registered if **WidgetToolsDB.lite** is true.
---@param page settingsPage Reference to the settings page to register to Settings
---@param parent? settingsPage Reference to the parent settings page to set **page** as a child category page of | ***Default:*** *set as a parent category page*
---@param icon? boolean If true, append the icon set for the settings page to its button title in the AddOns list of the Settings window as well | ***Default:*** true if **parent** == nil
function wt.RegisterSettingsPage(page, parent, icon)
	if WidgetToolsDB.lite or type(page) ~= "table" or type(page.isType) ~= "function" or not page.isType("SettingsPage") or page.category then return end

	local title = (page.title and page.title or "") .. (icon or not parent and page.icon and (" " .. wt.Texture(page.icon)) or "")

	page.canvas.OnCommit = function() page.save(true) end
	page.canvas.OnRefresh = function() page.load(nil, true) end
	page.canvas.OnDefault = function() page.default(true) end

	if parent then page.category = Settings.RegisterCanvasLayoutSubcategory(parent.category, page.canvas, title)
	else page.category = Settings.RegisterCanvasLayoutCategory(page.canvas, title) end

	Settings.RegisterAddOnCategory(page.category)
end


--[[ Chat Control ]]

---Register a list of chat keywords and related commands for use
---***
---@param addon string The name of the addon's folder (the addon namespace not the display title)
---@param keywords string[] List of addon-specific keywords to register to listen to when typed as slash commands<ul><li>***Note:*** A slash character (`/`) will appended before each keyword specified here during registration, it doesn't need to be included.</li></ul>
---@param t chatCommandManagerCreationData Parameters are to be provided in this table
---***
---@return chatCommandManager manager Table containing command handler functions
function wt.RegisterChatCommands(addon, keywords, t)
	t = t or {}

	local logo = C_AddOns.GetAddOnMetadata(addon, "IconTexture")
	logo = logo and (wt.Texture(logo, 11, 11) .. " ") or nil
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
	---@param contentColor? chatCommandColorNames|colorData ***Default:*** "content"
	---@param titleColor? chatCommandColorNames|colorData ***Default:*** "title"
	function manager.print(message, title, titleColor, contentColor)
		title = type(title) == "string" or branding
		titleColor = type(titleColor) == "table" and titleColor or t.colors[type(titleColor) == "string" and titleColor or "title"]
		contentColor = type(contentColor) == "table" and contentColor or t.colors[type(contentColor) == "string" and contentColor or "content"]

		if type(message) == "string" then print(wt.Color(title, titleColor) .. wt.Color(message, contentColor)) end
	end

	--Print a welcome message with a hint about chat keywords
	function manager.welcome()
		local keyword = wt.Color(keywords[1], t.colors.command)
		if #keywords > 1 then
			if #keywords > 2 then for i = 2, #keywords - 1 do keyword = " " .. keyword .. "," .. wt.Color(keywords[i], t.colors.command) end end
			keyword = wt.strings.chat.welcome.keywords:gsub("#KEYWORD_ALTERNATE", wt.Color(keywords[#keywords], t.colors.command)):gsub("#KEYWORD", keyword)
		end

		print(wt.Color(logo .. wt.strings.chat.welcome.thanks:gsub("#ADDON", wt.Color(addonTitle, t.colors.title)), t.colors.content))
		print(wt.Color(wt.strings.chat.welcome.hint:gsub("#KEYWORD", keyword), t.colors.description))

		if type(t.onWelcome) == "function" then t.onWelcome() end
	end

	--Trigger a help command, listing all registered chat commands with their specified descriptions, calling their onHelp handlers
	function manager.help()
		print(wt.Color(wt.strings.chat.help.list:gsub("#ADDON", wt.Color(logo .. addonTitle, t.colors.title)), t.colors.content))

		for i = 1, #t.commands do
			if not t.commands[i].hidden then
				local description = type(t.commands[i].description) == "function" and t.commands[i].description() or t.commands[i].description

				print(wt.Color("    " .. keywords[1] .. " ".. t.commands[i].command, t.colors.command) .. (
					type(description) == "string" and wt.Color(" • " .. description, t.colors.description) or ""
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