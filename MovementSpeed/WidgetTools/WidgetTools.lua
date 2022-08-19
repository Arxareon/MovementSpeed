--[[ ADDON INFO ]]

--Addon namespace string & table (Note: Since WidgetToolbox is only loaded once for the first addon, WidgetToolbox will reference that addon's namespace for every other addon!)
local addonNameSpace, ns = ...


--[[ WIDGET TOOLS DATA ]]

--Version string
ns.WidgetToolsVersion = "1.4.1"

--Global WidgetTools table containing toolbox subtables for each respective WidgetTools version (WidgetToolbox["version_string"])
if not WidgetToolbox then WidgetToolbox = {} end

--Create the global reference subtable for the current version
if not WidgetToolbox[ns.WidgetToolsVersion] then

	--Create Toolbox
	WidgetToolbox[ns.WidgetToolsVersion] = {}


	--[[ LOCALIZATIONS ]]

	local english = {
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
		value = {
			label = "Specify the value",
			tooltip = "Enter any value within range."
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
		misc = {
			cancel = "Cancel",
			example = "Example",
		},
		separator = ",", --Thousand separator character
		decimal = ".", --Decimal character
	}

	--Load Strings
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


	--[[ ALIASES ]]

	---@alias UniqueFrameType
	---|"Selector"
	---|"Dropdown"
	---|"ColorPicker"


	--[[ UTILITIES ]]

	--[ Table Management ]

	---Get the sorted key value pairs of a table ([Documentation: Sort](https://www.lua.org/pil/19.3.html))
	---@param t table Table to be sorted (in an ascending order and/or alphabetically, based on the < operator)
	---@return function iterator Function returning the Key, Value pairs of the table in order
	WidgetToolbox[ns.WidgetToolsVersion].SortedPairs = function(t)
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
	local SortedPairs = WidgetToolbox[ns.WidgetToolsVersion].SortedPairs --Short local reference

	---Convert and format an input object to string to be dumped to the in-game chat
	---@param object any Object to dump out
	---@param outputTable? table Table to put the formatted output lines in
	---@param name? string A name to print out [Default: *the dumped object will not be named*]
	---@param depth? integer How many levels of subtables to print out (root level: 0) [Default: *full depth*]
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
			local line = (currentKey and currentKey .. " = " or "Dump " .. name .. "value:") .. (skip and "…" or tostring(object))
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
			for k, v in SortedPairs(object) do GetDumpOutput(v, outputTable, nil, blockrule, depth, k, currentLevel + 1) end
		end
	end

	---Dump an object and its contents to the in-game chat
	---@param object any Object to dump out
	---@param name? string A name to print out [Default: *the dumped object will not be named*]
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
	---@param depth? integer How many levels of subtables to print out (root level: 0) [Default: *full depth*]
	---@param linesPerMessage? integer Print the specified number of output lines in a single chat message (all lines in one message: 0) [Default: 7]
	WidgetToolbox[ns.WidgetToolsVersion].Dump = function(object, name, blockrule, depth, linesPerMessage)
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
	local Dump = WidgetToolbox[ns.WidgetToolsVersion].Dump --Short local reference

	---Convert table to code chunk
	--- - ***Note:*** Append "return " to the start when loading via [load()](https://www.lua.org/manual/5.2/manual.html#lua_load).
	---@param table table The table to convert
	---@param compact? boolean Whether spaces and indentations should be trimmed or not [Default: false]
	---@param colored? boolean Whether the string should be formatted by included coloring escape sequences [Default: false]
	---@param currentLevel? number
	---@return string chunk
	WidgetToolbox[ns.WidgetToolsVersion].TableToString = function(table, compact, colored, currentLevel)
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
				chunk = chunk .. WidgetToolbox[ns.WidgetToolsVersion].TableToString(v, compact, colored, currentLevel + 1)
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
	WidgetToolbox[ns.WidgetToolsVersion].Clone = function(object)
		if type(object) ~= "table" then return object end
		local copy = {}
		for k, v in pairs(object) do
			copy[k] = WidgetToolbox[ns.WidgetToolsVersion].Clone(v)
		end
		return copy
	end

	---Copy all values at matching keys from a sample table to another table recursively keeping references (for subtables as well)
	---@param tableToCopy table Reference to the table to copy the values from
	---@param targetTable table Reference to the table to copy the values to
	WidgetToolbox[ns.WidgetToolsVersion].CopyValues = function(tableToCopy, targetTable)
		if type(tableToCopy) ~= "table" or type(targetTable) ~= "table" then return end
		if next(targetTable) == nil then return end --The target table is empty
		for k, v in pairs(targetTable) do
			if tableToCopy[k] == nil then return end --This key doesn't exist in the sample table
			if type(v) == "table" then
				WidgetToolbox[ns.WidgetToolsVersion].CopyValues(tableToCopy[k], v)
			else
				targetTable[k] = tableToCopy[k]
			end
		end
	end

	---Remove all nil, empty or otherwise invalid items from a data table
	---@param tableToCheck table Reference to the table to prune
	---@param valueChecker? function Optional function describing rules to validate values
	--- - @*param* **k** number|string
	--- - @*param* **v** any [non-table]
	--- - @*return* boolean ― True if **v** is to be accepted as valid, false if not
	WidgetToolbox[ns.WidgetToolsVersion].RemoveEmpty = function(tableToCheck, valueChecker)
		if type(tableToCheck) ~= "table" then return end
		for k, v in pairs(tableToCheck) do
			if type(v) == "table" then
				if next(v) == nil then --The subtable is empty
					tableToCheck[k] = nil --Remove the empty subtable
				else
					WidgetToolbox[ns.WidgetToolsVersion].RemoveEmpty(v, valueChecker)
				end
			else
				local remove = v == nil or v == "" --The value is empty or doesn't exist
				if valueChecker and not remove then remove = not valueChecker(k, v) end--The value is invalid
				if remove then tableToCheck[k] = nil end --Remove the key value pair
			end
		end
	end

	---Compare two tables to check for and fill in missing data from one to the other
	---@param tableToCheck table|any Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already "table")
	---@param tableToSample table Reference to the table to sample data from
	WidgetToolbox[ns.WidgetToolsVersion].AddMissing = function(tableToCheck, tableToSample)
		if type(tableToSample) ~= "table" then return end
		if next(tableToSample) == nil then return end --The sample table is empty
		for k, v in pairs(tableToSample) do
			if type(tableToCheck) ~= "table" then tableToCheck = {} end --The table to check isn't actually a table - turn it into a new one
			if tableToCheck[k] == nil then --The sample key doesn't exist in the table to check
				if v ~= nil and v ~= "" then
					tableToCheck[k] = v --Add the item if the value is not empty or nil
				end
			else
				WidgetToolbox[ns.WidgetToolsVersion].AddMissing(tableToCheck[k], tableToSample[k])
			end
		end
	end

	---Remove unused or outdated data from a table while trying to keep any old data
	---@param tableToCheck table Reference to the table to remove unneeded key, value pairs from
	---@param tableToSample table Reference to the table to sample data from
	---@param recoveredData? table
	---@return table recoveredData Table containing the removed key, value pairs
	WidgetToolbox[ns.WidgetToolsVersion].RemoveMismatch = function(tableToCheck, tableToSample, recoveredData)
		if recoveredData == nil then recoveredData = {} end
		if type(tableToCheck) ~= "table" or type(tableToSample) ~= "table" then return recoveredData end
		if next(tableToCheck) == nil then return end --The table to check is empty
		for k, v in pairs(tableToCheck) do
			if tableToSample[k] == nil then --The checked key doesn't exist in the sample table
				--Save the old item to the recovered data container
				recoveredData[k] = v
				--Remove the unneeded item
				tableToCheck[k] = nil
			else
				recoveredData = WidgetToolbox[ns.WidgetToolsVersion].RemoveMismatch(tableToCheck[k], tableToSample[k], recoveredData)
			end
		end
		return recoveredData
	end

	--[ Math ]

	---Round a decimal fraction to the specified number of digits
	---@param number number A fractional number value to round
	---@param decimals? number Specify the number of decimal places to round the number to [Default: 0]
	---@return number
	WidgetToolbox[ns.WidgetToolsVersion].Round = function(number, decimals)
		local multiplier = 10 ^ (decimals or 0)
		return math.floor(number * multiplier + 0.5) / multiplier
	end

	--[ String Formatting ]

	---Add coloring escape sequences to a string
	---@param text string Text to add coloring to
	---@param color table Table containing the color values
	--- - **r** number ― Red [Range: 0, 1]
	--- - **g** number ― Green [Range: 0, 1]
	--- - **b** number ― Blue [Range: 0, 1]
	--- - **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	---@return string
	WidgetToolbox[ns.WidgetToolsVersion].Color = function(text, color)
		local r, g, b, a = WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(color)
		return WrapTextInColorCode(text, WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(r, g, b, a, true, false))
	end

	---Format a number string to include thousand separation
	---@param value number Number value to turn into a string with thousand separation
	---@param decimals? number Specify the number of decimal places to display if the number is a fractional value [Default: 0]
	---@param round? boolean Round the number value to the specified number of decimal places [Default: true]
	---@param trim? boolean Trim trailing zeros in decimal places [Default: true]
	---@return string
	WidgetToolbox[ns.WidgetToolsVersion].FormatThousands = function(value, decimals, round, trim)
		value = round == false and value or WidgetToolbox[ns.WidgetToolsVersion].Round(value, decimals)
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
	WidgetToolbox[ns.WidgetToolsVersion].Clear = function(s)
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

	--[ Convert color table <-> RGB(A) values ]

	---Return a table constructed from color values
	---@param red number [Range: 0, 1]
	---@param green number [Range: 0, 1]
	---@param blue number [Range: 0, 1]
	---@param alpha? number Opacity [Range: 0, 1; Default: 1]
	---@return number table
	WidgetToolbox[ns.WidgetToolsVersion].PackColor = function(red, green, blue, alpha)
		 return { r = red, g = green, b = blue, a = alpha or 1 }
	end

	---Return the color values found in a table
	---@param table table Table containing the color values
	--- - **r** number ― Red [Range: 0, 1]
	--- - **g** number ― Green [Range: 0, 1]
	--- - **b** number ― Blue [Range: 0, 1]
	--- - **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	---@param alpha? boolean Specify whether to return the full RGBA set or just the RGB values [Default: true]
	---@return number r
	---@return number g
	---@return number b
	---@return number? a
	WidgetToolbox[ns.WidgetToolsVersion].UnpackColor = function(table, alpha)
		if type(table) ~= "table" then return end
		if alpha ~= false then
			return table.r, table.g, table.b, table.a or 1
		else
			return table.r, table.g, table.b
		end
	end

	--[ Convert HEX <-> RGB(A) values ]

	---Convert RGB(A) color values [Range: 0, 1] to HEX color code
	---@param r number Red [Range: 0, 1]
	---@param g number Green [Range: 0, 1]
	---@param b number Blue [Range: 0, 1]
	---@param a? number Alpha [Range: 0, 1; Default: *no alpha*]
	---@param alphaFirst? boolean Put the alpha value first: ARGB output instead of RGBA [Default: false]
	---@param hashtag? boolean Whether to add a "#" to the beginning of the color description [Default: true]
	---@return string hex Color code in HEX format (Examples: RGB - "#2266BB", RGBA - "#2266BBAA")
	WidgetToolbox[ns.WidgetToolsVersion].ColorToHex = function(r, g, b, a, alphaFirst, hashtag)
		local hex = hashtag ~= false and "#" or ""
		if a and alphaFirst then hex = hex .. string.format("%02x", math.ceil(a * 255)) end
		hex = hex .. string.format("%02x", math.ceil(r * 255)) .. string.format("%02x", math.ceil(g * 255)) .. string.format("%02x", math.ceil(b * 255))
		if a and not alphaFirst then hex = hex .. string.format("%02x", math.ceil(a * 255)) end
		return hex:upper()
	end

	---Convert a HEX color code into RGB or RGBA [Range: 0, 1]
	---@param hex string String in HEX color code format (Examples: RGB - "#2266BB", RGBA - "#2266BBAA" where the "#" is optional)
	---@return number r Red value [Range: 0, 1]
	---@return number g Green value [Range: 0, 1]
	---@return number b Blue value [Range: 0, 1]
	---@return number? a Alpha value [Range: 0, 1]
	WidgetToolbox[ns.WidgetToolsVersion].HexToColor = function(hex)
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

	--[ Frame Setup ]

	---Set the visibility of a frame based on the value provided
	---@param frame Frame Reference to the frame to hide or show
	---@param visible boolean If false, hide the frame, show it if true
	WidgetToolbox[ns.WidgetToolsVersion].SetVisibility = function(frame, visible)
		if visible then frame:Show() else frame:Hide() end
	end

	---Set the position and anchoring of a frame when it is unknown which parameters will be nil when calling [Region:SetPoint()](https://wowpedia.fandom.com/wiki/API_Region_SetPoint)
	---@param frame Frame Reference to the frame to be moved
	---@param anchor AnchorPoint Base anchor point
	---@param relativeTo? Frame [Default: UIParent *(the entire screen)*]
	---@param relativePoint? AnchorPoint [Default: **anchor**]
	---@param offsetX? number [Default: 0]
	---@param offsetY? number [Default: 0]
	---@param userPlaced? boolean Whether to set the position of the frame to be user placed [Default: false]
	WidgetToolbox[ns.WidgetToolsVersion].PositionFrame = function(frame, anchor, relativeTo, relativePoint, offsetX, offsetY, userPlaced)
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
		if frame["SetUserPlaced"] and frame:IsMovable() then frame:SetUserPlaced(userPlaced == true) end
	end

	--[ Widget Dependency Handling ]

	---Check all dependencies (disable / enable rules) of a frame
	---@param rules table Indexed, 0-based table containing the dependency rules of the frame object
	--- - **[*index*]** table ― Parameters of a dependency rule
	--- 	- **frame** Frame — Reference to the widget the state of a widget is tied to
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, the type of which depends on the type of the frame (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	---@return boolean state
	local function CheckDependencies(rules)
		local state = true
		for i = 0, #rules do
			--Blizzard widgets
			if rules[i].frame:IsObjectType("CheckButton") then
				if rules[i].evaluate then state = rules[i].evaluate(rules[i].frame:GetChecked()) else state = rules[i].frame:GetChecked() end
			elseif rules[i].frame:IsObjectType("Slider") then state = rules[i].evaluate(rules[i].frame:GetValue())
			elseif rules[i].frame:IsObjectType("Frame") then
				--Custom widgets
				if rules[i].frame.isUniqueType("Dropdown") then state = rules[i].evaluate(UIDropDownMenu_GetSelectedValue(rules[i].frame))
				elseif rules[i].frame.isUniqueType("Selector") then state = rules[i].evaluate(rules[i].frame.getSelected()) end
			end
			if not state then break end
		end
		return state
	end

	---Set the dependencies (disable / enable rules) of a frame based on a ruleset
	---@param rules table Indexed, 0-based table containing the dependency rules of the frame object
	--- - **[*index*]** table ― Parameters of a dependency rule
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, the type of which depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 		- ***Overloads:***
	--- 		- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	---@param setState function Function to call to set the state of the frame
	--- - @*param* boolean
	local function SetDependencies(rules, setState)
		for i = 0, #rules do
			if rules[i].frame.HookScript and rules[i].frame.IsObjectType then
				rules[i].frame:HookScript("OnAttributeChanged", function(_, name, value) if name == "loaded" and value then setState(CheckDependencies(rules)) end end)
				--Blizzard Widgets
				if rules[i].frame:IsObjectType("CheckButton") then rules[i].frame:HookScript("OnClick", function() setState(CheckDependencies(rules)) end)
				elseif rules[i].frame:IsObjectType("Slider") then rules[i].frame:HookScript("OnValueChanged", function() setState(CheckDependencies(rules)) end)
				elseif rules[i].frame:IsObjectType("Frame") then
					if rules[i].frame.isUniqueType("Dropdown") or rules[i].frame.isUniqueType("Selector") then
						rules[i].frame:HookScript("OnAttributeChanged", function(_, name, value) if name == "selected" then setState(CheckDependencies(rules)) end end)
					end
				end
			end
		end
	end

	--[ Interface Options Data Management ]

	--Collection of rules describing where to save/load options data to/from, and what to call in the process
	local optionsTable

	---Add a connection between an options widget and a DB entry to the options data table under the specified options key
	---@param widget table Widget table containing reference to its UI frame
	--- - **frame**? Frame *optional* ― Reference to the widget to be saved & loaded data to & from (if it's a custom WidgetTools object with UniqueFrameType)
	---@param type FrameType|UniqueFrameType Type of the widget object (string)
	--- - ***Example:*** The return value of [**widget**:GetObjectType()](https://wowpedia.fandom.com/wiki/API_UIObject_GetObjectType) (for applicable Blizzard-built widgets).
	--- - ***Note:*** If GetObjectType() would return "Frame" in case of a Frame with UIDropDownMenuTemplate or another uniquely built frame, provide a UniqueFrameType.
	---@param optionsKey table A unique key referencing the collection of widget options data to add this data to to be saved & loaded together
	---@param storageTable table Reference to the table containing the value modified by the options widget
	---@param storageKey string Key of the variable inside the storage table
	---@param convertSave? function Function to convert or modify the data while it is being saved from the widget to the storage table
	--- - @*param* boolean ― The current value of the widget
	--- - @*return* any ― The converted data to be saved to the storage table
	---@param convertLoad? function Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- - @*param* any ― The data in the storage table to be converted and loaded to the widget
	--- - @*return* boolean ― The value to be set to the widget
	---@param onSave? function This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- - @*param* **self**? Frame ― Reference to the widget
	--- - @*param* **value**? any ― Reference to the widget
	---@param onLoad? function This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- - @*param* **self**? Frame ― Reference to the widget
	--- - @*param* **value**? any ― The value loaded to the frame
	WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData = function(widget, type, optionsKey, storageTable, storageKey, convertSave, convertLoad, onSave, onLoad)
		--Check the tables
		if not optionsTable then optionsTable = {} end
		if not optionsTable[optionsKey] then optionsTable[optionsKey] = {} end
		if not optionsTable[optionsKey][type] then optionsTable[optionsKey][type] = {} end
		--Add the options data
		optionsTable[optionsKey][type][not optionsTable[optionsKey][type][0] and 0 or #optionsTable[optionsKey][type] + 1] = {
			widget = widget,
			storageTable = storageTable,
			storageKey = storageKey,
			convertSave = convertSave,
			convertLoad = convertLoad,
			onSave = onSave,
			onLoad = onLoad
		}
	end

	---Save all data from the widgets to the storage table(s) specified in the collection of options data referenced by the options key
	---@param optionsKey table A unique key referencing the collection of widget options data to be saved
	WidgetToolbox[ns.WidgetToolsVersion].SaveOptionsData = function(optionsKey)
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
					elseif k == "Selector" then value = v[i].widget.getSelected()
					elseif k == "Dropdown" then value = UIDropDownMenu_GetSelectedValue(v[i].widget)
					elseif k == "ColorPicker" then value = WidgetToolbox[ns.WidgetToolsVersion].PackColor(v[i].widget.getColor())
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
	--- - [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) will be triggered for all frames:
	--- 	- First, before the widget's value is loaded the event will be called with:
	--- 		- **name**: "loaded"
	--- 		- **value**: false
	--- 	- Second, after the widget's value has been successfully loaded:
	--- 		- **name**: "loaded"
	--- 		- **value**: true
	---@param optionsKey table A unique key referencing the collection of widget options data to be loaded
	WidgetToolbox[ns.WidgetToolsVersion].LoadOptionsData = function(optionsKey)
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
						v[i].widget:SetText(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "Selector" then
						v[i].widget:SetAttribute("loaded", false)
						v[i].widget.setSelected(value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "Dropdown" then
						v[i].widget:SetAttribute("loaded", false)
						UIDropDownMenu_SetSelectedValue(v[i].widget, value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "ColorPicker" then
						v[i].widget:SetAttribute("loaded", false)
						v[i].widget.setColor(WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(value))
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
	--- - ***Note:*** To make a custom hyperlink handled by an addon, *"item"* may be used as **type**. (Following details are to be provided in **content** to be able to use **WidgetToolbox[ns.WidgetToolsVersion].SetHyperlinkHandler** to set a function to handle clicks on the custom hyperlink).
	---@param content string A colon-separated chain of parameters determined by the [type of the hyperlink](https://wowpedia.fandom.com/wiki/Hyperlinks#Types) (Example: "parameter1:parameter2:parameter3")
	--- - ***Note:*** When using *"item"* as **type** with the intention of setting a custom hyperlink to be handled by an addon, set the first parameter of **content** to a unique addon identifier key, and the second parameter to a unique key signifying the type of the hyperlink specific to the addon (if the addon handles multiple different custom types of hyperlinks), in order to be able to set unique hyperlink click handlers via **WidgetToolbox[ns.WidgetToolsVersion].SetHyperlinkHandler**.
	---@param text string Clickable text to be displayed as the hyperlink
	---@return string
	WidgetToolbox[ns.WidgetToolsVersion].Hyperlink = function(type, content, text)
		return "\124H" .. type .. ":" .. content .. "\124h" .. text .. "\124h"
	end

	---Register a function to handle custom hyperlink clicks
	---@param addon string Addon namespace key used for a subtable in **WidgetToolbox[ns.WidgetToolsVersion].HyperlinkHandlers**
	---@param handlerKey string Unique custom hyperlink type key used to identify the specific handler function within **WidgetToolbox[ns.WidgetToolsVersion].HyperlinkHandlers[addonKey]**
	---@param handlerFunction function Function to be called by clicking on a hyperlink text created via |Hitem:**addonKey**:**handlerKey**:*content*|h*Text*|h
	WidgetToolbox[ns.WidgetToolsVersion].SetHyperlinkHandler = function(addon, handlerKey, handlerFunction)
		--Set the table containing the hyperlink handlers
		if not WidgetToolbox[ns.WidgetToolsVersion].HyperlinkHandlers then
			--Create the table
			WidgetToolbox[ns.WidgetToolsVersion].HyperlinkHandlers = {}
			--Hook the hyperlink handler caller
			hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(...)
				local _, linkType = ...
				local _, addonID, handlerID, content = strsplit(":", linkType, 4)
				--Check if it's a registered addon
				for key, addonHandlers in pairs(WidgetToolbox[ns.WidgetToolsVersion].HyperlinkHandlers) do
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
		if not WidgetToolbox[ns.WidgetToolsVersion].HyperlinkHandlers[addon] then WidgetToolbox[ns.WidgetToolsVersion].HyperlinkHandlers[addon] = {} end
		WidgetToolbox[ns.WidgetToolsVersion].HyperlinkHandlers[addon][handlerKey] = handlerFunction
	end


	--[[ ASSETS & RESOURCES ]]

	--Color palette
	local colors = {
		normal = WidgetToolbox[ns.WidgetToolsVersion].PackColor(HIGHLIGHT_FONT_COLOR:GetRGB()),
		title = WidgetToolbox[ns.WidgetToolsVersion].PackColor(NORMAL_FONT_COLOR:GetRGB()),
	}

	--Textures
	local textures = {
		alphaBG = "Interface/AddOns/" .. addonNameSpace .. "/WidgetTools/Textures/AlphaBG.tga",
		gradientBG = "Interface/AddOns/" .. addonNameSpace .. "/WidgetTools/Textures/GradientBG.tga",
	}


	--[[ UX HELPERS ]]

	--[ Custom Tooltip]

	---Create and set up a new custom GameTooltip frame
	---@param name string Unique string piece to place in the name of the the tooltip to distinguish it from other tooltips (use the addon namespace string as an example)
	---@return GameTooltip tooltip
	WidgetToolbox[ns.WidgetToolsVersion].CreateGameTooltip = function(name)
		local tooltip = CreateFrame("GameTooltip", name .. "GameTooltip", nil, "GameTooltipTemplate")
		tooltip:SetFrameStrata("DIALOG")
		tooltip:SetScale(0.9)
		--Title
		local left = tooltip:GetName() .. "TextLeft" .. 1
		local right = tooltip:GetName() .. "TextRight" .. 1
		tooltip:AddFontStrings(tooltip:CreateFontString(left, nil, GameFontNormalMed1), tooltip:CreateFontString(right, nil, GameFontNormalMed1))
		_G[left]:SetFontObject(GameFontNormalMed1)
		_G[right]:SetFontObject(GameFontNormalMed1)
		return tooltip
	end

	local customTooltip = WidgetToolbox[ns.WidgetToolsVersion].CreateGameTooltip("WidgetTools" .. ns.WidgetToolsVersion)

	---Set up a show a GameTooltip for a frame
	---@param tooltip? GameTooltip Reference to the tooltip widget to set up [Default: *default WidgetTools custom tooltip*]
	---@param parent Frame Owner frame the tooltip to be shown for
	---@param anchor TooltipAnchor [GameTooltip anchor](https://wowpedia.fandom.com/wiki/API_GameTooltip_SetOwner#Arguments)
	---@param title string String to be shown as the tooltip title
	---@param textLines? table Table containing text lines to be added to the tooltip [indexed, 0-based]
	--- - **[*index*]** table ― Parameters of a line of text
	--- 	- **text** string ― Text to be displayed in the line
	--- 	- **font**? string|FontObject *optional* ― The FontObject to set for this line [Default: GameTooltipTextSmall]
	--- 	- **color**? table *optional* ― Table containing the RGB values to color this line with [Default: HIGHLIGHT_FONT_COLOR (white)]
	--- 		- **r** number ― Red [Range: 0, 1]
	--- 		- **g** number ― Green [Range: 0, 1]
	--- 		- **b** number ― Blue [Range: 0, 1]
	--- 	- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped [Default: true]
	---@param offsetX? number [Default: 0]
	---@param offsetY? number [Default: 0]
	---@return GameTooltip tooltip (Don't forget to hide later!)
	WidgetToolbox[ns.WidgetToolsVersion].AddTooltip = function(tooltip, parent, anchor, title, textLines, offsetX, offsetY)
		if not tooltip then tooltip = customTooltip end
		--Position
		tooltip:SetOwner(parent, anchor, offsetX, offsetY)
		--Title
		tooltip:AddLine(title, colors.title.r, colors.title.g, colors.title.b, true)
		--Text
		if textLines then
			local offset = 2
			for i = 0, #textLines do
				--Set FontString
				local left = tooltip:GetName() .. "TextLeft" .. i + offset
				local right = tooltip:GetName() .. "TextRight" .. i + offset
				local font = textLines[i].font or GameTooltipTextSmall
				if not _G[left] or not _G[right] then tooltip:AddFontStrings(tooltip:CreateFontString(left, nil, font), tooltip:CreateFontString(right, nil, font)) end
				_G[left]:SetFontObject(font)
				_G[left]:SetJustifyH("LEFT")
				_G[right]:SetFontObject(font)
				_G[right]:SetJustifyH("RIGHT")
				--Add line
				if i == 1 then --Third line is bugged (on Retail), skip it
					if (select(4, GetBuildInfo())) >= 90200 then --Temporary workaround for Retail
						tooltip:AddLine(" \n") --FIXME: Find out why the third line is bugged
						offset = 3
					end
				end
				local color = textLines[i].color or colors.normal
				tooltip:AddLine(textLines[i].text, color.r, color.g, color.b, textLines[i].wrap ~= false)
			end
		end
		--Show
		tooltip:Show() --Don't forget to hide later!
		return tooltip
	end

	--[ Popup Dialogue Box ]

	---Create a popup dialogue with an accept function and cancel button
	---@param t table Parameters are to be provided in this table
	--- - **addon** string — The name of the addon's folder (the addon namespace not the display title)
	--- - **name** string — Appended to **t.addon** as a unique identifier key in the global **StaticPopupDialogs** table
	--- - **text** string — The text to display as the message in the popup window
	--- - **accept**? string *optional* — The text to display as the label of the accept button [Default: **t.name**]
	--- - **cancel**? string *optional* — The text to display as the label of the cancel button [Default: **WidgetToolbox[ns.WidgetToolsVersion].strings.misc.cancel**]
	--- - **onAccept**? function *optional* — The function to be called when the accept button is pressed and an OnAccept event happens
	--- - **onCancel**? function *optional* — The function to be called when the cancel button is pressed, the popup is overwritten (by another popup for instance) or the popup expires and an OnCancel event happens
	---@return string key The unique identifier key created for this popup in the global **StaticPopupDialogs** table used as the parameter when calling [StaticPopup_Show()](https://wowwiki-archive.fandom.com/wiki/Creating_simple_pop-up_dialog_boxes#Displaying_the_popup) or [StaticPopup_Hide()](https://wowwiki-archive.fandom.com/wiki/Creating_simple_pop-up_dialog_boxes#Hiding_the_popup)
	WidgetToolbox[ns.WidgetToolsVersion].CreatePopup = function(t)
		local key = t.addon:upper() .. "_" .. t.name:gsub("%s+", "_"):upper()
		StaticPopupDialogs[key] = {
			text = t.text,
			button1 = t.accept or t.name,
			button2 = t.cancel or strings.misc.cancel,
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
	---@return Frame reload Reference to the reload notice panel frame
	WidgetToolbox[ns.WidgetToolsVersion].CreateReloadNotice = function()
		if reloadFrame then
			reloadFrame:Show()
			return reloadFrame
		end
		local reload = WidgetToolbox[ns.WidgetToolsVersion].CreatePanel({
			parent = UIParent,
			name = "WidgetToolsReloadNotice",
			title = strings.reload.title,
			description = strings.reload.description,
			position = {
				anchor = "TOPRIGHT",
				offset = { x = -300, y = -80 }
			},
			size = { width = 240, height = 74 },
		})
		WidgetToolbox[ns.WidgetToolsVersion].CreateButton({
			parent = reload,
			name = "ReloadButton",
			title = strings.reload.accept.label,
			tooltip = { [0] = { text = strings.reload.accept.tooltip, } },
			position = { offset = { x = 10, y = -40 } },
			width = 120,
			onClick = function() ReloadUI() end
		})
		WidgetToolbox[ns.WidgetToolsVersion].CreateButton({
			parent = reload,
			name = "CancelButton",
			title = strings.reload.cancel.label,
			tooltip = { [0] = { text = strings.reload.cancel.tooltip, } },
			position = {
				anchor = "TOPRIGHT",
				offset = { x = -10, y = -40 }
			},
			width = 80,
			onClick = function() reload:Hide() end
		})
		reload:SetMovable(true)
		reload:SetScript("OnMouseDown", function() reload:StartMoving() end)
		reload:SetScript("OnMouseUp", function() reload:StopMovingOrSizing() end)
		reloadFrame = reload
		return reload
	end


	--[[ ART ELEMENTS ]]

	--[ Text ]

	---Create a FontString with the specified text and template
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame ― The frame to create the text in
	--- - **name**? string *optional* — String appended to the name of **t.parent** used to set the name of the new [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) [Default: "Text"]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* — [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **width**? number *optional*
	--- - **text** string ― Text to be shown
	--- - **layer**? Layer *optional* ― Draw [Layer](https://wowpedia.fandom.com/wiki/Layer)
	--- - **template**? string *optional* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) [Default: "GameFontNormal"]
	--- - **font**? table *optional* ― Table containing font properties used for [SetFont](https://wowwiki-archive.fandom.com/wiki/API_FontInstance_SetFont)
	--- 	- **path** string ― Path to the font file relative to the WoW client directory
	--- 	- **size**? number *optional* ― [Default: *size defined by the template*]
	--- 	- **style**? string *optional* ― Comma separated string of styling flags: "OUTLINE"|"THICKOUTLINE"|"THINOUTLINE"|"MONOCHROME" .. [Default: *style defined by the template*]
	--- - **color**? table *optional* — Apply the specified color to the text
	--- 	- **r** number ― Red [Range: 0, 1]
	--- 	- **g** number ― Green [Range: 0, 1]
	--- 	- **b** number ― Blue [Range: 0, 1]
	--- 	- **a** number ― Opacity [Range: 0, 1]
	--- - **justify**? string *optional* — Set the horizontal justification of the text: "LEFT"|"RIGHT"|"CENTER" [Default: "CENTER"]
	--- - **wrap**? boolean *optional* — Whether or not to allow the text lines to wrap [Default: true]
	---@return FontString text
	WidgetToolbox[ns.WidgetToolsVersion].CreateText = function(t)
		local name = "Text"
		if t.name then name = t.name:gsub("%s+", "") end
		local text = t.parent:CreateFontString(t.parent:GetName() .. name, t.layer, t.template and t.template or "GameFontNormal")
		--Position & dimensions
		if not t.position then text:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = (t.position.offset or {}).y or 0
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(text, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		if t.width then text:SetWidth(t.width) end
		--Font & text
		if t.font then text:SetFont(t.font.path, t.font.size, t.font.style) end
		if t.color then text:SetTextColor(WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(t.color)) end
		if t.justify then text:SetJustifyH(t.justify) end
		if t.wrap ~= false then text:SetWordWrap(t.wrap) end
		text:SetText(t.text)
		return text
	end

	--[ Frame Title & Description ]

	---Add a title & description to a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame ― The frame panel to add the title & description to
	--- - **title**? table *optional*
	--- 	- **text** string ― Text to be shown as the main title of the frame
	--- 	- **template**? string *optional* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) [Default: "GameFontNormal"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **offset**? table *optional* ― The offset from the anchor point relative to the specified frame
	--- 		- **x**? number *optional* ― Horizontal offset value [Default: 0]
	--- 		- **y**? number *optional* ― Vertical offset value [Default: 0]
	--- 	- **width**? number *optional* [Default: *width of the parent frame*]
	--- 	- **justify**? table *optional* — Set the horizontal justification of the text: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **color**? table *optional* — Apply the specified color to the title
	--- 		- **r** number ― Red [Range: 0, 1]
	--- 		- **g** number ― Green [Range: 0, 1]
	--- 		- **b** number ― Blue [Range: 0, 1]
	--- 		- **a** number ― Opacity [Range: 0, 1]
	--- - **description**? table *optional*
	--- 	- **text** string ― Text to be shown as the description of the frame
	--- 	- **template**? string *optional* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) [Default: "GameFontNormal"]
	--- 	- **offset**? table *optional* ― The offset from the "BOTTOMLEFT" point of the main title
	--- 		- **x**? number *optional* ― Horizontal offset value [Default: 0]
	--- 		- **y**? number *optional* ― Vertical offset value [Default: 0]
	--- 	- **width**? number *optional* [Default: *width of the parent frame*]
	--- 	- **justify**? table *optional* — Set the horizontal justification of the text: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **color**? table *optional* — Apply the specified color to the description
	--- 		- **r** number ― Red [Range: 0, 1]
	--- 		- **g** number ― Green [Range: 0, 1]
	--- 		- **b** number ― Blue [Range: 0, 1]
	--- 		- **a** number ― Opacity [Range: 0, 1]
	---@return FontString|nil title
	---@return FontString|nil description
	WidgetToolbox[ns.WidgetToolsVersion].AddTitle = function(t)
		--Title
		local title = nil
		if t.title then title = WidgetToolbox[ns.WidgetToolsVersion].CreateText({
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
			color = t.title.color,
			justify = t.title.justify or "LEFT",
		}) end
		--Description
		local description = nil
		if t.description then description = WidgetToolbox[ns.WidgetToolsVersion].CreateText({
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
			template =  t.description.template,
			color = t.description.color,
			justify = t.description.justify or "LEFT",
		}) end
		return title, description
	end

	--[ Texture Image ]

	---Create a texture image
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture)
	--- - **name**? string *optional* — String appended to the name of **t.parent** used to set the name of the new [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture) [Default: "Texture"]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **size** table
	--- 	- **width** number
	--- 	- **height** number
	--- - **path** string ― Path to the specific texture file relative to the root directory of the specific WoW client.
	--- 	- ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga).
	--- 	- ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.
	--- 	- ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client.
	--- - **tile**? number *optional*
	---@return Texture texture
	WidgetToolbox[ns.WidgetToolsVersion].CreateTexture = function(t)
		local name = "Texture"
		if t.name then name = t.name:gsub("%s+", "") end
		local texture = t.parent:CreateTexture(t.parent:GetName() .. name)
		--Position & dimensions
		if not t.position then texture:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = (t.position.offset or {}).y or 0
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(texture, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		texture:SetSize(t.size.width, t.size.height)
		--Set asset
		if t.tile then texture:SetTexture(t.path, t.tile) else texture:SetTexture(t.path) end
		return texture
	end


	--[[ CONTAINERS ]]

	--[ Scrollable Frame ]

	---Create an empty vertically scrollable frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to place the scroll frame into
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **size**? table *optional*
	--- 	- **width**? number *optional* — Horizontal size of the main scroll frame [Default: *width of the parent frame*]
	--- 	- **height**? number *optional* — Vertical size of the main scroll frame [Default: *height of the parent frame*]
	--- - **scrollSize** table
	--- 	- **width**? number *optional* — Horizontal size of the scrollable child frame [Default: *width of the scroll frame* - 20]
	--- 	- **height** number *optional* — Vertical size of the scrollable child frame
	--- - **scrollSpeed**? number *optional* — Scroll step value [Default: *half of the height of the scroll bar*]
	---@return Frame scrollChild
	---@return Frame scrollFrame
	WidgetToolbox[ns.WidgetToolsVersion].CreateScrollFrame = function(t)
		local parentName = t.parent:GetName()
		local scrollFrame = CreateFrame("ScrollFrame", parentName .. "ScrollFrame", t.parent, "UIPanelScrollFrameTemplate")
		--Position & dimensions
		if not t.position then scrollFrame:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = (t.position.offset or {}).y or 0
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(scrollFrame, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		scrollFrame:SetSize((t.size or {}).width or t.parent:GetWidth(), (t.size or {}).height or t.parent:GetHeight())
		--Scrollbar & buttons
		_G[scrollFrame:GetName() .. "ScrollBarScrollUpButton"]:ClearAllPoints()
		_G[scrollFrame:GetName() .. "ScrollBarScrollUpButton"]:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", -2, -3)
		_G[scrollFrame:GetName() .. "ScrollBarScrollDownButton"]:ClearAllPoints()
		_G[scrollFrame:GetName() .. "ScrollBarScrollDownButton"]:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", -2, 3)
		_G[scrollFrame:GetName() .. "ScrollBar"]:ClearAllPoints()
		_G[scrollFrame:GetName() .. "ScrollBar"]:SetPoint("TOP", _G[scrollFrame:GetName() .. "ScrollBarScrollUpButton"], "BOTTOM")
		_G[scrollFrame:GetName() .. "ScrollBar"]:SetPoint("BOTTOM", _G[scrollFrame:GetName() .. "ScrollBarScrollDownButton"], "TOP")
		if t.scrollSpeed then _G[scrollFrame:GetName() .. "ScrollBar"].scrollStep = t.scrollSpeed end
		--Scrollbar background
		local scrollBarBG = CreateFrame("Frame", scrollFrame:GetName() .. "ScrollBarBackground", scrollFrame,  BackdropTemplateMixin and "BackdropTemplate")
		scrollBarBG:SetPoint("TOPLEFT", _G[scrollFrame:GetName() .. "ScrollBar"], "TOPLEFT", -1, -3)
		scrollBarBG:SetSize(_G[scrollFrame:GetName() .. "ScrollBar"]:GetWidth() + 1, _G[scrollFrame:GetName() .. "ScrollBar"]:GetHeight() - 6)
		scrollBarBG:SetBackdrop({
			bgFile = "Interface/ChatFrame/ChatFrameBackground",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true, tileSize = 5, edgeSize = 12,
			insets = {left = 2, right = 2, top = 2, bottom = 2},
		})
		scrollBarBG:SetBackdropColor(0.2, 0.2, 0.2, 0.4)
		scrollBarBG:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8)
		--Scrolled child Frame
		local scrollChild = CreateFrame("Frame", parentName .. "ScrollChild", scrollFrame)
		scrollChild:SetPoint("TOPLEFT")
		scrollChild:SetSize(t.scrollSize.width or scrollFrame:GetWidth() - 20, t.scrollSize.height)
		scrollFrame:SetScrollChild(scrollChild)
		return scrollChild, scrollFrame
	end

	--[ Category Panel Frame ]

	---Create a new frame as a category panel
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The main options frame to set as the parent of the new panel
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "Panel"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **title**? string *optional* — Text to be shown as the title of the panel [Default: **t.name**]
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above to the panel [Default: true]
	--- - **description**? string *optional* — Text to be shown as the subtitle or description of the panel
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **size** table
	--- 	- **width**? number *optional* — [Default: *width of the parent frame* - 32]
	--- 	- **height** number
	---@return Frame panel
	WidgetToolbox[ns.WidgetToolsVersion].CreatePanel = function(t)
		local name = "Panel"
		if t.name then name = t.name:gsub("%s+", "") end
		local panel = CreateFrame("Frame", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent, BackdropTemplateMixin and "BackdropTemplate")
		--Position & dimensions
		if not t.position then UnitThreatPercentageOfLead:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = (t.position.offset or {}).y or 0
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(panel, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		panel:SetSize(t.size.width or t.parent:GetWidth() - 32, t.size.height)
		--Backdrop
		panel:SetBackdrop({
			bgFile = "Interface/ChatFrame/ChatFrameBackground",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true, tileSize = 5, edgeSize = 16,
			insets = {left = 4, right = 4, top = 4, bottom = 4},
		})
		panel:SetBackdropColor(0.15, 0.15, 0.15, 0.35)
		panel:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8)
		--Title & description
		WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
			parent = panel,
			title = t.label ~= false and {
				text = t.title or t.name or "Panel",
				offset = { x = 10, y = 16 },
			} or nil,
			description = t.description and {
				text = t.description,
				template = "GameFontHighlightSmall",
				offset = { x = 4, y = -16 },
			} or nil
		})
		return panel
	end

	--[ Interface Options Category Page ]

	---Create an new ScrollFrame as the child of an Interface Options Panel
	---@param optionsPanel Frame Reference to the options category panel frame
	---@param scrollHeight number Set the height of the scrollable child frame to the specified value
	---@param scrollSpeed? number Set the scroll rate to the specified value [Default: *half of the height of the scroll bar*]
	---@return Frame scrollChild The scrollable child frame of the ScrollFrame
	local function AddOptionsPanelScrollFrame(optionsPanel, scrollHeight, scrollSpeed)
		--Create the ScrollFrame
		local scrollChild = WidgetToolbox[ns.WidgetToolsVersion].CreateScrollFrame({
			parent = optionsPanel,
			position = {
				anchor = "TOPLEFT",
				offset = { x = 0, y = -4 }
			},
			size = { width = optionsPanel:GetWidth() - 4, height = optionsPanel:GetHeight() - 8 },
			scrollSize = { width = optionsPanel:GetWidth() - 20, height = scrollHeight, },
			scrollSpeed = scrollSpeed
		})
		--Reparent, reposition and resize default elements
		_G[optionsPanel:GetName() .. "Title"]:SetParent(scrollChild)
		_G[optionsPanel:GetName() .. "Description"]:SetParent(scrollChild)
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(_G[optionsPanel:GetName() .. "Title"], "TOPLEFT", nil, nil, 16, -12)
		_G[optionsPanel:GetName() .. "Title"]:SetWidth(_G[optionsPanel:GetName() .. "Title"]:GetWidth() - 20)
		_G[optionsPanel:GetName() .. "Description"]:SetWidth(_G[optionsPanel:GetName() .. "Description"]:GetWidth() - 20)
		if _G[optionsPanel:GetName() .. "Icon"] then
			_G[optionsPanel:GetName() .. "Icon"]:SetParent(scrollChild)
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(_G[optionsPanel:GetName() .. "Icon"], "TOPRIGHT", nil, nil, -16, -12)
		end
		return scrollChild
	end

	---Create an new Interface Options Panel frame and add it to the Interface options
	---@param t table Parameters are to be provided in this tables
	--- - **parent**? string *optional* — The display name of the options category to be set as the parent category, making this its subcategory [Default: *set as a main category*]
	--- - **addon** string — The name of the addon's folder (the addon namespace not the display title)
	--- - **name**? string *optional* — String appended to **t.addon** and followed by "Options" used to set the name of the new frame
	--- - **title**? string *optional* — Text to be shown as the title of the options panel [Default: *current addon title*]
	--- - **description**? string *optional* — Text to be shown as the description below the title of the options panel
	--- - **logo**? string *optional* — Path to the texture file to be added as an icon to the top right corner of the panel
	--- - **titleLogo**? boolean *optional* — Append the texture specified as **t.logo** to the title of the interface options button as well [Default: false]
	--- - **scroll**? table *optional* — Create an empty ScrollFrame for the category panel
	--- 	- **height** number — Set the height of the scrollable child frame to the specified value
	--- 	- **speed**? number *optional* — Set the scroll rate to the specified value [Default: *half of the height of the scroll bar*]
	--- - **okay**? function *optional* — The function to be called when the "Okay" button is clicked
	--- - **cancel**? function *optional* — The function to be called when the "Cancel" button is clicked
	--- - **default**? function *optional* — The function to be called when either the "All Settings" or "These Settings" (***Options Category Panel-specific***) button is clicked from the "Defaults" dialogue (**t.refresh** will be called automatically afterwards)
	--- - **refresh**? function *optional* — The function to be called when the interface panel is loaded
	--- - **optionsKey**? table ―  A unique key referencing the collection of widget options data to be saved & loaded with this options category page
	--- - **autoSave**? boolean *optional* — If true, automatically save all data from the storage tables to the widgets described in the collection of options data referenced by **t.optionsKey** [Default: true if **t.optionsKey** is set]
	--- 	- ***Note:*** If **t.optionsKey** is not set, the automatic save will not be executed even if **t.autoSave** is true.
	--- - **autoLoad**? boolean *optional* — If true, automatically load the values of all widgets to the storage tables described in the collection of options data referenced by **t.optionsKey** [Default: true if **t.optionsKey** is set]
	--- 	- ***Note:*** If **t.optionsKey** is not set, the automatic load will not be executed even if **t.autoLoad** is true.
	---@return Frame optionsPanel
	---@return Frame? scrollChild
	WidgetToolbox[ns.WidgetToolsVersion].CreateOptionsPanel = function(t)
		local name = ""
		if t.name then name = t.name:gsub("%s+", "") end
		local optionsPanel = CreateFrame("Frame", t.addon .. name .. "Options", InterfaceOptionsFramePanelContainer)
		--Position, dimensions & visibility
		optionsPanel:SetSize(InterfaceOptionsFramePanelContainer:GetSize())
		optionsPanel:SetPoint("TOPLEFT") --Preload the frame
		optionsPanel:Hide()
		--Set the category name
		local title = t.title
		if not title then _, title = GetAddOnInfo(t.addon) end
		optionsPanel.name = title .. (t.logo and t.titleLogo and " |T" .. t.logo .. ":0|t" or "")
		--Set as a subcategory or a parent category
		if t.parent then optionsPanel.parent = t.parent end
		--Title & description
		WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
			parent = optionsPanel,
			title = {
				text = title,
				template = "GameFontNormalLarge",
				offset = { x = 16, y = -16 },
				width = optionsPanel:GetWidth() - (t.logo and 72 or 32),
			},
			description = t.description and {
				text = t.description,
				template = "GameFontHighlightSmall",
				offset = { y = -8 },
				width = optionsPanel:GetWidth() - (t.logo and 72 or 32),
			} or nil
		})
		--Icon texture
		if t.logo then
			WidgetToolbox[ns.WidgetToolsVersion].CreateTexture({
				parent = optionsPanel,
				name = "Icon",
				position = {
					anchor = "TOPRIGHT",
					offset = { x = -16, y = -16 }
				},
				size = { width = 36, height = 36 },
				path = t.logo,
			})
		end
		--Event handlers
		if t.okay or t.autoSave or t.optionsKey then optionsPanel.okay = function()
			if t.autoSave or t.optionsKey then WidgetToolbox[ns.WidgetToolsVersion].SaveOptionsData(t.optionsKey) end
			if t.okay then t.okay() end
		end end
		if t.cancel or t.autoLoad or t.optionsKey then optionsPanel.cancel = function()
			if t.autoLoad or t.optionsKey then WidgetToolbox[ns.WidgetToolsVersion].LoadOptionsData(t.optionsKey) end
			if t.cancel then t.cancel() end
		end end
		if t.default then optionsPanel.default = t.default end --Refresh will be called automatically afterwards
		if t.refresh or t.autoLoad or t.optionsKey then optionsPanel.refresh = function()
			if t.autoLoad or t.optionsKey then WidgetToolbox[ns.WidgetToolsVersion].LoadOptionsData(t.optionsKey) end
			if t.refresh then t.refresh() end
		end end
		--Add to the Interface options
		InterfaceOptions_AddCategory(optionsPanel)
		--Make scrollable
		if t.scroll then return optionsPanel, AddOptionsPanelScrollFrame(optionsPanel, t.scroll.height, t.scroll.speed) end
		return optionsPanel
	end


	--[[ DATA ELEMENTS ]]

	--[ Button ]

	---Create a button frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new button
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "Button"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **title**? string *optional* — Text to be shown on the button and in the top line of the tooltip [Default: **t.name**]
	--- - **label**? boolean *optional* — Whether or not to display **t.title** on the button frame [Default: true]
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the button
	--- 	- **[*index*]** table ― Parameters of a line of text
	--- 		- **text** string ― Text to be displayed in the line
	--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line [Default: GameTooltipTextSmall]
	--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with [Default: HIGHLIGHT_FONT_COLOR (white)]
	--- 			- **r** number ― Red [Range: 0, 1]
	--- 			- **g** number ― Green [Range: 0, 1]
	--- 			- **b** number ― Blue [Range: 0, 1]
	--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped [Default: true]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **width**? number *optional* ― [Default: 40]
	--- - **onClick** function — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the button
	--- 	- **[*index*]** table ― Event handler parameters
	--- 		- **event** string — Event name
	--- 		- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** [Default: *no evaluation, only for checkboxes*]
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	---@return Button button
	WidgetToolbox[ns.WidgetToolsVersion].CreateButton = function(t)
		local name = "Button"
		if t.name then name = t.name:gsub("%s+", "") end
		local button = CreateFrame("Button", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent, "UIPanelButtonTemplate")
		--Position & dimensions
		if not t.position then button:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = (t.position.offset or {}).y or 0
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(button, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		if t.width then button:SetWidth(t.width) end
		--Title
		local title = t.title or t.name or "Button"
		if t.label ~= false then getglobal(button:GetName() .. "Text"):SetText(title) else getglobal(button:GetName() .. "Text"):Hide() end
		--Event handlers
		button:SetScript("OnClick", t.onClick)
		button:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		if t.onEvent then for i = 0, #t.onEvent do button:HookScript(t.onEvent[i].event, t.onEvent[i].handler) end end
		--Tooltip
		button:HookScript("OnEnter", function() WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, button, "ANCHOR_TOPLEFT", title, t.tooltip, 20) end)
		button:HookScript("OnLeave", function() customTooltip:Hide() end)
		--State & dependencies
		if t.disabled then button:Disable() end
		if t.dependencies then SetDependencies(t.dependencies, function(state) button:SetEnabled(state) end) end
		return button
	end

	--[ Checkbox ]

	---Create a checkbox frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new checkbox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "Checkbox"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **title**? string *optional* — Text to be shown on the right of the checkbox and in the top line of the tooltip [Default: **t.name**]
	--- - **label**? boolean *optional* — Whether or not to display **t.title** as the label next to the checkbox [Default: true]
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the checkbox
	--- 	- **[*index*]** table ― Parameters of a line of text
	--- 		- **text** string ― Text to be displayed in the line
	--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line [Default: GameTooltipTextSmall]
	--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with [Default: HIGHLIGHT_FONT_COLOR (white)]
	--- 			- **r** number ― Red [Range: 0, 1]
	--- 			- **g** number ― Green [Range: 0, 1]
	--- 			- **b** number ― Blue [Range: 0, 1]
	--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped [Default: true]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **autoOffset**? boolean *optional* — Offset the position of the checkbox in a Category Panel to place it into a 3 column grid based on its anchor point. [Default: false]
	--- - **onClick**? function *optional* — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the checkbox
	--- 	- **[*index*]** table ― Event handler parameters
	--- 		- **event** string — Event name
	--- 		- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** [Default: *no evaluation, only for checkboxes*]
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
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
	---@return CheckButton checkbox
	WidgetToolbox[ns.WidgetToolsVersion].CreateCheckbox = function(t)
		local name = "Checkbox"
		if t.name then name = t.name:gsub("%s+", "") end
		local checkbox = CreateFrame("CheckButton", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent, "InterfaceOptionsCheckButtonTemplate")
		--Position & dimensions
		if not t.position then checkbox:SetPoint("TOPLEFT") else
			local w = checkbox:GetWidth() --Frame width
			local cW = (t.parent:GetWidth() - 16 - 20) / 3 --Column width
			local columnOffset = t.autoOffset and (t.position.anchor == "TOP" and cW / -2 + w / 2 or (t.position.anchor == "TOPRIGHT" and -cW - 8 + w or 0) or 8) or 0
			local offsetX = ((t.position.offset or {}).x or 0) + columnOffset
			local offsetY = (t.position.offset or {}).y or 0
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(checkbox, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		--Title
		local title = t.title or t.name or "Checkbox"
		local label = nil
		if t.label ~= false then
			label = getglobal(checkbox:GetName() .. "Text")
			label:SetFontObject("GameFontHighlight")
			label:SetText(title)
		else getglobal(checkbox:GetName() .. "Text"):Hide() end
		--Event handlers
		if t.onClick then checkbox:SetScript("OnClick", t.onClick) else checkbox:SetScript("OnClick", function() --[[ Do nothing ]] end) end
		checkbox:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		if t.onEvent then for i = 0, #t.onEvent do checkbox:HookScript(t.onEvent[i].event, t.onEvent[i].handler) end end
		--Tooltip
		checkbox:HookScript("OnEnter", function() WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, checkbox, "ANCHOR_RIGHT", title, t.tooltip) end)
		checkbox:HookScript("OnLeave", function() customTooltip:Hide() end)
		--State & dependencies
		if t.disabled then
			checkbox:Disable()
			if label then label:SetFontObject("GameFontDisable") end
		end
		if t.dependencies then SetDependencies(t.dependencies, function(state)
			checkbox:SetEnabled(state)
			if label then label:SetFontObject(state and "GameFontHighlight" or "GameFontDisable") end
		end) end
		--Add to options data management
		if t.optionsData then
			local o = t.optionsData
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(
				checkbox, checkbox:GetObjectType(), o.optionsKey, o.storageTable, o.storageKey, o.convertSave, o.convertLoad, o.onSave, o.onLoad
			)
		end
		return checkbox
	end

	--[ Selector & Radio Button ]

	---Create a radio button frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new radio button
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "RadioButton"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **title**? string *optional* — Text to be shown on the right of the radio button and in the top line of the tooltip [Default: **t.name**]
	--- - **label**? boolean *optional* — Whether or not to display **t.title** and add a clickable extension next to the radio button [Default: true]
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the radio button
	--- 	- **[*index*]** table ― Parameters of a line of text
	--- 		- **text** string ― Text to be displayed in the line
	--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line [Default: GameTooltipTextSmall]
	--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with [Default: HIGHLIGHT_FONT_COLOR (white)]
	--- 			- **r** number ― Red [Range: 0, 1]
	--- 			- **g** number ― Green [Range: 0, 1]
	--- 			- **b** number ― Blue [Range: 0, 1]
	--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped [Default: true]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **width**? number *optional* — The combined width of the radio button's dot and the clickable extension to the right of it (where the label is) [Default: 140]
	--- - **onClick**? function *optional* — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the radio button
	--- 	- **[*index*]** table ― Event handler parameters
	--- 		- **event** string — Event name
	--- 		- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** [Default: *no evaluation, only for checkboxes*]
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
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
	---@return CheckButton radioButton
	WidgetToolbox[ns.WidgetToolsVersion].CreateRadioButton = function(t)
		local name = "RadioButton"
		if t.name then name = t.name:gsub("%s+", "") end
		local radioButton = CreateFrame("CheckButton", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent, "UIRadioButtonTemplate")
		--Position
		if not t.position then radioButton:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = (t.position.offset or {}).y or 0
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(radioButton, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		--Title
		local title = t.title or t.name or "RadioButton"
		local label = nil
		if t.label ~= false then
			--Font & text
			label = getglobal(radioButton:GetName() .. "Text")
			label:SetFontObject("GameFontHighlightSmall")
			label:SetText(title)
			--Add extension
			local extension = CreateFrame("Frame", radioButton:GetName() .. "Extension", radioButton)
			--Position & dimensions
			extension:SetSize((t.width or 140) - radioButton:GetWidth(), radioButton:GetHeight())
			extension:SetPoint("TOPLEFT", radioButton, "TOPRIGHT")
			--Linked events
			extension:HookScript("OnEnter", function() if radioButton:IsEnabled() then radioButton:LockHighlight() end end)
			extension:HookScript("OnLeave", function() if radioButton:IsEnabled() then radioButton:UnlockHighlight() end end)
			extension:HookScript("OnMouseDown", function() if radioButton:IsEnabled() then radioButton:Click() end end)
			--Tooltip
			extension:HookScript("OnEnter", function() WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, radioButton, "ANCHOR_RIGHT", title, t.tooltip) end)
			extension:HookScript("OnLeave", function() customTooltip:Hide() end)
		else getglobal(radioButton:GetName() .. "Text"):Hide() end
		--Event handlers
		if t.onClick then radioButton:SetScript("OnClick", t.onClick) end
		radioButton:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		if t.onEvent then for i = 0, #t.onEvent do radioButton:HookScript(t.onEvent[i].event, t.onEvent[i].handler) end end
		--Tooltip
		radioButton:HookScript("OnEnter", function() WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, radioButton, "ANCHOR_RIGHT", title, t.tooltip) end)
		radioButton:HookScript("OnLeave", function() customTooltip:Hide() end)
		--State & dependencies
		if t.disabled then
			radioButton:Disable()
			if label then label:SetFontObject("GameFontDisableSmall") end
		end
		if t.dependencies then SetDependencies(t.dependencies, function(state)
			radioButton:SetEnabled(state)
			if label then label:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall") end
		end) end
		--Add to options data management
		if t.optionsData then
			local o = t.optionsData
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(
				radioButton, radioButton:GetObjectType(), o.optionsKey, o.storageTable, o.storageKey, o.convertSave, o.convertLoad, o.onSave, o.onLoad
			)
		end
		return radioButton
	end

	---Create a selector frame, a collection of radio buttons to pick one out of multiple options
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new selector
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "Selector"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **title**? string *optional* — Text to be shown above the selector frame [Default: **t.name**]
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the selector [Default: true]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **width**? number *optional* ― The height is defaulted to 36, the width may be specified [Default: 140]
	--- - **items** table [indexed, 0-based] — Table containing subtables with data used to create radio button items, or already existing radio button widget frames
	--- 	- **[*index*]** table ― Parameters of a selector item
	--- 		- **title** string — Text to be shown on the right of the radio button to represent the item within the selector frame
	--- 		- **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the radio button
	--- 			- **[*index*]** table ― Parameters of a line of text
	--- 				- **text** string ― Text to be displayed in the line
	--- 				- **font**? string|FontObject *optional* ― The FontObject to set for this line [Default: GameTooltipTextSmall]
	--- 				- **color**? table *optional* ― Table containing the RGB values to color this line with [Default: HIGHLIGHT_FONT_COLOR (white)]
	--- 					- **r** number ― Red [Range: 0, 1]
	--- 					- **g** number ― Green [Range: 0, 1]
	--- 					- **b** number ― Blue [Range: 0, 1]
	--- 				- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped [Default: true]
	--- 		- **onSelect**? function *optional* — The function to be called when the radio button is clicked and the item is selected
	--- 			- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will be evoked whenever an item is selected with:
	--- 				- **name**: "selected"
	--- 				- **value**: *index*
	--- - **labels**? boolean *optional* — Whether or not to add the labels to the right of each newly created radio button [Default: true]
	--- - **columns**? integer *optional* — Arrange the newly created radio buttons in a grid with the specified number of columns instead of a vertical list [Default: 1]
	--- - **selected?** integer *optional* — The item to be set as selected on load [Default: 0]
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** [Default: *no evaluation, only for checkboxes*]
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the selector to the options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* integer ― The index of the currently selected item in the selector
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the selector
	--- 		- @*return* integer ― The index of the item to be set as selected in the selector
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** integer ― The saved value of the frame
	--- 	- **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** integer ― The value loaded to the frame
	---@return Frame selector A base Frame object with custom functions and events added
	--- - **getUniqueType** function Returns the object type of this unique frame
	--- 	- @*return* "Selector" UniqueFrameType
	--- - **isUniqueType** function Checks and returns if the type of this unique frame is equal to the string provided
	--- 	- @*param* **type** string
	--- 	- @*return* boolean
	--- - **getSelected** function Returns the index of the currently selected item
	--- 	- @*return* **index** integer — [Default: 0]
	--- - **setSelected** function Set the specified item as selected (automatically called when an item is manually selected by clicking on a radio button)
	--- 	- @*param* **index** integer
	--- 	- @*param* **user** boolean — Whether to call **t.item.onSelect** [Default: false]
	--- 	- @*return* boolean
	--- - ***Events:***
	--- 	- **OnAttributeChanged** ― Fired after **setSelected** was called or an option was clicked (use **selector**:[HookScript](https://wowwiki-archive.fandom.com/wiki/API_Frame_HookScript)(name, index) to add a listener)
	--- 		- @*return* "selected" string
	--- 		- @*return* **index** integer
	WidgetToolbox[ns.WidgetToolsVersion].CreateSelector = function(t)
		local name = "Selector"
		if t.name then name = t.name:gsub("%s+", "") end
		local selector = CreateFrame("Frame", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent)
		--Position & dimensions
		if not t.position then selector:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = (t.position.offset or {}).y or 0
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(selector, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		local frameWidth = (t.size or {}).width or 140
		selector:SetSize(frameWidth, 36)
		--Title
		local label = WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
			parent = selector,
			title = t.label ~= false and {
				text = t.title or t.name or "Selector",
				offset = { x = 4, },
			} or nil,
		})
		--Add radio buttons
		local items = {}
		for i = 0, #t.items do
			local new = true
			--Check if it's an already existing radio button
			if t.items[i].IsObjectType then if t.items[i]:IsObjectType("CheckButton") then
				items[i] = t.items[i]
				new = false
			end end
			--Create a new radio button
			if new then local sameRow = i % (t.columns or 1) > 0
				items[i] = WidgetToolbox[ns.WidgetToolsVersion].CreateRadioButton({
					parent = selector,
					name = "Item" .. i,
					title = t.items[i].title,
					label = t.labels,
					tooltip = t.items[i].tooltip,
					position = {
						relativeTo = i > 0 and items[sameRow and i - 1 or i - (t.columns or 1)] or label,
						relativePoint = sameRow and "TOPRIGHT" or "BOTTOMLEFT",
						offset = { y = i > 0 and 0 or -4 }
					},
					dependencies = t.dependencies,
				})
			end
		end
		--State & dependencies
		if t.disabled then label:SetFontObject("GameFontDisable") end
		if t.dependencies then SetDependencies(t.dependencies, function(state) label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end) end
		--Add custom functions to the frame
		selector.getUniqueType = function() return "Selector" end
		selector.isUniqueType = function(type) return type == "Selector" end
		selector.getSelected = function() for i = 0, #items do if items[i]:GetChecked() then return i end end return 0 end
		selector.setSelected = function(index, user)
			if index > #items then index = #items elseif index < 0 then index = 0 end
			for i = 0, #items do items[i]:SetChecked(i == index) end
			if t.items[index].onSelect and user then t.items[index].onSelect() end
			--Evoke a custom event
			selector:SetAttribute("selected", index)
		end
		--Establish chain selection updates
		for i = 0, #items do items[i]:HookScript("OnClick", function() selector.setSelected(i, true) end) end
		selector.setSelected(t.selected or 0)
		--Add to options data management
		if t.optionsData then
			local o = t.optionsData
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(
				selector, selector.getUniqueType(), o.optionsKey, o.storageTable, o.storageKey, o.convertSave, o.convertLoad, o.onSave, o.onLoad
			)
		end
		return selector
	end

	--[ EditBox ]

	---Set the parameters of an editbox frame
	---@param editBox EditBox Parent frame of [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) type
	---@param t table Parameters are to be provided in this table
	--- - **label**? FontString *optional* — The title [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) above the editbox [Default: nil *(no title)*]
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **multiline** boolean — Set to true if the editbox should be support multiple lines for the string input
	--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) [Default: 0 (*no limit*)]
	--- - **fontObject**? FontString *optional*— Font template object to use [Default: *default font template based on the frame template*]
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox
	--- 	- **r** number ― Red [Range: 0, 1]
	--- 	- **g** number ― Green [Range: 0, 1]
	--- 	- **b** number ― Blue [Range: 0, 1]
	--- 	- **a** number ― Opacity [Range: 0, 1]
	--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
	--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" [Default: "MIDDLE"]
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true [Default: false]
	--- - **onChar**? function *optional* — The function to be called when a character is entered. Can be used for excluding characters via pattern matching.
	--- - **onEnterPressed**? function *optional* — The function to be called when an [OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed) event happens
	--- - **onEscapePressed**? function *optional* — The function to be called when an [OnEscapePressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEscapePressed) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the editbox
	--- 	- **[*index*]** table ― Event handler parameters
	--- 		- **event** string — Event name
	--- 		- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** [Default: *no evaluation, only for checkboxes*]
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
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
	---@return EditBox editBox
	local function SetEditBox(editBox, t)
		--Font & text
		editBox:SetMultiLine(t.multiline)
		if t.fontObject then editBox:SetFontObject(t.fontObject) end
		if t.justify then
			if t.justify.h then editBox:SetJustifyH(t.justify.h) end
			if t.justify.v then editBox:SetJustifyV(t.justify.v) end
		end
		if t.maxLetters then editBox:SetMaxLetters(t.maxLetters) end
		if t.color and t.text then
			local r, g, b, a = WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(t.color)
			t.text = "|c" .. WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(r, g, b, a, true, false) .. t.text .. "|r"
		end
		--Events & behavior
		editBox:SetAutoFocus(false)
		if t.text then editBox:HookScript("OnShow", function(self) self:SetText(t.text) end) end
		if t.onChar then editBox:SetScript("OnChar", t.onChar) end
		if t.onEnterPressed then
			editBox:SetScript("OnEnterPressed", t.onEnterPressed)
			editBox:HookScript("OnEnterPressed", function(self)
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
				self:ClearFocus()
			end)
		end
		if t.onEscapePressed then editBox:SetScript("OnEscapePressed", t.onEscapePressed) end
		editBox:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
		if t.onEvent then for i = 0, #t.onEvent do editBox:HookScript(t.onEvent[i].event, t.onEvent[i].handler) end end
		--State & dependencies
		if t.readOnly or t.disabled then editBox:Disable() end
		if t.label and t.disabled then t.label:SetFontObject("GameFontDisable") end
		if t.dependencies then SetDependencies(t.dependencies, function(state)
			editBox:SetEnabled(state)
			if t.label then t.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
		end) end
		--Add to options data management
		if t.optionsData then
			local o = t.optionsData
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(
				editBox, editBox:GetObjectType(), o.optionsKey, o.storageTable, o.storageKey, o.convertSave, o.convertLoad, o.onSave, o.onLoad
			)
		end
	end

	---Create an editbox frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the editbox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "EditBox"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **title**? string *optional* — Text to be shown above the editbox and in the top line of the tooltip [Default: **t.name**]
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the editbox [Default: true]
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the editbox
	--- 	- **[*index*]** table ― Parameters of a line of text
	--- 		- **text** string ― Text to be displayed in the line
	--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line [Default: GameTooltipTextSmall]
	--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with [Default: HIGHLIGHT_FONT_COLOR (white)]
	--- 			- **r** number ― Red [Range: 0, 1]
	--- 			- **g** number ― Green [Range: 0, 1]
	--- 			- **b** number ― Blue [Range: 0, 1]
	--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped [Default: true]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **width** number — The height is defaulted to 17, the width may be specified [Default: 180]
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) [Default: 0 (*no limit*])
	--- - **fontObject**? FontString *optional*— Font template object to use [Default: *default font template based on the frame template*]
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox
	--- 	- **r** number ― Red [Range: 0, 1]
	--- 	- **g** number ― Green [Range: 0, 1]
	--- 	- **b** number ― Blue [Range: 0, 1]
	--- 	- **a** number ― Opacity [Range: 0, 1]
	--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
	--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" [Default: "MIDDLE"]
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true [Default: false]
	--- - **onChar**? function *optional* — The function to be called when a character is entered. Can be used for excluding characters via pattern matching.
	--- - **onEnterPressed**? function *optional* — The function to be called when an [OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed) event happens
	--- - **onEscapePressed**? function *optional* — The function to be called when an [OnEscapePressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEscapePressed) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the editbox
	--- 	- **[*index*]** table ― Event handler parameters
	--- 		- **event** string — Event name
	--- 		- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** [Default: *no evaluation, only for checkboxes*]
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
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
	---@return EditBox editBox
	WidgetToolbox[ns.WidgetToolsVersion].CreateEditBox = function(t)
		local name = "EditBox"
		if t.name then name = t.name:gsub("%s+", "") end
		local editBox = CreateFrame("EditBox", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent, "InputBoxTemplate")
		--Position & dimensions
		if not t.position then editBox:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = ((t.position.offset or {}).y or 0) + (t.label ~= false and -18 or 0)
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(editBox, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		editBox:SetSize(t.width or 180, 17)
		--Title
		local title = t.title or t.name or "EditBox"
		local label = WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
			parent = editBox,
			title = t.label ~= false and {
				text = title,
				offset = { x = -1, y = 18 },
			} or nil,
		})
		--Set up the editbox
		SetEditBox(editBox, {
			label = label,
			text = t.text,
			multiline = false,
			maxLetters = t.maxLetters,
			fontObject = t.fontObject,
			color = t.color,
			justify = t.justify,
			readOnly = t.readOnly,
			onChar = t.onChar,
			onEnterPressed = t.onEnterPressed,
			onEscapePressed = t.onEscapePressed,
			onEvent = t.onEvent,
			disabled = t.disabled,
			dependencies = t.dependencies,
			optionsData = t.optionsData,
		})
		--Tooltip
		editBox:HookScript("OnEnter", function() WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, editBox, "ANCHOR_RIGHT", title, t.tooltip) end)
		editBox:HookScript("OnLeave", function() customTooltip:Hide() end)
		return editBox
	end

	---Create a scrollable editbox as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the editbox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "EditBox"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **title**? string *optional* — Text to be shown above the editbox and in the top line of the tooltip [Default: **t.name**]
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the editbox [Default: true]
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the editbox
	--- 	- **[*index*]** table ― Parameters of a line of text
	--- 		- **text** string ― Text to be displayed in the line
	--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line [Default: GameTooltipTextSmall]
	--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with [Default: HIGHLIGHT_FONT_COLOR (white)]
	--- 			- **r** number ― Red [Range: 0, 1]
	--- 			- **g** number ― Green [Range: 0, 1]
	--- 			- **b** number ― Blue [Range: 0, 1]
	--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped [Default: true]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **size** table
	--- 	- **width** number
	--- 	- **height**? number *optional* — [Default: 17]
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **maxLetters**? integer *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) [Default: 0 (*no limit*)]
	--- - **charCount**? boolean — Show or hide the remaining number of characters [Default: (**t.maxLetters** or 0) > 0]
	--- - **fontObject**? FontString *optional*— Font template object to use [Default: *default font template based on the frame template*]
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox
	--- 	- **r** number ― Red [Range: 0, 1]
	--- 	- **g** number ― Green [Range: 0, 1]
	--- 	- **b** number ― Blue [Range: 0, 1]
	--- 	- **a** number ― Opacity [Range: 0, 1]
	--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
	--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" [Default: "MIDDLE"]
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true [Default: false]
	--- - **scrollSpeed**? number *optional* — Scroll step value [Default: *half of the height of the scroll bar*]
	--- - **scrollToTop**? boolean *optional* — Automatically scroll to the top when the text is loaded or changed while not being actively edited [Default: true]
	--- - **onChar**? function *optional* — The function to be called when a character is entered. Can be used for excluding characters via pattern matching.
	--- - **onEnterPressed**? function *optional* — The function to be called when an [OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed) event happens
	--- - **onEscapePressed**? function *optional* — The function to be called when an [OnEscapePressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEscapePressed) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the editbox
	--- 	- **[*index*]** table ― Event handler parameters
	--- 		- **event** string — Event name
	--- 		- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** [Default: *no evaluation, only for checkboxes*]
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
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
	---@return EditBox
	---@return Frame scrollFrame
	WidgetToolbox[ns.WidgetToolsVersion].CreateEditScrollBox = function(t)
		local name = "EditBox"
		if t.name then name = t.name:gsub("%s+", "") end
		local scrollFrame = CreateFrame("ScrollFrame", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent, "InputScrollFrameTemplate")
		--Position & dimensions
		if not t.position then scrollFrame:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = ((t.position.offset or {}).y or 0) - 20
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(scrollFrame, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		scrollFrame:SetSize(t.size.width, t.size.height)
		local function ResizeEditBox()
			local scrollBarOffset = _G[scrollFrame:GetName().."ScrollBar"]:IsShown() and 16 or 0
			local counterOffset = t.charCount ~= false and (t.maxLetters or 0) > 0 and tostring(t.maxLetters - scrollFrame.EditBox:GetText():len()):len() * 6 + 3 or 0
			scrollFrame.EditBox:SetWidth(scrollFrame:GetWidth() - scrollBarOffset - counterOffset)
		end
		ResizeEditBox()
		--Scroll speed
		if t.scrollSpeed then _G[scrollFrame:GetName() .. "ScrollBar"].scrollStep = t.scrollSpeed end
		--Character counter
		scrollFrame.CharCount:SetFontObject("GameFontDisableTiny2")
		if t.charCount == false or (t.maxLetters or 0) == 0 then scrollFrame.CharCount:Hide() end
		--Title
		local title = t.title or t.name or "EditBox"
		local label = WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
			parent = scrollFrame,
			title = t.label ~= false and {
				text = title,
				offset = { x = -1, y = 20 },
			} or nil,
		})
		--Set up the EditBox
		SetEditBox(scrollFrame.EditBox, {
			label = label,
			text = t.text,
			multiline = true,
			maxLetters = t.maxLetters,
			fontObject = t.fontObject or "ChatFontNormal",
			color = t.color,
			justify = t.justify,
			readOnly = t.readOnly,
			onChar = t.onChar,
			onEnterPressed = t.onEnterPressed,
			onEscapePressed = t.onEscapePressed,
			onEvent = t.onEvent,
			disabled = t.disabled,
			dependencies = t.dependencies,
			optionsData = t.optionsData,
		})
		--Events & behavior
		t.scrollToTop = t.scrollToTop ~= false or nil
		scrollFrame.EditBox:HookScript("OnTextChanged", function()
			ResizeEditBox()
			if t.scrollToTop then scrollFrame:SetVerticalScroll(0) end
		end)
		scrollFrame.EditBox:HookScript("OnEditFocusGained", function(self)
			ResizeEditBox()
			if t.scrollToTop ~= nil then t.scrollToTop = false end
			self:HighlightText()
		end)
		scrollFrame.EditBox:HookScript("OnEditFocusLost", function(self)
			if t.scrollToTop ~= nil then t.scrollToTop = true end
			self:ClearHighlightText()
		end)
		--Tooltip
		scrollFrame.EditBox:HookScript("OnEnter", function() WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, scrollFrame, "ANCHOR_RIGHT", title, t.tooltip) end)
		scrollFrame.EditBox:HookScript("OnLeave", function() customTooltip:Hide() end)
		return scrollFrame.EditBox, scrollFrame
	end

	--[ CopyBox]

	---Create a clickable textline and an editbox from which the contents of the text can be copied
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the copybox
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "CopyBox"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **title**? string *optional* — Text to be shown above the copybox [Default: **t.name**]
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the copybox [Default: true]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **width**? number *optional* — The height is defaulted to 17, the width may be specified [Default: 120]
	--- - **text** string ― The copyable text to be shown
	--- - **layer**? Layer *optional* ― Draw [Layer](https://wowpedia.fandom.com/wiki/Layer)
	--- - **template**? string *optional* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) [Default: "GameFontNormal"]
	--- - **color**? table *optional* — Apply the specified color to the text
	--- 	- **r** number ― Red [Range: 0, 1]
	--- 	- **g** number ― Green [Range: 0, 1]
	--- 	- **b** number ― Blue [Range: 0, 1]
	--- 	- **a** number ― Opacity [Range: 0, 1]
	--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
	--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" [Default: "MIDDLE"]
	--- - **flipOnMouse**? boolean *optional* — Hide/Reveal the editbox on mouseover instead of after a click [Default: false]
	--- - **colorOnMouse**? table *optional* — If set, change the color of the text on mouseover to the specified color (if **t.flipOnMouse** is false) [Default: *no color change*]
	--- 	- **r** number ― Red [Range: 0, 1]
	--- 	- **g** number ― Green [Range: 0, 1]
	--- 	- **b** number ― Blue [Range: 0, 1]
	--- 	- **a** number ― Opacity [Range: 0, 1]
	---@return FontString textLine
	---@return EditBox copyBox
	WidgetToolbox[ns.WidgetToolsVersion].CreateCopyBox = function(t)
		local name = "CopyBox"
		if t.name then name = t.name:gsub("%s+", "") end
		local copyBox = CreateFrame("Button", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent)
		--Position & dimensions
		if not t.position then copyBox:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = ((t.position.offset or {}).y or 0) + (t.label ~= false and -12 or 0)
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(copyBox, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		copyBox:SetSize(t.width or 180, 17)
		--Title
		WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
			parent = copyBox,
			title = t.label ~= false and {
				text = t.title or t.name or "CopyBox",
				offset = { x = -1, y = 12 },
				width = t.width or 180,
			} or nil,
		})
		--Displayed textline
		local textLine = WidgetToolbox[ns.WidgetToolsVersion].CreateText({
			parent = copyBox,
			name = "DisplayText",
			position = { anchor = "LEFT", },
			width = t.width or 180,
			text = t.text,
			layer = t.layer,
			template = t.template,
			color = t.color,
			justify = (t.justify or {}).h or "LEFT",
			wrap = false
		})
		--Copyable textline
		local text = t.text
		if t.color then
			local r, g, b, a = WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(t.color)
			text = "|c" .. WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(r, g, b, a, true, false) .. t.text .. "|r"
		end
		local editBox = WidgetToolbox[ns.WidgetToolsVersion].CreateEditBox({
			parent = copyBox,
			name = "CopyText",
			title = strings.copy.editbox.label,
			label = false,
			tooltip = { [0] = { text = strings.copy.editbox.tooltip }, },
			position = { anchor = "LEFT", },
			width = t.width,
			text = t.text,
			fontObject = textLine:GetFontObject(),
			color = t.color,
			justify = t.justify,
			onEvent = {
				[0] = {
					event = "OnTextChanged",
					handler = function(self)
						self:SetText(text)
						self:HighlightText()
					end
				},
				[1] = {
					event = t.flipOnMouse and "OnLeave" or "OnEditFocusLost",
					handler = function(self)
						self:Hide()
						textLine:Show()
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
					end
				}
			},
		})
		editBox:Hide()
		--Events & behavior
		copyBox:SetScript(t.flipOnMouse and "OnEnter" or "OnClick", function()
			textLine:Hide()
			editBox:Show()
			editBox:SetFocus()
			editBox:HighlightText()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end)
		if not t.flipOnMouse and t.colorOnMouse then
			copyBox:SetScript("OnEnter", function() textLine:SetTextColor(WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(t.colorOnMouse)) end)
			copyBox:SetScript("OnLeave", function() textLine:SetTextColor(WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(t.color)) end)
		end
		--Tooltip
		copyBox:HookScript("OnEnter", function()
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, copyBox, "ANCHOR_RIGHT", strings.copy.textline.label, { [0] = { text = strings.copy.textline.tooltip }, })
		end)
		copyBox:HookScript("OnLeave", function() customTooltip:Hide() end)
		return copyBox, textLine, editBox
	end

	--[ Value Slider ]

	---Add a value box as a child to an existing slider frame
	---@param slider Slider Parent frame of [Slider](https://wowpedia.fandom.com/wiki/UIOBJECT_Slider) type
	---@param value table Parameters are to be provided in this table
	--- - **min** number — Lower numeric value limit of the slider
	--- - **max** number — Upper numeric value limit of the slider
	--- - **step**? number *optional* — Size of value increments [Default: *the value can be freely changed (within range, no set increments)*]
	--- - **fractional**? integer *optional* — If the value is fractional, allow and display this many decimal digits [Default: *the most amount of digits present in the fractional part of* **value.min**, **value.max** *or* **value.step**]
	---@return EditBox valueBox
	local function AddSliderValueBox(slider, value)
		local valueBox = CreateFrame("EditBox", slider:GetName() .. "ValueBox", slider, BackdropTemplateMixin and "BackdropTemplate")
		--Calculate the required number of fractal digits, assemble string patterns for value validation
		local decimals = value.fractional or max(
			tostring(value.min):gsub("-?[%d]+[%.]?([%d]*).*", "%1"):len(),
			tostring(value.max):gsub("-?[%d]+[%.]?([%d]*).*", "%1"):len(),
			tostring(value.step or 0):gsub("-?[%d]+[%.]?([%d]*).*", "%1"):len()
		)
		local decimalPattern = ""
		for i = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end
		local matchPattern = "(" .. (value.min < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
		local replacePattern = "%1" .. (decimals > 0 and "%2" or "")
		--Position & dimensions
		valueBox:SetPoint("TOP", slider, "BOTTOM")
		valueBox:SetSize(64, 17)
		--Backdrop
		valueBox:SetBackdrop({
			bgFile = "Interface/ChatFrame/ChatFrameBackground",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true, tileSize = 5, edgeSize = 12,
			insets = { left = 2.5, right = 2.5, top = 2, bottom = 2.5 }
		})
		valueBox:SetBackdropColor(0, 0, 0, 0.5)
		valueBox:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.9)
		--Font & text
		valueBox:SetFontObject("GameFontHighlightSmall")
		valueBox:SetJustifyH("CENTER")
		valueBox:SetMaxLetters(tostring(math.floor(value.max)):len() + (decimals + (decimals > 0 and 1 or 0)) + (value.min < 0 and 1 or 0))
		--Events & behavior
		valueBox:SetAutoFocus(false)
		valueBox:SetScript("OnShow", function(self) self:SetText(tostring(slider:GetValue()):gsub(matchPattern, replacePattern)) end)
		valueBox:SetScript("OnEnter", function(self) if self:IsEnabled() then self:SetBackdropBorderColor(0.8, 0.8, 0.8, 0.9) end end)
		valueBox:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.9) end)
		valueBox:SetScript("OnEnterPressed", function(self)
			local v = self:GetNumber()
			if value.step then v = max(value.min, min(value.max, floor(v * (1 / value.step) + 0.5) / (1 / value.step))) end
			self:SetText(tostring(v):gsub(matchPattern, replacePattern))
			slider:SetAttribute("valueboxchange", v)
		end)
		valueBox:HookScript("OnEnterPressed", function(self)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			self:ClearFocus()
		end)
		valueBox:SetScript("OnEscapePressed", function(self) self:SetText(tostring(slider:GetValue()):gsub(matchPattern, replacePattern)) end)
		valueBox:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
		valueBox:SetScript("OnChar", function(self) self:SetText(self:GetText():gsub(matchPattern, replacePattern)) end)
		slider:HookScript("OnValueChanged", function(_, v) valueBox:SetText(tostring(v):gsub(matchPattern, replacePattern)) end)
		--Tooltip
		valueBox:HookScript("OnEnter", function()
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, valueBox, "ANCHOR_RIGHT", strings.value.label, { [0] = { text = strings.value.tooltip }, })
		end)
		valueBox:HookScript("OnLeave", function() customTooltip:Hide() end)
		return valueBox
	end

	---Create a new slider frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new slider
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "Slider"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **title**? string *optional* — Text to be shown above the slider and in the top line of the tooltip [Default: **t.name**]
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the slider [Default: true]
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the slider
	--- 	- **[*index*]** table ― Parameters of a line of text
	--- 		- **text** string ― Text to be displayed in the line
	--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line [Default: GameTooltipTextSmall]
	--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with [Default: HIGHLIGHT_FONT_COLOR (white)]
	--- 			- **r** number ― Red [Range: 0, 1]
	--- 			- **g** number ― Green [Range: 0, 1]
	--- 			- **b** number ― Blue [Range: 0, 1]
	--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped [Default: true]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **width**? number *optional*
	--- - **value** table
	--- 	- **min** number — Lower numeric value limit
	--- 	- **max** number — Upper numeric value limit
	--- 	- **step**? number *optional* — Size of value increments [Default: *the value can be freely changed (within range, no set increments)*]
	--- 	- **fractional**? integer *optional* — If the value is fractional, allow and display this many decimal digits [Default: *the most amount of digits present in the fractional part of* **t.value.min**, **t.value.max** *or* **t.value.step**]
	--- - **valueBox**? boolean *optional* — Whether or not should the slider have an [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) as a child to manually enter a precise value to move the slider to [Default: true]
	--- - **onValueChanged** function — The function to be called when an [OnValueChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnValueChanged) event happens
	--- 	- @*param* **self** Frame ― Reference to the widget
	--- 	- @*param* **value** number ― The new value of the slider
	--- 	- @*param* **user** boolean ― True if the value was changed by the user, false if it was done programmatically
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the slider
	--- 	- **[*index*]** table ― Event handler parameters
	--- 		- **event** string — Event name
	--- 		- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** [Default: *no evaluation, only for checkboxes*]
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
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
	---@return Slider slider
	---@return EditBox? valueBox
	WidgetToolbox[ns.WidgetToolsVersion].CreateSlider = function(t)
		local name = "Slider"
		if t.name then name = t.name:gsub("%s+", "") end
		local slider = CreateFrame("Slider", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent, "OptionsSliderTemplate")
		--Position
		if not t.position then slider:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = ((t.position.offset or {}).y or 0) - 12
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(slider, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		if t.width then slider:SetWidth(t.width) end
		--Title
		local title = t.title or t.name or "Slider"
		local label = nil
		if t.label ~= false then
			label = getglobal(slider:GetName() .. "Text")
			label:SetFontObject("GameFontNormal")
			label:SetText(title)
		else getglobal(slider:GetName() .. "Text"):Hide() end
		--Value
		getglobal(slider:GetName() .. "Low"):SetText(tostring(t.value.min))
		getglobal(slider:GetName() .. "High"):SetText(tostring(t.value.max))
		slider:SetMinMaxValues(t.value.min, t.value.max)
		if t.value.step then
			slider:SetValueStep(t.value.step)
			slider:SetObeyStepOnDrag(true)
		end
		--Event handlers
		slider:SetScript("OnValueChanged", function(self, value, user)
			if not user then return end
			t.onValueChanged(self, value, user)
		end)
		slider:SetScript("OnAttributeChanged", function(self, name, value)
			if name == "valueboxchange" then
				self:SetValue(value)
				t.onValueChanged(self, value, true)
			end
		end)
		slider:HookScript("OnMouseUp", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		if t.onEvent then for i = 0, #t.onEvent do slider:HookScript(t.onEvent[i].event, t.onEvent[i].handler) end end
		--Tooltip
		slider:HookScript("OnEnter", function() WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, slider, "ANCHOR_RIGHT", title, t.tooltip) end)
		slider:HookScript("OnLeave", function() customTooltip:Hide() end)
		--Value box
		if t.valueBox == false then return slider end
		local valueBox = AddSliderValueBox(slider, t.value)
		--State & dependencies
		if t.disabled then
			slider:Disable()
			valueBox:Disable()
			if label then label:SetFontObject("GameFontDisable") end
			valueBox:SetFontObject("GameFontDisableSmall")
		end
		if t.dependencies then SetDependencies(t.dependencies, function(state)
			slider:SetEnabled(state)
			valueBox:SetEnabled(state)
			if label then label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
			valueBox:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall")
		end) end
		--Add to options data management
		if t.optionsData then
			local o = t.optionsData
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(
				slider, slider:GetObjectType(), o.optionsKey, o.storageTable, o.storageKey, o.convertSave, o.convertLoad, o.onSave, o.onLoad
			)
		end
		return slider, valueBox
	end

	--[ Dropdown Menu ]

	---Create a dropdown frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new dropdown
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "Dropdown"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **title**? string *optional* — Text to be shown above the dropdown and in the top line of the tooltip [Default: **t.name**]
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the dropdown [Default: true]
	--- - **tooltip**? table [indexed, 0-based] *optional* — List of text lines to be added to the tooltip of the dropdown
	--- 	- **[*index*]** table ― Parameters of a line of text
	--- 		- **text** string ― Text to be displayed in the line
	--- 		- **font**? string|FontObject *optional* ― The FontObject to set for this line [Default: GameTooltipTextSmall]
	--- 		- **color**? table *optional* ― Table containing the RGB values to color this line with [Default: HIGHLIGHT_FONT_COLOR (white)]
	--- 			- **r** number ― Red [Range: 0, 1]
	--- 			- **g** number ― Green [Range: 0, 1]
	--- 			- **b** number ― Blue [Range: 0, 1]
	--- 		- **wrap**? boolean *optional* ― Allow the text in this line to be wrapped [Default: true]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **width**? number *optional* — [Default: 115]
	--- - **items** table [indexed, 0-based] — Table containing the dropdown items described within subtables
	--- 	- **[*index*]** table ― Parameters of a dropdown item
	--- 		- **title** string — Text to represent the item within the dropdown frame
	--- 		- **onSelect** function — The function to be called when the dropdown item is selected
	--- 			- ***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will be evoked whenever an item is selected with:
	--- 				- **name**: "selected"
	--- 				- **value**: *index*
	--- - **selected?** integer *optional* — The default selected item of the dropdown menu
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** [Default: *no evaluation, only for checkboxes*]
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
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
	---@return Frame dropdown A base UIDropDownMenu Frame with custom functions and events added
	--- - **getUniqueType** function ― Returns the functional unique type of this Frame
	--- 	- @*return* "Dropdown" UniqueFrameType
	--- - **isUniqueType** function ― Checks and returns if the functional unique type of this Frame matches the string provided entirely
	--- 	- @*param* **type** UniqueFrameType|string
	--- 	- @*return* boolean
	--- - ***Events:***
	--- 	- **OnAttributeChanged** ― Fired after a dropdown button was clicked (use **dropdown**:[HookScript](https://wowwiki-archive.fandom.com/wiki/API_Frame_HookScript)(name, index) to add a listener)
	--- 		- @*return* "selected" string
	--- 		- @*return* **index** integer
	WidgetToolbox[ns.WidgetToolsVersion].CreateDropdown = function(t)
		local name = "Dropdown"
		if t.name then name = t.name:gsub("%s+", "") end
		local dropdown = CreateFrame("Frame", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent, "UIDropDownMenuTemplate")
		--Position & dimensions
		if not t.position then dropdown:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = ((t.position.offset or {}).y or 0) + (t.title ~= false and -16 or 0)
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(dropdown, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		UIDropDownMenu_SetWidth(dropdown, t.width or 115)
		--Title
		local title = t.title or t.name or "Dropdown"
		local label = WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
			parent = dropdown,
			title = t.label ~= false and {
				text = title,
				offset = { x = 22, y = 16 },
			} or nil,
		})
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
		if t.selected then
			UIDropDownMenu_SetSelectedValue(dropdown, t.selected)
			UIDropDownMenu_SetText(dropdown, t.items[t.selected].title)
		end
		--Tooltip
		dropdown:HookScript("OnEnter", function() WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, dropdown, "ANCHOR_RIGHT", title, t.tooltip) end)
		dropdown:HookScript("OnLeave", function() customTooltip:Hide() end)
		--State & dependencies
		if t.disabled then
			UIDropDownMenu_DisableDropDown(dropdown)
			if label then label:SetFontObject("GameFontDisable") end
		end
		if t.dependencies then SetDependencies(t.dependencies, function(state)
			if state then UIDropDownMenu_EnableDropDown(dropdown) else UIDropDownMenu_DisableDropDown(dropdown) end
			if label then label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
		end) end
		--Add to options data management
		if t.optionsData then
			local o = t.optionsData
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(
				dropdown, "Dropdown", o.optionsKey, o.storageTable, o.storageKey, o.convertSave, o.convertLoad, o.onSave, function(self, value)
					if value then UIDropDownMenu_SetText(dropdown, t.items[value].title) end
					if o.onLoad then o.onLoad(self, value) end
				end
			)
		end
		--Add custom functions to the frame
		dropdown.getUniqueType = function() return "Dropdown" end
		dropdown.isUniqueType = function(type) return type == "Dropdown" end
		return dropdown
	end

	--[ Context Menu ]

	---Create a context menu frame as a child of a frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new context menu
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "ContextMenu"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **anchor** string|Region — The current cursor position or a region or frame reference [Default: 'cursor']
	--- - **offset**? table *optional*
	--- 	- **x**? number [Default: 0]
	--- 	- **y**? number [Default: 0]
	--- - **width**? number *optional* — [Default: 115]
	--- - **menu** table — Table of nested subtables for the context menu items containing their attributes
	--- 	- **[*value*]** table — List of attributes representing a menu item (*Select examples below!* See the [full list of attributes](https://www.townlong-yak.com/framexml/5.4.7/UIDropDownMenu.lua#139) that can be set for menu items.)
	--- 		- **text** string — Text to be displayed on the button within the context menu
	--- 		- **isTitle**? boolean *optional* — Set the item as a title instead of a clickable button [Default: false (*not title*)]
	--- 		- **disabled**? number *optional* — Disable the button if set to 1 [Range: nil, 1; Default: nil or 1 if **t.isTitle** == true]
	--- 		- **checked**? boolean *optional* — Whether the button is currently checked or not [Default: false (*not checked*)]
	--- 		- **notCheckable**? number *optional* — Make the item a simple button instead of a checkbox if set to 1 [Range: nil, 1; Default: nil]
	--- 		- **func** function — The function to be called the button is clicked
	--- 		- **hasArrow** boolean — Show the arrow to open the submenu specified in t.menuList
	--- 		- **menuList** table — A table of subtables containing submenu items
	---@return Frame contextMenu
	WidgetToolbox[ns.WidgetToolsVersion].CreateContextMenu = function(t)
		local name = "ContextMenu"
		if t.name then name = t.name:gsub("%s+", "") end
		local contextMenu = CreateFrame("Frame", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent, "UIDropDownMenuTemplate")
		--Dimensions
		UIDropDownMenu_SetWidth(contextMenu, t.width or 115)
		--Right-click event
		t.parent:HookScript("OnMouseUp", function(self, button, isInside)
			if button == "RightButton" and isInside then EasyMenu(t.menu, contextMenu, t.anchor or "cursor", (t.offset or {}).x or 0, (t.offset or {}).y or 0, "MENU") end
		end)
		return contextMenu
	end

	--[ Color Picker ]

	--Addon-scope data must be used to stop the separate color pickers from interfering with each other through the global Blizzard Color Picker frame
	local colorPickerData = {}

	---Set up and open the built-in Color Picker frame
	---
	---Using **colorPickerData** table, it must be set before call:
	--- - **activeColorPicker** Button
	--- - **startColors** table ― Color values are to be provided in this table
	--- 	- **r** number ― Red [Range: 0, 1]
	--- 	- **g** number ― Green [Range: 0, 1]
	--- 	- **b** number ― Blue [Range: 0, 1]
	--- 	- **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	--- - **onColorUpdate** function
	--- 	- @*param* **r** number ― Red [Range: 0, 1]
	--- 	- @*param* **g** number ― Green [Range: 0, 1]
	--- 	- @*param* **b** number ― Blue [Range: 0, 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	--- - **onCancel** function
	--- 	- @*param* **r** number ― Red [Range: 0, 1]
	--- 	- @*param* **g** number ― Green [Range: 0, 1]
	--- 	- @*param* **b** number ― Blue [Range: 0, 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	local function OpenColorPicker()
		--Color picker button background update function
		local function ColorUpdate()
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = OpacitySliderFrame:GetValue() or 1
			colorPickerData.activeColorPicker:SetBackdropColor(r, g, b, a)
			colorPickerData.backgroundGradient:SetVertexColor(r, g, b, 1)
			_G[colorPickerData.activeColorPicker:GetName():gsub("PickerButton", "HEXBox")]:SetText(WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(r, g, b, a))
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
			_G[colorPickerData.activeColorPicker:GetName():gsub("PickerButton", "HEXBox")]:SetText(WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(
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
	---@param colorPicker Frame — The frame to set as the parent of the new color picker button
	---@param t table Parameters are to be provided in this table
	--- - **setColors** function — The function to be called to set the colors of the color picker on load or update
	--- 	- @*return* **r** number ― Red [Range: 0, 1]
	--- 	- @*return* **g** number ― Green [Range: 0, 1]
	--- 	- @*return* **b** number ― Blue [Range: 0, 1]
	--- 	- @*return* **a**? number *optional* ― Opacity [Range: 0, 1]
	--- - **onColorUpdate** function — The function to be called when the color is changed
	--- 	- @*param* **r** number ― Red [Range: 0, 1]
	--- 	- @*param* **g** number ― Green [Range: 0, 1]
	--- 	- @*param* **b** number ― Blue [Range: 0, 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	--- - **onCancel** function — The function to be called when the color change is cancelled
	--- 	- @*param* **r** number ― Red [Range: 0, 1]
	--- 	- @*param* **g** number ― Green [Range: 0, 1]
	--- 	- @*param* **b** number ― Blue [Range: 0, 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	---@return Button pickerButton The color picker button frame
	---@return Texture backgroundGradient The gradient color background texture
	local function AddColorPickerButton(colorPicker, t)
		local pickerButton = CreateFrame("Button", colorPicker:GetName() .. "PickerButton", colorPicker, BackdropTemplateMixin and "BackdropTemplate")
		--Position & dimensions
		pickerButton:SetPoint("TOPLEFT", 0, -16)
		pickerButton:SetSize(34, 22)
		--Backdrop
		local r, g, b, a = t.setColors()
		pickerButton:SetBackdrop({
			bgFile = "Interface/ChatFrame/ChatFrameBackground",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true, tileSize = 5, edgeSize = 11,
			insets = { left = 2.5, right = 2.5, top = 2.5, bottom = 2.5 }
		})
		pickerButton:SetBackdropColor(r, g, b, a or 1)
		pickerButton:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.9)
		--Background
		local background = CreateFrame("Frame", pickerButton:GetName() .. "AlphaBG", pickerButton, BackdropTemplateMixin and "BackdropTemplate")
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(background, "TOPLEFT")
		background:SetSize(pickerButton:GetWidth(), pickerButton:GetHeight())
		background:SetBackdrop({
			bgFile = textures.alphaBG,
			tile = true, tileSize = 8,
			insets = { left = 2.5, right = 2.5, top = 2.5, bottom = 2.5 }
		})
		background:SetFrameLevel(pickerButton:GetFrameLevel() - 1)
		local backgroundGradient = WidgetToolbox[ns.WidgetToolsVersion].CreateTexture({
			parent = background,
			name = "ColorGradient",
			position = { offset = { x = 2.5, y = -2.5 } },
			size = { width = 14, height = 17 },
			path = textures.gradientBG,
		})
		backgroundGradient:SetVertexColor(r, g, b, 1)
		--Events & behavior
		pickerButton:SetScript("OnEnter", function(self) self:SetBackdropBorderColor(0.8, 0.8, 0.8, 0.9) end)
		pickerButton:SetScript("OnLeave", function(self) self:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.9) end)
		pickerButton:SetScript("OnClick", function()
			local red, green, blue, alpha = pickerButton:GetBackdropColor()
			colorPickerData = {
				activeColorPicker = pickerButton,
				backgroundGradient = backgroundGradient,
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
			if a then tooltip = strings.color.picker.tooltip:gsub("#ALPHA", strings.color.picker.alpha)
			else tooltip = strings.color.picker.tooltip:gsub("#ALPHA", "") end
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, pickerButton, "ANCHOR_TOPLEFT", strings.color.picker.label, { [0] = { text = tooltip }, }, 20)
		end)
		pickerButton:HookScript("OnLeave", function() customTooltip:Hide() end)
		return pickerButton, backgroundGradient
	end

	---Set up the built-in Color Picker and create a button as a child of a container frame to open it
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new color picker button
	--- - **name**? string *optional* — Unique string used to set the name of the new frame [Default: "ColorPicker"]
	--- - **append**? boolean *optional* — When setting the name, append **t.name** to the name of **t.parent** [Default: true]
	--- - **title**? string *optional* — Text to be shown above the color picker frame [Default: **t.name**]
	--- - **label**? boolean *optional* — Whether or not to display **t.title** above the color picker frame [Default: true]
	--- - **position**? table *optional* — Parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with [Default: "TOPLEFT"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x**? number *optional* ― [Default: 0]
	--- 		- **y**? number *optional* ― [Default: 0]
	--- - **width**? number *optional* ― The height is defaulted to 36, the width may be specified [Default: 120]
	--- - **setColors** function — The function to be called to set the colors of the color picker on load or update
	--- 	- @*return* **r** number ― Red [Range: 0, 1]
	--- 	- @*return* **g** number ― Green [Range: 0, 1]
	--- 	- @*return* **b** number ― Blue [Range: 0, 1]
	--- 	- @*return* **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	--- - **onColorUpdate** function — The function to be called when the color is changed
	--- 	- @*param* **r** number ― Red [Range: 0, 1]
	--- 	- @*param* **g** number ― Green [Range: 0, 1]
	--- 	- @*param* **b** number ― Blue [Range: 0, 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	--- - **onCancel** function — The function to be called when the color change is cancelled
	--- 	- @*param* **r** number ― Red [Range: 0, 1]
	--- 	- @*param* **g** number ― Green [Range: 0, 1]
	--- 	- @*param* **b** number ― Blue [Range: 0, 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **[*index*]** table ― Parameters of a dependency rule
	--- 		- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 		- **evaluate**? function *optional* — Call this function to evaluate the current value of **t.dependencies[*index*].frame** [Default: *no evaluation, only for checkboxes*]
	--- 			- @*param* **value**? any *optional* — The current value of **t.dependencies[*index*].frame**, the type of which depends on the type of the frame (see overloads)
	--- 			- @*return* **evaluation** boolean — If false, disable the dependent widget (or enable it when true)
	--- 			- ***Overloads:***
	--- 				- function(**value**: boolean) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a checkbox
	--- 				- function(**value**: number) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a slider
	--- 				- function(**value**: integer) -> **evaluation**: boolean — If **t.dependencies[*index*].frame** is recognized as a dropdown or selector
	--- 				- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 			- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **t.dependencies[*index*].frame** is not "CheckButton".
	--- - **optionsData**? table ― If set, add the color picker to the options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **optionsKey** table ― A unique key referencing a collection of widget options data to be saved & loaded together
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **storageKey** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* **r** number ― Red [Range: 0, 1]
	--- 		- @*param* **g** number ― Green [Range: 0, 1]
	--- 		- @*param* **b** number ― Blue [Range: 0, 1]
	--- 		- @*param* **a**? number ― Opacity [Range: 0, 1]
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any *(any number of arguments)* ― The data in the storage table to be converted
	--- 		- @*return* **r** number ― Red [Range: 0, 1]
	--- 		- @*return* **g** number ― Green [Range: 0, 1]
	--- 		- @*return* **b** number ― Blue [Range: 0, 1]
	--- 		- @*return* **a**? number ― Opacity [Range: 0, 1]
	--- 	- **onSave**? function *optional* — This function will be called with the parameters listed below when the options are saved (the Okay button is pressed) after the data has been saved from the options widget to the storage table
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** table ― The saved value of the frame
	--- 			- **r** number ― Red [Range: 0, 1]
	--- 			- **g** number ― Green [Range: 0, 1]
	--- 			- **b** number ― Blue [Range: 0, 1]
	--- 			- **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	--- 	- **onLoad**? function *optional* — This function will be called with the parameters listed below when the options category page is refreshed after the data has been loaded from the storage table to the widget
	--- 		- @*param* **self** Frame ― Reference to the widget
	--- 		- @*param* **value** table ― The value loaded to the frame
	--- 			- **r** number ― Red [Range: 0, 1]
	--- 			- **g** number ― Green [Range: 0, 1]
	--- 			- **b** number ― Blue [Range: 0, 1]
	--- 			- **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	---@return Frame colorPicker A base Frame object with custom functions added
	--- - **getUniqueType** function ― Returns the object type of this unique frame
	--- 	- @*return* "ColorPicker" UniqueFrameType
	--- - **isUniqueType** function ― Checks and returns if the type of this unique frame matches the string provided entirely
	--- 	- @*param* **type** UniqueFrameType|string
	--- 	- @*return* boolean
	--- - **getColor** function ― Returns the currently set color values
	--- 	- @*return* **r** number ― Red [Range: 0, 1]
	--- 	- @*return* **g** number ― Green [Range: 0, 1]
	--- 	- @*return* **b** number ― Blue [Range: 0, 1]
	--- 	- @*return* **a**? number ― Opacity [Range: 0, 1]
	--- - **setColor** function ― Sets the color and text of each element
	--- 	- @*param* **r** number ― Red [Range: 0, 1]
	--- 	- @*param* **g** number ― Green [Range: 0, 1]
	--- 	- @*param* **b** number ― Blue [Range: 0, 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0, 1; Default: 1]
	WidgetToolbox[ns.WidgetToolsVersion].CreateColorPicker = function(t)
		local name = "ColorPicker"
		if t.name then name = t.name:gsub("%s+", "") end
		local colorPicker = CreateFrame("Frame", (t.append ~= false and t.parent:GetName() or "") .. name, t.parent)
		--Position & dimensions
		if not t.position then colorPicker:SetPoint("TOPLEFT") else
			local offsetX = (t.position.offset or {}).x or 0
			local offsetY = (t.position.offset or {}).y or 0
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(colorPicker, t.position.anchor or "TOPLEFT", t.position.relativeTo, t.position.relativePoint, offsetX, offsetY)
		end
		local frameWidth = (t.size or {}).width or 120
		colorPicker:SetSize(frameWidth, 36)
		--Title
		local label = WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
			parent = colorPicker,
			title = t.label ~= false and {
				text = t.title or t.name or "ColorPicker",
				offset = { x = 4, },
			} or nil,
		})
		--Add color picker button to open the Blizzard Color Picker
		local pickerButton, backgroundGradient = AddColorPickerButton(colorPicker, {
			setColors = t.setColors,
			onColorUpdate = t.onColorUpdate,
			onCancel = t.onCancel
		})
		--Add editbox to change the color via HEX code
		local _, _, _, alpha = t.setColors()
		local hexBox = WidgetToolbox[ns.WidgetToolsVersion].CreateEditBox({
			parent = colorPicker,
			name = "HEXBox",
			title = strings.color.hex.label,
			label = false,
			tooltip = { [0] = { text = strings.color.hex.tooltip .. "\n\n" .. strings.misc.example .. ": #2266BB" .. (alpha and "AA" or "") }, },
			position = { offset = { x = 44, y = -18 } },
			width = frameWidth - 44,
			maxLetters = 7 + (alpha and 2 or 0),
			fontObject = "GameFontWhiteSmall",
			onChar = function(self) self:SetText(self:GetText():gsub("^(#?)([%x]*).*", "%1%2")) end,
			onEnterPressed = function(self)
				local r, g, b, a = WidgetToolbox[ns.WidgetToolsVersion].HexToColor(self:GetText())
				pickerButton:SetBackdropColor(r, g, b, a or 1)
				backgroundGradient:SetVertexColor(r, g, b, 1)
				t.onColorUpdate(r, g, b, a or 1)
				self:SetText(self:GetText():upper())
			end,
			onEscapePressed = function(self) self:SetText(WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(pickerButton:GetBackdropColor())) end,
		})
		--State & dependencies
		if t.disabled then
			if label then label:SetFontObject("GameFontDisable") end
			pickerButton:Disable()
			hexBox:Disable()
			hexBox:SetFontObject("GameFontDisableSmall")
		end
		if t.dependencies then SetDependencies(t.dependencies, function(state)
			if label then label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
			pickerButton:SetEnabled(state)
			hexBox:SetEnabled(state)
			hexBox:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall")
		end) end
		--Add custom functions to the frame
		colorPicker.getUniqueType = function() return "ColorPicker" end
		colorPicker.isUniqueType = function(type) return type == "ColorPicker" end
		colorPicker.getColor = function() return pickerButton:GetBackdropColor() end
		colorPicker.setColor = function(r, g, b, a)
			pickerButton:SetBackdropColor(r, g, b, a or 1)
			backgroundGradient:SetVertexColor(r, g, b, 1)
			hexBox:SetText(WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(r, g, b, a))
		end
		--Add to options data management
		if t.optionsData then
			local o = t.optionsData
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(
				colorPicker, colorPicker.getUniqueType(), o.optionsKey, o.storageTable, o.storageKey, o.convertSave, o.convertLoad, o.onSave, o.onLoad
			)
		end
		return colorPicker
	end
end