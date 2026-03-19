--NOTE: Annotations are for development purposes only, providing documentation for use with LUA Language Server. This file does not need to be loaded by the game client.


--[[ CLASSES ]]

---Global read-only Widget Tools table
---@class widgetTools
widgetTools = {

	---@class widgetToolsResources
	---@field name string Addon namespace name
	---@field title string Addon display title
	---@field root string Addon root folder
	resources = {


		--[[ STRINGS ]]

		--Chat commands
		chat = {},

		changelog = {},

		---Localized strings
		---@class WidgetToolsStrings
		strings = {},


		--[[ ASSETS ]]

		colors = {},
		textures = {},
		fonts = {},
	},


	--[[ UTILITIES ]]

	---Core utility collection
	---@class widgetToolsUtilities
	utilities = {

		--[ General ]

		---Access a Blizzard modifier key down checking function via a modifier key string
		---@type table<ModifierKey|any, fun(): down: boolean>
		isKeyDown = {},

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

		---@type table<string, widgetToolbox|table> List of temporary toolbox initialization tables under version keys where a toolbox can assembled to be registered once the addon requesting it finishes loading
		initialization = {},

		Register = Register,
	},
}


---@class widgetToolboxEntry
---@field toolbox widgetToolbox|table Read-only proxy reference to the registered toolbox table
---@field addons string[] List of addons registered for using this toolbox (represented by their namespace names)


--[[ FUNCTIONS ]]

--[ Utilities ]

---Shared resources
---@class widgetToolsResources
widgetTools.utilities = {}

--| General

---Get the sorted key, value pairs of a table ([Documentation: Sort](https://www.lua.org/pil/19.3.html))
---***
---@param t table Table to be sorted (in an ascending order and/or alphabetically, based on the `<` operator)
---***
---@return function iterator Function returning the key, value pairs of the table in order
function SortedPairs(t) return function() end end


--| Math

---Round a decimal fraction to the specified number of digits
---***
---@param number? number A fractional number value to round | ***Default:*** 0
---@param decimals? integer Specify the number of decimal places to round the number to | ***Default:*** 0
---@return number
function Round(number, decimals) return 0 end

--| Validation

---Check if a variable is a frame (or a backdrop object)
---@param t Frame|any
---***
---@return boolean|string # If **t** is recognized as a [FrameScriptObject](https://warcraft.wiki.gg/wiki/UIOBJECT_FrameScriptObject), return true, or, return the frame name if named or the debug name if unnamed but recognized as a UI [Object](https://warcraft.wiki.gg/wiki/UIOBJECT_Object) with a parent, otherwise, return false
function IsFrame(t) return false end

---Find a frame or region by its name (or a subregion if a key is included in the input string) and get a reference to it if it exists
---***
---@param s string Name of the frame to find (and the key of its child region appended to it after a period character)
---***
---@return AnyFrameObject|nil frame Reference to the object
function ToFrame(s) end

--| Formatting

---Format a number string with thousands separation and optional value rounding
---***
---@param value number Number value to turn into a string with thousand separation
---@param decimals? number Specify the number of decimal places to display if the number is a fractional value | ***Default:*** 0
---@param round? boolean Round the number value to the specified number of decimal places | ***Default:*** true
---@param trim? boolean Trim trailing zeros in decimal places | ***Default:*** true
---***
---@return string # ***Default:*** ""
function Thousands(value, decimals, round, trim) return "" end

---Convert the object to an appropriately formatted and colored string based on its type
---***
---@param object any Object to convert to a formatted text
---***
---@return string s Formatted output string
---@return "Frame"|"FrameScriptObject"|"table"|"boolean"|"number"|"string"|"any" t Recognized object type
---<hr><p></p>
function ToString(object) return "", "any" end

---Convert a table into a formatted and colored string (appearing as a functional LUA code chunk but including coloring escape sequences)
--- - ***Example:*** Turning back into a loadable code chunk to then be useable as a table:
--- 	```
--- 	local success, loadedTable = pcall(loadstring("return " .. ns.ut.Clear(tableAsString)))
--- 	```
---***
---@param table table Reference to the table to convert
---@param compact? boolean Whether spaces and indentations should be trimmed or not | ***Default:*** false
---@return string # ***Default:*** **(WidgetTools.utilities.ToString(table))**
function TableToString(table, compact) return "" end

--| Table management

---Shield a table by creating a deep proxy through which value access will be read-only via a protective metatable ruleset
--- - ***Note:*** The protection will "infect" any and all subtables when they are indexed through a proxy, meaning the read-only protection will be extended at any depth, including new subtables added to the original table structure of **t** after it was protected.
--- - ***Note:*** Tables for which **getmetatable(...)** returns "public" or "protected", will not be wrapped behind a new proxy.
---   - ***Example:*** Use `setmetatable(t, { __metatable = "public" })` to whitelist any table from getting read-only protection.
---***
---@param t any Reference to the table to create the proxy for
---***
---@return any # Reference to the new proxy table or **t** itself
function Protect(t) end

---Get the unique internal runtime ID of the table
---***
---@param t table Reference to the table to get the ID of
---@return string # Return empty string of t is not a table | ***Default:*** ""
function GetID(t) return "" end

--Search

---Find the index of the first matching value in the array provided while also checking subtable branches via a deep search if no match was found at the first level
---***
---@param array any[] Array to search
---@param value any The value to find
---@return integer|nil index
function FindIndex(array, value) end

---Find the first matching value and return its key via a deep search
---***
---@param t table Reference to the table to find a value at a certain key in
---@param value any Value to look for in **tableToCheck** (including all subtables, recursively)
---***
---@return any|nil match The first match of the key of the found **valueToFind**, or nil if no match was found
function FindKey(t, value) end

---Find and return the value at the first matching key via a deep search
---***
---@param t table Reference to the table to find a value at a certain key in
---@param key any Key to look for in **tableToCheck** (including all subtables, recursively)
---***
---@return any|nil match The first match of the value found at **keyToFind**, or nil if no match was found
function FindValue(t, key) end

--Data management

---Make a new deep copy of a non-frame table
---***
---@param object any Reference to the object to create a copy of
---***
---@return any copy Returns **object** itself if it's a frame or not a table
function Clone(object) end

---Merge a table to another table, deep copying all its values over under new integer keys
---***
---@param target table Table to add the values to
---@param source table Table to copy all values from
---***
---@return any target Reference to **target** (it was already overwritten during the operation, no need for setting it again)
function Merge(target, source) end

---Copy all values at matching keys from a sample table to another table while preserving all table references
---***
---@param target table Reference to the table to copy the values to
---@param source table Reference to the table to copy the values from
---***
---@return any target Reference to **target** (the values were already overwritten during the operation, no need to set it again)
function CopyValues(target, source) end

---Compare two tables and clone any missing data from one to the other
---***
---@param target table Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already "table")
---@param source table Reference to the table to sample data from
---***
---@return any target Reference to **target** (it was already updated during the operation, no need for setting it again)
function Fill(target, source) end

---Copy all values at matching keys and clone any missing data from a reference to the target table
---***
---@param target table Reference to the table to copy the values to
---@param source table Reference to the table to sample data from
---***
---@return any target Reference to **target** (it was already overwritten during the operation, no need for setting it again)
function Pull(target, source) end

---Verify data in a table and harmonize it with a sample table, removing invalid data & filling defaults
---@param target table Reference to the table to verify
---@param source table Reference to the table to sample
---@return any target Reference to **target** (it was already mutated during the operation)
function VerifyData(target, source) end

---Remove all nil, empty or otherwise invalid items from a data table
---***
---@param target table Reference to the table to prune
---@param validate? fun(k: number|string, v: any): boolean Helper function for validating values, returning true if the value is to be accepted as valid
---***
---@return any table Reference to **table** (it was already overwritten during the operation, no need for setting it again)
function Prune(target, validate) end

---Remove unused or outdated data from a table while comparing it to another table while restoring any removed values
---***
---@param target table Reference to the table to remove unused key, value pairs from
---@param sample table Reference to the table to sample data from
---@param recoveryMap? table<string, recoveryData>|fun(tableToCheck: table, recoveredData: recoveredData): recoveryMap: table<string, recoveryData>|nil Static map or function returning a dynamically creatable map for removed but recoverable data
---@param onRecovery? fun(tableToCheck: table) Function called after the data has been has been recovered via the **recoveryMap**
---***
---@return any target Reference to **target** (it was already overwritten during the operation, no need for setting it again)
function Filter(target, sample, recoveryMap, onRecovery) end

--[ Debugging tools ]

---Save a tab-separated debug log entry to the log history and print out a formatted chat message 
---@param message any Included in the log entry as a string
---@param trace? any Custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** "(source not traced)"
function Log(message, trace) end

---Dump an object and its contents to the in-game chat
---***
---@param object any Object to dump out
---@param name? string A name to print out | ***Default:*** *the dumped object will not be named* | ***Default:*** true
---@param depth? integer How many levels of subtables to print out (root level: 0) | ***Default:*** *full depth*
---@param blockrule? fun(key: integer|string): boolean Manually filter further exploring subtables under specific keys, skipping it if the value returned is true<ul><li>***Note:*** *The code examples below are only visible in the full function annotations, not the parameter annotations.*</li></ul>
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
---@param linesPerMessage? integer Print the specified number of output lines in a single chat message to be able to display more message history and allow faster scrolling | ***Default:*** 2<ul><li>***Note:*** Set to 0 to print all lines in a single message.</li></ul>
function Dump(object, name, blockrule, depth, digTables, digFrames, linesPerMessage) end

--[ Toolbox registry ]

---Get a read-only reference to the toolbox of the specified version from the registry, register one or stat initializing a new table, linked to specified addon for use
--- - ***Note:*** If a toolbox of **version** already exists in the registry, get a read-only reference to it and register **addon** for use, **callback** will not be called.
--- - ***Note:*** If no existing toolbox entry was found, and **toolbox** is not provided or it's not a valid table, start the initialization of a new toolbox in **WidgetTools.toolboxes.initialization[version]**, and call **callback** when **addon** finished loading, returning a read-only reference to the newly initialized toolbox bundled from the initialization table which itself will be cleared.
---***
---@param addon string Addon namespace (the name of the addon's folder, not its display title) to register for WidgetTools usage
---@param version string|number Version key the **toolbox** should be registered under (always converted to string)
---@param callback? fun(toolbox: widgetToolbox|table?) Function to be called after a new toolbox initialization has finished when **addon** loaded, returning a read-only reference to the new toolbox table
---@param toolbox? table Reference to an existing toolbox table to register
---***
---@return widgetToolbox|table? toolbox Read-only reference to the registered toolbox table | ***Default:*** nil
function Register(addon, version, callback, toolbox) end