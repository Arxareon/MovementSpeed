--[[ RESOURCES ]]

---Addon namespace
---@class ns
local addonNameSpace, ns = ...


--[[ WIDGET TOOLBOX ]]

--Register the toolbox
local toolboxVersion = "1.11"
ns.WidgetToolbox = WidgetTools.RegisterToolbox(addonNameSpace, toolboxVersion, nil) or {}

--Create a new toolbox
if not next(ns.WidgetToolbox) then

	---WidgetTools toolbox
	---@class wt
	local wt = ns.WidgetToolbox


	--[[ LOCALIZATIONS ]]

	--# flags will be replaced with code
	--\n represents the newline character

	local english = {
		reload = {
			title = "Pending Changes",
			description = "Reload the interface to apply the pending changes.",
			accept = {
				label = "Reload Now",
				tooltip = "You may choose to reload the interface now to apply the pending changes.",
			},
			cancel = {
				tooltip = "Reload the interface later with the /reload chat command or by logging out.",
			},
		},
		multiSelector = {
			locked = "Locked",
			minLimit = "At least #MIN options must be selected.",
			maxLimit = "Only #MAX options can be selected at once.",
		},
		dropdown = {
			selected = "This is the currently selected option.",
			none = "No option has been selected.",
			open = "\nClick to view the list of options.",
			previous = {
				label = "Previous option",
				tooltip = "Select the previous option.",
			},
			next = {
				label = "Next option",
				tooltip = "Select the next option.",
			},
		},
		copy = {
			textline = {
				label = "Click to copy",
				tooltip = "Click to reveal the text field you will be able to copy the text from."
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
				tooltip = {
					"Subtract #VALUE from the value.",
					"Hold ALT to subtract #VALUE instead.",
				},
			},
			increase = {
				label = "Increase",
				tooltip = {
					"Add #VALUE to the value.",
					"Hold ALT to add #VALUE instead.",
				},
			},
		},
		color = {
			picker = {
				label = "Pick a color",
				tooltip = "Open the color picker to customize the color#ALPHA.",
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
			defaultThese = "These Settings",
			defaultAll = "All Addon Settings",
			warning = "Are you sure you want to revert the\n#TITLE\nsettings to their default values?",
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
		strata = {
			lowest = "Low Background",
			lower = "Middle Background",
			low = "High Background",
			lowMid = "Low Middle",
			highMid = "High Middle",
			high = "Low Foreground",
			higher = "Middle Foreground",
			highest = "High Foreground",
		},
		misc = {
			accept = "Accept",
			cancel = "Cancel",
			default = "Default",
			example = "Example",
			close = "Close",
		},
		separator = ",", --Thousand separator character
		decimal = ".", --Decimal character
	}

	--Load the current localization
	local function LoadLocale()
		local strings
		local locale = GetLocale()

		if (locale == "") then
			--TODO: Add localization for other languages (locales: https://wowpedia.fandom.com/wiki/API_GetLocale#Values)
			--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml#L8
		else --Default: English (UK & US)
			strings = english
		end
		return strings
	end

	local strings = LoadLocale()


	--[[ UTILITIES ]]

	--Classic vs Dragonflight code separation
	wt.classic = select(4, GetBuildInfo())
	wt.classic = (wt.classic < 11404) or (wt.classic >= 20000 and wt.classic < 30402)
	wt.preDF = select(4, GetBuildInfo()) < 100000

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
			if a[i] == nil then return nil else return a[i], t[a[i]] end
		end

		return iterator
	end

	---Convert and format an input object to string to be dumped to the in-game chat
	---@param object any Object to dump out
	---@param outputTable? table Table to put the formatted output lines in
	---@param name? string A name to print out | ***Default:*** *the dumped object will not be named*
	---@param depth? integer How many levels of subtables to print out (root level: 0) | ***Default:*** *full depth*
	---@param blockrule? function Function to manually filter which keys get printed and explored further
	--- - @*param* `key` integer|string ― The currently dumped key
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
			table.insert(outputTable, line)
			return
		else
			local s = (currentKey and currentKey or "Dump " .. name .. "table") .. ":"

			--Stop at the max depth or if the key is skipped
			if skip or currentLevel >= (depth or currentLevel + 1) then
				table.insert(outputTable, s .. " {…}")
				return
			end
			table.insert(outputTable, s)

			--Convert & format the subtable
			for k, v in wt.SortedPairs(object) do GetDumpOutput(v, outputTable, nil, blockrule, depth, k, currentLevel + 1) end
		end
	end

	---Dump an object and its contents to the in-game chat
	---@param object any Object to dump out
	---@param name? string A name to print out | ***Default:*** *the dumped object will not be named*
	---@param blockrule? function Function to manually filter which keys get printed and explored further
	--- - @*param* `key` integer|string ― The currently dumped key
	--- - @*return* boolean ― Skip the key if the returned value is true
	--- - ***Example - Match:*** Skip a specific matching key
	--- 	```
	--- 	function(key) return key == "skip_key" end
	--- 	```
	--- - ***Example - Comparison:*** Skip an index key based the result of a comparison
	--- 	```
	--- 	function(key)
	--- 		if type(key) == "number" then --check if the key is an index to avoid issues with mixed tables
	--- 			return key < 10
	--- 		end
	--- 		return true --or false whether to allow string keys in mixed tables
	--- 	end
	--- 	```
	--- - ***Example - Blocklist:*** Iterate through an array (indexed table) containing keys, the values of which are to be skipped
	--- 	```
	--- 	function(key)
	--- 		local blocklist = {
	--- 			"skip_key",
	--- 			1,
	--- 		}
	--- 		for i = 1, #blocklist do
	--- 			if key == blocklist[i] then
	--- 				return true --or false to invert the functionality and treat the blocklist as an allowlist
	--- 			end
	--- 		end
	--- 		return false --or true to invert the functionality and treat the blocklist as an allowlist
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
		for i = 1, #output do
			lineCount = lineCount + 1
			message = message .. ((lineCount > 1 and i > 1) and "\n" .. output[i]:sub(5) or output[i])
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
	---@return any copy Returns **object** if it's not a table or if it is a frame reference
	wt.Clone = function(object)
		if type(object) ~= "table" then return object end
		if object.GetObjectType and object.IsObjectType then if object:IsObjectType(object:GetObjectType()) then return object end end

		local copy = {}
		for k, v in pairs(object) do copy[k] = wt.Clone(v) end

		return copy
	end

	---Copy all values at matching keys from a sample table to another table while preserving all table references
	---@param tableToCopy table Reference to the table to copy the values from
	---@param targetTable table Reference to the table to copy the values to
	---@return table? targetTable Reference to **targetTable** (the values were already overwritten during the operation, no need to set it again)
	wt.CopyValues = function(tableToCopy, targetTable)
		if type(tableToCopy) ~= "table" or type(targetTable) ~= "table" then return end
		if next(targetTable) == nil then return end

		for k, v in pairs(targetTable) do
			if tableToCopy[k] == nil then return end

			if type(v) == "table" then wt.CopyValues(tableToCopy[k], v) else targetTable[k] = tableToCopy[k] end
		end

		return targetTable
	end

	---Remove all nil, empty or otherwise invalid items from a data table
	---@param tableToCheck table Reference to the table to prune
	---@param valueChecker? function Optional function describing rules to validate values
	--- - @*param* `k` number|string
	--- - @*param* `v` any [non-table]
	--- - @*return* boolean ― True if **v** is to be accepted as valid, false if not
	---@return table? tableToCheck Reference to **tableToCheck** (it was already overwritten during the operation, no need for setting it again)
	wt.RemoveEmpty = function(tableToCheck, valueChecker)
		if type(tableToCheck) ~= "table" then return end

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

	---Compare two tables to check for and fill in missing data from one to the other
	---@param tableToCheck table|any Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already "table")
	---@param tableToSample table Reference to the table to sample data from
	---@return table? tableToCheck Reference to **tableToCheck** (it was already overwritten during the operation, no need for setting it again)
	wt.AddMissing = function(tableToCheck, tableToSample)
		if type(tableToSample) ~= "table" then return end
		if next(tableToSample) == nil then return end

		tableToCheck = type(tableToCheck) ~= "table" and {} or tableToCheck --The table to check isn't actually a table - turn it into a new one
		for k, v in pairs(tableToSample) do
			if tableToCheck[k] == nil then if v ~= nil and v ~= "" then tableToCheck[k] = v end --Add the missing item if the value is not empty or nil
			else wt.AddMissing(tableToCheck[k], tableToSample[k]) end
		end

		return tableToCheck
	end

	---Remove unused or outdated data from a table while comparing it to another table and assemble the list of removed keys
	---@param tableToCheck table Reference to the table to remove unused key, value pairs from
	---@param tableToSample table Reference to the table to sample data from
	---@param recoveredData? table
	---@param recoveredKey? string
	---@return table? recoveredData Table containing the removed key, value pairs (nested keys chained together with period characters in-between)
	local function CleanTable(tableToCheck, tableToSample, recoveredData, recoveredKey)
		recoveredData = recoveredData or {}

		if type(tableToCheck) ~= "table" or type(tableToSample) ~= "table" then return recoveredData end
		if next(tableToCheck) == nil then return recoveredData end

		for key, value in pairs(tableToCheck) do
			local rk = (recoveredKey or "") .. (type(key) == "number" and ("[" .. key .. "]") or ("." .. key))

			if tableToSample[key] == nil then
				--Save the old item to the recovered data container
				if type(value) ~= "table" then recoveredData[rk:sub(2)] = value else
					--Go deeper to fully map out recoverable keys
					local function GoDeeper(ttc, rck)
						if type(ttc) ~= "table" then return end

						for k, v in pairs(ttc) do
							rck = rck .. (type(k) == "number" and ("[" .. k .. "]") or ("." .. k))
							GoDeeper(v, rck)
							if type(v) ~= "table" then recoveredData[rck:sub(2)] = v end
						end
					end

					GoDeeper(value, rk)
				end

				--Remove the unneeded item
				tableToCheck[key] = nil
			else recoveredData = CleanTable(tableToCheck[key], tableToSample[key], recoveredData, rk) end
		end

		return recoveredData, tableToCheck
	end

	---Remove unused or outdated data from a table while comparing it to another table while restoring any removed values
	---@param tableToCheck table Reference to the table to remove unused key, value pairs from
	---@param tableToSample table Reference to the table to sample data from
	---@param recoveryMap? table Save removed data from matching key chains to the specified table under the specified key
	--- - **[*key*]** string Chain of keys pointing to the old data in **tableToCheck** to be recovered (Example: "keyOne[2].keyThree.keyFour[1]")
	--- - **[*value*]** table Recovery specifications
	--- 	- **saveTo** table Reference to the table to save the recovered piece of data to
	--- 	- **saveKey** string|number Save the data under this kay within the specified recovery table
	---@return table? tableToCheck Reference to **tableToCheck** (it was already overwritten during the operation, no need for setting it again)
	wt.RemoveMismatch = function(tableToCheck, tableToSample, recoveryMap)
		local rd = CleanTable(tableToCheck, tableToSample)

		if recoveryMap then for key, value in pairs(rd) do if recoveryMap[key] then recoveryMap[key].saveTo[recoveryMap[key].saveKey] = value end end end

		return tableToCheck
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

	---Returns the position values used by [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) from a position table used by WidgetTools
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
	---@return number? offsetX ***Default:*** 0
	---@return number? offsetY ***Default:*** 0
	wt.UnpackPosition = function(t)
		if type(t) ~= "table" then return "TOPLEFT" end

		t.offset = t.offset or {}
		return t.anchor or "TOPLEFT", type(t.relativeTo) == "string" and wt.ToFrame(t.relativeTo) or t.relativeTo, t.relativePoint, t.offset.x or 0, t.offset.y or 0
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

	---Returns the color values found in a table
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
	---@return number r Red | ***Range:*** (0, 1) | ***Default:*** 1 *(when an invalid input or missing value is provided)*
	---@return number g Green  | ***Range:*** (0, 1) | ***Default:*** 1 *(when an invalid input or missing value is provided)*
	---@return number b Blue | ***Range:*** (0, 1) | ***Default:*** 1 *(when an invalid input or missing value is provided)*
	---@return number? a Alpha | ***Range:*** (0, 1)
	wt.HexToColor = function(hex)
		hex = hex:gsub("#", "")
		if hex:len() ~= 6 and hex:len() ~= 8 then return 1, 1, 1 end

		local r = tonumber(hex:sub(1, 2), 16) / 255
		local g = tonumber(hex:sub(3, 4), 16) / 255
		local b = tonumber(hex:sub(5, 6), 16) / 255

		if hex:len() == 8 then return r, g, b, tonumber(hex:sub(7, 8), 16) / 255 else return r, g, b end
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

		--Set the position
		frame:ClearAllPoints()
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

	---Convert the position of a frame positioned relative to another to absolute position (being positioned in the UIParent)
	---@param frame Frame Reference to the frame the position of which to be converted to absolute position
	wt.ConvertToAbsolutePosition = function(frame)
		--Store movability
		local movable = frame:IsMovable()

		--Convert position
		frame:SetMovable(true)
		frame:StartMoving()
		frame:StopMovingOrSizing()

		--Restore movability
		frame:SetMovable(movable)
	end

	---Arrange the child frames of a container frame into stacked rows based on the parameters provided
	--- - ***Note:*** The frames will be arranged into columns based on the the number of child frames assigned to a given row, anchored to TOPLEFT, TOP and TOPRIGHT in order (by default) up to 3 frames. Columns in rows with more frames will be attempted to be spaced out evenly between the frames placed at the main 3 anchors.
	---@param container Frame Reference to the parent container frame the child frames of which are to be arranged based on the description in **arrangement**
	---@param margins? table Inset the content inside the container by the specified amount on each side
	--- - **l**? number *optional* — Space to leave on the left side | ***Default:*** 12
	--- - **r**? number *optional* — Space to leave on the right side (doesn't need to be negated) | ***Default:*** 12
	--- - **t**? number *optional* — Space to leave at the top (doesn't need to be negated) | ***Default:*** 12
	--- - **b**? number *optional* — Space to leave at the bottom | ***Default:*** 12
	---@param gaps? number The amount of space to leave between rows | ***Default:*** 8
	---@param flip? boolean Fill the rows from right to left instead of left to right | ***Default:*** false
	---@param resize? boolean Set the height of **container** to match the space taken up by the arranged content (including margins) | ***Default:*** true
	---@param arrangement? table Sef of descriptions to order the specified child frames by into columns within rows by | ***Default:*** *assemble the arrangement from the individual descriptions of child frames stored in their custom property *(see **Property**)*
	--- - **[*index*]** table ― List of elements to populate a row with
	--- 	- **[*value*]** integer — Index of a given child frame in { **container**:[GetChildren()](https://wowpedia.fandom.com/wiki/API_Frame_GetChildren) } to position | ***Range:*** (1, **container**:[GetNumChildren()](https://wowpedia.fandom.com/wiki/API_Frame_GetNumChildren))
	--- - ***Property:*** ***childFrame*.arrangementInfo**? table *optional*
	--- 	- **newRow**? boolean *optional* — Place **childFrame** into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place ***childFrame*** in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place ***childFrame*** at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	wt.ArrangeContent = function(container, margins, gaps, flip, resize, arrangement)
		local frames = { container:GetChildren() }
		margins = margins or {}
		margins = { l = margins.l or 12, r = margins.r or 12, t = margins.t or 12, b = margins.b or 12 }
		if flip then
			local temp = margins.l
			margins.l = margins.r
			margins.r = temp
		end
		gaps = gaps or 8
		local flipper = flip and -1 or 1
		local height = margins.t

		--Assemble the arrangement descriptions
		if not arrangement then
			arrangement = {}

			--Check the child frames for descriptions
			for i = 1, #frames do if frames[i].arrangementInfo then
				--Add the description to the list
				if frames[i].arrangementInfo.newRow ~= false or #arrangement == 0 then
					--To be placed in a new row
					table.insert(arrangement, { i })
				else
					--Assign row
					local rowCount = #arrangement
					frames[i].arrangementInfo.row = frames[i].arrangementInfo.row and (
						frames[i].arrangementInfo.row < rowCount and frames[i].arrangementInfo.row
					) or rowCount

					--Assign column
					local columnCount = #arrangement[frames[i].arrangementInfo.row or 1]
					frames[i].arrangementInfo.column = frames[i].arrangementInfo.column and (
						frames[i].arrangementInfo.column <= columnCount and frames[i].arrangementInfo.column
					) or columnCount + 1

					--To be place in the specified spot
					table.insert(arrangement[frames[i].arrangementInfo.row], frames[i].arrangementInfo.column, i)
				end
			end end
		end

		--Arrange the frames in each row
		for i = 1, #arrangement do
			local rowHeight = 0

			--Find the tallest widget
			for j = 1, #arrangement[i] do
				local frameHeight = frames[arrangement[i][j]]:GetHeight()
				if frameHeight > rowHeight then rowHeight = frameHeight end

				--Clear positions
				frames[arrangement[i][j]]:ClearAllPoints()
			end

			--Increase the content height by the space between rows
			height = height + (i > 1 and gaps or 0)

			--First frame goes to the top left (or right if flipped)
			frames[arrangement[i][1]]:SetPoint(flip and "TOPRIGHT" or "TOPLEFT", margins.l * flipper, -height)

			--Place the rest of the frames
			if #arrangement[i] > 1 then
				local odd = #arrangement[i] % 2 ~= 0

				--Middle frame goes to the top center
				local two = #arrangement[i] == 2
				if odd or two then frames[arrangement[i][two and 2 or math.ceil(#arrangement[i] / 2)]]:SetPoint("TOP", container, "TOP", 0, -height) end

				if #arrangement[i] > 2 then
					--Last frame goes to the top right (or left if flipped)
					frames[arrangement[i][#arrangement[i]]]:SetPoint(flip and "TOPLEFT" or "TOPRIGHT", -margins.r * flipper, -height)

					--Fill the space between the main anchor points with the remaining frames
					if #arrangement[i] > 3 then
						local shift = odd and 0 or 0.5
						local w = container:GetWidth() / 2
						local n = (#arrangement[i] - (odd and 1 or 0)) / 2 - shift
						local leftFillWidth = (w - frames[arrangement[i][1]]:GetWidth() / 2 - margins.l) / -n * flipper
						local rightFillWidth = (w - frames[arrangement[i][#arrangement[i]]]:GetWidth() / 2 - margins.r) / n * flipper

						--Fill the left half
						local last = math.floor(#arrangement[i] / 2)
						for j = 2, last do frames[arrangement[i][j]]:SetPoint("TOP", leftFillWidth * (math.abs(last - j) + (1 - shift)), -height) end

						--Fill the right half
						local first = math.ceil(#arrangement[i] / 2) + 1
						for j = first, #arrangement[i] - 1 do frames[arrangement[i][j]]:SetPoint("TOP", rightFillWidth * (math.abs(first - j) + (1 - shift)), -height) end
					end
				end
			end

			--Increase the content height by the row height
			height = height + rowHeight
		end

		--Set the height of the container frame
		if resize ~= false then container:SetHeight(height + margins.b) end
	end

	---Set the movability of a frame based in the specified values
	---@param frame Frame Reference to the frame to make movable/unmovable
	---@param movable boolean Whether to make the frame movable or unmovable
	---@param modifier? ModifierKey The specific (or any) modifier key required to be pressed down to move **frame** (if **frame** has the "OnUpdate" script defined) | ***Default:*** nil *(no modifier)*
	--- - ***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://wowpedia.fandom.com/wiki/API_IsModifierKeyDown) is used.
	---@param triggers? table Optional list of frames that should trigger the movement when interacted with | ***Default:*** **frame**
	--- - **[*value*]** Frame ― Reference to the frame to handle the inputs to initiate or stop the movement of **frame**
	--- 	- ***Note:*** The [IsMouseEnabled](https://wowpedia.fandom.com/wiki/API_ScriptRegion_IsMouseEnabled) property and [OnUpdate](OnUpdate) script handlers of the trigger frame will be overwritten.
	---@param events? table Table containing function descriptions to call when certain events occur
	--- - **onStart**? function *optional* — Function to call when **frame** starts moving
	--- - **onMove**? function *optional* — Function to call every with frame update while **frame** is moving (if **frame** has the "OnUpdate" script defined)
	--- - **onStop**? function *optional* — Function to call when the movement of **frame** is stopped and the it was moved successfully
	--- - **onCancel**? function *optional* — Function to call when the movement of **frame** is cancelled (because the modifier key was released early as an example)
	wt.SetMovability = function(frame, movable, modifier, triggers, events)
		if not frame.SetMovable then return end
		triggers = triggers or { [1] = frame }
		if modifier then modifier = wt.ModifierToCheck(modifier) end
		local position = wt.PackPosition(frame:GetPoint())

		--Set movability
		frame:SetMovable(movable)
		for i = 1, #triggers do
			triggers[i]:EnableMouse(movable)
			if movable then
				triggers[i]:HookScript("OnMouseDown", function()
					if not frame:IsMovable() or frame.isMoving then return end
					if modifier then if not modifier() then return end end

					--Store position
					position = wt.PackPosition(frame:GetPoint())

					--Start moving
					frame:StartMoving()
					frame.isMoving = true
					if (events or {}).onStart then events.onStart() end

					--Start the movement updates
					if triggers[i]:HasScript("OnUpdate") then triggers[i]:SetScript("OnUpdate", function()
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
							triggers[i]:SetScript("OnUpdate", nil)
						end
					end) end
				end)
				triggers[i]:HookScript("OnMouseUp", function()
					if not frame:IsMovable() or not frame.isMoving then return end

					--Stop moving
					frame:StopMovingOrSizing()
					frame.isMoving = false
					if (events or {}).onStop then events.onStop() end

					--Stop the movement updates
					if triggers[i]:HasScript("OnUpdate") then triggers[i]:SetScript("OnUpdate", nil) end
				end)
				triggers[i]:HookScript("OnHide", function()
					if not frame:IsMovable() or not frame.isMoving then return end

					--Cancel moving
					frame:StopMovingOrSizing()
					frame.isMoving = false
					if (events or {}).onCancel then events.onCancel() end

					--Reset the position
					wt.SetPosition(frame, position)

					--Stop the movement updates
					if triggers[i]:HasScript("OnUpdate") then triggers[i]:SetScript("OnUpdate", nil) end
				end)
			end
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
	--- 			- **l**? number *optional* — ***Default:*** 0
	--- 			- **r**? number *optional* — ***Default:*** 0
	--- 			- **t**? number *optional* — ***Default:*** 0
	--- 			- **b**? number *optional* — ***Default:*** 0
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
	--- 		- @*param* `self` Frame ― Reference to **updates[*key*].frame**
	--- 		- @*param* `...` any ― Any leftover arguments will be passed from the handler script to **updates[*key*].rule**
	--- 		- @*return* `backdropUpdate`? table *optional* ― Parameters to update the backdrop with | ***Default:*** nil *(remove the backdrop)*
	--- 			- **background**? table *optional* ― Table containing the parameters used for the background | ***Default:*** **backdrop.background** if **keepValues** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure) and **frame**:[GetBackdropColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropColor))*
	--- 				- **texture**? table *optional* ― Parameters used for setting the background texture | ***Default:*** **backdrop.background.texture** if **keepValues** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure))*
	--- 					- **path**? string *optional* ― Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/ChatFrame/ChatFrameBackground"
	--- 						- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 						- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 						- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- 					- **size** number — Size of a single background tile square
	--- 					- **tile**? boolean *optional* — Whether to repeat the texture to fill the entire size of the frame | ***Default:*** true
	--- 					- **insets**? table *optional* ― Offset the position of the background texture from the edges of the frame inward
	--- 						- **l**? number *optional* — ***Default:*** 0
	--- 						- **r**? number *optional* — ***Default:*** 0
	--- 						- **t**? number *optional* — ***Default:*** 0
	--- 						- **b**? number *optional* — ***Default:*** 0
	--- 				- **color**? table *optional* — Apply the specified color to the background texture | ***Default:*** **backdrop.background.color** if **keepValues** == true *(if it's false, keep the currently set values of **frame**:[GetBackdropColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropColor))*
	--- 					- **r** number ― Red | ***Range:*** (0, 1)
	--- 					- **g** number ― Green | ***Range:*** (0, 1)
	--- 					- **b** number ― Blue | ***Range:*** (0, 1)
	--- 					- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- 			- **border**? table *optional* ― Table containing the parameters used for the border | ***Default:*** **backdrop** if **keepValues** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure) and **frame**:[GetBackdropBorderColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropBorderColor))*
	--- 				- **texture**? table *optional* ― Parameters used for setting the border texture | ***Default:*** **backdrop.border.texture** if **keepValues** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure))*
	--- 					- **path**? string *optional* ― Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/Tooltips/UI-Tooltip-Border"
	--- 						- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 						- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 						- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- 					- **width** number — Width of the backdrop edge
	--- 				- **color**? table *optional* — Apply the specified color to the border texture | ***Default:*** **backdrop.border.color** if **keepValues** == true *(if it's false, keep the currently set values of **frame**:[GetBackdropBorderColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropBorderColor))*
	--- 					- **r** number ― Red | ***Range:*** (0, 1)
	--- 					- **g** number ― Green | ***Range:*** (0, 1)
	--- 					- **b** number ― Blue | ***Range:*** (0, 1)
	--- 					- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- 		- @*return* `fillRule`? boolean *optional* ― If true, fill the specified defaults for the unset values in **backdropUpdates** with the values provided in **backdrop** at matching keys, if false, fill them with their corresponding values from the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure), **frame**:[GetBackdropColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropColor) and **frame**:[GetBackdropBorderColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropBorderColor) | ***Default:*** false
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

	---Check all dependencies (disable / enable rules) of a frame
	---@param rules table Indexed table containing the dependency rules of the frame object
	--- - **[*index*]** table ― Parameters of a dependency rule
	--- 	- **frame** Frame — Reference to the widget the state of a widget is tied to
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 		- @*param* `value`? any *optional* — The current value of **rules.frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 		- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
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

		for i = 1, #rules do
			if rules[i].frame:IsObjectType("CheckButton") then
				if rules[i].evaluate then state = rules[i].evaluate(rules[i].frame:GetChecked()) else state = rules[i].frame:GetChecked() end
			elseif rules[i].frame:IsObjectType("EditBox") then state = rules[i].evaluate(rules[i].frame:GetText())
			elseif rules[i].frame:IsObjectType("Slider") then state = rules[i].evaluate(rules[i].frame:GetValue())
			elseif rules[i].frame:IsObjectType("Frame") and rules[i].frame.isUniqueType then
				--Custom widgets
				if rules[i].frame.isUniqueType("Toggle") then
					if rules[i].evaluate then state = rules[i].evaluate(rules[i].frame.getState()) else state = rules[i].frame.getState() end
				elseif rules[i].frame.isUniqueType("Selector") or rules[i].frame.isUniqueType("Dropdown") then state = rules[i].evaluate(rules[i].frame.getSelected())
				elseif rules[i].frame.isUniqueType("TextBox") then state = rules[i].evaluate(rules[i].frame.getText())
				elseif rules[i].frame.isUniqueType("ValueSlider") then state = rules[i].evaluate(rules[i].frame.getValue())  end
			end

			if not state then break end
		end

		return state
	end

	---Set the dependencies (disable / enable rules) of a frame based on a ruleset
	---@param rules table Indexed table containing the dependency rules of the frame object
	--- - **[*index*]** table ― Parameters of a dependency rule
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 		- @*param* `value`? any *optional* — The current value of **rules.frame**, the type of which depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** *(see **Overloads**)*
	--- 		- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: string) -> **evaluation**: boolean — If **rules.frame** is recognized as an editbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	---@param setState function Function to call to set the state of the frame
	--- - @*param* `state` boolean — The frame should be enabled when true, disabled when false
	wt.SetDependencies = function(rules, setState)
		for i = 1, #rules do
			if rules[i].frame.HookScript and rules[i].frame.IsObjectType then
				--Watch value load events
				rules[i].frame:HookScript("OnAttributeChanged", function(_, attribute, state) if attribute == "loaded" and state then setState(wt.CheckDependencies(rules)) end end)

				--Watch value change events
				if rules[i].frame:IsObjectType("CheckButton") then rules[i].frame:HookScript("OnClick", function() setState(wt.CheckDependencies(rules)) end)
				elseif rules[i].frame:IsObjectType("EditBox") then rules[i].frame:HookScript("OnTextChanged", function() setState(wt.CheckDependencies(rules)) end)
				elseif rules[i].frame:IsObjectType("Slider") then rules[i].frame:HookScript("OnValueChanged", function() setState(wt.CheckDependencies(rules)) end)
				elseif rules[i].frame:IsObjectType("Frame") and rules[i].frame.isUniqueType then
					--Custom widgets
					if rules[i].frame.isUniqueType("Toggle") then
						rules[i].frame:HookScript("OnAttributeChanged", function(_, attribute, _) if attribute == "toggled" then setState(wt.CheckDependencies(rules)) end end)
					elseif rules[i].frame.isUniqueType("Selector") or rules[i].frame.isUniqueType("Dropdown") then
						rules[i].frame:HookScript("OnAttributeChanged", function(_, attribute, _) if attribute == "selected" then setState(wt.CheckDependencies(rules)) end end)
					elseif rules[i].frame.isUniqueType("TextBox") or rules[i].frame.isUniqueType("ValueSlider") then
						rules[i].frame:HookScript("OnAttributeChanged", function(_, attribute, _) if attribute == "changed" then setState(wt.CheckDependencies(rules)) end end)
					end
				end
			end
		end
	end

	--[ Options Data Management ]

	--Collection of rules describing where to save/load options data to/from, and what to call in the process
	local optionsTable = { rules = {}, changeHandlers = {} }

	---Add a connection between an options widget and a DB entry to the options data table under the specified options key
	---@param widget Frame Reference to the widget to be saved & loaded data to/from
	---@param widgetType FrameType|UniqueFrameType Type of the widget object (string), the return value of **widget**:[GetObjectType()](https://wowpedia.fandom.com/wiki/API_UIObject_GetObjectType) (for applicable Blizzard-built widgets).
	--- - ***Note:*** When "Frame" is returned in case of a UIDropDownMenu or a custom WidgetTools frame, use **widget.getUniqueType()** to get its unique type.
	---@param optionsData table Table with the information on options data handling
	--- - **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- - **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- - **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- - **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 	- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- - **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 	- @*param* any ― The current value of the widget
	--- 	- @*return* any ― The converted value
	--- - **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 	- @*param* any ― The data to be converted and loaded into the widget
	--- 	- @*return* any ― The converted value
	--- - **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 	- @*param* `self`? Frame ― Reference to the widget
	--- 	- @*param* `value`? any *optional* ― The saved value from the widget
	--- - **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 	- @*param* `self`? Frame ― Reference to the widget
	--- 	- @*param* `value`? any *optional* ― The value loaded to the widget
	--- - **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 	- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *next assigned index*
	--- 	- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 		- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	wt.AddOptionsData = function(widget, widgetType, optionsData)
		if not optionsData.optionsKey then return end

		optionsTable.rules[optionsData.optionsKey] = optionsTable.rules[optionsData.optionsKey] or {}
		optionsTable.rules[optionsData.optionsKey][widgetType] = optionsTable.rules[optionsData.optionsKey][widgetType] or {}

		--Add the onChange handlers to options data management
		if optionsData.onChange then
			local keys = {}

			for k, v in pairs(optionsData.onChange) do if type(k) == "string" and type(v) == "function" then
				--Store the function
				optionsTable.changeHandlers[optionsData.optionsKey] = optionsTable.changeHandlers[optionsData.optionsKey] or {}
				optionsTable.changeHandlers[optionsData.optionsKey][k] = v

				--Remove the function definitions, save their keys
				optionsData.onChange[k] = nil
				table.insert(keys, k)
			end end

			--Add saved keys
			for i = 1, #keys do table.insert(optionsData.onChange, keys[i]) end
		end

		--Add the options data rules to the collection
		optionsData.widget = widget
		table.insert(optionsTable.rules[optionsData.optionsKey][widgetType], optionsData)
	end

	---Save all data from the widgets to the working table(s) specified in the collection of options data referenced by the options key
	---@param optionsKey table A unique key referencing the collection of widget options data to be saved
	wt.SaveOptionsData = function(optionsKey)
		if not optionsTable.rules[optionsKey] then return end

		for k, v in pairs(optionsTable.rules[optionsKey]) do
			for i = 1, #v do
				--Get the value from the widget
				local value
				if k == "CheckButton" then value = v[i].widget:GetChecked()
				elseif k == "Toggle" then value = v[i].widget.getState()
				elseif k == "Selector" or k == "Dropdown" then value = v[i].widget.getSelected()
				elseif k == "EditBox" then value = v[i].widget:GetText()
				elseif k == "TextBox" then value = v[i].widget.getText()
				elseif k == "Slider" then value = v[i].widget:GetValue()
				elseif k == "ValueSlider" then value = v[i].widget.getValue()
				elseif k == "ColorPicker" then value = wt.PackColor(v[i].widget.getColor())
				end

				--Save the value to the working table
				if v[i].workingTable and v[i].storageKey then if v[i].instantSave == false and value ~= nil then
					if v[i].convertSave then value = v[i].convertSave(value) end
					v[i].workingTable[v[i].storageKey] = value
				end end

				--Call onSave if specified
				if v[i].onSave then v[i].onSave(v[i].widget, value) end
			end
		end
	end

	---Load all data from the working table(s) to the widgets specified in the collection of options data referenced by the options key
	--- - [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) will be evoked for all frames
	--- 	- @*param* `self` Frame ― Reference to the widget frame
	--- 	- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 	- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
	---@param optionsKey table A unique key referencing the collection of widget options data to be loaded
	---@param changes boolean Whether to call **onChange** handlers or not | ***Default:*** false
	wt.LoadOptionsData = function(optionsKey, changes)
		if not optionsTable.rules[optionsKey] then return end

		if changes then changes = {} end

		for k, v in pairs(optionsTable.rules[optionsKey]) do
			for i = 1, #v do
				--Load the value from the working table
				local value
				if (v[i].workingTable and v[i].storageKey) or v[i].convertLoad then
					if v[i].workingTable and v[i].storageKey then value = v[i].workingTable[v[i].storageKey] end
					if v[i].convertLoad then value = v[i].convertLoad(value) end

					--Apply to the widget
					if k == "CheckButton" then
						v[i].widget:SetAttributeNoHandler("loaded", false)
						v[i].widget:SetChecked(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "Toggle" then
						v[i].widget:SetAttributeNoHandler("loaded", false)
						v[i].widget.setState(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "Selector" or k == "Dropdown" then
						v[i].widget:SetAttributeNoHandler("loaded", false)
						v[i].widget.setSelected(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "EditBox" or k == "TextBox" then
						v[i].widget:SetAttributeNoHandler("loaded", false)
						v[i].widget.setText(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "Slider" then
						v[i].widget:SetAttributeNoHandler("loaded", false)
						v[i].widget:SetValue(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "ValueSlider" then
						v[i].widget:SetAttributeNoHandler("loaded", false)
						v[i].widget.setValue(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "ColorPicker" then
						v[i].widget:SetAttributeNoHandler("loaded", false)
						v[i].widget.setColor(wt.UnpackColor(value))
						v[i].widget:SetAttribute("loaded", true)
					end
				end

				--Call onLoad if specified
				if v[i].onLoad then v[i].onLoad(v[i].widget, value) end

				--Register onChange handlers for call
				if changes and v[i].onChange then for j = 1, #v[i].onChange do changes[v[i].onChange[j]] = true end end
			end
		end

		--Call registered onChange handlers
		if changes then for k in pairs(changes) do optionsTable.changeHandlers[optionsKey][k]() end end
	end

	--[ Hyperlink Handlers ]

	---Format a clickable hyperlink text via escape sequences
	---@param type HyperlinkType [Type of the hyperlink](https://wowpedia.fandom.com/wiki/Hyperlinks#Types) determining how it's being handled and what payload it carries
	---@param content? string A colon-separated chain of parameters determined by **type** (Example: "content1:content2:content3") | ***Default:*** ""
	---@param text string Clickable text to be displayed as the hyperlink
	---@return string
	wt.Hyperlink = function(type, content, text)
		return "\124H" .. type .. ":" .. (content or "") .. "\124h" .. text .. "\124h"
	end

	---Format a custom clickable addon hyperlink text via escape sequences
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param type? string A unique key signifying the type of the hyperlink specific to the addon (if the addon handles multiple different custom types of hyperlinks) in order to be able to set unique hyperlink click handlers via ***WidgetToolbox*.SetHyperlinkHandler(...)** | ***Default:*** "-"
	---@param content? string A colon-separated chain of data strings carried by the hyperlink to be provided to the handler function (Example: "content1:content2:content3") | ***Default:*** ""
	---@param text string Clickable text to be displayed as the hyperlink
	wt.CustomHyperlink = function(addon, type, content, text)
		return wt.Hyperlink(wt.preDF and "item" or "addon", addon .. ":" .. (type or "-") .. ":" .. (content or ""), text)
	end

	--Collection of hyperlink handler scripts
	local hyperlinkHandlers = {}

	---Register a function to handle custom hyperlink clicks
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param type? string Unique custom hyperlink type key used to identify the specific handler function | ***Default:*** "-"
	---@param handler function Function to be called by clicking on a hyperlink text created via ***WidgetToolbox*.CustomHyperlink(...)**
	--- - @*param* `...` any ― List of content data strings carried by the hyperlink returned one by one
	wt.SetHyperlinkHandler = function(addon, type, handler)
		--Call the handler function if it has been registered
		local function callHandler(addonID, handlerID, payload)
			local handlerFunction = wt.FindKey(wt.FindKey(hyperlinkHandlers, addonID), handlerID)
			if handlerFunction then handlerFunction(strsplit(":", payload)) end
		end

		--Hook the hyperlink handler caller
		if not next(hyperlinkHandlers) then
			if not wt.preDF then EventRegistry:RegisterCallback("SetItemRef", function(_, ...)
				local linkType, addonID, handlerID, payload = strsplit(":", ..., 4)
				if linkType == "addon" then callHandler(addonID, handlerID, payload) end
			end) else hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(_, ...)
				local _, addonID, handlerID, payload = strsplit(":", ..., 4)
				callHandler(addonID, handlerID, payload)
			end) end
		end

		--Add the hyperlink handler function to the table
		if not hyperlinkHandlers[addon] then hyperlinkHandlers[addon] = {} end
		hyperlinkHandlers[addon][type or "-"] = handler
	end

	--[ Chat Control ]

	---Register a list of chat keywords and related commands for use
	---@param addon string The name of the addon's folder (the addon namespace not the display title)
	---@param keywords table List of keywords to register
	--- - **[*value*]** string ― A slash character (`"/"`) will appended before the keyword specified here.
	---@param commands table List of commands to register under the specified **keywords**
	--- - **[*value*]** table ― Parameters are to be provided in this table
	--- 	- **command** string ― Name of the slash command word (no spaces) to recognize after the keyword (separated by a space character)
	--- 	- **handler**? function *optional* ― Function to be called when the specific command was recognized after being typed into chat
	--- 		- @*param* `...` string ― Payload of the command typed, any words following the command name separated by spaces split and returned one by one
	--- 		- @*return* `result`? boolean *optional* ― Whether to call **[*value*].onSuccess** or **[*value*].onError** after the operation | ***Default:*** nil *(no response)*
	--- 		- @*return* `...` any ― Any leftover arguments will be passed to the result handler script
	--- 	- **onSuccess**? function *optional* ― Function to call after **commands[*value*].handler** returns with true to handle a successful result
	--- 		- @*param* `...` any ― Any leftover arguments returned by the handler script will be passed over
	--- 	- **onError**? function *optional* ― Function to call after **commands[*value*].handler** returns with false to handle a failed result
	--- 		- @*param* `...` any ― Any leftover arguments returned by the handler script will be passed over
	--- 	- **help**? boolean *optional* ― If true, when typed, trigger a call for each command to execute their **commands[*value*].onHelp** handlers | ***Default:*** false
	--- 	- **onHelp**? function *optional* ― Function to handle the calls initiated by the specified help command(s)
	---@param defaultHandler? function Default handler function to call when no matching command was typed after the keyword (separated by a space character)
	--- - @*param* `command` string ― The unrecognized command typed after the keyword (separated by a space character)
	--- - @*param* `...` string Payload of the command typed, any words following the command name separated by spaces split and returned one by one
	---@return table commandManager
	--- - **handleCommand** function ― Function to find and a specific command by its name and call its handler script
	--- 	- @*param* `command` string ― Name of the slash command word (no spaces)
	--- 	- @*param* `...` any ― Any further arguments are used as the payload of the command, passed over to its handler
	wt.RegisterChatCommands = function(addon, keywords, commands, defaultHandler)
		local commandManager = {}
		addon = addon:upper()

		--Register the keywords
		for i = 1, #keywords do _G["SLASH_" .. addon .. i] = "/" .. keywords[i] end

		--Create command handler
		commandManager.handleCommand = function(command, ...)
			--Find the command
			for i = 1, #commands do if command == commands[i].command then
				--Call the command handler
				if commands[i].handler then
					local results = { commands[i].handler(...) }

					--Call success/error handlers
					if commands[i].onSuccess and results[1] == true then
						table.remove(results, 1)
						commands[i].onSuccess(unpack(results))
					elseif commands[i].onError and results[1] == false then
						table.remove(results, 1)
						commands[i].onError(unpack(results))
					end
				end

				--Call help handlers
				if commands[i].help then for j = 1, #commands do if commands[j].onHelp then commands[j].onHelp() end end end

				return true
			end end

			return false
		end

		--Set keyword handler
		SlashCmdList[addon] = function(line)
			local payload = { strsplit(" ", line) }
			local command = payload[1]
			table.remove(payload, 1)

			--Find and handle the specific command or call the default handler script
			if not commandManager.handleCommand(command, unpack(payload)) and defaultHandler then defaultHandler(unpack(payload)) end
		end

		return commandManager
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
			highlight = { r = 0.8, g = 0.8, b = 0.3, a = 0.5 },
			click = { r = 0.6, g = 0.6, b = 0.2, a = 0.5 },
		},
	}

	--Textures
	local textures = {
		alphaBG = "Interface/AddOns/" .. addonNameSpace .. "/Textures/AlphaBG.tga",
		gradientBG = "Interface/AddOns/" .. addonNameSpace .. "/Textures/GradientBG.tga",
		contextBG = "Interface/AddOns/" .. addonNameSpace .. "/Textures/ContextBG.tga",
	}


	--[[ UX HELPERS ]]

	--[ Custom Tooltip]

	---Create and set up a new custom GameTooltip frame
	---@param name string Unique string piece to place in the name of the the tooltip to distinguish it from other tooltips (use the addon namespace string as an example)
	---@return GameTooltip tooltip
	wt.CreateGameTooltip = function(name)
		local tooltip = CreateFrame("GameTooltip", name .. "GameTooltip", nil, "GameTooltipTemplate")

		--Visibility
		tooltip:SetFrameStrata("TOOLTIP")
		tooltip:SetScale(0.9)

		--Title font
		_G[tooltip:GetName() .. "TextLeft" .. 1]:SetFontObject("GameFontNormalMed1")
		_G[tooltip:GetName() .. "TextRight" .. 1]:SetFontObject("GameFontNormalMed1")

		return tooltip
	end

	local customTooltip = wt.CreateGameTooltip("WidgetTools" .. toolboxVersion)

	---Set up a GameTooltip for a frame to be toggled on hover
	---@param owner Frame Owner frame the tooltip to be shown for
	--- - ***Note:*** A custom property named **tooltipData** will be added to **owner** with the value of the **tooltipData** parameter provided here.
	--- - ***Note:*** If **owner** doesn't have a **tooltipData** property, no tooltip will be shown.
	---@param tooltipData table The tooltip parameters are to be provided in this table
	--- - **tooltip**? GameTooltip ― Reference to the tooltip frame to set up | ***Default:*** *default WidgetTools custom tooltip*
	--- - **title** string ― String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR)
	--- - **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 	- **[*index*]** table ― Parameters of a line of text
	--- 		- **text** string ― Text to be displayed in the line
	--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR
	--- 			- **r** number ― Red | ***Range:*** (0, 1)
	--- 			- **g** number ― Green | ***Range:*** (0, 1)
	--- 			- **b** number ― Blue | ***Range:*** (0, 1)
	--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- - **anchor** TooltipAnchor ― [GameTooltip anchor](https://wowpedia.fandom.com/wiki/API_GameTooltip_SetOwner#Arguments)
	--- - **offset**? table *optional* ― Values to offset the position of **tooltipData.tooltip** by
	--- 	- **x**? number *optional* — ***Default:*** 0
	--- 	- **y**? number *optional* — ***Default:*** 0
	--- - **position**? table *optional* ― Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via **t.anchor** | ***Default:*** "TOPLEFT" if **tooltipData.anchor** == "ANCHOR_NONE"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- ***Note:*** **t.offset** will be used when calling [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) as well.
	--- - **flipColors**? boolean *optional* ― Flip the default color values of the title and the text lines | ***Default:*** false
	---@param toggle table Further toggle rule parameters are to be provided in this table
	--- - **triggers**? table *optional* ― List of additional frames to add hover events to to toggle **tooltipData.tooltip** for **owner** besides **owner** itself
	--- 	- **[*value*]** Frame ― Reference to the frame to add the hover events to to toggle the visibility of **tooltipData.tooltip**
	--- - **checkParent**? boolean *optional* ― Whether to check if **owner** is being hovered before hiding **tooltipData.tooltip** when triggers stop being hovered | ***Default:*** true
	--- - **replace**? boolean *optional* ― If false, while **tooltipData.tooltip** is already visible for a different owner, don't change it | ***Default:*** true
	--- 	- ***Note:*** If **tooltipData.tooltip** is already shown for **owner**, ***WidgetToolbox*.UpdateTooltip(...)** will be called anyway.
	wt.AddTooltip = function(owner, tooltipData, toggle)
		--Set Property
		owner.tooltipData = tooltipData
		owner.tooltipData.tooltip = owner.tooltipData.tooltip or customTooltip

		--Toggle events
		toggle = toggle or {}
		toggle.triggers = toggle.triggers or {}
		table.insert(toggle.triggers, owner)
		for i = 1, #toggle.triggers do
			--Show tooltip
			if toggle.triggers[i] ~= owner and toggle.replace == false then
				toggle.triggers[i]:HookScript("OnEnter", function() if owner.tooltipData then if not owner.tooltipData.tooltip:IsVisible() then wt.UpdateTooltip(owner) end end end)
			else toggle.triggers[i]:HookScript("OnEnter", function() wt.UpdateTooltip(owner) end) end

			--Hide tooltip
			if toggle.triggers[i] ~= owner and toggle.checkParent ~= false then
				toggle.triggers[i]:HookScript("OnLeave", function() if not owner:IsMouseOver() then if owner.tooltipData then owner.tooltipData.tooltip:Hide() end end end)
			else toggle.triggers[i]:HookScript("OnLeave", function() if owner.tooltipData then owner.tooltipData.tooltip:Hide() end end) end
		end

		--Hide with owner
		owner:HookScript("OnHide", function() if owner.tooltipData then owner.tooltipData.tooltip:Hide() end end)
	end

	---Update and show a GameTooltip already set up to be toggled for a frame
	---@param owner Frame Owner frame the tooltip to be shown for
	--- - ***Note:*** If **owner** doesn't have a **tooltipData** property, no tooltip will be shown.
	---@param tooltipData? table The tooltip parameters are to be provided in this table | ***Default:*** **owner.tooltipData**
	--- - **tooltip**? GameTooltip ― Reference to the tooltip frame to set up | ***Default:*** **owner.tooltipData.tooltip**
	--- - **title**? string *optional* ― String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR) | ***Default:*** **owner.tooltipData.title**
	--- - **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title | ***Default:*** **owner.tooltipData.lines**
	--- 	- **[*index*]**? table *optional* ― Parameters of a line of text | ***Default:*** **owner.tooltipData.lines[*index*]**
	--- 		- **text**? string *optional* ― Text to be displayed in the line | ***Default:*** **owner.tooltipData.lines[*index*].text**
	--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** **owner.tooltipData.lines[*index*].font** or GameTooltipTextSmall
	--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** **owner.tooltipData.lines[*index*].color** or HIGHLIGHT_FONT_COLOR
	--- 			- **r**? number *optional* ― Red | ***Range:*** (0, 1) | ***Default:*** **owner.tooltipData.lines[*index*].color.r**
	--- 			- **g**? number *optional* ― Green | ***Range:*** (0, 1) | ***Default:*** **owner.tooltipData.lines[*index*].color.g**
	--- 			- **b**? number *optional* ― Blue | ***Range:*** (0, 1) | ***Default:*** **owner.tooltipData.lines[*index*].color.b**
	--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** **owner.tooltipData.lines[*index*].wrap** or true
	--- - **anchor**? TooltipAnchor *optional* ― [GameTooltip anchor](https://wowpedia.fandom.com/wiki/API_GameTooltip_SetOwner#Arguments) | ***Default:*** **owner.tooltipData.anchor**
	--- - **offset**? table *optional* ― Values to offset the position of **tooltip** by | ***Default:*** **owner.tooltipData.offset**
	--- 	- **x**? number *optional* — ***Default:*** **owner.tooltipData.offset.x** or 0
	--- 	- **y**? number *optional* — ***Default:*** **owner.tooltipData.offset.y** or 0
	--- - **position**? table *optional* ― Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via **t.anchor** | ***Default:*** **owner.tooltipData.position** or "TOPLEFT" if **tooltipData.anchor** == "ANCHOR_NONE"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- ***Note:*** **t.offset** will be used when calling [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) as well.
	--- - **flipColors**? boolean *optional* ― Flip the default color values of the title and the text lines | ***Default:*** **owner.tooltipData.flipColors** or false
	---@param clearLines? boolean Replace **owner.tooltipData.lines** with **tooltipData.lines** instead of adjusting existing values | ***Default:*** true if **tooltipData.lines** ~= nil
	---@param override? boolean Update **owner.tooltipData** values with corresponding values provided in **tooltipData** | ***Default:*** true
	wt.UpdateTooltip = function(owner, tooltipData, clearLines, override)
		if not owner.tooltipData then return end

		--Update the tooltip data
		tooltipData = tooltipData or {}
		if clearLines ~= false and tooltipData.lines then owner.tooltipData.lines = wt.Clone(tooltipData.lines) end
		tooltipData = wt.AddMissing(tooltipData, owner.tooltipData)
		if override ~= false then owner.tooltipData = wt.Clone(tooltipData) end

		--Position
		tooltipData.position = tooltipData.position or {}
		tooltipData.position.offset = tooltipData.offset or {}
		if tooltipData.anchor == "ANCHOR_NONE" then
			tooltipData.tooltip:SetOwner(owner, tooltipData.anchor)
			wt.SetPosition(tooltipData.tooltip, tooltipData.position)
		else tooltipData.tooltip:SetOwner(owner, tooltipData.anchor, tooltipData.position.offset.x or 0, tooltipData.position.offset.y or 0) end

		--Add title
		local titleColor = tooltipData.flipColors and colors.highlight or colors.normal
		tooltipData.tooltip:AddLine(tooltipData.title, titleColor.r, titleColor.g, titleColor.b, true)

		--Add textlines
		if tooltipData.lines then
			for i = 1, #tooltipData.lines do
				--Set FontString
				local left = tooltipData.tooltip:GetName() .. "TextLeft" .. i + 1
				local right = tooltipData.tooltip:GetName() .. "TextRight" .. i + 1
				local font = tooltipData.lines[i].font or "GameTooltipTextSmall"
				if not _G[left] or not _G[right] then
					tooltipData.tooltip:AddFontStrings(tooltipData.tooltip:CreateFontString(left, nil, font), tooltipData.tooltip:CreateFontString(right, nil, font))
				end
				_G[left]:SetFontObject(font)
				_G[left]:SetJustifyH("LEFT")
				_G[right]:SetFontObject(font)
				_G[right]:SetJustifyH("RIGHT")

				--Add textline
				local color = tooltipData.lines[i].color or (tooltipData.flipColors and colors.normal or colors.highlight)
				tooltipData.tooltip:AddLine(tooltipData.lines[i].text, color.r, color.g, color.b, tooltipData.lines[i].wrap ~= false)
			end
		end

		--Display or update the displayed tooltip
		tooltipData.tooltip:Show()
	end

	--[ Popup Dialogue Box ]

	---Create a popup dialogue with an accept function and cancel button
	---@param t table Parameters are to be provided in this table
	--- - **addon** string — The name of the addon's folder (the addon namespace not the display title)
	--- - **name** string — Appended to **t.addon** as a unique identifier key in the global **StaticPopupDialogs** table
	--- - **text** string — The text to display as the message in the popup window
	--- - **accept**? string *optional* — The text to display as the label of the accept button | ***Default:*** ***WidgetToolbox*.strings.misc.accept**
	--- - **cancel**? string *optional* — The text to display as the label of the cancel button | ***Default:*** ***WidgetToolbox*.strings.misc.cancel**
	--- - **alt**? string *optional* — The text to display as the label of the third alternative button
	--- - **onAccept**? function *optional* — Called when the accept button is pressed and an OnAccept event happens
	--- - **onCancel**? function *optional* — Called when the cancel button is pressed, the popup is overwritten (by another popup for instance) or the popup expires and an OnCancel event happens
	--- - **onAlt**? function *optional* — Called when the alternative button is pressed and an OnAlt event happens
	---@return string key The unique identifier key created for this popup in the global **StaticPopupDialogs** table used as the parameter when calling [StaticPopup_Show()](https://wowpedia.fandom.com/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://wowpedia.fandom.com/wiki/API_StaticPopup_Hide)
	wt.CreatePopup = function(t)
		local key = t.addon:upper() .. "_" .. t.name:gsub("%s+", "_"):upper()

		--Create the popup dialogue
		StaticPopupDialogs[key] = {
			text = t.text,
			button1 = t.accept or strings.misc.accept,
			button2 = t.cancel or strings.misc.cancel,
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
		t = t or {}

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
				offset = { x = -300, y = -100 }
			},
			keepInBounds = true,
			size = { width = 240, height = 90 },
			background = { color = { a = 0.9 }, },
		})
		_G[reloadFrame:GetName() .. "Title"]:SetPoint("TOPLEFT", 14, -14)
		_G[reloadFrame:GetName() .. "Description"]:SetPoint("TOPLEFT", _G[reloadFrame:GetName() .. "Title"], "BOTTOMLEFT", 0, -4)
		wt.SetMovability(reloadFrame, true)
		reloadFrame:SetFrameStrata("DIALOG")
		reloadFrame:IsToplevel(true)

		--Button: Reload
		wt.CreateButton({
			parent = reloadFrame,
			name = "ReloadButton",
			title = strings.reload.accept.label,
			tooltip = { lines = { { text = strings.reload.accept.tooltip, }, } },
			position = {
				anchor = "BOTTOMLEFT",
				offset = { x = 12, y = 12 }
			},
			size = { width = 120, },
			events = { OnClick = function() ReloadUI() end },
		})

		--Button: Close
		wt.CreateButton({
			parent = reloadFrame,
			name = "CancelButton",
			title = strings.misc.close,
			tooltip = { lines = { { text = strings.reload.cancel.tooltip, }, } },
			position = {
				anchor = "BOTTOMRIGHT",
				offset = { x = -12, y = 12 }
			},
			events = { OnClick = function() reloadFrame:Hide() end },
		})

		return reloadFrame
	end


	--[[ ART ELEMENTS ]]

	--[ Font ]

	---Create a new [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used when setting the look of a [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) using a [FontInstance](https://wowpedia.fandom.com/wiki/UIOBJECT_FontInstance)
	---@param t table Parameters are to be provided in this table
	--- - **name** string — A unique identifier name to set for the hew font object to be accessed by and referred to later
	--- 	- ***Note:*** If a font object with that name already exists, it will *not* be overwritten and its reference key will be returned.
	--- 	- ***Example:*** Access the reference to the font object created via the globals table
	--- 		```
	--- 		local customFont = _G["CustomFontName"]
	--- 		```
	--- - **template**? Font *optional* — An existing [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to copy as a baseline
	--- - **font**? table *optional* ― Table containing font properties used for [SetFont](https://wowpedia.fandom.com/wiki/API_FontInstance_SetFont) (overriding **t.template**)
	--- 	- **path** string ― Path to the font file relative to the WoW client directory
	--- 		- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Fonts/Font.ttf)
	--- 		- ***Note - File format:*** Font files must be in TTF or OTF format
	--- 	- **size** number ― The default display size of the new font object
	--- 	- **style**? string *optional* ― Comma separated string of styling flags: "OUTLINE"|"THICKOUTLINE"|"THINOUTLINE"|"MONOCHROME" .. | ***Default:*** *style defined by the template*
	--- - **color**? table *optional* — Apply the specified color to the font (overriding **t.template**)
	--- 	- **r**? number *optional* ― Red | ***Range:*** (0, 1) | ***Default:*** 1
	--- 	- **g**? number *optional* ― Green | ***Range:*** (0, 1) | ***Default:*** 1
	--- 	- **b**? number *optional* ― Blue | ***Range:*** (0, 1) | ***Default:*** 1
	--- 	- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- - **spacing**? number *optional* — Set the character spacing of the text using this font (overriding **t.template**) | ***Default:*** 0
	--- - **shadow**? table *optional* — Set a text shadow with the following parameters (overriding **t.template**)
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― Horizontal offset value | ***Default:*** 0
	--- 		- **y**? number *optional* ― Vertical offset value | ***Default:*** 0
	--- 	- **color**? *optional* — Apply the specified color to the text shadow
	--- 		- **r**? number *optional* ― Red | ***Range:*** (0, 1) | ***Default:*** 0
	--- 		- **g**? number *optional* ― Green | ***Range:*** (0, 1) | ***Default:*** 0
	--- 		- **b**? number *optional* ― Blue | ***Range:*** (0, 1) | ***Default:*** 0
	--- 		- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- - **justify**? string *optional* — Set the justification of the text using font (overriding **t.template**)
	--- 	- **h**? string *optional* — Horizontal alignment: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "CENTER"
	--- 	- **v**? string *optional* — Vertical alignment: "TOP"|"BOTTOM"|"MIDDLE" | ***Default:*** "MIDDLE"
	--- - **wrap**? boolean *optional* — Whether or not to allow the text lines using this font to wrap (overriding **t.template**) | ***Default:*** true
	---@return string name, FontObject font
	wt.CreateFont = function(t)
		if _G[t.name] then return t.name, _G[t.name] end

		--[ Font Setup ]

		--Create the new font object
		local font = CreateFont(t.name)
		if t.template then font:CopyFontObject(t.template) end

		--Set display font
		if t.font then font:SetFont(t.font.path, t.font.size, t.font.style) end

		--Set appearance
		if t.color then font:SetTextColor(wt.UnpackColor(wt.AddMissing(t.color, { r = 1, g = 1, b = 1 }))) end
		if t.spacing then font:SetSpacing(t.spacing) end
		if t.shadow then
			font:SetShadowOffset(t.shadow.offset.x or 1, t.shadow.offset.y)
			font:SetShadowColor(wt.UnpackColor(wt.AddMissing(t.shadow.color, { r = 0, g = 0, b = 0 })))
		end

		--Set text positioning
		if t.justify then
			if t.justify.h then font:SetJustifyH(t.justify.h) end
			if t.justify.v then font:SetJustifyV(t.justify.v) end
		end
		if t.wrap == false then font:SetIndentedWordWrap(false) end

		return t.name, font
	end

	--Create a custom disabled font for Classic
	if select(4, GetBuildInfo()) < 100000 then wt.CreateFont({
		name = "GameFontDisableMed2",
		template = "GameFontHighlightMedium",
		color = wt.PackColor(GameFontDisable:GetTextColor()),
	}) end

	--[ Text ]

	---Create a [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) with the specified parameters
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame ― The frame to create the text in
	--- - **name**? string *optional* — String appended to the name of **t.parent** used to set the name of the new [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "Text"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional*
	--- - **layer**? Layer *optional* ― Draw [Layer](https://wowpedia.fandom.com/wiki/Layer)
	--- - **text**? string *optional* ― Text to be shown
	--- - **font**? string *optional* — Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormal"
	--- 	- ***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).
	--- - **color**? table *optional* — Apply the specified color to the text (overriding **t.font**)
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- - **justify**? string *optional* — Set the justification of the text (overriding **t.font**)
	--- 	- **h**? string *optional* — Horizontal alignment: "LEFT"|"RIGHT"|"CENTER"
	--- 	- **v**? string *optional* — Vertical alignment "TOP"|"BOTTOM"|"MIDDLE"
	--- - **wrap**? boolean *optional* — Whether or not to allow the text lines to wrap (overriding **t.font**) | ***Default:*** true
	---@return FontString text
	wt.CreateText = function(t)
		local text = t.parent:CreateFontString(t.parent:GetName() .. (t.name and t.name:gsub("%s+", "") or "Text"), t.layer, t.font and t.font or "GameFontNormal")

		--Position & dimensions
		wt.SetPosition(text, t.position)
		if t.width then text:SetWidth(t.width) end

		--Font & text
		if t.color then text:SetTextColor(wt.UnpackColor(t.color)) end
		if t.justify then
			if t.justify.h then text:SetJustifyH(t.justify.h) end
			if t.justify.v then text:SetJustifyV(t.justify.v) end
		end
		if t.wrap == false then text:SetWordWrap(false) end
		if t.text then text:SetText(t.text) end

		return text
	end

	---Add a title & description to a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame ― The frame panel to add the title & description to
	--- - **title**? table *optional*
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **offset**? table *optional* ― The offset from the anchor point relative to the specified frame
	--- 		- **x**? number *optional* ― Horizontal offset value | ***Default:*** 0
	--- 		- **y**? number *optional* ― Vertical offset value | ***Default:*** 0
	--- 	- **width**? number *optional* — ***Default:*** *width of the parent frame*
	--- 	- **text** string ― Text to be shown as the main title of the frame
	--- 	- **font**? string *optional* — Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormal"
	--- 		- ***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).
	--- 	- **color**? table *optional* — Apply the specified color to the title (overriding **t.title.font**)
	--- 		- **r** number ― Red | ***Range:*** (0, 1)
	--- 		- **g** number ― Green | ***Range:*** (0, 1)
	--- 		- **b** number ― Blue | ***Range:*** (0, 1)
	--- 		- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- 	- **justify**? string *optional* — Set the horizontal alignment of the text: "LEFT"|"RIGHT"|"CENTER" (overriding **t.title.font**) | ***Default:*** "LEFT"
	--- - **description**? table *optional*
	--- 	- **offset**? table *optional* ― The offset from the "BOTTOMLEFT" point of the main title
	--- 		- **x**? number *optional* ― Horizontal offset value | ***Default:*** 0
	--- 		- **y**? number *optional* ― Vertical offset value | ***Default:*** 0
	--- 	- **width**? number *optional* — ***Default:*** *width of the parent frame*
	--- 	- **text** string ― Text to be shown as the description of the frame
	--- 	- **font**? string *optional* — Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontHighlightSmall"
	--- 		- ***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).
	--- 	- **color**? table *optional* — Apply the specified color to the description (overriding **t.description.font**)
	--- 		- **r** number ― Red | ***Range:*** (0, 1)
	--- 		- **g** number ― Green | ***Range:*** (0, 1)
	--- 		- **b** number ― Blue | ***Range:*** (0, 1)
	--- 		- **a** number ― Opacity | ***Range:*** (0, 1)
	--- 	- **justify**? string *optional* — Set the horizontal alignment of the text: "LEFT"|"RIGHT"|"CENTER" (overriding **t.description.font**) | ***Default:*** "LEFT"
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
			layer = "ARTWORK",
			text = t.title.text,
			font =  t.title.font,
			color = t.title.color,
			justify = { h = t.title.justify or "LEFT", },
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
			layer = "ARTWORK",
			text = t.description.text,
			font =  t.description.font or "GameFontHighlightSmall",
			color = t.description.color,
			justify = { h = t.description.justify or "LEFT", },
		}) or nil

		return title, description
	end

	---Add a title & description to a container frame
	---@param contextMenu Frame Reference to the context menu to add this label to
	---@param t table Parameters are to be provided in this table
	--- - **text** string ― Text to be shown as the main title of the frame
	--- - **font**? string *optional* — Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormalSmall"
	--- 	- ***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).
	--- - **color**? table *optional* — Apply the specified color to the title (overriding **t.font**)
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	--- - **justify**? string *optional* — Set the horizontal alignment of the text: "LEFT"|"RIGHT"|"CENTER" (overriding **t.font**) | ***Default:*** "LEFT"
	---@return FontString label
	wt.AddContextLabel = function(contextMenu, t)
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
			layer = "ARTWORK",
			text = t.text,
			font = t.font or "GameFontNormalSmall",
			color = t.color,
			justify = { h = t.justify or "LEFT", },
		})

		--Add to the context menu
		table.insert(contextMenu.items, label)

		return label
	end

	--[ Texture Image ]

	---Create a [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture) image object
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture)
	--- - **name**? string *optional* — String appended to the name of **t.parent** used to set the name of the new [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture) | ***Default:*** "Texture"
	--- 	- ***Note:*** Space characters will be removed.
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
	--- 		- @*param* `self` Frame ― Reference to **updates[*key*].frame**
	--- 		- @*param* `...` any ― Any leftover arguments will be passed from the handler script to **updates[*key*].rule**
	--- 		- @*return* `data` table *optional* ― Parameters to update the texture with
	--- 			- **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with
	--- 				- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** **t.position.anchor**
	--- 				- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional* — ***Default:*** **t.position.relativeTo**
	--- 				- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** **t.position.relativePoint**
	--- 				- **offset**? table *optional* — ***Default:*** **t.position.offset**
	--- 					- **x**? number *optional* — ***Default:*** **t.position.offset.x**
	--- 					- **y**? number *optional* — ***Default:*** **t.position.offset.y**
	--- 			- **size**? table *optional*
	--- 				- **width**? number *optional* | ***Default:*** **t.size.width**
	--- 				- **height**? number *optional* | ***Default:*** **t.size.height**
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

	--[ Basic Frame ]

	---Create & set up a new basic frame
	---@param t table Parameters are to be provided in this table
	--- - **parent**? Frame *optional* ― Reference to the frame to set as the parent of the new frame | ***Default:*** nil *(parentless frame)*
	--- 	- ***Note:*** You may use [Region:SetParent(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegion_SetParent) to set the parent frame later.
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** nil *(anonymous frame)*
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true if **t.name** ~= nil and **t.parent** ~= nil and **t.parent** ~= UIParent
	--- - **customizable**? boolean *optional* ― Create the frame with `BackdropTemplateMixin and "BackdropTemplate"` to be easily customizable | ***Default:*** false
	--- 	- ***Note:*** You may use ***WidgetToolbox*.SetBackdrop(...)** to set up the backdrop quickly.
	--- - **container**? boolean *optional* — Whether or not to add child frame arrangement support to the frame turning it to a container | ***Default:*** false
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **keepInBounds**? boolean *optional* — Whether to keep the frame within screen bounds whenever it's moved | ***Default:*** false
	--- - **frameStrata**? FrameStrata *optional* — Screen layer to pin the frame to
	--- - **frameLevel**? integer *optional* — Layer to appear in within the specified **t.frameStrata**
	--- - **keepOnTop**? boolean — Whether to raise the frame level on mouse interaction | ***Default:*** false
	--- - **size**? table *optional*
	--- 	- **width**? number *optional* — ***Default:*** 0 *(no width)*
	--- 	- **height**? number *optional* — ***Default:*** 0 *(no height)*
	--- - **events**? table *optional* — Table of key, value pairs that holds script event handlers to be set for the frame
	--- 	- **[*key*]** scriptType — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers)
	--- 		- ***Note:*** "[OnEvent](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEvent)" handlers specified here will not be set. Handler functions for specific global events should be specified in the **t.onEvent** table.
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- - **onEvent**? table *optional* — Table of key, value pairs that holds global event tags & their corresponding event handlers to be registered for the frame
	--- 	- **[*key*]** WowEvent — Global [Event](https://wowpedia.fandom.com/wiki/Events) tag registrable via [Frame:RegisterEvent(...)](https://wowpedia.fandom.com/wiki/API_Frame_RegisterEvent) for the frame
	--- 	- **[*value*]** function — The handler function to be called when the specific global event is triggered
	--- 		- @*param* `self` Frame — Reference to the new frame
	--- 		- @*param* `...` any — Leftover arguments carried by the specific event will be passed to the handler script
	--- 		- ***Note:*** You may want to include [Frame:UnregisterEvent(...)](https://wowpedia.fandom.com/wiki/API_Frame_UnregisterEvent) to prevent the handler function to be executed again.
	--- 		- ***Example:*** "[ADDON_LOADED](https://wowpedia.fandom.com/wiki/ADDON_LOADED)" is fired repeatedly after each addon. To call the handler only after one specified addon is loaded, you may check the parameter the handler is called with. It's a good idea to unregister the event to prevent repeated calling for every other addon after the specified one has been loaded already.
	--- 			```
	--- 			function(self, addon)
	--- 				if addon ~= "AddonNameSpace" then return end --Replace "AddonNameSpace" with the namespace of the specific addon to watch
	--- 				self:UnregisterEvent("ADDON_LOADED")
	--- 				--Do something
	--- 			end
	--- 			```
	--- - **initialize**? function *optional* ― Call this function while setting up the new frame to perform specific tasks like creating content child frames right away
	--- 	- @*param* `frame` Frame ― Reference to the new frame
	--- - **arrangement**? table *optional* ― If set, arrange the content added to the frame via **t.initialize** into stacked rows based on the parameters provided
	--- 	- **margins**? table *optional* — Inset the content inside the frame by the specified amount on each side
	--- 		- **l**? number *optional* — Space to leave on the left side | ***Default:*** 12
	--- 		- **r**? number *optional* — Space to leave on the right side (doesn't need to be negated) | ***Default:*** 12
	--- 		- **t**? number *optional* — Space to leave at the top (doesn't need to be negated) | ***Default:*** 12
	--- 		- **b**? number *optional* — Space to leave at the bottom | ***Default:*** 12
	--- 	-  **gaps**? number *optional* — The amount of space to leave between rows | ***Default:*** 8
	--- 	-  **flip**? boolean *optional* — Fill the rows from right to left instead of left to right | ***Default:*** false
	--- 	-  **resize**? boolean *optional* — Set the height of the frame to match the space taken up by the arranged content (including margins) | ***Default:*** true
	---@return Frame frame
	wt.CreateFrame = function(t)
		t = t or {}

		local name = t.name and (((t.append or (t.parent and t.parent ~= UIParent)) and t.parent:GetName() or "") .. t.name:gsub("%s+", "")) or nil
		local template = t.customizable and (BackdropTemplateMixin and "BackdropTemplate") or nil

		--[ Frame Setup ]

		--Create the panel frame
		local frame = CreateFrame("Frame", name, t.parent, template)

		--Position & dimensions
		if t.keepInBounds then frame:SetClampedToScreen(true) end
		if t.position then wt.SetPosition(frame, t.position) end
		if t.size then frame:SetSize(t.size.width or 0, t.size.height or 0) end

		--Visibility
		if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
		if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
		if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

		--[ Events & Behavior ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do frame:HookScript(key, value) end end

		--Pass global events to handlers
		frame:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)

		--Register global event handlers
		if t.onEvent then for key, value in pairs(t.onEvent) do
			frame:RegisterEvent(key)
			frame[key] = function(...) value(...) end
		end end

		--[ Initialization ]

		--Add content, performs tasks
		if t.initialize then
			t.initialize(frame)

			--Arrange content
			if t.arrangement then wt.ArrangeContent(frame, t.arrangement.margins, t.arrangement.gaps, t.arrangement.flip, t.arrangement.resize) end
		end

		return frame
	end

	--[ Scrollable Frame ]

	---Set the parameters of a classic scrollbar
	---@param scrollFrame ScrollFrame Reference to the scrollable frame to set up
	local function SetClassicScrollBar(scrollFrame)
		local name = scrollFrame:GetName().. "ScrollBar"

		--[ Frame Setup ]

		--Set scrollbar & button elements
		_G[name .. "ScrollUpButton"]:ClearAllPoints()
		_G[name .. "ScrollUpButton"]:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", -2, -3)
		_G[name .. "ScrollDownButton"]:ClearAllPoints()
		_G[name .. "ScrollDownButton"]:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", -2, 3)
		_G[name]:ClearAllPoints()
		_G[name]:SetPoint("TOP", _G[name .. "ScrollUpButton"], "BOTTOM", 0, 3)
		_G[name]:SetPoint("BOTTOM", _G[name .. "ScrollDownButton"], "TOP", 0, -3)

		--[ Add Scrollbar Background ]

		--Create the background frame
		local scrollBarBG = CreateFrame("Frame", name .. "Background", _G[name],  BackdropTemplateMixin and "BackdropTemplate")

		--Position & dimensions
		scrollBarBG:SetPoint("TOPLEFT", -1, -3)
		scrollBarBG:SetSize(_G[name]:GetWidth() + 1,  scrollFrame:GetHeight() - 39)

		--Backdrop
		wt.SetBackdrop(scrollBarBG, {
			background = {
				texture = {
					size = 5,
					insets = { l = 2, r = 2, t = 2, b = 2 },
				},
				color = { r = 0.2, g = 0.2, b = 0.2, a = 0.4 }
			},
			border = {
				texture = { width = 12, },
				color = { r = 0.4, g = 0.4, b = 0.4, a = 0.8 }
			}
		})

		--Set scrollbar visibility
		_G[name]:SetFrameLevel(_G[name]:GetFrameLevel() + 1)
		scrollBarBG:SetFrameLevel(_G[name]:GetFrameLevel() - 1)
	end

	---Create an empty vertically scrollable frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to place the scrollable frame into
	--- - **name**? string *optional* — Unique string used to set the name of the new scroll frame | ***Default:*** "ScrollFrame"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **scrollName**? string *optional* — Unique string used to set the name of the scrolling child frame | ***Default:*** "ScrollChild"
	--- 	- ***Note:*** Space characters will be removed.
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
	--- 	- **width**? number *optional* — Horizontal size of the scrollable child frame | ***Default:*** **t.size.width** - (***WidgetTools*.classic** and 22 or 16)
	--- 	- **height** number *optional* — Vertical size of the scrollable child frame | ***Default:*** 0 *(no height)*
	--- - **scrollSpeed**? number *optional* — Percentage of one page of content to scroll at a time | ***Range:*** (0, 1) | ***Default:*** 0.25
	--- 	- ***Note:*** If ***WidgetTools*.classic** is true, **t.scrollSpeed** is used as the scroll step value of the classic scroll frames. | ***Default:*** *half of the height of the scrollbar*
	--- - **initialize**? function *optional* ― Call this function while setting up the new scrollable frame to perform specific tasks like creating content child frames right away
	--- 	- @*param* `scrollChild` Frame ― Reference to the new scrollable child frame
	--- - **arrangement**? table *optional* ― If set, arrange the content added to the scrollable child frame via **t.initialize** into stacked rows based on the parameters provided
	--- 	- **margins**? table *optional* — Inset the content inside the scrollable child frame by the specified amount on each side
	--- 		- **l**? number *optional* — Space to leave on the left side | ***Default:*** 12
	--- 		- **r**? number *optional* — Space to leave on the right side (doesn't need to be negated) | ***Default:*** 12
	--- 		- **t**? number *optional* — Space to leave at the top (doesn't need to be negated) | ***Default:*** 12
	--- 		- **b**? number *optional* — Space to leave at the bottom | ***Default:*** 12
	--- 	-  **gaps**? number *optional* — The amount of space to leave between rows | ***Default:*** 8
	--- 	-  **flip**? boolean *optional* — Fill the rows from right to left instead of left to right | ***Default:*** false
	--- 	-  **resize**? boolean *optional* — Set the height of the scrollable child frame to match the space taken up by the arranged content (including margins) | ***Default:*** true
	---@return Frame scrollChild
	---@return ScrollFrame scrollFrame
	wt.CreateScrollFrame = function(t)
		local name = t.parent:GetName() .. (t.name and  t.name:gsub("%s+", "") or "ScrollFrame")

		--[ Frame Setup ]

		--Create the scroll frame
		local scrollFrame = CreateFrame("ScrollFrame", name, t.parent, wt.classic and "UIPanelScrollFrameTemplate" or (ScrollControllerMixin and "ScrollFrameTemplate"))

		--Position & dimensions
		wt.SetPosition(scrollFrame, t.position)
		t.size = t.size or { width = t.parent:GetWidth(), height = t.parent:GetHeight() }
		scrollFrame:SetSize(t.size.width, t.size.height)

		--Scrollbar setup
		if not wt.classic then
			--Scrollbar position & dimensions
			wt.SetPosition(scrollFrame.ScrollBar, {
				anchor = "RIGHT",
				relativeTo = scrollFrame,
				relativePoint = "RIGHT",
				offset = { x = -4, y = 0 }
			})
			scrollFrame.ScrollBar:SetHeight(t.size.height - 4)
		else SetClassicScrollBar(scrollFrame) end

		--[ Scroll Child ]

		--Create scrollable child frame
		local scrollChild = wt.CreateFrame({
			parent = scrollFrame,
			name = t.scrollName and t.scrollName:gsub("%s+", "") or "ScrollChild",
			size = { width = t.scrollSize.width or scrollFrame:GetWidth() - (wt.classic and 22 or (wt.preDF and 32 or 16)), height = t.scrollSize.height },
			initialize = t.initialize,
			arrangement = t.arrangement
		})

		--Register for scroll
		scrollFrame:SetScrollChild(scrollChild)

		--Update scroll speed
		if not wt.classic then
			t.scrollSpeed = t.scrollSpeed or 0.25

			--Override the built-in update function
			scrollFrame.ScrollBar.SetPanExtentPercentage = function() --TODO: Change when Blizzard provides a better way
				local height = scrollFrame:GetHeight()
				scrollFrame.ScrollBar.panExtentPercentage = height * t.scrollSpeed / math.abs(scrollChild:GetHeight() - height)
			end
		elseif t.scrollSpeed then _G[name .. "ScrollBar"].scrollStep = t.scrollSpeed end

		return scrollChild, scrollFrame
	end

	--[ Panel Frame ]

	---Create a new simple panel frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new panel
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Panel"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown as the title of the panel | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above to the panel | ***Default:*** true
	--- - **description**? string *optional* — Text to be shown as the subtitle or description of the panel | ***Default:*** *no description*
	--- - **arrange**? table *optional* ― When set, automatically position the panel in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the panel into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the panel in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the panel at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **keepInBounds**? boolean *optional* — Whether to keep the panel within screen bounds whenever it's moved | ***Default:*** false
	--- - **size**? table *optional*
	--- 	- **width**? number *optional* — ***Default:*** *width of the parent frame* - 32
	--- 	- **height**? number *optional* — ***Default:*** 0 *(no height)*
	--- 		- ***Note:*** If content is added, arranged and **t.arrangeContent.resize** is true, the height will be set dynamically based on the calculated height of the content.
	--- - **background**? table *optional* ― Table containing the parameters used for the background
	--- 	- **texture**? table *optional* ― Parameters used for setting the background texture
	--- 		- **path**? string *optional* ― Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/ChatFrame/ChatFrameBackground"
	--- 			- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 			- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 			- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- 		- **size** number — Size of a single background tile square | ***Default:*** 5
	--- 		- **tile**? boolean *optional* — Whether to repeat the texture to fill the entire size of the frame | ***Default:*** true
	--- 		- **insets**? table *optional* ― Offset the position of the background texture from the edges of the frame inward
	--- 			- **l**? number *optional* — ***Default:*** 4
	--- 			- **r**? number *optional* — ***Default:*** 4
	--- 			- **t**? number *optional* — ***Default:*** 4
	--- 			- **b**? number *optional* — ***Default:*** 4
	--- 	- **color**? table *optional* — Apply the specified color to the background texture
	--- 		- **r** number ― Red | ***Range:*** (0, 1) | ***Default:*** 0.175
	--- 		- **g** number ― Green | ***Range:*** (0, 1) | ***Default:*** 0.175
	--- 		- **b** number ― Blue | ***Range:*** (0, 1) | ***Default:*** 0.175
	--- 		- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 0.45
	--- - **border**? table *optional* ― Table containing the parameters used for the border
	--- 	- **texture**? table *optional* ― Parameters used for setting the border texture
	--- 		- **path**? string *optional* ― Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/Tooltips/UI-Tooltip-Border"
	--- 			- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga)
	--- 			- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format
	--- 			- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client
	--- 		- **width** number — Width of the backdrop edge | ***Default:*** 16
	--- 	- **color**? table *optional* — Apply the specified color to the border texture
	--- 		- **r** number ― Red | ***Range:*** (0, 1) | ***Default:*** 0.75
	--- 		- **g** number ― Green | ***Range:*** (0, 1) | ***Default:*** 0.75
	--- 		- **b** number ― Blue | ***Range:*** (0, 1) | ***Default:*** 0.75
	--- 		- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 0.5
	--- - **initialize**? function *optional* ― Call this function while setting up the new panel to perform specific tasks like creating content child frames right away
	--- 	- @*param* `panel` Frame ― Reference to the new panel frame
	--- - **arrangement**? table *optional* ― If set, arrange the content added to the panel via **t.initialize** into stacked rows based on the parameters provided
	--- 	- **margins**? table *optional* — Inset the content inside the panel by the specified amount on each side
	--- 		- **l**? number *optional* — Space to leave on the left side | ***Default:*** 12
	--- 		- **r**? number *optional* — Space to leave on the right side (doesn't need to be negated) | ***Default:*** 12
	--- 		- **t**? number *optional* — Space to leave at the top (doesn't need to be negated) | ***Default:*** **t.description** and 30 or 12
	--- 		- **b**? number *optional* — Space to leave at the bottom | ***Default:*** 12
	--- 	-  **gaps**? number *optional* — The amount of space to leave between rows | ***Default:*** 8
	--- 	-  **flip**? boolean *optional* — Fill the rows from right to left instead of left to right | ***Default:*** false
	--- 	-  **resize**? boolean *optional* — Set the height of the panel to match the space taken up by the arranged content (including margins) | ***Default:*** true
	---@return Frame panel
	wt.CreatePanel = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Panel")

		--[ Frame Setup ]

		--Create the panel frame
		local panel = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

		--Position & dimensions
		if t.arrange then panel.arrangementInfo = t.arrange else wt.SetPosition(panel, t.position) end
		if t.keepInBounds then panel:SetClampedToScreen(true) end
		t.size = t.size or {}
		panel:SetSize(t.size.width or t.parent:GetWidth() - 32, t.size.height or 0)

		--Title & description
		local _, description = wt.AddTitle({
			parent = panel,
			title = t.label ~= false and {
				offset = { x = 10, y = 16 },
				text = t.title or t.name or "Panel",
			} or nil,
			description = t.description and {
				offset = { x = 4, y = -16 },
				text = t.description,
			} or nil
		})

		--Backdrop
		wt.SetBackdrop(panel, {
			background = wt.AddMissing(t.background, {
				texture = {
					size = 5,
					insets = { l = 4, r = 4, t = 4, b = 4 },
				},
				color = { r = 0.175, g = 0.175, b = 0.175, a = 0.45 }
			}),
			border = wt.AddMissing(t.border, {
				texture = { width = 16, },
				color = { r = 0.75, g = 0.75, b = 0.75, a = 0.5 }
			})
		})

		--[ Initialization ]

		--Add content, performs tasks
		if t.initialize then
			t.initialize(panel)

			--Arrange content
			if t.arrangement then wt.ArrangeContent(panel, wt.AddMissing(
				t.arrangement.margins, { l = 12, r = 12, t = description and 30 or 12, b = 12 }
			), t.arrangement.gaps, t.arrangement.flip, t.arrangement.resize) end
		end


		return panel
	end

	--[ Context Menu ]

	---Create an empty context menu frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new context menu
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "ContextMenu"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
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
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically activate or deactivate the context menu based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	---@return Frame contextMenu A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - ***Note:*** Annotate `@type contextMenu` for detailed function descriptions.
	--- - **isEnabled** function — Check if the context menu is active
	--- - **setEnabled** function — Activate or deactivate the context menu
	--- - **items** table — The list references of the content items added to this context menu
	--- - **submenus** table — The list references of the submenus folding out of this context menu
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when the context menu is opened or closed
	--- 		- @*param* `self` Frame ― Reference to the context menu frame
	--- 		- @*param* `attribute` = "open" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― True if the context menu is open, false if not
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

		---Create the context menu frame
		---@class contextMenu
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
					insets = { l = 4, r = 4, t = 4, b = 4 },
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

		--Base state
		contextMenu:Hide()
		contextMenu:SetAttributeNoHandler("open", false)

		--Events & behavior
		t.parent:HookScript("OnMouseUp", function(_, button, isInside)
			if not enabled then return end
			if button == "RightButton" and isInside then
				contextMenu:RegisterEvent("GLOBAL_MOUSE_DOWN")

				--Open the menu
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

				--Close the menu
				contextMenu:Hide()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end
		end
		contextMenu:HookScript("OnShow", function() contextMenu:SetAttribute("open", true) end)
		contextMenu:HookScript("OnHide", function() contextMenu:SetAttribute("open", false) end)

		--[ Getters, Setters & Holders ]

		---Check if the context menu is active
		---@return boolean
		contextMenu.isEnabled = function() return enabled end

		---Activate or deactivate the context menu
		---@param state? boolean Activate it if true, deactivate if not | ***Default:*** true
		contextMenu.setEnabled = function(state)
			enabled = state ~= false
			if not enabled then
				contextMenu:UnregisterEvent("GLOBAL_MOUSE_DOWN")
				contextMenu:UnregisterEvent("GLOBAL_MOUSE_UP")

				--Close the menu
				contextMenu:Hide()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end
		end

		--The list references of the content items added to this context menu
		contextMenu.items = {}

		--The list references of the submenus folding out of this context menu
		contextMenu.submenus = {}

		return contextMenu
	end

	---Create an empty submenu as an item for an existing context menu
	---@param contextMenu Frame Reference to the context menu to add this submenu to
	---@param t table Parameters are to be provided in this table
	--- - **name**? string *optional* — Unique string to append this to the name of **contextMenu** when setting the name | ***Default:*** "Item" *followed by the the increment of the last index of* **contextMenu.items**
	--- 	- ***Note:*** Space characters will be removed.
	--- - **title**? string *optional* — Text to be shown as the label on the toggle item representing the submenu in the **contextMenu** list | ***Default:*** **t.name**
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the toggle button acting as the trigger item for the submenu displayed when mousing over the frame
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
	--- - **font**? string *optional* — Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontHighlightSmall"
	--- 	- ***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).
	--- - **justify**? string *optional* — Set the horizontal alignment of the label: "LEFT"|"RIGHT"|"CENTER" (overriding **t.font**) | ***Default:*** "LEFT"
	--- - **leftSide**? boolean *optional* — Open the submenu on the left instead of the right | ***Default:*** true if **t.justify** is "RIGHT"
	---@return Frame submenu
	--- - **open** function — Open the submenu
	--- - **close** function — Close the submenu
	--- - **items** table — The list references of the content items added to this submenu
	--- - **submenus** table — The list references of the submenus folding out of this submenu
	---@return Button toggle
	wt.AddContextSubmenu = function(contextMenu, t)
		t = t or {}

		local defaultName = "Item" .. #contextMenu.items + 1
		local name = contextMenu:GetName() .. (t.name and t.name:gsub("%s+", "") or defaultName)
		local title = t.title or t.name or defaultName

		--[ Toggle Item ]

		--Create the submenu trigger frame
		local toggle = CreateFrame("Button", name, contextMenu, BackdropTemplateMixin and "BackdropTemplate")

		--Add to the context menu
		table.insert(contextMenu.items, toggle)

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
			font = t.font or "GameFontHighlightSmall",
			justify = { h = t.justify or t.leftSide and "RIGHT" or "LEFT", },
		})

		--Texture: Arrow
		wt.CreateText({
			parent = toggle,
			name = "Arrow",
			position = {
				anchor = (t.leftSide or t.justify == "RIGHT") and "LEFT" or "RIGHT",
				offset = { x = (t.leftSide or t.justify == "RIGHT") and 2 or -2, }
			},
			width = 10,
			text = (t.leftSide or t.justify == "RIGHT") and "◄" or "►",
			font = t.font or "ChatFontSmall",
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
			OnEnter = { rule = function() return { color = IsMouseButtonDown() and colors.context.click or colors.context.highlight } end },
			OnLeave = {},
			OnHide = {},
			OnMouseDown = { rule = function() return { color = colors.context.click } end },
			OnMouseUp = { rule = function(self) return self:IsMouseOver() and { color = colors.context.highlight } or {} end },
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
			wt.AddTooltip(toggle, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_TOPLEFT",
				offset = { x = 20, },
			}, { triggers = { hoverTarget, }, })
		end

		--[ Flyout Menu ]

		--Create the context submenu frame
		local submenu = CreateFrame("Frame", name .. "Menu", contextMenu, BackdropTemplateMixin and "BackdropTemplate")

		--Add to the context menu
		table.insert(contextMenu.submenus, submenu)

		--Visibility
		submenu:SetFrameStrata("DIALOG")
		submenu:SetFrameLevel(contextMenu:GetFrameLevel() + 1)

		--Position & dimensions
		submenu:SetClampedToScreen(true)
		submenu:SetPoint((t.leftSide or t.justify == "RIGHT") and "TOPRIGHT" or "TOPLEFT", toggle, (t.leftSide or t.justify == "RIGHT") and "TOPLEFT" or "TOPRIGHT", 0, 10)
		submenu:SetSize(t.width or 140, 20)

		--Backdrop
		wt.SetBackdrop(submenu, {
			background = {
				texture = {
					size = 5,
					insets = { l = 4, r = 4, t = 4, b = 4 },
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
			for i = 1, #submenu.items do if submenu.items[i]:IsMouseOver() then return true end end
			return false
		end

		--[ Toggle ]

		--Base state
		submenu:Hide()
		submenu:SetAttributeNoHandler("open", false)

		--Utilities
		submenu.open = function()
			for i = 1, #contextMenu.submenus do contextMenu.submenus[i].close() end
			submenu:Show()

			--Set attribute
			submenu:SetAttribute("open", true)
		end
		submenu.close = function()
			submenu:Hide()

			--Set attribute
			submenu:SetAttribute("open", false)
		end

		--Events & behavior
		if t.hover ~= false then toggle:HookScript("OnEnter", function() submenu.open() end) else toggle:HookScript("OnClick", function() if not submenu:IsVisible() then
			submenu.open()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		else
			submenu.close()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		end end) end
		submenu:HookScript("OnLeave", function() if not checkItems() then submenu.close() end end)
		contextMenu:HookScript("OnHide", function() submenu.close() end)

		--Item & submenu holder
		submenu.items = {}
		submenu.submenus = {}

		return submenu, toggle
	end

	---Create a classic context menu frame as a child of a frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new context menu
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "ContextMenu"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **anchor**? string|Region — The current cursor position or a region or frame reference | ***Default:*** 'cursor'
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

	--Collection of options pages referenced when restoring settings to their defaults
	local optionsPages = {}

	---Create an new Settings Panel frame and add it to the Options
	---@param t table Parameters are to be provided in this tables
	--- - **parent**? table|string *optional* — The options category page or its display name to be set as the parent category, making this its subcategory | ***Default:*** nil *(set as a main category)*
	--- - **addon** string — The name of the addon's folder (the addon namespace, not its displayed title)
	--- - **name**? string *optional* — Unique string used to set the name of the options frame | ***Default:*** **t.addon**
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name of the options category page, append **t.name** after **t.addon** | ***Default:*** true if **t.name** ~= nil
	--- - **appendOptions**? boolean *optional* — When setting the name of the canvas frame, append "Options" at the end as well | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown as the title of the options panel | ***Default:*** [GetAddOnMetadata(**t.addon**, "title")](https://wowpedia.fandom.com/wiki/API_GetAddOnMetadata)
	--- - **description**? string *optional* — Text to be shown as the description below the title of the options panel
	--- - **logo**? string *optional* — Path to the texture file, the logo of the addon to be added as to the top right corner of the panel
	--- - **titleLogo**? boolean *optional* — Append the texture specified as **t.logo** to the title of the Settings button as well | ***Default:*** false
	--- - **scroll**? table *optional* — If set, create an empty ScrollFrame for the category panel
	--- 	- **height**? number *optional* — Set the height of the scrollable child frame to the specified value | ***Default:*** 0 *(no height)*
	--- 	- **speed**? number *optional* — Percentage of one page of content to scroll at a time | ***Range:*** (0, 1) | ***Default:*** 0.25
	--- 		- ***Note:*** If ***WidgetTools*.classic** is true, **t.scroll.speed** is used as the scroll step value of the classic scroll frames. | ***Default:*** *half of the height of the scrollbar*
	--- - **optionsKeys**? table *optional* ― A list of unique keys linking collections of widget options data to be saved & loaded with this options category page
	--- 	- **[*value*]** any ― A unique key under which widget options data has been registered to options data management
	--- 	- ***Note:*** If **t.optionsKey** is not set, the automatic load will not be executed even if **t.autoLoad** is true.
	--- - **storage**? table *optional* — Table containing working and non-working table pairs to move data between when saving and loading settings
	--- 	- **[*value*]** table
	--- 		- **workingTable** — Options data to be modified as widget values are changed and saved
	--- 		- **storageTable** — A non-working storage database where data is committed to when all settings are saved and loaded back when settings are opened allowing changes to be reverted even when widget value changes are saved instantly (which is the default behavior)
	--- 		- **defaultsTable** — A static table containing all default settings values
	--- - **autoSave**? boolean *optional* — If true, automatically save all data on commit from the storage tables to the widgets described in the collection of options data referenced by **t.optionsKey** | ***Default:*** true if **t.optionsKey** ~= nil
	--- 	- ***Note:*** If **t.optionsKey** is not set, the automatic save will not be executed even if **t.autoSave** is true.
	--- - **autoLoad**? boolean *optional* — If true, automatically load the values of all widgets to the storage tables described in the collection of options data referenced by **t.optionsKey** | ***Default:*** true if **t.optionsKey** ~= nil
	--- - **onSave**? function *optional* — Function called after the settings linked to this page are saved by the user
	--- 	- @*param* `user` boolean *optional* — Marking whether the call is due to a user interaction or not | ***Default:*** false
	--- - **onLoad**? function *optional* — Function called after the settings linked to this page have been loaded
	--- 	- @*param* `user` boolean *optional* — Marking whether the call is due to a user interaction or not | ***Default:*** false
	--- - **onCancel**? function *optional* — Function called after the changes are scrapped by the user when "Revert Changes" is clicked
	--- 	- @*param* `user` boolean *optional* — Marking whether the call is due to a user interaction or not | ***Default:*** false
	--- - **onDefault**? function *optional* — Function called after settings are restored to their default values by the user when the "These Settings" (affecting this options category page only) or "All Settings" (affecting all options category pages within the **t.addon** namespace) is clicked in the dialogue opened via "Restore Defaults"
	--- 	- @*param* `user` boolean *optional* — Marking whether the call is due to a user interaction or not | ***Default:*** false
	--- - **initialize**? function *optional* ― Call this function while setting up the new category page to perform specific tasks like creating content child frames right away
	--- 	- @*param* `canvas` Frame ― Reference to the content holder frame (default canvas or a scrollable child frame if **t.scroll** is set)
	--- - **arrangement**? table *optional* ― If set, arrange the content added to the options panel via **t.initialize** into stacked rows based on the parameters provided
	--- 	- **margins**? table *optional* — Inset the content inside the options panel by the specified amount on each side
	--- 		- **l**? number *optional* — Space to leave on the left side | ***Default:*** ***WidgetTools*.classic** and 16 or 10
	--- 		- **r**? number *optional* — Space to leave on the right side (doesn't need to be negated) | ***Default:*** ***WidgetTools*.classic** and 16 or 10
	--- 		- **t**? number *optional* — Space to leave at the top (doesn't need to be negated) | ***Default:*** **t.scroll** and 78 or 82
	--- 		- **b**? number *optional* — Space to leave at the bottom | ***Default:*** **t.scroll** and (***WidgetTools*.classic** and 16 or 10) or 22
	--- 	-  **gaps**? number *optional* — The amount of space to leave between rows | ***Default:*** 32
	--- 	-  **flip**? boolean *optional* — Fill the rows from right to left instead of left to right | ***Default:*** false
	--- 	-  **resize**? boolean *optional* — Set the height of the options panel to match the space taken up by the arranged content (including margins) | ***Default:*** **t.scroll** ~= nil
	---@return table optionsPage Table containing references to the options category, its related functions & frames
	--- - ***Note:*** Annotate `@type optionsPage` for detailed function descriptions.
	--- - **open** function — Call to open the interface settings panel to this category page
	--- - **save** function — Call to force save the options in this category page
	--- - **load** function — Call to force update the options widgets in this category page
	--- - **cancel** function — Call to cancel any changes made in this category page
	--- - **default** function — Call to reset all options in this category page to their default values
	--- - **category** table — The settings category frame | ***Default:*** **canvas** *(if its a Classic client)*
	--- - **canvas** [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) — The options page frame to house the settings widgets
	--- - **scrollChild**? [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)|nil — Scrollable child frame of the ScrollFrame created as a child of **canvas** if **t.scroll** was set
	wt.CreateOptionsCategory = function(t)
		local name = (t.append ~= false and t.addon or "") .. (t.name and t.name:gsub("%s+", "") or t.addon)
		local title = t.title or wt.Clear(GetAddOnMetadata(t.addon, "title")):gsub("^%s*(.-)%s*$", "%1")
		local titleLogo =  t.logo and t.titleLogo and " |T" .. t.logo .. ":0|t" or ""

		---Create the options page holder table
		---@class optionsPage
		local optionsPage = {}

		--Add a reference to this options page table to the collection
		optionsPages[t.addon] = optionsPages[t.addon] or {}
		table.insert(optionsPages[t.addon], optionsPage)

		--[ Options Data Management Utilities ]

		---Call to force save the options in this category page
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		optionsPage.save = function(user)
			if t.autoSave ~= false and t.optionsKeys then for i = 1, #t.optionsKeys do wt.SaveOptionsData(t.optionsKeys[i]) end end
			if t.storage then for i = 1, #t.storage do wt.CopyValues(t.storage[i].workingTable, t.storage[i].storageTable) end end
			if t.onSave then t.onSave(user) end
		end

		---Call to force update the options widgets in this category page
		---@param changes? boolean Whether to call **onChange** handlers or not | ***Default:*** false
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		optionsPage.load = function(changes, user)
			if t.autoLoad ~= false and t.optionsKeys then for i = 1, #t.optionsKeys do wt.LoadOptionsData(t.optionsKeys[i], changes) end end
			if t.onLoad then t.onLoad(user) end
		end

		---Call to cancel any changes made in this category page
		---@param user boolean? Whether to mark the call as being the result of a user interaction | ***Default:*** false
		optionsPage.cancel = function(user)
			if t.storage then for i = 1, #t.storage do wt.CopyValues(t.storage[i].storageTable, t.storage[i].workingTable) end end
			if t.optionsKeys then for i = 1, #t.optionsKeys do wt.LoadOptionsData(t.optionsKeys[i], true) end end
			if t.onCancel then t.onCancel(user) end
		end

		---Call to reset all options in this category page to their default values
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		optionsPage.default = function(user)
			if t.storage then for i = 1, #t.storage do
				wt.CopyValues(t.storage[i].defaultsTable, t.storage[i].storageTable)
				wt.CopyValues(t.storage[i].defaultsTable, t.storage[i].workingTable)
			end end
			if t.optionsKeys then for i = 1, #t.optionsKeys do wt.LoadOptionsData(t.optionsKeys[i], true) end end
			if t.onDefault then t.onDefault(user) end
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
			optionsPage.category.name = title .. titleLogo

			--Set as a subcategory or a parent category
			if t.parent then optionsPage.category.parent = t.parent.name end

			--Event handlers
			optionsPage.category.okay = function() optionsPage.save(true) end
			optionsPage.category.refresh = function() optionsPage.load(nil, true) end
			optionsPage.category.cancel = function() optionsPage.cancel(true) end
			optionsPage.category.default = function() optionsPage.default(true) end

			--Add to the Interface options
			InterfaceOptions_AddCategory(optionsPage.category)
		else
			--Create the options canvas frame
			optionsPage.canvas = CreateFrame("Frame", name .. (t.appendOptions ~= false and "Options" or ""))

			--Dimensions
			optionsPage.canvas:SetSize(SettingsPanel.Container.SettingsCanvas:GetSize())

			--Event handlers
			optionsPage.canvas.OnCommit = function() optionsPage.save(true) end
			optionsPage.canvas.OnRefresh = function() optionsPage.load(nil, true) end
			optionsPage.canvas.OnDefault = function() optionsPage.default(true) end

			--Create the category or subcategory page
			if t.parent then optionsPage.category = Settings.RegisterCanvasLayoutSubcategory(t.parent, optionsPage.canvas, title .. titleLogo)
			else optionsPage.category = Settings.RegisterCanvasLayoutCategory(optionsPage.canvas, title .. titleLogo) end

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
				events = { OnClick = function() optionsPage.cancel(true) end, },
			})

			--Button & Popup: Default
			local defaultWarning = wt.CreatePopup({
				addon = t.addon,
				name = name .. "DefaultOptions",
				text = strings.options.warning:gsub("#TITLE", wt.Clear(GetAddOnMetadata(t.addon, "title")) .. (t.parent and (": " .. title) or "")),
				accept = strings.options.defaultThese,
				alt = strings.options.defaultAll,
				onAccept = function() optionsPage.default(true) end,
				onAlt = function() for i = 1, #optionsPages[t.addon] do optionsPages[t.addon][i].default() end end
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
		end

		--Title & description
		local label, description = wt.AddTitle({
			parent = optionsPage.canvas,
			title = {
				offset = { x = wt.classic and 16 or 10, y = -16 },
				width = optionsPage.canvas:GetWidth() - (t.logo and 72 or 32),
				text = title,
				font = "GameFontNormalLarge",
			},
			description = t.description and {
				offset = { y = -8 },
				width = optionsPage.canvas:GetWidth() - (t.logo and 72 or 32),
				text = t.description,
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
				size = { width = optionsPage.canvas:GetWidth() - (wt.classic and 4 or 8), height = optionsPage.canvas:GetHeight() - (wt.classic and 8 or 16) },
				scrollSize = { width = wt.classic and optionsPage.canvas:GetWidth() -20 or nil, height = t.scroll.height, },
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

		--[ Initialization ]

		--Add content, performs tasks
		if t.initialize then
			t.initialize(optionsPage.scrollChild or optionsPage.canvas)

			--Arrange content
			local sideMargin = wt.classic and 16 or 10
			if t.arrangement then wt.ArrangeContent(optionsPage.scrollChild or optionsPage.canvas, wt.AddMissing(
				t.arrangement.margins, { l = sideMargin, r = sideMargin, t = t.scroll and 78 or 82, b = t.scroll and sideMargin or 22 }
			), t.arrangement.gaps or 32, t.arrangement.flip, t.scroll ~= nil) end
		end

		--[ Other Utilities ]

		--Call to open the interface settings panel to this category page
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
	--- - **parent** Frame — Reference to the frame to set as the parent of the new button
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Button"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown on the button and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **titleOffset**? table *optional* — Offset the position of the label of the button
	--- 	- **x**? number *optional* — ***Default:*** 0
	--- 	- **y**? number *optional* — ***Default:*** 0
	--- - **label**? boolean *optional* — Whether or not to display **t.title** on the button frame | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the button displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the button in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the button into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the button in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the button at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size**? table *optional*
	--- 	- **width**? number *optional* — ***Default:*** 80
	--- 	- **height**? number *optional* — ***Default:*** 22
	--- - **customizable**? boolean *optional* ― Create the button with `BackdropTemplateMixin and "BackdropTemplate"` to be easily customizable | ***Default:*** false
	--- 	- ***Note:*** You may use ***WidgetToolbox*.SetBackdrop(...)** to set up the backdrop quickly.
	--- - **font**? table *optional* — List of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label
	--- 	- **normal**? string *optional* — Used by default | ***Default:*** "GameFontHighlightSmall"
	--- 	- **highlight**? string *optional* — Used when the button is being hovered | ***Default:*** "GameFontHighlightSmall"
	--- 	- **disabled**? string *optional* — Used when the button is disabled | ***Default:*** "GameFontDisabledSmall"
	--- 	- ***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).
	--- - **events**? table *optional* — Table of key, value pairs that holds script event handlers to be set for the button
	--- 	- **[*key*]** scriptType — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button#Defined_Script_Handlers)
	--- 		- ***Example:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" when the button is clicked.
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	---@return Button button A base Button object with custom functions added
	--- - ***Note:*** Annotate `@type button` for detailed function descriptions.
	--- - **setEnabled** function — Enable or disable the button widget based on the specified value
	--- - **setTooltip** function — Modify the tooltip set for the button with this to make sure it works even when the button is disabled
	--- 	- @*param* `tooltip`? table *optional* — List of text lines to set as the tooltip of the button | ***Default:*** **t.tooltip** or *no changes will be made*
	--- 		- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
	--- 		- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 			- **[*index*]** table ― Parameters of an additional line of text
	--- 				- **text** string ― Text to be displayed in the line
	--- 				- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 				- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 					- **r** number ― Red | ***Range:*** (0, 1)
	--- 					- **g** number ― Green | ***Range:*** (0, 1)
	--- 					- **b** number ― Blue | ***Range:*** (0, 1)
	--- 				- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	wt.CreateButton = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Button")
		local title = t.title or t.name or "Button"
		local custom = t.customizable and (BackdropTemplateMixin and "BackdropTemplate") or nil

		--[ Frame Setup ]

		---Create the button frame
		---@class button
		local button = CreateFrame("Button", name, t.parent, custom or "UIPanelButtonTemplate")

		--Position & dimensions
		if t.arrange then button.arrangementInfo = t.arrange else wt.SetPosition(button, t.position) end
		t.size = t.size or {}
		t.size.width = t.size.width or 80
		t.size.height = t.size.height or 22
		button:SetSize(t.size.width, t.size.height)

		--Label
		local label = custom and wt.CreateText({
			parent = button,
			position = { anchor = "CENTER", },
			width = t.size.width,
			text = title,
			font = (t.font or {}).normal or "GameFontNormal",
		}) or _G[name .. "Text"]
		if t.titleOffset then label:SetPoint("CENTER", t.titleOffset.x or 0, t.titleOffset.y or 0) end
		if t.label ~= false then label:SetText(title) else label:Hide() end

		--[ Getters & Setters ]

		---Enable or disable the button widget based on the specified value
		---@param state boolean Enable the input if true, disable if not
		button.setEnabled = function(state)
			button:SetEnabled(state)
			if state then
				if button:IsMouseOver() then if (t.font or {}).highlight or custom then label:SetFontObject((t.font or {}).highlight or "GameFontHighlight") end
				elseif (t.font or {}).normal or custom then label:SetFontObject((t.font or {}).normal or "GameFontNormal") end
				if button.hoverTarget then button.hoverTarget:Hide() end
			else
				if (t.font or {}).disabled or custom then label:SetFontObject((t.font or {}).disabled or "GameFontDisable") end
				if button.hoverTarget then button.hoverTarget:Show() end
			end
		end

		---Modify the tooltip set for the button with this to make sure it works even when the button is disabled
		---@param tooltip? table List of text lines to set as the tooltip of the button | ***Default:*** **t.tooltip** or *no changes will be made*
		--- - **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**
		--- - **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
		--- 	- **[*index*]** table ― Parameters of an additional line of text
		--- 		- **text** string ― Text to be displayed in the line
		--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
		--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
		--- 			- **r** number ― Red | ***Range:*** (0, 1)
		--- 			- **g** number ― Green | ***Range:*** (0, 1)
		--- 			- **b** number ― Blue | ***Range:*** (0, 1)
		--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
		button.setTooltip = function(tooltip)
			tooltip = tooltip or t.tooltip
			if not tooltip then return end

			--Create a trigger to show the tooltip when the button is disabled
			if not button.hoverTarget then
				button.hoverTarget = CreateFrame("Frame", name .. "HoverTarget", button)
				button.hoverTarget:SetPoint("TOPLEFT")
				button.hoverTarget:SetSize(button:GetSize())
				button.hoverTarget:Hide()
			end

			--Set the tooltip
			wt.AddTooltip(button, {
				title = tooltip.title or title,
				lines = tooltip.lines,
				anchor = "ANCHOR_TOPLEFT",
				offset = { x = 20, },
			}, { triggers = { button.hoverTarget, }, })
		end

		--[ Events & Behavior ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do button:HookScript(key, value) end end

		--Custom behavior
		button:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		if (t.font or {}).highlight or custom then
			button:HookScript("OnEnter", function() label:SetFontObject((t.font or {}).highlight or "GameFontHighlight") end)
			button:HookScript("OnLeave", function() label:SetFontObject((t.font or {}).normal or "GameFontNormal") end)
		end

		--Tooltip
		if t.tooltip then button.setTooltip() end

		--State & dependencies
		if t.disabled then button.setEnabled(false) else button:SetAttribute("enabled", true) end
		if t.dependencies then wt.SetDependencies(t.dependencies, button.setEnabled) end

		return button
	end

	---Create a button widget as a child of a context menu frame
	---@param contextMenu Frame Reference to the context menu to add this button to
	---@param mainContextMenu? Frame Reference to the root context menu to hide after clicking the button | ***Default:*** **contextMenu**
	---@param t table Parameters are to be provided in this table
	--- - **name**? string *optional* — Unique string to append this to the name of **contextMenu** when setting the name | ***Default:*** "Item" *followed by the the increment of the last index of* **contextMenu.items**
	--- 	- ***Note:*** Space characters will be removed.
	--- - **title**? string *optional* — Text to be shown on the button and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the button displayed when mousing over the frame
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
	--- - **font**? table *optional* — List of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label
	--- 	- **normal**? string *optional* — Used by default | ***Default:*** "GameFontHighlightSmall"
	--- 	- **highlight**? string *optional* — Used when the button is being hovered | ***Default:*** "GameFontHighlightSmall"
	--- 	- **disabled**? string *optional* — Used when the button is disabled | ***Default:*** "GameFontDisabledSmall"
	--- 	- ***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).
	--- - **justify**? string *optional* — Set the horizontal alignment of the label: "LEFT"|"RIGHT"|"CENTER" (overriding all font objects set in **t.font**) | ***Default:*** "LEFT"
	--- - **events**? table *optional* — Table of key, value pairs that holds script event handlers to be set for the button
	--- 	- **[*key*]** scriptType — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button#Defined_Script_Handlers)
	--- 		- ***Example:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" when the button is clicked.
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	---@return Button button A base Button object with custom functions added
	--- - ***Note:*** Annotate `@type contextButton` for detailed function descriptions.
	--- - **setEnabled** function — Enable or disable the button widget based on the specified value
	wt.AddContextButton = function(contextMenu, mainContextMenu, t)
		t = t or {}

		local defaultName = "Item" .. #contextMenu.items + 1
		local name = (t.append ~= false and contextMenu:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or defaultName)
		local title = t.title or t.name or defaultName

		--[ Frame Setup ]

		---Create the button frame
		---@class contextButton
		local button = CreateFrame("Button", name, contextMenu, BackdropTemplateMixin and "BackdropTemplate")

		--Add to the context menu
		table.insert(contextMenu.items, button)

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
			font = (t.font or {}).normal or "GameFontHighlightSmall",
			justify = { h = t.justify or "LEFT", },
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
			OnEnter = { rule = function() return { color = IsMouseButtonDown() and colors.context.click or colors.context.highlight } end },
			OnLeave = {},
			OnHide = {},
			OnMouseDown = { rule = function(self) return self:IsEnabled() and { color = colors.context.click } or {} end },
			OnMouseUp = { rule = function(self) return self:IsEnabled() and self:IsMouseOver() and { color = colors.context.highlight } or {} end },
		})

		--[ Events & Behavior ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do button:HookScript(key, value) end end

		--Custom behavior
		button:HookScript("OnClick", function()
			(mainContextMenu or contextMenu):Hide()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end)
		if (t.font or {}).highlight then
			button:HookScript("OnEnter", function() _G[name .. "Text"]:SetFontObject(t.font.highlight or "GameFontHighlightSmall") end)
			button:HookScript("OnLeave", function() _G[name .. "Text"]:SetFontObject((t.font or {}).normal or "GameFontHighlightSmall") end)
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
			wt.AddTooltip(button, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_TOPLEFT",
				offset = { x = 20, },
			}, { triggers = { hoverTarget, }, })
		end

		--[ Getters & Setters ]

		---Enable or disable the button widget based on the specified value
		---@param state boolean Enable the input if true, disable if not
		button.setEnabled = function(state)
			button:SetEnabled(state)
			if state then
				if button:IsMouseOver() then _G[name .. "Text"]:SetFontObject((t.font or {}).highlight or "GameFontHighlightSmall")
				else _G[name .. "Text"]:SetFontObject((t.font or {}).normal or "GameFontHighlightSmall") end
				if hoverTarget then hoverTarget:Hide() end
			else
				_G[name .. "Text"]:SetFontObject((t.font or {}).disabled or "GameFontDisableSmall")
				if hoverTarget then hoverTarget:Show() end
			end
		end

		--State & dependencies
		if t.disabled then button.setEnabled(false) else button:SetAttribute("enabled", true) end
		if t.dependencies then wt.SetDependencies(t.dependencies, button.setEnabled) end

		return button
	end

	--[ Toggle ]

	---Create a checkbox frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new checkbox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Toggle"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown on the right of the checkbox and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** and add a clickable extension next to next to the checkbox | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the checkbox displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the checkbox in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the checkbox into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the checkbox in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the checkbox at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size**? table *optional*
	--- 	- **width**? number *optional* — ***Default:*** **t.label** and 180 or **t.size.height**
	--- 	- **height**? number *optional* — ***Default:*** 26
	--- - **events**? table *optional* — Table of key, value pairs that holds script event handlers to be set for the checkbox
	--- 	- **[*key*]** scriptType — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- 		- ***Note:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" will be called with custom parameters:
	--- 			- @*param* `self` Frame ― Reference to the checkbox frame
	--- 			- @*param* `state` boolean ― The checked state of the checkbox frame
	--- 			- @*param* `button`? string *optional* — Which button caused the click | ***Default:*** "LeftButton"
	--- 			- @*param* `down`? boolean *optional* — Whether the event happened on button press (down) or release (up) | ***Default:*** false
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the checkbox to the options data table to save & load its value automatically to/from the specified workingTable
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param* boolean ― The current value of the checkbox
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any ― The data in the working table to be converted and loaded to the checkbox
	--- 		- @*return* boolean ― The value to be set to the checkbox
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` boolean ― The saved value from the widget
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` boolean ― The value loaded to the widget
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	---@return Frame toggleFrame A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - ***Note:*** Annotate `@type checkbox` for detailed function descriptions.
	--- - **getUniqueType** function — Returns the object type of this unique frame | ***Value:*** "Toggle"
	--- - **isUniqueType** function — Checks and returns if the type of this unique frame is equal to the string provided
	--- - **getState** function — Returns the current state of the checkbox in the toggle frame (whether it's checked or not)
	--- - **setState** function — Set the state of the checkbox inside the toggle frame (whether it's checked or not)
	--- - **toggleState** function — Flip the current state of the checkbox inside the toggle frame (whether it's checked or not)
	--- - **setEnabled** function — Enable or disable the checkbox widget based on the specified value
	--- - **checkbox** CheckButton — A base CheckButton object
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **toggleFrame.setSelected(...)** was called or an option was clicked or cleared
	--- 		- @*param* `self` Frame ― Reference to the checkbox holder frame
	--- 		- @*param* `attribute` = "toggled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `value` table ― Payload of the event
	--- 			- **user** boolean ― Whether the event was invoked by an action taken by the user
	--- 			- **state** boolean ― Whether the checkbox is checked or not
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			toggleFrame:HookScript("OnAttributeChanged", function(self, attribute, value)
	--- 				if attribute ~= "toggled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **toggleFrame.setEnabled(...)** was called
	--- 		- @*param* `self` Frame ― Reference to the checkbox holder frame
	--- 		- @*param* `attribute` = "enabled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the widget is enabled
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			toggleFrame:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "enabled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* `self` Frame ― Reference to the checkbox frame
	--- 		- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			checkbox:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateCheckbox = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")
		local title = t.title or t.name or "Toggle"

		--[ Main Frame ]

		---Create the parent frame
		---@class checkbox
		local toggleFrame = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		if t.arrange then toggleFrame.arrangementInfo = t.arrange else wt.SetPosition(toggleFrame, t.position) end
		t.size = t.size or {}
		t.size.height = t.size.height or 26
		t.size.width = t.label == false and t.size.height or t.size.width or 180
		toggleFrame:SetSize(t.size.width, t.size.height)

		--[ Checkbox ]

		--Create the checkbox frame
		toggleFrame.checkbox = CreateFrame("CheckButton", name .. "CheckBox", toggleFrame, "InterfaceOptionsCheckButtonTemplate")

		--Position & dimensions
		toggleFrame.checkbox:SetPoint("TOPLEFT")
		toggleFrame.checkbox:SetSize(t.size.height, t.size.height) --1:1 aspect ratio applies

		--Visibility
		toggleFrame:SetFrameLevel(toggleFrame:GetFrameLevel() + 1)
		toggleFrame.checkbox:SetFrameLevel(toggleFrame.checkbox:GetFrameLevel() - 2)

		--Label
		local label = nil
		if t.label ~= false then
			label = _G[name .. "CheckBoxText"]
			label:SetPoint("LEFT", toggleFrame.checkbox, "RIGHT", 2, 0)
			label:SetFontObject("GameFontHighlight")
			label:SetText(title)
		else _G[name .. "CheckBoxText"]:Hide() end

		--[ Getters & Setters ]

		---Returns the object type of this unique frame
		---@return UniqueFrameType type ***Value:*** "Toggle"
		toggleFrame.getUniqueType = function() return "Toggle" end

		---Checks and returns if the type of this unique frame is equal to the string provided
		---@param type string
		---@return boolean
		toggleFrame.isUniqueType = function(type) return type == "Toggle" end

		---Returns the current state of the checkbox in the toggle frame (whether it's checked or not)
		---@return boolean
		toggleFrame.getState = function() return toggleFrame.checkbox:GetChecked() end

		---Set the state of the checkbox inside the toggle frame (whether it's checked or not)
		---@param state? boolean ***Default:*** false
		---@param user? boolean Whether to flag the change as being done by a user interaction or not | ***Default:*** false
		toggleFrame.setState = function(state, user)
			toggleFrame.checkbox:SetChecked(state == true)

			--Set attribute
			toggleFrame:SetAttribute("toggled", { user = user, state = state == true })
		end

		---Flip the current state of the checkbox inside the toggle frame (whether it's checked or not)
		---@param user? boolean Whether to flag the change as being done by a user interaction or not | ***Default:*** false
		--- - ***Note:*** When true, a click action will be simulated on the CheckButton as if interacted with by the user.
		toggleFrame.toggleState = function(user)
			local state = not toggleFrame.checkbox:GetChecked()
			if user then toggleFrame.checkbox:Click() else
				toggleFrame.checkbox:SetChecked(state)

				--Set attribute
				toggleFrame:SetAttribute("toggled", { user = user, state = state })
			end
		end

		---Enable or disable the checkbox widget based on the specified value
		---@param state boolean Enable the input if true, disable if not
		toggleFrame.setEnabled = function(state)
			--Set attribute
			toggleFrame:SetAttribute("enabled", state)

			--Update enabled state
			toggleFrame.checkbox:SetEnabled(state)
			if label then label:SetFontObject(state and "GameFontHighlight" or "GameFontDisable") end
		end

		--[ Events & Behavior ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "OnClick" then toggleFrame.checkbox:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
			else toggleFrame.checkbox:HookScript(key, value) end
		end end

		--Custom behavior
		toggleFrame.checkbox:HookScript("OnClick", function(self)
			local state = self:GetChecked()
			PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

			--Set attribute
			toggleFrame:SetAttribute("toggled", { user = true, state = state })
		end)

		--Link events
		toggleFrame:HookScript("OnEnter", function(self) if self.checkbox:IsEnabled() then self.checkbox:LockHighlight() end end)
		toggleFrame:HookScript("OnLeave", function(self) if self.checkbox:IsEnabled() then self.checkbox:UnlockHighlight() end end)
		toggleFrame:HookScript("OnMouseDown", function(self) if self.checkbox:IsEnabled() then self.checkbox:SetButtonState("PUSHED") end end)
		toggleFrame:HookScript("OnMouseUp", function(self, button) if self.checkbox:IsEnabled() then
			self.checkbox:SetButtonState("NORMAL")
			if button == "LeftButton" then self.checkbox:Click(button) end
		end end)

		--Tooltip
		if t.tooltip then wt.AddTooltip(toggleFrame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_NONE",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = toggleFrame.checkbox,
				relativePoint = "TOPRIGHT",
			},
		}, { triggers = { toggleFrame.checkbox, }, }) end

		--State & dependencies
		if t.disabled then toggleFrame.setEnabled(false) else toggleFrame:SetAttribute("enabled", true) end
		if t.dependencies then wt.SetDependencies(t.dependencies, toggleFrame.setEnabled) end

		--[ Options Data Management ]

		if t.optionsData then
			--Add to the options data management
			wt.AddOptionsData(toggleFrame, toggleFrame.getUniqueType(), t.optionsData)

			--Handle changes
			if t.optionsData.onChange or t.optionsData.instantSave ~= false then
				toggleFrame.checkbox:HookScript("OnClick", function(self)
					local value = self:GetChecked()

					--Save the value to the working table
					if t.optionsData.instantSave ~= false then if t.optionsData.workingTable and t.optionsData.storageKey and value ~= nil then
						if t.optionsData.convertSave then value = t.optionsData.convertSave(value) end
						t.optionsData.workingTable[t.optionsData.storageKey] = value
					end end

					--Call specified onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end)
			end
		end

		return toggleFrame
	end

	---Create a radio button frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new radio button
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Toggle"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown on the right of the radio button and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** and add a clickable extension next to the radio button | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the radio button displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the radio button in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the radio button into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the radio button in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the radio button at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size**? table *optional*
	--- 	- **width**? number *optional* — ***Default:*** **t.label** and 160 or **t.size.height**
	--- 	- **height**? number *optional* — ***Default:*** 16
	--- - **clearable**? boolean *optional* — Whether this radio button should be clearable by right clicking on it or not | ***Default:*** false
	--- 	- ***Note:*** The radio button will be registered for "RightButtonUp" triggers to call "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" events with **button** = "RightButton".
	--- - **events**? table *optional* — Table of key, value pairs that holds script event handlers to be set for the radio button
	--- 	- **[*key*]** scriptType — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- 		- ***Note:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" will be called with custom parameters:
	--- 			- @*param* `self` Frame ― Reference to the radio button frame
	--- 			- @*param* `state` boolean ― The checked state of the radio button frame
	--- 			- @*param* `button`? string *optional* — Which button caused the click | ***Default:*** "LeftButton"
	--- 			- @*param* `down`? boolean *optional* — Whether the event happened on button press (down) or release (up) | ***Default:*** false
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the radio button to the options data table to save & load its value automatically to/from the specified workingTable
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param* boolean ― The current value of the radio button
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any ― The data in the working table to be converted and loaded to the radio button
	--- 		- @*return* boolean ― The value to be set to the radio button
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` boolean ― The saved value from the widget
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` boolean ― The value loaded to the widget
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	---@return Frame toggleFrame A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - ***Note:*** Annotate `@type radioButton` for detailed function descriptions.
	--- - **getUniqueType** function — Returns the object type of this unique frame | ***Value:*** "Toggle"
	--- - **isUniqueType** function — Checks and returns if the type of this unique frame is equal to the string provided
	--- - **getState** function — Returns the current state of the radio button in the toggle frame (whether it's checked or not)
	--- - **setState** function — Set the state of the radio button inside the toggle frame (whether it's checked or not)
	--- - **toggleState** function — Flip the current state of the radio button inside the toggle frame (whether it's checked or not)
	--- - **setEnabled** function — Enable or disable the radio button widget based on the specified value
	--- - **radioButton** CheckButton — A base CheckButton (with UIRadioButtonTemplate) object
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **toggleFrame.setSelected(...)** was called or an option was clicked or cleared
	--- 		- @*param* `self` Frame ― Reference to the radio button holder frame
	--- 		- @*param* `attribute` = "toggled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `value` table ― Payload of the event
	--- 			- **user** boolean ― Whether the event was invoked by an action taken by the user
	--- 			- **state** boolean ― Whether the radio button is checked or not
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			toggleFrame:HookScript("OnAttributeChanged", function(self, attribute, value)
	--- 				if attribute ~= "toggled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **toggleFrame.setEnabled(...)** was called
	--- 		- @*param* `self` Frame ― Reference to the radio button holder frame
	--- 		- @*param* `attribute` = "enabled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the widget is enabled
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			toggleFrame:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "enabled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* `self` Frame ― Reference to the radio button frame
	--- 		- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			radioButton:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateRadioButton = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")
		local title = t.title or t.name or "Toggle"

		--[ Main Frame ]

		---Create the parent frame
		---@class radioButton
		local toggleFrame = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		if t.arrange then toggleFrame.arrangementInfo = t.arrange else wt.SetPosition(toggleFrame, t.position) end
		t.size = t.size or {}
		t.size.height = t.size.height or 16
		t.size.width = t.label == false and t.size.height or t.size.width or 160
		toggleFrame:SetSize(t.size.width, t.size.height)

		--[ Radio Button ]

		--Create the radio button frame
		toggleFrame.radioButton = CreateFrame("CheckButton", name .. "RadioButton", toggleFrame, "UIRadioButtonTemplate")

		--Position & dimensions
		toggleFrame.radioButton:SetPoint("TOPLEFT")
		toggleFrame.radioButton:SetSize(t.size.height, t.size.height) --1:1 aspect ratio applies

		--Visibility
		toggleFrame:SetFrameLevel(toggleFrame:GetFrameLevel() + 1)
		toggleFrame.radioButton:SetFrameLevel(toggleFrame.radioButton:GetFrameLevel() - 2)

		--Label
		local label = nil
		if t.label ~= false then
			label = _G[name .. "RadioButtonText"]
			label:SetPoint("LEFT", toggleFrame.radioButton, "RIGHT", 3, 0)
			label:SetFontObject("GameFontHighlightSmall")
			label:SetText(title)
		else _G[name .. "RadioButtonText"]:Hide() end

		--[ Getters & Setters ]

		---Returns the object type of this unique frame
		---@return UniqueFrameType type ***Value:*** "Toggle"
		toggleFrame.getUniqueType = function() return "Toggle" end

		---Checks and returns if the type of this unique frame is equal to the string provided
		---@param type string
		---@return boolean
		toggleFrame.isUniqueType = function(type) return type == "Toggle" end

		---Returns the current state of the radio button in the toggle frame (whether it's checked or not)
		---@return boolean
		toggleFrame.getState = function() return toggleFrame.radioButton:GetChecked() end

		---Set the state of the radio button inside the toggle frame (whether it's checked or not)
		---@param state boolean
		---@param user? boolean Whether to flag the change as being done by a user interaction or not | ***Default:*** false
		toggleFrame.setState = function(state, user)
			--Update state
			toggleFrame.radioButton:SetChecked(state)

			--Set attribute
			toggleFrame:SetAttribute("toggled", { user = user, state = state })
		end

		---Flip the current state of the radio button inside the toggle frame (whether it's checked or not)
		---@param user? boolean Whether to flag the change as being done by a user interaction or not | ***Default:*** false
		--- - ***Note:*** When true, a click action will be simulated on the CheckButton as if interacted with by the user.
		toggleFrame.toggleState = function(user)
			local state = not toggleFrame.radioButton:GetChecked()
			if user then toggleFrame.radioButton:Click() else
				toggleFrame.radioButton:SetChecked(state)

				--Set attribute
				toggleFrame:SetAttribute("toggled", { user = user, state = state })
			end
		end

		---Enable or disable the radio button widget based on the specified value
		---@param state boolean Enable the input if true, disable if not
		toggleFrame.setEnabled = function(state)
			--Set attribute
			toggleFrame:SetAttribute("enabled", state)

			--Update enabled state
			toggleFrame.radioButton:SetEnabled(state)
			if label then label:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall") end
		end

		--State & dependencies
		if t.disabled then toggleFrame.radioButton.setEnabled(false) else toggleFrame:SetAttribute("enabled", true) end
		if t.dependencies then wt.SetDependencies(t.dependencies, toggleFrame.radioButton.setEnabled) end

		--[ Events & Behavior ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "OnClick" then toggleFrame.radioButton:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
			else toggleFrame.radioButton:HookScript(key, value) end
		end end

		--Custom behavior
		toggleFrame.radioButton:HookScript("OnClick", function(self, button)
			if button == "LeftButton" then
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

				--Call listeners & set attribute
				toggleFrame:SetAttribute("toggled", { user = true, state = self:GetChecked() })
			elseif t.clearable and button == "RightButton" then
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
				toggleFrame.setState(false)
			end
		end)

		--Link events
		toggleFrame:HookScript("OnEnter", function(self) if self.radioButton:IsEnabled() then self.radioButton:LockHighlight() end end)
		toggleFrame:HookScript("OnLeave", function(self) if self.radioButton:IsEnabled() then self.radioButton:UnlockHighlight() end end)
		toggleFrame:HookScript("OnMouseDown", function(self) if self.radioButton:IsEnabled() then self.radioButton:SetButtonState("PUSHED") end end)
		toggleFrame:HookScript("OnMouseUp", function(self, button) if self.radioButton:IsEnabled() then
			self.radioButton:SetButtonState("NORMAL")
			if button == "LeftButton" or (t.clearable and button == "RightButton") then self.radioButton:Click(button) end
		end end)

		--Tooltip
		if t.tooltip then wt.AddTooltip(toggleFrame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_NONE",
			position = {
				anchor = "BOTTOMLEFT",
				relativeTo = toggleFrame.radioButton,
				relativePoint = "TOPRIGHT",
			},
		}, { triggers = { toggleFrame.radioButton, }, }) end

		--[ Options Data Management ]

		if t.optionsData then
			--Add to the options data management
			wt.AddOptionsData(toggleFrame, toggleFrame.getUniqueType(), t.optionsData)

			--Handle changes
			if t.optionsData.onChange or t.optionsData.instantSave ~= false then
				toggleFrame.radioButton:HookScript("OnClick", function(self)
					local value = self:GetChecked()

					--Save the value to the working table
					if t.optionsData.instantSave ~= false then if t.optionsData.workingTable and t.optionsData.storageKey and value ~= nil then
						if t.optionsData.convertSave then value = t.optionsData.convertSave(value) end
						t.optionsData.workingTable[t.optionsData.storageKey] = value
					end end

					--Call specified onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end)
			end
		end

		return toggleFrame
	end

	--[ Selector ]

	---Create a selector frame, a collection of radio buttons to pick one out of multiple options
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new selector
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Selector"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the selector frame | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the selector | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the selector displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the selector in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the selector into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the selector in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the selector at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* ― The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or **t.label** and 160 or 0 *(whichever is greater)*
	--- 	- ***Note:*** The width of each individual radio button item will be set to **t.width** if **t.columns** is 1 and **t.width** is specified.
	--- - **items** table — Table containing subtables with data used to create radio button items, or already existing radio button widget frames
	--- 	- **[*index*]** table ― Parameters of a selector item
	--- 		- **title** string — Text to be shown on the right of the radio button to represent the item within the selector frame (if **t.labels** is true)
	--- 		- **tooltip**? table *optional* — List of text lines to be added to the tooltip of the radio button displayed when mousing over the frame
	--- 			- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.items[*index*].title**
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
	--- 			- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected *(see below)*.
	--- - **labels**? boolean *optional* — Whether or not to add the labels to the right of each newly created radio button | ***Default:*** true
	--- - **columns**? integer *optional* — Arrange the newly created radio buttons in a grid with the specified number of columns instead of a vertical list | ***Default:*** 1
	--- - **selected**? integer *optional* — The item to be set as selected on load | ***Default:*** nil *(no selection)*
	--- - **clearable**? boolean *optional* — Whether the selector input should be clearable by right clicking on its radio button items or not (the functionality of **setSelected** called with nil to clear the input will not be affected) | ***Default:*** false
	--- - **onSelection** function — The function to be called when a radio button is clicked and an item is selected, or when the input is cleared by the user
	--- 	- @*param* `index`? integer|nil *optional* — The index of the currently selected item
	--- 	- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected *(see below)*.
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the selector to the options data table to save & load its value automatically to/from the specified workingTable
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param*? integer|nil *optional* ― The index of the currently selected item in the selector
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any ― The data in the working table to be converted and loaded to the selector
	--- 		- @*return* *index*? integer|nil ― The index of the item to be set as selected in the selector
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value`? integer|nil *optional* ― The saved value from the widget
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value`? integer|nil *optional* ― The value loaded to the widget
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	---@return Frame selector A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - ***Note:*** Annotate `@type selector` for detailed function descriptions.
	--- - **getUniqueType** function — Returns the object type of this unique frame | ***Value:*** "Selector"
	--- - **isUniqueType** function — Checks and returns if the type of this unique frame is equal to the string provided
	--- - **getSelected** function — Returns the index of the currently selected item or nil if there is no selection
	--- - **setSelected** function — Set the specified item as selected (automatically called when an item is manually selected by clicking on a radio button)
	--- - **setEnabled** function — Enable or disable the selector widget based on the specified value
	--- - **items** table — The list of radio button widgets linked together in this selector
	--- 	- **[*index*]** Frame ― A base Frame object with custom values, functions and events added
	--- 		- ***Note:*** See ***WidgetToolbox*.CreateRadioButton(...)** for details.
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **selector.setSelected(...)** was called or an option was clicked or cleared
	--- 		- @*param* `self` Frame ― Reference to the selector frame
	--- 		- @*param* `attribute` = "selected" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `value` table ― Payload of the event
	--- 			- **user** boolean ― Whether the event was invoked by an action taken by the user
	--- 			- **selected**? integer|nil ― The index of the currently selected item
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, value)
	--- 				if attribute ~= "selected" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **selector.setEnabled(...)** was called
	--- 		- @*param* `self` Frame ― Reference to the selector frame
	--- 		- @*param* `attribute` = "enabled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the widget is enabled
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "enabled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* `self` Frame ― Reference to the selector frame
	--- 		- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
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
		t.columns = t.columns or 1

		--[ Main Frame ]

		---Create the selector frame
		---@class selector
		local selector = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		if t.arrange then selector.arrangementInfo = t.arrange else wt.SetPosition(selector, t.position) end
		selector:SetWidth(t.width or max(t.label ~= false and 160 or 0, (t.labels ~= false and 160 or 16) * t.columns))
		selector:SetHeight(math.ceil((#t.items) / t.columns) * 16 + (t.label ~= false and 14 or 0))

		--Label
		local label = wt.AddTitle({
			parent = selector,
			title = t.label ~= false and {
				offset = { x = 4, },
				text = title,
			} or nil,
		})

		--[ Radio Buttons ]

		selector.items = {}
		for i = 1, #t.items do
			if not next(t.items) then break end

			local new = true
			--Check if it's an already existing radio button
			if t.items[i].isUniqueType then if t.items[i].isUniqueType("Toggle") then if t.items[i].radioButton then
				selector.items[i] = t.items[i]
				new = false
			end end end

			--Create a new radio button
			if new then local sameRow = (i - 1) % t.columns > 0
				selector.items[i] = wt.CreateRadioButton({
					parent = selector,
					name = "Item" .. i,
					title = t.items[i].title,
					label = t.labels,
					tooltip = t.items[i].tooltip,
					position = {
						relativeTo = i == 1 and label or selector.items[sameRow and i - 1 or i - t.columns],
						relativePoint = sameRow and "TOPRIGHT" or "BOTTOMLEFT",
						offset = { x = label and i == 1 and -4 or 0, y = label and i == 1 and -2 or 0}
					},
					size = { width = (t.width and t.columns == 1) and t.width or nil },
					clearable = t.clearable,
				})
			end
		end

		--[ Events & Behavior ]

		--Tooltip
		if t.tooltip then wt.AddTooltip(selector, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}) end

		--[ Getters & Setters ]

		---Returns the object type of this unique frame
		---@return UniqueFrameType type ***Value:*** "Selector"
		selector.getUniqueType = function() return "Selector" end

		---Checks and returns if the type of this unique frame is equal to the string provided
		---@param type string
		---@return boolean
		selector.isUniqueType = function(type) return type == "Selector" end

		---Returns the index of the currently selected item or nil if there is no selection
		---@return integer? index
		selector.getSelected = function()
			if not next(selector.items) then return end

			for i = 1, #selector.items do if selector.items[i].getState() then return i end end
			return nil
		end

		---Set the specified item as selected (automatically called when an item is manually selected by clicking on a radio button)
		---@param index? integer ***Default:*** nil *(clear the selection)*
		---@param user? boolean Whether to call **t.item.onSelect** and **t.onSelection** | ***Default:*** false
		selector.setSelected = function(index, user)
			if not next(selector.items) then return end

			if index then
				if index > #selector.items then index = #selector.items elseif index < 1 then index = 1 end
				if t.items[index].onSelect and user then t.items[index].onSelect() end
			end
			for i = 1, #selector.items do selector.items[i].setState(i == index) end

			--Call listener & set attribute
			if t.onSelection and user then t.onSelection(index) end
			selector:SetAttribute("selected", { user = user, selected = index })
		end

		---Enable or disable the selector widget based on the specified value
		---@param state boolean Enable the input if true, disable if not
		selector.setEnabled = function(state)
			if not next(selector.items) then return end

			--Set attribute
			selector:SetAttribute("enabled", state)

			--Update states
			for i = 1, #selector.items do selector.items[i].setEnabled(state) end
			if label then label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
		end

		--Chain selection events
		for i = 1, #selector.items do
			if not next(selector.items) then break end

			selector.items[i].radioButton:HookScript("OnClick", function(_, button)
				if button == "LeftButton" then selector.setSelected(i, true)
				elseif t.clearable and button == "RightButton" and not selector.getSelected() then selector.setSelected(nil, true) end
			end)
		end

		--Starting value
		selector.setSelected(t.selected)

		--State & dependencies
		if t.disabled then selector.setEnabled(false) else selector:SetAttribute("enabled", true) end
		if t.dependencies then wt.SetDependencies(t.dependencies, selector.setEnabled) end

		--[ Options Data Management ]

		if t.optionsData then
			--Add to the options data management
			wt.AddOptionsData(selector, selector.getUniqueType(), t.optionsData)

			--Handle changes
			if t.optionsData.onChange or t.optionsData.instantSave ~= false then
				selector:HookScript("OnAttributeChanged", function(_, attribute, value)
					if attribute ~= "selected" or not value.user then return end

					--Save the value to the working table
					if t.optionsData.instantSave ~= false then if t.optionsData.workingTable and t.optionsData.storageKey and value.selected ~= nil then
						if t.optionsData.convertSave then value.selected = t.optionsData.convertSave(value.selected) end
						t.optionsData.workingTable[t.optionsData.storageKey] = value.selected
					end end

					--Call specified onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end)
			end
		end

		return selector
	end

	---Create a selector frame, a collection of small checkboxes to pick multiple options out of a list
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new selector
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Selector"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the selector frame | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the selector | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the selector displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the selector in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the selector into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the selector in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the selector at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* ― The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or **t.label** and 160 or 0 *(whichever is greater)*
	--- 	- ***Note:*** The width of each individual checkbox item will be set to **t.width** if **t.columns** is 1 and **t.width** is specified.
	--- - **items** table — Table containing subtables with data used to create checkbox items, or already existing checkbox widget frames
	--- 	- **[*index*]** table ― Parameters of a selector item
	--- 		- **title** string — Text to be shown on the right of the checkbox to represent the item within the selector frame (if **t.labels** is true)
	--- 		- **tooltip**? table *optional* — List of text lines to be added to the tooltip of the checkbox displayed when mousing over the frame
	--- 			- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.items[*index*].title**
	--- 			- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 				- **[*index*]** table ― Parameters of an additional line of text
	--- 					- **text** string ― Text to be displayed in the line
	--- 					- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 					- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 						- **r** number ― Red | ***Range:*** (0, 1)
	--- 						- **g** number ― Green | ***Range:*** (0, 1)
	--- 						- **b** number ― Blue | ***Range:*** (0, 1)
	--- 					- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- 		- **onSelect**? function *optional* — The function to be called when the checkbox is clicked and the item is selected
	--- 			- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected *(see below)*.
	--- - **labels**? boolean *optional* — Whether or not to add the labels to the right of each newly created checkbox | ***Default:*** true
	--- - **columns**? integer *optional* — Arrange the newly created checkboxes in a grid with the specified number of columns instead of a vertical list | ***Default:*** 1
	--- - **limits**? table *optional* — Parameters to specify the limits of the number of selectable items
	--- 	- **min**? integer *optional* — The minimal number of items that need to be selected at all times | ***Default:*** 1
	--- 	- **max**? integer *optional* — The maximal number of items that can be selected at once | ***Default:*** #**t.items** *(all items)*
	--- - **selected**? table *optional* — List of items and their states to be set on load | ***Default:*** *(no selection)*
	--- 	- **[*index*]** integer — The index of the specific item
	--- 	- **[*value*]** boolean? *optional* — Whether this item should be set as selected or not | ***Default:*** false
	--- - **onSelection** function — The function to be called when a checkbox is clicked and an item is selected, or when the input is cleared by the user
	--- 	- @*param* `selected` table — List of items and their current states
	--- 		- **[*index*]** integer — The index of the specific item
	--- 		- **[*value*]** boolean — The selected state of this item
	--- 	- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected *(see below)*.
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the selector to the options data table to save & load its value automatically to/from the specified workingTable
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param* `selected`? table|nil *optional* — List of items and their current states
	--- 			- **[*index*]** integer — The index of the specific item
	--- 			- **[*value*]** boolean — The selected state of this item
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any ― The data in the working table to be converted and loaded to the selector
	--- 		- @*param* `selected`? table|nil *optional* — List of items and their states to be set
	--- 			- **[*index*]** integer — The index of the specific item
	--- 			- **[*value*]** boolean? *optional* — Whether this item should be set as selected or not | ***Default:*** false
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value`? table|nil *optional* — The saved value from the widget
	--- 			- **[*index*]** integer — The index of the specific item
	--- 			- **[*value*]** boolean — The selected state of this item
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value`? table|nil *optional* — The value loaded to the widget
	--- 			- **[*index*]** integer — The index of the specific item
	--- 			- **[*value*]** boolean — The selected state of this item
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	---@return Frame selector A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - ***Note:*** Annotate `@type multiSelector` for detailed function descriptions.
	--- - **getUniqueType** function — Returns the object type of this unique frame | ***Value:*** "Selector"
	--- - **isUniqueType** function — Checks and returns if the type of this unique frame is equal to the string provided
	--- - **getSelected** function — Returns the list of all items and their current states
	--- - **setSelected** function — Set the specified items as selected (automatically called when an item is manually selected by clicking on a checkbox)
	--- - **setEnabled** function — Enable or disable the selector widget based on the specified value
	--- - **items** table — The list of checkbox widgets linked together in this selector
	--- 	- **[*index*]** Frame ― A base Frame object with custom values, functions and events added
	--- 		- **setLimited** function ― Enable or disable the toggleability of the checkbox widget based on the specified limits applying
	--- 		- ***Note:*** See ***WidgetToolbox*.CreateCheckbox(...)** for further details.
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **selector.setSelected(...)** was called or an option was clicked or cleared
	--- 		- @*param* `self` Frame ― Reference to the selector frame
	--- 		- @*param* `attribute` = "selected" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `value` table ― Payload of the event
	--- 			- **user** boolean ― Whether the event was invoked by an action taken by the user
	--- 			- **selected**? table — List of items and their current states
	--- 				- **[*index*]** integer — The index of the specific item
	--- 				- **[*value*]** boolean — The selected state of this item
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, value)
	--- 				if attribute ~= "selected" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **selector.setSelected(...)** was called or an option was clicked or cleared
	--- 		- @*param* `self` Frame ― Reference to the selector frame
	--- 		- @*param* `attribute` = "min" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `min` boolean — Whether **t.limits.min** ha been reached
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, min)
	--- 				if attribute ~= "min" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **selector.setSelected(...)** was called or an option was clicked or cleared
	--- 		- @*param* `self` Frame ― Reference to the selector frame
	--- 		- @*param* `attribute` = "max" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `max` boolean — Whether **t.limits.max** ha been reached
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, max)
	--- 				if attribute ~= "max" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **selector.setEnabled(...)** was called
	--- 		- @*param* `self` Frame ― Reference to the selector frame
	--- 		- @*param* `attribute` = "enabled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the widget is enabled
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "enabled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* `self` Frame ― Reference to the selector frame
	--- 		- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateMultipleSelector = function(t)
		local items = wt.Clone(t.items)
		local selectedItems = wt.Clone(t.selected)
		local disabled = t.disabled
		local dependencies = wt.Clone(t.dependencies)
		t.limits = t.limits or {}
		t.limits.min = t.limits.min or 1
		t.limits.max = t.limits.max or #items

		--[ Frame Setup ]

		--Remove parameters of overwritten functionalities
		t.items = {}
		t.selected = nil
		t.disabled = nil
		t.dependencies = nil

		---Create the selector frame
		---@class multiSelector : selector
		local selector = wt.CreateSelector(t)

		--Update Dimensions
		selector:SetHeight(math.ceil((#items) / t.columns) * 16 + (t.label ~= false and 14 or 0))

		--Label reference
		local label = _G[selector:GetName() .. "Title"]

		--[ Checkboxes ]

		selector.items = {}
		for i = 1, #items do
			local new = true
			--Check if it's an already existing checkbox
			if items[i].isUniqueType then if items[i].isUniqueType("Toggle") then if items[i].checkbox then
				selector.items[i] = items[i]
				new = false
			end end end

			--Create a new checkbox
			if new then local sameRow = (i - 1) % t.columns > 0
				selector.items[i] = wt.CreateCheckbox({
					parent = selector,
					name = "Item" .. i,
					title = items[i].title,
					label = t.labels,
					tooltip = items[i].tooltip,
					position = {
						relativeTo = i == 1 and label or selector.items[sameRow and i - 1 or i - t.columns],
						relativePoint = sameRow and "TOPRIGHT" or "BOTTOMLEFT",
						offset = { x = label and i == 1 and -4 or 0, y = label and i == 1 and -2 or 0}
					},
					size = { width = (t.width and t.columns == 1) and t.width or 160, height = 16 },
				})
				_G[selector.items[i].checkbox:GetName() .. "Text"]:SetFontObject("GameFontHighlightSmall")
				_G[selector.items[i].checkbox:GetName() .. "Text"]:SetIgnoreParentAlpha(true)
			end

			--[ Add & Override Getters & Setters ]

			---Enable or disable the checkbox widget based on the specified value
			---@param state boolean Enable the input if true, disable if not
			selector.items[i].setEnabled = function(state)
				selector.items[i].checkbox:SetEnabled(state)
				_G[selector.items[i].checkbox:GetName() .. "Text"]:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall")

				--Update limited state
				selector.items[i].setLimited()
			end

			---Enable or disable the toggleability of the checkbox widget based on the specified limits applying
			---@param min boolean Whether the minimal limit has been reached | ***Default:*** **selector**:[GetAttribute](https://wowpedia.fandom.com/wiki/API_Frame_GetAttribute)("min")
			--- - ***Note:*** If the item is selected and **min** is set to true, the checkbox will be faded and functionally disabled.
			---@param max boolean Whether the maximal limit has been reached | ***Default:*** **selector**:[GetAttribute](https://wowpedia.fandom.com/wiki/API_Frame_GetAttribute)("max")
			--- - ***Note:*** If the item is not selected and **max** is set to true, the checkbox will be faded and functionally disabled.
			selector.items[i].setLimited = function(min, max)
				min = min ~= nil and min or selector:GetAttribute("min")
				max = max ~= nil and max or selector:GetAttribute("max")
				local checked = selector.items[i].getState()

				if (checked and min) or (not checked and max) then
					selector.items[i].checkbox:SetButtonState("DISABLED")
					selector.items[i].checkbox:UnlockHighlight()
					selector.items[i].checkbox:SetAlpha(0.4)
				elseif selector:GetAttribute("enabled") then
					selector.items[i].checkbox:SetButtonState("NORMAL")
					selector.items[i].checkbox:SetAlpha(1)
				end
			end
		end

		--[ Override Getters & Setters ]

		---Returns the list of all items and their current states
		---@return table selected List of items and their current states
		--- - **[*index*]** integer — The index of the specific item
		--- - **[*value*]** boolean — The selected state of this item
		selector.getSelected = function()
			local selected = {}
			for i = 1, #selector.items do selected[i] = selector.items[i].getState() end
			return selected
		end

		---Set the specified items as selected (automatically called when an item is manually selected by clicking on a checkbox)
		---@param selected? table List of items and their states to be set | ***Default:*** nil *(clear the selection)*
		--- - **[*index*]** integer? *optional* — The index of the specific item
		--- - **[*value*]** boolean? *optional* — Whether this item should be set as selected or not | ***Default:*** false
		---@param user? boolean Whether to call **t.item.onSelect** and **t.onSelection** | ***Default:*** false
		selector.setSelected = function(selected, user)
			selected = selected or {}

			--Update limits & set their attributes
			local count = 0
			if next(selected) then for _, v in pairs(selected) do if v then count = count + 1 end end end
			local min = count <= t.limits.min
			local max = count >= t.limits.max
			selector:SetAttribute("min", min)
			selector:SetAttribute("max", max)

			--Update selections
			local s = {}
			for i = 1, #selector.items do
				selector.items[i].setState(selected[i])
				selector.items[i].setLimited(min, max)
				if items[i].onSelect and user then items[i].onSelect() end
				s[i] = selector.items[i].getState()
			end

			--Call listeners & set attribute
			if t.onSelection and user then t.onSelection(s) end
			selector:SetAttribute("selected", { user = user, selected = s })
		end

		--Selection update events
		for i = 1, #selector.items do selector.items[i].checkbox:HookScript("OnClick", function() selector.setSelected(selector.getSelected(), true) end) end

		--Starting value
		selector.setSelected(selectedItems)

		--State & dependencies
		if disabled then selector.setEnabled(false) else selector:SetAttribute("enabled", true) end
		if dependencies then wt.SetDependencies(dependencies, selector.setEnabled) end

		return selector
	end

	--Anchor point index table
	local anchorPoints = {
		{ name = strings.points.top.left, value = "TOPLEFT" },
		{ name = strings.points.top.center, value = "TOP" },
		{ name = strings.points.top.right, value = "TOPRIGHT" },
		{ name = strings.points.left, value = "LEFT" },
		{ name = strings.points.center, value = "CENTER" },
		{ name = strings.points.right, value = "RIGHT" },
		{ name = strings.points.bottom.left, value = "BOTTOMLEFT" },
		{ name = strings.points.bottom.center, value = "BOTTOM" },
		{ name = strings.points.bottom.right, value = "BOTTOMRIGHT" },
	}

	--Horizontal alignment index table
	local horizontalAlignments = {
		{ name = strings.points.left, value = "LEFT" },
		{ name = strings.points.center, value = "CENTER" },
		{ name = strings.points.right, value = "RIGHT" },
	}

	--Vertical alignment index table
	local verticalAlignments = {
		{ name = strings.points.top.center, value = "TOP" },
		{ name = strings.points.center, value = "MIDDLE" },
		{ name = strings.points.bottom.center, value = "BOTTOM" },
	}

	--Vertical alignment index table
	local frameStratas = {
		{ name = strings.strata.lowest, value = "BACKGROUND" },
		{ name = strings.strata.lower, value = "LOW" },
		{ name = strings.strata.low, value = "MEDIUM" },
		{ name = strings.strata.lowMid, value = "HIGH" },
		{ name = strings.strata.highMid, value = "DIALOG" },
		{ name = strings.strata.high, value = "FULLSCREEN" },
		{ name = strings.strata.higher, value = "FULLSCREEN_DIALOG" },
		{ name = strings.strata.highest, value = "TOOLTIP" },
	}

	---Create a special selector frame, a collection of radio buttons to pick an Anchor Point, a horizontal or vertical text alignment or Frame Strata value
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new selector
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Selector"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the selector frame | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the selector | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the selector frame displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the selector in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the selector into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the selector in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the selector at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)|JustifyH|JustifyV *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)|JustifyH|JustifyV *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* ― The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or **t.label** and 160 or 0 *(whichever is greater)*
	--- - **itemset** string ― Specify what type of selector should be created | ***Value:*** "anchor"|"justifyH"|"justifyV"|"frameStrata"
	--- 	- ***Note:*** Setting this to "anchor" will use the set of [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) items.
	--- 	- ***Note:*** Setting this to "justifyH" will use the set of horizontal text alignment items (JustifyH).
	--- 	- ***Note:*** Setting this to "justifyV" will use the set of vertical text alignment items (JustifyV).
	--- 	- ***Note:*** Setting this to "frameStrata" will use the set of [FrameStrata](https://wowpedia.fandom.com/wiki/Frame_Strata) items (excluding "WORLD").
	--- - **selected**? integer *optional* — The index of the item to be set as selected on load | ***Default:*** 0
	--- - **clearable**? boolean *optional* — Whether the selector input should be clearable by right clicking on its radio button items or not (the functionality of **setSelected** called with nil to clear the input will not be affected) | ***Default:*** false
	--- - **onSelection** function — The function to be called when a radio button is clicked and an point is selected, or when the input is cleared by the user
	--- 	- @*param* `point`? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)|JustifyH|JustifyV *optional* — The currently selected point
	--- 	- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected *(see below)*.
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the selector to the options data table to save & load its value automatically to/from the specified workingTable
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param*? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)|JustifyH|JustifyV *optional* ― The value selected in the frame
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any ― The data in the working table to be converted and loaded to the selector
	--- 		- @*return* *value*? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)|JustifyH|JustifyV|FrameStrata|nil ― The value loaded to the selector frame
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value`? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)|JustifyH|JustifyV|FrameStrata|nil *optional* ― The saved value selected in the frame
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value`? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)|JustifyH|JustifyV|FrameStrata|nil *optional* ― The value loaded to the selector frame
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	---@return Frame selector A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom functions and events added
	--- - ***Note:*** Annotate `@type specialSelector` for detailed function descriptions.
	--- - **getUniqueType** function — Returns the object type of this unique frame | ***Value:*** "Selector"
	--- - **isUniqueType** function Checks and returns if the type of this unique frame is equal to the string provided
	--- - **getSelected** function — Returns the index of the currently selected item or nil if there is no selection
	--- - **setSelected** function — Set the specified item as selected (automatically called when an item is manually selected by clicking on a radio button)
	--- - **setEnabled** function — Enable or disable the selector widget based on the specified value
	--- - **toValue** function — Convert an index to a corresponding value (based on the selected **t.itemset**)
	--- - **toIndex** function — Convert an specific value to a corresponding index (based on the selected **t.itemset**)
	--- - **items** table — The list of radio button widgets linked together in this selector
	--- 	- **[*index*]** Frame ― A base Frame object with custom values, functions and events added
	--- 		- ***Note:*** See ***WidgetToolbox*.CreateRadioButton(...)** for details.
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **selector.setSelected(...)** was called or an option was clicked or cleared
	--- 		- @*param* `self` Frame ― Reference to the selector frame
	--- 		- @*param* `attribute` = "selected" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `value` table ― Payload of the event
	--- 			- **user** boolean ― Whether the event was invoked by an action taken by the user
	--- 			- **selected**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)|JustifyH|JustifyV|nil ― The currently selected value
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, value)
	--- 				if attribute ~= "selected" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **selector.setEnabled(...)** was called
	--- 		- @*param* `self` Frame ― Reference to the selector frame
	--- 		- @*param* `attribute` = "enabled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the widget is enabled
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "enabled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* `self` Frame ― Reference to the selector frame
	--- 		- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			selector:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateSpecialSelector = function(t)
		local itemset = {}

		--Select the item set
		if t.itemset == "anchor" then itemset = anchorPoints
		elseif t.itemset == "justifyH" then itemset = horizontalAlignments
		elseif t.itemset == "justifyV" then itemset = verticalAlignments
		elseif t.itemset == "frameStrata" then itemset = frameStratas
		end

		--[ Frame Setup ]

		--Set unique parameters
		t.items = {}
		for i = 1, #itemset do
			t.items[i] = {}
			t.items[i].title = itemset[i].name
			t.items[i].tooltip = {}
		end
		t.labels = false
		t.columns = t.itemset == "frameStrata" and 8 or 3

		---Create the selector frame
		---@class specialSelector : selector
		local selector = wt.CreateSelector(t)

		--[ Override Getters & Setters ]

		---Convert an index to a corresponding value (based on the selected **t.itemset**)
		---@param index integer
		---@return AnchorPoint|JustifyH|JustifyV|FrameStrata value
		selector.toValue = function(index) return itemset[index].value end

		---Convert an specific value to a corresponding index (based on the selected **t.itemset**)
		---@param value AnchorPoint|JustifyH|JustifyV|FrameStrata
		---@return integer index ***Default:*** nil *(no value)*
		selector.toIndex = function(value)
			for i = 1, #itemset do if itemset[i].value == value then return i end end
			return nil
		end

		---Returns the index of the currently selected item or nil if there is no selection
		---@return AnchorPoint|JustifyH|JustifyV|FrameStrata? point
		selector.getSelected = function()
			for i = 1, #selector.items do if selector.items[i].getState() then return selector.toValue(i) end end
			return nil
		end

		---Set the specified item as selected (automatically called when an item is manually selected by clicking on a radio button)
		---@param value? integer|AnchorPoint|JustifyH|JustifyV|FrameStrata ***Default:*** nil *(clear the selection)*
		---@param user? boolean Whether to call **t.item.onSelect** and **t.onSelection** | ***Default:*** false
		selector.setSelected = function(value, user)
			local index = nil

			--Update selection
			if value then
				index = type(value) == "string" and selector.toIndex(value) or value
				if index > #selector.items then index = #selector.items elseif index < 0 then index = 0 end
			end
			for i = 1, #selector.items do selector.items[i].setState(i == index) end

			--Call listener & set attribute
			value = type(value) == "number" and selector.toValue(value) or value
			if t.onSelection and user then t.onSelection(value) end
			selector:SetAttribute("selected", { user = user, selected = value })
		end

		return selector
	end


	--[ Dropdown ]

	---Create a dropdown selector frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new dropdown
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Dropdown"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the dropdown and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the dropdown | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the dropdown displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the dropdown in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the dropdown into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the dropdown in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the dropdown at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* — ***Default:*** 160
	--- - **items** table — Table containing the dropdown items described within subtables
	--- 	- **[*index*]** table ― Parameters of a dropdown item
	--- 		- **title** string — Text to represent the item within the dropdown frame
	--- 		- **tooltip**? table *optional* — List of text lines to be added to the tooltip of the item in the dropdown displayed when mousing over it or the menu toggle button
	--- 			- **title**? string *optional* ― Text to be displayed in the title line of the tooltip | ***Default:*** **t.items[*index*].title**
	--- 			- **lines**? table *optional* ― Table containing the lists of parameters for the text lines after the title
	--- 				- **[*index*]** table ― Parameters of an additional line of text
	--- 					- **text** string ― Text to be displayed in the line
	--- 					- **font**? string|FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
	--- 					- **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
	--- 						- **r** number ― Red | ***Range:*** (0, 1)
	--- 						- **g** number ― Green | ***Range:*** (0, 1)
	--- 						- **b** number ― Blue | ***Range:*** (0, 1)
	--- 					- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped | ***Default:*** true
	--- 		- **onSelect** function — The function to be called when the dropdown item is selected
	--- 			- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will be evoked whenever an item is selected *(see below)*.
	--- - **selected**? integer *optional* — Index of the item to be set as selected on load | ***Default:*** nil *(no selection)*
	--- - **clearable**? boolean *optional* — Whether the selected option should be clearable by right clicking on its radio button item or the toggle button (the functionality of **setSelected** called with nil to clear the input will not be affected) | ***Default:*** false
	--- - **onSelection** function — The function to be called when an item is selected
	--- 	- @*param* `index`? integer|nil *optional* — The index of the currently selected item
	--- 	- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected *(see below)*.
	--- - **autoClose**? boolean *optional* — Close the dropdown menu after an item is selected by the user | ***Default:*** true
	--- - **sideButtons**? boolean *optional* — Add previous & next item buttons next to the dropdown | ***Default:*** true
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the dropdown to the options data table to save & load its value automatically to/from the specified workingTable (also set its text to the name of the currently selected value automatically on load)
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param* integer ― The index of the currently selected item in the dropdown menu
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any ― The data in the working table to be converted and loaded to the dropdown menu
	--- 		- @*return* integer ― The index of the item to be set as selected in the dropdown menu
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` integer ― The saved value from the widget
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` integer ― The value loaded to the widget
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	---@return Frame dropdown A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - ***Note:*** Annotate `@type dropdown` for detailed function descriptions.
	--- - **getUniqueType** function ― Returns the object type of this unique frame | ***Value:*** "Dropdown"
	--- - **isUniqueType** function ― Checks and returns if the type of this unique frame is equal to the string provided
	--- - **getSelected** function ― Returns the index of the currently selected item or nil if there is no selection
	--- - **setSelected** function ― Set the item at the specified index as selected, or set the displayed text if there is no selection
	--- - **setEnabled** function ― Enable or disable the dropdown widget based on the specified value
	--- - **selector**? [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)|nil — A base Frame object with custom functions and events added
	--- 	- **items** table — The list of radio button widgets linked together in this selector
	--- 		- **[*index*]** Frame ― A base Frame object with custom values, functions and events added
	--- 			- ***Note:*** See ***WidgetToolbox*.CreateRadioButton(...)** for details.
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateSelector(...)** for more details.
	--- - **toggle**? [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)|nil ― A custom button widget
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - **previous**? [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)|nil ― A custom button widget
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - **next**? [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)|nil ― A custom button widget
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after a dropdown item was selected
	--- 		- @*param* `self` Frame ― Reference to the dropdown frame
	--- 		- @*param* `name` = "selected" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `value` table ― Payload of the event
	--- 			- **user** boolean ― Whether the event was invoked by an action taken by the user
	--- 			- **selected**? integer|nil ― The index of the currently selected item
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			dropdown:HookScript("OnAttributeChanged", function(self, attribute, index)
	--- 				if attribute ~= "selected" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when the dropdown menu is opened or closed
	--- 		- @*param* `self` Frame ― Reference to the dropdown frame
	--- 		- @*param* `attribute` = "open" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the dropdown menu is open or not
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			dropdown:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "open" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **dropdown.setEnabled(...)** was called
	--- 		- @*param* `self` Frame ― Reference to the dropdown frame
	--- 		- @*param* `attribute` = "enabled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the widget is enabled
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			dropdown:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "enabled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* `self` Frame ― Reference to the dropdown frame
	--- 		- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
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

		--[ Main Frame ]

		---Create the dropdown frame
		---@class dropdown
		local dropdown = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		if t.arrange then dropdown.arrangementInfo = t.arrange else wt.SetPosition(dropdown, t.position) end
		t.width = t.width or 160
		dropdown:SetSize(t.width, 36)

		--Label
		local label = wt.AddTitle({
			parent = dropdown,
			title = t.label ~= false and {
				offset = { x = 4, },
				text = title,
			} or nil,
		})

		--[ Dropdown Menu ]

		--Button: Dropdown toggle
		dropdown.toggle = wt.CreateButton({
			parent = dropdown,
			name = "Toggle",
			append = t.append,
			title = "…",
			tooltip = { lines = {
				{ text = strings.dropdown.selected, },
				{ text = strings.dropdown.open, },
			} },
			position = { anchor = "BOTTOM", },
			size = { width = t.width - (t.sideButtons ~= false and 44 or 0), },
			customizable = true,
			font = {
				normal = "GameFontHighlightSmall",
				highlight = "GameFontHighlightSmall",
				disabled = "GameFontDisableSmall",
			},
			events = {
				OnMouseUp = t.clearable and function(self, button, isInside)
					if button == "RightButton" and isInside and self:IsEnabled() then dropdown.setSelected(nil, nil, true) end
				end or nil,
				OnShow = function(self) self:SetAttribute("open", false) end,
			},
			dependencies = t.dependencies,
		})
		wt.SetBackdrop(dropdown.toggle, {
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
				if button == "LeftButton" then return {} end
				return (dropdown:GetAttribute("open") and {
					background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				} or {
					background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				})
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

		--Update the toggle button with the selection
		local function UpdateSelection(index, text)
			local item = t.items[index] or {}
			local itemTitle = text and text or item.title or "…"

			--Update the label
			_G[dropdown.toggle:GetName() .. "Text"]:SetText(itemTitle)

			--Update the tooltip
			local tooltip = wt.Clone(item.tooltip) or {}
			table.insert(wt.AddMissing(tooltip, {
				title = itemTitle,
				lines = { { text = index and strings.dropdown.selected or strings.dropdown.none, }, }
			}).lines, { text = strings.dropdown.open, })
			dropdown.toggle.setTooltip(tooltip)
		end

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
			size = { width = t.width, height = 12 + #t.items * 16 }
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
			width = t.width - 12,
			items = t.items,
			clearable = t.clearable,
			onSelection = function(index)
				--Close the menu
				if t.autoClose ~= false and dropdown:GetAttribute("open") then
					panel:UnregisterEvent("GLOBAL_MOUSE_UP")
					panel:Hide()

					--Set attribute
					dropdown:SetAttribute("open", false)
				end

				--Update the toggle button
				UpdateSelection(index)

				--Set attribute
				dropdown:SetAttribute("selected", { user = true, selected = index })
			end,
		})

		--[ Side Buttons ]

		local previousDependencies, nextDependencies

		if t.sideButtons ~= false then
			--Create a custom disabled font
			wt.CreateFont({
				name = "ChatFontSmallDisabled",
				template = "ChatFontSmall",
				color = wt.PackColor(GameFontDisable:GetTextColor()),
			})

			--[ Previous Item ]

			--Dependency rules
			previousDependencies = { { frame = dropdown.selector, evaluate = function(value)
				if not value then return true end
				return value > 1
			end }, }

			--Create the button frame
			dropdown.previous = wt.CreateButton({
				parent = dropdown,
				name = "SelectPrevious",
				title = "◄",
				titleOffset = { y = 0.5 },
				tooltip = {
					title = strings.dropdown.previous.label,
					lines = { { text = strings.dropdown.previous.tooltip, }, }
				},
				position = { anchor = "BOTTOMLEFT", },
				size = { width = 22 },
				customizable = true,
				font = {
					normal = "ChatFontSmall",
					highlight = "ChatFontSmall",
					disabled = "ChatFontSmallDisabled",
				},
				events = {
					OnClick = function()
						local selected = dropdown.getSelected()
						dropdown.setSelected(selected and selected - 1 or #dropdown.selector.items, nil, true)
					end,
				},
				dependencies = previousDependencies,
			})

			--Backdrop
			wt.SetBackdrop(dropdown.previous, {
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

			nextDependencies = { { frame = dropdown.selector, evaluate = function(value)
				if not value then return true end
				return value < #dropdown.selector.items
			end }, }

			--Create a button frame
			dropdown.next = wt.CreateButton({
				parent = dropdown,
				name = "SelectNext",
				title = "►",
				titleOffset = { x = 2, y = 0.5 },
				tooltip = {
					title = strings.dropdown.next.label,
					lines = { { text = strings.dropdown.next.tooltip, }, }
				},
				position = { anchor = "BOTTOMRIGHT", },
				size = { width = 22 },
				customizable = true,
				font = {
					normal = "ChatFontSmall",
					highlight = "ChatFontSmall",
					disabled = "ChatFontSmallDisabled",
				},
				events = {
					OnClick = function()
						local selected = dropdown.getSelected()
						dropdown.setSelected(selected and selected + 1 or 1, nil, true)
					end,
				},
				dependencies = nextDependencies,
			})

			--Backdrop
			wt.SetBackdrop(dropdown.next, {
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

		---Returns the object type of this unique frame
		---@return UniqueFrameType type ***Value:*** "Dropdown"
		dropdown.getUniqueType = function() return "Dropdown" end

		---Checks and returns if the type of this unique frame is equal to the string provided
		---@param type string
		---@return boolean
		dropdown.isUniqueType = function(type) return type == "Dropdown" end

		---Returns the index of the currently selected item or nil if there is no selection
		---@return integer? index
		dropdown.getSelected = function() return dropdown.selector.getSelected() end

		---Set the item at the specified index as selected, or set the displayed text if there is no selection
		---@param index? integer ***Default:*** nil *(no selection)*
		---@param text? string ***Default:*** **index** and **t.items[*index*].title** or "…"
		---@param user? boolean Whether to call **t.item.onSelect** and **t.onSelection** | ***Default:*** false
		dropdown.setSelected = function(index, text, user)
			dropdown.selector.setSelected(index, user)
			UpdateSelection(index, text)

			--Call listenerS & set attribute
			if t.onSelection and user then t.onSelection(index) end
			dropdown:SetAttribute("selected", { user = user, selected = index })
		end

		---Enable or disable the dropdown widget based on the specified value
		---@param state boolean Enable the input if true, disable if not
		dropdown.setEnabled = function(state)
			--Set attributes
			dropdown:SetAttribute("enabled", state)
			if not state then dropdown:SetAttribute("open", false) end

			--Update states
			dropdown.toggle.setEnabled(state)
			dropdown.selector.setEnabled(state)
			if t.sideButtons ~= false then
				dropdown.previous.setEnabled(state and wt.CheckDependencies(previousDependencies))
				dropdown.next.setEnabled(state and wt.CheckDependencies(nextDependencies))
			end
			if label then if state then label:SetFontObject("GameFontNormal") else label:SetFontObject("GameFontDisable") end end
		end

		--Starting value
		dropdown.setSelected(t.selected)
		dropdown:SetAttributeNoHandler("open", false)

		--State & dependencies
		if t.disabled then dropdown.setEnabled(false) else dropdown:SetAttribute("enabled", true) end
		if t.dependencies then wt.SetDependencies(t.dependencies, dropdown.setEnabled) end

		--[ Events & Behavior ]

		--Dropdown toggle
		panel:Hide()
		dropdown.toggle:HookScript("OnClick", function()
			local state = not panel:IsVisible()

			wt.SetVisibility(panel, state)
			if state then panel:RegisterEvent("GLOBAL_MOUSE_DOWN") end

			--Set attribute
			dropdown:SetAttribute("open", state)
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

			--Set attribute
			dropdown:SetAttribute("open", false)
		end
		dropdown:HookScript("OnAttributeChanged", function(_, attribute, state)
			if attribute ~= "open" then return end

			if not state then PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF) end
		end)

		--Tooltip
		if t.tooltip then wt.AddTooltip(dropdown, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}) end

		--[ Options Data Management ]

		if t.optionsData then
			--Add to the options data management
			wt.AddOptionsData(dropdown, dropdown.getUniqueType(), t.optionsData)

			--Handle changes
			if t.optionsData.onChange or t.optionsData.instantSave ~= false then
				dropdown:HookScript("OnAttributeChanged", function(_, attribute, value)
					if attribute ~= "selected" or not value.user then return end

					--Save the value to the working table
					if t.optionsData.instantSave ~= false then if t.optionsData.workingTable and t.optionsData.storageKey and value.selected ~= nil then
						if t.optionsData.convertSave then value.selected = t.optionsData.convertSave(value.selected) end
						t.optionsData.workingTable[t.optionsData.storageKey] = value.selected
					end end

					--Call specified onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end)
			end
		end

		return dropdown
	end

	---Create a classic dropdown frame as a child of a container frame
	--- - ***Note:*** If called on a non-classic client, ***WidgetToolbox*.CreateDropdown(...)** will be called instead, returning a custom dropdown selector frame.
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new dropdown
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Dropdown"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the dropdown and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the dropdown | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the dropdown displayed when mousing over the frame
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
	--- 			- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will be evoked whenever an item is selected *(see below)*.
	--- - **selected**? integer *optional* — Index of the item to be set as selected on load | ***Default:*** 0
	--- - **onSelection** function — The function to be called when an item is selected
	--- 	- @*param* `index`? integer|nil *optional* — The index of the currently selected item
	--- 	- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be evoked whenever an item is selected *(see below)*.
	--- - **autoClose**? boolean *optional* — Close the dropdown menu after an item is selected by the user | ***Default:*** true
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the dropdown to the options data table to save & load its value automatically to/from the specified workingTable (also set its text to the name of the currently selected value automatically on load)
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param* integer ― The index of the currently selected item in the dropdown menu
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any ― The data in the working table to be converted and loaded to the dropdown menu
	--- 		- @*return* integer ― The index of the item to be set as selected in the dropdown menu
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` integer ― The saved value from the widget
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` integer ― The value loaded to the widget
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	---@return Frame dropdown A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) (with UIDropDownMenu template) object with custom functions and events added
	--- - **getUniqueType** function ― Returns the functional unique type of this Frame
	--- 	- @*return* "Dropdown" UniqueFrameType
	--- - **isUniqueType** function ― Checks and returns if the functional unique type of this Frame matches the string provided entirely
	--- 	- @*param* `type` UniqueFrameType|string
	--- 	- @*return* boolean
	--- - **getSelected** function ― Returns the index of the currently selected item or nil if there is no selection
	--- 	- @*return* `index`? integer
	--- - **setSelected** function ― Set the item at the specified index as selected, or set the display name if there is no selection
	--- 	- @*param* `index`? integer | ***Default:*** nil *(no selection)*
	--- 	- @*param* `text`? string | ***Default:*** **t.items[*index*].title** *(if **index** is provided)*
	--- 	- @*param* `user`? boolean *optional* — Whether to call **t.item.onSelect** | ***Default:*** false
	--- - **setEnabled** function ― Enable or disable the dropdown widget based on the specified value
	--- 	- @*param* `state` boolean ― Enable the input if true, disable if not
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after a dropdown item was selected
	--- 		- @*param* `self` Frame ― Reference to the dropdown frame
	--- 		- @*param* `name` = "selected" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `value` table ― Payload of the event
	--- 			- **user** boolean ― Whether the event was invoked by an action taken by the user
	--- 			- **selected**? integer|nil ― The index of the currently selected item
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			dropdown:HookScript("OnAttributeChanged", function(self, attribute, index)
	--- 				if attribute ~= "selected" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when the dropdown menu is opened or closed
	--- 		- @*param* `self` Frame ― Reference to the dropdown frame
	--- 		- @*param* `attribute` = "open" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the dropdown menu is open or not
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			dropdown:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "open" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* `self` Frame ― Reference to the dropdown frame
	--- 		- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
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

					--Set attribute
					dropdown:SetAttribute("selected", { user = false, selected = self.value })
				end
				UIDropDownMenu_AddButton(info)
			end
		end)
		--Label
		local title = t.title or t.name or "Dropdown"
		local label = wt.AddTitle({
			parent = dropdown,
			title = t.label ~= false and {
				offset = { x = 22, y = 16 },
				text = title,
			} or nil,
		})
		--Tooltip
		if t.tooltip then wt.AddTooltip(dropdown, {
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
			--Call listener & set attribute
			if t.onSelection and user then t.onSelection(index) end
			dropdown:SetAttribute("selected", { user = user, selected = index })
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
		if t.optionsData then
			--Add to the options data management
			wt.AddOptionsData(dropdown, dropdown.getUniqueType(), t.optionsData)

			--Handle changes
			if t.optionsData.onChange or t.optionsData.instantSave ~= false then
				dropdown:HookScript("OnAttributeChanged", function(_, attribute, value)
					if attribute ~= "selected" or not value.user then return end

					--Save the value to the working table
					if t.optionsData.instantSave ~= false then if t.optionsData.workingTable and t.optionsData.storageKey and value.selected ~= nil then
						if t.optionsData.convertSave then value.selected = t.optionsData.convertSave(value.selected) end
						t.optionsData.workingTable[t.optionsData.storageKey] = value.selected
					end end

					--Call specified onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end)
			end
		end
		return dropdown
	end

	--[ Text Box ]

	---Set the parameters of an editbox frame
	---@param holder Frame Reference to the holder frame
	---@param editBox EditBox Reference to the editbox frame to set up
	---@param label? FontString The title [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) above the editbox | ***Default:*** nil *(no title)*
	---@param multiline boolean Set to true if the editbox should be support multiple lines for the string input
	---@param t table Additional parameters are to be provided in this table
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **insets**? table *optional* — Table containing padding values by which to offset the position of the text in the editbox
	--- 	- **l**? number *optional* — ***Default:*** 0
	--- 	- **r**? number *optional* — ***Default:*** 0
	--- 	- **t**? number *optional* — ***Default:*** 0
	--- 	- **b**? number *optional* — ***Default:*** 0
	--- - **font**? table *optional* — List of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label
	--- 	- **normal**? string *optional* — Used by default | ***Default:*** *default font based on the frame template*
	--- 	- **disabled**? string *optional* — Used when when the editbox is disabled | ***Default:*** *default font based on the frame template*
	--- 	- ***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox (overriding all font objects set in **t.font**)
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	--- - **justify**? string *optional* — Set the justification of the text (overriding all font objects set in **t.font**)
	--- 	- **h**? string *optional* — Horizontal alignment: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- 	- **v**? string *optional* — Vertical alignment: "TOP"|"BOTTOM"|"MIDDLE" | ***Default:*** "MIDDLE"
	--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) | ***Default:*** 0 (*no limit*)
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true | ***Default:*** false
	--- - **events**? table *optional* — Table of key, value pairs that holds script event handlers to be set for the editbox
	--- 	- **[*key*]** scriptType — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- 		- ***Note:*** "[OnChar](https://wowpedia.fandom.com/wiki/UIHANDLER_OnChar)" will be called with custom parameters:
	--- 			- @*param* `self` Frame ― Reference to the editbox frame
	--- 			- @*param* `char` string ― The UTF-8 character that was typed
	--- 			- @*param* `text` string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnTextChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnTextChanged)" will be called with custom parameters:
	--- 			- @*param* `self` Frame ― Reference to the editbox frame
	--- 			- @*param* `user` string ― True if the value was changed by the user, false if it was done programmatically
	--- 			- @*param* `text` string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed)" will be called with custom parameters:
	--- 			- @*param* `self` Frame ― Reference to the editbox frame
	--- 			- @*param* `text` string ― The text typed into the editbox
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the editbox to the options data table to save & load its value automatically to/from the specified workingTable
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param* string ― The current value of the editbox
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any ― The data in the working table to be converted and loaded to the editbox
	--- 		- @*return* string ― The value to be set to the editbox
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` string ― The saved value from the widget
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` string ― The value loaded to the widget
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	local function SetEditBox(holder, editBox, label, multiline, t)

		--[ Font & Text ]

		editBox:SetMultiLine(multiline)
		t.insets = t.insets or {}
		t.insets = { l = t.insets.l or 0, r = t.insets.r or 0, t = t.insets.t or 0, b = t.insets.b or 0 }
		editBox:SetTextInsets(t.insets.l, t.insets.r, t.insets.t, t.insets.b)
		t.font = t.font or {}
		if t.font.normal then editBox:SetFontObject(t.font.normal) end
		if t.justify then
			if t.justify.h then editBox:SetJustifyH(t.justify.h) end
			if t.justify.v then editBox:SetJustifyV(t.justify.v) end
		end
		if t.maxLetters then editBox:SetMaxLetters(t.maxLetters) end

		--[ Events & Behavior ]

		--Register script event handlers
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
		editBox:HookScript("OnTextChanged", function(_, user) holder:SetAttribute("changed", { user = user, text = editBox:GetText() }) end)

		--[ Getters & Setters ]

		---Returns the object type of this unique frame
		---@return UniqueFrameType type ***Value:*** "TextBox"
		holder.getUniqueType = function() return "TextBox" end

		---Checks and returns if the type of this unique frame is equal to the string provided
		---@param type string
		---@return boolean
		holder.isUniqueType = function(type) return type == "TextBox" end

		---Returns the text of the editbox
		---@return string
		holder.getText = function() return editBox:GetText() end

		---Set the text of the editbox
		---@param text string Text to call the built-in [EditBox:SetText(**text**)](https://wowpedia.fandom.com/wiki/API_EditBox_SetText) with
		---@param resetCursor? boolean If true, set the cursor position to the beginning of the string after setting the text | ***Default:*** true
		editBox.setText = function(text, resetCursor)
			editBox:SetText(text)
			if resetCursor ~= false then editBox:SetCursorPosition(0) end
		end
		holder.setText = editBox.setText

		---Enable or disable the editbox widget based on the specified value
		---@param state boolean Enable the input if true, disable if not
		editBox.setEnabled = function(state)
			--Set attribute
			holder:SetAttribute("enabled", true)

			--Update state
			editBox:SetEnabled(state)
			if state then if t.font.normal then editBox:SetFontObject(t.font.normal) end elseif t.font.disabled then editBox:SetFontObject(t.font.disabled) end
			if label then label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
		end
		holder.setEnabled = editBox.setEnabled

		--Starting value
		if t.text then editBox.setText(t.color and wt.Color(t.text, t.color) or t.text) end

		--State & dependencies
		if t.readOnly then editBox:Disable() end
		if t.disabled then editBox.setEnabled(false) else holder:SetAttribute("enabled", true) end
		if t.dependencies then wt.SetDependencies(t.dependencies, editBox.setEnabled) end

		--[ Options Data Management ]

		if t.optionsData then
			--Add to the options data management
			wt.AddOptionsData(editBox, editBox:GetObjectType(), t.optionsData)

			--Handle changes
			if t.optionsData.onChange or t.optionsData.instantSave ~= false then
				editBox:HookScript("OnTextChanged", function(self, user)
					if not user then return end
					local value = self:GetText()

					--Save the value to the working table
					if t.optionsData.instantSave ~= false then if t.optionsData.workingTable and t.optionsData.storageKey and value ~= nil then
						if t.optionsData.convertSave then value = t.optionsData.convertSave(value) end
						t.optionsData.workingTable[t.optionsData.storageKey] = value
					end end

					--Call specified onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end)
			end
		end
	end

	---Create an editbox frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the editbox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Text Box"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the editbox and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the editbox | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the editbox displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the editbox in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the editbox into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the editbox in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the editbox at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size**? table *optional*
	--- 	- **width**? number *optional* — ***Default:*** 180
	--- 	- **height**? number *optional* — ***Default:*** 17
	--- - **insets**? table *optional* — Padding values by which to offset the position of the text in the editbox inward
	--- 	- **l**? number *optional* — ***Default:*** 0
	--- 	- **r**? number *optional* — ***Default:*** 0
	--- 	- **t**? number *optional* — ***Default:*** 0
	--- 	- **b**? number *optional* — ***Default:*** 0
	--- - **customizable**? boolean *optional* ― Create the editbox with `BackdropTemplateMixin and "BackdropTemplate"` to be easily customizable | ***Default:*** false
	--- 	- ***Note:*** You may use ***WidgetToolbox*.SetBackdrop(...)** to set up the backdrop quickly.
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **font**? table *optional* — List of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label
	--- 	- **normal**? string *optional* — Used by default | ***Default:*** "GameFontNormal" if **t.customizable** == true
	--- 	- **disabled**? string *optional* — Used when when the editbox is disabled | ***Default:*** "GameFontDisabled" if **t.customizable** == true
	--- 	- ***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox (overriding all font objects set in **t.font**)
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	--- - **justify**? string *optional* — Set the justification of the text (overriding all font objects set in **t.font**)
	--- 	- **h**? string *optional* — Horizontal alignment: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- 	- **v**? string *optional* — Vertical alignment: "TOP"|"BOTTOM"|"MIDDLE" | ***Default:*** "MIDDLE"
	--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) | ***Default:*** 0 (*no limit*)
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true | ***Default:*** false
	--- - **events**? table *optional* — Table of key, value pairs that holds script event handlers to be set for the editbox
	--- 	- **[*key*]** scriptType — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- 		- ***Note:*** "[OnChar](https://wowpedia.fandom.com/wiki/UIHANDLER_OnChar)" will be called with custom parameters:
	--- 			- @*param* `self` Frame ― Reference to the editbox frame
	--- 			- @*param* `char` string ― The UTF-8 character that was typed
	--- 			- @*param* `text` string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnTextChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnTextChanged)" will be called with custom parameters:
	--- 			- @*param* `self` Frame ― Reference to the editbox frame
	--- 			- @*param* `user` string ― True if the value was changed by the user, false if it was done programmatically
	--- 			- @*param* `text` string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed)" will be called with custom parameters:
	--- 			- @*param* `self` Frame ― Reference to the editbox frame
	--- 			- @*param* `text` string ― The text typed into the editbox
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the editbox to the options data table to save & load its value automatically to/from the specified workingTable
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param* string ― The current value of the editbox
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any ― The data in the working table to be converted and loaded to the editbox
	--- 		- @*return* string ― The value to be set to the editbox
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` string ― The saved value from the widget
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` string ― The value loaded to the widget
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	---@return Frame textBox A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - **getUniqueType** function — Returns the object type of this unique frame | ***Value:*** "TextBox"
	--- - **isUniqueType** function — Checks and returns if the type of this unique frame is equal to the string provided
	--- - **getText** function — Returns the text of the editbox
	--- - **setText** function ― Reference to **textBox.editBox.setText**
	--- - **setEnabled** function — Reference to **textBox.editBox.setEnabled**
	--- - **editBox** [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) ― A base EditBox frame with custom functions added
	--- 	- **setText** function ― Set the text of the editbox
	--- 	- **setEnabled** function — Enable or disable the editbox widget based on the specified value
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **textBox.setText(...)** was called or an "[OnTextChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnTextChanged)" event
	--- 		- @*param* `self` Frame ― Reference to the editbox holder frame
	--- 		- @*param* `attribute` = "changed" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `value` table ― Payload of the event
	--- 			- **user** boolean ― Whether the event was invoked by an action taken by the user
	--- 			- **text**? string
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			textBox:HookScript("OnAttributeChanged", function(self, attribute, value)
	--- 				if attribute ~= "changed" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **textBox.setEnabled(...)** was called
	--- 		- @*param* `self` Frame ― Reference to the editbox frame
	--- 		- @*param* `attribute` = "enabled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the widget is enabled
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			textBox:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "enabled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* `self` Frame ― Reference to the editbox frame
	--- 		- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			editbox:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateEditBox = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "TextBox")
		local title = t.title or t.name or "Text Box"
		local custom = t.customizable and (BackdropTemplateMixin and "BackdropTemplate") or nil

		--[ Main Frame ]

		--Create the parent frame
		local textBox = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		if t.arrange then textBox.arrangementInfo = t.arrange else wt.SetPosition(textBox, t.position) end
		local titleOffset = t.label ~= false and -18 or 0
		t.size = t.size or {}
		t.size.width = t.size.width or 180
		t.size.height = t.size.height or 17
		textBox:SetSize(t.size.width, t.size.height - titleOffset)

		--Label
		local label = wt.AddTitle({
			parent = textBox,
			title = t.label ~= false and {
				offset = { x = -1, },
				text = title,
			} or nil,
		})

		--[ EditBox ]

		--Create the editbox frame
		textBox.editBox = CreateFrame("EditBox", name .. "EditBox", textBox, custom or "InputBoxTemplate")

		--Position & dimensions
		textBox.editBox:SetPoint("TOPLEFT", 0, titleOffset)
		textBox.editBox:SetSize(t.size.width, t.size.height)

		--EditBox setup
		SetEditBox(textBox, textBox.editBox, label, false, t)

		--[ Events & Behavior ]

		--Custom behavior
		if custom then
			textBox.editBox:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
			textBox.editBox:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)
		end

		--Tooltip
		if t.tooltip then wt.AddTooltip(textBox.editBox, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}) end

		return textBox
	end

	---Create a scrollable editbox as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the editbox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Text Box"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the editbox and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the editbox | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the editbox displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the editbox in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the editbox into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the editbox in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the editbox at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size** table
	--- 	- **width** number
	--- 	- **height** number
	--- - **insets**? table *optional* — Table containing padding values by which to offset the position of the text in the editbox
	--- 	- **l**? number *optional* — ***Default:*** 0
	--- 	- **r**? number *optional* — ***Default:*** 0
	--- 	- **t**? number *optional* — ***Default:*** 0
	--- 	- **b**? number *optional* — ***Default:*** 0
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **font**? table *optional* — List of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label
	--- 	- **normal**? string *optional* — Used by default | ***Default:*** *default font based on the frame template*
	--- 	- **disabled**? string *optional* — Used when when the editbox is disabled | ***Default:*** *default font based on the frame template*
	--- 	- ***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox (overriding all font objects set in **t.font**)
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	--- - **justify**? string *optional* — Set the justification of the text (overriding all font objects set in **t.font**)
	--- 	- **h**? string *optional* — Horizontal alignment: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
	--- 	- **v**? string *optional* — Vertical alignment: "TOP"|"BOTTOM"|"MIDDLE" | ***Default:*** "MIDDLE"
	--- - **maxLetters**? integer *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) | ***Default:*** 0 (*no limit*)
	--- - **charCount**? boolean *optional* — Show or hide the remaining number of characters | ***Default:*** **t.maxLetters** > 0
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true | ***Default:*** false
	--- - **scrollSpeed**? number *optional* — Percentage of one page of content to scroll at a time | ***Range:*** (0, 1) | ***Default:*** 0.25
	--- 	- ***Note:*** If ***WidgetTools*.classic** is true, **t.scrollSpeed** is used as the scroll step value of the classic scroll frames. | ***Default:*** *half of the height of the scrollbar*
	--- - **scrollToTop**? boolean *optional* — Automatically scroll to the top when the text is loaded or changed while not being actively edited | ***Default:*** true
	--- - **events**? table *optional* — Table of key, value pairs that holds script event handlers to be set for the editbox child frame
	--- 	- **[*key*]** scriptType — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- 		- ***Note:*** "[OnChar](https://wowpedia.fandom.com/wiki/UIHANDLER_OnChar)" will be called with custom parameters:
	--- 			- @*param* `self` Frame ― Reference to the editbox frame
	--- 			- @*param* `char` string ― The UTF-8 character that was typed
	--- 			- @*param* `text` string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnTextChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnTextChanged)" will be called with custom parameters:
	--- 			- @*param* `self` Frame ― Reference to the editbox frame
	--- 			- @*param* `user` string ― True if the value was changed by the user, false if it was done programmatically
	--- 			- @*param* `text` string ― The text typed into the editbox
	--- 		- ***Note:*** "[OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed)" will be called with custom parameters:
	--- 			- @*param* `self` Frame ― Reference to the editbox frame
	--- 			- @*param* `text` string ― The text typed into the editbox
	--- - **scrollEvents**? table *optional* — Table of key, value pairs that holds script event handlers to be set for the scroll frame
	--- 	- **[*key*]** scriptType — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [ScrollFrame](https://wowpedia.fandom.com/wiki/UIOBJECT_ScrollFrame#Defined_Script_Handlers)
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the editbox to the options data table to save & load its value automatically to/from the specified workingTable
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param* string ― The current value of the editbox
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any ― The data in the working table to be converted and loaded to the editbox
	--- 		- @*return* string ― The value to be set to the editbox
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` string ― The saved value from the widget
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` string ― The value loaded to the widget
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	---@return Frame textBox A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - **getUniqueType** function — Returns the object type of this unique frame | ***Value:*** "TextBox"
	--- - **isUniqueType** function — Checks and returns if the type of this unique frame is equal to the string provided
	--- - **getText** function — Returns the text of the editbox
	--- - **setText** function ― Reference to **textBox.scrollFrame.EditBox.setText**
	--- - **setEnabled** function — Reference to **textBox.scrollFrame.EditBox.setEnabled**
	--- - **scrollFrame** [ScrollFrame](https://wowpedia.fandom.com/wiki/UIOBJECT_ScrollFrame) ― A base ScrollFrame (with InputScrollFrameTemplate) object
	--- 	- **EditBox** [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) ― A base EditBox frame with custom functions added
	--- 		- **setText** function ― Set the text of the editbox
	--- 		- **setEnabled** function — Enable or disable the editbox widget based on the specified value
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **textBox.setText(...)** was called or an "[OnTextChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnTextChanged)" event
	--- 		- @*param* `self` Frame ― Reference to the editbox holder frame
	--- 		- @*param* `attribute` = "changed" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `value` table ― Payload of the event
	--- 			- **user** boolean ― Whether the event was invoked by an action taken by the user
	--- 			- **text**? string
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			textBox:HookScript("OnAttributeChanged", function(self, attribute, value)
	--- 				if attribute ~= "changed" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **textBox.setEnabled(...)** was called
	--- 		- @*param* `self` Frame ― Reference to the editbox holder frame
	--- 		- @*param* `attribute` = "enabled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the widget is enabled
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			textBox:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "enabled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* `self` Frame ― Reference to the editbox frame
	--- 		- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			editbox:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateEditScrollBox = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "TextBox")
		local title = t.title or t.name or "Text Box"

		--[ Main Frame ]

		--Create the parent frame
		local textBox = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		if t.arrange then textBox.arrangementInfo = t.arrange else wt.SetPosition(textBox, t.position) end
		textBox:SetSize(t.size.width, t.size.height)

		--Label
		local label = wt.AddTitle({
			parent = textBox,
			title = t.label ~= false and {
				offset = { x = 3, },
				text = title,
			} or nil,
		})

		--[ ScrollFrame ]

		--Create the edit scroll frame
		textBox.scrollFrame = CreateFrame("ScrollFrame", name .. "ScrollFrame", textBox, ScrollControllerMixin and "InputScrollFrameTemplate")

		--Position & dimensions
		textBox.scrollFrame:SetPoint("BOTTOM", 0, 5)
		local scrollFrameHeight = t.size.height - (t.label ~= false and 24 or 10)
		textBox.scrollFrame:SetSize(t.size.width - 10, scrollFrameHeight)

		--Scrollbar setup
		if not wt.classic then
			--Scrollbar position & dimensions
			wt.SetPosition(textBox.scrollFrame.ScrollBar, {
				anchor = "RIGHT",
				relativeTo = textBox.scrollFrame,
				relativePoint = "RIGHT",
				offset = { x = -4, y = 0 }
			})
			textBox.scrollFrame.ScrollBar:SetHeight(scrollFrameHeight - 4)
		else SetClassicScrollBar(textBox.scrollFrame) end

		--EditBox setup
		SetEditBox(textBox, textBox.scrollFrame.EditBox, label, true, t)
		if not wt.classic then textBox.scrollFrame.EditBox.cursorOffset = 0 end --REMOVE: When the character counter gets fixed..

		--Character counter
		textBox.scrollFrame.CharCount:SetFontObject("GameFontDisableTiny2")
		if t.charCount == false or (t.maxLetters or 0) == 0 then textBox.scrollFrame.CharCount:Hide() end

		--[ Size Update Utility ]

		local scrollBar = wt.classic and _G[name .. "ScrollFrameScrollBar"] or _G[name .. "ScrollFrame"].ScrollBar
		local scrollStripWidth = wt.classic and 22 or (wt.preDF and 32 or 16)

		local function resizeEditBox()
			local scrollBarOffset = scrollBar:IsShown() and scrollStripWidth or 0
			local charCountWidth = t.charCount ~= false and (t.maxLetters or 0) > 0 and tostring(t.maxLetters - textBox.getText():len()):len() * 6 + 3 or 0
			textBox.scrollFrame.EditBox:SetWidth(textBox.scrollFrame:GetWidth() - scrollBarOffset - charCountWidth)
			--Update the character counter
			if textBox.scrollFrame.CharCount:IsVisible() and t.maxLetters then --REMOVE: When the character counter gets fixed..
				textBox.scrollFrame.CharCount:SetWidth(charCountWidth)
				textBox.scrollFrame.CharCount:SetText(t.maxLetters - textBox.getText():len())
				textBox.scrollFrame.CharCount:SetPoint("BOTTOMRIGHT", textBox.scrollFrame, "BOTTOMRIGHT", -scrollBarOffset + 1, 0)
			end
		end
		resizeEditBox()

		--[ Events & Behavior ]

		--Custom behavior
		t.scrollToTop = t.scrollToTop ~= false or nil
		textBox.scrollFrame.EditBox:HookScript("OnTextChanged", function(_, user)
			resizeEditBox()
			if t.scrollToTop then textBox.scrollFrame:SetVerticalScroll(0) end

			--Set attribute
			textBox:SetAttribute("changed", { user = user, text = textBox.getText() })
		end)
		textBox.scrollFrame.EditBox:HookScript("OnEditFocusGained", function(self)
			resizeEditBox()
			if t.scrollToTop ~= nil then t.scrollToTop = false end
			self:HighlightText()
		end)
		textBox.scrollFrame.EditBox:HookScript("OnEditFocusLost", function(self)
			if t.scrollToTop ~= nil then t.scrollToTop = true end
			self:ClearHighlightText()
		end)

		--Update scroll speed
		if not wt.classic then
			t.scrollSpeed = t.scrollSpeed or 0.25

			--Override the built-in update function
			textBox.scrollFrame.ScrollBar.SetPanExtentPercentage = function() --TODO: Change when Blizzard provides a better way
				local height = textBox.scrollFrame:GetHeight()
				textBox.scrollFrame.ScrollBar.panExtentPercentage = height * t.scrollSpeed / math.abs(textBox.scrollFrame.EditBox:GetHeight() - height)
			end
		elseif t.scrollSpeed then scrollBar.scrollStep = t.scrollSpeed end

		--Tooltip
		if t.tooltip then wt.AddTooltip(textBox.scrollFrame, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}, { triggers = { textBox, textBox.scrollFrame.EditBox }, }) end

		return textBox
	end

	---Create a custom button with a textline and an editbox from which text can be copied
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the copybox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Copy Box"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the copybox | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the copybox | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the copybox displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the copybox in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the copybox into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the copybox in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the copybox at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **size**? table *optional*
	--- 	- **width**? number *optional* — ***Default:*** 180
	--- 	- **height**? number *optional* — ***Default:*** 17
	--- - **layer**? Layer *optional* ― Draw [Layer](https://wowpedia.fandom.com/wiki/Layer)
	--- - **text** string ― The copyable text to be shown
	--- - **font**? string *optional* — Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormal"
	--- 	- ***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).
	--- - **color**? table *optional* — Apply the specified color to the text (overriding **t.font**)
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	--- - **justify**? string *optional* — Set the horizontal alignment of the label: "LEFT"|"RIGHT"|"CENTER" (overriding **t.font**) | ***Default:*** "LEFT"
	--- - **flipOnMouse**? boolean *optional* — Hide/Reveal the editbox on mouseover instead of after a click | ***Default:*** false
	--- - **colorOnMouse**? table *optional* — If set, change the color of the text on mouseover to the specified color (if **t.flipOnMouse** is false) | ***Default:*** *no color change*
	--- 	- **r** number ― Red | ***Range:*** (0, 1)
	--- 	- **g** number ― Green | ***Range:*** (0, 1)
	--- 	- **b** number ― Blue | ***Range:*** (0, 1)
	--- 	- **a** number ― Opacity | ***Range:*** (0, 1)
	---@return Frame copyBox A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - **flipper** [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button) — A base Button object with custom values added
	--- 	- **textLine** [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) — Text displayed in place of the editbox when the copybox isn't interacted with
	--- - **textBox** [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) — A custom editbox widget
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateEditBox(...)** for details.
	wt.CreateCopyBox = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "CopyBox")
		local title = t.title or t.name or "Copy Box"

		--[ Main Frame ]

		--Create the parent frame
		local copyBox = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		if t.arrange then copyBox.arrangementInfo = t.arrange else wt.SetPosition(copyBox, t.position) end
		local titleOffset = t.label ~= false and -12 or 0
		t.size = t.size or {}
		t.size.width = t.size.width or 180
		t.size.height = t.size.height or 17
		copyBox:SetSize(t.size.width, t.size.height - titleOffset)

		--Label
		wt.AddTitle({
			parent = copyBox,
			title = t.label ~= false and {
				offset = { x = -1, },
				width = t.size.width,
				text = title,
			} or nil,
		})

		--[ Flipper Button ]

		--Create the toggle button
		copyBox.flipper = CreateFrame("Button", name .. "Flipper", copyBox)

		--Position & dimensions
		copyBox.flipper:SetPoint("TOPLEFT", 0, titleOffset)
		copyBox.flipper:SetSize(t.size.width, t.size.height)

		--Add the displayed textline
		copyBox.flipper.textLine = wt.CreateText({
			parent = copyBox.flipper,
			name = "DisplayText",
			position = { anchor = "LEFT", },
			width = t.size.width,
			layer = t.layer,
			text = t.text,
			font = t.font,
			color = t.color,
			justify = { h = t.justify or "LEFT", },
			wrap = false
		})

		--Tooltip
		wt.AddTooltip(copyBox.flipper, {
			title = strings.copy.textline.label,
			lines = { { text = strings.copy.textline.tooltip, }, },
			anchor = "ANCHOR_RIGHT",
		})

		--[ Text CopyBox ]

		--Create the copyable textline
		copyBox.textBox = wt.CreateEditBox({
			parent = copyBox,
			name = "CopyText",
			title = strings.copy.editbox.label,
			label = false,
			tooltip = { lines = { { text = strings.copy.editbox.tooltip, }, } },
			position = {
				anchor = "LEFT",
				relativeTo = copyBox.flipper,
				relativePoint = "LEFT",
			},
			size = t.size,
			text = t.text,
			font = { normal = copyBox.flipper.textLine:GetFontObject(), },
			color = t.colorOnMouse or t.color,
			justify = { h = t.justify, },
			events = {
				OnTextChanged = function(self, user)
					if not user then return end
					self:SetText((t.colorOnMouse or t.color) and wt.Color(t.text, t.colorOnMouse or t.color) or t.text)
					self:HighlightText()
					self:SetCursorPosition(0)
				end,
				[t.flipOnMouse and "OnLeave" or "OnEditFocusLost"] = function(self)
					copyBox.textBox:Hide()
					copyBox.flipper:Show()
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
				end,
			},
		})

		--[ Events & Behavior ]

		--Toggle
		copyBox.textBox:Hide()
		copyBox.flipper:HookScript(t.flipOnMouse and "OnEnter" or "OnClick", function()
			copyBox.flipper:Hide()
			copyBox.textBox:Show()
			copyBox.textBox.editBox:SetFocus()
			copyBox.textBox.editBox:HighlightText()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end)
		if not t.flipOnMouse and t.colorOnMouse then
			copyBox.flipper:HookScript("OnEnter", function() copyBox.flipper.textLine:SetTextColor(wt.UnpackColor(t.colorOnMouse)) end)
			copyBox.flipper:HookScript("OnLeave", function() copyBox.flipper.textLine:SetTextColor(wt.UnpackColor(t.color)) end)
		end

		--Tooltip
		if t.tooltip then wt.AddTooltip(copyBox, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}) end

		return copyBox
	end

	--[ Slider ]

	---Create a new numeric input with a slider frame and other controls as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new slider
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Slider"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the slider and in the top line of the tooltip | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the slider | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the slider displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the slider in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the slider into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the slider in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the slider at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
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
	--- 	- **increment**? number *optional* — Size of value increment | ***Default:*** *the value can be freely changed (within range)*
	--- 	- **fractional**? integer *optional* — If the value is fractional, display this many decimal digits | ***Default:*** *the most amount of digits present in the fractional part of* **t.value.min**, **t.value.max** *or* **t.value.increment**
	--- - **valueBox**? boolean *optional* — Whether or not should the slider have an [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) as a child to manually enter a precise value to move the slider to | ***Default:*** true
	--- - **sideButtons**? boolean *optional* — Whether or not to add increase/decrease buttons next to the slider to change the value by the increment set in **t.step** | ***Default:*** true
	--- - ***step***? number *optional* — Add/subtract this much when clicking the increase/decrease buttons | ***Default:*** **t.value.increment** or (t.value.max - t.value.min) / 10
	--- - **altStep**? number *optional* — If set, add/subtract this much when clicking the increase/decrease buttons while holding ALT | ***Default:*** *no alternative step value*
	--- - **events**? table *optional* — Table of key, value pairs that holds script event handlers to be set for the slider
	--- 	- **[*key*]** scriptType — Event name corresponding to a defined script handler for [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame#Defined_Script_Handlers) or [Slider](https://wowpedia.fandom.com/wiki/Widget_script_handlers#Slider)
	--- 		- ***Example:*** "[OnValueChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnValueChanged)" whenever the value in the slider widget is modified.
	--- 	- **[*value*]** function — The handler function to be called when the specified event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the slider to the options data table to save & load its value automatically to/from the specified workingTable
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param* number ― The current value of the slider
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any ― The data in the working table to be converted and loaded to the slider
	--- 		- @*return* number ― The value to be set to the slider
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` number ― The saved value from the widget
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` number ― The value loaded to the widget
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	---@return Frame numeric A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - ***Note:*** Annotate `@type slider` for detailed function descriptions.
	--- - **getUniqueType** function — Returns the object type of this unique frame | ***Value:*** "ValueSlider"
	--- - **isUniqueType** function — Checks and returns if the type of this unique frame is equal to the string provided
	--- - **getValue** function — Returns the current value of the slider
	--- - **setValue** function — Set the value of the slider
	--- - **setEnabled** function — Enable or disable the slider widget based on the specified value
	--- - **slider** [Slider](https://wowpedia.fandom.com/wiki/UIOBJECT_Slider)
	--- - **valueBox**? [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox)|nil
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateEditBox(...).editBox** for details.
	--- - **decrease**? [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)|nil ― A custom button widget
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - **increase**? [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame)|nil ― A custom button widget
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **numeric.setValue(...)** was called, the increase or decrease button was clicked, or a custom value was entered via the value box
	--- 		- @*param* `self` Frame ― Reference to the slider holder frame
	--- 		- @*param* `attribute` = "changed" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `value` table ― Payload of the event
	--- 			- **user** boolean ― Whether the event was invoked by an action taken by the user
	--- 			- **value**? number
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			numeric:HookScript("OnAttributeChanged", function(self, attribute, value)
	--- 				if attribute ~= "changed" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **numeric.setEnabled(...)** was called
	--- 		- @*param* `self` Frame ― Reference to the slider holder frame
	--- 		- @*param* `attribute` = "enabled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the widget is enabled
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			numeric:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "enabled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* `self` Frame ― Reference to the slider frame
	--- 		- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
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

		--[ Main Frame ]

		---Create the parent frame
		---@class slider
		local numeric = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		if t.arrange then numeric.arrangementInfo = t.arrange else wt.SetPosition(numeric, t.position) end
		t.width = t.width or 160
		numeric:SetSize(t.width, t.valueBox ~= false and 48 or 31)

		--[ Slider ]

		--Create the slider frame
		numeric.slider = CreateFrame("Slider", name .. "Frame", numeric, "OptionsSliderTemplate")

		--Position & dimensions
		numeric.slider:SetPoint("TOP", 0, -15)
		numeric.slider:SetWidth(t.width - (t.sideButtons ~= false and 40 or 0))

		--Label
		local label = nil
		if t.label ~= false then
			label = _G[name .. "FrameText"]
			label:SetFontObject("GameFontNormal")
			label:SetText(title)
			label:SetPoint("TOP", numeric, "TOP", 0, 2)
		else _G[name .. "Text"]:Hide() end

		--Set min/max value labels
		_G[name .. "FrameLow"]:SetText(tostring(t.value.min))
		_G[name .. "FrameHigh"]:SetText(tostring(t.value.max))
		_G[name .. "FrameLow"]:SetPoint("TOPLEFT", numeric.slider, "BOTTOMLEFT")
		_G[name .. "FrameHigh"]:SetPoint("TOPRIGHT", numeric.slider, "BOTTOMRIGHT")

		--Set slider values
		numeric.slider:SetMinMaxValues(t.value.min, t.value.max)
		if t.value.increment then
			numeric.slider:SetValueStep(t.value.increment)
			numeric.slider:SetObeyStepOnDrag(true)
		end

		--[ Events & Behavior ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do numeric.slider:HookScript(key, value) end end

		--Custom behavior
		numeric.slider:HookScript("OnMouseUp", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		numeric.slider:HookScript("OnValueChanged", function(_, value, user) if user then numeric:SetAttribute("changed", { user = true, value = value }) end end)

		--Tooltip
		if t.tooltip then wt.AddTooltip(numeric.slider, {
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
				tostring(t.value.increment or 0):gsub("-?[%d]+[%.]?([%d]*).*", "%1"):len()
			)
			local decimalPattern = ""
			for _ = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end
			local matchPattern = "(" .. (t.value.min < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
			local replacePattern = "%1" .. (decimals > 0 and "%2" or "")

			--Create the editbox frame
			numeric.valueBox = wt.CreateEditBox({
				parent = numeric,
				name = "ValueBox",
				label = false,
				tooltip = {
					title = strings.slider.value.label,
					lines = { { text = strings.slider.value.tooltip, }, }
				},
				position = {
					anchor = "TOP",
					relativeTo = numeric.slider,
					relativePoint = "BOTTOM",
				},
				size = { width = 64, },
				customizable = true,
				text = tostring(wt.Round(numeric.slider:GetValue(), decimals)):gsub(matchPattern, replacePattern),
				font = {
					normal = "GameFontHighlightSmall",
					disabled = "GameFontDisableSmall",
				},
				justify = { h = "CENTER", },
				maxLetters = tostring(math.floor(t.value.max)):len() + (decimals + (decimals > 0 and 1 or 0)) + (t.value.min < 0 and 1 or 0),
				events = {
					OnChar = function(self, _, text) self:SetText(text:gsub(matchPattern, replacePattern)) end,
					OnEnterPressed = function(self)
						local v = self:GetNumber()
						if t.value.increment then v = max(t.value.min, min(t.value.max, floor(v * (1 / t.value.increment) + 0.5) / (1 / t.value.increment))) end
						self.setText(tostring(wt.Round(v, decimals)):gsub(matchPattern, replacePattern))
						numeric.slider:SetValue(v)

						--Call listener & set Attribute
						local value = numeric.slider:GetValue()
						if (t.events or {}).OnValueChanged then t.events.OnValueChanged(numeric.slider, value, true) end
						numeric:SetAttribute("changed", { user = true, value = value })
					end,
					OnEscapePressed = function(self) self.setText(tostring(wt.Round(numeric.slider:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
				},
			}).editBox

			--Backdrop
			wt.SetBackdrop(numeric.valueBox, {
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
			}, {
				OnEnter = { rule = function(self) return self:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end },
				OnLeave = {},
			})

			--Add slider listener
			numeric.slider:HookScript("OnValueChanged", function(_, v) numeric.valueBox.setText(tostring(wt.Round(v, decimals)):gsub(matchPattern, replacePattern)) end)
		end

		--[ Side Buttons ]

		if t.sideButtons ~= false then
			t.step = t.step or t.value.increment or ((t.value.max - t.value.min) / 10)

			--[ Decrease Value ]

			--Create button frame
			numeric.decrease = wt.CreateButton({
				parent = numeric,
				name = "SelectPrevious",
				title = "-",
				tooltip = {
					title = strings.slider.decrease.label,
					lines = {
						{ text = strings.slider.decrease.tooltip[1]:gsub("#VALUE", t.step), },
						t.altStep and { text = strings.slider.decrease.tooltip[2]:gsub("#VALUE", t.altStep), } or nil,
					}
				},
				position = {
					anchor = "LEFT",
					relativeTo = numeric.slider,
					relativePoint = "LEFT",
					offset = { x = -21, }
				},
				size = { width = 20, height = 20 },
				customizable = true,
				font = {
					normal = "GameFontHighlightMedium",
					highlight = "GameFontHighlightMedium",
					disabled = "GameFontDisableMed2",
				},
				events = { OnClick = function()
					numeric.slider:SetValue(numeric.slider:GetValue() - (IsAltKeyDown() and t.altStep or t.step))

					--Call listener & set attribute
					local value = numeric.slider:GetValue()
					if (t.events or {}).OnValueChanged then t.events.OnValueChanged(numeric.slider, value, true) end
					numeric:SetAttribute("changed", { user = true, value = value })
				end, },
				dependencies = { { frame = numeric.slider, evaluate = function(value) return value > t.value.min end }, }
			})

			--Backdrop
			wt.SetBackdrop(numeric.decrease, {
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

			--[ Increase Value ]

			--Create the button frame
			numeric.increase = wt.CreateButton({
				parent = numeric,
				name = "SelectNext",
				title = "+",
				tooltip = {
					title = strings.slider.increase.label,
					lines = {
						{ text = strings.slider.increase.tooltip[1]:gsub("#VALUE", t.step), },
						t.altStep and { text = strings.slider.increase.tooltip[2]:gsub("#VALUE", t.altStep), } or nil,
					}
				},
				position = {
					anchor = "RIGHT",
					relativeTo = numeric.slider,
					relativePoint = "RIGHT",
					offset = { x = 21, }
				},
				size = { width = 20, height = 20 },
				customizable = true,
				font = {
					normal = "GameFontHighlightMedium",
					highlight = "GameFontHighlightMedium",
					disabled = "GameFontDisableMed2",
				},
				events = { OnClick = function()
					numeric.slider:SetValue(numeric.slider:GetValue() + (IsAltKeyDown() and t.altStep or t.step))

					--Call listener & set attribute
					local value = numeric.slider:GetValue()
					if (t.events or {}).OnValueChanged then t.events.OnValueChanged(numeric.slider, value, true) end
					numeric:SetAttribute("changed", { user = true, value = value })
				end, },
				dependencies = { { frame = numeric.slider, evaluate = function(value) return value < t.value.max end }, }
			})

			--Backdrop
			wt.SetBackdrop(numeric.increase, {
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

		---Returns the object type of this unique frame
		---@return string UniqueFrameType type ***Value:*** "ValueSlider"
		numeric.getUniqueType = function() return "ValueSlider" end

		---Checks and returns if the type of this unique frame is equal to the string provided
		---@param type string
		---@return boolean
		numeric.isUniqueType = function(type) return type == "ValueSlider" end

		---Returns the current value of the slider
		---@return number
		numeric.getValue = function() return numeric.slider:GetValue() end

		---Set the value of the slider
		---@param value number A valid number value to call [Slider:SetValue(...)](https://wowpedia.fandom.com/wiki/Widget_API#Slider) with
		---@param user? boolean Whether to flag the change as being done via a user interaction | ***Default:*** false
		numeric.setValue = function(value, user)
			numeric.slider:SetValue(value)

			--Set attribute
			numeric:SetAttribute("changed", { user = user, value = numeric.slider:GetValue() })
		end

		---Enable or disable the slider widget based on the specified value
		---@param state boolean Enable the input if true, disable if not
		numeric.setEnabled = function(state)
			--Set attribute
			numeric:SetAttribute("enabled", state)

			--Update state
			numeric.slider:SetEnabled(state)
			if t.valueBox ~= false then numeric.valueBox.setEnabled(state) end
			if t.sideButtons ~= false then
				numeric.decrease.setEnabled(state and wt.CheckDependencies({ { frame = numeric.slider, evaluate = function(value) return value > t.value.min end }, }))
				numeric.increase.setEnabled(state and wt.CheckDependencies({ { frame = numeric.slider, evaluate = function(value) return value < t.value.max end }, }))
			end
			if label then label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
		end

		--State & dependencies
		if t.disabled then numeric.setEnabled(false) else numeric:SetAttribute("enabled", true) end
		if t.dependencies then wt.SetDependencies(t.dependencies, numeric.setEnabled) end

		--[ Options Data Management ]

		if t.optionsData then
			--Add to the options data management
			wt.AddOptionsData(numeric, numeric.getUniqueType(), t.optionsData)

			--Handle changes
			if t.optionsData.onChange or t.optionsData.instantSave ~= false then
				numeric:HookScript("OnAttributeChanged", function(_, attribute, value)
					if attribute ~= "changed" or not value.user then return end

					--Save the value to the working table
					if t.optionsData.instantSave ~= false then if t.optionsData.workingTable and t.optionsData.storageKey and value.value ~= nil then
						if t.optionsData.convertSave then value.value = t.optionsData.convertSave(value.value) end
						t.optionsData.workingTable[t.optionsData.storageKey] = value.value
					end end

					--Call specified onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end)
			end
		end

		return numeric
	end

	--[ Color Picker ]

	---Create a custom color picker frame with HEX(A) input while utilizing the [ColorPickerFrame](https://wowpedia.fandom.com/wiki/Using_the_ColorPickerFrame) opened with a button
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — Reference to the frame to set as the parent of the new color picker button
	--- - **name**? string *optional* — Unique string used to set the name of the new frame | ***Default:*** "Color Picker"
	--- 	- ***Note:*** Space characters will be removed.
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true
	--- - **title**? string *optional* — Text to be shown above the color picker frame | ***Default:*** **t.name**
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the color picker frame | ***Default:*** true
	--- - **tooltip**? table *optional* — List of text lines to be added to the tooltip of the color picker displayed when mousing over the frame
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
	--- - **arrange**? table *optional* ― When set, automatically position the color picker in a columns within rows arrangement via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**
	--- 	- **newRow**? boolean *optional* — Place the color picker into a new row within its container instead of adding it to **t.arrange.row** | ***Default:*** true
	--- 	- **row**? integer *optional* — Place the color picker in the specified existing row | ***Default:*** *last row*
	--- 		- ***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.
	--- 	- **column**? integer *optional* — Place the color picker at this position within its row | ***Default:*** *new column at the end of the row*
	--- 		- ***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when **t.arrange** is not set | ***Default:*** "TOPLEFT" if **t.arrange** == nil
	--- 	- **anchor**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional* — ***Default:*** "TOPLEFT"
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* — ***Default:*** 0
	--- 		- **y**? number *optional* — ***Default:*** 0
	--- - **width**? number *optional* ― The height is defaulted to 36, the width may be specified | ***Default:*** 120
	--- - **startColor**? table *optional* — Values to use as the starting color | ***Default:*** **t.optionsData[t.optionsData.workingTable][t.optionsData.storageKey]**
	--- 	- **r** number ― Red | ***Range:*** (0, 1) | ***Default:*** 1
	--- 	- **g** number ― Green | ***Range:*** (0, 1) | ***Default:*** 1
	--- 	- **b** number ― Blue | ***Range:*** (0, 1) | ***Default:*** 1
	--- 	- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- 		- ***Note:*** If the alpha start value was not set, configure the color picker to handle RBG values exclusively instead of the full RGBA.
	--- - **onColorUpdate**? function *optional* — The function to be called when the color is changed by user interaction
	--- 	- @*param* `r` number ― Red | ***Range:*** (0, 1)
	--- 	- @*param* `g` number ― Green | ***Range:*** (0, 1)
	--- 	- @*param* `b` number ― Blue | ***Range:*** (0, 1)
	--- 	- @*param* `a`? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- - **onCancel**? function *optional* — The function to be called when the color change is cancelled (after calling **t.onColorUpdate**)
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load | ***Default:*** false
	--- 	- ***Note:*** Dependency evaluations described in **t.dependencies** may re-enable the widget.
	--- - **dependencies**? table *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** | ***Default:*** *no evaluation, only for checkboxes*
	--- 			- @*param* `value`? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame *(see **Overloads**)*
	--- 			- @*return* `evaluation` boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: string) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as an editbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the color picker to the options data table to save & load its value automatically to/from the specified workingTable
	--- 	- **optionsKey** string ― A unique key referencing a collection of options data management rules to handle together
	--- 	- **workingTable**? table *optional* ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey**? string *optional* ― Key of the variable inside the working/storage table
	--- 	- **instantSave**? boolean *optional* ― Immediately save the data from the widget to the working table whenever it's changed by the user | ***Default:*** true
	--- 		- ***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data before it is saved
	--- 		- @*param* `r` number ― Red | ***Range:*** (0, 1)
	--- 		- @*param* `g` number ― Green | ***Range:*** (0, 1)
	--- 		- @*param* `b` number ― Blue | ***Range:*** (0, 1)
	--- 		- @*param* `a`? number ― Opacity | ***Range:*** (0, 1)
	--- 		- @*return* any ― The converted value
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data before it is loaded
	--- 		- @*param* any *(any number of arguments)* ― The data in the working table to be converted
	--- 		- @*return* `r` number ― Red | ***Range:*** (0, 1)
	--- 		- @*return* `g` number ― Green | ***Range:*** (0, 1)
	--- 		- @*return* `b` number ― Blue | ***Range:*** (0, 1)
	--- 		- @*return* `a`? number ― Opacity | ***Range:*** (0, 1)
	--- 	- **onSave**? function *optional* — Function to be be called after the data of this widget has been saved
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` table ― The saved value from the widget
	--- 			- **r** number ― Red | ***Range:*** (0, 1)
	--- 			- **g** number ― Green | ***Range:*** (0, 1)
	--- 			- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- 	- **onLoad**? function *optional* — Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)
	--- 		- @*param* `self` Frame ― Reference to the widget
	--- 		- @*param* `value` table ― The value loaded to the widget
	--- 			- **r** number ― Red | ***Range:*** (0, 1)
	--- 			- **g** number ― Green | ***Range:*** (0, 1)
	--- 			- **b** number ― Blue | ***Range:*** (0, 1)
	--- 			- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- 	- **onChange**? table *optional* ― List of new or already defined functions to call after the value of the widget was changed by the user or via options data management
	--- 		- **[*key*]**? string ― A unique key to point to a newly defined function to be added to options data management | ***Default:*** *Next assigned index*
	--- 		- **[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**
	--- 			- ***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.
	---@return Frame colorPicker A base [Frame](https://wowpedia.fandom.com/wiki/UIOBJECT_Frame) object with custom values, functions and events added
	--- - ***Note:*** Annotate `@type colorPicker` for detailed function descriptions.
	--- - **getUniqueType** function ― Returns the object type of this unique frame | ***Value:*** "ColorPicker"
	--- - **isUniqueType** function ― Checks and returns if the type of this unique frame matches the string provided entirely
	--- - **getColor** function ― Returns the currently set color values
	--- - **setColor** function ― Sets the color and text of each element
	--- - **setEnabled** function ― Enable or disable the color picker widget based on the specified value
	--- - **setFaded** function ― Toggle the fading of the color picker elements when [ColorPickerFrame](https://wowpedia.fandom.com/wiki/Using_the_ColorPickerFrame) is opened (and this is not the color picker frame it has been opened for)
	--- 	- ***Note:*** Inputs will still be blocked while the [ColorPickerFrame](https://wowpedia.fandom.com/wiki/Using_the_ColorPickerFrame) is open whether or not this color piker is the active one.
	--- - **pickerButton** [Button](https://wowpedia.fandom.com/wiki/UIOBJECT_Button) — A base Button object with custom values, functions added
	--- 	- **gradient**? [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture)|nil — A base Texture object
	--- 	- **checker**? [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture)|nil — A base Texture object
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateButton(...)** for details.
	--- - **hexBox**? [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox)|nil — A base EditBox object with custom functions added
	--- 	- ***Note:*** See ***WidgetToolbox*.CreateEditBox(...)** for details.
	--- - ***Events:***
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **colorPicker.setColor(...)** was called (by color change via user interaction or programmatically)
	--- 		- @*param* `self` Frame ― Reference to the color picker frame
	--- 		- @*param* `attribute` = "colored" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `value` table ― Payload of the event
	--- 			- **user** boolean ― Whether the event was invoked by an action taken by the user
	--- 			- **color** table ― Table containing the applied color values
	--- 				- **r** number ― Red | ***Range:*** (0, 1)
	--- 				- **g** number ― Green | ***Range:*** (0, 1)
	--- 				- **b** number ― Blue | ***Range:*** (0, 1)
	--- 				- **a**? number *optional* ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			colorPicker:HookScript("OnAttributeChanged", function(self, attribute, value)
	--- 				if attribute ~= "colored" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **colorPicker.setEnabled(...)** was called
	--- 		- @*param* `self` Frame ― Reference to the color picker frame
	--- 		- @*param* `attribute` = "enabled" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether the widget is enabled
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			colorPicker:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "enabled" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked after **colorPicker.pickerButton** was clicked
	--- 		- @*param* `self` Frame ― Reference to the color picker frame
	--- 		- @*param* `attribute` = "active" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Whether this color picker is the active one the [ColorPickerFrame](https://wowpedia.fandom.com/wiki/Using_the_ColorPickerFrame) has been opened for
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			colorPicker:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "active" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	--- 	- **[OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged)** ― Evoked when options data is loaded automatically
	--- 		- @*param* `self` Frame ― Reference to the color picker frame
	--- 		- @*param* `attribute` = "loaded" string ― Unique attribute key used to identify which OnAttributeChanged event to handle
	--- 		- @*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true
	--- 		- ***Example:*** Add a script handler as listener:
	--- 			```
	--- 			colorPicker:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 				if attribute ~= "loaded" then return end
	--- 				--Do something
	--- 			end)
	--- 			```
	wt.CreateColorPicker = function(t)
		local name = (t.append ~= false and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "ColorPicker")
		local title = t.title or t.name or "Color Picker"
		if not t.startColor then if t.optionsData then if t.optionsData.workingTable and t.optionsData.storageKey then
			t.startColor = wt.Clone(t.optionsData.workingTable[t.optionsData.storageKey])
		else t.startColor = {} end else t.startColor = {} end else t.startColor = {} end

		--[ Main Frame ]

		---Create the color picker frame
		---@class colorPicker
		local colorPicker = CreateFrame("Frame", name, t.parent)

		--Position & dimensions
		if t.arrange then colorPicker.arrangementInfo = t.arrange else wt.SetPosition(colorPicker, t.position) end
		t.width = t.width or 120
		colorPicker:SetSize(t.width, 36)

		--Label
		local label = wt.AddTitle({
			parent = colorPicker,
			title = t.label ~= false and {
				offset = { x = 4, },
				text = title,
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
				lines = { { text = t.startColor.a and strings.color.picker.tooltip:gsub("#ALPHA", strings.color.picker.alpha) or strings.color.picker.tooltip:gsub("#ALPHA", ""), }, }
			},
			position = { offset = { y = -14 } },
			size = { width = 34, height = 22 },
			customizable = true,
			events = { OnClick = function(self)
				--Starting colors
				local startR, startG, startB, startA = self:GetBackdropColor()

				--Color picker button background update utility
				local function colorUpdate()
					if not colorPicker:GetAttribute("enabled") then return end

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
				colorPicker.setFaded(true)

				--Set the color update functions
				ColorPickerFrame.func = colorUpdate
				ColorPickerFrame.opacityFunc = colorUpdate

				--Reset on cancel
				ColorPickerFrame.cancelFunc = function()
					colorPicker.setColor(startR, startG, startB, startA, true)
					if t.onCancel then t.onCancel() end
				end

				--Set attribute
				colorPicker:SetAttribute("active", true)
			end, },
		})

		--Backdrop
		wt.SetBackdrop(colorPicker.pickerButton, {
			background = {
				texture = {
					size = 5,
					insets = { l = 2.5, r = 2.5, t = 2.5, b = 2.5 },
				},
				color = { r = t.startColor.r or 1, g = t.startColor.g or 1, b = t.startColor.b or 1, a = t.startColor.a or 1 }
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

		--Create the editbox frame
		colorPicker.hexBox = wt.CreateEditBox({
			parent = colorPicker,
			name = "HEXBox",
			title = strings.color.hex.label,
			label = false,
			tooltip = { lines = { { text = strings.color.hex.tooltip .. "\n\n" .. strings.misc.example .. ": #2266BB" .. (t.startColor.a and "AA" or ""), }, } },
			position = {
				relativeTo = colorPicker.pickerButton,
				relativePoint = "TOPRIGHT",
			},
			size = { width = t.width - colorPicker.pickerButton:GetWidth(), height = colorPicker.pickerButton:GetHeight() },
			insets = { l = 6, },
			customizable = true,
			font = {
				normal = "GameFontWhiteSmall",
				disabled = "GameFontDisableSmall",
			},
			maxLetters = 7 + (t.startColor.a and 2 or 0),
			events = {
				OnChar = function(self, _, text) self.setText(text:gsub("^(#?)([%x]*).*", "%1%2"), false) end,
				OnEnterPressed = function(_, text)
					local r, g, b, a = wt.HexToColor(text)
					colorPicker.setColor(r, g, b, a or 1, true)
				end,
				OnEscapePressed = function(self) self.setText(wt.ColorToHex(colorPicker.getColor())) end,
			},
		}).editBox

		--Backdrop
		wt.SetBackdrop(colorPicker.hexBox, {
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
		}, {
			OnEnter = { rule = function(self) return self:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end },
			OnLeave = {},
		})

		--[ Getters & Setters ]

		---Returns the object type of this unique frame
		---@return UniqueFrameType type ***Value:*** "ColorPicker"
		colorPicker.getUniqueType = function() return "ColorPicker" end

		---Checks and returns if the type of this unique frame matches the string provided entirely
		---@param type string
		---@return boolean
		colorPicker.isUniqueType = function(type) return type == "ColorPicker" end

		---Returns the currently set color values
		---@return number r Red | ***Range:*** (0, 1)
		---@return number g Green | ***Range:*** (0, 1)
		---@return number b Blue | ***Range:*** (0, 1)
		---@return number? a Opacity | ***Range:*** (0, 1)
		colorPicker.getColor = function() return colorPicker.pickerButton:GetBackdropColor() end

		---Sets the color and text of each element
		---@param r number Red | ***Range:*** (0, 1)
		---@param g number Green | ***Range:*** (0, 1)
		---@param b number Blue | ***Range:*** (0, 1)
		---@param a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 1
		---@param user? boolean Whether to flag the call as a result of a user interaction calling registered listeners | ***Default:*** false
		colorPicker.setColor = function(r, g, b, a, user)
			colorPicker.pickerButton:SetBackdropColor(r, g, b, a or 1)
			colorPicker.pickerButton.gradient:SetVertexColor(r, g, b, 1)
			colorPicker.hexBox.setText(wt.ColorToHex(r, g, b, a))

			--Call listener & set attribute
			if user and t.onColorUpdate then t.onColorUpdate(r, g, b, a) end
			colorPicker:SetAttribute("colored", { user = user, color = wt.PackColor(r, g, b, a) })
		end

		---Enable or disable the color picker widget based on the specified value
		---@param state boolean Enable the input if true, disable if no
		colorPicker.setEnabled = function(state)
			--Set attribute
			colorPicker:SetAttribute("enabled", state)

			--Update state
			colorPicker.pickerButton.setEnabled(state)
			colorPicker.hexBox.setEnabled(state)
			if label then label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
			if ColorPickerFrame:IsVisible() then
				local active = colorPicker:GetAttribute("active")

				colorPicker.pickerButton:EnableMouse(false)
				colorPicker.hexBox:EnableMouse(false)
				colorPicker.setFaded(active)

				--Update the color when re-enabled
				if active then
					local r, g, b = ColorPickerFrame:GetColorRGB()
					local a = OpacitySliderFrame:GetValue() or 1
					colorPicker.setColor(r, g, b, a, true)
				end
			end
		end

		---Toggle the fading of the color picker elements when [ColorPickerFrame](https://wowpedia.fandom.com/wiki/Using_the_ColorPickerFrame) is opened (and this is not the color picker frame it has been opened for)
		--- - ***Note:*** Inputs will still be blocked while the [ColorPickerFrame](https://wowpedia.fandom.com/wiki/Using_the_ColorPickerFrame) is open whether or not this color piker is the active one.
		---@param state boolean Wether to fade the color picker elements
		colorPicker.setFaded = function(state)
			local a = (state or not ColorPickerFrame:IsVisible()) and 1 or 0.4

			colorPicker.hexBox:SetAlpha(a)
			label:SetAlpha(a)
		end

		--State & dependencies
		if t.disabled then colorPicker.setEnabled(false) else colorPicker:SetAttribute("enabled", true) end
		if t.dependencies then wt.SetDependencies(t.dependencies, colorPicker.setEnabled) end

		--[ Events & Behavior ]

		--Custom behavior
		ColorPickerFrame:HookScript("OnShow", function()
			colorPicker.pickerButton:EnableMouse(false)
			colorPicker.hexBox:EnableMouse(false)
			colorPicker.setFaded(false)

			--Set attribute
			colorPicker:SetAttributeNoHandler("active", false)
		end)
		ColorPickerFrame:HookScript("OnHide", function()
			colorPicker.pickerButton:EnableMouse(true)
			colorPicker.hexBox:EnableMouse(true)
			colorPicker.setFaded(true)

			--Set attribute
			colorPicker:SetAttribute("active", false)
		end)

		--Base state
		colorPicker:SetAttributeNoHandler("active", false)

		--Tooltip
		if t.tooltip then wt.AddTooltip(colorPicker, {
			title = t.tooltip.title or title,
			lines = t.tooltip.lines,
			anchor = "ANCHOR_RIGHT",
		}) end

		--[ Options Data Management ]

		if t.optionsData then
			--Add to the options data management
			wt.AddOptionsData(colorPicker, colorPicker.getUniqueType(), t.optionsData)

			--Handle changes
			if t.optionsData.onChange or t.optionsData.instantSave ~= false then
				colorPicker:HookScript("OnAttributeChanged", function(_, attribute, value)
					if attribute ~= "colored" or not value.user then return end

					--Save the value to the working table
					if t.optionsData.instantSave ~= false then if t.optionsData.workingTable and t.optionsData.storageKey and value.color ~= nil then
						if t.optionsData.convertSave then value.color = t.optionsData.convertSave(wt.UnpackColor(value.color)) end
						t.optionsData.workingTable[t.optionsData.storageKey] = value.color
					end end

					--Call specified onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end)
			end
		end

		return colorPicker
	end


	--[[ REGISTER ]]

	ns.WidgetToolbox = WidgetTools.RegisterToolbox(addonNameSpace, toolboxVersion, ns.WidgetToolbox, ns.textures.logo)
end