--[[ ADDON INFO ]]

--Addon namespace string & table
local addonNameSpace, ns = ...


--[[ WIDGET TOOLBOX ]]

--Version string
local toolboxVersion = "1.5"

---@class WidgetToolbox
ns.WidgetToolbox = WidgetTools.RegisterToolbox(addonNameSpace, toolboxVersion, nil, ns.textures.logo) or {}

--Create a new toolbox
if not next(ns.WidgetToolbox) then

	---@class WidgetToolbox
	local wt = ns.WidgetToolbox


	--[[ LOCALIZATIONS ]]

	local english = {
		temp = {
			dfOpenSettings = "\nOpening subcategories is not yet supported in Dragonflight. Expand the #ADDON options on the left to navigate here manually." --# flags will be replaced with code, \n represents the newline character
		},
		reload = {
			title = "Pending Changes",
			description = "Reload the interface to apply the pending changes.",
			accept = {
				label = "Reload Now",
				tooltip = "You may choose to reload the interface now to apply the pending changes.",
			},
			cancel = {
				label = "Close",
				tooltip = "Reload the interface later with the /reload chat command or by logging out.",
			},
		},
		copy = {
			textline = {
				label = "Click to copy",
				tooltip = "Click on the text to reveal the text field where you'll be able to copy the text from."
			},
			editbox = {
				label = "Copy the text",
				tooltip = "You may copy the contents of the text field by pressing Ctrl + C (on Windows) or Command + C (on Mac).",
			},
		},
		slider = {
			value = {
				label = "Specify the value",
				tooltip = "Enter any value within range.",
			},
			decrease = {
				label = "Decrease",
				tooltip = "Subtract #VALUE from the value.",
			},
			increase = {
				label = "Increase",
				tooltip = "Add #VALUE to the value.",
			},
		},
		color = {
			picker = {
				label = "Pick a color",
				tooltip = "Open the color picker to customize the color#ALPHA.", --# flags will be replaced with code
				alpha = " and change the opacity",
			},
			hex = {
				label = "Add via HEX color code",
				tooltip = "You may change the color via HEX code instead of using the color picker.",
			}
		},
		options = {
			save = "Changes will be saved on close.",
			cancel = "Revert Changes",
			default = "Restore Defaults",
			accept = "These Settings",
			warning = "Are you sure you want to revert the\n#TITLE\nsettings to their default values?", --\n represents the newline character, # flags will be replaced with code
		},
		points = {
			left = "Left",
			right = "Right",
			center = "Center",
			top = {
				left = "Top Left",
				right = "Top Right",
				center = "Top Center",
			},
			bottom = {
				left = "Bottom Left",
				right = "Bottom Right",
				center = "Bottom Center",
			},
		},
		misc = {
			accept = "Accept",
			cancel = "Cancel",
			default = "Default",
			example = "Example",
		},
		separator = ",", --Thousand separator character
		decimal = ".", --Decimal character
	}

	--Load the current localization
	local function LoadLocale()
		local strings
		if (GetLocale() == "") then
			--TODO: Add localization for other languages (locales: https://wowpedia.fandom.com/wiki/API_GetLocale#Values)
			--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml#L8
		else --Default: English (UK & US)
			strings = english
		end
		return strings
	end

	local strings = LoadLocale()


	--[[ UTILITIES ]]

	--[ Table Management ]

	---Get the sorted key value pairs of a table ([Documentation: Sort](https://www.lua.org/pil/19.3.html))
	---@param t table Table to be sorted (in an ascending order and/or alphabetically, based on the < operator)
	---@return function iterator Function returning the Key, Value pairs of the table in order
	wt.SortedPairs = function(t)
		local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, function(x, y) if type(x) == "number" and type(y) == "number" then return x < y else return tostring(x) < tostring(y) end end)
		local i = 0
		local iterator = function ()
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]] end
		end
		return iterator
	end

	---Convert and format an input object to string to be dumped to the in-game chat
	---@param object any Object to dump out
	---@param outputTable? table Table to put the formatted output lines in
	---@param name? string A name to print out | ***Default:*** *the dumped object will not be named*
	---@param depth? integer How many levels of subtables to print out (root level: 0) | ***Default:*** *full depth*
	---@param blockrule? function Function to manually filter which keys get printed and explored further
	--- - @*param* **key** integer|string ― The currently dumped key
	--- - @*return* boolean ― Skip the key if the returned value is true
	---@param currentKey? string
	---@param currentLevel? integer
	local function GetDumpOutput(object, outputTable, name, blockrule, depth, currentKey, currentLevel)
		--Check whether the current key is to be skipped
		local skip = false
		if currentKey and blockrule then skip = blockrule(currentKey) end
		--Calculate indentation based on the current depth level
		currentLevel = currentLevel or 0
		local indentation = ""
		for i = 1, currentLevel do indentation = indentation .. "    " end
		--Format the name and key
		currentKey = currentKey and indentation .. "|cFFACD1EC" .. currentKey .. "|r" or nil
		name = name and "|cFF69A6F8" .. name .. "|r " or ""
		--Add the line to the output
		if type(object) ~= "table" then
			local line = (currentKey and currentKey .. " = " or "Dump " .. name .. "value: ") .. (skip and "…" or tostring(object))
			outputTable[outputTable[0] and #outputTable + 1 or 0] = line
			return
		else
			local s = (currentKey and currentKey or "Dump " .. name .. "table") .. ":"
			--Stop at the max depth or if the key is skipped
			if skip or currentLevel >= (depth or currentLevel + 1) then
				outputTable[outputTable[0] ~= nil and #outputTable + 1 or 0] = s .. " {…}"
				return
			end
			outputTable[outputTable[0] ~= nil and #outputTable + 1 or 0] = s
			--Convert & format the subtable
			for k, v in wt.SortedPairs(object) do GetDumpOutput(v, outputTable, nil, blockrule, depth, k, currentLevel + 1) end
		end
	end

	---Dump an object and its contents to the in-game chat
	---@param object any Object to dump out
	---@param name? string A name to print out | ***Default:*** *the dumped object will not be named*
	---@param blockrule? function Function to manually filter which keys get printed and explored further
	--- - @*param* **key** integer|string ― The currently dumped key
	--- - @*return* boolean ― Skip the key if the returned value is true
	--- - ***Example - Comparison:*** Skip the key based the result of a comparison between it (if it's an index) and a specified number value
	--- 	```
	--- 	function(key)
	--- 		if type(key) == "number" then --check if the key is an index to avoid issues with mixed tables
	--- 			return key < 10
	--- 		end
	--- 			return true --or false whether to allow string keys in mixed tables
	--- 	end
	--- 	```
	--- - ***Example - Blocklist:*** Iterate through an array (indexed table) containing keys, the values of which are to be skipped
	--- 	```
	--- 	function(key)
	--- 		local blocklist = {
	--- 			[0] = "skip_key",
	--- 			[1] = 1,
	--- 		}
	--- 		for i = 0, #blocklist do
	--- 			if key == blocklist[i] then
	--- 				return true --or false to invert the functionality and treat the blocklist as an allowlist
	--- 			end
	--- 		end
	--- 			return false --or true to invert the functionality and treat the blocklist as an allowlist
	--- 	end
	--- 	```
	---@param depth? integer How many levels of subtables to print out (root level: 0) | ***Default:*** *full depth*
	---@param linesPerMessage? integer Print the specified number of output lines in a single chat message (all lines in one message: 0) | ***Default:*** 7
	wt.Dump = function(object, name, blockrule, depth, linesPerMessage)
		--Get the output lines
		local output = {}
		GetDumpOutput(object, output, name, blockrule, depth)
		--Print the output
		local lineCount = 0
		local message = ""
		for i = 0, #output do
			lineCount = lineCount + 1
			message = message .. ((lineCount > 1 and i > 0) and "\n" .. output[i]:sub(5) or output[i])
			if lineCount == (linesPerMessage or 7) or i == #output then
				print(message)
				lineCount = 0
				message = ""
			end
		end
	end

	---Convert table into a LUA code chunk
	--- - ***Note:*** Append "return " to the start when loading via [load()](https://www.lua.org/manual/5.2/manual.html#lua_load).
	---@param table table The table to convert
	---@param compact? boolean Whether spaces and indentations should be trimmed or not | ***Default:*** false
	---@param colored? boolean Whether the string should be formatted by included coloring escape sequences | ***Default:*** false
	---@param currentLevel? number
	---@return string chunk
	wt.TableToString = function(table, compact, colored, currentLevel)
		if type(table) ~= "table" then return tostring(table) end
		--Set whitespaces, calculate indentation based on the current depth level
		local s = not compact and " " or ""
		local nl = not compact and "\n" or ""
		local indentation = ""
		currentLevel = currentLevel or 0
		if not compact then for i = 0, currentLevel do indentation = indentation .. "    " end end
		--Set coloring escape sequences
		local c = "|cFF999999" --base color (grey)
		local ck = "|cFFFFFFFF" --key (white)
		local cbt = "|cFFAAAAFF" --boolean true value (blue)
		local cbf = "|cFFFFAA66" --boolean false value (orange)
		local cn = "|cFFDDDD55" --number value (yellow)
		local cs = "|cFF55DD55" --string value (green)
		local cv = "|cFFDD99FF" --misc value (purple)
		local r = "|r" --end end previously defined coloring
		--Assemble
		local chunk = c .. "{"
		for k, v in pairs(table) do
			--Key
			chunk = chunk .. nl .. indentation .. (type(k) ~= "string" and "[" .. ck .. tostring(k) .. r .. "]" or ck .. k .. r) .. s .. "="
			--Value
			chunk = chunk .. s
			if type(v) == "table" then
				chunk = chunk .. wt.TableToString(v, compact, colored, currentLevel + 1)
			elseif type(v) == "boolean" then
				chunk = chunk .. (v and cbt or cbf) .. tostring(v) .. r
			elseif type(v) == "number" then
				chunk = chunk .. cn .. tostring(v) .. r
			elseif type(v) == "string" then
				chunk = chunk .. cs .. "\"" .. v .. "\"" .. r
			else
				chunk = chunk .. cv .. tostring(v) .. r
			end
			--Add separator
			chunk = chunk .. ","
		end
		return ((chunk .. "}"):gsub("," .. "}", (not compact and "," or "") .. nl .. indentation:gsub("%s%s%s%s(.*)", "%1") .. "}") .. r)
	end

	---Make a new deep copy (not reference) of an object (table)
	---@param object any Reference to the object to create a copy of
	---@return any copy Returns **object** if it's not a table
	wt.Clone = function(object)
		if type(object) ~= "table" then return object end
		local copy = {}
		for k, v in pairs(object) do
			copy[k] = wt.Clone(v)
		end
		return copy
	end

	---Copy all values at matching keys from a sample table to another table while preserving all table references
	---@param tableToCopy table Reference to the table to copy the values from
	---@param targetTable table Reference to the table to copy the values to
	---@return table targetTable Reference to **targetTable** (the values were already overwritten during the operation, no need to set it again)
	wt.CopyValues = function(tableToCopy, targetTable)
		if type(tableToCopy) ~= "table" or type(targetTable) ~= "table" then return end
		if next(targetTable) == nil then return end --The target table is empty
		for k, v in pairs(targetTable) do
			if tableToCopy[k] == nil then return end --This key doesn't exist in the sample table
			if type(v) == "table" then
				wt.CopyValues(tableToCopy[k], v)
			else
				targetTable[k] = tableToCopy[k]
			end
		end
		return targetTable
	end

	---Remove all nil, empty or otherwise invalid items from a data table
	---@param tableToCheck table Reference to the table to prune
	---@param valueChecker? function Optional function describing rules to validate values
	--- - @*param* **k** number|string
	--- - @*param* **v** any [non-table]
	--- - @*return* boolean ― True if **v** is to be accepted as valid, false if not
	---@return table tableToCheck Reference to **tableToCheck** (it was already overwritten during the operation, no need for setting it again)
	wt.RemoveEmpty = function(tableToCheck, valueChecker)
		if type(tableToCheck) ~= "table" then return end
		for k, v in pairs(tableToCheck) do
			if type(v) == "table" then
				if next(v) == nil then --The subtable is empty
					tableToCheck[k] = nil --Remove the empty subtable
				else
					wt.RemoveEmpty(v, valueChecker)
				end
			else
				local remove = v == nil or v == "" --The value is empty or doesn't exist
				if valueChecker and not remove then remove = not valueChecker(k, v) end--The value is invalid
				if remove then tableToCheck[k] = nil end --Remove the key value pair
			end
		end
		return tableToCheck
	end

	---Compare two tables to check for and fill in missing data from one to the other
	---@param tableToCheck table|any Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already "table")
	---@param tableToSample table Reference to the table to sample data from
	---@return table tableToCheck Reference to **tableToCheck** (it was already overwritten during the operation, no need for setting it again)
	wt.AddMissing = function(tableToCheck, tableToSample)
		if type(tableToSample) ~= "table" then return end
		if next(tableToSample) == nil then return end --The sample table is empty
		tableToCheck = type(tableToCheck) ~= "table" and {} or tableToCheck --The table to check isn't actually a table - turn it into a new one
		for k, v in pairs(tableToSample) do
			if tableToCheck[k] == nil then --The sample key doesn't exist in the table to check
				if v ~= nil and v ~= "" then
					tableToCheck[k] = v --Add the item if the value is not empty or nil
				end
			else
				wt.AddMissing(tableToCheck[k], tableToSample[k])
			end
		end
		return tableToCheck
	end

	---Remove unused or outdated data from a table while trying to keep any old data
	---@param tableToCheck table Reference to the table to remove unneeded key, value pairs from
	---@param tableToSample table Reference to the table to sample data from
	---@param recoveredData? table
	---@param recoveredKey? string
	---@return table recoveredData Table containing the removed key, value pairs (nested keys chained together with period characters in-between)
	---@return table tableToCheck Reference to **tableToCheck** (it was already overwritten during the operation, no need for setting it again)
	wt.RemoveMismatch = function(tableToCheck, tableToSample, recoveredData, recoveredKey)
		if not recoveredData then recoveredData = {} end
		if type(tableToCheck) ~= "table" or type(tableToSample) ~= "table" then return recoveredData end
		if next(tableToCheck) == nil then return end --The table to check is empty
		for key, value in pairs(tableToCheck) do
			local rk = recoveredKey or ""
			rk = rk .. key .. "."
			if tableToSample[key] == nil then --The checked key doesn't exist in the sample table
				--Save the old item to the recovered data container
				if type(value) ~= "table" then recoveredData[rk:sub(1, -2)] = value
				else
					--Go deeper to fully map out recoverable keys
					local function GoDeeper(ttc, rck)
						if type(ttc) ~= "table" then return end
						local r = rck
						for k, v in pairs(ttc) do
							r = rck .. k .. "."
							GoDeeper(v, r)
							if type(v) ~= "table" then recoveredData[r:sub(1, -2)] = v end
						end
					end
					GoDeeper(value, rk)
				end
				--Remove the unneeded item
				tableToCheck[key] = nil
			else recoveredData = wt.RemoveMismatch(tableToCheck[key], tableToSample[key], recoveredData, rk) end
		end
		return recoveredData, tableToCheck
	end

	---Find a value within a table at the at the first matching key
	---@param tableToCheck table Reference to the table to find a value at a certain key in
	---@param keyToFind any Key to look for in **tableToCheck** (including all subtables, recursively)
	---@return any|nil match Value found at **keyToFind**, returns the first match only
	wt.FindKey = function(tableToCheck, keyToFind)
		if type(tableToCheck) ~= "table" then return nil end
		for k, v in pairs(tableToCheck) do
			if k == keyToFind then return v end
			local match = wt.FindKey(v, keyToFind)
			if match then return match end
		end
		return nil
	end

	---Get a copy of the strings table or a subtable/value at the specified key used by this WidgetToolbox
	---@param key any Get the strings subtable/value at this key
	---@return table|string|nil value Nil, if **key** is specified but no match was found
	wt.GetStrings = function(key)
		return wt.Clone(wt.FindKey(strings, key))
	end

	--[ Math ]

	---Round a decimal fraction to the specified number of digits
	---@param number number A fractional number value to round
	---@param decimals? number Specify the number of decimal places to round the number to | ***Default:*** 0
	---@return number
	wt.Round = function(number, decimals)
		local multiplier = 10 ^ (decimals or 0)
		return math.floor(number * multiplier + 0.5) / multiplier
	end

	--[ Conversion, Packing & Unpacking ]

	---Find a frame or region by its name (or a subregion if a key is included in the input string)
	---@param s string Name of the frame to find (and the key of its child region appended to it after a period character)
	---@return table frame Reference to the object
	wt.ToFrame = function(s)
		local frame = nil
		for name in s:gmatch("[^.]+") do frame = frame and frame[name] or _G[name] end
		return frame
	end

	---Return a position table used by WidgetTools assembled from the provided values which are returned by [Region:GetPoint(...)](https://wowpedia.fandom.com/wiki/API_Region_GetPoint)
	---@param anchor? AnchorPoint Base anchor point | ***Default:*** "TOPLEFT"
	---@param relativeTo? Frame Relative to this Frame or Region
	---@param relativePoint? AnchorPoint Relative anchor point
	---@param offsetX? number | ***Default:*** 0
	---@param offsetY? number | ***Default:*** 0
	---@return table position Table containing the position values as used by WidgetTools
	--- - **anchor** [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)
	--- - **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- - **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- - **offset**? table *optional*
	--- 	- **x**? number *optional*
	--- 	- **y**? number *optional*
	wt.PackPosition = function(anchor, relativeTo, relativePoint, offsetX, offsetY)
		return {
			anchor = anchor or "TOPLEFT",
			relativeTo = relativeTo,
			relativePoint = relativePoint,
			offset = offsetX and offsetY and { x = offsetX or 0, y = offsetY or 0 } or nil
		}
	end

	---Return the position values used by [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) from a position table used by WidgetTools
	---@param t table Table containing parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with
	--- - **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- - **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)|string *optional* ― Frame reference or name
	--- - **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- - **offset**? table *optional*
	--- 	- **x**? number *optional* — ***Default:*** 0
	--- 	- **y**? number *optional* — ***Default:*** 0
	---@return AnchorPoint anchor ***Default:*** "TOPLEFT" *(when an invalid input or missing value is provided)*
	---@return Frame|nil? relativeTo
	---@return AnchorPoint|nil? relativePoint
	---@return number? ofsx ***Default:*** 0
	---@return number? ofsy ***Default:*** 0
	wt.UnpackPosition = function(t)
		if type(t) ~= "table" then return "TOPLEFT" end
		return t.anchor or "TOPLEFT", type(t.relativeTo) == "string" and wt.ToFrame(t.relativeTo) or t.relativeTo, t.relativePoint, (t.offset or {}).x or 0, (t.offset or {}).y or 0
	end

	---Return a table constructed from color values
	---@param red number ***Range:*** (0, 1)
	---@param green number ***Range:*** (0, 1)
	---@param blue number ***Range:*** (0, 1)
	---@param alpha? number Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	---@return table color Table containing the color values
	--- - **r** number ― Red | ***Range:*** (0, 1)
	--- - **g** number ― Green | ***Range:*** (0, 1)
	--- - **b** number ― Blue | ***Range:*** (0, 1)
	--- - **a** number ― Opacity | ***Range:*** (0, 1)
	wt.PackColor = function(red, green, blue, alpha)
		 return { r = red, g = green, b = blue, a = alpha or 1 }
	end

	---Return the color values found in a table
	---@param t table Table containing the color values
	--- - **r** number ― Red | ***Range:*** (0, 1)
	--- - **g** number ― Green | ***Range:*** (0, 1)
	--- - **b** number ― Blue | ***Range:*** (0, 1)
	--- - **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	---@param alpha? boolean Specify whether to return the full RGBA set or just the RGB values | ***Default:*** true
	---@return number r ***Default:*** 1 *(when an invalid input is provided)*
	---@return number g ***Default:*** 1 *(when an invalid input is provided)*
	---@return number b ***Default:*** 1 *(when an invalid input is provided)*
	---@return number? a ***Default:*** 1
	wt.UnpackColor = function(t, alpha)
		if type(t) ~= "table" then return 1, 1, 1, 1 end
		if alpha ~= false then return t.r, t.g, t.b, t.a or 1 else return t.r, t.g, t.b end
	end

	---Convert RGB(A) color values in Range: (0, 1) to HEX color code
	---@param r number Red | ***Range:*** (0, 1)
	---@param g number Green | ***Range:*** (0, 1)
	---@param b number Blue | ***Range:*** (0, 1)
	---@param a? number Alpha | ***Range:*** (0, 1) | ***Default:*** *no alpha*
	---@param alphaFirst? boolean Put the alpha value first: ARGB output instead of RGBA | ***Default:*** false
	---@param hashtag? boolean Whether to add a "#" to the beginning of the color description | ***Default:*** true
	---@return string hex Color code in HEX format (Examples: RGB - "#2266BB", RGBA - "#2266BBAA")
	wt.ColorToHex = function(r, g, b, a, alphaFirst, hashtag)
		local hex = hashtag ~= false and "#" or ""
		if a and alphaFirst then hex = hex .. string.format("%02x", math.ceil(a * 255)) end
		hex = hex .. string.format("%02x", math.ceil(r * 255)) .. string.format("%02x", math.ceil(g * 255)) .. string.format("%02x", math.ceil(b * 255))
		if a and not alphaFirst then hex = hex .. string.format("%02x", math.ceil(a * 255)) end
		return hex:upper()
	end

	---Convert a HEX color code into RGB or RGBA in Range: (0, 1)
	---@param hex string String in HEX color code format (Examples: RGB - "#2266BB", RGBA - "#2266BBAA" where the "#" is optional)
	---@return number r Red | ***Range:*** (0, 1)
	---@return number g Green  | ***Range:*** (0, 1)
	---@return number b Blue | ***Range:*** (0, 1)
	---@return number? a Alpha | ***Range:*** (0, 1)
	wt.HexToColor = function(hex)
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

	--[ String Formatting ]

	---Add coloring escape sequences to a string
	---@param text string Text to add coloring to
	---@param color table Table containing the color values
	--- - **r** number ― Red | ***Range:*** (0, 1)
	--- - **g** number ― Green | ***Range:*** (0, 1)
	--- - **b** number ― Blue | ***Range:*** (0, 1)
	--- - **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	---@return string
	wt.Color = function(text, color)
		local r, g, b, a = wt.UnpackColor(color)
		return WrapTextInColorCode(text, wt.ColorToHex(r, g, b, a, true, false))
	end

	---Format a number string to include thousand separation
	---@param value number Number value to turn into a string with thousand separation
	---@param decimals? number Specify the number of decimal places to display if the number is a fractional value | ***Default:*** 0
	---@param round? boolean Round the number value to the specified number of decimal places | ***Default:*** true
	---@param trim? boolean Trim trailing zeros in decimal places | ***Default:*** true
	---@return string
	wt.FormatThousands = function(value, decimals, round, trim)
		value = round == false and value or wt.Round(value, decimals)
		local fraction = math.fmod(value, 1)
		local integer = value - fraction
		--Formatting
		local leftover
		while true do
			integer, leftover = string.gsub(integer, "^(-?%d+)(%d%d%d)", '%1' .. strings.separator .. '%2')
			if leftover == 0 then break end
		end
		local decimalText = tostring(fraction):sub(3, (decimals or 0) + 2)
		if trim == false then for i = 1, (decimals or 0) - #decimalText do decimalText = decimalText .. "0" end end
		return integer .. (((decimals or 0) > 0 and (fraction ~= 0 or trim == false)) and strings.decimal .. decimalText or "")
	end

	---Remove all recognized formatting, other escape sequences (like coloring) from a string
	--- - ***Note:*** *Grammar* escape sequences are not yet supported, and will not be removed.
	---@param s string
	---@return string s
	wt.Clear = function(s)
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

	--[ Key Handling ]

	---Turn a modifier key string into a callable modifier checking function
	---@param modifier ModifierKey
	---@return function
	wt.ModifierToCheck = function(modifier)
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

	--[ Frame Setup & Management ]

	---Set the visibility of a frame based on the value provided
	---@param frame Frame Reference to the frame to hide or show
	---@param visible boolean If false, hide the frame, show it if true
	wt.SetVisibility = function(frame, visible)
		if visible then frame:Show() else frame:Hide() end
	end

	---Set the position and anchoring of a frame when it is unknown which parameters will be nil
	---@param frame Frame Reference to the frame to be moved
	---@param position table Table of parameters to call **frame**:[SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with
	--- - **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- - **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional* ***Default:*** UIParent *(the entire screen)*
	--- - **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** **anchor**
	--- - **offset**? table *optional*
	--- 	- **x**? number *optional* — ***Default:*** 0
	--- 	- **y**? number *optional* — ***Default:*** 0
	---@param userPlaced? boolean Remember the position if **frame**:[IsMovable()](https://wowpedia.fandom.com/wiki/API_Frame_IsMovable) | ***Default:*** true
	wt.SetPosition = function(frame, position, userPlaced)
		local anchor, relativeTo, relativePoint, offsetX, offsetY = wt.UnpackPosition(position)
		frame:ClearAllPoints()
		--Set the position
		if (not relativeTo or not relativePoint) and (not offsetX or not offsetY) then
			frame:SetPoint(anchor)
		elseif not relativeTo or not relativePoint then
			frame:SetPoint(anchor, offsetX, offsetY)
		elseif not offsetX or not offsetY then
			frame:SetPoint(anchor, relativeTo, relativePoint)
		else
			frame:SetPoint(anchor, relativeTo, relativePoint, offsetX, offsetY)
		end
		--Set user placed
		if frame["SetUserPlaced"] and frame:IsMovable() then frame:SetUserPlaced(userPlaced ~= false) end
	end

	---Set the movability of a frame based in the specified values
	---@param frame Frame Reference to the frame to make movable/unmovable
	---@param movable boolean Whether to make the frame movable or unmovable
	---@param modifier? ModifierKey The specific (or any) modifier key required to be pressed down to move **frame** (if **frame** has the "OnUpdate" script defined) | ***Default:*** nil *(no modifier)*
	--- - ***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://wowpedia.fandom.com/wiki/API_IsModifierKeyDown) is used.
	---@param triggerFrame? Frame Reference to the frame to handle the inputs to initiate or stop the movement of **frame** | ***Default:*** **frame**
	---@param events? table Table containing function descriptions to call when certain events occur
	--- - **onStart**? function *optional* — Function to call when **frame** starts moving
	--- - **onMove**? function *optional* — Function to call every with frame update while **frame** is moving (if **frame** has the "OnUpdate" script defined)
	--- - **onStop**? function *optional* — Function to call when the movement of **frame** is stopped and the it was moved successfully
	--- - **onCancel**? function *optional* — Function to call when the movement of **frame** is cancelled (because the modifier key was released early as an example)
	wt.SetMovability = function(frame, movable, modifier, triggerFrame, events)
		if not frame.SetMovable then return end
		triggerFrame = triggerFrame or frame
		if modifier then modifier = wt.ModifierToCheck(modifier) end
		local position = wt.PackPosition(frame:GetPoint())
		--Set movability
		frame:SetMovable(movable)
		triggerFrame:EnableMouse(movable)
		if movable then
			triggerFrame:HookScript("OnMouseDown", function()
				if not frame:IsMovable() or frame.isMoving then return end
				if modifier then if not modifier() then return end end
				--Store position
				position = wt.PackPosition(frame:GetPoint())
				--Start moving
				frame:StartMoving()
				frame.isMoving = true
				if (events or {}).onStart then events.onStart() end
				--Start the movement updates
				if triggerFrame:HasScript("OnUpdate") then triggerFrame:SetScript("OnUpdate", function()
					if (events or {}).onMove then events.onMove() end
					--Check if the modifier key is pressed
					if modifier then
						if modifier() then return end
						--Cancel when the modifier key is released
						frame:StopMovingOrSizing()
						frame.isMoving = false
						if (events or {}).onCancel then events.onCancel() end
						--Reset the position
						wt.SetPosition(frame, position)
						--Stop checking if the modifier key is pressed
						triggerFrame:SetScript("OnUpdate", nil)
					end
				end) end
			end)
			triggerFrame:HookScript("OnMouseUp", function()
				if not frame:IsMovable() or not frame.isMoving then return end
				--Stop moving
				frame:StopMovingOrSizing()
				frame.isMoving = false
				if (events or {}).onStop then events.onStop() end
				--Stop the movement updates
				if triggerFrame:HasScript("OnUpdate") then triggerFrame:SetScript("OnUpdate", nil) end
			end)
			triggerFrame:HookScript("OnHide", function()
				if not frame:IsMovable() or not frame.isMoving then return end
				--Cancel moving
				frame:StopMovingOrSizing()
				frame.isMoving = false
				if (events or {}).onCancel then events.onCancel() end
				--Reset the position
				wt.SetPosition(frame, position)
				--Stop the movement updates
				if triggerFrame:HasScript("OnUpdate") then triggerFrame:SetScript("OnUpdate", nil) end
			end)
		end
	end

	---Set the backdrop of a frame with BackdropTemplate with the specified parameters
	---@param frame Frame Reference to the frame to set the backdrop of
	--- - ***Note:*** The template of **frame** must have been set as: `BackdropTemplateMixin and "BackdropTemplate"`.
	---@param backdrop? table Parameters to set the custom backdrop with | ***Default:*** nil *(remove the backdrop)*
	--- - **background**? table *optional* ― Table containing the parameters used for the background
	--- 	- **texture**? table *optional* ― Parameters used for setting the background texture
	--- 		- **path**? string *optional* ― Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/ChatFrame/ChatFrameBackground"
	--- 			- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 			- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 			- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- 		- **size** number — Size of a single background tile square
	--- 		- **tile**? boolean *optional* — Whether to repeat the texture to fill the entire size of the frame | ***Default:*** true
	--- 		- **insets**? table *optional* ― Offset the position of the background texture from the edges of the frame inward
	--- 			- **left**? number *optional* — ***Default:*** 0
	--- 			- **right**? number *optional* — ***Default:*** 0
	--- 			- **top**? number *optional* — ***Default:*** 0
	--- 			- **bottom**? number *optional* — ***Default:*** 0
	--- 	- **color**? table *optional* — Apply the specified color to the background texture
	--- 		- **r** number ― Red | ***Range:*** (0, 1)
	--- 		- **g** number ― Green | ***Range:*** (0, 1)
	--- 		- **b** number ― Blue | ***Range:*** (0, 1)
	--- 		- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- - **border**? table *optional* ― Table containing the parameters used for the border
	--- 	- **texture**? table *optional* ― Parameters used for setting the border texture
	--- 		- **path**? string *optional* ― Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/Tooltips/UI-Tooltip-Border"
	--- 			- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 			- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 			- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- 		- **width** number — Width of the backdrop edge
	--- 	- **color**? table *optional* — Apply the specified color to the border texture
	--- 		- **r** number ― Red | ***Range:*** (0, 1)
	--- 		- **g** number ― Green | ***Range:*** (0, 1)
	--- 		- **b** number ― Blue | ***Range:*** (0, 1)
	--- 		- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	---@param updates? table Table of key, value pairs containing the list of events to link backdrop changes to, and what parameters to change
	--- - **[*key*]** string ― Event name, any script handler defined for **updates[*key*].frame**
	--- - **[*value*]** table ― Table containing the update rules
	--- 	- **frame**? Frame *optional* ― Reference to the frame to add the listener script to | ***Default:*** **frame**
	--- 	- **rule**? function *optional* ― Evaluate the event and specify the backdrop updates to set, or, if nil, restore the base **backdrop** unconditionally on event trigger
	--- 		- @*param* **self** Frame ― Reference to **updates[*key*].frame**
	--- 		- @*param* **...** any ― Any leftover arguments will be passed from the handler script to **updates[*key*].rule**
	--- 		- @*return* **backdropUpdate**? table *optional* ― Parameters to update the backdrop with | ***Default:*** nil *(remove the backdrop)*
	--- 			- **background**? table *optional* ― Table containing the parameters used for the background | ***Default:*** **backdrop.background** if **keepValues** is true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure) and **frame**:[GetBackdropColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropColor))*
	--- 				- **texture**? table *optional* ― Parameters used for setting the background texture | ***Default:*** **backdrop.background.texture** if **keepValues** is true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure))*
	--- 					- **path**? string *optional* ― Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/ChatFrame/ChatFrameBackground"
	--- 						- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 						- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 						- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- 					- **size** number — Size of a single background tile square
	--- 					- **tile**? boolean *optional* — Whether to repeat the texture to fill the entire size of the frame | ***Default:*** true
	--- 					- **insets**? table *optional* ― Offset the position of the background texture from the edges of the frame inward
	--- 						- **left**? number *optional* — ***Default:*** 0
	--- 						- **right**? number *optional* — ***Default:*** 0
	--- 						- **top**? number *optional* — ***Default:*** 0
	--- 						- **bottom**? number *optional* — ***Default:*** 0
	--- 				- **color**? table *optional* — Apply the specified color to the background texture | ***Default:*** **backdrop.background.color** if **keepValues** is true *(if it's false, keep the currently set values of **frame**:[GetBackdropColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropColor))*
	--- 					- **r** number ― Red | ***Range:*** (0, 1)
	--- 					- **g** number ― Green | ***Range:*** (0, 1)
	--- 					- **b** number ― Blue | ***Range:*** (0, 1)
	--- 					- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- 			- **border**? table *optional* ― Table containing the parameters used for the border | ***Default:*** **backdrop** if **keepValues** is true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure) and **frame**:[GetBackdropBorderColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropBorderColor))*
	--- 				- **texture**? table *optional* ― Parameters used for setting the border texture | ***Default:*** **backdrop.border.texture** if **keepValues** is true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure))*
	--- 					- **path**? string *optional* ― Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/Tooltips/UI-Tooltip-Border"
	--- 						- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 						- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 						- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- 					- **width** number — Width of the backdrop edge
	--- 				- **color**? table *optional* — Apply the specified color to the border texture | ***Default:*** **backdrop.border.color** if **keepValues** is true *(if it's false, keep the currently set values of **frame**:[GetBackdropBorderColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropBorderColor))*
	--- 					- **r** number ― Red | ***Range:*** (0, 1)
	--- 					- **g** number ― Green | ***Range:*** (0, 1)
	--- 					- **b** number ― Blue | ***Range:*** (0, 1)
	--- 					- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- 		- @*return* **fillRule**? boolean *optional* ― If true, fill the specified defaults for the unset values in **backdropUpdates** with the values provided in **backdrop** at matching keys, if false, fill them with their corresponding values from the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure), **frame**:[GetBackdropColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropColor) and **frame**:[GetBackdropBorderColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropBorderColor) | ***Default:*** false
	--- 		- ***Note:*** Return an empty table `{}` for **backdropUpdate** and true for **keepValues** in order to restore the base **backdrop** after evaluation.
	--- 		- ***Note:*** Return an empty table `{}` for **backdropUpdate** and false or nil for **keepValues** to do nothing (keep the current backdrop).
	--- - ***Note:*** All update rules are additive, calling ***WidgetToolbox*.SetBackdrop(...)** multiple times with **updates** specified *will not* override previously set update rules. The base **backdrop** values used for these old rules *will not* change by setting a new backdrop via ***WidgetToolbox*.SetBackdrop(...)** either!
	wt.SetBackdrop = function(frame, backdrop, updates)
		if not frame.SetBackdrop then return end

		--[ Set Backdrop ]

		--Set backdrop utility
		local function setBackdrop(t)
			--Remove the backdrop
			if not t then
				frame:SetBackdrop(nil)
				return
			end

			--Set the backdrop
			t.background = t.background or {}
			t.border = t.border or {}
			t.background.texture = t.background.texture or {}
			t.border.texture = t.border.texture or {}
			if next(t.background.texture) or next(t.border.texture) then frame:SetBackdrop({
				bgFile = next(t.background.texture) and (t.background.texture.path or "Interface/ChatFrame/ChatFrameBackground") or nil,
				tile = t.background.texture.tile ~= false,
				tileSize = t.background.texture.size,
				insets = {
					left = (t.background.texture.insets or {}).left or 0,
					right = (t.background.texture.insets or {}).right or 0,
					top = (t.background.texture.insets or {}).top or 0,
					bottom = (t.background.texture.insets or {}).bottom or 0
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
			value.frame = value.frame or frame
			if value.frame:HasScript(key) then value.frame:HookScript(key, function(self, ...)
				--Unconditional: Restore the base backdrop on trigger
				if not value.rule then
					setBackdrop(backdrop)
					return
				end

				--Conditional: Evaluate the rule
				local backdropUpdate, fillRule = value.rule(self, ...)

				--Remove the backdrop
				if type(backdropUpdate) ~= "table" then
					setBackdrop(nil)
					return
				end

				--Restore the base backdrop or do nothing on evaluation
				if not next(backdropUpdate) then if fillRule then
					setBackdrop(backdrop)
					return
				else return end end

				--Fill defaults
				if fillRule then
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
							insets = frame.backdropInfo.insets
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

	---Check all dependencies (disable / enable rules) of a frame
	---@param rules table Indexed, 0-based table containing the dependency rules of the frame object
	--- - **[*index*]** table ― Parameters of a dependency rule
	--- 	- **frame** Frame — Reference to the widget the state of a widget is tied to
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, the type of which depends on the type of the frame (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: string) -> **evaluation**: boolean — If **rules.frame** is recognized as an editbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	---@return boolean state
	wt.CheckDependencies = function(rules)
		local state = true
		for i = 0, #rules do
			--Blizzard widgets
			if rules[i].frame:IsObjectType("CheckButton") then
				if rules[i].evaluate then state = rules[i].evaluate(rules[i].frame:GetChecked()) else state = rules[i].frame:GetChecked() end
			elseif rules[i].frame:IsObjectType("EditBox") then state = rules[i].evaluate(rules[i].frame:GetText())
			elseif rules[i].frame:IsObjectType("Slider") then state = rules[i].evaluate(rules[i].frame:GetValue())
			elseif rules[i].frame:IsObjectType("Frame") then
				--Custom widgets
				if rules[i].frame.isUniqueType("Dropdown") or rules[i].frame.isUniqueType("Selector") then state = rules[i].evaluate(rules[i].frame.getSelected()) end
			end
			if not state then break end
		end
		return state
	end

	---Set the dependencies (disable / enable rules) of a frame based on a ruleset
	---@param rules table Indexed, 0-based table containing the dependency rules of the frame object
	--- - **[*index*]** table ― Parameters of a dependency rule
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, the type of which depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: string) -> **evaluation**: boolean — If **rules.frame** is recognized as an editbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	---@param setState function Function to call to set the state of the frame
	--- - @*param* **state** boolean — The frame should be enabled when true, disabled when false
	wt.SetDependencies = function(rules, setState)
		for i = 0, #rules do
			if rules[i].frame.HookScript and rules[i].frame.IsObjectType then
				rules[i].frame:HookScript("OnAttributeChanged", function(_, attribute, state) if attribute == "loaded" and state then setState(wt.CheckDependencies(rules)) end end)
				--Blizzard Widgets
				if rules[i].frame:IsObjectType("CheckButton") then rules[i].frame:HookScript("OnClick", function() setState(wt.CheckDependencies(rules)) end)
				elseif rules[i].frame:IsObjectType("EditBox") then rules[i].frame:HookScript("OnTextChanged", function() setState(wt.CheckDependencies(rules)) end)
				elseif rules[i].frame:IsObjectType("Slider") then rules[i].frame:HookScript("OnValueChanged", function() setState(wt.CheckDependencies(rules)) end)
				elseif rules[i].frame:IsObjectType("Frame") then
					--Custom widgets
					if rules[i].frame.isUniqueType("Dropdown") or rules[i].frame.isUniqueType("Selector") then
						rules[i].frame:HookScript("OnAttributeChanged", function(_, attribute, _) if attribute == "selected" then setState(wt.CheckDependencies(rules)) end end)
					end
				end
			end
		end
	end

	--[ Options Data Management ]

	--Collection of rules describing where to save/load options data to/from, and what to call in the process
	local optionsTable

	---Add a connection between an options widget and a DB entry to the options data table under the specified options key
	---@param widget table Widget table containing reference to its UI frame
	--- - **frame**? Frame *optional* ― Reference to the widget to be saved & loaded data to & from (if it's a custom WidgetTools object with UniqueFrameType)
	---@param type FrameType|UniqueFrameType Type of the widget object (string), the return value of **widget**:[GetObjectType()](https://wowpedia.fandom.com/wiki/API_UIObject_GetObjectType) (for applicable Blizzard-built widgets).
	--- - ***Note:*** If GetObjectType() would return "Frame" in case of a UIDropDownMenu or a custom WidgetTools frame, use widget.isUniqueType() to get its unique type.
	---@param optionsData table Table with the information on options data handling
	--- - **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- - **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- - **storageKey** string ― Key of the variable inside the storage table
	--- - **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 	- @*param* string ― The current value of the widget
	--- 	- @*return* any ― The converted data to be saved to the storage table
	--- - **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 	- @*param* any ― The data in the storage table to be converted and loaded to the widget
	--- 	- @*return* string ― The value to be set to the widget
	--- - **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 	- @*param* **self**? Frame ― Reference to the widget
	--- 	- @*param* **value**? string ― The saved value of the frame
	--- - **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 	- @*param* **self**? Frame ― Reference to the widget
	--- 	- @*param* **value**? string ― The value loaded to the frame
	wt.AddOptionsData = function(widget, type, optionsData)
		--Check the tables
		if not optionsTable then optionsTable = {} end
		if not optionsTable[optionsData.optionsKey] then optionsTable[optionsData.optionsKey] = {} end
		if not optionsTable[optionsData.optionsKey][type] then optionsTable[optionsData.optionsKey][type] = {} end
		--Add the options data
		optionsTable[optionsData.optionsKey][type][not optionsTable[optionsData.optionsKey][type][0] and 0 or #optionsTable[optionsData.optionsKey][type] + 1] = {
			widget = widget,
			storageTable = optionsData.storageTable,
			storageKey = optionsData.storageKey,
			convertSave = optionsData.convertSave,
			convertLoad = optionsData.convertLoad,
			onSave = optionsData.onSave,
			onLoad = optionsData.onLoad
		}
	end

	---Save all data from the widgets to the storage table(s) specified in the collection of options data referenced by the options key
	---@param optionsKey table A unique key referencing the collection of widget options data to be saved
	wt.SaveOptionsData = function(optionsKey)
		if not (optionsTable or {})[optionsKey] then return end
		for k, v in pairs(optionsTable[optionsKey]) do
			for i = 0, #v do
				local value = nil
				--Automatic save
				if v[i].storageTable and v[i].storageKey then
					--Get the value from the widget
					if k == "CheckButton" then value = v[i].widget:GetChecked()
					elseif k == "Slider" then value = v[i].widget:GetValue()
					elseif k == "EditBox" then value = v[i].widget:GetText()
					elseif k == "Selector" or k == "Dropdown" then value = v[i].widget.getSelected()
					elseif k == "ColorPicker" then value = wt.PackColor(v[i].widget.getColor())
					end
					if value ~= nil then
						--Save the value to the storage table
						if v[i].convertSave then value = v[i].convertSave(value) end
						v[i].storageTable[v[i].storageKey] = value
					end
				end
				--Call onSave if specified
				if v[i].onSave then v[i].onSave(v[i].widget, value) end
			end
		end
	end

	---Load all data from the storage table(s) to the widgets specified in the collection of options data referenced by the options key
	--- - [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) will be evoked for all frames
	--- 	- @*param* **self** Frame ― Reference to the widget frame
	--- 	- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 	- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	---@param optionsKey table A unique key referencing the collection of widget options data to be loaded
	wt.LoadOptionsData = function(optionsKey)
		if not (optionsTable or {})[optionsKey] then return end
		for k, v in pairs(optionsTable[optionsKey]) do
			for i = 0, #v do
				local value = nil
				--Automatic load
				if v[i].storageTable and v[i].storageKey then
					--Load the value from the storage table
					value = v[i].storageTable[v[i].storageKey]
					if v[i].convertLoad then value = v[i].convertLoad(value) end
					--Apply to the widget
					if k == "CheckButton" then
						v[i].widget:SetAttribute("loaded", false)
						v[i].widget:SetChecked(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "Slider" then
						v[i].widget:SetAttribute("loaded", false)
						v[i].widget:SetValue(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "EditBox" then
						v[i].widget:SetAttribute("loaded", false)
						v[i].widget.setText(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "Selector" or k == "Dropdown" then
						v[i].widget:SetAttribute("loaded", false)
						v[i].widget.setSelected(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "ColorPicker" then
						v[i].widget:SetAttribute("loaded", false)
						v[i].widget.setColor(wt.UnpackColor(value))
						v[i].widget:SetAttribute("loaded", true)
					end
				end
				--Call onLoad if specified
				if v[i].onLoad then v[i].onLoad(v[i].widget, value) end
			end
		end
	end

	--[ Hyperlink Handlers ]

	---Format a string to be a clickable hyperlink text via escape sequences
	---@param type HyperlinkType [Type of the hyperlink](https://wowpedia.fandom.com/wiki/Hyperlinks#Types) determining how it's being handled and what payload it carries
	--- - ***Note:*** To make a custom hyperlink handled by an addon, *"item"* may be used as **type**. (Following details are to be provided in **content** to be able to use ***WidgetToolbox*.SetHyperlinkHandler(...)** to set a function to handle clicks on the custom hyperlink).
	---@param content string A colon-separated chain of parameters determined by the [type of the hyperlink](https://wowpedia.fandom.com/wiki/Hyperlinks#Types) (Example: "parameter1:parameter2:parameter3")
	--- - ***Note:*** When using *"item"* as **type** with the intention of setting a custom hyperlink to be handled by an addon, set the first parameter of **content** to a unique addon identifier key, and the second parameter to a unique key signifying the type of the hyperlink specific to the addon (if the addon handles multiple different custom types of hyperlinks), in order to be able to set unique hyperlink click handlers via ***WidgetToolbox*.SetHyperlinkHandler(...)**.
	---@param text string Clickable text to be displayed as the hyperlink
	---@return string
	wt.Hyperlink = function(type, content, text)
		return "\124H" .. type .. ":" .. content .. "\124h" .. text .. "\124h"
	end

	---Register a function to handle custom hyperlink clicks
	---@param addon string Addon namespace key used for a subtable in ***WidgetToolbox*.HyperlinkHandlers**
	---@param handlerKey string Unique custom hyperlink type key used to identify the specific handler function within ***WidgetToolbox*.HyperlinkHandlers[addonKey]**
	---@param handlerFunction function Function to be called by clicking on a hyperlink text created via |Hitem:**addonKey**:**handlerKey**:*content*|h*Text*|h
	wt.SetHyperlinkHandler = function(addon, handlerKey, handlerFunction)
		--Set the table containing the hyperlink handlers
		if not wt.HyperlinkHandlers then
			--Create the table
			wt.HyperlinkHandlers = {}
			--Hook the hyperlink handler caller
			hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(...)
				local _, linkType = ...
				local _, addonID, handlerID, content = strsplit(":", linkType, 4)
				--Check if it's a registered addon
				for key, addonHandlers in pairs(wt.HyperlinkHandlers) do
					if addonID == key then
						--Check if there is a valid handler to call
						for k, handler in pairs(addonHandlers) do
							if handlerID == k then
								--Call the handler function
								handler(content)
								return
							end
						end
					end
				end
			end)
		end
		--Add the hyperlink handler function to the table
		if not wt.HyperlinkHandlers[addon] then wt.HyperlinkHandlers[addon] = {} end
		wt.HyperlinkHandlers[addon][handlerKey] = handlerFunction
	end


	--[[ ASSETS & RESOURCES ]]

	--Colors
	local colors = {
		normal = wt.PackColor(HIGHLIGHT_FONT_COLOR:GetRGBA()),
		highlight = wt.PackColor(NORMAL_FONT_COLOR:GetRGBA()),
		disabled = wt.PackColor(GRAY_FONT_COLOR:GetRGB()),
		warning = wt.PackColor(RED_FONT_COLOR:GetRGB()),
		context = {
			bg = { r = 0.05, g = 0.05, b = 0.075, a = 0.825 },
			normal = { r = 0.25, g = 0.25, b = 0.3, a = 0.5 },
			hover = { r = 0.8, g = 0.8, b = 0.3, a = 0.5 },
			click = { r = 0.6, g = 0.6, b = 0.2, a = 0.5 },
		},
	}

	--Textures
	local textures = {
		alphaBG = "Interface/AddOns/" .. addonNameSpace .. "/Textures/AlphaBG.tga",
		gradientBG = "Interface/AddOns/" .. addonNameSpace .. "/Textures/GradientBG.tga",
		arrowhead = "Interface/AddOns/" .. addonNameSpace .. "/Textures/Arrowhead.tga",
		contextBG = "Interface/AddOns/" .. addonNameSpace .. "/Textures/ContextBG.tga",
	}

	--Classic vs Dragonflight code separation
	wt.classic = select(4, GetBuildInfo()) < 100000


	--[[ UX HELPERS ]]

	--[ Custom Tooltip]

	---Create and set up a new custom GameTooltip frame
	---@param name string Unique string piece to place in the name of the the tooltip to distinguish it from other tooltips (use the addon namespace string as an example)
	---@return GameTooltip tooltip
	wt.CreateGameTooltip = function(name)
		local tooltip = CreateFrame("GameTooltip", name .. "GameTooltip", nil, "GameTooltipTemplate")

		--Visibility
		tooltip:SetFrameStrata("DIALOG")
		tooltip:SetScale(0.9)

		--Title font
		_G[tooltip:GetName() .. "TextLeft" .. 1]:SetFontObject("GameFontNormalMed1")
		_G[tooltip:GetName() .. "TextRight" .. 1]:SetFontObject("GameFontNormalMed1")

		return tooltip
	end

	local customTooltip = wt.CreateGameTooltip("WidgetTools" .. toolboxVersion)

	---Set up a show a GameTooltip for a frame to show or hide on hover
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame ― Owner frame the tooltip to be shown for
	--- - **tooltip**? GameTooltip *optional* ― Reference to the tooltip frame to set up | ***Default:*** *default WidgetTools custom tooltip*
	--- - **title** string ― String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR (orange))
	--- - **lines**? table *optional* ― Table containing text lines to be added to the tooltip [indexed, 0-based]
	--- 	- **[*index*]** table ― Parameters of a line of text
	--- 		- **text** string ― Text to be displayed in the line
	--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 			- **r** number ― Red | ***Range:*** (0, 1)
	--- 			- **g** number ― Green | ***Range:*** (0, 1)
	--- 			- **b** number ― Blue | ***Range:*** (0, 1)
	--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **flipColors**? boolean *optional* ― Flip the default color values of the title and the text lines | ***Default:*** false
	--- - **anchor** TooltipAnchor ― [GameTooltip anchor](https://wowpedia.fandom.com/wiki/API_GameTooltip_SetOwner#Arguments)
	--- - **offset**? table *optional* ― Values to offset the position of **tooltip** by
	--- 	- **x**? number *optional* — ***Default:*** 0
	--- 	- **y**? number *optional* — ***Default:*** 0
	--- - **position**? table *optional* ― Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via **t.anchor** | ***Default:*** "TOPLEFT" if **t.anchor** is set to "ANCHOR_NONE"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- ***Note:*** **t.offset** will be used when calling [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) as well.
	--- - **triggers**? table *optional* ― List of additional frames to add hover events to to toggle **tooltip** for **parent** besides **parent** itself
	--- 	- **[*value*]** Frame ― Reference to the frame to add the hover events to to toggle the visibility of **tooltip** | ***Default:*** **parent**
	--- - **checkParent**? boolean *optional* ― Whether or not to check if **parent** is being hovered or not before hiding **tooltip** when triggers are stopped being hovered | ***Default:*** true
	--- - **replace**? boolean *optional* ― If false, while **tooltip** is already visible for a different parent, don't change it | ***Default:*** true
	--- 	- ***Note:*** If **tooltip** is already shown for **parent**, ***WidgetToolbox*.UpdateTooltip(...)** will be called anyway.
	---@return GameTooltip tooltip ― Reference to the tooltip frame
	wt.AddTooltip = function(t)
		t.tooltip = t.tooltip or customTooltip

		--Toggle events
		t.triggers = t.triggers or {}
		table.insert(t.triggers, t.parent)
		for _, trigger in pairs(t.triggers) do
			if trigger ~= t.parent and t.replace ~= false then
				trigger:HookScript("OnEnter", function() if not t.tooltip:IsVisible() then
					wt.UpdateTooltip({
						parent = t.parent,
						tooltip = t.tooltip,
						title = t.title,
						lines = t.lines,
						flipColors = t.flipColors,
						anchor = t.anchor,
						offset = t.offset,
						position = t.position
					})
					t.tooltip:Show()
				end end)
			else
				trigger:HookScript("OnEnter", function()
					wt.UpdateTooltip({
						parent = t.parent,
						tooltip = t.tooltip,
						title = t.title,
						lines = t.lines,
						flipColors = t.flipColors,
						anchor = t.anchor,
						offset = t.offset,
						position = t.position
					})
					t.tooltip:Show()
				end)
			end
			if trigger ~= t.parent and t.checkParent then
				trigger:HookScript("OnLeave", function() if not t.parent:IsMouseOver() then t.tooltip:Hide() end end)
			else
				trigger:HookScript("OnLeave", function() t.tooltip:Hide() end)
			end
		end

		return t.tooltip
	end

	---Update an already visible GameTooltip
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame ― Owner frame the tooltip to be shown for
	--- - **tooltip**? GameTooltip *optional* ― Reference to the tooltip frame to set up | ***Default:*** *default WidgetTools custom tooltip*
	--- - **title** string ― String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR (orange))
	--- - **lines**? table *optional* ― Table containing text lines to be added to the tooltip [indexed, 0-based]
	--- 	- **[*index*]** table ― Parameters of a line of text
	--- 		- **text** string ― Text to be displayed in the line
	--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 			- **r** number ― Red | ***Range:*** (0, 1)
	--- 			- **g** number ― Green | ***Range:*** (0, 1)
	--- 			- **b** number ― Blue | ***Range:*** (0, 1)
	--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **flipColors**? boolean *optional* ― Flip the default color values of the title and the text lines | ***Default:*** false
	--- - **anchor** TooltipAnchor ― [GameTooltip anchor](https://wowpedia.fandom.com/wiki/API_GameTooltip_SetOwner#Arguments)
	--- - **offset**? table *optional* ― Values to offset the position of **tooltip** by
	--- 	- **x**? number *optional* — ***Default:*** 0
	--- 	- **y**? number *optional* — ***Default:*** 0
	--- - **position**? table *optional* ― Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via **t.anchor** | ***Default:*** "TOPLEFT" if **t.anchor** is set to "ANCHOR_NONE"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- ***Note:*** **t.offset** will be used when calling [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) as well.
	---@return GameTooltip tooltip Reference to the tooltip frame
	wt.UpdateTooltip = function(t)
		--Position
		if t.anchor == "ANCHOR_NONE" then
			t.tooltip:SetOwner(t.parent, t.anchor)
			t.position = t.position or {}
			t.position.offset = t.offset
			wt.SetPosition(t.tooltip, t.position)
		else t.tooltip:SetOwner(t.parent, t.anchor, (t.offset or {}).x or 0, (t.offset or {}).y or 0) end

		--Title
		local titleColor = t.flipColors and colors.highlight or colors.normal
		t.tooltip:AddLine(t.title, titleColor.r, titleColor.g, titleColor.b, true)

		--Text lines
		if t.lines then
			for i = 0, #t.lines do
				--Set FontString
				local left = t.tooltip:GetName() .. "TextLeft" .. i + 2
				local right = t.tooltip:GetName() .. "TextRight" .. i + 2
				local font = t.lines[i].font or "GameTooltipTextSmall"
				if not _G[left] or not _G[right] then t.tooltip:AddFontStrings(t.tooltip:CreateFontString(left, nil, font), t.tooltip:CreateFontString(right, nil, font)) end
				_G[left]:SetFontObject(font)
				_G[left]:SetJustifyH("LEFT")
				_G[right]:SetFontObject(font)
				_G[right]:SetJustifyH("RIGHT")
				local color = t.lines[i].color or (t.flipColors and colors.normal or colors.highlight)
				t.tooltip:AddLine(t.lines[i].text, color.r, color.g, color.b, t.lines[i].wrap ~= false)
			end
		end

		return t.tooltip
	end

	--[ Popup Dialogue Box ]

	---Create a popup dialogue with an accept function and cancel button
	---@param t table Parameters are to be provided in this table
	--- - **addon** string — The name of the addon's folder (the addon namespace not the display title)
	--- - **name** string — Appended to **t.addon** as a unique identifier key in the global **StaticPopupDialogs** table
	--- - **text** string — The text to display as the message in the popup window
	--- - **accept**? string *optional* — The text to display as the label of the accept button | ***Default:*** ***WidgetToolbox*.strings.misc.accept**
	--- - **cancel**? string *optional* — The text to display as the label of the cancel button | ***Default:*** ***WidgetToolbox*.strings.misc.cancel**
	--- - **onAccept**? function *optional* — The function to be called when the accept button is pressed and an OnAccept event happens
	--- - **onCancel**? function *optional* — The function to be called when the cancel button is pressed, the popup is overwritten (by another popup for instance) or the popup expires and an OnCancel event happens
	---@return string key The unique identifier key created for this popup in the global **StaticPopupDialogs** table used as the parameter when calling [StaticPopup_Show()](https://wowpedia.fandom.com/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://wowpedia.fandom.com/wiki/API_StaticPopup_Hide)
	wt.CreatePopup = function(t)
		local key = t.addon:upper() .. "_" .. t.name:gsub("%s+", "_"):upper()

		--Create the popup dialogue
		StaticPopupDialogs[key] = {
			text = t.text,
			button1 = t.accept or strings.misc.accept,
			button2 = t.cancel or strings.misc.cancel,
			-- button3 = "All", --TODO: Figure out what's up with handler functions for buttons past the first two (accept & cancel)
			OnAccept = t.onAccept,
			OnCancel = t.onCancel,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = STATICPOPUPS_NUMDIALOGS
		}

		return key
	end

	--[ Reload Notice ]

	local reloadFrame

	---Show a movable reload notice window on screen with a reload now and cancel button
	---@param t table Parameters are to be provided in this table
	--- - **title**? string *optional* — Text to be shown as the title of the reload notice | ***Default:*** "Pending Changes" *(when the language is set to English)*
	--- - **message**? string *optional* — Text to be shown as the message of the reload notice | ***Default:*** "Reload the interface to apply the pending changes." *(when the language is set to English)*
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** -300
	--- 		- **y**? number *optional* — ***Default:*** -80
	---@return Frame reload Reference to the reload notice panel frame
	wt.CreateReloadNotice = function(t)
		if reloadFrame then
			reloadFrame:Show()
			return reloadFrame
		end

		--[ Frame Setup ]

		--Create the reload frame
		reloadFrame = wt.CreatePanel({
			parent = UIParent,
			name = "WidgetToolsReloadNotice",
			title = t.title or strings.reload.title,
			description = t.message or strings.reload.description,
			position = t.position or {
				anchor = "TOPRIGHT",
				offset = { x = -300, y = -80 }
			},
			size = { width = 240, height = 74 }
		})
		wt.SetMovability(reloadFrame, true)
		reloadFrame:SetClampedToScreen(true)

		--Button: Reload
		wt.CreateButton({
			parent = reloadFrame,
			name = "ReloadButton",
			title = strings.reload.accept.label,
			tooltip = { lines = { [0] = { text = strings.reload.accept.tooltip, }, } },
			position = { offset = { x = 10, y = -40 } },
			size = { width = 120, },
			events = { OnClick = function() ReloadUI() end },
		})

		--Button Close
		wt.CreateButton({
			parent = reloadFrame,
			name = "CancelButton",
			title = strings.reload.cancel.label,
			tooltip = { lines = { [0] = { text = strings.reload.cancel.tooltip, }, } },
			position = {
				anchor = "TOPRIGHT",
				offset = { x = -10, y = -40 }
			},
			events = { OnClick = function() reloadFrame:Hide() end },
		})

		return reloadFrame
	end


	--[[ ART ELEMENTS ]]

	--[ Text ]

	---Create a FontString with the specified text and template
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame ― The frame to create the text in
	--- - **name**? string *optional* — String appended to the name of **t.parent** used to set the name of the new [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "Text"
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional*
	--- - **text** string ― Text to be shown
	--- - **layer**? Layer *optional* ― Draw [Layer](https://wowpedia.fandom.com/wiki/Layer)
	--- - **template**? string *optional* — [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormal"
	--- - **font**? table *optional* ― Table containing font properties used for [SetFont](https://wowpedia.fandom.com/wiki/API_FontInstance_SetFont)
	--- 	- **path** string ― Path to the font file relative to the WoW client directory
	--- 	- **size**? number *optional* — ***Default:*** *size defined by the template*
	--- 	- **style**? string *optional* ― Comma separated string of styling flags: "OUTLINE"|"THICKOUTLINE"|"THINOUTLINE"|"MONOCHROME" .. | ***Default:*** *style defined by the template*
	--- - **justify**? string *optional* — Set the horizontal justification of the text: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "CENTER"
	--- - **color**? table *optional* — Apply the specified color to the text
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	--- - **wrap**? boolean *optional* — Whether or not to allow the text lines to wrap | ***Default:*** true
	---@return FontString text
	wt.CreateText = function(t)
		local text = t.parent:CreateFontString(t.parent:GetName() .. (t.name and t.name:gsub("%s+", "") or "Text"), t.layer, t.template and t.template or "GameFontNormal")

		--Position & dimensions
		wt.SetPosition(text, t.position)
		if t.width then text:SetWidth(t.width) end

		--Font & text
		if t.font then text:SetFont(t.font.path, t.font.size, t.font.style) end
		if t.color then text:SetTextColor(wt.UnpackColor(t.color)) end
		if t.justify then text:SetJustifyH(t.justify) end
		-- if t.wrap ~= false then text:SetWordWrap(t.wrap) end --BUG: text.SetWordWrap == nil
		text:SetText(t.text)

		return text
	end

	---Add a title & description to a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame ― The frame panel to add the title & description to
	--- - **title**? table *optional*
	--- 	- **text** string ― Text to be shown as the main title of the frame
	--- 	- **template**? FontObject *optional* ― [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormal"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **offset**? table *optional* ― The offset from the anchor point relative to the specified frame
	--- 		- **x**? number *optional* ― Horizontal offset value | ***Default:*** 0
	--- 		- **y**? number *optional* ― Vertical offset value | ***Default:*** 0
	--- 	- **width**? number *optional* — ***Default:*** *width of the parent frame*
	--- 	- **justify**? string *optional* — Set the horizontal justification of the text: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- 	- **color**? table *optional* — Apply the specified color to the title
	--- 		- **r** number ― Red | ***Range:*** (0, 1)
	--- 		- **g** number ― Green | ***Range:*** (0, 1)
	--- 		- **b** number ― Blue | ***Range:*** (0, 1)
	--- 		- **a** number ― Opacity | ***Range:*** (0, 1)
	--- - **description**? table *optional*
	--- 	- **text** string ― Text to be shown as the description of the frame
	--- 	- **template**? FontObject *optional* ― [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontHighlightSmall"
	--- 	- **offset**? table *optional* ― The offset from the "BOTTOMLEFT" point of the main title
	--- 		- **x**? number *optional* ― Horizontal offset value | ***Default:*** 0
	--- 		- **y**? number *optional* ― Vertical offset value | ***Default:*** 0
	--- 	- **width**? number *optional* — ***Default:*** *width of the parent frame*
	--- 	- **justify**? string *optional* — Set the horizontal justification of the text: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- 	- **color**? table *optional* — Apply the specified color to the description
	--- 		- **r** number ― Red | ***Range:*** (0, 1)
	--- 		- **g** number ― Green | ***Range:*** (0, 1)
	--- 		- **b** number ― Blue | ***Range:*** (0, 1)
	--- 		- **a** number ― Opacity | ***Range:*** (0, 1)
	---@return FontString|nil? title
	---@return FontString|nil? description
	wt.AddTitle = function(t)
		--Title
		local title = t.title and wt.CreateText({
			parent = t.parent,
			name = "Title",
			position = {
				anchor = t.title.anchor,
				offset = { x = t.title.offset.x, y = t.title.offset.y }
			},
			width = t.title.width or t.parent:GetWidth() - ((t.title.offset or {}).x or 0),
			text = t.title.text,
			layer = "ARTWORK",
			template =  t.title.template,
			justify = t.title.justify or "LEFT",
			color = t.title.color,
		}) or nil

		--Description
		local description = t.description and wt.CreateText({
			parent = t.parent,
			name = "Description",
			position = {
				relativeTo = title,
				relativePoint = "BOTTOMLEFT",
				offset = { x = t.description.offset.x, y = t.description.offset.y }
			},
			width = t.description.width or t.parent:GetWidth() - (((t.title or {}).offset or {}).x or 0) - ((t.description.offset or {}).x or 0),
			text = t.description.text,
			layer = "ARTWORK",
			template =  t.description.template or "GameFontHighlightSmall",
			justify = t.description.justify or "LEFT",
			color = t.description.color,
		}) or nil

		return title, description
	end

	---Add a title & description to a container frame
	---@param contextMenu Frame Reference to the context menu to add this label to
	---@param t table Parameters are to be provided in this table
	--- - **text** string ― Text to be shown as the main title of the frame
	--- - **template**? string *optional* — [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormalSmall"
	--- - **font**? table *optional* ― Table containing font properties used for [SetFont](https://wowpedia.fandom.com/wiki/API_FontInstance_SetFont)
	--- 	- **path** string ― Path to the font file relative to the WoW client directory
	--- 	- **size**? number *optional* — ***Default:*** *size defined by the template*
	--- 	- **style**? string *optional* ― Comma separated string of styling flags: "OUTLINE"|"THICKOUTLINE"|"THINOUTLINE"|"MONOCHROME" .. | ***Default:*** *style defined by the template*
	--- - **justify**? string *optional* — Set the horizontal justification of the text: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- - **color**? table *optional* — Apply the specified color to the title
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	---@return FontString label
	wt.AddContextLabel = function(contextMenu, t)
		local index = not contextMenu.items[0] and 0 or #contextMenu.items + 1

		--Increase the context menu height
		local contextHeight = contextMenu:GetHeight()
		contextMenu:SetHeight(contextHeight + 16)

		--Create the text
		local label = wt.CreateText({
			parent = contextMenu,
			name = "Title",
			position = {
				anchor = "CENTER",
				relativeTo = contextMenu,
				relativePoint = "TOP",
				offset = { y = -contextHeight + 2 }
			},
			width = contextMenu:GetWidth() - 20,
			text = t.text,
			layer = "ARTWORK",
			template = t.template or "GameFontNormalSmall",
			font = t.font,
			justify = t.justify or "LEFT",
			color = t.color,
		})

		--Add to the context menu
		contextMenu.items[index] = label

		return label
	end

	--[ Texture Image ]

	---Create a texture image
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture)
	--- - **name**? string *optional* — String appended to the name of **t.parent** used to set the name of the new [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture) | ***Default:*** "Texture"
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size** table
	--- 	- **width** number
	--- 	- **height** number
	--- - **path** string ― Path to the specific texture file relative to the root directory of the specific WoW client
	--- 	- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 	- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 	- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- - **layer**? [Layer](https://wowpedia.fandom.com/wiki/Layer) *optional*
	--- - **level**? integer *optional* — Sublevel to set within the draw layer specified with **t.layer** | ***Range:*** (-8, 7)
	--- - **tile**? boolean *optional* — Repeat the texture horizontally and vertically | ***Default:*** false
	--- - **flip**? table *optional*
	--- 	- **horizontal**? boolean *optional* — Mirror the entire texture on the horizontal axis | ***Default:*** false
	--- 	- **vertical**? boolean *optional* — Mirror the entire texture on the vertical axis | ***Default:*** false
	--- - **color**? table *optional* — Apply the specified color to the texture
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	---@param updates? table Table of key, value pairs containing the list of events to link texture changes to, and what parameters to change
	--- - **[*key*]** string  ― Event name, script handler defined for **t.parent**
	--- - **[*value*]** table ― Table containing the update rules
	--- 	- **frame**? Frame *optional* ― Reference to the frame to add the listener script to | ***Default:*** **t.parent**
	--- 	- **rule**? function *optional* ― Evaluate the event and specify the texture updates to set, or, if nil, restore the base values unconditionally on event trigger
	--- 		- @*param* **self** Frame ― Reference to **updates[*key*].frame**
	--- 		- @*param* **...** any ― Any leftover arguments will be passed from the handler script to **updates[*key*].rule**
	--- 		- @*return* **data** table *optional* ― Parameters to update the texture with
	--- 			- **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with
	--- 				- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** **t.position.anchor**
	--- 				- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional* — ***Default:*** **t.position.relativeTo**
	--- 				- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** **t.position.relativePoint**
	--- 				- **offset**? table *optional* — ***Default:*** **t.position.offset**
	--- 					- **x**? number *optional* — ***Default:*** **t.position.offset.x**
	--- 					- **y**? number *optional* — ***Default:*** **t.position.offset.y**
	--- 			- **size**? table *optional*
	--- 				- **width** number | ***Default:*** **t.size.width**
	--- 				- **height** number | ***Default:*** **t.size.height**
	--- 			- **path**? string *optional* ― Path to the specific texture file relative to the root directory of the specific WoW client
	--- 				- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 				- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 				- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- 			- **tile**? boolean *optional* — Repeat the texture horizontally and vertically ***Default:*** **t.tile**
	--- 			- **color**? table *optional* — Apply the specified color to the texture
	--- 				- **r** number ― Red | ***Range:*** (0, 1) | ***Default:*** **t.color.r**
	--- 				- **g** number ― Green | ***Range:*** (0, 1) | ***Default:*** **t.color.g**
	--- 				- **b** number ― Blue | ***Range:*** (0, 1) | ***Default:*** **t.color.b**
	--- 				- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** **t.color.a**
	---@return Texture texture
	wt.CreateTexture = function(t, updates)
		--Create the texture
		local texture = t.parent:CreateTexture(t.parent:GetName() .. (t.name and t.name:gsub("%s+", "") or "Texture"))

		--[ Set Texture Utility ]

		local function setTexture(data)
			--Position & dimensions
			wt.SetPosition(texture, data.position)
			texture:SetSize(data.size.width, data.size.height)

			--Asset & color
			texture:SetTexture(data.path, data.tile, data.tile)
			if data.tile then
				texture:SetHorizTile("REPEAT")
				texture:SetVertTile("REPEAT")
			end
			if data.layer then if data.level then texture:SetDrawLayer(data.layer, data.level) else texture:SetDrawLayer(data.layer) end end
			if data.flip then texture:SetTexCoord(t.flip.horizontal and 1 or 0, t.flip.horizontal and 0 or 1, t.flip.vertical and 1 or 0, t.flip.vertical and 0 or 1) end
			if data.color then texture:SetVertexColor(wt.UnpackColor(data.color)) end
		end

		--Set the base texture
		setTexture(t)

		--[ Texture Updates ]

		if updates then for key, value in pairs(updates) do
			value.frame = value.frame or t.parent
			--Set the script
			if value.frame:HasScript(key) then value.frame:HookScript(key, function(self, ...)
				--Unconditional: Restore the base backdrop on trigger
				if not value.rule then
					setTexture(t)
					return
				end

				--Conditional: Evaluate the rule & fill texture update date with the base values
				local data = wt.AddMissing(value.rule(self, ...), t)

				--Update the texture
				setTexture(data)
			end) end
		end end

		return texture
	end


	--[[ CONTAINERS ]]

	--[ Panel Frame ]

	---Create a new simple panel frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The main options frame to set as the parent of the new panel
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Panel"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown as the title of the panel | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above to the panel | ***Default:*** true
	--- - **description**? string *optional* — Text to be shown as the subtitle or description of the panel
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **keepInBounds**? boolean *optional* — Whether to keep the panel within screen bounds whenever it's moved | ***Default:*** false
	--- - **size** table
	--- 	- **width**? number *optional* — ***Default:*** *width of the parent frame* - 32
	--- 	- **height** number
	--- - **background**? table *optional* ― Table containing the parameters used for the background
	--- 	- **path**? string *optional* ― Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/ChatFrame/ChatFrameBackground"
	--- 		- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 		- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 		- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- 	- **size** number — Size of a single background tile square | ***Default:*** 5
	--- 	- **tile**? boolean *optional* — Whether to repeat the texture to fill the entire size of the frame | ***Default:*** true
	--- 	- **insets**? table *optional* ― Offset the position of the background texture from the edges of the frame inward
	--- 		- **left**? number *optional* — ***Default:*** 4
	--- 		- **right**? number *optional* — ***Default:*** 4
	--- 		- **top**? number *optional* — ***Default:*** 4
	--- 		- **bottom**? number *optional* — ***Default:*** 4
	--- 	- **color**? table *optional* — Apply the specified color to the background texture
	--- 		- **r** number ― Red | ***Range:*** (0, 1) | ***Default:*** 0.175
	--- 		- **g** number ― Green | ***Range:*** (0, 1) | ***Default:*** 0.175
	--- 		- **b** number ― Blue | ***Range:*** (0, 1) | ***Default:*** 0.175
	--- 		- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 0.45
	--- - **border**? table *optional* ― Table containing the parameters used for the border
	--- 	- **path**? string *optional* ― Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/Tooltips/UI-Tooltip-Border"
	--- 		- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 		- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 		- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- 	- **width** number — Width of the backdrop edge | ***Default:*** 16
	--- 	- **color**? table *optional* — Apply the specified color to the border texture
	--- 		- **r** number ― Red | ***Range:*** (0, 1) | ***Default:*** 0.75
	--- 		- **g** number ― Green | ***Range:*** (0, 1) | ***Default:*** 0.75
	--- 		- **b** number ― Blue | ***Range:*** (0, 1) | ***Default:*** 0.75
	--- 		- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 0.5
	---@return Frame panel
	wt.CreatePanel = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Panel")

		--[ Frame Setup ]

		--Create the panel frame
		local panel = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

		--Position & dimensions
		if t.keepInBound then panel:SetClampedToScreen(true) end
		wt.SetPosition(panel, t.position)
		panel:SetSize(t.size.width or t.parent:GetWidth() - 32, t.size.height)

		--Backdrop
		wt.SetBackdrop(panel, {
			background = wt.AddMissing(t.background, {
				texture = {
					size = 5,
					insets = { left = 4, right = 4, top = 4, bottom = 4 },
				},
				color = { r = 0.175, g = 0.175, b = 0.175, a = 0.45 }
			}),
			border = wt.AddMissing(t.border, {
				texture = { width = 16, },
				color = { r = 0.75, g = 0.75, b = 0.75, a = 0.5 }
			})
		})

		--Title & description
		wt.AddTitle({
			parent = panel,
			title = t.label ~= false and {
				text = t.title or t.name or "Panel",
				offset = { x = 10, y = 16 },
			} or nil,
			description = t.description and {
				text = t.description,
				offset = { x = 4, y = -16 },
			} or nil
		})

		return panel
	end

	--[ Scrollable Frame ]

	---Create an empty vertically scrollable frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** FrameThe frame to place the scroll frame into
	--- - **name**? string *optional* — Unique string used to set the name of the new scroll frame | ***Default:*** "ScrollFrame"
	--- - **scrollName**? string *optional* — Unique string used to set the name of the scrolling child frame | ***Default:*** "ScrollChild"
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size**? table *optional*
	--- 	- **width**? number *optional* — Horizontal size of the main scroll frame | ***Default:*** *width of the parent frame*
	--- 	- **height**? number *optional* — Vertical size of the main scroll frame | ***Default:*** *height of the parent frame*
	--- - **scrollSize** table
	--- 	- **width**? number *optional* — Horizontal size of the scrollable child frame | ***Default:*** *width of the scroll frame* - 20
	--- 	- **height** number *optional* — Vertical size of the scrollable child frame
	--- - **scrollSpeed**? number *optional* — Scroll step value | ***Default:*** *half of the height of the scroll bar*
	---@return Frame scrollChild
	---@return Frame scrollFrame
	wt.CreateScrollFrame = function(t)
		local name = t.parent:GetName() .. (t.name and  t.name:gsub("%s+", "") or "ScrollFrame")

		--[ Frame Setup ]

		--Create the scroll frame
		local scrollFrame = CreateFrame("ScrollFrame", name, t.parent, "UIPanelScrollFrameTemplate")

		--Position & dimensions
		wt.SetPosition(scrollFrame, t.position)
		scrollFrame:SetSize((t.size or {}).width or t.parent:GetWidth(), (t.size or {}).height or t.parent:GetHeight())

		--Set scrollbar & button elements
		_G[name .. "ScrollBarScrollUpButton"]:ClearAllPoints()
		_G[name .. "ScrollBarScrollUpButton"]:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", -2, -3)
		_G[name .. "ScrollBarScrollDownButton"]:ClearAllPoints()
		_G[name .. "ScrollBarScrollDownButton"]:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", -2, 3)
		_G[name .. "ScrollBar"]:ClearAllPoints()
		_G[name .. "ScrollBar"]:SetPoint("TOP", _G[name .. "ScrollBarScrollUpButton"], "BOTTOM")
		_G[name .. "ScrollBar"]:SetPoint("BOTTOM", _G[name .. "ScrollBarScrollDownButton"], "TOP")

		--Set scroll speed
		if t.scrollSpeed then _G[name .. "ScrollBar"].scrollStep = t.scrollSpeed end

		--[ Add Scrollbar Background ]

		--Create the background frame
		local scrollBarBG = CreateFrame("Frame", name .. "ScrollBarBackground", scrollFrame,  BackdropTemplateMixin and "BackdropTemplate")

		--Position & dimensions
		scrollBarBG:SetPoint("TOPLEFT", _G[name .. "ScrollBar"], "TOPLEFT", -1, -3)
		scrollBarBG:SetSize(_G[name .. "ScrollBar"]:GetWidth() + 1,  t.parent:GetHeight() - 60)

		--Backdrop
		wt.SetBackdrop(scrollBarBG, {
			background = {
				texture = {
					size = 5,
					insets = { left = 2, right = 2, top = 2, bottom = 2 },
				},
				color = { r = 0.2, g = 0.2, b = 0.2, a = 0.4 }
			},
			border = {
				texture = { width = 12, },
				color = { r = 0.4, g = 0.4, b = 0.4, a = 0.8 }
			}
		})

		--[ Scroll Child Frame ]

		--Create scrollable child frame
		local scrollChild = CreateFrame("Frame", t.parent:GetName() .. (t.scrollName and t.scrollName:gsub("%s+", "") or "ScrollChild"), scrollFrame)

		--Position & dimensions
		scrollChild:SetPoint("TOPLEFT")
		scrollChild:SetSize(t.scrollSize.width or scrollFrame:GetWidth() - 20, t.scrollSize.height)

		--Register for scroll
		scrollFrame:SetScrollChild(scrollChild)

		return scrollChild, scrollFrame
	end

	--[ Context Menu ]

	---Create an empty context menu frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new context menu
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "ContextMenu"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **cursor**? boolean — Open the context menu at the current cursor position instead of **t.position** | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT" if **t.cursor** is false
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* — ***Default:*** 140
	--- - **disabled**? boolean *optional* — Deactivate the context menu on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically activate or deactivate the context menu based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	---@return Frame contextMenu A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - **isEnabled** function — Check whether the context menu is active or not
	--- 	- @*return* **state** boolean — True if it is, false if not
	--- - **setEnabled** function — Activate or deactivate the context menu based on the specified value
	--- 	- @*param* **state**? boolean *optional* — Activate it if true, deactivate if not | ***Default:*** true
	--- - **items** table — The list references of the content items added to this context menu
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when the context menu is opened or closed
	--- 		- @*param* **self** Frame ― Reference to the context menu frame
	--- 		- @*param* **attribute** = "open" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― True if the context menu is open, false if not
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			contextMenu:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "open" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateContextMenu = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "ContextMenu")

		--[ Frame Setup ]

		--Create the context menu frame
		local contextMenu = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

		--Visibility
		contextMenu:SetFrameStrata("DIALOG")

		--Position & dimensions
		contextMenu:SetClampedToScreen(true)
		if t.cursor == false then wt.SetPosition(contextMenu, t.position) end
		contextMenu:SetSize(t.width or 140, 20)

		--Backdrop
		wt.SetBackdrop(contextMenu, {
			background = {
				texture = {
					size = 5,
					insets = { left = 4, right = 4, top = 4, bottom = 4 },
				},
				color = colors.context.bg
			},
			border = {
				texture = { width = 16, },
				color = { r = 1, g = 1, b = 1 }
			}
		})

		--[ Toggle ]

		local enabled = t.disabled ~= true

		--Submenu mouseover utility
		local function checkSubmenus()
			for i = 1, #contextMenu.submenus do if contextMenu.submenus[i]:IsMouseOver() then return true end end
			return false
		end

		contextMenu:Hide()
		contextMenu:SetAttributeNoHandler("open", false)
		t.parent:HookScript("OnMouseUp", function(_, button, isInside)
			if not enabled then return end
			if button == "RightButton" and isInside then
				contextMenu:RegisterEvent("GLOBAL_MOUSE_DOWN")
				contextMenu:Show()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
				--Position
				if t.cursor ~= false then
					local x, y = GetCursorPosition()
					local s = UIParent:GetEffectiveScale()
					contextMenu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
				end
			end
		end)
		contextMenu:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
		function contextMenu:GLOBAL_MOUSE_DOWN(button)
			if button == "LeftButton" or button == "RightButton" and not t.parent:IsMouseOver() and not contextMenu:IsMouseOver() then
				contextMenu:UnregisterEvent("GLOBAL_MOUSE_DOWN")
				contextMenu:RegisterEvent("GLOBAL_MOUSE_UP")
			end
		end
		function contextMenu:GLOBAL_MOUSE_UP(button)
			if (button == "LeftButton" or button == "RightButton") and not t.parent:IsMouseOver() and not contextMenu:IsMouseOver() and not checkSubmenus() then
				contextMenu:UnregisterEvent("GLOBAL_MOUSE_UP")
				contextMenu:Hide()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end
		end
		contextMenu:HookScript("OnShow", function() contextMenu:SetAttribute("open", true) end)
		contextMenu:HookScript("OnHide", function() contextMenu:SetAttribute("open", false) end)

		--[ Getters, Setters & Values ]

		contextMenu.isEnabled = function() return enabled end
		contextMenu.setEnabled = function(state)
			enabled = state ~= false
			if not enabled then
				contextMenu:UnregisterEvent("GLOBAL_MOUSE_DOWN")
				contextMenu:UnregisterEvent("GLOBAL_MOUSE_UP")
				contextMenu:Hide()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end
		end

		--Item & submenu holder
		contextMenu.items = {}
		contextMenu.submenus = {}

		return contextMenu
	end

	---Create an empty submenu as an item for an existing context menu
	---@param contextMenu Frame Reference to the context menu to add this submenu to
	---@param mainContextMenu? Frame Reference to the root context menu to register the submenu under if **contextMenu** is also a submenu | ***Default:*** **contextMenu**
	---@param t table Parameters are to be provided in this table
	--- - **name**? string *optional* — Unique string to append this to the name of **contextMenu** when setting the name | ***Default:*** "Item" *followed by the the increment of the last index of* **contextMenu.items**
	--- - **title**? string *optional* — Text to be shown as the label on the toggle item representing the submenu in the **contextMenu** list | ***Default:*** **t.name**
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the toggle button acting as the trigger item for the submenu displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **width**? number *optional* — ***Default:*** 140
	--- - **hover**? boolean *optional** — If true, open the submenu when its trigger item is being hovered, or if false, open only when it's clicked instead | ***Default:*** true
	--- - **font**? FontObject *optional* — Use this [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object for the label on the trigger item | ***Default:*** "GameFontHighlightSmall"
	--- - **justify**? string *optional* — Set the horizontal justification of the label: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- - **leftSide**? boolean *optional* — Open the submenu on the left instead of the right | ***Default:*** true if **t.justify** is "RIGHT"
	---@return Frame submenu
	---@return Button toggle
	wt.AddContextSubmenu = function(contextMenu, mainContextMenu, t)
		local index = not contextMenu.items[0] and 0 or #contextMenu.items + 1
		local name = contextMenu:GetName() .. (t.name and t.name:gsub("%s+", "") or "Item" .. index)
		local title = t.title or t.name or "Item" .. index

		--[ Toggle Item ]

		--Create the submenu trigger frame
		local toggle = CreateFrame("Button", name, contextMenu, BackdropTemplateMixin and "BackdropTemplate")

		--Add to the context menu
		contextMenu.items[index] = toggle

		--Increase the context menu height
		local contextHeight = contextMenu:GetHeight()
		contextMenu:SetHeight(contextHeight + 20)

		--Position & dimensions
		toggle:SetPoint("TOP", contextMenu, "TOP", 0, -contextHeight + 10)
		toggle:SetSize(contextMenu:GetWidth() - 20, 20)

		--Label
		wt.CreateText({
			parent = toggle,
			position = { anchor = "CENTER", },
			width = toggle:GetWidth(),
			text = title,
			template = t.font or "GameFontHighlightSmall",
			justify = t.justify or "LEFT",
		})

		--Texture: Arrow
		wt.CreateTexture({
			parent = toggle,
			name = "Arrow",
			position = {
				anchor = t.leftSide or t.justify == "RIGHT" and "LEFT" or "RIGHT",
				offset = { x = t.leftSide or t.justify == "RIGHT" and 2 or -2, }
			},
			size = { width = 8, height = 8 },
			path = textures.arrowhead,
			flip = { horizontal = t.leftSide or t.justify == "RIGHT" },
			color = colors.white
		})

		--Texture: Background highlight
		wt.CreateTexture({
			parent = toggle,
			name = "Highlight",
			position = { anchor = "CENTER" },
			size = { width = toggle:GetWidth() + 4, height = toggle:GetHeight() - 2 },
			path = textures.contextBG,
			layer = "BACKGROUND",
			color = colors.context.normal
		}, {
			OnEnter = { rule = function() return { color = IsMouseButtonDown() and colors.context.click or colors.context.hover } end },
			OnLeave = {},
			OnHide = {},
			OnMouseDown = { rule = function() return { color = colors.context.click } end },
			OnMouseUp = { rule = function(self) return self:IsMouseOver() and { color = colors.context.hover } or {} end },
		})

		--Tooltip
		local hoverTarget = nil
		if t.tooltip then
			--Create a trigger to show the tooltip when the button is disabled
			hoverTarget = CreateFrame("Frame", name .. "HoverTarget", toggle)
			hoverTarget:SetPoint("TOPLEFT")
			hoverTarget:SetSize(toggle:GetSize())
			hoverTarget:Hide()
			--Set the tooltip
			wt.AddTooltip({
				parent = toggle,
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_TOPLEFT",
				offset = { x = 20, },
				triggers = { hoverTarget, },
			})
		end

		--[ Flyout Menu ]

		--Create the context submenu frame
		local submenu = CreateFrame("Frame", name .. "Menu", contextMenu, BackdropTemplateMixin and "BackdropTemplate")

		--Add to the context menu
		table.insert((mainContextMenu or contextMenu).submenus, submenu)

		--Visibility
		submenu:SetFrameStrata("DIALOG")
		submenu:SetFrameLevel(contextMenu:GetFrameLevel() + 1)

		--Position & dimensions
		submenu:SetClampedToScreen(true)
		submenu:SetPoint(t.leftSide or t.justify == "RIGHT" and "TOPRIGHT" or "TOPLEFT", toggle, t.leftSide or t.justify == "RIGHT" and "TOPLEFT" or "TOPRIGHT", 0, 10)
		submenu:SetSize(t.width or 140, 20)

		--Backdrop
		wt.SetBackdrop(submenu, {
			background = {
				texture = {
					size = 5,
					insets = { left = 4, right = 4, top = 4, bottom = 4 },
				},
				color = colors.context.bg
			},
			border = {
				texture = { width = 16, },
				color = { r = 1, g = 1, b = 1 }
			}
		})

		--Item mouseover utility
		local function checkItems()
			for i = 0, #submenu.items do if submenu.items[i]:IsMouseOver() then return true end end
			return false
		end

		--Toggle the menu
		submenu:Hide()
		submenu:SetAttributeNoHandler("open", false)
		if t.hover ~= false then
			toggle:HookScript("OnEnter", function() submenu:Show() end)
			toggle:HookScript("OnLeave", function() if not submenu:IsMouseOver() then submenu:Hide() end end)
		else toggle:HookScript("OnClick", function()
			local state = not submenu:IsVisible()
			wt.SetVisibility(submenu, state)
			PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		end) end
		submenu:HookScript("OnLeave", function() if not checkItems() then submenu:Hide() end end)
		contextMenu:HookScript("OnHide", function() submenu:Hide() end)
		submenu:HookScript("OnShow", function() submenu:SetAttribute("open", true) end)
		submenu:HookScript("OnHide", function() submenu:SetAttribute("open", false) end)

		--Item holder
		submenu.items = {}

		return submenu, toggle
	end

	---Create a classic context menu frame as a child of a frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new context menu
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "ContextMenu"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **anchor** string|Region — The current cursor position or a region or frame reference | ***Default:*** 'cursor'
	--- - **offset**? table *optional*
	--- 	- **x**? number | ***Default:*** 0
	--- 	- **y**? number | ***Default:*** 0
	--- - **width**? number *optional* — ***Default:*** 115
	--- - **menu** table — Table of nested subtables for the context menu items containing their attributes
	--- 	- **[*value*]** table — List of attributes representing a menu item (*Select examples below!* See the [full list of attributes](https://www.townlong-yak.com/framexml/5.4.7/UIDropDownMenu.lua#139) that can be set for menu items.)
	--- 		- **text** string — Text to be displayed on the button within the context menu
	--- 		- **isTitle**? boolean *optional* — Set the item as a title instead of a clickable button | ***Default:*** false (*not title*)
	--- 		- **disabled**? number *optional* — Disable the button if set to 1 | ***Range:*** (nil, 1) | ***Default:*** nil or 1 if **t.isTitle** == true
	--- 		- **checked**? boolean *optional* — Whether the button is currently checked or not | ***Default:*** false (*not checked*)
	--- 		- **notCheckable**? number *optional* — Make the item a simple button instead of a checkbox if set to 1 | ***Range:*** (nil, 1) | ***Default:*** nil
	--- 		- **func** function — The function to be called the button is clicked
	--- 		- **hasArrow** boolean — Show the arrow to open the submenu specified in t.menuList
	--- 		- **menuList** table — A table of subtables containing submenu items
	---@return Frame contextMenu
	wt.CreateClassicContextMenu = function(t)
		--Create the context menu frame
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "ContextMenu")
		local contextMenu = CreateFrame("Frame", name, t.parent, "UIDropDownMenuTemplate")
		--Dimensions
		UIDropDownMenu_SetWidth(contextMenu, t.width or 115)
		--Right-click event
		t.parent:HookScript("OnMouseUp", function(_, button, isInside)
			if button == "RightButton" and isInside then EasyMenu(t.menu, contextMenu, t.anchor or "cursor", (t.offset or {}).x or 0, (t.offset or {}).y or 0, "MENU") end
		end)
		return contextMenu
	end

	--[ Settings Category Page ]

	---Create an new Settings Panel frame and add it to the Options
	---@param t table Parameters are to be provided in this tables
	--- - **parent**? table|string *optional* — The options category page or its display name to be set as the parent category, making this its subcategory | ***Default:*** nil *(set as a main category)*
	--- - **addon**? string *optional* — The name of the addon's folder (the addon namespace not its displayed title)
	--- - **name**? string *optional* — Unique string used to set the name of the options frame | ***Default:*** **t.addon**
	--- - **append**? boolean *optional* — If true, when setting the name of the options category page, append **t.name** after **t.addon** | ***Default:*** true if **t.name** is set
	--- - **appendOptions**? boolean *optional* — If true, when setting the name of the canvas frame, append "Options" at the end as well | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown as the title of the options panel | ***Default:*** *the "title" metadata of **t.addon**, deformatted*
	--- - **description**? string *optional* — Text to be shown as the description below the title of the options panel
	--- - **logo**? string *optional* — Path to the texture file, the logo of the addon to be added as to the top right corner of the panel
	--- - **titleLogo**? boolean *optional* — Append the texture specified as **t.logo** to the title of the Settings button as well | ***Default:*** false
	--- - **scroll**? table *optional* — Create an empty ScrollFrame for the category panel
	--- 	- **height** number — Set the height of the scrollable child frame to the specified value
	--- 	- **speed**? number *optional* — Set the scroll rate to the specified value | ***Default:*** *half of the height of the scroll bar*
	--- - **save**? function *optional* — The function to be called when the settings are getting saved by the user
	--- - **load**? function *optional* — The function to be called when the settings panel is loaded
	--- - **cancel**? function *optional* — The function to be called when the changes are getting scrapped by the user before the widgets are updated
	--- - **default**? function *optional* — The function to be called when either the "All Settings" or "These Settings" (***Options Category Panel-specific***) button is clicked from the "Defaults" dialogue before the widgets are updated
	--- - **optionsKey**? table ―  A unique key referencing the collection of widget options data to be saved & loaded with this options category page
	--- - **autoSave**? boolean *optional* — If true, automatically save all data on commit from the storage tables to the widgets described in the collection of options data referenced by **t.optionsKey** | ***Default:*** true if **t.optionsKey** is set
	--- 	- ***Note:*** If **t.optionsKey** is not set, the automatic save will not be executed even if **t.autoSave** is true.
	--- - **autoLoad**? boolean *optional* — If true, automatically load the values of all widgets to the storage tables described in the collection of options data referenced by **t.optionsKey** | ***Default:*** true if **t.optionsKey** is set
	--- 	- ***Note:*** If **t.optionsKey** is not set, the automatic load will not be executed even if **t.autoLoad** is true.
	---@return table optionsPage Table containing references to the options category, its related functions & frames
	--- - **category** table — The settings category frame | ***Default:*** **canvas** *(if its a Classic client)*
	--- - **canvas** [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)] — The options page frame to house the settings widgets
	--- - **scrollChild**? [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)|nil — Scrolling child frame of the scroll frame created as a child of **canvas** if **t.scroll** was set
	--- - **open** function — Call to open the interface settings panel to this category page
	--- - **save** function — Call to force save the options in this category page (calls **t.save** as well)
	--- - **load** function — Call to force update the options widgets in this category page (calls **t.load** as well)
	--- - **cancel** function — Call to cancel any changes made in this category page (calls **t.cancel** along with **load** & **t.load** as well)
	--- - **default** function — Call to reset all options in this category page to their default values (calls **t.default** along with **load** & **t.load** as well)
	wt.CreateOptionsCategory = function(t)
		local name = (t.append ~= false and t.addon or "") .. (t.name and t.name:gsub("%s+", "") or t.addon)
		local title = t.title or wt.Clear(GetAddOnMetadata(t.addon, "title")):gsub("^%s*(.-)%s*$", "%1")
		local optionsPage = {}

		--[ Options Data Management Utilities ]

		optionsPage.save = function()
			if t.optionsKey then if t.autoSave ~= false then wt.SaveOptionsData(t.optionsKey) end end
			if t.save then t.save() end
		end
		optionsPage.load = function()
			if t.optionsKey then if t.autoLoad ~= false then wt.LoadOptionsData(t.optionsKey) end end
			if t.load then t.load() end
		end
		optionsPage.cancel = function()
			if t.cancel then t.cancel() end
			if t.optionsKey then wt.LoadOptionsData(t.optionsKey) end
		end
		optionsPage.default = function()
			if t.default then t.default() end
			if t.optionsKey then wt.LoadOptionsData(t.optionsKey) end
		end

		--[ Options Page Setup ]

		--Create the options page
		if wt.classic then
			--Create the options canvas frame
			optionsPage.canvas = CreateFrame("Frame", name .. (t.appendOptions ~= false and "Options" or ""), InterfaceOptionsFramePanelContainer)

			--Position, dimensions & visibility
			optionsPage.canvas:SetSize(InterfaceOptionsFramePanelContainer:GetSize())
			optionsPage.canvas:SetPoint("TOPLEFT") --Preload the frame
			optionsPage.canvas:Hide()

			--Set category page reference
			optionsPage.category = optionsPage.canvas

			--Set the category name
			optionsPage.category.name = title .. (t.logo and t.titleLogo and " |T" .. t.logo .. ":0|t" or "")

			--Set as a subcategory or a parent category
			if t.parent then optionsPage.category.parent = t.parent.name end

			--Event handlers
			optionsPage.category.okay = function() optionsPage.save() end
			optionsPage.category.refresh = function() optionsPage.load() end
			optionsPage.category.cancel = function() optionsPage.cancel() end
			optionsPage.category.default = function() optionsPage.default() end

			--Add to the Interface options
			InterfaceOptions_AddCategory(optionsPage.category)
		else
			--Create the options canvas frame
			optionsPage.canvas = CreateFrame("Frame", name .. (t.appendOptions ~= false and "Options" or ""))

			--Dimensions
			optionsPage.canvas:SetSize(SettingsPanel.Container.SettingsCanvas:GetSize())

			--Event handlers
			optionsPage.canvas.OnCommit = function() optionsPage.save() end
			optionsPage.canvas.OnRefresh = function() optionsPage.load() end
			optionsPage.canvas.OnDefault = function() optionsPage.default() end

			--Create the category or subcategory page
			if t.parent then optionsPage.category = Settings.RegisterCanvasLayoutSubcategory(t.parent, optionsPage.canvas, title)
			else optionsPage.category = Settings.RegisterCanvasLayoutCategory(optionsPage.canvas, title) end

			--Add save notice text
			wt.CreateText({
				parent = optionsPage.canvas,
				name = "SaveNotice",
				position = {
					anchor = "BOTTOMRIGHT",
					offset = { x = -106, y = -26.75 }
				},
				text = strings.options.save,
			})

			--Button: Cancel
			wt.CreateButton({
				parent = optionsPage.canvas,
				name = "Cancel",
				title = strings.options.cancel,
				position = {
					anchor = "BOTTOMLEFT",
					offset = { x = 138, y = -31 }
				},
				size = { width = 140, },
				events = { OnClick = optionsPage.cancel, },
			})

			--Button & Popup: Default
			local defaultWarning = wt.CreatePopup({
				addon = t.addon,
				name = name .. "DefaultOptions",
				text = strings.options.warning:gsub("#TITLE", wt.Clear(GetAddOnMetadata(t.addon, "title")) .. (t.parent and (": " .. title) or "")),
				accept = strings.options.accept,
				onAccept = optionsPage.default,
			})
			wt.CreateButton({
				parent = optionsPage.canvas,
				name = "Default",
				title = strings.options.default,
				position = {
					anchor = "BOTTOMLEFT",
					offset = { x = -18, y = -31 }
				},
				size = { width = 140, },
				events = { OnClick = function() StaticPopup_Show(defaultWarning) end, },
			})

			--Add to the Settings
			Settings.RegisterAddOnCategory(optionsPage.category)

			--Set the category name
			optionsPage.category.name = title .. (t.logo and t.titleLogo and " |T" .. t.logo .. ":0|t" or "")
		end

		--Title & description
		local label, description = wt.AddTitle({
			parent = optionsPage.canvas,
			title = {
				text = title,
				template = "GameFontNormalLarge",
				offset = { x = 10, y = -16 },
				width = optionsPage.canvas:GetWidth() - (t.logo and 72 or 32),
			},
			description = t.description and {
				text = t.description,
				offset = { y = -8 },
				width = optionsPage.canvas:GetWidth() - (t.logo and 72 or 32),
			} or nil
		})

		--Logo texture
		local logo = nil
		if t.logo then
			logo = wt.CreateTexture({
				parent = optionsPage.canvas,
				name = "Logo",
				position = {
					anchor = "TOPRIGHT",
					offset = { x = -16, y = -16 }
				},
				size = { width = 36, height = 36 },
				path = t.logo,
			})
		end

		--[ Make Scrollable ]

		if t.scroll then
			--Create the ScrollFrame
			optionsPage.scrollChild = wt.CreateScrollFrame({
				parent = optionsPage.canvas,
				position = { offset = { x = 0, y = -4 } },
				size = { width = optionsPage.canvas:GetWidth() - 4, height = optionsPage.canvas:GetHeight() - (wt.classic and 8 or 16) },
				scrollSize = { width = optionsPage.canvas:GetWidth() - 20, height = t.scroll.height, },
				scrollSpeed = t.scroll.speed
			})
			--Reparent, reposition and resize default elements
			label:SetParent(optionsPage.scrollChild)
			label:SetPoint("TOPLEFT", 10, -12)
			label:SetWidth(label:GetWidth() - 20)
			if description then
				description:SetParent(optionsPage.scrollChild)
				description:SetWidth(description:GetWidth() - 20)
			end
			if logo then
				logo:SetParent(optionsPage.scrollChild)
				logo:SetPoint("TOPRIGHT", -16, -12)
			end
		end

		--[ Open Utility ]

		optionsPage.open = wt.classic and function()
			InterfaceOptionsFrame_OpenToCategory(optionsPage.category)
			InterfaceOptionsFrame_OpenToCategory(optionsPage.category) --Load twice to make sure the proper page and category is loaded
		end or function() Settings.OpenToCategory(optionsPage.category:GetID()) end --FIXME: Add support whenever they add opening to subcategories

		return optionsPage
	end


	--[[ DATA WIDGETS ]]

	--[ Button ]

	---Create a button frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new button
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Button"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown on the button and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** on the button frame | ***Default:*** true
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the button displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size** table
	--- 	- **width**? number *optional* — ***Default:*** 80
	--- 	- **height**? number *optional* — ***Default:*** 22
	--- - **customizable**? boolean *optional* ― Create the button with `BackdropTemplateMixin and "BackdropTemplate"` to be easily customizable | ***Default:*** false
	--- 	- ***Note:*** You may use ***WidgetToolbox*.SetBackdrop(...)** to set up the frame quickly.
	--- - **font**? FontObject *optional* — Use this [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object for the label | ***Default:*** "GameFontNormal" if **t.customizable** is true
	--- - **fontHover**? FontObject — Use this [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object for the label when the button is being hovered | ***Default:*** "GameFontHighlight" if **t.customizable** is true
	--- - **fontDisabled**? FontObject — Use this [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object for the label when the button is disabled | ***Default:*** "GameFontDisabled" if **t.customizable** is true
	--- - **events**? table *optional* — Table of key, value pairs that holds event handler scripts to be set for the button
	--- 	- **[*key*]** string — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button#Defined_Script_Handlers)
	--- 		- ***Example:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" when the button is clicked.
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	---@return Button button A base Button object with custom functions added
	--- - **setEnabled** function — Enable or disable the button widget based on the specified value
	--- 	- @*param* **state** boolean — Enable the input if true, disable if not
	wt.CreateButton = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Button")
		local title = t.title or t.name or "Button"
		local custom = t.customizable and (BackdropTemplateMixin and "BackdropTemplate") or nil

		--[ Frame Setup ]

		--Create the button frame
		local button = CreateFrame("Button", name, t.parent, custom or "UIPanelButtonTemplate")

		--Position & dimensions
		wt.SetPosition(button, t.position)
		button:SetSize((t.size or {}).width or 80, (t.size or {}).height or 22)

		--Label
		if custom then wt.CreateText({
			parent = button,
			position = { anchor = "CENTER", },
			width = button:GetWidth(),
			text = title,
			template = t.font or "GameFontNormal",
		}) end
		if t.label ~= false then _G[name .. "Text"]:SetText(title) else _G[name .. "Text"]:Hide() end

		--[ Events & Behavior ]

		--Register event handlers
		if t.events then for key, value in pairs(t.events) do button:HookScript(key, value) end end

		--Custom behavior
		button:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		if t.fontHover or custom then
			button:HookScript("OnEnter", function() _G[name .. "Text"]:SetFontObject(t.fontHover or "GameFontHighlight") end)
			button:HookScript("OnLeave", function() _G[name .. "Text"]:SetFontObject(t.font or "GameFontNormal") end)
		end

		--Tooltip
		local hoverTarget = nil
		if t.tooltip then
			--Create a trigger to show the tooltip when the button is disabled
			hoverTarget = CreateFrame("Frame", name .. "HoverTarget", button)
			hoverTarget:SetPoint("TOPLEFT")
			hoverTarget:SetSize(button:GetSize())
			hoverTarget:Hide()

			--Set the tooltip
			wt.AddTooltip({
				parent = button,
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_TOPLEFT",
				offset = { x = 20, },
				triggers = { hoverTarget, },
			})
		end

		--[ Getters & Setters ]

		button.setEnabled = function(state)
			button:SetEnabled(state)
			if state then
				if button:IsMouseOver() then if t.fontHover or custom then _G[name .. "Text"]:SetFontObject(t.fontHover or "GameFontHighlight") end
				elseif t.font or custom then _G[name .. "Text"]:SetFontObject(t.font or "GameFontNormal") end
				if hoverTarget then hoverTarget:Hide() end
			else
				if t.fontDisabled or custom then _G[name .. "Text"]:SetFontObject(t.fontDisabled or "GameFontDisable") end
				if hoverTarget then hoverTarget:Show() end
			end
		end

		--State & dependencies
		if t.disabled then button.setEnabled(false) end
		if t.dependencies then wt.SetDependencies(t.dependencies, button.setEnabled) end

		return button
	end

	---Create a button widget as a child of a context menu frame
	---@param contextMenu Frame Reference to the context menu to add this button to
	---@param mainContextMenu? Frame Reference to the root context menu to hide after clicking the button | ***Default:*** **contextMenu**
	---@param t table Parameters are to be provided in this table
	--- - **name**? string *optional* — Unique string to append this to the name of **contextMenu** when setting the name | ***Default:*** "Item" *followed by the the increment of the last index of* **contextMenu.items**
	--- - **title**? string *optional* — Text to be shown on the button and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the button displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **font**? FontObject *optional* — Use this [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object for the label | ***Default:*** "GameFontHighlightSmall"
	--- - **fontHover**? FontObject — Use this [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object for the label when the button is being hovered | ***Default:*** "GameFontHighlightSmall"
	--- - **fontDisabled**? FontObject — Use this [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object for the label when the button is disabled | ***Default:*** "GameFontDisabledSmall"
	--- - **justify**? string *optional* — Set the horizontal justification of the label: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- - **events**? table *optional* — Table of key, value pairs that holds event handler scripts to be set for the button
	--- 	- **[*key*]** string — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button#Defined_Script_Handlers)
	--- 		- ***Example:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" when the button is clicked.
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	---@return Button button A base Button object with custom functions added
	--- - **setEnabled** function — Enable or disable the button widget based on the specified value
	--- 	- @*param* **state** boolean — Enable the input if true, disable if not
	wt.AddContextButton = function(contextMenu, mainContextMenu, t)
		local index = not contextMenu.items[0] and 0 or #contextMenu.items + 1
		local name = (t.append ~= false and contextMenu:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Item" .. index)
		local title = t.title or t.name or "Item" .. index

		--[ Frame Setup ]

		--Create the button frame
		local button = CreateFrame("Button", name, contextMenu, BackdropTemplateMixin and "BackdropTemplate")

		--Add to the context menu
		contextMenu.items[index] = button

		--Increase the context menu height
		local contextHeight = contextMenu:GetHeight()
		contextMenu:SetHeight(contextHeight + 20)

		--Position & dimensions
		button:SetPoint("TOP", contextMenu, "TOP", 0, -contextHeight + 10)
		button:SetSize(contextMenu:GetWidth() - 20, 20)

		--Label
		wt.CreateText({
			parent = button,
			position = { anchor = "CENTER", },
			width = button:GetWidth(),
			text = title,
			template = t.font or "GameFontHighlightSmall",
			justify = t.justify or "LEFT",
		})

		--Texture: Background highlight
		wt.CreateTexture({
			parent = button,
			name = "Highlight",
			position = { anchor = "CENTER" },
			size = { width = button:GetWidth() + 4, height = button:GetHeight() - 2 },
			path = textures.contextBG,
			color = colors.context.normal
		}, {
			OnEnter = { rule = function() return { color = IsMouseButtonDown() and colors.context.click or colors.context.hover } end },
			OnLeave = {},
			OnHide = {},
			OnMouseDown = { rule = function(self) return self:IsEnabled() and { color = colors.context.click } or {} end },
			OnMouseUp = { rule = function(self) return self:IsEnabled() and self:IsMouseOver() and { color = colors.context.hover } or {} end },
		})

		--[ Events & Behavior ]

		--Register event handlers
		if t.events then for key, value in pairs(t.events) do button:HookScript(key, value) end end

		--Custom behavior
		button:HookScript("OnClick", function()
			(mainContextMenu or contextMenu):Hide()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end)
		if t.fontHover then
			button:HookScript("OnEnter", function() _G[name .. "Text"]:SetFontObject(t.fontHover or "GameFontHighlightSmall") end)
			button:HookScript("OnLeave", function() _G[name .. "Text"]:SetFontObject(t.font or "GameFontHighlightSmall") end)
		end

		--Tooltip
		local hoverTarget = nil
		if t.tooltip then
			--Create a trigger to show the tooltip when the button is disabled
			hoverTarget = CreateFrame("Frame", name .. "HoverTarget", button)
			hoverTarget:SetPoint("TOPLEFT")
			hoverTarget:SetSize(button:GetSize())
			hoverTarget:Hide()

			--Set the tooltip
			wt.AddTooltip({
				parent = button,
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_TOPLEFT",
				offset = { x = 20, },
				triggers = { hoverTarget, },
			})
		end

		--[ Getters & Setters ]

		button.setEnabled = function(state)
			button:SetEnabled(state)
			if state then
				if button:IsMouseOver() then _G[name .. "Text"]:SetFontObject(t.fontHover or "GameFontHighlightSmall")
				else _G[name .. "Text"]:SetFontObject(t.font or "GameFontHighlightSmall") end
				if hoverTarget then hoverTarget:Hide() end
			else
				_G[name .. "Text"]:SetFontObject(t.fontDisabled or "GameFontDisableSmall")
				if hoverTarget then hoverTarget:Show() end
			end
		end

		--State & dependencies
		if t.disabled then button.setEnabled(false) end
		if t.dependencies then wt.SetDependencies(t.dependencies, button.setEnabled) end

		return button
	end

	--[ Checkbox ]

	---Create a checkbox frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new checkbox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Checkbox"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown on the right of the checkbox and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** as the label next to the checkbox | ***Default:*** true
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the checkbox displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **autoOffset**? boolean *optional* — Offset the position of the checkbox in a Category Panel to place it into a 3 column grid based on its anchor point. | ***Default:*** false
	--- - **events**? table *optional* — Table of key, value pairs that holds event handler scripts to be set for the checkbox
	--- 	- **[*key*]** string — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- 		- ***Note:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" will be called with custom parameters:
	--- 			- @*param* **self** Frame ― Reference to the checkbox frame
	--- 			- @*param* **state** boolean ― The checked state of the checkbox frame
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the checkbox to the options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* boolean ― The current value of the checkbox
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the checkbox
	--- 		- @*return* boolean ― The value to be set to the checkbox
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** boolean ― The saved value of the frame
	--- 	- **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** boolean ― The value loaded to the frame
	---@return CheckButton checkbox A base CheckButton object with custom functions and events added
	--- - **setEnabled** function — Enable or disable the checkbox widget based on the specified value
	--- 	- @*param* **state** boolean — Enable the input if true, disable if not
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* **self** Frame ― Reference to the checkbox frame
	--- 		- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			checkbox:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateCheckbox = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Checkbox")
		local title = t.title or t.name or "Checkbox"

		--[ Frame Setup ]

		--Create the checkbox frame
		local checkbox = CreateFrame("CheckButton", name, t.parent, "InterfaceOptionsCheckButtonTemplate")

		--Position & dimensions
		local w = checkbox:GetWidth() --Frame width
		local cW = (t.parent:GetWidth() - 16 - 20) / 3 --Column width
		local columnOffset = t.autoOffset and (t.position.anchor == "TOP" and cW / -2 + w / 2 or (t.position.anchor == "TOPRIGHT" and -cW - 8 + w or 0) or 8) or 0
		t.position.offset = t.position.offset or {}
		t.position.offset.x = (t.position.offset.x or 0) + columnOffset
		wt.SetPosition(checkbox, t.position)

		--Label
		local label = nil
		if t.label ~= false then
			label = _G[name .. "Text"]
			label:SetPoint("LEFT", checkbox, "RIGHT")
			label:SetFontObject("GameFontHighlight")
			label:SetText(title)
		else _G[name .. "Text"]:Hide() end

		--[ Events & Behavior ]

		--Register event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "OnClick" then checkbox:SetScript("OnClick", function(self) value(self, self:GetChecked()) end)
			else checkbox:HookScript(key, value) end
		end end

		--Custom behavior
		checkbox:HookScript("OnClick", function(self) PlaySound(self:GetChecked() and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF) end)

		--Tooltip
		if t.tooltip then wt.AddTooltip({
			parent = checkbox,
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}) end

		--[ Getters & Setters ]

		checkbox.setEnabled = function(state)
			checkbox:SetEnabled(state)
			if label then label:SetFontObject(state and "GameFontHighlight" or "GameFontDisable") end
		end

		--State & dependencies
		if t.disabled then checkbox.setEnabled(false) end
		if t.dependencies then wt.SetDependencies(t.dependencies, checkbox.setEnabled) end

		--[ Options Data ]

		if t.optionsData then wt.AddOptionsData(checkbox, checkbox:GetObjectType(), t.optionsData) end

		return checkbox
	end

	--[ Selector & Radio Button ]

	---Create a radio button frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new radio button
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "RadioButton"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown on the right of the radio button and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** and add a clickable extension next to the radio button | ***Default:*** true
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the radio button displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* — The combined width of the radio button's dot and the clickable extension to the right of it (where the label is) | ***Default:*** 140
	--- - **clearable**? boolean *optional* — Whether this radio button should be clearable by right clicking on it or not | ***Default:*** false
	--- 	- ***Note:*** **onClick** will be called after this input is cleared
	--- - **events**? table *optional* — Table of key, value pairs that holds event handler scripts to be set for the radio button
	--- 	- **[*key*]** string — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- 		- ***Note:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" will be called with custom parameters:
	--- 			- @*param* **self** Frame ― Reference to the radio button frame
	--- 			- @*param* **state** boolean ― The checked state of the radio button frame
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the radio button to the options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* boolean ― The current value of the radio button
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the radio button
	--- 		- @*return* boolean ― The value to be set to the radio button
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** boolean ― The saved value of the frame
	--- 	- **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** boolean ― The value loaded to the frame
	---@return CheckButton radioButton A base CheckButton (with UIRadioButtonTemplate) object with custom functions and events added
	--- - **setEnabled** function — Enable or disable the radio button widget based on the specified value
	--- 	- @*param* **state** boolean — Enable the input if true, disable if not
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* **self** Frame ― Reference to the radio button frame
	--- 		- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			radioButton:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateRadioButton = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "RadioButton")
		local title = t.title or t.name or "RadioButton"

		--[ Frame Setup ]

		--Create the radio button frame
		local radioButton = CreateFrame("CheckButton", name, t.parent, "UIRadioButtonTemplate")

		--Position
		wt.SetPosition(radioButton, t.position)

		--Label
		local label = nil
		local extension = nil
		if t.label ~= false then
			--Font & text
			label = _G[name .. "Text"]
			label:SetFontObject("GameFontHighlightSmall")
			label:SetText(title)
			--Add extension
			extension = CreateFrame("Frame", name .. "Extension", radioButton)
			--Position & dimensions
			extension:SetSize((t.width or 140) - radioButton:GetWidth(), radioButton:GetHeight())
			extension:SetPoint("TOPLEFT", radioButton, "TOPRIGHT")
			--Linked events
			extension:HookScript("OnEnter", function() if radioButton:IsEnabled() then radioButton:LockHighlight() end end)
			extension:HookScript("OnLeave", function() if radioButton:IsEnabled() then radioButton:UnlockHighlight() end end)
			extension:HookScript("OnMouseDown", function() if radioButton:IsEnabled() then radioButton:Click() end end)
		else _G[name .. "Text"]:Hide() end

		--[ Events & behavior ]

		--Register event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "OnClick" then radioButton:SetScript("OnClick", function(self) value(self, self:GetChecked()) end)
			else radioButton:HookScript(key, value) end
		end end

		--Custom behavior
		radioButton:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		if t.clearable then radioButton:HookScript("OnMouseUp", function(self, button, isInside) if button == "RightButton" and isInside and radioButton:IsEnabled() then
			self:SetChecked(false)
			if (t.events or {}).OnClick then t.events.OnClick(self, false) end
		end end) end

		--Tooltip
		if t.tooltip then wt.AddTooltip({
			parent = radioButton,
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
			triggers = { extension, },
		}) end

		--[ Getters & Setters ]

		radioButton.setEnabled = function(state)
			radioButton:SetEnabled(state)
			if label then label:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall") end
		end

		--State & dependencies
		if t.disabled then radioButton.setEnabled(false) end
		if t.dependencies then wt.SetDependencies(t.dependencies, radioButton.setEnabled) end

		--[ Options Data ]

		if t.optionsData then wt.AddOptionsData(radioButton, radioButton:GetObjectType(), t.optionsData) end

		return radioButton
	end

	---Create a selector frame, a collection of radio buttons to pick one out of multiple options
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new selector
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Selector"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the selector frame | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the selector | ***Default:*** true
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the selector displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* ― The height is dynamically set to fit all radio button items (and the title if **t.label** is set), the width may be specified | ***Default:*** 140
	--- - **items** table [indexed, 0-based] — Table containing subtables with data used to create radio button items, or already existing radio button widget frames
	--- 	- **[*index*]** table ― Parameters of a selector item
	--- 		- **title** string — Text to be shown on the right of the radio button to represent the item within the selector frame
	--- 		- **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the radio button displayed when mousing over the frame
	--- 			- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.items[*index*.title]**
	--- 			- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 				- **[*index*]** table ― Parameters of an additional line of text
	--- 					- **text** string ― Text to be displayed in the line
	--- 					- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 					- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 						- **r** number ― Red | ***Range:*** (0, 1)
	--- 						- **g** number ― Green | ***Range:*** (0, 1)
	--- 						- **b** number ― Blue | ***Range:*** (0, 1)
	--- 					- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- 		- **onSelect**? function *optional* — The function to be called when the radio button is clicked and the item is selected
	--- 			- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected (see below).
	--- - **labels**? boolean *optional* — Whether or not to add the labels to the right of each newly created radio button | ***Default:*** true
	--- - **columns**? integer *optional* — Arrange the newly created radio buttons in a grid with the specified number of columns instead of a vertical list | ***Default:*** 1
	--- - **selected**? integer *optional* — The item to be set as selected on load | ***Default:*** nil *(no selection)*
	--- - **clearable**? boolean *optional* — Whether the selector input should be clearable by right clicking on its radio button items or not (the functionality of **setSelected** called with nil to clear the input will not be affected) | ***Default:*** false
	--- - **onSelection** function — The function to be called when a radio button is clicked and an item is selected, or when the input is cleared by the user
	--- 	- @*param* **index**? integer|nil *optional* — The index of the currently selected item
	--- 	- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected (see below).
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the selector to the options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param*? integer|nil *optional* ― The index of the currently selected item in the selector
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the selector
	--- 		- @*return* *index*? integer|nil ― The index of the item to be set as selected in the selector
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value**? integer|nil *optional* ― The saved value of the frame
	--- 	- **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value**? integer|nil *optional* ― The value loaded to the frame
	---@return Frame selector A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - **getUniqueType** function — Returns the object type of this unique frame
	--- 	- @*return* "Selector" UniqueFrameType
	--- - **isUniqueType** function — Checks and returns if the type of this unique frame is equal to the string provided
	--- 	- @*param* **type** string
	--- 	- @*return* boolean
	--- - **getSelected** function — Returns the index of the currently selected item or nil if there is no selection
	--- 	- @*return* **index**? integer|nil — 0-based
	--- - **setSelected** function — Set the specified item as selected (automatically called when an item is manually selected by clicking on a radio button)
	--- 	- @*param* **index**? integer *optional* — 0-based | ***Default:*** nil *(clear the selection)*
	--- 	- @*param* **user**? boolean *optional* — Whether to call **t.item.onSelect** | ***Default:*** false
	--- - **setEnabled** function — Enable or disable the selector widget based on the specified value
	--- 	- @*param* **state** boolean — Enable the input if true, disable if not
	--- - **items** table — The list references of the radio button widget frames linked together in this selector
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **setSelected** was called or an option was clicked or cleared
	--- 		- @*param* **self** Frame ― Reference to the selector frame
	--- 		- @*param* **attribute** = "selected" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **index**? integer|nil ― The (0-based) index of the currently selected item
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, index)
	--- 				if attribute ~= "selected" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* **self** Frame ― Reference to the selector frame
	--- 		- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateSelector = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Selector")
		local title = t.title or t.name or "Selector"

		--[ Frame Setup ]

		--Create the selector frame
		local selector = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		wt.SetPosition(selector, t.position)
		selector:SetSize(t.width or 140, math.ceil(#t.items / (t.columns or 1)) * 16 + (t.label and 30 or 18))

		--Label
		local label = wt.AddTitle({
			parent = selector,
			title = t.label ~= false and {
				text = title,
				offset = { x = 4, },
			} or nil,
		})

		--[ Radio Buttons ]

		selector.items = {}
		for i = 0, #t.items do
			local new = true
			--Check if it's an already existing radio button
			if t.items[i].IsObjectType then if t.items[i]:IsObjectType("CheckButton") then
				selector.items[i] = t.items[i]
				new = false
			end end
			--Create a new radio button --TODO: Handle multicolumn selectors with labels better
			if new then local sameRow = i % (t.columns or 1) > 0
				selector.items[i] = wt.CreateRadioButton({
					parent = selector,
					name = "Item" .. i,
					title = t.items[i].title,
					label = t.labels,
					tooltip = t.items[i].tooltip,
					position = {
						relativeTo = i > 0 and selector.items[sameRow and i - 1 or i - (t.columns or 1)] or label,
						relativePoint = sameRow and "TOPRIGHT" or "BOTTOMLEFT",
						offset = { y = i > 0 and 0 or -2 }
					},
					width = selector:GetWidth() - 4, 
					clearable = t.clearable,
				})
			end
		end

		--[ Events & Behavior ]

		--Tooltip
		if t.tooltip then wt.AddTooltip({
			parent = selector,
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}) end

		--[ Getters & Setters ]

		selector.getUniqueType = function() return "Selector" end
		selector.isUniqueType = function(type) return type == "Selector" end
		selector.getSelected = function()
			for i = 0, #selector.items do if selector.items[i]:GetChecked() then return i end end
			return nil
		end
		selector.setSelected = function(index, user)
			if not index then
				--Clear the input
				for i = 0, #selector.items do selector.items[i]:SetChecked(false) end
			else
				if index > #selector.items then index = #selector.items elseif index < 0 then index = 0 end
				for i = 0, #selector.items do selector.items[i]:SetChecked(i == index) end
				if t.items[index].onSelect and user then t.items[index].onSelect() end
			end
			--Call listeners & evoke a custom event
			if t.onSelection and user then t.onSelection(index) end
			selector:SetAttribute("selected", index)
		end
		selector.setEnabled = function(state)
			if label then label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
			for i = 0, #selector.items do
				selector.items[i]:SetEnabled(state)
				local itemLabel = _G[selector.items[i]:GetName() .. "Text"]
				if itemLabel then itemLabel:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall") end
			end
		end

		--Chain selection events
		for i = 0, #selector.items do
			selector.items[i]:HookScript("OnClick", function() selector.setSelected(i, true) end)
			if t.clearable then selector.items[i]:HookScript("OnMouseUp", function(_, button, isInside) if button == "RightButton" and isInside and selector.items[i]:IsEnabled() then
				selector.setSelected(nil, true)
			end end) end
		end

		--Starting value
		selector.setSelected(t.selected)

		--State & dependencies
		if t.disabled then selector.setEnabled(false) end
		if t.dependencies then wt.SetDependencies(t.dependencies, selector.setEnabled) end

		--[ Options Data ]

		if t.optionsData then wt.AddOptionsData(selector, selector.getUniqueType(), t.optionsData) end

		return selector
	end

	--[ Anchor Point Selector ]

	--Anchor point index table
	local anchors = {
		[0] = { name = strings.points.top.left, point = "TOPLEFT" },
		[1] = { name = strings.points.top.center, point = "TOP" },
		[2] = { name = strings.points.top.right, point = "TOPRIGHT" },
		[3] = { name = strings.points.left, point = "LEFT" },
		[4] = { name = strings.points.center, point = "CENTER" },
		[5] = { name = strings.points.right, point = "RIGHT" },
		[6] = { name = strings.points.bottom.left, point = "BOTTOMLEFT" },
		[7] = { name = strings.points.bottom.center, point = "BOTTOM" },
		[8] = { name = strings.points.bottom.right, point = "BOTTOMRIGHT" },
	}

	---Create an Anchor Point selector frame, a collection of radio buttons to pick a Frame Anchor Point
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new selector
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "AnchorPointSelector"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the selector frame | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the selector | ***Default:*** true
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the selector frame displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* ― The height is dynamically set to fit all radio button items (and the title if **t.label** is set), the width may be specified | ***Default:*** 56
	--- - **selected**? integer *optional* — The item to be set as selected on load | ***Default:*** 0
	--- - **clearable**? boolean *optional* — Whether the selector input should be clearable by right clicking on its radio button items or not (the functionality of **setSelected** called with nil to clear the input will not be affected) | ***Default:*** false
	--- - **onSelection** function — The function to be called when a radio button is clicked and an Anchor Point is selected, or when the input is cleared by the user
	--- 	- @*param* **point**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — The currently selected Anchor Point
	--- 	- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected (see below).
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the selector to the options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey** string ― Key of the variable inside the storage table
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **point**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)|nil *optional* ― The saved Anchor Point selected in the frame
	--- 	- **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **point**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)|nil *optional* ― The Anchor Point loaded to the selector frame
	---@return Frame selector A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom functions and events added
	--- - **getUniqueType** function — Returns the object type of this unique frame
	--- 	- @*return* "Selector" UniqueFrameType
	--- - **isUniqueType** function Checks and returns if the type of this unique frame is equal to the string provided
	--- 	- @*param* **type** string
	--- 	- @*return* boolean
	--- - **getSelected** function — Returns the index of the currently selected item or nil if there is no selection
	--- 	- @*return* **point**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)|nil
	--- - **setSelected** function — Set the specified item as selected (automatically called when an item is manually selected by clicking on a radio button)
	--- 	- @*param* **anchor**? integer|[AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) — ***Default:*** nil *(clear the selection)*
	--- 	- @*param* **user**? boolean *optional* — Whether to call **t.item.onSelect** | ***Default:*** false
	--- - **setEnabled** function — Enable or disable the selector widget based on the specified value
	--- 	- @*param* **state** boolean — Enable the input if true, disable if not
	--- - **items** table — The list references of the radio button widget frames linked together in this selector
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **setSelected** was called or an option was clicked or cleared
	--- 		- @*param* **self** Frame ― Reference to the selector frame
	--- 		- @*param* **attribute** = "selected" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **index**? integer|nil ― The (0-based) index of the currently selected item
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, index)
	--- 				if attribute ~= "selected" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* **self** Frame ― Reference to the selector frame
	--- 		- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateAnchorSelector = function(t)
		--[ Frame Setup ]

		--Set unique parameters
		t.items = {}
		for i = 0, #anchors do
			t.items[i] = {}
			t.items[i].title = anchors[i].name
			t.items[i].tooltip = {}
		end
		t.name = t.name or "AnchorPointSelector"
		t.width = t.width or 56
		t.labels = false
		t.columns = 3

		--Create the selector frame
		local anchorSelector = wt.CreateSelector(t)

		--[ Convert Utilities ]

		--Selected index <-> AnchorPoint
		local function ToAnchor(index) return anchors[index].point end
		local function ToIndex(point)
			local index = 0
			for i = 0, #anchors do
				if anchors[i].point == point then
					index = i
					break
				end
			end
			return index
		end

		--[ Override Getters & Setters ]

		anchorSelector.getSelected = function()
			for i = 0, #anchorSelector.items do if anchorSelector.items[i]:GetChecked() then return ToAnchor(i) end end
			return nil
		end
		anchorSelector.setSelected = function(anchor, user)
			local index = nil
			if not anchor then
				--Clear the input
				for i = 0, #anchorSelector.items do anchorSelector.items[i]:SetChecked(false) end
			else
				index = type(anchor) == "string" and ToIndex(anchor) or anchor
				if index > #anchorSelector.items then index = #anchorSelector.items elseif index < 0 then index = 0 end
				for i = 0, #anchorSelector.items do anchorSelector.items[i]:SetChecked(i == index) end
			end
			--Call listeners & evoke a custom event
			if t.onSelection and user then t.onSelection(type(anchor) == "number" and ToAnchor(anchor) or anchor) end
			anchorSelector:SetAttribute("selected", index)
		end

		return anchorSelector
	end

	--[ Dropdown Menu ]

	---Create a dropdown selector frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new dropdown
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Dropdown"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the dropdown and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the dropdown | ***Default:*** true
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the dropdown displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* — ***Default:*** 160
	--- - **items** table [indexed, 0-based] — Table containing the dropdown items described within subtables
	--- 	- **[*index*]** table ― Parameters of a dropdown item
	--- 		- **title** string — Text to represent the item within the dropdown frame
	--- 		- **onSelect** function — The function to be called when the dropdown item is selected
	--- 			- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will be evoked whenever an item is selected (see below).
	--- - **selected**? integer *optional* — Index of the item to be set as selected on load | ***Default:*** 0
	--- - **onSelection** function — The function to be called when an item is selected
	--- 	- @*param* **index**? integer|nil *optional* — The index of the currently selected item
	--- 	- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected (see below).
	--- - **autoClose**? boolean *optional* — Close the dropdown menu after an item is selected by the user | ***Default:*** true
	--- - **sideButtons**? boolean *optional* — Add previous & next item buttons next to the dropdown | ***Default:*** true
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the dropdown to the options data table to save & load its value automatically to & from the specified storageTable (also set its text to the name of the currently selected value automatically on load)
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* integer ― The index of the currently selected item in the dropdown menu
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the dropdown menu
	--- 		- @*return* integer ― The index of the item to be set as selected in the dropdown menu
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** integer ― The saved value of the frame
	--- 	- **onLoad**? function *optional* — Function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget; the name of the currently selected item based on the value loaded will be set on load whether the onLoad function is specified or not)
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** integer ― The value loaded to the frame
	---@return Frame dropdown A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - **getUniqueType** function ― Returns the functional unique type of this Frame
	--- 	- @*return* "Dropdown" UniqueFrameType
	--- - **isUniqueType** function ― Checks and returns if the functional unique type of this Frame matches the string provided entirely
	--- 	- @*param* **type** UniqueFrameType|string
	--- 	- @*return* boolean
	--- - **getSelected** function ― Returns the index of the currently selected item or nil if there is no selection
	--- 	- @*return* **index**? integer|nil ― 0-based
	--- - **setSelected** function ― Set the item at the specified index as selected, or set the display name if there is no selection
	--- 	- @*param* **index**? integer | ***Default:*** nil *(no selection)*
	--- 	- @*param* **text**? string | ***Default:*** **t.items[*index*].title** *(if **index** is provided)*
	--- 	- @*param* **user**? boolean *optional* — Whether to call **t.item.onSelect** | ***Default:*** false
	--- - **setEnabled** function ― Enable or disable the dropdown widget based on the specified value
	--- 	- @*param* **state** boolean ― Enable the input if true, disable if not
	--- - **selector**? Frame|nil — A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom functions and events added
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateSelector(...)** for details.
	--- - **toggle**? [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button)|nil — A base Button object with custom functions added
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - **previous**? [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button)|nil — A base Button object with custom functions added
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - **next**? [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button)|nil — A base Button object with custom functions added
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after a dropdown item was selected
	--- 		- @*param* **self** Frame ― Reference to the dropdown frame
	--- 		- @*param* **name** = "selected" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **index**? integer|nil ― The index of the currently selected item
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			dropdown:HookScript("OnAttributeChanged", function(self, attribute, index)
	--- 				if attribute ~= "selected" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when the dropdown menu is opened or closed
	--- 		- @*param* **self** Frame ― Reference to the dropdown frame
	--- 		- @*param* **attribute** = "open" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Whether the dropdown menu is open or not
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			dropdown:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "open" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* **self** Frame ― Reference to the dropdown frame
	--- 		- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			dropdown:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateDropdown = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Drorpdown")
		local title = t.title or t.name or "Dropdown"

		--[ Frame Setup ]

		--Create the dropdown frame
		local dropdown = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		wt.SetPosition(dropdown, t.position)
		dropdown:SetSize(t.width or 160, 36)

		--Label
		local label = wt.AddTitle({
			parent = dropdown,
			title = t.label ~= false and {
				text = title,
				offset = { x = 4, },
			} or nil,
		})

		--[ Dropdown Menu ]

		--Button: Dropdown toggle
		dropdown.toggle = wt.CreateButton({
			parent = dropdown,
			name = "Toggle",
			append = t.append,
			title = t.items[t.selected or 0].title,
			position = { anchor = "BOTTOM", },
			size = { width = dropdown:GetWidth() - (t.sideButtons ~= false and 44 or 0), },
			customizable = true,
			font = "GameFontHighlightSmall",
			fontHover = "GameFontHighlightSmall",
			fontDisabled = "GameFontDisableSmall",
			events = { OnShow = function(self) self:SetAttribute("open", false) end, },
			dependencies = t.dependencies,
		})
		wt.SetBackdrop(dropdown.toggle, {
			background = {
				texture = {
					size = 5,
					insets = { left = 3, right = 3, top = 3, bottom = 3 },
				},
				color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
			},
			border = {
				texture = { width = 14, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
			}
		}, {
			OnEnter = { rule = function()
				return IsMouseButtonDown() and {
					background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
					border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
				} or (dropdown:GetAttribute("open") and {
					background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				} or {
					background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				})
			end },
			OnLeave = { rule = function()
				if dropdown:GetAttribute("open") then return {
					background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
					border = { color = { r = 0.6, g = 0.6, b = 0.6, a = 0.9 } }
				} end
				return {}, true
			end },
			OnMouseDown = { rule = function(self)
				return self:IsEnabled() and {
					background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
					border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
				} or {}
			end },
			OnMouseUp = { rule = function(_, button)
				if button ~= "LeftButton" and not dropdown:GetAttribute("open") then return {}, true end
				return {}
			end },
			OnAttributeChanged = { frame = dropdown, rule = function(_, attribute, state)
				if attribute ~= "open" then return {} end
				if dropdown.toggle:IsMouseOver() then return state and {
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				} or {
					background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				} end
				return {}, true
			end },
		})

		--Panel: Dropdown frame
		local panel = wt.CreatePanel({
			parent = dropdown,
			label = false,
			position = {
				anchor = "TOP",
				relativeTo = dropdown,
				relativePoint = "BOTTOM",
			},
			keepInBound = true,
			size = { width = dropdown:GetWidth(), height = 28 + #t.items * 16 }
		})
		panel:SetFrameStrata("DIALOG")
		panel:SetBackdropColor(0.06, 0.06, 0.06, 0.9)
		panel:SetBackdropBorderColor(0.42, 0.42, 0.42, 0.9)

		--Selector: Dropdown items
		dropdown.selector = wt.CreateSelector({
			parent = panel,
			name = name .. "Selector",
			append = false,
			label = false,
			tooltip = t.tooltip,
			position = { anchor = "CENTER", },
			width = panel:GetWidth() - 12,
			items = t.items,
			onSelection = function(index)
				--Close the menu if set
				if t.autoClose ~= false and dropdown:GetAttribute("open") then
					panel:UnregisterEvent("GLOBAL_MOUSE_UP")
					panel:Hide()
					dropdown:SetAttribute("open", false)
				end
				--Update the selected text
				if index then _G[name .. "ToggleText"]:SetText(t.items[index].title) end
			end,
		})

		--[ Side Buttons ]

		if t.sideButtons ~= false then
			--[ Previous Item ]

			--Create the button frame
			dropdown.previous = wt.CreateButton({
				parent = dropdown,
				name = "SelectPrevious",
				title = "|T" .. textures.arrowhead .. ":8:8:0:0:8:8:8:0:0:8|t",
				position = { anchor = "BOTTOMLEFT", },
				size = { width = 22 },
				customizable = true,
				font = "GameFontHighlight",
				events = {
					OnClick = function()
						local selected = dropdown.getSelected()
						dropdown.setSelected(selected and selected - 1 or 0, nil, true)
					end,
					OnEnable = function(self) _G[self:GetName() .. "Text"]:SetText("|T" .. textures.arrowhead .. ":8:8:0:0:8:8:8:0:0:8|t") end,
					OnDisable = function(self) _G[self:GetName() .. "Text"]:SetText(
						"|T" .. textures.arrowhead .. ":8:8:0:0:8:8:8:0:0:8:" .. colors.disabled.r * 255 .. ":" .. colors.disabled.g * 255 .. ":" .. colors.disabled.b * 255 .. "|t"
					) end,
				},
				dependencies = { [0] = { frame = dropdown.selector, evaluate = function(value)
					if not value then return false end
					return value > 0
				end }, }
			})

			--Backdrop
			wt.SetBackdrop(dropdown.previous, {
				background = {
					texture = {
						size = 5,
						insets = { left = 3, right = 3, top = 3, bottom = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			}, {
				OnEnter = { rule = function()
					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end },
				OnLeave = { rule = function() return {}, true end },
				OnMouseDown = { rule = function(self)
					return self:IsEnabled() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end },
				OnMouseUp = { rule = function(self)
					return self:IsEnabled() and self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end },
			})

			--[ Next Item ]

			--Create a button frame
			dropdown.next = wt.CreateButton({
				parent = dropdown,
				name = "SelectNext",
				title = "|T" .. textures.arrowhead .. ":8:8|t",
				position = { anchor = "BOTTOMRIGHT", },
				size = { width = 22 },
				customizable = true,
				font = "GameFontHighlight",
				events = {
					OnClick = function()
						local selected = dropdown.getSelected()
						dropdown.setSelected(selected and selected + 1 or 0, nil, true)
					end,
					OnEnable = function(self) _G[self:GetName() .. "Text"]:SetText("|T" .. textures.arrowhead .. ":8:8|t") end,
					OnDisable = function(self) _G[self:GetName() .. "Text"]:SetText(
						"|T" .. textures.arrowhead .. ":8:8:0:0:8:8:0:8:0:8:" .. colors.disabled.r * 255 .. ":" .. colors.disabled.g * 255 .. ":" .. colors.disabled.b * 255 .. "|t"
					) end,
				},
				dependencies = { [0] = { frame = dropdown.selector, evaluate = function(value)
					if not value then return false end
					return value < #dropdown.selector.items
				end }, }
			})

			--Backdrop
			wt.SetBackdrop(dropdown.next, {
				background = {
					texture = {
						size = 5,
						insets = { left = 3, right = 3, top = 3, bottom = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			}, {
				OnEnter = { rule = function()
					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end },
				OnLeave = { rule = function() return {}, true end },
				OnMouseDown = { rule = function(self)
					return self:IsEnabled() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end },
				OnMouseUp = { rule = function(self)
					return self:IsEnabled() and self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end },
			})
		end

		--[ Getters & Setters ]

		dropdown.getUniqueType = function() return "Dropdown" end
		dropdown.isUniqueType = function(type) return type == "Dropdown" end
		dropdown.getSelected = function() return dropdown.selector.getSelected() end
		dropdown.setSelected = function(index, text, user)
			dropdown.selector.setSelected(index, user)
			_G[dropdown.toggle:GetName() .. "Text"]:SetText(text and text or (t.items[index] or {}).title or "…")
			--Call listeners & evoke a custom event
			if t.onSelection and user then t.onSelection(index) end
			dropdown:SetAttribute("selected", index)
		end
		dropdown.setEnabled = function(state)
			dropdown.toggle.setEnabled(state)
			dropdown.selector.setEnabled(state)
			if t.sideButtons ~= false then
				dropdown.previous.setEnabled(state and wt.CheckDependencies({ [0] = { frame = dropdown.selector, evaluate = function(value)
						if not value then return false end
						return value > 0
					end }, }))
				dropdown.next.setEnabled(state and wt.CheckDependencies({ [0] = { frame = dropdown.selector, evaluate = function(value)
					if not value then return false end
					return value < #dropdown.selector.items
				end }, }))
			end
			if label then if state then label:SetFontObject("GameFontNormal") else label:SetFontObject("GameFontDisable") end end
			if not state then dropdown:SetAttribute("open", false) end
		end

		--Starting value
		dropdown.setSelected(t.selected)
		dropdown:SetAttributeNoHandler("open", false)

		--State & dependencies
		if t.disabled then dropdown.setEnabled(false) end
		if t.dependencies then wt.SetDependencies(t.dependencies, dropdown.setEnabled) end

		--[ Events & Behavior ]

		--Dropdown toggle
		panel:Hide()
		dropdown.toggle:HookScript("OnClick", function(self)
			local state = not panel:IsVisible()
			wt.SetVisibility(panel, state)
			dropdown:SetAttribute("open", state)
			if state then panel:RegisterEvent("GLOBAL_MOUSE_DOWN") end
		end)
		panel:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
		function panel:GLOBAL_MOUSE_DOWN()
			if dropdown.toggle:IsMouseOver() then return end
			panel:UnregisterEvent("GLOBAL_MOUSE_DOWN")
			panel:RegisterEvent("GLOBAL_MOUSE_UP")
		end
		function panel:GLOBAL_MOUSE_UP(button)
			if (button ~= "LeftButton" and button ~= "RightButton") or panel:IsMouseOver() then return end
			panel:UnregisterEvent("GLOBAL_MOUSE_UP")
			panel:Hide()
			dropdown:SetAttribute("open", false)
		end
		dropdown:HookScript("OnAttributeChanged", function(_, attribute, state)
			if attribute ~= "open" then return end
			if not state then PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF) end
		end)

		--Tooltip
		if t.tooltip then wt.AddTooltip({
			parent = dropdown,
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}) end

		--[ Options Data ]

		if t.optionsData then wt.AddOptionsData(dropdown, dropdown.getUniqueType(), t.optionsData) end

		return dropdown
	end

	---Create a classic dropdown frame as a child of a container frame
	--- - ***Note:*** If called on a non-classic client, ***WidgetToolbox*.CreateDropdown(...)** will be called instead, returning a custom dropdown selector frame.
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new dropdown
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Dropdown"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the dropdown and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the dropdown | ***Default:*** true
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the dropdown displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* — ***Default:*** 115
	--- - **items** table [indexed, 0-based] — Table containing the dropdown items described within subtables
	--- 	- **[*index*]** table ― Parameters of a dropdown item
	--- 		- **title** string — Text to represent the item within the dropdown frame
	--- 		- **onSelect** function — The function to be called when the dropdown item is selected
	--- 			- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will be evoked whenever an item is selected (see below).
	--- - **selected**? integer *optional* — Index of the item to be set as selected on load | ***Default:*** 0
	--- - **onSelection** function — The function to be called when an item is selected
	--- 	- @*param* **index**? integer|nil *optional* — The index of the currently selected item
	--- 	- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected (see below).
	--- - **autoClose**? boolean *optional* — Close the dropdown menu after an item is selected by the user | ***Default:*** true
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the dropdown to the options data table to save & load its value automatically to & from the specified storageTable (also set its text to the name of the currently selected value automatically on load)
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* integer ― The index of the currently selected item in the dropdown menu
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the dropdown menu
	--- 		- @*return* integer ― The index of the item to be set as selected in the dropdown menu
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** integer ― The saved value of the frame
	--- 	- **onLoad**? function *optional* — Function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget; the name of the currently selected item based on the value loaded will be set on load whether the onLoad function is specified or not)
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** integer ― The value loaded to the frame
	---@return Frame dropdown A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) (with UIDropDownMenu template) object with custom functions and events added
	--- - **getUniqueType** function ― Returns the functional unique type of this Frame
	--- 	- @*return* "Dropdown" UniqueFrameType
	--- - **isUniqueType** function ― Checks and returns if the functional unique type of this Frame matches the string provided entirely
	--- 	- @*param* **type** UniqueFrameType|string
	--- 	- @*return* boolean
	--- - **getSelected** function ― Returns the index of the currently selected item or nil if there is no selection
	--- 	- @*return* **index**? integer|nil ― 0-based
	--- - **setSelected** function ― Set the item at the specified index as selected, or set the display name if there is no selection
	--- 	- @*param* **index**? integer | ***Default:*** nil *(no selection)*
	--- 	- @*param* **text**? string | ***Default:*** **t.items[*index*].title** *(if **index** is provided)*
	--- 	- @*param* **user**? boolean *optional* — Whether to call **t.item.onSelect** | ***Default:*** false
	--- - **setEnabled** function ― Enable or disable the dropdown widget based on the specified value
	--- 	- @*param* **state** boolean ― Enable the input if true, disable if not
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after a dropdown item was selected
	--- 		- @*param* **self** Frame ― Reference to the dropdown frame
	--- 		- @*param* **name** = "selected" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **index**? integer|nil ― The index of the currently selected item
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			dropdown:HookScript("OnAttributeChanged", function(self, attribute, index)
	--- 				if attribute ~= "selected" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when the dropdown menu is opened or closed
	--- 		- @*param* **self** Frame ― Reference to the dropdown frame
	--- 		- @*param* **attribute** = "open" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Whether the dropdown menu is open or not
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			dropdown:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "open" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* **self** Frame ― Reference to the dropdown frame
	--- 		- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			dropdown:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateClassicDropdown = function(t)
		if not wt.classic then return wt.CreateDropdown(t) end
		--Create the dropdown frame
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Dropdown")
		local dropdown = CreateFrame("Frame", name, t.parent, "UIDropDownMenuTemplate")
		--Position & dimensions
		t.position.offset = t.position.offset or {}
		t.position.offset.y = (t.position.offset.y or 0) + (t.title ~= false and -16 or 0)
		wt.SetPosition(dropdown, t.position)
		UIDropDownMenu_SetWidth(dropdown, t.width or 115)
		--Initialize
		UIDropDownMenu_Initialize(dropdown, function()
			for i = 0, #t.items do
				local info = UIDropDownMenu_CreateInfo()
				info.text = t.items[i].title
				info.value = i
				info.func = function(self)
					t.items[i].onSelect()
					UIDropDownMenu_SetSelectedValue(dropdown, self.value)
					--Evoke a custom event
					dropdown:SetAttribute("selected", self.value)
				end
				UIDropDownMenu_AddButton(info)
			end
		end)
		--Label
		local title = t.title or t.name or "Dropdown"
		local label = wt.AddTitle({
			parent = dropdown,
			title = t.label ~= false and {
				text = title,
				offset = { x = 22, y = 16 },
			} or nil,
		})
		--Tooltip
		if t.tooltip then wt.AddTooltip({
			parent = dropdown,
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}) end
		--Getters & setters
		dropdown.getUniqueType = function() return "Dropdown" end
		dropdown.isUniqueType = function(type) return type == "Dropdown" end
		dropdown.getSelected = function() return UIDropDownMenu_GetSelectedValue(dropdown) end
		dropdown.setSelected = function(index, text, user)
			UIDropDownMenu_SetSelectedValue(dropdown, index)
			UIDropDownMenu_SetText(dropdown, (t.items[index] or {}).title or text)
			--Call listeners & evoke a custom event
			if t.onSelection and user then t.onSelection(index) end
			dropdown:SetAttribute("selected", index)
		end
		dropdown.setEnabled = function(state)
			if state then
				UIDropDownMenu_EnableDropDown(dropdown)
				if label then label:SetFontObject("GameFontNormal") end
			else
				UIDropDownMenu_DisableDropDown(dropdown)
				if label then label:SetFontObject("GameFontDisable") end
			end
		end
		--Starting value
		dropdown.setSelected(t.selected or 0)
		dropdown:SetAttributeNoHandler("open", false)
		--State & dependencies
		if t.disabled then dropdown.setEnabled(false) end
		if t.dependencies then wt.SetDependencies(t.dependencies, dropdown.setEnabled) end
		--Options data
		if t.optionsData then wt.AddOptionsData(dropdown, dropdown.getUniqueType(), t.optionsData) end
		return dropdown
	end

	--[ EditBox ]

	---Set the parameters of an editbox frame
	---@param editBox EditBox Parent frame of [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) type
	---@param t table Parameters are to be provided in this table
	--- - **label**? FontString *optional* — The title [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) above the editbox | ***Default:*** nil *(no title)*
	--- - **multiline** boolean — Set to true if the editbox should be support multiple lines for the string input
	--- - **insets**? table *optional* — Table containing padding values by which to offset the position of the text in the editbox
	--- 	- **left**? number *optional* — ***Default:*** 0
	--- 	- **right**? number *optional* — ***Default:*** 0
	--- 	- **top**? number *optional* — ***Default:*** 0
	--- 	- **bottom**? number *optional* — ***Default:*** 0
	--- - **font**? FontObject *optional* — Use this [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object | ***Default:*** *default font based on the frame template*
	--- - **fontDisable**? FontObject *optional* — Use this [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object when the editbox is disabled | ***Default:*** *default font based on the frame template*
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) | ***Default:*** 0 (*no limit*)
	--- - **justify**? string *optional* — Set the justification of the [FontInstance](https://wowpedia.fandom.com/wiki/UIOBJECT_FontInstance)
	--- 	- **horizontal**? string *optional* — "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- 	- **vertical**? string *optional* — "TOP"|"BOTTOM"|"MIDDLE" | ***Default:*** "MIDDLE"
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true | ***Default:*** false
	--- - **events**? table *optional* — Table of key, value pairs that holds event handler scripts to be set for the editbox
	--- 	- **[*key*]** string — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- 		- ***Note:*** "[OnChar](https://wowpedia.fandom.com/wiki/UIHANDLER_OnChar)" will be called with custom parameters:
	--- 			- @*param* **self** Frame ― Reference to the editbox frame
	--- 			- @*param* **char** string ― The UTF-8 character that was typed
	--- 			- @*param* **text** string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnTextChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnTextChanged)" will be called with custom parameters:
	--- 			- @*param* **self** Frame ― Reference to the editbox frame
	--- 			- @*param* **user** string ― True if the value was changed by the user, false if it was done programmatically
	--- 			- @*param* **text** string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed)" will be called with custom parameters:
	--- 			- @*param* **self** Frame ― Reference to the editbox frame
	--- 			- @*param* **text** string ― The text typed into the editbox
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the editbox to the options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* string ― The current value of the editbox
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the editbox
	--- 		- @*return* string ― The value to be set to the editbox
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** string ― The saved value of the frame
	--- 	- **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** string ― The value loaded to the frame
	---@return EditBox editBox A base EditBox object with custom functions and event added
	--- - **setText** function ― An overloaded [EditBox:SetText(string)](https://wowpedia.fandom.com/wiki/API_EditBox_SetText) with custom functionality
	--- 	- @*param* **text** string ― Text to call the built-in [EditBox:SetText(**text**)](https://wowpedia.fandom.com/wiki/API_EditBox_SetText) with
	--- 	- @*param* **resetCursor** boolean ― If true, set the cursor position to the beginning of the string after setting the text | ***Default:*** true
	--- - **setEnabled** function — Enable or disable the editbox widget based on the specified value
	--- 	- @*param* **state** boolean — Enable the input if true, disable if not
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* **self** Frame ― Reference to the editbox frame
	--- 		- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			editbox:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	local function SetEditBox(editBox, t)
		--[ Font & Text ]

		editBox:SetMultiLine(t.multiline)
		editBox:SetTextInsets((t.insets or {}).left or 0, (t.insets or {}).right or 0, (t.insets or {}).top or 0, (t.insets or {}).bottom or 0)
		if t.font then editBox:SetFontObject(t.font) end
		if t.justify then
			if t.justify.horizontal then editBox:SetJustifyH(t.justify.horizontal) end
			if t.justify.vertical then editBox:SetJustifyV(t.justify.vertical) end
		end
		if t.maxLetters then editBox:SetMaxLetters(t.maxLetters) end

		--[ Events & Behavior ]

		--Register event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "OnChar" then editBox:SetScript("OnChar", function(self, char) value(self, char, self:GetText()) end)
			elseif key == "OnTextChanged" then editBox:SetScript("OnTextChanged", function(self, user) value(self, user, self:GetText()) end)
			elseif key == "OnEnterPressed" then editBox:SetScript("OnEnterPressed", function(self) value(self, self:GetText()) end)
			else editBox:HookScript(key, value) end
		end end

		--Custom behavior
		editBox:SetAutoFocus(false)
		editBox:HookScript("OnEnterPressed", function(self)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			self:ClearFocus()
		end)
		editBox:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)

		--[ Getters & Setters ]

		editBox.setText = function(text, resetCursor)
			editBox:SetText(text)
			if resetCursor ~= false then editBox:SetCursorPosition(0) end
		end
		editBox.setEnabled = function(state)
			editBox:SetEnabled(state)
			if state then if t.font then editBox:SetFontObject(t.font) end elseif t.fontDisabled then editBox:SetFontObject(t.fontDisabled) end
			if t.label then t.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
		end

		--Starting value
		if t.text then editBox.setText(t.color and wt.Color(t.text, t.color) or t.text) end

		--State & dependencies
		if t.readOnly then editBox:Disable() end
		if t.disabled then editBox.setEnabled(false) end
		if t.dependencies then wt.SetDependencies(t.dependencies, editBox.setEnabled) end

		--[ Options Data ]

		if t.optionsData then wt.AddOptionsData(editBox, editBox:GetObjectType(), t.optionsData) end
	end

	---Create an editbox frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the editbox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "EditBox"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the editbox and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the editbox | ***Default:*** true
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the editbox displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size** table
	--- 	- **width**? number *optional* — ***Default:*** 180
	--- 	- **height**? number *optional* — ***Default:*** 17
	--- - **insets**? table *optional* — Padding values by which to offset the position of the text in the editbox inward
	--- 	- **left**? number *optional* — ***Default:*** 0
	--- 	- **right**? number *optional* — ***Default:*** 0
	--- 	- **top**? number *optional* — ***Default:*** 0
	--- 	- **bottom**? number *optional* — ***Default:*** 0
	--- - **customizable**? boolean *optional* ― Create the editbox with `BackdropTemplateMixin and "BackdropTemplate"` to be easily customizable | ***Default:*** false
	--- 	- ***Note:*** You may use ***WidgetToolbox*.SetBackdrop(...)** to set up the frame quickly.
	--- - **font**? FontObject *optional* — Use this [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object | ***Default:*** "GameFontNormal" if **t.customizable** is true
	--- - **fontDisabled**? FontObject — Use this [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object for the label when the button is disabled | ***Default:*** "GameFontDisabled" if **t.customizable** is true
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) | ***Default:*** 0 (*no limit*)
	--- - **justify**? string *optional* — Set the justification of the [FontInstance](https://wowpedia.fandom.com/wiki/UIOBJECT_FontInstance)
	--- 	- **horizontal**? string *optional* — "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- 	- **vertical**? string *optional* — "TOP"|"BOTTOM"|"MIDDLE" | ***Default:*** "MIDDLE"
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true | ***Default:*** false
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **events**? table *optional* — Table of key, value pairs that holds event handler scripts to be set for the editbox
	--- 	- **[*key*]** string — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- 		- ***Note:*** "[OnChar](https://wowpedia.fandom.com/wiki/UIHANDLER_OnChar)" will be called with custom parameters:
	--- 			- @*param* **self** Frame ― Reference to the editbox frame
	--- 			- @*param* **char** string ― The UTF-8 character that was typed
	--- 			- @*param* **text** string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnTextChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnTextChanged)" will be called with custom parameters:
	--- 			- @*param* **self** Frame ― Reference to the editbox frame
	--- 			- @*param* **user** string ― True if the value was changed by the user, false if it was done programmatically
	--- 			- @*param* **text** string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed)" will be called with custom parameters:
	--- 			- @*param* **self** Frame ― Reference to the editbox frame
	--- 			- @*param* **text** string ― The text typed into the editbox
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the editbox to the options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* string ― The current value of the editbox
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the editbox
	--- 		- @*return* string ― The value to be set to the editbox
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** string ― The saved value of the frame
	--- 	- **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** string ― The value loaded to the frame
	---@return EditBox editBox A base EditBox object with custom functions and events added
	--- - **setText** function ― An overloaded [EditBox:SetText(string)](https://wowpedia.fandom.com/wiki/API_EditBox_SetText) with custom functionality
	--- 	- @*param* **text** string ― Text to call the built-in [EditBox:SetText(**text**)](https://wowpedia.fandom.com/wiki/API_EditBox_SetText) with
	--- 	- @*param* **resetCursor** boolean ― If true, set the cursor position to the beginning of the string after setting the text | ***Default:*** true
	--- - **setEnabled** function — Enable or disable the editbox widget based on the specified value
	--- 	- @*param* **state** boolean — Enable the input if true, disable if not
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* **self** Frame ― Reference to the editbox frame
	--- 		- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			editbox:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateEditBox = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "EditBox")
		local title = t.title or t.name or "EditBox"
		local custom = t.customizable and (BackdropTemplateMixin and "BackdropTemplate") or nil

		--[ Frame Setup ]

		--Create the editbox frame
		local editBox = CreateFrame("EditBox", name, t.parent, custom or "InputBoxTemplate")

		--Position & dimensions
		t.position.offset = t.position.offset or {}
		t.position.offset.y = (t.position.offset.y or 0) + (t.label ~= false and -18 or 0)
		wt.SetPosition(editBox, t.position)
		editBox:SetSize((t.size or {}).width or 180, (t.size or {}).height or 17)

		--Label
		local label = wt.AddTitle({
			parent = editBox,
			title = t.label ~= false and {
				text = title,
				offset = { x = -1, y = 18 },
			} or nil,
		})

		--[ EditBox Setup ]

		SetEditBox(editBox, {
			label = label,
			multiline = false,
			insets = t.insets,
			font = t.font,
			fontDisabled = t.fontDisabled,
			color = t.color,
			maxLetters = t.maxLetters,
			justify = t.justify,
			text = t.text,
			readOnly = t.readOnly,
			events = t.events,
			disabled = t.disabled,
			dependencies = t.dependencies,
			optionsData = t.optionsData
		})

		--[ Events & Behavior ]

		--Custom behavior
		if custom then
			editBox:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
			editBox:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)
		end

		--Tooltip
		if t.tooltip then wt.AddTooltip({
			parent = editBox,
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}) end

		return editBox
	end

	---Create a scrollable editbox as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the editbox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "EditBox"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the editbox and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the editbox | ***Default:*** true
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the editbox displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size** table
	--- 	- **width** number
	--- 	- **height**? number *optional* — ***Default:*** 17
	--- - **insets**? table *optional* — Table containing padding values by which to offset the position of the text in the editbox
	--- 	- **left**? number *optional* — ***Default:*** 0
	--- 	- **right**? number *optional* — ***Default:*** 0
	--- 	- **top**? number *optional* — ***Default:*** 0
	--- 	- **bottom**? number *optional* — ***Default:*** 0
	--- - **font**? FontObject *optional* — [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to use | ***Default:*** "ChatFontNormal"
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	--- - **maxLetters**? integer *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) | ***Default:*** 0 (*no limit*)
	--- - **charCount**? boolean *optional* — Show or hide the remaining number of characters | ***Default:*** (**t.maxLetters** or 0) > 0
	--- - **justify**? string *optional* — Set the justification of the [FontInstance](https://wowpedia.fandom.com/wiki/UIOBJECT_FontInstance)
	--- 	- **horizontal**? string *optional* — "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- 	- **vertical**? string *optional* — "TOP"|"BOTTOM"|"MIDDLE" | ***Default:*** "MIDDLE"
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true | ***Default:*** false
	--- - **scrollSpeed**? number *optional* — Scroll step value | ***Default:*** *half of the height of the scroll bar*
	--- - **scrollToTop**? boolean *optional* — Automatically scroll to the top when the text is loaded or changed while not being actively edited | ***Default:*** true
	--- - **events**? table *optional* — Table of key, value pairs that holds event handler scripts to be set for the editbox child frame
	--- 	- **[*key*]** string — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- 		- ***Note:*** "[OnChar](https://wowpedia.fandom.com/wiki/UIHANDLER_OnChar)" will be called with custom parameters:
	--- 			- @*param* **self** Frame ― Reference to the editbox frame
	--- 			- @*param* **char** string ― The UTF-8 character that was typed
	--- 			- @*param* **text** string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnTextChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnTextChanged)" will be called with custom parameters:
	--- 			- @*param* **self** Frame ― Reference to the editbox frame
	--- 			- @*param* **user** string ― True if the value was changed by the user, false if it was done programmatically
	--- 			- @*param* **text** string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed)" will be called with custom parameters:
	--- 			- @*param* **self** Frame ― Reference to the editbox frame
	--- 			- @*param* **text** string ― The text typed into the editbox
	--- - **scrollEvents**? table *optional* — Table of key, value pairs that holds event handler scripts to be set for the scroll frame
	--- 	- **[*key*]** string — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [ScrollFrame](https://wowpedia.fandom.com/wiki/UIOBJECT_ScrollFrame#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the editbox to the options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* string ― The current value of the editbox
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the editbox
	--- 		- @*return* string ― The value to be set to the editbox
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** string ― The saved value of the frame
	--- 	- **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** string ― The value loaded to the frame
	---@return EditBox scrollFrame.EditBox A base editbox object with custom functions and events added
	--- - **setText** function ― An overloaded [EditBox:SetText(string)](https://wowpedia.fandom.com/wiki/API_EditBox_SetText) with custom functionality
	--- 	- @*param* **text** string ― Text to call the built-in [EditBox:SetText(**text**)](https://wowpedia.fandom.com/wiki/API_EditBox_SetText) with
	--- 	- @*param* **resetCursor** boolean ― If true, set the cursor position to the beginning of the string after setting the text | ***Default:*** true
	--- - **setEnabled** function — Enable or disable the editbox widget based on the specified value
	--- 	- @*param* **state** boolean — Enable the input if true, disable if not
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* **self** Frame ― Reference to the editbox frame
	--- 		- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			editbox:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	---@return Frame scrollFrame A base ScrollFrame (with InputScrollFrameTemplate) object
	wt.CreateEditScrollBox = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "EditBox")
		local title = t.title or t.name or "EditBox"

		--[ Frame Setup ]

		--Create the edit scroll frame
		local scrollFrame = CreateFrame("ScrollFrame", name, t.parent, wt.classic and "InputScrollFrameTemplate" or "WidgetToolsInputScrollFrameTemplate") --BUG: Revert to using the default template when SetMaxLetters gets fixed

		--Position & dimensions
		t.position.offset = t.position.offset or {}
		t.position.offset.y = (t.position.offset.y or 0) - 20
		wt.SetPosition(scrollFrame, t.position)
		scrollFrame:SetSize(t.size.width, t.size.height)

		--Scroll speed
		if t.scrollSpeed then _G[name .. "ScrollBar"].scrollStep = t.scrollSpeed end

		--Character counter
		scrollFrame.CharCount:SetFontObject("GameFontDisableTiny2")
		if t.charCount == false or (t.maxLetters or 0) == 0 then scrollFrame.CharCount:Hide() end

		--Label
		local label = wt.AddTitle({
			parent = scrollFrame,
			title = t.label ~= false and {
				text = title,
				offset = { x = -1, y = 18 },
			} or nil,
		})

		--[ EditBox Setup ]

		SetEditBox(scrollFrame.EditBox, {
			label = label,
			multiline = true,
			insets = t.insets,
			font = t.font or "ChatFontNormal",
			fontDisabled = t.fontDisabled,
			color = t.color,
			maxLetters = t.maxLetters,
			justify = t.justify,
			text = t.text,
			readOnly = t.readOnly,
			events = t.events,
			disabled = t.disabled,
			dependencies = t.dependencies,
			optionsData = t.optionsData
		})
		if not wt.classic then scrollFrame.EditBox.cursorOffset = 0 end --FIXME: Remove when the character counter gets fixed

		--[ Size Update Utility ]

		local function resizeEditBox()
			local scrollBarOffset = _G[name.."ScrollBar"]:IsShown() and 16 or 0
			local counterOffset = t.charCount ~= false and (t.maxLetters or 0) > 0 and tostring(t.maxLetters - scrollFrame.EditBox:GetText():len()):len() * 6 + 3 or 0
			scrollFrame.EditBox:SetWidth(scrollFrame:GetWidth() - scrollBarOffset - counterOffset)
			--Update the character counter
			if scrollFrame.CharCount:IsVisible() and t.maxLetters then --FIXME: Remove when the character counter gets fixed
				scrollFrame.CharCount:SetWidth(counterOffset)
				scrollFrame.CharCount:SetText(t.maxLetters - scrollFrame.EditBox:GetText():len())
				scrollFrame.CharCount:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", -scrollBarOffset + 1, 0)
			end
		end
		resizeEditBox()

		--[ Events & Behavior ]

		--Custom behavior
		t.scrollToTop = t.scrollToTop ~= false or nil
		scrollFrame.EditBox:HookScript("OnTextChanged", function()
			resizeEditBox()
			if t.scrollToTop then scrollFrame:SetVerticalScroll(0) end
		end)
		scrollFrame.EditBox:HookScript("OnEditFocusGained", function(self)
			resizeEditBox()
			if t.scrollToTop ~= nil then t.scrollToTop = false end
			self:HighlightText()
		end)
		scrollFrame.EditBox:HookScript("OnEditFocusLost", function(self)
			if t.scrollToTop ~= nil then t.scrollToTop = true end
			self:ClearHighlightText()
		end)

		--Tooltip
		if t.tooltip then wt.AddTooltip({
			parent = scrollFrame,
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
			triggers = { scrollFrame.EditBox },
		}) end

		return scrollFrame.EditBox, scrollFrame
	end

	--[ CopyBox]

	---Create a clickable textline and an editbox from which the contents of the text can be copied
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the copybox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "CopyBox"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the copybox | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the copybox | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size** table
	--- 	- **width**? number *optional* — ***Default:*** 180
	--- 	- **height**? number *optional* — ***Default:*** 17
	--- - **text** string ― The copyable text to be shown
	--- - **layer**? Layer *optional* ― Draw [Layer](https://wowpedia.fandom.com/wiki/Layer)
	--- - **template**? string *optional* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormal"
	--- - **color**? table *optional* — Apply the specified color to the text
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	--- - **justify**? string *optional* — Set the justification of the [FontInstance](https://wowpedia.fandom.com/wiki/UIOBJECT_FontInstance)
	--- 	- **horizontal**? string *optional* — "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- 	- **vertical**? string *optional* — "TOP"|"BOTTOM"|"MIDDLE" | ***Default:*** "MIDDLE"
	--- - **flipOnMouse**? boolean *optional* — Hide/Reveal the editbox on mouseover instead of after a click | ***Default:*** false
	--- - **colorOnMouse**? table *optional* — If set, change the color of the text on mouseover to the specified color (if **t.flipOnMouse** is false) | ***Default:*** *no color change*
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	---@return Button copyBox textLine A base Button object with custom values & functions added
	--- - **editBox**? [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) — A base EditBox object with custom functions added
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateEditBox(...)** for details.
	--- - **textLine**? [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString)
	wt.CreateCopyBox = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "CopyBox")

		--[ Frame Setup ]

		--Create the copybox frame
		local copyBox = CreateFrame("Button", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent)

		--Position & dimensions
		t.position.offset = t.position.offset or {}
		t.position.offset.y = (t.position.offset.y or 0) + (t.label ~= false and -12 or 0)
		wt.SetPosition(copyBox, t.position)
		copyBox:SetSize((t.size or {}).width or 180, (t.size or {}).height or 17)

		--Label
		wt.AddTitle({
			parent = copyBox,
			title = t.label ~= false and {
				text = t.title or t.name or "CopyBox",
				offset = { x = -1, y = 12 },
				width = (t.size or {}).width or 180,
			} or nil,
		})

		--[ Displayed Textline ]

		copyBox.textLine = wt.CreateText({
			parent = copyBox,
			name = "DisplayText",
			position = { anchor = "LEFT", },
			width = (t.size or {}).width or 180,
			text = t.text,
			layer = t.layer,
			template = t.template,
			color = t.color,
			justify = t.justify or "LEFT",
			wrap = false
		})

		--[ Copyable Textline ]

		copyBox.editBox = wt.CreateEditBox({
			parent = copyBox,
			name = "CopyText",
			title = strings.copy.editbox.label,
			label = false,
			tooltip = { lines = { [0] = { text = strings.copy.editbox.tooltip, }, } },
			position = { anchor = "LEFT", },
			size = t.size,
			font = copyBox.textLine:GetFontObject(),
			color = t.colorOnMouse or t.color,
			justify = t.justify,
			text = t.text,
			events = {
				OnTextChanged = function(self, user)
					if not user then return end
					self:SetText((t.colorOnMouse or t.color) and wt.Color(t.text, t.colorOnMouse or t.color) or t.text)
					self:HighlightText()
				end,
				[t.flipOnMouse and "OnLeave" or "OnEditFocusLost"] = function(self)
					self:Hide()
					copyBox.textLine:Show()
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
				end,
			},
		})

		--[ Events & Behavior ]

		--Toggle
		copyBox.editBox:Hide()
		copyBox:SetScript(t.flipOnMouse and "OnEnter" or "OnClick", function()
			copyBox.textLine:Hide()
			copyBox.editBox:Show()
			copyBox.editBox:SetFocus()
			copyBox.editBox:HighlightText()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end)
		if not t.flipOnMouse and t.colorOnMouse then
			copyBox:SetScript("OnEnter", function() copyBox.textLine:SetTextColor(wt.UnpackColor(t.colorOnMouse)) end)
			copyBox:SetScript("OnLeave", function() copyBox.textLine:SetTextColor(wt.UnpackColor(t.color)) end)
		end

		--Tooltip
		wt.AddTooltip({
			parent = copyBox,
			title = strings.copy.textline.label,
			lines = { [0] = { text = strings.copy.textline.tooltip, }, },
			anchor = "ANCHOR_RIGHT",
		})

		return copyBox
	end

	--[ Slider ]

	---Create a new slider frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new slider
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Slider"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the slider and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the slider | ***Default:*** true
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the slider displayed when mousing over the frame
	--- 	- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 	- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 		- **[*index*]** table ― Parameters of an additional line of text
	--- 			- **text** string ― Text to be displayed in the line
	--- 			- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 			- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* — ***Default:*** 160
	--- - **value** table
	--- 	- **min** number — Lower numeric value limit
	--- 	- **max** number — Upper numeric value limit
	--- 	- **step**? number *optional* — Size of value increments | ***Default:*** *the value can be freely changed (within range, no set increments)*
	--- 	- **fractional**? integer *optional* — If the value is fractional, allow and display this many decimal digits | ***Default:*** *the most amount of digits present in the fractional part of* **t.value.min**, **t.value.max** *or* **t.value.step**
	--- - **valueBox**? boolean *optional* — Whether or not should the slider have an [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) as a child to manually enter a precise value to move the slider to | ***Default:*** true
	--- - **sideButtons**? boolean *optional* — Whether or not to add increase/decrease buttons next to the slider to change the value by the increment set in **value.step** or by 10% of the difference of **value.min** & **value.max** | ***Default:*** true
	--- - **events**? table *optional* — Table of key, value pairs that holds event handler scripts to be set for the slider
	--- 	- **[*key*]** string — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [Slider](https://wowpedia.fandom.com/wiki/Widget_script_handlers#Slider)
	--- 		- ***Example:*** "[OnValueChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnValueChanged)" whenever the value in the slider widget is modified.
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the slider to the options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* number ― The current value of the slider
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the slider
	--- 		- @*return* number ― The value to be set to the slider
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** number ― The saved value of the frame
	--- 	- **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** number ― The value loaded to the frame
	---@return Frame sliderFrame A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - **setEnabled** function — Enable or disable the slider widget based on the specified value
	--- 	- @*param* **state** boolean — Enable the input if true, disable if not
	--- - **slider** [Slider](https://wowpedia.fandom.com/wiki/UIOBJECT_Slider) ― A base Slider object
	--- - **valueBox**? [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox)|nil — A base EditBox object with custom functions added
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateEditBox(...)** for details.
	--- - **decrease**? [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button)|nil — A base Button object with custom functions added
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - **increase**? [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button)|nil — A base Button object with custom functions added
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* **self** Frame ― Reference to the slider frame
	--- 		- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			slider:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateSlider = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Slider")
		local title = t.title or t.name or "Slider"

		--[ Frame Setup ]

		--Create the parent frame
		local sliderFrame = CreateFrame("Frame", name, t.parent)

		--Create the slider frame
		sliderFrame.slider = CreateFrame("Slider", name .. "Slider", sliderFrame, "OptionsSliderTemplate")

		--Position & dimensions
		wt.SetPosition(sliderFrame, t.position)
		sliderFrame:SetSize(t.width or 160, t.valueBox ~= false and 48 or 31)
		sliderFrame.slider:SetPoint("TOP", sliderFrame, "TOP", 0, -15)
		sliderFrame.slider:SetWidth(sliderFrame:GetWidth() - (t.sideButtons ~= false and 40 or 0))

		--Set min/max value labels
		_G[name .. "SliderLow"]:SetText(tostring(t.value.min))
		_G[name .. "SliderHigh"]:SetText(tostring(t.value.max))
		_G[name .. "SliderLow"]:SetPoint("TOPLEFT", sliderFrame.slider, "BOTTOMLEFT")
		_G[name .. "SliderHigh"]:SetPoint("TOPRIGHT", sliderFrame.slider, "BOTTOMRIGHT")

		--Set slider values
		sliderFrame.slider:SetMinMaxValues(t.value.min, t.value.max)
		if t.value.step then
			sliderFrame.slider:SetValueStep(t.value.step)
			sliderFrame.slider:SetObeyStepOnDrag(true)
		end

		--Label
		local label = nil
		if t.label ~= false then
			label = _G[sliderFrame.slider:GetName() .. "Text"]
			label:SetFontObject("GameFontNormal")
			label:SetText(title)
			label:SetPoint("TOP", sliderFrame, "TOP", 0, 2)
		else _G[name .. "Text"]:Hide() end

		--[ Events & Behavior ]

		--Register event handlers
		if t.events then for key, value in pairs(t.events) do sliderFrame.slider:HookScript(key, value) end end

		--Custom behavior
		sliderFrame.slider:HookScript("OnMouseUp", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)

		--Tooltip
		if t.tooltip then wt.AddTooltip({
			parent = sliderFrame.slider,
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}) end

		--[ Value Box ]

		if t.valueBox ~= false then
			--Calculate the required number of fractal digits, assemble string patterns for value validation
			local decimals = t.value.fractional or max(
				tostring(t.value.min):gsub("-?[%d]+[%.]?([%d]*).*", "%1"):len(),
				tostring(t.value.max):gsub("-?[%d]+[%.]?([%d]*).*", "%1"):len(),
				tostring(t.value.step or 0):gsub("-?[%d]+[%.]?([%d]*).*", "%1"):len()
			)
			local decimalPattern = ""
			for i = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end
			local matchPattern = "(" .. (t.value.min < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
			local replacePattern = "%1" .. (decimals > 0 and "%2" or "")

			--Create the editbox frame
			sliderFrame.valueBox = wt.CreateEditBox({
				parent = sliderFrame.slider,
				name = "ValueBox",
				label = false,
				tooltip = {
					title = strings.slider.value.label,
					lines = { [0] = { text = strings.slider.value.tooltip, }, }
				},
				position = {
					anchor = "TOP",
					relativeTo = sliderFrame.slider,
					relativePoint = "BOTTOM",
				},
				size = { width = 64, },
				customizable = true,
				font = "GameFontHighlightSmall",
				fontDisabled = "GameFontDisableSmall",
				maxLetters = tostring(math.floor(t.value.max)):len() + (decimals + (decimals > 0 and 1 or 0)) + (t.value.min < 0 and 1 or 0),
				justify = { horizontal = "CENTER", },
				text = tostring(wt.Round(sliderFrame.slider:GetValue(), decimals)):gsub(matchPattern, replacePattern),
				events = {
					OnChar = function(self, _, text) self:SetText(text:gsub(matchPattern, replacePattern)) end,
					OnEnterPressed = function(self)
						local v = self:GetNumber()
						if t.value.step then v = max(t.value.min, min(t.value.max, floor(v * (1 / t.value.step) + 0.5) / (1 / t.value.step))) end
						self.setText(tostring(wt.Round(v, decimals)):gsub(matchPattern, replacePattern))
						sliderFrame.slider:SetValue(v)
						if (t.events or {}).OnValueChanged then t.events.OnValueChanged(sliderFrame.slider, sliderFrame.slider:GetValue(), true) end
					end,
					OnEscapePressed = function(self) self.setText(tostring(wt.Round(sliderFrame.slider:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
				},
			})

			--Backdrop
			wt.SetBackdrop(sliderFrame.valueBox, {
				background = {
					texture = {
						size = 5,
						insets = { left = 3, right = 3, top = 3, bottom = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 }
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
				}
			}, {
				OnEnter = { rule = function(self) return self:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end },
				OnLeave = {},
			})

			--Add slider listener
			sliderFrame.slider:HookScript("OnValueChanged", function(_, v) sliderFrame.valueBox.setText(tostring(wt.Round(v, decimals)):gsub(matchPattern, replacePattern)) end)
		end

		--[ Side Buttons ]

		if t.sideButtons ~= false then
			local step = t.value.step or ((t.value.max - t.value.min) / 10)

			--[ Decrease Value ]

			--Create button frame
			sliderFrame.decrease = wt.CreateButton({
				parent = sliderFrame.slider,
				name = "SelectPrevious",
				title = "-",
				tooltip = {
					title = strings.slider.decrease.label,
					lines = { [0] = { text = strings.slider.decrease.tooltip:gsub("#VALUE", step), }, }
				},
				position = {
					anchor = "LEFT",
					offset = { x = -21, }
				},
				size = { width = 20, height = 20 },
				customizable = true,
				font = "GameFontHighlight",
				events = { OnClick = function()
					sliderFrame.slider:SetValue(sliderFrame.slider:GetValue() - step)
					if (t.events or {}).OnValueChanged then t.events.OnValueChanged(sliderFrame.slider, sliderFrame.slider:GetValue(), true) end
				end, },
				dependencies = { [0] = { frame = sliderFrame.slider, evaluate = function(value) return value > t.value.min end }, }
			})

			--Backdrop
			wt.SetBackdrop(sliderFrame.decrease, {
				background = {
					texture = {
						size = 5,
						insets = { left = 3, right = 3, top = 3, bottom = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			}, {
				OnEnter = { rule = function()
					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end },
				OnLeave = { rule = function() return {}, true end },
				OnMouseDown = { rule = function(self)
					return self:IsEnabled() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end },
				OnMouseUp = { rule = function(self)
					return self:IsEnabled() and self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end },
			})

			--Texture: Arrow
			-- wt.CreateTexture({
			-- 	parent = sliderFrame.decrease,
			-- 	name = "Arrow",
			-- 	position = {
			-- 		anchor = t.leftSide or t.justify == "RIGHT" and "LEFT" or "RIGHT",
			-- 		offset = { x = t.leftSide or t.justify == "RIGHT" and 2 or -2, }
			-- 	},
			-- 	size = { width = 8, height = 8 },
			-- 	path = textures.arrowhead,
			-- 	flip = { horizontal = t.leftSide or t.justify == "RIGHT" },
			-- 	color = colors.white
			-- })

			--[ Increase Value ]

			--Create the button frame
			sliderFrame.increase = wt.CreateButton({
				parent = sliderFrame.slider,
				name = "SelectNext",
				title = "+",
				tooltip = {
					title = strings.slider.increase.label,
					lines = { [0] = { text = strings.slider.increase.tooltip:gsub("#VALUE", step), }, }
				},
				position = {
					anchor = "RIGHT",
					offset = { x = 21, }
				},
				size = { width = 20, height = 20 },
				customizable = true,
				font = "GameFontHighlight",
				events = { OnClick = function()
					sliderFrame.slider:SetValue(sliderFrame.slider:GetValue() + step)
					if (t.events or {}).OnValueChanged then t.events.OnValueChanged(sliderFrame.slider, sliderFrame.slider:GetValue(), true) end
				end, },
				dependencies = { [0] = { frame = sliderFrame.slider, evaluate = function(value) return value < t.value.max end }, }
			})

			--Backdrop
			wt.SetBackdrop(sliderFrame.increase, {
				background = {
					texture = {
						size = 5,
						insets = { left = 3, right = 3, top = 3, bottom = 3 },
					},
					color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
				},
				border = {
					texture = { width = 12, },
					color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
				}
			}, {
				OnEnter = { rule = function()
					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					}
				end },
				OnLeave = { rule = function() return {}, true end },
				OnMouseDown = { rule = function(self)
					return self:IsEnabled() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or {}
				end },
				OnMouseUp = { rule = function(self)
					return self:IsEnabled() and self:IsMouseOver() and {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {}
				end },
			})

			--Texture: Arrow
			-- wt.CreateTexture({
			-- 	parent = sliderFrame.decrease,
			-- 	name = "Arrow",
			-- 	position = {
			-- 		anchor = t.leftSide or t.justify == "RIGHT" and "LEFT" or "RIGHT",
			-- 		offset = { x = t.leftSide or t.justify == "RIGHT" and 2 or -2, }
			-- 	},
			-- 	size = { width = 8, height = 8 },
			-- 	path = textures.arrowhead,
			-- 	flip = { horizontal = t.leftSide or t.justify == "RIGHT" },
			-- 	color = colors.white
			-- })
		end

		--[ Getters & Setters ]

		sliderFrame.setEnabled = function(state)
			sliderFrame.slider:SetEnabled(state)
			if t.valueBox ~= false then sliderFrame.valueBox.setEnabled(state) end
			if t.sideButtons ~= false then
				sliderFrame.decrease.setEnabled(state and wt.CheckDependencies({ [0] = { frame = sliderFrame.slider, evaluate = function(value) return value > t.value.min end }, }))
				sliderFrame.increase.setEnabled(state and wt.CheckDependencies({ [0] = { frame = sliderFrame.slider, evaluate = function(value) return value < t.value.max end }, }))
			end
			if label then label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
		end

		--State & dependencies
		if t.disabled then sliderFrame.setEnabled(false) end
		if t.dependencies then wt.SetDependencies(t.dependencies, sliderFrame.setEnabled) end

		--[ Options Data ]

		if t.optionsData then wt.AddOptionsData(sliderFrame.slider, sliderFrame.slider:GetObjectType(), t.optionsData) end

		return sliderFrame
	end

	--[ Color Picker ]

	---Create a custom color picker frame with HEX(A) input while utilizing the Blizzard ColorPickerFrame opened with a button
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new color picker button
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "ColorPicker"
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the color picker frame | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the color picker frame | ***Default:*** true
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* ― The height is defaulted to 36, the width may be specified | ***Default:*** 120
	--- - **setColors** function — The function to be called to set the colors of the color picker on load or update
	--- 	- @*return* **r** number ― Red | ***Range:*** (0, 1)
	--- 	- @*return* **g** number ― Green | ***Range:*** (0, 1)
	--- 	- @*return* **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- @*return* **a**? number ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- - **onColorUpdate** function — The function to be called when the color is changed
	--- 	- @*param* **r** number ― Red | ***Range:*** (0, 1)
	--- 	- @*param* **g** number ― Green | ***Range:*** (0, 1)
	--- 	- @*param* **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- @*param* **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- - **onCancel** function — The function to be called when the color change is cancelled
	--- 	- @*param* **r** number ― Red | ***Range:*** (0, 1)
	--- 	- @*param* **g** number ― Green | ***Range:*** (0, 1)
	--- 	- @*param* **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- @*param* **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the color picker to the options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* **r** number ― Red | ***Range:*** (0, 1)
	--- 		- @*param* **g** number ― Green | ***Range:*** (0, 1)
	--- 		- @*param* **b** number ― Blue | ***Range:*** (0, 1)
	--- 		- @*param* **a**? number ― Opacity | ***Range:*** (0, 1)
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any *(any number of arguments)* ― The data in the storage table to be converted
	--- 		- @*return* **r** number ― Red | ***Range:*** (0, 1)
	--- 		- @*return* **g** number ― Green | ***Range:*** (0, 1)
	--- 		- @*return* **b** number ― Blue | ***Range:*** (0, 1)
	--- 		- @*return* **a**? number ― Opacity | ***Range:*** (0, 1)
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** table ― The saved value of the frame
	--- 			- **r** number ― Red | ***Range:*** (0, 1)
	--- 			- **g** number ― Green | ***Range:*** (0, 1)
	--- 			- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- 	- **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** table ― The value loaded to the frame
	--- 			- **r** number ― Red | ***Range:*** (0, 1)
	--- 			- **g** number ― Green | ***Range:*** (0, 1)
	--- 			- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	---@return Frame colorPicker A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - **getUniqueType** function ― Returns the object type of this unique frame
	--- 	- @*return* "ColorPicker" UniqueFrameType
	--- - **isUniqueType** function ― Checks and returns if the type of this unique frame matches the string provided entirely
	--- 	- @*param* **type** UniqueFrameType|string
	--- 	- @*return* boolean
	--- - **getColor** function ― Returns the currently set color values
	--- 	- @*return* **r** number ― Red | ***Range:*** (0, 1)
	--- 	- @*return* **g** number ― Green | ***Range:*** (0, 1)
	--- 	- @*return* **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- @*return* **a**? number ― Opacity | ***Range:*** (0, 1)
	--- - **setColor** function ― Sets the color and text of each element
	--- 	- @*param* **r** number ― Red | ***Range:*** (0, 1)
	--- 	- @*param* **g** number ― Green | ***Range:*** (0, 1)
	--- 	- @*param* **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- @*param* **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- - **setEnabled** function ― Enable or disable the color picker widget based on the specified value
	--- 	- @*param* **state** boolean ― Enable the input if true, disable if no
	--- - **pickerButton** [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button) — A base Button object with custom values, functions added
	--- 	- **gradient**? [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture)|nil — A base Texture object
	--- 	- **checker**? [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture)|nil — A base Texture object
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - **hexBox**? [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox)|nil — A base EditBox object with custom functions added
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateEditBox(...)** for details.
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* **self** Frame ― Reference to the color picker frame
	--- 		- @*param* **attribute** = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* **state** boolean ― Called with false before the before the widget's value is loaded, and called with true a second time, after the widget's value has been successfully loaded
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			colorPicker:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateColorPicker = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "ColorPicker")
		local red, green, blue, alpha = t.setColors()

		--[ Frame Setup ]

		--Create the color picker frame
		local colorPicker = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		wt.SetPosition(colorPicker, t.position)
		colorPicker:SetSize(t.width or 120, 36)

		--Label
		colorPicker.label = wt.AddTitle({
			parent = colorPicker,
			title = t.label ~= false and {
				text = t.title or t.name or "ColorPicker",
				offset = { x = 4, },
			} or nil,
		})

		--[ Color Picker Button ]

		--Create the Blizzard ColorPickerFrame opener button frame
		colorPicker.pickerButton = wt.CreateButton({
			parent = colorPicker,
			name = "PickerButton",
			label = false,
			tooltip = {
				title = strings.color.picker.label,
				lines = { [0] = { text = alpha and strings.color.picker.tooltip:gsub("#ALPHA", strings.color.picker.alpha) or strings.color.picker.tooltip:gsub("#ALPHA", ""), }, }
			},
			position = { offset = { y = -16 } },
			size = { width = 34, height = 22 },
			customizable = true,
			events = { OnClick = function(self)
				--Starting colors
				local startR, startG, startB, startA = self:GetBackdropColor()

				--Color picker button background update utility
				local function colorUpdate()
					local r, g, b = ColorPickerFrame:GetColorRGB()
					local a = OpacitySliderFrame:GetValue() or 1
					colorPicker.setColor(r, g, b, a, true)
				end

				--Clear the color update functions
				ColorPickerFrame.func = nil
				ColorPickerFrame.opacityFunc = nil

				--Load the color
				ColorPickerFrame:SetColorRGB(startR, startG, startB)
				ColorPickerFrame.hasOpacity = true
				ColorPickerFrame.opacity = startA

				--Open the Blizzard color picker
				ColorPickerFrame:Show()

				--Set the color update functions
				ColorPickerFrame.func = colorUpdate
				ColorPickerFrame.opacityFunc = colorUpdate

				--Reset on cancel
				ColorPickerFrame.cancelFunc = function()
					colorPicker.setColor(startR, startG, startB, startA)
					t.onCancel(startR, startG, startB, startA)
				end
			end, },
		})

		--Backdrop
		wt.SetBackdrop(colorPicker.pickerButton, {
			background = {
				texture = {
					size = 5,
					insets = { left = 2.5, right = 2.5, top = 2.5, bottom = 2.5 },
				},
				color = { r = red, g = green, b = blue, a = alpha or 1 }
			},
			border = {
				texture = { width = 11, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
			}
		}, {
			OnEnter = { rule = function()
				return IsMouseButtonDown() and {
					border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
				} or {
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				}
			end },
			OnLeave = { rule = function()
				return {
					border = { color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 } }
				}
			end },
			OnMouseDown = { rule = function()
				return {
					border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
				}
			end },
			OnMouseUp = { rule = function(self)
				return self:IsMouseOver() and {
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				} or {}
			end },
		})

		--Texture: Background gradient
		colorPicker.pickerButton.gradient = wt.CreateTexture({
			parent = colorPicker.pickerButton,
			name = "ColorGradient",
			position = { offset = { x = 2.5, y = -2.5 } },
			size = { width = 14, height = 17 },
			path = textures.gradientBG,
			layer = "BACKGROUND",
			level = -7,
		})


		--Texture: Checker pattern
		colorPicker.pickerButton.checker = wt.CreateTexture({
			parent = colorPicker.pickerButton,
			name = "AlphaBG",
			position = { offset = { x = 2.5, y = -2.5 } },
			size = { width = 29, height = 17 },
			path = textures.alphaBG,
			layer = "BACKGROUND",
			level = -8,
			tile = true,
		})

		--[ HEX Box ]

		colorPicker.hexBox = wt.CreateEditBox({
			parent = colorPicker,
			name = "HEXBox",
			title = strings.color.hex.label,
			label = false,
			tooltip = { lines = { [0] = { text = strings.color.hex.tooltip .. "\n\n" .. strings.misc.example .. ": #2266BB" .. (alpha and "AA" or ""), }, } },
			position = {
				relativeTo = colorPicker.pickerButton,
				relativePoint = "TOPRIGHT",
			},
			size = { width = colorPicker:GetWidth() - colorPicker.pickerButton:GetWidth(), height = colorPicker.pickerButton:GetHeight() },
			insets = { left = 6, },
			customizable = true,
			font = "GameFontWhiteSmall",
			fontDisabled = "GameFontDisableSmall",
			maxLetters = 7 + (alpha and 2 or 0),
			events = {
				OnChar = function(self, _, text) self.setText(text:gsub("^(#?)([%x]*).*", "%1%2"), false) end,
				OnEnterPressed = function(_, text)
					local r, g, b, a = wt.HexToColor(text)
					colorPicker.setColor(r, g, b, a or 1, true)
				end,
				OnEscapePressed = function(self) self.setText(wt.ColorToHex(colorPicker.getColor())) end,
			},
		})
		wt.SetBackdrop(colorPicker.hexBox, {
			background = {
				texture = {
					size = 5,
					insets = { left = 3, right = 3, top = 3, bottom = 3 },
				},
				color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 }
			},
			border = {
				texture = { width = 12, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 }
			}
		}, {
			OnEnter = { rule = function(self) return self:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end },
			OnLeave = {},
		})

		--[ Getters & Setters ]

		colorPicker.getUniqueType = function() return "ColorPicker" end
		colorPicker.isUniqueType = function(type) return type == "ColorPicker" end
		colorPicker.getColor = function() return colorPicker.pickerButton:GetBackdropColor() end
		colorPicker.setColor = function(r, g, b, a, user)
			colorPicker.pickerButton:SetBackdropColor(r, g, b, a or 1)
			colorPicker.pickerButton.gradient:SetVertexColor(r, g, b, 1)
			colorPicker.hexBox.setText(wt.ColorToHex(r, g, b, a))
			if user and t.onColorUpdate then t.onColorUpdate(r, g, b, a) end
		end
		colorPicker.setEnabled = function(state)
			state = state and not ColorPickerFrame:IsVisible()
			colorPicker.pickerButton.setEnabled(state)
			colorPicker.hexBox.setEnabled(state)
			if colorPicker.label then colorPicker.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
		end

		--State & dependencies
		if t.disabled then colorPicker.setEnabled(false) end
		if t.dependencies then wt.SetDependencies(t.dependencies, colorPicker.setEnabled) end

		--[ Events & behavior ]

		--Custom behavior
		ColorPickerFrame:HookScript("OnShow", function() colorPicker.setEnabled(false) end)
		ColorPickerFrame:HookScript("OnHide", function() colorPicker.setEnabled(wt.CheckDependencies(t.dependencies)) end)

		--[ Options Data ]

		if t.optionsData then wt.AddOptionsData(colorPicker, colorPicker.getUniqueType(), t.optionsData) end

		return colorPicker
	end


	--[[ REGISTER ]]

	--Register the toolbox
	ns.WidgetToolbox = WidgetTools.RegisterToolbox(addonNameSpace, toolboxVersion, ns.WidgetToolbox, ns.textures.logo)
end