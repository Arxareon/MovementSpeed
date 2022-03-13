--Addon identifier name, namespace table
local addonNameSpace, ns = ...

--Version
ns.WidgetToolsVersion = "1.2"

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
	---|'"Selector"'
	---|'"Dropdown"'
	---|'"ColorPicker"'


	--[[ UTILITIES ]]

	--[ Table Management ]

	---Get the sorted key value pairs of a table ([Documentation: Sort](https://www.lua.org/pil/19.3.html))
	---@param t table Table to be sorted (in an ascending order and/or alphabetically)
	---@param f? function Iterator function defining how elements should be compared (used for [table.sort](https://www.lua.org/manual/5.4/manual.html#pdf-table.sort)) [Default: < *operator (fixed for mixed tables)*]
	---@return function iterator Function returning the Key, Value pairs of the table in order
	WidgetToolbox[ns.WidgetToolsVersion].SortedPairs = function(t, f)
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

	---Dump an object and its contents to the in-game chat
	---@param object any Object to dump out
	---@param name? string A name to print out [Default: *the dumped object will not be named*]
	---@param depth? number How many levels of subtables to print out (root level: 0)
	---@param blockrule? function Function to manually filter which keys get printed and explored further
	--- - @*param* **key** number | string ― The currently dumped key
	--- - @*return* boolean ― Skip the key if the returned value is true
	--- - ***Example:** comparison* ― Skip the key based the result of a comparison between it (if it's an index) and a specified number value
	--- 	- --[[____]] function(key)
	--- 	- --[[________]] if type(key) == "number" then --check if the key is an index to avoid issues with mixed tables
	--- 	- --[[____________]] return key < 10
	--- 	- --[[________]] end
	--- 	- --[[________]] return true --or false whether to allow string keys in mixed tables
	--- 	- --[[____]] end
	--- - ***Example:** blocklist* ― Iterate through an array (indexed table) containing keys, the values of which are to be skipped
	--- 	- --[[____]] function(key)
	--- 	- --[[________]] local blocklist = {
	--- 	- --[[____________]] [0] = "skip_key",
	--- 	- --[[____________]] [1] = 1,
	--- 	- --[[________]] }
	--- 	- --[[________]] for i = 0, #blocklist do
	--- 	- --[[____________]] if key == blocklist[i] then
	--- 	- --[[________________]] return true --or false to invert the functionality and treat the blocklist as an allowlist
	--- 	- --[[____________]] end
	--- 	- --[[________]] end
	--- 	- --[[________]] return false --or true to invert the functionality and treat the blocklist as an allowlist
	--- 	- --[[____]] end
	---@param currentKey? string
	---@param currentLevel? number
	WidgetToolbox[ns.WidgetToolsVersion].Dump = function(object, name, depth, blockrule, currentKey, currentLevel)
		--Check whether the current key is to be skipped
		local skip = false
		if currentKey ~= nil and blockrule ~= nil then skip = blockrule(currentKey) end
		--Calculate indentation based on the current depth level
		local indentation = ""
		currentLevel = currentLevel or 0
		for i = 1, currentLevel do
			indentation = indentation .. "    "
		end
		--Format the name and key
		currentKey = currentKey ~= nil and indentation .. "|cFFACD1EC" .. currentKey .. "|r" or nil
		name = name ~= nil and "|cFF69A6F8" .. name .. "|r " or ""
		--Print the line
		if type(object) ~= "table" then
			print(currentKey ~= nil and currentKey .. " =" or "Dump " .. name .. "value:", skip and "…" or object)
			return
		else
			local s = (currentKey ~= nil and currentKey or "Dump " .. name .. "table") .. ":"
			--Stop at the max depth or if the key is skipped
			if skip or currentLevel >= (depth or currentLevel + 1) then
				print(s .. " {…}")
				return
			end
			print(s)
			--Dump the subtable
			for k, v in WidgetToolbox[ns.WidgetToolsVersion].SortedPairs(object) do
				WidgetToolbox[ns.WidgetToolsVersion].Dump(v, nil, depth, blockrule, k, currentLevel + 1)
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
		local s = compact ~= true and " " or ""
		local nl = compact ~= true and "\n" or ""
		local indentation = ""
		currentLevel = currentLevel or 0
		if compact ~= true then for i = 0, currentLevel do indentation = indentation .. "    " end end
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
		return ((chunk .. "}"):gsub("," .. "}", (compact ~= true and "," or "") .. nl .. indentation:gsub("%s%s%s%s(.*)", "%1") .. "}") .. r)
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
	--- - @*param* **k** number | string
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
				if not remove and valueChecker ~= nil then remove = not valueChecker(k, v) end--The value is invalid
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

	---Format a number string to include thousand separation
	---@param value number Number value to turn into a string with thousand separation
	---@param decimals? number Specify the number of decimal places to display if the number is a fractional value [Default: 2]
	---@param trim? boolean Trim trailing zeros in decimal places [Default: true]
	---@return string
	WidgetToolbox[ns.WidgetToolsVersion].FormatThousands = function(value, decimals, trim)
		local fraction = math.fmod(value, 1)
		local integer = value - fraction
		--Formatting
		local leftover
		while true do
			integer, leftover = string.gsub(integer, "^(-?%d+)(%d%d%d)", '%1' .. strings.separator .. '%2')
			if leftover == 0 then break end
		end
		local decimalText = tostring(fraction):sub(3, (decimals or 2) + 2)
		if trim == false then for i = 1, decimals - #decimalText do decimalText = decimalText .. "0" end end
		return integer .. ((fraction ~= 0 or trim == false) and strings.decimal .. decimalText or "")
	end

	---Remove all formatting escape sequences from a string (like **|cAARRGGBB**, **|r** pairs)
	--- - *Grammar* escape sequences are not yet supported, and will not be removed
	---@param s string
	---@return string s
	WidgetToolbox[ns.WidgetToolsVersion].ClearFormatting = function(s)
		s = s:gsub(
			"|c%x%x%x%x%x%x%x%x", ""
		):gsub(
			"|r", ""
		):gsub(
			"|H(.-)|h", "%1"
		):gsub(
			"|T(.-)|t", "%1"
		):gsub(
			"|K(.-)|k", ""
		):gsub(
			"|n", "\n"
		):gsub(
			"||", "|"
		)
		return s
	end

	--[ Convert color table <-> RGB(A) values ]

	---Return a table constructed from color values
	---@param red number [Range: 0 - 1]
	---@param green number [Range: 0 - 1]
	---@param blue number [Range: 0 - 1]
	---@param alpha? number Opacity [Range: 0 - 1, Default: 1]
	---@return number table
	WidgetToolbox[ns.WidgetToolsVersion].PackColor = function(red, green, blue, alpha)
		 return { r = red, g = green, b = blue, a = alpha or 1 }
	end

	---Return the color values found in a table
	---@param table table Table containing the color values
	--- - **r** number ― Red [Range: 0 - 1]
	--- - **g** number ― Green [Range: 0 - 1]
	--- - **b** number ― Blue [Range: 0 - 1]
	--- - **a**? number *optional* ― Opacity [Range: 0 - 1, Default: 1]
	---@param alpha? boolean Specify whether to return the full RGBA set or just the RGB values [Default: true]
	---@return number r
	---@return number g
	---@return number b
	---@return number? a
	WidgetToolbox[ns.WidgetToolsVersion].UnpackColor = function(table, alpha)
		if type(table) ~= "table" then return end
		if alpha or alpha == nil then
			return table.r, table.g, table.b, table.a or 1
		else
			return table.r, table.g, table.b
		end
	end

	--[ Convert HEX <-> RGB(A) values ]

	---Convert RGB(A) color values [Range: 0 - 1] to HEX color code
	---@param r number Red [Range: 0 - 1]
	---@param g number Green [Range: 0 - 1]
	---@param b number Blue [Range: 0 - 1]
	---@param a? number Alpha [Range: 0 - 1, Default: *no alpha*]
	---@param alphaFirst? boolean Put the alpha value first: ARGB output instead of RGBA [Default: false]
	---@param hashtag? boolean Whether to add a "#" to the beginning of the color description [Default: true]
	---@return string hex Color code in HEX format (Examples: RGB - "#2266BB", RGBA - "#2266BBAA")
	WidgetToolbox[ns.WidgetToolsVersion].ColorToHex = function(r, g, b, a, alphaFirst, hashtag)
		local hex = hashtag ~= false and "#" or ""
		if a ~= nil and alphaFirst == true then hex = hex .. string.format("%02x", math.ceil(a * 255)) end
		hex = hex .. string.format("%02x", math.ceil(r * 255)) .. string.format("%02x", math.ceil(g * 255)) .. string.format("%02x", math.ceil(b * 255))
		if a ~= nil and alphaFirst ~= true then hex = hex .. string.format("%02x", math.ceil(a * 255)) end
		return hex:upper()
	end

	---Convert a HEX color code into RGB or RGBA [Range: 0 - 1]
	---@param hex string String in HEX color code format (Examples: RGB - "#2266BB", RGBA - "#2266BBAA" where the "#" is optional)
	---@return number r Red value [Range: 0 - 1]
	---@return number g Green value [Range: 0 - 1]
	---@return number b Blue value [Range: 0 - 1]
	---@return number? a Alpha value [Range: 0 - 1]
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
	---@param relativeTo Frame [Default: UIParent *(the entire screen)*]
	---@param relativePoint AnchorPoint [Default: **anchor**]
	---@param offsetX? number [Default: 0]
	---@param offsetY? number [Default: 0]
	---@param userPlaced boolean Whether to set the position of the frame to be user placed [Default: false]
	WidgetToolbox[ns.WidgetToolsVersion].PositionFrame = function(frame, anchor, relativeTo, relativePoint, offsetX, offsetY, userPlaced)
		frame:ClearAllPoints()
		--Set the position
		if (relativeTo == nil or relativePoint == nil) and (offsetX == nil or offsetY == nil) then
			frame:SetPoint(anchor)
		elseif relativeTo == nil or relativePoint == nil then
			frame:SetPoint(anchor, offsetX, offsetY)
		elseif offsetX == nil or offsetY == nil then
			frame:SetPoint(anchor, relativeTo, relativePoint)
		else
			frame:SetPoint(anchor, relativeTo, relativePoint, offsetX, offsetY)
		end
		--Set user placed
		if frame["SetUserPlaced"] ~= nil and frame:IsMovable() then frame:SetUserPlaced(userPlaced == true) end
	end

	--[ Widget Dependency Management ]

	---Check all dependencies (disable / enable rules) of a frame
	---@param rules table Indexed, 0-based table containing the dependency rules of the frame object
	--- - **frame** Frame — Reference to the widget the state of a widget is tied to
	--- - **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 	- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 	- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 	- ***Overloads:***
	--- 		- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 		- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 		- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 		- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 	- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	---@return boolean state
	local function CheckDependencies(rules)
		local state = true
		for i = 0, #rules do
			if rules[i].frame.IsObjectType ~= nil then
				--Blizzard Widgets
				if rules[i].frame:IsObjectType("CheckButton") then
					if rules[i].evaluate ~= nil then
						state = rules[i].evaluate(rules[i].frame:GetChecked())
					else
						state = rules[i].frame:GetChecked()
					end
				elseif rules[i].frame:IsObjectType("Slider") then
					state = rules[i].evaluate(rules[i].frame:GetValue())
				end
			else
				--Custom Widgets
				if rules[i].frame.isObjectType("Selector") then
					state = rules[i].evaluate(rules[i].frame.getSelected())
				-- elseif rules[i].frame:IsObjectType("Dropdown") then
				-- 	state = rules[i].evaluate()
				end
			end
			if state == false then break end
		end
		return state
	end

	---Set the dependencies (disable / enable rules) of a frame based on a ruleset
	---@param rules table Indexed, 0-based table containing the dependency rules of the frame object
	--- - **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- - **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 	- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 	- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 	- ***Overloads:***
	--- 		- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 		- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 		- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 		- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 	- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	---@param setState function Function to call to set the state of the frame
	--- - @*param* boolean
	local function SetDependencies(rules, setState)
		for i = 0, #rules do
			if rules[i].frame.HookScript ~= nil and rules[i].frame.IsObjectType ~= nil then
				rules[i].frame:HookScript("OnAttributeChanged", function(_, name, value)
					if name == "loaded" and value == true then setState(CheckDependencies(rules)) end
				end)
				--Blizzard Widgets
				if rules[i].frame:IsObjectType("CheckButton") then
					rules[i].frame:HookScript("OnClick", function() setState(CheckDependencies(rules)) end)
				elseif rules[i].frame:IsObjectType("Slider") then
					rules[i].frame:HookScript("OnValueChanged", function() setState(CheckDependencies(rules)) end)
				end
			else
				rules[i].frame.frame:HookScript("OnAttributeChanged", function(_, name, value)
					if name == "loaded" and value == true then setState(CheckDependencies(rules)) end
				end)
				--Custom Widgets
				if rules[i].frame.isObjectType("Selector") then
					rules[i].frame.frame:HookScript("OnAttributeChanged", function(_, name) if name == "selected" then setState(CheckDependencies(rules)) end end)
				-- elseif rules[i].frame:IsObjectType("Dropdown") then
				-- 	rules[i].frame:HookScript("OnClick", setState(rules[i].evaluate()))
				end
			end
		end
	end

	--[ Interface Options Data Management ]

	---Add a connection between an options widget and a DB entry to the options data table
	---@param widget table Widget table containing reference to its UI frame
	--- - **frame** Frame ― Reference to the object to be saved & loaded data to & from
	---@param type FrameType | UniqueFrameType Type of the widget object (string)
	--- - ***Example:*** The return value of [**widget**:GetObjectType()](https://wowpedia.fandom.com/wiki/API_UIObject_GetObjectType) (for applicable Blizzard-built widgets).
	--- - ***Note:*** If GetObjectType() would return "Frame" in case of a Frame with UIDropDownMenuTemplate or another uniquely built frame, provide a UniqueFrameType.
	---@param onSave? function Optional function to be called when they okay button is pressed (after the data has been saved from the options widget to the storage table)
	--- - @*param* **self** Frame ― Reference to the widget
	---@param onLoad? function Optional function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget)
	--- - @*param* **self** Frame ― Reference to the widget
	---@param optionsTable? table Reference to the table where all options data should be stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	---@param optionsData? table Table containing the autosave/-load-specific options data of the specified widget
	--- - **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- - **key** string ― Key of the variable inside the storage table
	--- - **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 	- @*param* boolean ― The current value of the widget
	--- 	- @*return* any ― The converted data to be saved to the storage table
	--- - **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 	- @*param* any ― The data in the storage table to be converted and loaded to the widget
	--- 	- @*return* boolean ― The value to be set to the widget
	WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData = function(widget, type, onSave, onLoad, optionsTable, optionsData)
		--Set the options data table
		if optionsTable == nil then
			if WidgetToolbox[ns.WidgetToolsVersion] == nil then
				WidgetToolbox[ns.WidgetToolsVersion] = {}
				WidgetToolbox[ns.WidgetToolsVersion].OptionsData = {}
			elseif WidgetToolbox[ns.WidgetToolsVersion].OptionsData == nil then
				WidgetToolbox[ns.WidgetToolsVersion].OptionsData = {}
			end
			optionsTable = WidgetToolbox[ns.WidgetToolsVersion].OptionsData
		end
		--Add the options data
		if optionsTable[type] == nil then optionsTable[type] = {} end
		if optionsData == nil then optionsData = {} end
		optionsData.widget = widget
		optionsData.onSave = onSave
		optionsData.onLoad = onLoad
		optionsTable[type][optionsTable[type][0] == nil and 0 or #optionsTable[type] + 1] = optionsData
	end

	---Save all data from the widgets to the storage table(s) specified in an options data table
	---@param optionsTable? table Reference to the table where all options data is being stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	WidgetToolbox[ns.WidgetToolsVersion].SaveOptionsData = function(optionsTable)
		if optionsTable == nil then
			if WidgetToolbox[ns.WidgetToolsVersion].OptionsData == nil then return end
			optionsTable = WidgetToolbox[ns.WidgetToolsVersion].OptionsData
		end
		for k, v in pairs(optionsTable) do
			for i = 0, #v do
				--Automatic save
				if v[i].storageTable ~= nil and v[i].key ~= nil then
					--Get the value from the widget
					local value = nil
					if k == "CheckButton" then value = v[i].widget:GetChecked()
					elseif k == "Slider" then value = v[i].widget:GetValue()
					elseif k == "EditBox" then value = v[i].widget:GetText()
					elseif k == "Selector" then value = v[i].widget.getSelected()
					elseif k == "Dropdown" then value = UIDropDownMenu_GetSelectedValue(v[i].widget)
					elseif k == "ColorPicker" then value = WidgetToolbox[ns.WidgetToolsVersion].PackColor(v[i].widget.getColor()) end
					if value ~= nil then
						--Save the value to the storage table
						if v[i].convertSave ~= nil then value = v[i].convertSave(value) end
						v[i].storageTable[v[i].key] = value
					end
				end
				--Call onSave if specified
				if v[i].onSave ~= nil then v[i].onSave(v[i].widget) end
			end
		end
	end

	---Load all data from the storage table(s) to the widgets specified in an options data table
	--- - [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) will be triggered for all frames:
	--- 	- First, before the widget's value is loaded the event will be called with:
	--- 		- **name**: "loaded"
	--- 		- **value**: false
	--- 	- Second, after the widget's value has been successfully loaded:
	--- 		- **name**: "loaded"
	--- 		- **value**: true
	---@param optionsTable? table Reference to the table where all options data is being stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	WidgetToolbox[ns.WidgetToolsVersion].LoadOptionsData = function(optionsTable)
		if optionsTable == nil then
			if WidgetToolbox[ns.WidgetToolsVersion].OptionsData == nil then return end
			optionsTable = WidgetToolbox[ns.WidgetToolsVersion].OptionsData
		end
		for k, v in pairs(optionsTable) do
			for i = 0, #v do
				--Automatic load
				if v[i].storageTable ~= nil and v[i].key ~= nil then
					--Load the value from the storage table
					local value = v[i].storageTable[v[i].key]
					if v[i].convertLoad ~= nil then value = v[i].convertLoad(value) end
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
						v[i].widget.frame:SetAttribute("loaded", false)
						v[i].widget.setSelected(value)
						v[i].widget.frame:SetAttribute("loaded", true)
					elseif k == "Dropdown" then
						v[i].widget:SetAttribute("loaded", false)
						UIDropDownMenu_SetSelectedValue(v[i].widget, value)
						v[i].widget:SetAttribute("loaded", true)
					elseif k == "ColorPicker" then
						v[i].widget.frame:SetAttribute("loaded", false)
						v[i].widget.setColor(WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(value))
						v[i].widget.frame:SetAttribute("loaded", true)
					end
				end
				--Call onLoad if specified
				if v[i].onLoad ~= nil then v[i].onLoad(v[i].widget) end
				--Signal that the widget's value has been loaded to trigger the OnAttributeChanged event
			end
		end
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
	---@param name string Unique string piece to place in the name of the the tooltip to distinguish it from other tooltips
	---@return GameTooltip tooltip
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

	local customTooltip = CreateGameTooltip("WidgetTools" .. ns.WidgetToolsVersion)

	---Set up a show a GameTooltip for a frame
	---@param tooltip? GameTooltip Reference to the tooltip widget to set up [Default: WidgetToolsGameTooltip]
	---@param owner Frame Owner frame the tooltip to be shown for
	---@param anchor string [GameTooltip anchor](https://wowpedia.fandom.com/wiki/API_GameTooltip_SetOwner)
	---@param title string String to be shown as the tooltip title
	---@param text? string String to be shown as the first line of tooltip summary
	---@param extraLines? table Table containing additional string lines to be added to the tooltip text [indexed, 0-based]
	--- - **text** string ― Text to be added to the line
	--- - **color**? table *optional* ― RGB colors line
	--- 	- **r** number ― Red [Range: 0 - 1]
	--- 	- **g** number ― Green [Range: 0 - 1]
	--- 	- **b** number ― Blue [Range: 0 - 1]
	--- - **wrap**? boolean *optional* ― Allow wrapping the line [Default: true]
	---@param offsetX? number [Default: 0]
	---@param offsetY? number [Default: 0]
	---@return GameTooltip tooltip (Don't forget to hide later!)
	WidgetToolbox[ns.WidgetToolsVersion].AddTooltip = function(tooltip, owner, anchor, title, text, extraLines, offsetX, offsetY)
		if tooltip == nil then tooltip = customTooltip end
		--Position
		tooltip:SetOwner(owner, anchor, offsetX, offsetY)
		--Title
		tooltip:AddLine(title, colors.title.r, colors.title.g, colors.title.b, true)
		--Summary
		if text ~= nil then
			tooltip:AddLine(text, colors.normal.r, colors.normal.g, colors.normal.b, true)
			--Additional text lines
			if extraLines ~= nil then
				--Empty line after the summary
				tooltip:AddLine(" ", nil, nil, nil, true) --TODO: Check why the third line has the title FontObject
				for i = 0, #extraLines do
					--Add line
					local r = (extraLines[i].color or {}).r or colors.normal.r
					local g = (extraLines[i].color or {}).g or colors.normal.g
					local b = (extraLines[i].color or {}).b or colors.normal.b
					tooltip:AddLine(extraLines[i].text, r, g, b, extraLines[i].wrap == nil and true or extraLines[i].wrap)
				end
			end
		end
		--Show
		tooltip:Show() --Don't forget to hide later!
		return tooltip
	end

	--[ Popup Dialogue Box ]

	---Create a popup dialogue with an accept function and cancel button
	---@param addon string The name of the addon's folder
	---@param t table Parameters are to be provided in this table
	--- - **name** string — Appended to the addon's name as a unique identifier key in the global **StaticPopupDialogs** table
	--- - **text** string — The text to display as the message in the popup window
	--- - **accept**? string *optional* — The text to display as the label of the accept button [Default: **t.name**]
	--- - **cancel**? string *optional* — The text to display as the label of the cancel button [Default: **WidgetToolbox[ns.WidgetToolsVersion].strings.misc.cancel**]
	--- - **onAccept** function — The function to be called when the accept button is pressed and an OnAccept event happens
	--- - **onCancel**? function *optional* — The function to be called when the cancel button is pressed, the popup is overwritten (by another popup for instance) or the popup expires and an OnCancel event happens
	---@return string key The unique identifier key created for this popup in the global **StaticPopupDialogs** table used as the parameter when calling [StaticPopup_Show()](https://wowwiki-archive.fandom.com/wiki/Creating_simple_pop-up_dialog_boxes#Displaying_the_popup) or [StaticPopup_Hide()](https://wowwiki-archive.fandom.com/wiki/Creating_simple_pop-up_dialog_boxes#Hiding_the_popup)
	WidgetToolbox[ns.WidgetToolsVersion].CreatePopup = function(addon, t)
		local key = addon:upper() .. "_" .. t.name:gsub("%s+", "_"):upper()
		StaticPopupDialogs[key] = {
			text = t.text,
			button1 = t.accept or t.name,
			button2 = t.cancel or strings.misc.cancel,
			OnAccept = t.onAccept,
			OnCancel = t.onCancel or nil,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = STATICPOPUPS_NUMDIALOGS
		}
		return key
	end

	--[ Reload Notice ]

	local reloadFrame
	WidgetToolbox[ns.WidgetToolsVersion].CreateReloadNotice = function()
		if reloadFrame then
			reloadFrame:Show()
			return reloadFrame
		end
		local reload = WidgetToolbox[ns.WidgetToolsVersion].CreatePanel({
			parent = UIParent,
			position = {
				anchor = "TOPRIGHT",
				offset = { x = -300, y = -80 }
			},
			size = { width = 240, height = 74 },
			title = strings.reload.title,
			description = strings.reload.description
		})
		WidgetToolbox[ns.WidgetToolsVersion].CreateButton({
			parent = reload,
			position = {
				anchor = "TOPLEFT",
				offset = { x = 10, y = -40 }
			},
			width = 120,
			label = strings.reload.accept.label,
			tooltip = strings.reload.accept.tooltip,
			onClick = function() ReloadUI() end
		})
		WidgetToolbox[ns.WidgetToolsVersion].CreateButton({
			parent = reload,
			position = {
				anchor = "TOPRIGHT",
				offset = { x = -10, y = -40 }
			},
			width = 80,
			label = strings.reload.cancel.label,
			tooltip = strings.reload.cancel.tooltip,
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
	--- - **frame** Frame ― The frame to create the text in
	--- - **name**? string *optional* ― String to append to the name of **t.frame** as the unique name of the new [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) [Default: "Text"]
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? Frame *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **width**? number *optional*
	--- - **justify**? string *optional* — Set the horizontal justification of the text: "LEFT"|"RIGHT"|"CENTER" [Default: "CENTER"]
	--- - **layer**? Layer *optional* ― Draw [Layer](https://wowpedia.fandom.com/wiki/Layer)
	--- - **template**? string *optional* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) [Default: "GameFontNormal" if **t.font** == nil]
	--- - **font**? table *optional* ― Table containing font properties used for [SetFont](https://wowwiki-archive.fandom.com/wiki/API_FontInstance_SetFont)
	--- 	- **path** string ― Path to the font file relative to the WoW client directory
	--- 	- **size** number
	--- 	- **flags** string ― Outline, coloring (comma separated string of one or more of): "OUTLINE"|"THICKOUTLINE"|"THINOUTLINE"|"MONOCHROME" ..
	--- - **color**? table *optional* — Apply the specified color to the text
	--- 	- **r** number ― Red [Range: 0 - 1]
	--- 	- **g** number ― Green [Range: 0 - 1]
	--- 	- **b** number ― Blue [Range: 0 - 1]
	--- 	- **a** number ― Opacity [Range: 0 - 1]
	--- - **text** string ― Text to be shown
	---@return FontString text
	WidgetToolbox[ns.WidgetToolsVersion].CreateText = function(t)
		local text = t.frame:CreateFontString(t.frame:GetName() .. (t.name or "Text"), t.layer, (t.template == nil and t.font == nil) and "GameFontNormal" or t.template)
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			text, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y
		)
		if t.width ~= nil then text:SetWidth(t.width) end
		if t.justify ~= nil then text:SetJustifyH(t.justify) end
		if t.font ~= nil then text:SetFont(t.font.path, t.font.size, t.font.flags) end
		if t.color ~= nil then text:SetTextColor(WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(t.color)) end
		text:SetText(t.text)
		return text
	end

	--[ Frame Title & Description (optional) ]

	---Add a title and an optional description to a container frame
	---@param t table Parameters are to be provided in this table
	--- - **frame** Frame ― The frame panel to add the title and (optional) description to
	--- - **title** table
	--- 	- **text** string ― Text to be shown as the main title of the frame
	--- 	- **template**? string *optional* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) [Default: "GameFontNormal"]
	--- 	- **anchor**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional* ― [Default: "TOPLEFT"]
	--- 	- **offset**? table *optional* ― The offset from the anchor point relative to the specified frame
	--- 		- **x** number ― Horizontal offset value
	--- 		- **y** number ― Vertical offset value
	--- 	- **width**? number *optional* [Default: *width of the parent frame*]
	--- 	- **justify**? table *optional* — Set the horizontal justification of the text: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **color**? table *optional* — Apply the specified color to the title
	--- 		- **r** number ― Red [Range: 0 - 1]
	--- 		- **g** number ― Green [Range: 0 - 1]
	--- 		- **b** number ― Blue [Range: 0 - 1]
	--- 		- **a** number ― Opacity [Range: 0 - 1]
	--- - **description**? table *optional*
	--- 	- **text** string ― Text to be shown as the description of the frame
	--- 	- **template**? string *optional* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) [Default: "GameFontNormal"]
	--- 	- **offset**? table *optional* ― The offset from the "BOTTOMLEFT" point of the main title
	--- 		- **x** number ― Horizontal offset value
	--- 		- **y** number ― Vertical offset value
	--- 	- **width**? number *optional* [Default: *width of the parent frame*]
	--- 	- **justify**? table *optional* — Set the horizontal justification of the text: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **color**? table *optional* — Apply the specified color to the description
	--- 		- **r** number ― Red [Range: 0 - 1]
	--- 		- **g** number ― Green [Range: 0 - 1]
	--- 		- **b** number ― Blue [Range: 0 - 1]
	--- 		- **a** number ― Opacity [Range: 0 - 1]
	---@return FontString title
	---@return FontString? description
	WidgetToolbox[ns.WidgetToolsVersion].AddTitle = function(t)
		--Title
		local title = WidgetToolbox[ns.WidgetToolsVersion].CreateText({
			frame = t.frame,
			name = "Title",
			position = {
				anchor = t.title.anchor or "TOPLEFT",
				offset = { x = t.title.offset.x, y = t.title.offset.y }
			},
			width = t.title.width or t.frame:GetWidth() - ((t.title.offset or {}).x or 0),
			layer = "ARTWORK",
			template =  t.title.template,
			justify = t.title.justify or "LEFT",
			color = t.title.color,
			text = t.title.text,
		})
		if t.description == nil then return title end
		--Description
		local description = WidgetToolbox[ns.WidgetToolsVersion].CreateText({
			frame = t.frame,
			name = "Description",
			position = {
				anchor = "TOPLEFT",
				relativeTo = title,
				relativePoint = "BOTTOMLEFT",
				offset = { x = t.description.offset.x, y = t.description.offset.y }
			},
			width = t.description.width or t.frame:GetWidth() - ((t.title.offset or {}).x or 0) - ((t.description.offset or {}).x or 0),
			layer = "ARTWORK",
			template =  t.description.template,
			justify = t.description.justify or "LEFT",
			color = t.description.color,
			text = t.description.text,
		})
		return title, description
	end

	--[ Texture Image ]

	---Create a texture/image
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new button
	--- - **name**? string *optional* — String to append to the name of **t.parent** as the unique name of the new texture frame [Default: "Texture"]
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
	WidgetToolbox[ns.WidgetToolsVersion].CreateTexture = function(t)
		local texture = t.parent:CreateTexture(t.parent:GetName() .. (t.name or "Texture"))
		--Position & dimensions
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			texture, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y
		)
		texture:SetSize(t.size.width, t.size.height)
		--Set asset
		if t.tile ~= nil then
			texture:SetTexture(t.path, t.tile)
		else
			texture:SetTexture(t.path)
		end
		return texture
	end


	--[[ CONTAINERS ]]

	--[ Scrollable Frame ]

	---Create an empty vertically scrollable frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to place the scroll frame into
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? Frame *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
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
		local scrollFrame = CreateFrame("ScrollFrame", t.parent:GetName() .. "ScrollFrame", t.parent, "UIPanelScrollFrameTemplate")
		--Position & dimensions
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			scrollFrame, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y
		)
		scrollFrame:SetSize((t.size or {}).width or t.parent:GetWidth(), (t.size or {}).height)
		--Scrollbar & buttons
		_G[scrollFrame:GetName() .. "ScrollBarScrollUpButton"]:ClearAllPoints()
		_G[scrollFrame:GetName() .. "ScrollBarScrollUpButton"]:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", -2, -3)
		_G[scrollFrame:GetName() .. "ScrollBarScrollDownButton"]:ClearAllPoints()
		_G[scrollFrame:GetName() .. "ScrollBarScrollDownButton"]:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", -2, 3)
		_G[scrollFrame:GetName() .. "ScrollBar"]:ClearAllPoints()
		_G[scrollFrame:GetName() .. "ScrollBar"]:SetPoint("TOP", _G[scrollFrame:GetName() .. "ScrollBarScrollUpButton"], "BOTTOM")
		_G[scrollFrame:GetName() .. "ScrollBar"]:SetPoint("BOTTOM", _G[scrollFrame:GetName() .. "ScrollBarScrollDownButton"], "TOP")
		if t.scrollSpeed ~= nil then _G[scrollFrame:GetName() .. "ScrollBar"].scrollStep = t.scrollSpeed end
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
		local scrollChild = CreateFrame("Frame", scrollFrame:GetName() .. "ChildFrame", scrollFrame)
		scrollChild:SetPoint("TOPLEFT")
		scrollChild:SetSize(t.scrollSize.width or scrollFrame:GetWidth() - 20, t.scrollSize.height)
		scrollFrame:SetScrollChild(scrollChild)
		return scrollChild, scrollFrame
	end

	--[ Category Panel Frame ]

	---Create a new frame as a category panel
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The main options frame to set as the parent of the new panel
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: **t.title**]
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? Frame *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **size** table
	--- 	- **width**? number *optional* — [Default: *width of the parent frame* - 32]
	--- 	- **height** number
	--- - **title** string — Text to be shown as the main title of the panel
	--- - **description**? string *optional* — Text to be shown as the subtitle/description of the panel
	---@return Frame panel
	WidgetToolbox[ns.WidgetToolsVersion].CreatePanel = function(t)
		local panel = CreateFrame("Frame", t.parent:GetName() .. (t.name or t.title:gsub("%s+", "")), t.parent, BackdropTemplateMixin and "BackdropTemplate")
		--Position & dimensions
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			panel, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y
		)
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
			frame = panel,
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
		return panel
	end

	--[ Interface Options Category Page ]

	---Create an new Interface Options Panel frame
	--- - Note: The new panel will need to be added to the Interface options via WidgetToolsTable[ns.WidgetToolsVersion].AddOptionsPanel()
	---@param t table Parameters are to be provided in this table
	--- - **parent**? string *optional* — The display name of the options category to be set as the parent category, making this its subcategory [Default: *set as a main category*]
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: **t.title**]
	--- - **title** string — Title text to be shown as the title of the options panel
	--- - **description** string — Title text to be shown as the description below the title of the options panel
	--- - **logo**? string *optional* — Path to the texture file to be added as an icon to the top right corner of the panel
	--- - **titleLogo**? boolean *optional* — Append the texture specified as **t.logo** to the title of the interface options button as well [Default: false]
	--- - **scroll**? table *optional* — Create an empty ScrollFrame for the category panel
	--- 	- **height** number — Set the height of the scrollable child frame to the specified value
	--- 	- **speed**? number *optional* — Set the scroll rate to the specified value [Default: *half of the height of the scroll bar*]
	--- - **okay**? function *optional* — The function to be called then the "Okay" button is clicked
	--- - **cancel**? function *optional* — The function to be called then the "Cancel" button is clicked
	--- - **default**? function *optional* — The function to be called then either the "All Settings" or "These Settings" (Options Category Panel-specific) button is clicked from the "Defaults" dialogue (refresh will be called automatically afterwards)
	--- - **refresh**? function *optional* — The function to be called then the interface panel is loaded
	--- - **autoSave**? boolean *optional* — If true, automatically save all data from the storage tables to the widgets stored within the options data table [Default: true]
	--- - **autoLoad**? boolean *optional* — If true, automatically load the values of all widgets to the storage tables within the options data table [Default: true]
	--- - **optionsTable**? table ― Reference to the table where all options data should be stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	---@return Frame optionsPanel
	---@return Frame? scrollChild
	---@return Frame? scrollFrame
	WidgetToolbox[ns.WidgetToolsVersion].CreateOptionsPanel = function(t)
		local optionsPanel = CreateFrame("Frame", (t.name or t.title:gsub("%s+", "")) .. "Options", InterfaceOptionsFramePanelContainer)
		--Position, dimensions & visibility
		optionsPanel:SetSize(InterfaceOptionsFramePanelContainer:GetSize())
		optionsPanel:SetPoint("TOPLEFT") --Preload the frame
		optionsPanel:Hide()
		--Set the category name
		optionsPanel.name = t.title .. (t.logo ~= nil and t.titleLogo == true and " |T" .. t.logo .. ":0|t" or "")
		--Set as a subcategory or a parent category
		if t.parent ~= nil then optionsPanel.parent = t.parent end
		--Title & description
		WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
			frame = optionsPanel,
			title = {
				text = t.title,
				template = "GameFontNormalLarge",
				offset = { x = 16, y = -16 },
				width = optionsPanel:GetWidth() - (t.logo ~= nil and 72 or 32),
				justify = "LEFT"
			},
			description = {
				text = t.description,
				template = "GameFontHighlightSmall",
				offset = { x = 0, y = -8 },
				width = optionsPanel:GetWidth() - (t.logo ~= nil and 72 or 32),
				justify = "LEFT"
			}
		})
		--Icon texture
		if t.logo ~= nil then
			WidgetToolbox[ns.WidgetToolsVersion].CreateTexture({
				parent = optionsPanel,
				name = "Icon",
				path = t.logo,
				position = {
					anchor = "TOPRIGHT",
					offset = { x = -16, y = -16 }
				},
				size = { width = 36, height = 36 }
			})
		end
		--Event handlers
		if t.okay ~= nil or t.autoSave ~= false then optionsPanel.okay = function()
			if t.autoSave ~= false then WidgetToolbox[ns.WidgetToolsVersion].SaveOptionsData(t.optionsTable) end
			if t.okay ~= nil then t.okay() end
		end end
		if t.cancel ~= nil or t.autoLoad ~= false then optionsPanel.cancel = function()
			if t.autoLoad ~= false then WidgetToolbox[ns.WidgetToolsVersion].LoadOptionsData(t.optionsTable) end
			if t.cancel ~= nil then t.cancel() end
		end end
		if t.default ~= nil then optionsPanel.default = t.default end --Refresh will be called automatically afterwards
		if t.refresh ~= nil or t.autoLoad ~= false then optionsPanel.refresh = function()
			if t.autoLoad ~= false then WidgetToolbox[ns.WidgetToolsVersion].LoadOptionsData(t.optionsTable) end
			if t.refresh ~= nil then t.refresh() end
		end end
		--Add to the Interface options
		InterfaceOptions_AddCategory(optionsPanel)
		--Make scrollable
		if t.scroll ~= nil then return optionsPanel, WidgetToolbox[ns.WidgetToolsVersion].AddOptionsPanelScrollFrame(optionsPanel, t.scroll.height, t.scroll.speed) end
		return optionsPanel
	end

	---Create an new ScrollFrame as the child of an Interface Options Panel
	---@param optionsPanel Frame Reference to the options category panel frame
	---@param scrollHeight number Set the height of the scrollable child frame to the specified value
	---@param scrollSpeed? number Set the scroll rate to the specified value [Default: *half of the height of the scroll bar*]
	---@return Frame scrollFrame
	WidgetToolbox[ns.WidgetToolsVersion].AddOptionsPanelScrollFrame = function(optionsPanel, scrollHeight, scrollSpeed)
		--Create the ScrollFrame
		local scrollFrame = WidgetToolbox[ns.WidgetToolsVersion].CreateScrollFrame({
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
		_G[optionsPanel:GetName() .. "Title"]:SetParent(scrollFrame)
		_G[optionsPanel:GetName() .. "Description"]:SetParent(scrollFrame)
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(_G[optionsPanel:GetName() .. "Title"], "TOPLEFT", nil, nil, 16, -12)
		_G[optionsPanel:GetName() .. "Title"]:SetWidth(_G[optionsPanel:GetName() .. "Title"]:GetWidth() - 20)
		_G[optionsPanel:GetName() .. "Description"]:SetWidth(_G[optionsPanel:GetName() .. "Description"]:GetWidth() - 20)
		if _G[optionsPanel:GetName() .. "Icon"] ~= nil then
			_G[optionsPanel:GetName() .. "Icon"]:SetParent(scrollFrame)
			WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(_G[optionsPanel:GetName() .. "Icon"], "TOPRIGHT", nil, nil, -16, -12)
		end
		return scrollFrame
	end


	--[[ DATA ELEMENTS ]]

	--[ Button ]

	---Create a button frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new button
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: **t.label**]
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **width**? number *optional* ― [Default: 40]
	--- - **label** string — Title text to be shown on the button and as the the tooltip label
	--- - **tooltip**? string *optional* — Text to be shown as the tooltip of the button
	--- - **tooltipExtra**? table [indexed, 0-based] *optional* — Additional text lines to be added to the tooltip of the button
	--- 	- **text** string ― Text to be added to the line
	--- 	- **color**? table *optional* ― RGB colors line
	--- 		- **r** number ― Red [Range: 0 - 1]
	--- 		- **g** number ― Green [Range: 0 - 1]
	--- 		- **b** number ― Blue [Range: 0 - 1]
	--- 	- **wrap**? boolean *optional* ― Allow wrapping the line [Default: true]
	--- - **onClick** function — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the button
	--- 	- **event** string — Event name
	--- 	- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	---@return Button button
	WidgetToolbox[ns.WidgetToolsVersion].CreateButton = function(t)
		local button = CreateFrame("Button", t.parent:GetName() .. (t.name or t.label:gsub("%s+", "")) .. "Button", t.parent, "UIPanelButtonTemplate")
		--Position & dimensions
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			button, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y
		)
		if t.width ~= nil then button:SetWidth(t.width) end
		--Font
		getglobal(button:GetName() .. "Text"):SetText(t.label)
		--Event handlers
		button:SetScript("OnClick", t.onClick)
		button:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		if t.onEvent ~= nil then for i = 0, #t.onEvent do button:HookScript(t.onEvent[i].event, t.onEvent[i].handler) end end
		--Tooltip
		button:HookScript("OnEnter", function()
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, button, "ANCHOR_TOPLEFT", t.label, t.tooltip, t.tooltipExtra, 20)
		end)
		button:HookScript("OnLeave", function() customTooltip:Hide() end)
		--State & dependencies
		if t.disabled then button:Disable() end
		if t.dependencies ~= nil then SetDependencies(t.dependencies, function(state) button:SetEnabled(state) end) end
		return button
	end

	--[ Checkbox ]

	---Create a checkbox frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new checkbox
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: **t.label**]
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **autoOffset**? boolean *optional* — Offset the position of the checkbox in a Category Panel to place it into a 3 column grid based on its anchor point. [Default: false]
	--- - **label** string — Text to be shown to the right of the checkbox and as the the tooltip label
	--- - **tooltip**? string *optional* — Text to be shown as the tooltip of the checkbox
	--- - **tooltipExtra**? table [indexed, 0-based] *optional* — Additional text lines to be added to the tooltip of the checkbox
	--- 	- **text** string ― Text to be added to the line
	--- 	- **color**? table *optional* ― RGB colors line
	--- 		- **r** number ― Red [Range: 0 - 1]
	--- 		- **g** number ― Green [Range: 0 - 1]
	--- 		- **b** number ― Blue [Range: 0 - 1]
	--- 	- **wrap**? boolean *optional* ― Allow wrapping the line [Default: true]
	--- - **onClick**? function *optional* — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the checkbox
	--- 	- **event** string — Event name
	--- 	- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	--- - **optionsTable**? table ― Reference to the table where all options data should be stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	--- - **optionsData**? table ― If set, add the checkbox to the referenced options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **key** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* boolean ― The current value of the checkbox
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the checkbox
	--- 		- @*return* boolean ― The value to be set to the checkbox
	--- - **onSave**? function *optional* — Function to be called when they okay button is pressed (after the data has been saved from the options widget to the storage table)
	--- 	- @*param* **self** Frame ― Reference to the widget
	--- - **onLoad**? function *optional* — Function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget)
	--- 	- @*param* **self** Frame ― Reference to the widget
	---@return CheckButton checkbox
	WidgetToolbox[ns.WidgetToolsVersion].CreateCheckbox = function(t)
		local checkbox = CreateFrame("CheckButton", t.parent:GetName() .. (t.name or t.label:gsub("%s+", "")) .. "Checkbox", t.parent, "InterfaceOptionsCheckButtonTemplate")
		--Position & dimensions
		local columnWidth = (t.parent:GetWidth() - 16 - 20) / 3
		local columnOffset = t.autoOffset and (
			t.position.anchor == "TOP" and columnWidth / -2 + checkbox:GetWidth() / 2 or (t.position.anchor == "TOPRIGHT" and -columnWidth - 8 + checkbox:GetWidth() or 0) or 8
		) or 0
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			checkbox, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x + columnOffset, (t.position.offset or {}).y
		)
		--Font
		getglobal(checkbox:GetName() .. "Text"):SetFontObject("GameFontHighlight")
		getglobal(checkbox:GetName() .. "Text"):SetText(t.label)
		--Event handlers
		if t.onClick ~= nil then checkbox:SetScript("OnClick", t.onClick) else checkbox:SetScript("OnClick", function() --[[ Do nothing. ]] end) end
		checkbox:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		if t.onEvent ~= nil then for i = 0, #t.onEvent do checkbox:HookScript(t.onEvent[i].event, t.onEvent[i].handler) end end
		--Tooltip
		checkbox:HookScript("OnEnter", function()
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, checkbox, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra)
		end)
		checkbox:HookScript("OnLeave", function() customTooltip:Hide() end)
		--State & dependencies
		if t.disabled then
			checkbox:Disable()
			getglobal(checkbox:GetName() .. "Text"):SetFontObject("GameFontDisable")
		end
		if t.dependencies ~= nil then SetDependencies(t.dependencies, function(state)
			checkbox:SetEnabled(state)
			getglobal(checkbox:GetName() .. "Text"):SetFontObject(state and "GameFontHighlight" or "GameFontDisable")
		end) end
		--Add to options data management
		if t.optionsData ~= nil or t.onSave ~= nil or t.onLoad ~= nil then
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(checkbox, checkbox:GetObjectType(), t.onSave, t.onLoad, t.optionsTable, t.optionsData)
		end
		return checkbox
	end

	--[ Selector & Radio Button ]

	---Create a radio button frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new radio button
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: **t.label**]
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **width**? number *optional* — The combined width of the radio button's dot and the clickable extension to the right of it (where the label is) [Default: 140]
	--- - **label** string — Text to be shown on the right of the radio button and as the the tooltip label
	--- - **title**? boolean *optional* — Whether or not to show the label and add a clickable extension next to the the radio button bot [Default: true]
	--- - **tooltip**? string *optional* — Text to be shown as the tooltip of the radio button
	--- - **tooltipExtra**? table [indexed, 0-based] *optional* — Additional text lines to be added to the tooltip of the radio button
	--- 	- **text** string ― Text to be added to the line
	--- 	- **color**? table *optional* ― RGB colors line
	--- 		- **r** number ― Red [Range: 0 - 1]
	--- 		- **g** number ― Green [Range: 0 - 1]
	--- 		- **b** number ― Blue [Range: 0 - 1]
	--- 	- **wrap**? boolean *optional* ― Allow wrapping the line [Default: true]
	--- - **onClick**? function *optional* — The function to be called when an [OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the radio button
	--- 	- **event** string — Event name
	--- 	- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for radio buttons*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	--- - **optionsTable**? table ― Reference to the table where all options data should be stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	--- - **optionsData**? table ― If set, add the radio button to the referenced options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **key** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* boolean ― The current value of the radio button
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the radio button
	--- 		- @*return* boolean ― The value to be set to the radio button
	--- - **onSave**? function *optional* — Function to be called when they okay button is pressed (after the data has been saved from the options widget to the storage table)
	--- 	- @*param* **self** Frame ― Reference to the widget
	--- - **onLoad**? function *optional* — Function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget)
	--- 	- @*param* **self** Frame ― Reference to the widget
	---@return CheckButton radioButton
	WidgetToolbox[ns.WidgetToolsVersion].CreateRadioButton = function(t)
		local radioButton = CreateFrame("CheckButton", t.parent:GetName() .. (t.name or t.label:gsub("%s+", "")) .. "RadioButton", t.parent, "UIRadioButtonTemplate")
		--Position & dimensions
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			radioButton, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y
		)
		--Label & clickable extension
		if t.title ~= false then
			--Font & text
			getglobal(radioButton:GetName() .. "Text"):SetFontObject("GameFontHighlightSmall")
			getglobal(radioButton:GetName() .. "Text"):SetText(t.label)
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
			extension:HookScript("OnEnter", function()
				WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, radioButton, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra)
			end)
			extension:HookScript("OnLeave", function() customTooltip:Hide() end)
		end
		--Event handlers
		if t.onClick ~= nil then radioButton:SetScript("OnClick", t.onClick) end
		radioButton:HookScript("OnClick", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)
		if t.onEvent ~= nil then for i = 0, #t.onEvent do radioButton:HookScript(t.onEvent[i].event, t.onEvent[i].handler) end end
		--Tooltip
		radioButton:HookScript("OnEnter", function()
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, radioButton, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra)
		end)
		radioButton:HookScript("OnLeave", function() customTooltip:Hide() end)
		--State & dependencies
		if t.disabled then
			radioButton:Disable()
			getglobal(radioButton:GetName() .. "Text"):SetFontObject("GameFontDisableSmall")
		end
		if t.dependencies ~= nil then SetDependencies(t.dependencies, function(state)
			radioButton:SetEnabled(state)
			getglobal(radioButton:GetName() .. "Text"):SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall")
		end) end
		--Add to options data management
		if t.optionsData ~= nil or t.onSave ~= nil or t.onLoad ~= nil then
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(radioButton, radioButton:GetObjectType(), t.onSave, t.onLoad, t.optionsTable, t.optionsData)
		end
		return radioButton
	end

	---Set up the built-in Color Picker and create a button as a child of a container frame to open it
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new selector
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: **t.label**]
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **width**? number *optional* ― The height is defaulted to 36, the width may be specified [Default: 140]
	--- - **title** string — Title text to be shown above the radio buttons
	--- - **items** table [indexed, 0-based] — Table containing subtables with data used to create radio button items, or already existing radio button widget frames
	--- 	- **label** string — Text to represent the items within the selector frame
	--- 	- **tooltip**? string *optional* — Text to be shown as the tooltip of the radio button
	--- 	- **tooltipExtra**? table [indexed, 0-based] *optional* — Additional text lines to be added to the tooltip of the radio button
	--- 		- **text** string ― Text to be added to the line
	--- 		- **color**? table *optional* ― RGB colors line
	--- 			- **r** number ― Red [Range: 0 - 1]
	--- 			- **g** number ― Green [Range: 0 - 1]
	--- 			- **b** number ― Blue [Range: 0 - 1]
	--- 		- **wrap**? boolean *optional* ― Allow wrapping the line [Default: true]
	--- 	- **onSelect**? function *optional* — The function to be called when the radio button is clicked and the item is selected
	--- - **labels**? boolean *optinal* — Whether or not to add the labels to the right of each newly created radio button [Default: true]
	--- - **columns**? integer *optional* — Arrange the newly created radio buttons in a grid with the specified number of columns instead of a vertical list [Default: 1]
	--- - **selected?** integer *optional* — The item to be set as selected on load [Default: 0]
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	--- - **optionsTable**? table ― Reference to the table where all options data should be stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	--- - **optionsData**? table ― If set, add the selector to the referenced options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **key** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* integer ― The index of the currently selected item in the selector
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the selector
	--- 		- @*return* integer ― The index of the item to be set as selected in the selector
	--- - **onSave**? function *optional* — Function to be called when they okay button is pressed (after the data has been saved from the options widget to the storage table)
	--- 	- @*param* **self** Frame ― Reference to the widget
	--- - **onLoad**? function *optional* — Function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget)
	--- 	- @*param* **self** Frame ― Reference to the widget
	---@return table selector A table containing component frame references and getter & setter functions
	--- - **frame** Frame Reference to the selector parent frame
	--- 	- ***Events:***
	--- 		- **OnAttributeChanged** ― Fired after **setSelected** was called (use **selector.frame**:[HookScript](https://wowwiki-archive.fandom.com/wiki/API_Frame_HookScript)(name, index) to add a listener)
	--- 			- @*return* "selected" string
	--- 			- @*return* **index** integer
	--- - **getObjectType** function Returns the object type of this unique frame
	--- 	- @*return* "Selector" UniqueFrameType
	--- - **isObjectType** function Checks and returns if the type of this unique frame is equal to the string provided
	--- 	- @*param* **type** string
	--- 	- @*return* boolean
	--- - **getSelected** function Returns the index of the currently selected item
	--- 	- @*return* **index** integer — [Default: 0]
	--- - **setSelected** function Set the specified item as selected (automatically called when an item is manually selected by cligking on a radio button)
	--- 	- @*param* **index** integer
	--- 	- @*param* **user** boolean — Whether to call **t.item.onSelect** [Default: false]
	--- 	- @*return* boolean
	WidgetToolbox[ns.WidgetToolsVersion].CreateSelector = function(t)
		local selectorFrame = CreateFrame("Frame", t.parent:GetName() .. (t.name or t.label:gsub("%s+", "")) .. "Selector", t.parent)
		--Position & dimensions
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			selectorFrame, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y
		)
		local frameWidth = (t.size or {}).width or 140
		selectorFrame:SetSize(frameWidth, 36)
		--Title
		local title = WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
			frame = selectorFrame,
			title = {
				text = t.label,
				template = "GameFontNormal",
				offset = { x = 4, y = 0 }
			}
		})
		--Add radio buttons
		local items = {}
		for i = 0, #t.items do
			if t.items[i].GetObjectType ~= nil then --It's an already existing radio button
				items[i] = t.items[i]
			else --Create a new radio button
				local sameRow = i % (t.columns or 1) > 0
				items[i] = WidgetToolbox[ns.WidgetToolsVersion].CreateRadioButton({
					parent = selectorFrame,
					position = {
						anchor = "TOPLEFT",
						relativeTo = i > 0 and items[sameRow and i - 1 or i - (t.columns or 1)] or title,
						relativePoint = sameRow and "TOPRIGHT" or "BOTTOMLEFT",
						offset = { x = 0, y = i > 0 and 0 or -4 }
					},
					label = t.items[i].label,
					title = t.labels,
					tooltip = t.items[i].tooltip,
					tooltipExtra = t.items[i].tooltipExtra,
					dependencies = t.dependencies,
				})

			end
		end
		--State & dependencies
		if t.disabled then
			title:SetFontObject("GameFontDisable")
		end
		if t.dependencies ~= nil then SetDependencies(t.dependencies, function(state)
			title:SetFontObject(state and "GameFontNormal" or "GameFontDisable")
		end) end
		--Assemble the seletor widget table
		local selector = {
			frame = selectorFrame,
			getObjectType = function() return "Selector" end,
			isObjectType = function(type) return type == "Selector" end,
			getSelected = function() for i = 0, #items do if items[i]:GetChecked() then return i end end return 0 end,
			setSelected = function(index, user)
				if index > #items then index = #items elseif index < 0 then index = 0 end
				for i = 0, #items do items[i]:SetChecked(i == index) end
				if t.items[index].onSelect ~= nil and user == true then t.items[index].onSelect() end
				selectorFrame:SetAttribute("selected", index)
			end,
		}
		for i = 0, #items do items[i]:HookScript("OnClick", function() selector.setSelected(i, true) end) end
		selector.setSelected(t.selected or 0)
		--Add to options data management
		if t.optionsData ~= nil or t.onSave ~= nil or t.onLoad ~= nil then
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(selector, selector.getObjectType(), t.onSave, t.onLoad, t.optionsTable, t.optionsData)
		end
		return selector
	end

	--[ EditBox ]

	---Create an editbox frame as a child of a container frame
	---@param editBox EditBox Parent frame of [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) type
	---@param t table Parameters are to be provided in this table
	--- - **multiline** boolean — Set to true if the editbox should be support multiple lines for the string input
	--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
	--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" [Default: "MIDDLE"]
	--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) [Default: 0 (*no limit*)]
	--- - **fontObject**? FontString *optional*— Font template object to use [Default: *default font template based on the frame template*]
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox
	--- 	- **r** number ― Red [Range: 0 - 1]
	--- 	- **g** number ― Green [Range: 0 - 1]
	--- 	- **b** number ― Blue [Range: 0 - 1]
	--- 	- **a** number ― Opacity [Range: 0 - 1]
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **title**? FontString *optional* — The title above the editbox [Default: nil *(no title)*]
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true [Default: false]
	--- - **onChar**? function *optional* — The function to be called when a character is entered. Can be used for excluding characters via pattern matching.
	--- - **onEnterPressed**? function *optional* — The function to be called when an [OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed) event happens
	--- - **onEscapePressed**? function *optional* — The function to be called when an [OnEscapePressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEscapePressed) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the editbox
	--- 	- **event** string — Event name
	--- 	- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	--- - **optionsTable**? table ― Reference to the table where all options data should be stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	--- - **optionsData**? table ― If set, add the editbox to the referenced options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **key** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* string ― The current value of the editbox
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the editbox
	--- 		- @*return* string ― The value to be set to the editbox
	--- - **onSave**? function *optional* — Function to be called when they okay button is pressed (after the data has been saved from the options widget to the storage table)
	--- 	- @*param* **self** Frame ― Reference to the widget
	--- - **onLoad**? function *optional* — Function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget)
	--- 	- @*param* **self** Frame ― Reference to the widget
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
		if t.color ~= nil and t.text ~= nil then
			local r, g, b, a = WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(t.color)
			t.text = "|c" .. WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(r, g, b, a, true, false) .. t.text .. "|r"
		end
		--Events & behavior
		editBox:SetAutoFocus(false)
		if t.text ~= nil then editBox:HookScript("OnShow", function(self) self:SetText(t.text) end) end
		if t.onChar ~= nil then editBox:SetScript("OnChar", t.onChar) end
		if t.onEnterPressed ~= nil then
			editBox:SetScript("OnEnterPressed", t.onEnterPressed)
			editBox:HookScript("OnEnterPressed", function(self)
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
				self:ClearFocus()
			end)
		end
		if t.onEscapePressed ~= nil then editBox:SetScript("OnEscapePressed", t.onEscapePressed) end
		editBox:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
		if t.onEvent ~= nil then for i = 0, #t.onEvent do editBox:HookScript(t.onEvent[i].event, t.onEvent[i].handler) end end
		--State & dependencies
		if t.readOnly or t.disabled then editBox:Disable() end
		if t.disabled and t.title ~= nil then t.title:SetFontObject("GameFontDisable") end
		if t.dependencies ~= nil then SetDependencies(t.dependencies, function(state)
			editBox:SetEnabled(state)
			t.title:SetFontObject(state and "GameFontNormal" or "GameFontDisable")
		end) end
		--Add to options data management
		if t.optionsData ~= nil or t.onSave ~= nil or t.onLoad ~= nil then
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(editBox, editBox:GetObjectType(), t.onSave, t.onLoad, t.optionsTable, t.optionsData)
		end
	end

	---Create an editbox frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the editbox
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: **t.label** if **t.title** == true or ""]
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **width** number — The height is defaulted to 17, the width may be specified [Default: 180]
	--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
	--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" [Default: "MIDDLE"]
	--- - **maxLetters**? number *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) [Default: 0 (*no limit*])
	--- - **fontObject**? FontString *optional*— Font template object to use [Default: *default font template based on the frame template*]
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox
	--- 	- **r** number ― Red [Range: 0 - 1]
	--- 	- **g** number ― Green [Range: 0 - 1]
	--- 	- **b** number ― Blue [Range: 0 - 1]
	--- 	- **a** number ― Opacity [Range: 0 - 1]
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **label** string — Name of the editbox to be shown as the tooltip title and optionally as the title text
	--- - **title**? boolean *optional* — Whether or not to add a title above the editbox [Default: true]
	--- - **tooltip**? string *optional* — Text to be shown as the tooltip of the editbox
	--- - **tooltipExtra**? table [indexed, 0-based] *optional* — Additional text lines to be added to the tooltip of the editbox
	--- 	- **text** string ― Text to be added to the line
	--- 	- **color**? table *optional* ― RGB colors line
	--- 		- **r** number ― Red [Range: 0 - 1]
	--- 		- **g** number ― Green [Range: 0 - 1]
	--- 		- **b** number ― Blue [Range: 0 - 1]
	--- 	- **wrap**? boolean *optional* ― Allow wrapping the line [Default: true]
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true [Default: false]
	--- - **onChar**? function *optional* — The function to be called when a character is entered. Can be used for excluding characters via pattern matching.
	--- - **onEnterPressed**? function *optional* — The function to be called when an [OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed) event happens
	--- - **onEscapePressed**? function *optional* — The function to be called when an [OnEscapePressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEscapePressed) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the editbox
	--- 	- **event** string — Event name
	--- 	- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	--- - **optionsTable**? table ― Reference to the table where all options data should be stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	--- - **optionsData**? table ― If set, add the editbox to the referenced options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **key** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* string ― The current value of the editbox
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the editbox
	--- 		- @*return* string ― The value to be set to the editbox
	--- - **onSave**? function *optional* — Function to be called when they okay button is pressed (after the data has been saved from the options widget to the storage table)
	--- 	- @*param* **self** Frame ― Reference to the widget
	--- - **onLoad**? function *optional* — Function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget)
	--- 	- @*param* **self** Frame ― Reference to the widget
	---@return EditBox editBox
	WidgetToolbox[ns.WidgetToolsVersion].CreateEditBox = function(t)
		local editBox = CreateFrame("EditBox", t.parent:GetName() .. (t.name or t.title ~= false and t.label:gsub("%s+", "") or "") .. "EditBox", t.parent, "InputBoxTemplate")
		--Position & dimensions
		local titleOffset = t.title ~= false and -18 or 0
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			editBox, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) + titleOffset
		)
		editBox:SetSize(t.width or 180, 17)
		--Title
		local title = nil
		if t.title ~= false then
			title = WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
				frame = editBox,
				title = {
					text = t.label,
					template = "GameFontNormal",
					offset = { x = -1, y = 18 }
				}
			})
		end
		--Set up the editbox
		SetEditBox(editBox, {
			multiline = false,
			justify = t.justify,
			maxLetters = t.maxLetters,
			fontObject = t.fontObject,
			color = t.color,
			text = t.text,
			title = title,
			readOnly = t.readOnly,
			onChar = t.onChar,
			onEnterPressed = t.onEnterPressed,
			onEscapePressed = t.onEscapePressed,
			onEvent = t.onEvent,
			disabled = t.disabled,
			dependencies = t.dependencies,
			optionsTable = t.optionsTable,
			optionsData = t.optionsData,
			onSave = t.onSave,
			onLoad = t.onLoad,
		})
		--Tooltip
		editBox:HookScript("OnEnter", function()
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, editBox, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra)
		end)
		editBox:HookScript("OnLeave", function() customTooltip:Hide() end)
		return editBox
	end

	---Create a scrollable editbox as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the editbox
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: **t.label** if **t.title** == true or ""]
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **size** table
	--- 	- **width** number
	--- 	- **height**? number *optional* — [Default: 17]
	--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
	--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" [Default: "MIDDLE"]
	--- - **maxLetters**? integer *optional* — The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) [Default: 0 (*no limit*)]
	--- - **charCount**? boolean — Show or hide the remaining number of characters [Default: (**t.maxLetters** or 0) > 0]
	--- - **fontObject**? FontString *optional*— Font template object to use [Default: *default font template based on the frame template*]
	--- - **color**? table *optional* — Apply the specified color to all text in the editbox
	--- 	- **r** number ― Red [Range: 0 - 1]
	--- 	- **g** number ― Green [Range: 0 - 1]
	--- 	- **b** number ― Blue [Range: 0 - 1]
	--- 	- **a** number ― Opacity [Range: 0 - 1]
	--- - **text**? string *optional* — Text to be shown inside editbox, loaded whenever the text box is shown
	--- - **label** string — Name of the editbox to be shown as the tooltip title and optionally as the title text
	--- - **title**? boolean *optional* — Whether or not to add a title above the editbox [Default: true]
	--- - **tooltip**? string *optional* — Text to be shown as the tooltip of the editbox
	--- - **tooltipExtra**? table [indexed, 0-based] *optional* — Additional text lines to be added to the tooltip of the editbox
	--- 	- **text** string ― Text to be added to the line
	--- 	- **color**? table *optional* ― RGB colors line
	--- 		- **r** number ― Red [Range: 0 - 1]
	--- 		- **g** number ― Green [Range: 0 - 1]
	--- 		- **b** number ― Blue [Range: 0 - 1]
	--- 	- **wrap**? boolean *optional* ― Allow wrapping the line [Default: true]
	--- - **scrollSpeed**? number *optional* — Scroll step value [Default: *half of the height of the scroll bar*]
	--- - **scrollToTop**? boolean *optional* — Automatically scroll to the top when the text is loaded or changed while not being actively edited [Default: true]
	--- - **readOnly**? boolean *optional* — The text will be uneditable if true [Default: false]
	--- - **onChar**? function *optional* — The function to be called when a character is entered. Can be used for excluding characters via pattern matching.
	--- - **onEnterPressed**? function *optional* — The function to be called when an [OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed) event happens
	--- - **onEscapePressed**? function *optional* — The function to be called when an [OnEscapePressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEscapePressed) event happens
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the editbox
	--- 	- **event** string — Event name
	--- 	- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	--- - **optionsTable**? table ― Reference to the table where all options data should be stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	--- - **optionsData**? table ― If set, add the editbox to the referenced options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **key** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* string ― The current value of the editbox
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the editbox
	--- 		- @*return* string ― The value to be set to the editbox
	--- - **onSave**? function *optional* — Function to be called when they okay button is pressed (after the data has been saved from the options widget to the storage table)
	--- 	- @*param* **self** Frame ― Reference to the widget
	--- - **onLoad**? function *optional* — Function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget)
	--- 	- @*param* **self** Frame ― Reference to the widget
	---@return EditBox
	---@return Frame scrollFrame
	WidgetToolbox[ns.WidgetToolsVersion].CreateEditScrollBox = function(t)
		local scrollFrame = CreateFrame("ScrollFrame", t.parent:GetName() .. (t.name or t.title ~= false and t.label:gsub("%s+", "") or "") .. "EditBox", t.parent, "InputScrollFrameTemplate")
		--Position & dimensions
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			scrollFrame, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) - 20
		)
		scrollFrame:SetSize(t.size.width, t.size.height)
		local function ResizeEditBox()
			local scrollBarOffset = _G[scrollFrame:GetName().."ScrollBar"]:IsShown() and 16 or 0
			local counterOffset = t.charCount ~= false and (t.maxLetters or 0) > 0 and tostring(t.maxLetters - scrollFrame.EditBox:GetText():len()):len() * 6 + 3 or 0
			scrollFrame.EditBox:SetWidth(scrollFrame:GetWidth() - scrollBarOffset - counterOffset)
		end
		ResizeEditBox()
		--Scroll speed
		if t.scrollSpeed ~= nil then _G[scrollFrame:GetName() .. "ScrollBar"].scrollStep = t.scrollSpeed end
		--Character counter
		scrollFrame.CharCount:SetFontObject("GameFontDisableTiny2")
		if t.charCount == false or (t.maxLetters or 0) == 0 then scrollFrame.CharCount:Hide() end
		--Title
		local title = nil
		if t.title ~= false then
			title = WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
				frame = scrollFrame,
				title = {
					text = t.label,
					template = "GameFontNormal",
					offset = { x = -1, y = 20 }
				}
			})
		end
		--Set up the EditBox
		SetEditBox(scrollFrame.EditBox, {
			multiline = true,
			justify = t.justify,
			maxLetters = t.maxLetters,
			fontObject = t.fontObject or "ChatFontNormal",
			color = t.color,
			text = t.text,
			title = title,
			readOnly = t.readOnly,
			onChar = t.onChar,
			onEnterPressed = t.onEnterPressed,
			onEscapePressed = t.onEscapePressed,
			onEvent = t.onEvent,
			disabled = t.disabled,
			dependencies = t.dependencies,
			optionsTable = t.optionsTable,
			optionsData = t.optionsData,
			onSave = t.onSave,
			onLoad = t.onLoad,
		})
		--Events & behavior
		t.scrollToTop = t.scrollToTop ~= false or nil
		scrollFrame.EditBox:HookScript("OnTextChanged", function()
			ResizeEditBox()
			if t.scrollToTop == true then scrollFrame:SetVerticalScroll(0) end
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
		scrollFrame.EditBox:HookScript("OnEnter", function()
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, scrollFrame, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra)
		end)
		scrollFrame.EditBox:HookScript("OnLeave", function() customTooltip:Hide() end)
		return scrollFrame.EditBox, scrollFrame
	end

	--[ CopyBox]

	---Create a clickable textline and an editbox from which the contents of the text can be copied
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the copybox
	--- - **name** string — String to be included in the unique frame name (it will not be visible)
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **width**? number *optional* — The height is defaulted to 17, the width may be specified [Default: 120]
	--- - **justify**? table *optional* — Set the justification of the [FontInstance](https://wowwiki-archive.fandom.com/wiki/Widget_API#FontInstance)
	--- 	- **h**? string *optional* — Horizontal: "LEFT"|"RIGHT"|"CENTER" [Default: "LEFT"]
	--- 	- **v**? string *optional* — Vertical: "TOP"|"BOTTOM"|"MIDDLE" [Default: "MIDDLE"]
	--- - **layer**? Layer *optional* ― Draw [Layer](https://wowpedia.fandom.com/wiki/Layer)
	--- - **template**? string *optional* ― Template to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) [Default: "GameFontNormal"]
	--- - **color**? table *optional* — Apply the specified color to the text
	--- 	- **r** number ― Red [Range: 0 - 1]
	--- 	- **g** number ― Green [Range: 0 - 1]
	--- 	- **b** number ― Blue [Range: 0 - 1]
	--- 	- **a** number ― Opacity [Range: 0 - 1]
	--- - **text** string ― The copyable text to be shown
	--- - **label**? string *optional* — Title text to be shown above the copybox [Default: *no title*]
	--- - **flipOnMouse**? boolean *optional* — Hide/Reveal the editbox on mouseover instead of after a click [Default: false]
	--- - **colorOnMouse**? table *optional* — If set, change the color of the text on mouseover to the specified color (if **t.flipOnMouse** is false) [Default: *no color change*]
	--- 	- **r** number ― Red [Range: 0 - 1]
	--- 	- **g** number ― Green [Range: 0 - 1]
	--- 	- **b** number ― Blue [Range: 0 - 1]
	--- 	- **a** number ― Opacity [Range: 0 - 1]
	---@return FontString textLine
	---@return EditBox copyBox
	WidgetToolbox[ns.WidgetToolsVersion].CreateCopyBox = function(t)
		local copyBox = CreateFrame("Button", t.parent:GetName() .. t.name .. "CopyBox", t.parent)
		--Position & dimensions
		local titleOffset = t.label ~= nil and -12 or 0
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			copyBox, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y + titleOffset
		)
		copyBox:SetSize(t.width or 180, 17)
		--Title
		if t.label ~= nil then
			WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
				frame = copyBox,
				title = {
					text = t.label,
					offset = { x = -1, y = 12 },
					width = t.width or 180,
				},
			})
		end
		--Displayed textline
		local textLine = WidgetToolbox[ns.WidgetToolsVersion].CreateText({
			frame = copyBox,
			name = t.name .. "Textline",
			position = { anchor = "LEFT", },
			width = t.width or 180,
			justify = (t.justify or {}).h or "LEFT",
			layer = t.layer,
			template = t.template,
			color = t.color,
			text = t.text,
		})
		--Copyable textline
		local text = t.text
		if t.color ~= nil then
			local r, g, b, a = WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(t.color)
			text = "|c" .. WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(r, g, b, a, true, false) .. t.text .. "|r"
		end
		local editBox = WidgetToolbox[ns.WidgetToolsVersion].CreateEditBox({
			parent = copyBox,
			name = t.name .. "CopyBox",
			position = { anchor = "LEFT", },
			width = t.width,
			justify = t.justify,
			fontObject = textLine:GetFontObject(),
			color = t.color,
			text = t.text,
			label = strings.copy.editbox.label,
			title = false,
			tooltip = strings.copy.editbox.tooltip,
			onEvent = {
				[0] = {
					event = "OnTextChanged",
					handler = function(self)
						self:SetText(text)
						self:HighlightText()
					end
				},
				[1] = {
					event = t.flipOnMouse == true and "OnLeave" or "OnEditFocusLost",
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
		copyBox:SetScript(t.flipOnMouse == true and "OnEnter" or "OnClick", function()
			textLine:Hide()
			editBox:Show()
			editBox:SetFocus()
			editBox:HighlightText()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end)
		if t.flipOnMouse ~= true and t.colorOnMouse ~= nil then
			copyBox:SetScript("OnEnter", function() textLine:SetTextColor(WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(t.colorOnMouse)) end)
			copyBox:SetScript("OnLeave", function() textLine:SetTextColor(WidgetToolbox[ns.WidgetToolsVersion].UnpackColor(t.color)) end)
		end
		--Tooltip
		copyBox:HookScript("OnEnter", function()
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, copyBox, "ANCHOR_RIGHT", strings.copy.textline.label, strings.copy.textline.tooltip)
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
		local decimals = value.fractional ~= nil and value.fractional or max(
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
			if value.step ~= nil then v = max(value.min, min(value.max, floor(v * (1 / value.step) + 0.5) / (1 / value.step))) end
			self:SetText(tostring(v):gsub(matchPattern, replacePattern))
			slider:SetAttribute("ValueBoxChange", v)
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
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, valueBox, "ANCHOR_RIGHT", strings.value.label, strings.value.tooltip)
		end)
		valueBox:HookScript("OnLeave", function() customTooltip:Hide() end)
		return valueBox
	end

	---Create a new slider frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new slider
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: **t.label**]
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? Frame *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **width**? number *optional*
	--- - **label** string — Title text to be shown above the slider and as the the tooltip label
	--- - **tooltip**? string *optional* — Text to be shown as the tooltip of the slider
	--- - **tooltipExtra**? table [indexed, 0-based] *optional* — Additional text lines to be added to the tooltip of the slider
	--- 	- **text** string ― Text to be added to the line
	--- 	- **color**? table *optional* ― RGB colors line
	--- 		- **r** number ― Red [Range: 0 - 1]
	--- 		- **g** number ― Green [Range: 0 - 1]
	--- 		- **b** number ― Blue [Range: 0 - 1]
	--- 	- **wrap**? boolean *optional* ― Allow wrapping the line [Default: true]
	--- - **value** table
	--- 	- **min** number — Lower numeric value limit
	--- 	- **max** number — Upper numeric value limit
	--- 	- **step**? number *optional* — Size of value increments [Default: *the value can be freely changed (within range, no set increments)*]
	--- 	- **fractional**? integer *optional* — If the value is fractional, allow and display this many decimal digits [Default: *the most amount of digits present in the fractional part of* **t.value.min**, **t.value.max** *or* **t.value.step**]
	--- - **valueBox**? boolean *optional* — Set to false when the frame type should NOT have an [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) added as a child frame
	--- - **onValueChanged** function — The function to be called when an [OnValueChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnValueChanged) event happens
	--- 	- @*param* **self** Frame ― Reference to the widget
	--- 	- @*param* **value** number ― The new value of the slider
	--- 	- @*param* **user** boolean ― True if the value was changed by the user, false if it was done programmatically
	--- - **onEvent**? table [indexed, 0-based] *optional* — Table that holds additional event handler scripts to be set for the slider
	--- 	- **event** string — Event name
	--- 	- **handler** function — The handler function to be called when the named event happens
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	--- - **optionsTable**? table ― Reference to the table where all options data should be stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	--- - **optionsData**? table ― If set, add the slider to the referenced options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **key** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* number ― The current value of the slider
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the slider
	--- 		- @*return* number ― The value to be set to the slider
	--- - **onSave**? function *optional* — Function to be called when they okay button is pressed (after the data has been saved from the options widget to the storage table)
	--- 	- @*param* **self** Frame ― Reference to the widget
	--- - **onLoad**? function *optional* — Function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget)
	--- 	- @*param* **self** Frame ― Reference to the widget
	---@return Slider slider
	---@return EditBox? valueBox
	WidgetToolbox[ns.WidgetToolsVersion].CreateSlider = function(t)
		local slider = CreateFrame("Slider", t.parent:GetName() .. (t.name or t.label:gsub("%s+", "")) .. "Slider", t.parent, "OptionsSliderTemplate")
		--Position
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			slider, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) - 12
		)
		if t.width ~= nil then slider:SetWidth(t.width) end
		--Font
		getglobal(slider:GetName() .. "Text"):SetFontObject("GameFontNormal")
		getglobal(slider:GetName() .. "Text"):SetText(t.label)
		getglobal(slider:GetName() .. "Low"):SetText(tostring(t.value.min))
		getglobal(slider:GetName() .. "High"):SetText(tostring(t.value.max))
		--Value
		slider:SetMinMaxValues(t.value.min, t.value.max)
		if t.value.step ~= nil then
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
		if t.onEvent ~= nil then for i = 0, #t.onEvent do slider:HookScript(t.onEvent[i].event, t.onEvent[i].handler) end end
		--Tooltip
		slider:HookScript("OnEnter", function()
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, slider, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra)
		end)
		slider:HookScript("OnLeave", function() customTooltip:Hide() end)
		--Value box
		if t.valueBox == false then return slider end
		local valueBox = AddSliderValueBox(slider, t.value)
		--State & dependencies
		if t.disabled then
			slider:Disable()
			valueBox:Disable()
			getglobal(slider:GetName() .. "Text"):SetFontObject("GameFontDisable")
			valueBox:SetFontObject("GameFontDisableSmall")
		end
		if t.dependencies ~= nil then SetDependencies(t.dependencies, function(state)
			slider:SetEnabled(state)
			valueBox:SetEnabled(state)
			getglobal(slider:GetName() .. "Text"):SetFontObject(state and "GameFontNormal" or "GameFontDisable")
			valueBox:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall")
		end) end
		--Add to options data management
		if t.optionsData ~= nil or t.onSave ~= nil or t.onLoad ~= nil then
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(slider, slider:GetObjectType(), t.onSave, t.onLoad, t.optionsTable, t.optionsData)
		end
		return slider, valueBox
	end

	--[ Dropdown Menu ]

	---Create a dropdown frame as a child of a container frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new dropdown
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: **t.label** if **t.title** == true or ""]
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? Frame *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **width**? number *optional* — [Default: 115]
	--- - **label** string — Name of the dropdown shown as the tooltip title and optionally as the title text
	--- - **title**? boolean *optional* — Whether or not to add a title above the dropdown menu [Default: true]
	--- - **tooltip**? string *optional* — Text to be shown as the tooltip of the dropdown
	--- - **tooltipExtra**? table [indexed, 0-based] *optional* — Additional text lines to be added to the tooltip of the dropdown
	--- 	- **text** string ― Text to be added to the line
	--- 	- **color**? table *optional* ― RGB colors line
	--- 		- **r** number ― Red [Range: 0 - 1]
	--- 		- **g** number ― Green [Range: 0 - 1]
	--- 		- **b** number ― Blue [Range: 0 - 1]
	--- 	- **wrap**? boolean *optional* ― Allow wrapping the line [Default: true]
	--- - **items** table [indexed, 0-based] — Table containing the dropdown items described within subtables
	--- 	- **text** string — Text to represent the items within the dropdown frame
	--- 	- **onSelect** function — The function to be called when the dropdown item is selected
	--- - **selected?** integer *optional* — The default selected item of the dropdown menu
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	--- - **optionsTable**? table ― Reference to the table where all options data should be stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	--- - **optionsData**? table ― If set, add the dropdown to the referenced options data table to save & load its value automatically to & from the specified storageTable (also set its text to the name of the currently selected value automatically on load)
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **key** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* integer ― The index of the currently selected item in the dropdown menu
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any ― The data in the storage table to be converted and loaded to the dropdown menu
	--- 		- @*return* integer ― The index of the item to be set as selected in the dropdown menu
	--- - **onSave**? function *optional* — Function to be called when they okay button is pressed (after the data has been saved from the options widget to the storage table)
	--- 	- @*param* **self** Frame ― Reference to the widget
	--- - **onLoad**? function *optional* — Function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget; the name of the currently selected item based on the value loaded will be set on load whether the onLoad function is specified or not)
	--- 	- @*param* **self** Frame ― Reference to the widget
	---@return Frame dropdown
	WidgetToolbox[ns.WidgetToolsVersion].CreateDropdown = function(t)
		local dropdown = CreateFrame("Frame", t.parent:GetName() .. (t.name or t.title ~= false and t.label:gsub("%s+", "") or "") .. "Dropdown", t.parent, "UIDropDownMenuTemplate")
		--Position & dimensions
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			dropdown, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, ((t.position.offset or {}).y or 0) - 16
		)
		UIDropDownMenu_SetWidth(dropdown, t.width or 115)
		--Title
		local title = nil
		if t.title ~= false then
			title = WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
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
		--Tooltip
		dropdown:HookScript("OnEnter", function()
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, dropdown, "ANCHOR_RIGHT", t.label, t.tooltip, t.tooltipExtra)
		end)
		dropdown:HookScript("OnLeave", function() customTooltip:Hide() end)
		--State & dependencies
		if t.disabled then
			UIDropDownMenu_DisableDropDown(dropdown)
			if title ~= nil then title:SetFontObject("GameFontDisable") end
		end
		if t.dependencies ~= nil then SetDependencies(t.dependencies, function(state)
			if state then UIDropDownMenu_EnableDropDown(dropdown) else UIDropDownMenu_DisableDropDown(dropdown) end
			if title ~= nil then title:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
		end) end
		--Add to options data management
		if t.optionsData ~= nil or t.onSave ~= nil or t.onLoad ~= nil then
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(dropdown, "Dropdown", t.onSave, function(self)
				if UIDropDownMenu_GetSelectedValue(dropdown) ~= nil then UIDropDownMenu_SetText(dropdown, t.items[UIDropDownMenu_GetSelectedValue(dropdown)].text) end
				if t.onLoad ~= nil then t.onLoad(self) end
			end, t.optionsTable, t.optionsData)
		end
		return dropdown
	end

	--[ Context Menu ]

	---Create a context menu frame as a child of a frame
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new context menu
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: ""]
	--- - **anchor** string|[AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) [Default: 'cursor']
	--- - **offset**? table *optional*
	--- 	- **x** number [Default: 0]
	--- 	- **y** number [Default: 0]
	--- - **width**? number *optional* — [Default: 115]
	--- - **menu** table — Table of subtables containing the menu items and their attributes (examples below)
	--- 	- **text** string — Text to be displayed on the button within the context menu
	--- 	- **isTitle**? boolean *optional* — Set the item as a title instead of a clickable button [Default: false (*not title*)]
	--- 	- **disabled**? number *optional* — Disable the button if set to 1 [Range: nil, 1; Default: nil or 1 if **t.isTitle** == true]
	--- 	- **checked**? boolean *optional* — Whether the button is currently checked or not [Default: false (*not checked*)]
	--- 	- **notCheckable**? number *optional* — Make the item a simple button instead of a checkbox if set to 1 [Range: nil, 1; Default: nil]
	--- 	- **func** function — The function to be called the button is clicked
	--- 	- **hasArrow** boolean — Show the arrow to open the submenu specified in t.menuList
	--- 	- **menuList** table — A table of subtables containing submenu items
	--- 	- ***[Attribute list](https://www.townlong-yak.com/framexml/5.4.7/UIDropDownMenu.lua#139)*** — See the full list of attributes that can be set for context menu items
	---@return Frame contextMenu
	WidgetToolbox[ns.WidgetToolsVersion].CreateContextMenu = function(t)
		local contextMenu = CreateFrame("Frame", t.parent:GetName() .. (t.name or "") .. "ContextMenu", t.parent, "UIDropDownMenuTemplate")
		--Dimensions
		UIDropDownMenu_SetWidth(contextMenu, t.width or 115)
		--Right-click event
		t.parent:HookScript("OnMouseUp", function(self, button, isInside)
			if button == "RightButton" and isInside then
				EasyMenu(t.menu, contextMenu, t.anchor or "cursor", (t.offset or {}).x or 0, (t.offset or {}).y or 0, "MENU")
			end
		end)
		return contextMenu
	end

	--[ Color Picker ]

	--Addon-scope data bust be used to stop the separate color pickers from interfering with each other through the global Blizzard Color Picker frame
	local colorPickerData = {}

	---Set up and open the built-in Color Picker frame
	---
	---Using **colorPickerData** table, it must be set before call:
	--- - **activeColorPicker** Button
	--- - **startColors** table ― Color values are to be provided in this table
	--- 	- **r** number ― Red [Range: 0 - 1]
	--- 	- **g** number ― Green [Range: 0 - 1]
	--- 	- **b** number ― Blue [Range: 0 - 1]
	--- 	- **a**? number *optional* ― Opacity [Range: 0 - 1, Default: 1]
	--- - **onColorUpdate** function
	--- 	- @*param* **r** number ― Red [Range: 0 - 1]
	--- 	- @*param* **g** number ― Green [Range: 0 - 1]
	--- 	- @*param* **b** number ― Blue [Range: 0 - 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0 - 1, Default: 1]
	--- - **onCancel** function
	--- 	- @*param* **r** number ― Red [Range: 0 - 1]
	--- 	- @*param* **g** number ― Green [Range: 0 - 1]
	--- 	- @*param* **b** number ― Blue [Range: 0 - 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0 - 1, Default: 1]
	local function OpenColorPicker()
		--Color picker button background update function
		local function ColorUpdate()
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = OpacitySliderFrame:GetValue() or 1
			colorPickerData.activeColorPicker:SetBackdropColor(r, g, b, a)
			colorPickerData.backgroundGradient:SetVertexColor(r, g, b, 1)
			_G[colorPickerData.activeColorPicker:GetName():gsub("Button", "EditBox")]:SetText(WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(r, g, b, a))
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
			_G[colorPickerData.activeColorPicker:GetName():gsub("Button", "EditBox")]:SetText(WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(
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
	--- 	- @*return* **r** number ― Red [Range: 0 - 1]
	--- 	- @*return* **g** number ― Green [Range: 0 - 1]
	--- 	- @*return* **b** number ― Blue [Range: 0 - 1]
	--- 	- @*return* **a**? number *optional* ― Opacity [Range: 0 - 1]
	--- - **onColorUpdate** function — The function to be called when the color is changed
	--- 	- @*param* **r** number ― Red [Range: 0 - 1]
	--- 	- @*param* **g** number ― Green [Range: 0 - 1]
	--- 	- @*param* **b** number ― Blue [Range: 0 - 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0 - 1, Default: 1]
	--- - **onCancel** function — The function to be called when the color change is cancelled
	--- 	- @*param* **r** number ― Red [Range: 0 - 1]
	--- 	- @*param* **g** number ― Green [Range: 0 - 1]
	--- 	- @*param* **b** number ― Blue [Range: 0 - 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0 - 1, Default: 1]
	---@return Button pickerButton The color picker button frame
	---@return Texture backgroundGradient The gradient color background texture
	local function AddColorPickerButton(colorPicker, t)
		local pickerButton = CreateFrame("Button", colorPicker:GetName() .. "Button", colorPicker, BackdropTemplateMixin and "BackdropTemplate")
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
			path = textures.gradientBG,
			position = {
				anchor = "TOPLEFT",
				offset = { x = 2.5, y = -2.5 }
			},
			size = { width = 14, height = 17 }
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
			if a ~= nil then
				tooltip = strings.color.picker.tooltip:gsub("#ALPHA", strings.color.picker.alpha)
			else
				tooltip = strings.color.picker.tooltip:gsub("#ALPHA", "")
			end
			WidgetToolbox[ns.WidgetToolsVersion].AddTooltip(nil, pickerButton, "ANCHOR_TOPLEFT", strings.color.picker.label, tooltip, nil, 20)
		end)
		pickerButton:HookScript("OnLeave", function() customTooltip:Hide() end)
		return pickerButton, backgroundGradient
	end

	---Set up the built-in Color Picker and create a button as a child of a container frame to open it
	---@param t table Parameters are to be provided in this table
	--- - **parent** Frame — The frame to set as the parent of the new color picker button
	--- - **name**? string *optional* — String to be included in the unique frame name (it will not be visible) [Default: **t.label**]
	--- - **position** table — Collection of parameters to call [Region:SetPoint()](https://wowwiki-archive.fandom.com/wiki/API_Region_SetPoint#Arguments) with
	--- 	- **anchor** [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides)
	--- 	- **relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) *optional*
	--- 	- **relativePoint**? [AnchorPoint](https://wowwiki-archive.fandom.com/wiki/Widget_Anchor_Points#All_sides) *optional*
	--- 	- **offset**? table *optional*
	--- 		- **x** number
	--- 		- **y** number
	--- - **width**? number *optional* ― The height is defaulted to 36, the width may be specified [Default: 120]
	--- - **label** string — Title text to be shown above the color picker button and HEX input box
	--- - **setColors** function — The function to be called to set the colors of the color picker on load or update
	--- 	- @*return* **r** number ― Red [Range: 0 - 1]
	--- 	- @*return* **g** number ― Green [Range: 0 - 1]
	--- 	- @*return* **b** number ― Blue [Range: 0 - 1]
	--- 	- @*return* **a**? number *optional* ― Opacity [Range: 0 - 1, Default: 1]
	--- - **onColorUpdate** function — The function to be called when the color is changed
	--- 	- @*param* **r** number ― Red [Range: 0 - 1]
	--- 	- @*param* **g** number ― Green [Range: 0 - 1]
	--- 	- @*param* **b** number ― Blue [Range: 0 - 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0 - 1, Default: 1]
	--- - **onCancel** function — The function to be called when the color change is cancelled
	--- 	- @*param* **r** number ― Red [Range: 0 - 1]
	--- 	- @*param* **g** number ― Green [Range: 0 - 1]
	--- 	- @*param* **b** number ― Blue [Range: 0 - 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0 - 1, Default: 1]
	--- - **disabled**? boolean *optional* — Set the state of this widget to be disabled on load [Default: false]
	--- - **dependencies**? table [indexed, 0-based] *optional* — Automatically disable or enable this widget based on the rules described in subtables
	--- 	- **frame** Frame — Tie the state of this widget to the evaluation of this frame's value
	--- 	- **evaluate**? function *optional* — Call this function to evaluate the current value of **rules.frame** [Default: *no evaluation, only for checkboxes*]
	--- 		- @*param* **value**? any *optional* — The current value of **rules.frame**, its variable type depends on the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** (see overloads)
	--- 		- @*return* **evaluation** boolean — If false, disable the dependent widget (and enable it when true)
	--- 		- ***Overloads:***
	--- 			- function(**value**: boolean) -> **evaluation**: boolean — If **rules.frame** is recognized as a checkbox
	--- 			- function(**value**: number) -> **evaluation**: boolean — If **rules.frame** is recognized as a slider
	--- 			- function(**value**: integer) -> **evaluation**: boolean — If **rules.frame** is recognized as a dropdown or selector
	--- 			- function(**value**: nil) -> **evaluation**: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*
	--- 		- ***Note:*** **rules.evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) of **rules.frame** is not "CheckButton".
	--- - **optionsTable**? table ― Reference to the table where all options data should be stored in [Default: **WidgetToolbox[ns.WidgetToolsVersion].OptionsData** *(the data of all addons is stored collectively)*]
	--- - **optionsData**? table ― If set, add the color picker to the referenced options data table to save & load its value automatically to & from the specified storageTable
	--- 	- **storageTable** table ― Reference to the table containing the value modified by the options widget
	--- 	- **key** string ― Key of the variable inside the storage table
	--- 	- **convertSave**? function *optional* — Function to convert or modify the data while it is being saved from the widget to the storage table
	--- 		- @*param* **r** number ― Red [Range: 0 - 1]
	--- 		- @*param* **g** number ― Green [Range: 0 - 1]
	--- 		- @*param* **b** number ― Blue [Range: 0 - 1]
	--- 		- @*param* **a**? number ― Opacity [Range: 0 - 1]
	--- 		- @*return* any ― The converted data to be saved to the storage table
	--- 	- **convertLoad**? function *optional* — Function to convert or modify the data while it is being loaded from the storage table to the widget as its value
	--- 		- @*param* any *(any number of arguments)* ― The data in the storage table to be converted
	--- 		- @*return* **r** number ― Red [Range: 0 - 1]
	--- 		- @*return* **g** number ― Green [Range: 0 - 1]
	--- 		- @*return* **b** number ― Blue [Range: 0 - 1]
	--- 		- @*return* **a**? number ― Opacity [Range: 0 - 1]
	--- - **onSave**? function *optional* — Function to be called when they okay button is pressed (after the data has been saved from the options widget to the storage table)
	--- 	- @*param* **self** Frame ― Reference to the widget
	--- - **onLoad**? function *optional* — Function to be called when an options category is refreshed (after the data has been restored from the storage table to the widget)
	--- 	- @*param* **self** Frame ― Reference to the widget
	---@return table colorPicker A table containing component frame references and color getter & setter functions
	--- - **frame** Frame ― Reference to the color picker parent frame
	--- - **getObjectType** function ― Returns the object type of this unique frame
	--- 	- @*return* "ColorPicker" UniqueFrameType
	--- - **isObjectType** function ― Checks and returns if the type of this unique frame is equal to the string provided
	--- 	- @*param* **type** string
	--- 	- @*return* boolean
	--- - **getColor** function ― Returns the currently set color values
	--- 	- @*return* **r** number ― Red [Range: 0 - 1]
	--- 	- @*return* **g** number ― Green [Range: 0 - 1]
	--- 	- @*return* **b** number ― Blue [Range: 0 - 1]
	--- 	- @*return* **a**? number ― Opacity [Range: 0 - 1]
	--- - **setColor** function ― Sets the color and text of each element
	--- 	- @*param* **r** number ― Red [Range: 0 - 1]
	--- 	- @*param* **g** number ― Green [Range: 0 - 1]
	--- 	- @*param* **b** number ― Blue [Range: 0 - 1]
	--- 	- @*param* **a**? number *optional* ― Opacity [Range: 0 - 1, Default: 1]
	WidgetToolbox[ns.WidgetToolsVersion].CreateColorPicker = function(t)
		local pickerFrame = CreateFrame("Frame", t.parent:GetName() .. (t.name or t.label:gsub("%s+", "")) .. "ColorPicker", t.parent)
		--Position & dimensions
		WidgetToolbox[ns.WidgetToolsVersion].PositionFrame(
			pickerFrame, t.position.anchor, t.position.relativeTo, t.position.relativePoint, (t.position.offset or {}).x, (t.position.offset or {}).y
		)
		local frameWidth = (t.size or {}).width or 120
		pickerFrame:SetSize(frameWidth, 36)
		--Title
		local title = WidgetToolbox[ns.WidgetToolsVersion].AddTitle({
			frame = pickerFrame,
			title = {
				text = t.label,
				template = "GameFontNormal",
				offset = { x = 4, y = 0 }
			}
		})
		--Add color picker button to open the Blizzard Color Picker
		local pickerButton, backgroundGradient = AddColorPickerButton(pickerFrame, {
			setColors = t.setColors,
			onColorUpdate = t.onColorUpdate,
			onCancel = t.onCancel
		})
		--Add editbox to change the color via HEX code
		local _, _, _, alpha = t.setColors()
		local hexBox = WidgetToolbox[ns.WidgetToolsVersion].CreateEditBox({
			parent = pickerFrame,
			position = {
				anchor = "TOPLEFT",
				offset = { x = 44, y = -18 }
			},
			width = frameWidth - 44,
			maxLetters = 7 + (alpha ~= nil and 2 or 0),
			fontObject = "GameFontWhiteSmall",
			label = strings.color.hex.label,
			title = false,
			tooltip = strings.color.hex.tooltip .. "\n\n" .. strings.misc.example .. ": #2266BB" .. (alpha ~= nil and "AA" or ""),
			onChar = function(self) self:SetText(self:GetText():gsub("^(#?)([%x]*).*", "%1%2")) end,
			onEnterPressed = function(self)
				local r, g, b, a = WidgetToolbox[ns.WidgetToolsVersion].HexToColor(self:GetText())
				pickerButton:SetBackdropColor(r, g, b, a or 1)
				backgroundGradient:SetVertexColor(r, g, b, 1)
				t.onColorUpdate(r, g, b, a or 1)
				self:SetText(self:GetText():upper())
			end,
			onEscapePressed = function(self) self:SetText(WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(pickerButton:GetBackdropColor())) end
		})
		--State & dependencies
		if t.disabled then
			title:SetFontObject("GameFontDisable")
			pickerButton:Disable()
			hexBox:Disable()
			hexBox:SetFontObject("GameFontDisableSmall")
		end
		if t.dependencies ~= nil then SetDependencies(t.dependencies, function(state)
			title:SetFontObject(state and "GameFontNormal" or "GameFontDisable")
			pickerButton:SetEnabled(state)
			hexBox:SetEnabled(state)
			hexBox:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall")
		end) end
		--Assemble the color widget table
		local colorPicker = {
			frame = pickerFrame,
			getObjectType = function() return "ColorPicker" end,
			isObjectType = function(type) return type == "ColorPicker" end,
			getColor = function() return pickerButton:GetBackdropColor() end,
			setColor = function(r, g, b, a)
				pickerButton:SetBackdropColor(r, g, b, a or 1)
				backgroundGradient:SetVertexColor(r, g, b, 1)
				hexBox:SetText(WidgetToolbox[ns.WidgetToolsVersion].ColorToHex(r, g, b, a))
			end,
		}
		--Add to options data management
		if t.optionsData ~= nil or t.onSave ~= nil or t.onLoad ~= nil then
			WidgetToolbox[ns.WidgetToolsVersion].AddOptionsData(colorPicker, colorPicker.getObjectType(), t.onSave, t.onLoad, t.optionsTable, t.optionsData)
		end
		return colorPicker
	end
end