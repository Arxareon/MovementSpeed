--NOTE: Annotations are for development purposes only, providing documentation for use with LUA Language Server. This file does not need to be loaded by the game client.


--[[ REFERENCES ]]

--[ Namespace ]

---Addon namespace table
---@class addonNamespace
local ns = select(2, ...)


--[[ CLASSES ]]

---Global read-only Widget Tools table
---@class widgetTools
widgetTools = {


	--[[ RESOURCES ]]

	---Shared resources
	---@class widgetToolsResources
	---@field addon string Addon namespace name: `"WidgetTools"`
	---@field title string Addon display title: `"Widget Tools"`
	---@field root string Addon root folder path
	---@field chat table List of chat keywords and commands
	---@field changelog table
	---@field strings WidgetToolsStrings Localized strings
	---@field colors table
	---@field textures table
	---@field fonts table
	resources = {},


	--[[ UTILITIES ]]

	---Core utility collection
	---@class widgetToolsUtilities
	utilities = {
		SortedPairs = SortedPairs,
		Round = Round,
		IsFrame = IsFrame,
		ToFrame = ToFrame,
		Thousands = Thousands,
		ToString = ToString,
		TableToString = TableToString,
		Protect = Protect,
		GetID = GetID,
		FindIndex = FindIndex,
		FindKey = FindKey,
		FindValue = FindValue,
		Clone = Clone,
		Merge = Merge,
		CopyValues = CopyValues,
		Fill = Fill,
		Pull = Pull,
		VerifyData = VerifyData,
		Prune = Prune,
		Filter = Filter,

		---Access a Blizzard modifier key down checking function via a modifier key string
		---@type table<ModifierKey|any, fun(): down: boolean>
		isKeyDown = {},
	},

	---Debugging tools
	---@class widgetToolsDebugging
	debugging = {
		Log = Log,
		Dump = Dump,
	},

	---Toolbox registration
	---@class widgetToolsToolboxes
	toolboxes = {
		Register = Register,

		---@type table<string, widgetToolbox|table> List of temporary toolbox initialization tables under version keys where a toolbox can assembled to be registered once the addon requesting it finishes loading
		initialization = {},
	},
}


--[[ TYPES ]]

---@class widgetToolboxEntry
---@field toolbox widgetToolbox|table Read-only proxy reference to the registered toolbox table
---@field addons string[] List of addons registered for using this toolbox (represented by their namespace names)


---@class widgetToolsResources
widgetTools.utilities = {}


--[[ FUNCTIONS ]]

--| SortedPairs

---Table to be sorted (in an ascending order and/or alphabetically, based on the `<` operator)
---@alias SortedPairs_param # t
---| table 

---Get the sorted key, value pairs of a table ([Documentation: Sort](https://www.lua.org/pil/19.3.html))
---***
---@param t SortedPairs_param Table to be sorted (in an ascending order and/or alphabetically, based on the `<` operator)
---***
---@return function iterator Function returning the key, value pairs of the table in order
function SortedPairs(t) return function() end end

--| Round

---A fractional number value to round | ***Default:*** `0`
---@alias Round_param1 # number
---| number

---Specify the number of decimal places to round the number to | ***Default:*** `0`
---@alias Round_param2 # decimals
---| integer

---Round a decimal fraction to the specified number of digits
---***
---@param number? Round_param1 A fractional number value to round | ***Default:*** `0`
---@param decimals? Round_param2 Specify the number of decimal places to round the number to | ***Default:*** `0`
---@return number
function Round(number, decimals) return 0 end

--| IsFrame

---Check if a variable is a frame (or a backdrop object)
---@param t Frame|any
---***
---@return boolean|string # If `t` is recognized as a [`FrameScriptObject`](https://warcraft.wiki.gg/wiki/UIOBJECT_FrameScriptObject), return `true`, or, return the frame name if named or the debug name if unnamed but recognized as a UI [Object](https://warcraft.wiki.gg/wiki/UIOBJECT_Object) with a parent, otherwise, return false
function IsFrame(t) return false end

--| ToFrame

---Name of the frame to find (and the key of its child region appended to it after a period character)
---@alias ToFrame_param # s
---| string

---Find a frame or region by its name (or a subregion if a key is included in the input string) and get a reference to it if it exists
---***
---@param s ToFrame_param Name of the frame to find (and the key of its child region appended to it after a period character)
---***
---@return AnyFrameObject|nil frame Reference to the object | ***Default:*** `nil`
function ToFrame(s) end

--| Thousands

---Number value to turn into a string with thousand separation
---@alias Thousands_param1 # value
---| number

---Specify the number of decimal places to display if the number is a fractional value | ***Default:*** `0`
---@alias Thousands_param2 # decimals
---| number

---Round the number value to the specified number of decimal places | ***Default:*** `true`
---@alias Thousands_param3 # round
---| boolean

---Trim trailing zeros in decimal places | ***Default:*** `true`
---@alias Thousands_param4 # trim
---| boolean

---Format a number string with thousands separation and optional value rounding
---***
---@param value Thousands_param1 Number value to turn into a string with thousand separation
---@param decimals? Thousands_param2 Specify the number of decimal places to display if the number is a fractional value | ***Default:*** `0`
---@param round? Thousands_param3 Round the number value to the specified number of decimal places | ***Default:*** `true`
---@param trim? Thousands_param4 Trim trailing zeros in decimal places | ***Default:*** `true`
---***
---@return string # ***Default:*** `""`
function Thousands(value, decimals, round, trim) return "" end

--| ToString

---Object to convert to a formatted text
---@alias ToString_param # object
---| any

---Convert the object to an appropriately formatted and colored string based on its type
---***
---@param object ToString_param Object to convert to a formatted text
---***
---@return string s Formatted output string
---@return "Frame"|"FrameScriptObject"|"table"|"boolean"|"number"|"string"|"any" t Recognized object type
---<hr><p></p>
function ToString(object) return "", "any" end

--| TableToString

---Reference to the table to convert
---@alias TableToString_param1 # table
---| table

---Whether spaces and indentations should be trimmed or not | ***Default:*** `false`
---@alias TableToString_param2 # compact
---| boolean

---Convert a table into a formatted and colored string (appearing as a functional LUA code chunk but including coloring escape sequences)
--- - ***Example:*** Turning back into a loadable code chunk to then be useable as a table:
--- 	```
--- 	local success, loadedTable = pcall(loadstring("return " .. ns.ut.Clear(tableAsString)))
--- 	```
---***
---@param table TableToString_param1 Reference to the table to convert
---@param compact? TableToString_param2 Whether spaces and indentations should be trimmed or not | ***Default:*** `false`
---***
---@return string # ***Default:*** `(WidgetTools.utilities.ToString(table))`
function TableToString(table, compact) return "" end

--| Protect

---Reference to the table to create the proxy for
---@alias Protect_param # t
---| any

---Shield a table by creating a deep proxy through which value access will be read-only via a protective metatable ruleset
--- - ***Note:*** The protection will "infect" any and all subtables when they are indexed through a proxy, meaning the read-only protection will be extended at any depth, including new subtables added to the original table structure of `t` after it was protected.
--- - ***Note:*** Tables for which `getmetatable(t)` returns "public" or "protected", will not be wrapped behind a new proxy.
---   - ***Example:*** Use `setmetatable(t, { __metatable = "public" })` to whitelist any table from getting read-only protection.
---***
---@param t Protect_param Reference to the table to create the proxy for
---***
---@return any # Reference to the new proxy table or `t` itself
function Protect(t) end

--| GetID

---Reference to the table to get the ID of
---@alias GetID_param # t
---| table

---Get the unique internal runtime ID of the table
---***
---@param t GetID_param Reference to the table to get the ID of
---@return string # Return empty string of t is not a table | ***Default:*** `""`
function GetID(t) return "" end

--| FindIndex

---Array to search
---@alias FindIndex_param1 # array
---| any[]

---The value to find
---@alias FindIndex_param2 # value
---| any

---Find the index of the first matching value in the array provided while also checking subtable branches via a deep search if no match was found at the first level
---***
---@param array FindIndex_param1 Array to search
---@param value FindIndex_param2 The value to find
---@return integer|nil index ***Default:*** `nil`
function FindIndex(array, value) end

--| FindKey

---Reference to the table to find a value at a certain key in
---@alias FindKey_param1 # t
---| table

---Value to look for in `t` (including all subtables, recursively)
---@alias FindKey_param2 # value
---| any

---Find the first matching value and return its key via a deep search
---***
---@param t FindKey_param1 Reference to the table to find a value at a certain key in
---@param value FindKey_param2 Value to look for in `t` (including all subtables, recursively)
---***
---@return any|nil match The first match of the key `value` was found paired to | ***Default:*** `nil`
function FindKey(t, value) end

--| FindValue

---Reference to the table to find a value at a certain key in
---@alias FindValue_param1 # t
---| table

---Key to look for in `t` (including all subtables, recursively)
---@alias FindValue_param2 # key
---| any

---Find and return the value at the first matching key via a deep search
---***
---@param t FindValue_param1 Reference to the table to find a value at a certain key in
---@param key FindValue_param2 Key to look for in `t` (including all subtables, recursively)
---***
---@return any|nil match The first match of the value found at `key` | ***Default:*** `nil`
function FindValue(t, key) end

--| Clone

---Reference to the object to create a copy of
---@alias Clone_param # object
---| any

---Make a new deep copy of a non-frame table
---***
---@param object Clone_param Reference to the object to create a copy of
---***
---@return any copy Returns `object` itself if it's a frame or not a table
function Clone(object) end

--| Merge

---Table to add the values to
---@alias Merge_param1 # target
---| table

---Table to copy all values from
---@alias Merge_param2 # source
---| table

---Merge a table to another table, deep copying all its values over under new integer keys
---***
---@param target Merge_param1 Table to add the values to
---@param source Merge_param2 Table to copy all values from
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function Merge(target, source) end

--| CopyValues

---Reference to the table to copy the values to
---@alias CopyValues_param1 # target
---| table

---Reference to the table to copy the values from
---@alias CopyValues_param2 # source
---| table

---Copy all values at matching keys from a sample table to another table while preserving all table references
---***
---@param target CopyValues_param1 Reference to the table to copy the values to
---@param source CopyValues_param2 Reference to the table to copy the values from
---***
---@return any target Reference to `target` (the values were already overwritten during the operation, no need to set it again)
function CopyValues(target, source) end

--| Fill

---Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already `"table"`)
---@alias Fill_param1 # target
---| table

---Reference to the table to sample data from
---@alias Fill_param2 # source
---| table

---Compare two tables and clone any missing data from one to the other
---***
---@param target Fill_param1 Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already `"table"`)
---@param source Fill_param2 Reference to the table to sample data from
---***
---@return any target Reference to `target` (it was already updated during the operation, no need for setting it again)
function Fill(target, source) end

--| Pull

---Reference to the table to copy the values to
---@alias Pull_param1 # target
---| table

---Reference to the table to sample data from
---@alias Pull_param2 # source
---| table

---Copy all values at matching keys and clone any missing data from a reference to the target table
---***
---@param target Pull_param1 Reference to the table to copy the values to
---@param source Pull_param2 Reference to the table to sample data from
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function Pull(target, source) end

--| VerifyData

---Reference to the table to verify
---@alias VerifyData_param1 # target
---| table

---Reference to the table to sample
---@alias VerifyData_param2 # source
---| table

---Verify data in a table and harmonize it with a sample table, removing invalid data & filling defaults
---@param target VerifyData_param1 Reference to the table to verify
---@param source VerifyData_param2 Reference to the table to sample
---@return any target Reference to `target` (it was already mutated during the operation)
function VerifyData(target, source) end

--| Prune

---Reference to the table to prune
---@alias Prune_param1 # target
---| table

---Helper function for validating values, returning true if the value is to be accepted as valid
---@alias Prune_param2 # validate
---| fun(k: number|string, v: any): boolean

---Remove all nil, empty or otherwise invalid items from a data table
---***
---@param target Prune_param1 Reference to the table to prune
---@param validate? Prune_param2 Helper function for validating values, returning true if the value is to be accepted as valid
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function Prune(target, validate) end

--| Filter

---Reference to the table to remove unused key, value pairs from
---@alias Filter_param1 # target
---| table

---Reference to the table to sample data from
---@alias Filter_param2 # sample
---| table

---Static map or function returning a dynamically creatable map for removed but recoverable data
---@alias Filter_param3 # recoveryMap
---| table<string, recoveryData>
---| fun(tableToCheck: table, recoveredData: recoveredData): recoveryMap: table<string, recoveryData>
---| nil

---Function called after the data has been has been recovered via the `recoveryMap`
---@alias Filter_param4 # onRecovery
---| fun(tableToCheck: table)

---Remove unused or outdated data from a table while comparing it to another table while restoring any removed values
---***
---@param target Filter_param1 Reference to the table to remove unused key, value pairs from
---@param sample Filter_param2 Reference to the table to sample data from
---@param recoveryMap? Filter_param3 Static map or function returning a dynamically creatable map for removed but recoverable data
---@param onRecovery? Filter_param4 Function called after the data has been has been recovered via the `recoveryMap`
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function Filter(target, sample, recoveryMap, onRecovery) end

--| Log

---Included in the log entry as a string
---@alias Log_param1 # message
---| any

---Custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** `"(source not traced)"`
---@alias Log_param2 # trace
---| any

---Save a tab-separated debug log entry to the log history and print out a formatted chat message
---@param message Log_param1 Included in the log entry as a string
---@param trace? Log_param2 Custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** `"(source not traced)"`
function Log(message, trace) end

--| Dump

---Object to dump out
---@alias Dump_param1 # object
---| any

---A name to print out | ***Default:*** *the dumped object will not be named*
---@alias Dump_param2 # name
---| string

---Manually filter further exploring subtables under specific keys, skipping it if the value returned is true
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
---@alias Dump_param3 # blockrule
---| fun(key: integer|string): boolean

---How many levels of subtables to print out (root level: `0`) | ***Default:*** *full depth*
---@alias Dump_param4 # depth
---| integer

---If `true`, explore and dump the non-subtable values of table objects | ***Default:*** `true`
---@alias Dump_param5 # digTables
---| boolean

---If `true`, explore and dump the insides of objects recognized as frames | ***Default:*** `false`
---@alias Dump_param6 # digFrames
---| boolean

---Print the specified number of output lines in a single chat message to be able to display more message history and allow faster scrolling | ***Default:*** `2`
--- - ***Note:*** Set to `0` to print all lines in a single message.
---@alias Dump_param7 # linesPerMessage
---| integer

---Dump an object and its contents to the in-game chat
---***
---@param object Dump_param1 Object to dump out
---@param name? Dump_param2 A name to print out | ***Default:*** *the dumped object will not be named*
---@param blockrule? Dump_param3 Manually filter further exploring subtables under specific keys, skipping it if the value returned is true
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
---@param depth? Dump_param4 How many levels of subtables to print out (root level: `0`) | ***Default:*** *full depth*
---@param digTables? Dump_param5 If `true`, explore and dump the non-subtable values of table objects | ***Default:*** `true`
---@param digFrames? Dump_param6 If `true`, explore and dump the insides of objects recognized as frames | ***Default:*** `false`
---@param linesPerMessage? Dump_param7 Print the specified number of output lines in a single chat message to be able to display more message history and allow faster scrolling | ***Default:*** `2`
--- - ***Note:*** Set to `0` to print all lines in a single message.
function Dump(object, name, blockrule, depth, digTables, digFrames, linesPerMessage) end

--| Register

---Addon namespace (the name of the addon's folder, not its display title) to register for WidgetTools usage
---@alias Register_param1 # addon
---| string

---Version key the `toolbox` should be registered under (always converted to string)
---@alias Register_param2 # version
---| string
---| number

---Function to be called after a new toolbox initialization has finished when `addon` loaded, returning a read-only reference to the new toolbox table
---@alias Register_param3 # callback
---| fun(toolbox: widgetToolbox|table?) 

---Reference to an existing toolbox table to register
---@alias Register_param4 # toolbox
---| table

---Get a read-only reference to the toolbox of the specified version from the registry, register one or stat initializing a new table, linked to specified addon for use
--- - ***Note:*** If a toolbox of `version` already exists in the registry, get a read-only reference to it and register `addon` for use, `callback` will not be called.
--- - ***Note:*** If no existing toolbox entry was found, and `toolbox` is not provided or it's not a valid table, start the initialization of a new toolbox in the a readable table accessible via `WidgetTools.toolboxes.initialization[version]`, and call `callback` when `addon` finished loading, returning a read-only reference to the newly initialized toolbox bundled from this initialization table which itself will be cleared.
---***
---@param addon Register_param1 Addon namespace (the name of the addon's folder, not its display title) to register for WidgetTools usage
---@param version Register_param2 Version key the `toolbox` should be registered under (always converted to string)
---@param callback? Register_param3 Function to be called after a new toolbox initialization has finished when `addon` loaded, returning a read-only reference to the new toolbox table
---@param toolbox? Register_param4 Reference to an existing toolbox table to register
---***
---@return widgetToolbox|table? toolbox Read-only reference to the registered toolbox table | ***Default:*** *nil*
function Register(addon, version, callback, toolbox) end