--[[ RESOURCES ]]

---@class WidgetToolsNamespace
local ns = select(2, ...)


--[[ WIDGET TOOLBOX ]]

--| Register the toolbox

local toolboxVersion = "2.0"

ns.WidgetToolbox = WidgetTools.RegisterToolbox(ns.name, toolboxVersion) or {}

--Check if a toolbox with this version already exists (stop execution if so)
if next(ns.WidgetToolbox) then do return end end

--| Create a new toolbox

WidgetTools.frame:RegisterEvent("ADDON_LOADED")

function WidgetTools.frame:ADDON_LOADED(addon)
	if addon ~= ns.name then return end

	WidgetTools.frame:UnregisterEvent("ADDON_LOADED")

	--[ Wrapper Table ]

	---WidgetTools toolbox
	---@class wt
	local wt = ns.WidgetToolbox


	--[[ LOCALIZATIONS ]]

	--# flags will be replaced with code
	--\n represents the newline character

	local english = {
		popupInput = {
			title = "Specify the text",
			tooltip = "Press " .. KEY_ENTER .. " to accept the specified text or " .. KEY_ESCAPE .. " to dismiss it."
		},
		reload = {
			title = "Pending Changes",
			description = "Reload the interface to apply the pending changes.",
			accept = {
				label = "Reload Now",
				tooltip = "You may choose to reload the interface now to apply the pending changes.",
			},
			cancel = {
				label = "Later",
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
				tooltip = "You may copy the contents of the text field by pressing " .. CTRL_KEY_TEXT .." + C (on Windows) or " .. COMMAND .. " + C (on Mac).",
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
		settings = {
			save = "Changes will be finalized on close.",
			cancel = {
				label = "Revert Changes",
				tooltip = "Dismiss all changes made on this page, and load the saved values.",
			},
			defaults = {
				label = "Restore Defaults",
				tooltip = "Restore all settings on this page (or the whole category) to default values.",
			},
			warning = "Are you sure you want to reset the settings on page #PAGE, or all settings in the whole #CATEGORY category to defaults?\n\n#DISMISS",
			warningSingle = "Are you sure you want to reset the settings on page #PAGE to defaults?\n\n#DISMISS",
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
		about = {
			title = "About",
			description = "Thanks for using #ADDON! Copy the links to see how to share feedback, get help & support development.",
			version = "Version",
			date = "Date",
			author = "Author",
			license = "License",
			curseForge = "CurseForge Page",
			wago = "Wago Page",
			repository = "GitHub Repository",
			issues = "Issues & Feedback",
			changelog = {
				label = "Update Notes",
				tooltip = "Notes of all the changes, updates & fixes introduced with the latest version.\n\nThe changelog is only available in English for now.",
			},
			fullChangelog = {
				label = "#ADDON Changelog",
				tooltip = "Notes of all the changes included in the addon updates for all versions.\n\nThe changelog is only available in English for now.",
				open = {
					label = "Open the full Changelog",
					tooltip = "Access the full list of update notes of all addon versions.",
				},
			},
		},
		sponsors = {
			title = "Sponsors",
			description = "Your continued support is greatly appreciated! Thank you!",
		},
		dataManagement = {
			title = "Data Management",
			description = "Configure #ADDON settings further by managing profiles and backups via importing, exporting options.",
		},
		profiles = {
			title = "Profiles",
			description = "Create, edit and apply unique options profiles specific to each of your characters.",
			select = {
				label = "Select a Profile",
				tooltip = "Choose the options data storage profile to be used for your current character.\n\nThe data in the active profile will be overwritten automatically when settings are modified and saved!",
				profile = "Profile",
				main = "Main",
			},
			new = {
				label = "New Profile",
				tooltip = "Create a new default profile.",
			},
			duplicate = {
				label = "Duplicate",
				tooltip = "Create a new profile, copying the data from the currently active profile.",
			},
			rename = {
				label = "Rename",
				tooltip = "Rename the currently active profile.",
				description = "Rename #PROFILE to:",
			},
			delete = {
				tooltip = "Delete the currently active profile.",
				warning = "Are you sure you want to remove the currently active profile and permanently delete all settings data stored in it?"
			},
		},
		backup = {
			title = "Backup",
			description = "Import or export data in the currently active profile to save, share or move settings, or edit specific values manually.",
			box = {
				label = "Import or Export Profile Data",
				tooltip = {
					"The backup string in this box contains the currently active addon profile data.",
					"Copy the text to save, share or load data for another account from it.",
					"To load data from a string you have, override the text inside this box, then press " .. KEY_ENTER .. " or click the #LOAD button.",
					"Note: If you're using custom font or texture files, those files cannot carry over with this string. They will need to be saved separately, and pasted into the addon folder to become usable.",
					"Only load strings you have verified yourself or trust the source of!",
				},
			},
			allProfiles = {
				title = "Backup All Profiles",
				label = "Import or Export All Profiles",
				tooltipLine = "The backup string in this box contains the list of all addon profiles and the data stored in each specific one as well as the name of currently active profile.",
				open = {
					label = "Open the backup box with all profiles",
					tooltip = "Access the full profile list and backup or modify the data stored in each one.",
				},
			},
			compact = {
				label = "Compact",
				tooltip = "Toggle between a compact, and a more readable & editable view.",
			},
			load = {
				label = "Load",
				tooltip = "Check the current string, and attempt to load the data from it.",
			},
			reset = {
				tooltip = "Dismiss all changes made to the string, and reset it to contain the currently stored data.",
			},
			import = "Load the string",
			warning = "Are you sure you want to attempt to load the currently inserted string?\n\n#DISMISS\n\nIf you've copied it from an online source or someone else has sent it to you, only load it after you've checked the code inside and you know what you are doing.\n\nIf don't trust the source, you may want to cancel to prevent any unwanted actions.",
			error = "The provided backup string could not be validated and no data was loaded. It might be missing some characters or errors may have been introduced if it was edited.",
		},
		position = {
			title = "Position",
			description = {
				static = "Fine-tune the position of #FRAME on the screen via the options provided here.",
				movable = "Drag & drop #FRAME while holding SHIFT to position it anywhere on the screen, fine-tune it here.",
			},
			relativePoint = {
				label = "Linking Screen Point",
				tooltip = "Attach the chosen anchor point of #FRAME to the linking point selected here.",
			},
			-- relativeTo = {
			-- 	label = "Link to Frame",
			-- 	tooltip = "Type the name of another UI element, a frame to link the position of #FRAME to.\n\nFind out the names of frames by toggling the debug UI via the /framestack chat command.",
			-- },
			anchor = {
				label = "Linking Anchor Point",
				tooltip = "Select which point #FRAME should be anchored from when linking to the chosen screen point.",
			},
			keepInPlace = {
				label = "Keep in place",
				tooltip = "Don't move #FRAME when changing the #ANCHOR, update the offset values instead.",
			},
			offsetX= {
				label = "Horizontal Offset",
				tooltip = "Set the amount of horizontal offset (X axis) of #FRAME from the selected #ANCHOR.",
			},
			offsetY = {
				label = "Vertical Offset",
				tooltip = "Set the amount of vertical offset (Y axis) of #FRAME from the selected #ANCHOR.",
			},
			keepInBounds = {
				label = "Keep in screen bounds",
				tooltip = "Make sure #FRAME cannot be moved out of screen bounds.",
			},
		},
		presets = {
			apply = {
				label = "Apply a Preset",
				tooltip = "Change the position of #FRAME by choosing and applying one of these presets.",
				list = { "Under Minimap", },
				select = "Select a preset…",
			},
			save = {
				label = "Update #CUSTOM Preset",
				tooltip = "Save the current position and visibility of #FRAME to the #CUSTOM preset.",
				warning = "Are you sure you want to override the #CUSTOM Preset with the current customizations?\n\nThe #CUSTOM preset is account-wide.",
			},
			reset = {
				label = "Reset #CUSTOM Preset",
				tooltip = "Override currently saved #CUSTOM preset data with the default values, then apply it.",
				warning = "Are you sure you want to override the #CUSTOM Preset with the default values?\n\nThe #CUSTOM preset is account-wide.",
			},
		},
		layer = {
			strata = {
				label = "Screen Layer",
				tooltip = "Raise or lower #FRAME to be in front of or behind other UI elements.",
			},
			keepOnTop = {
				label = "Reveal on mouse interaction",
				tooltip = "Allow #FRAME to be moved above other frames within the same #STRATA when being interacted with.",
			},
			level = {
				label = "Frame Level",
				tooltip = "The exact position of #FRAME above and under other frames within the same #STRATA stack.",
			},
		},
		dismiss = "All unsaved changes will be dismissed.",
		date = "#MONTH/#DAY/#YEAR",
		override = "Override",
		example = "Example",
		separator = ",", --Thousand separator character
		decimal = ".", --Decimal character
	}

	--Load the current localization
	local function LoadLocale()
		local locale = GetLocale()

		if (locale == "") then
			--ADD localization for other languages (locales: https://wowpedia.fandom.com/wiki/API_GetLocale#Values)
			--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml#L8
		else --Default: English (UK & US)
			ns.toolboxStrings = english
		end

		--Fill static & internal references
		ns.toolboxStrings.settings.warning = ns.toolboxStrings.settings.warning:gsub("#DISMISS", ns.toolboxStrings.dismiss)
		ns.toolboxStrings.settings.warningSingle = ns.toolboxStrings.settings.warningSingle:gsub("#DISMISS", ns.toolboxStrings.dismiss)
		ns.toolboxStrings.backup.warning = ns.toolboxStrings.backup.warning:gsub("#DISMISS", ns.toolboxStrings.dismiss)
		ns.toolboxStrings.backup.box.tooltip[3] = ns.toolboxStrings.backup.box.tooltip[3]:gsub("#LOAD", ns.toolboxStrings.backup.load.label)
		ns.toolboxStrings.position.keepInPlace.tooltip = ns.toolboxStrings.position.keepInPlace.tooltip:gsub("#ANCHOR", ns.toolboxStrings.position.anchor.label)
		ns.toolboxStrings.position.offsetX.tooltip = ns.toolboxStrings.position.offsetX.tooltip:gsub("#ANCHOR", ns.toolboxStrings.position.anchor.label)
		ns.toolboxStrings.position.offsetY.tooltip = ns.toolboxStrings.position.offsetY.tooltip:gsub("#ANCHOR", ns.toolboxStrings.position.anchor.label)
		ns.toolboxStrings.position.relativePoint.tooltip = ns.toolboxStrings.position.relativePoint.tooltip:gsub("#ANCHOR", ns.toolboxStrings.position.anchor.label)
		ns.toolboxStrings.layer.keepOnTop.tooltip = ns.toolboxStrings.layer.keepOnTop.tooltip:gsub("#STRATA", ns.toolboxStrings.layer.strata.label)
		ns.toolboxStrings.layer.level.tooltip = ns.toolboxStrings.layer.level.tooltip:gsub("#STRATA", ns.toolboxStrings.layer.strata.label)
	end

	LoadLocale()


	--[[ UTILITIES ]]

	--Classic vs Dragonflight code separation
	wt.classic = select(4, GetBuildInfo()) < 100000

	---Check if a table is a frame (or a backdrop object)
	---@param t table
	---***
	---@return boolean|string # If **t** is recognized as a [FrameScriptObject](https://warcraft.wiki.gg/wiki/UIOBJECT_FrameScriptObject), return true, or, return the frame name if named or the debug name if unnamed but recognized as a UI [Object](https://wowpedia.fandom.com/wiki/UIOBJECT_Object) with a parent, otherwise, return false
	function wt.IsFrame(t)
		if type(t) ~= "table" then return false end

		return t.GetObjectType and t.IsObjectType and (t.GetName and t:GetName() or t.GetParent and t:GetParent() and t.GetDebugName and t:GetDebugName() or true) or false
	end

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
	---@param outputTable? table Table to put the formatted output lines in
	---@param name? any Value to print out as name string | ***Default:*** **object** as string
	---@param blockrule? fun(key: integer|string): boolean Manually filter further exploring subtables under specific keys, skipping it if the value returned is true
	---@param digTables? boolean ***Default:*** true
	---@param digFrames? boolean ***Default:*** false
	---@param depth? integer How many levels of subtables to print out (root level: 0) | ***Default:*** *full depth*
	---@param currentKey? string
	---@param currentLevel? integer
	local function GetDumpOutput(object, outputTable, name, blockrule, depth, digTables, digFrames, currentKey, currentLevel)
		--Check whether the current key is to be skipped
		local skip = false
		if currentKey and blockrule then skip = blockrule(currentKey) end

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
			for k, v in wt.SortedPairs(object) do GetDumpOutput(v, outputTable, nil, blockrule, depth, digTables, digFrames, k, currentLevel + 1) end
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
	---@param digTables? boolean If true, explore and dump the non-subtable values of table objects | ***Default:*** true
	---@param digFrames? boolean If true, explore and dump the insides of objects recognized as frames | ***Default:*** false
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
	---@param depth? integer How many levels of subtables to print out (root level: 0) | ***Default:*** *full depth*
	---@param linesPerMessage? integer Print the specified number of output lines in a single chat message to be able to display more message history and allow faster scrolling | ***Default:*** 2
	--- - ***Note:*** Set to 0 to print all lines in a single message.
	function wt.Dump(object, name, blockrule, depth, digTables, digFrames, linesPerMessage)
		--| Get the output lines

		local output = {}

		GetDumpOutput(object, output, name, blockrule, depth, digTables, digFrames)

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
	--- - ***Note:*** When set to "any" [IsModifierKeyDown()](https://wowpedia.fandom.com/wiki/API_IsModifierKeyDown) is used, otherwise the corresponding key down checker is returned.
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

	--[ Math ]

	---Round a decimal fraction to the specified number of digits
	---***
	---@param number number A fractional number value to round
	---@param decimals? number Specify the number of decimal places to round the number to | ***Default:*** 0
	---@return number
	function wt.Round(number, decimals)
		local multiplier = 10 ^ (decimals or 0)

		return math.floor(number * multiplier + 0.5) / multiplier
	end

	--[ Conversion ]

	---Convert the object to an appropriately formatted and colored string based on its type
	---***
	---@param object any Object to convert to a formatted text
	---***
	---@return string s Formatted output string
	---@return string t Recognized object type | ***Value:*** "Frame"|"FrameScriptObject"|"table"|"boolean"|"number"|"string"|"any"
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
	---@return table|nil? frame Reference to the object
	function wt.ToFrame(s)
		local frame = nil

		--Find the global reference
		for name in s:gmatch("[^.]+") do frame = frame and frame[name] or _G[name] end

		return wt.IsFrame(frame) and frame or nil
	end

	---Return a position table used by WidgetTools assembled from the provided values which are returned by [Region:GetPoint(...)](https://wowpedia.fandom.com/wiki/API_Region_GetPoint)
	---***
	---@param anchor? AnchorPoint Base anchor point | ***Default:*** "TOPLEFT"
	---@param relativeTo? Frame Relative to this Frame or Region
	---@param relativePoint? AnchorPoint Relative anchor point
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

	---Returns the position values used by [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) from a position table used by WidgetTools
	---***
	---@param t? positionData Table containing parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with
	---***
	---@return AnchorPoint anchor ***Default:*** "TOPLEFT"
	--- - ***Note:*** Default to "TOPLEFT" when an invalid input is provided.
	---@return Frame? relativeTo ***Default:*** "nil" *(anchor relative to screen dimensions)*
	--- - ***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).
	--- - ***Note:*** Default to nil when an invalid frame name is provided.
	---@return AnchorPoint? relativePoint
	---@return number? offsetX ***Default:*** 0
	---@return number? offsetY ***Default:*** 0
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
	---@param red number ***Range:*** (0, 1)
	---@param green number ***Range:*** (0, 1)
	---@param blue number ***Range:*** (0, 1)
	---@param alpha? number Opacity | ***Range:*** (0, 1) | ***Default:*** 1
	---***
	---@return colorData # Table containing the color values
	function wt.PackColor(red, green, blue, alpha)
		return { r = red, g = green, b = blue, a = alpha or 1 }
	end

	---Returns the color values found in a table
	---***
	---@param t colorData Table containing the color values
	---@param alpha? boolean Specify whether to return the full RGBA set or just the RGB values | ***Default:*** true
	---***
	---@return number r
	--- - ***Note:*** Default to 1 when an invalid input is provided.
	---@return number g
	--- - ***Note:*** Default to 1 when an invalid input is provided.
	---@return number b
	--- - ***Note:*** Default to 1 when an invalid input is provided.
	---@return number? a ***Default:*** 1
	function wt.UnpackColor(t, alpha)
		if type(t) ~= "table" then return 1, 1, 1, 1 end
		if alpha ~= false then return t.r, t.g, t.b, t.a or 1 else return t.r, t.g, t.b end
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
	---@return number? a Alpha | ***Range:*** (0, 1)
	function wt.HexToColor(hex)
		hex = hex:gsub("#", "")
		if hex:len() ~= 6 and hex:len() ~= 8 then return 1, 1, 1 end

		local r = tonumber(hex:sub(1, 2), 16) / 255
		local g = tonumber(hex:sub(3, 4), 16) / 255
		local b = tonumber(hex:sub(5, 6), 16) / 255

		if hex:len() == 8 then return r, g, b, tonumber(hex:sub(7, 8), 16) / 255 else return r, g, b end
	end

	--[ String Formatting ]

	---Add coloring escape sequences to a string
	---***
	---@param text string Text to add coloring to
	---@param color colorData Table containing the color values
	---@return string
	function wt.Color(text, color)
		local r, g, b, a = wt.UnpackColor(color)

		return WrapTextInColorCode(text, wt.ColorToHex(r, g, b, a, true, false))
	end

	---Format a number string to include thousand separation
	---***
	---@param value number Number value to turn into a string with thousand separation
	---@param decimals? number Specify the number of decimal places to display if the number is a fractional value | ***Default:*** 0
	---@param round? boolean Round the number value to the specified number of decimal places | ***Default:*** true
	---@param trim? boolean Trim trailing zeros in decimal places | ***Default:*** true
	---@return string
	function wt.FormatThousands(value, decimals, round, trim)
		value = round == false and value or wt.Round(value, decimals)
		local fraction = math.fmod(value, 1)
		local integer = value - fraction

		--Formatting
		local leftover
		while true do
			integer, leftover = string.gsub(integer, "^(-?%d+)(%d%d%d)", '%1' .. ns.toolboxStrings.separator .. '%2')
			if leftover == 0 then break end
		end
		local decimalText = tostring(fraction):sub(3, (decimals or 0) + 2)
		if trim == false then for i = 1, (decimals or 0) - #decimalText do decimalText = decimalText .. "0" end end

		return integer .. (((decimals or 0) > 0 and (fraction ~= 0 or trim == false)) and ns.toolboxStrings.decimal .. decimalText or "")
	end

	---Remove all recognized formatting, other escape sequences (like coloring) from a string
	--- - ***Note:*** *Grammar* escape sequences are not yet supported, and will not be removed.
	---@param s string
	---@return string s
	function wt.Clear(s)
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

	---Get an assembled & fully formatted string of a string table (changelog) that meets the specifications
	---***
	---@param changelog { [table[]] : string[] } String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included
	--- - ***Note:*** The first line is expected to be the title containing the version number and/or the date of release.
	--- - ***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).
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

		for i = #changelog, 1, -1 do
			local firstLine = latest and 2 or 1

			for j = firstLine, #changelog[i] do
				c = c .. (j > firstLine and "\n\n" or "") .. changelog[i][j]:gsub(
					"#V_(.-)_#", (i < #changelog and "\n\n\n" or "") .. "|c" .. highlight .. "• %1|r"
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

	---Format a table as a string with colored values appropriate to their type
	---***
	---@param table table Reference to the table to convert
	---@param compact? boolean Whether spaces and indentations should be trimmed or not | ***Default:*** false
	---@param space string Character(s) to add for additional spacing between non-atomic elements
	---@param newLine string Character(s) to add for breaking lines (or not)
	---@param indentation string Chain of characters to use as the indentation for subtables
	---@return string
	local function FormatTableString(table, compact, space, newLine, indentation)
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
			if valueType == "table" then valueString = FormatTableString(value, compact, space, newLine, indentation .. (compact and "" or "    ")) end

			tableString = tableString .. space .. valueString

			--Add separator
			tableString = tableString .. ","
		end

		return WrapTextInColorCode((compact and tableString or tableString:sub(1, -2)) .. newLine .. indentation:sub(1, -5) .. "}", "FF999999") --base color (grey)
	end

	---Convert a table into a formatted and colored string appearing as a LUA code chunk
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

		return FormatTableString(table, compact, compact and "" or " ", compact and "" or "\n", "    ")
	end

	--[ Table Management ]

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

	---Find and return the value at the first matching key
	---***
	---@param tableToCheck table Reference to the table to find a value at a certain key in
	---@param keyToFind any Key to look for in **tableToCheck** (including all subtables, recursively)
	---***
	---@return any|nil match Value found at **keyToFind**, returns the first match only
	function wt.FindKey(tableToCheck, keyToFind)
		if type(tableToCheck) ~= "table" then return nil end

		for k, v in pairs(tableToCheck) do
			if k == keyToFind then return v end

			local match = wt.FindKey(v, keyToFind)
			if match then return match end
		end

		return nil
	end

	---Find the first matching value and return its key
	---***
	---@param tableToCheck table Reference to the table to find a value at a certain key in
	---@param valueToFind any Value to look for in **tableToCheck** (including all subtables, recursively)
	---***
	---@return any|nil match Key of the found value, returns the first match only
	function wt.FindValue(tableToCheck, valueToFind)
		if type(tableToCheck) ~= "table" then return nil end

		for k, v in pairs(tableToCheck) do
			if v == valueToFind then return k end

			local match = wt.FindValue(v, valueToFind)

			if match then return match end
		end

		return nil
	end

	---Get a copy of the strings table or a subtable/value at the specified key used by this WidgetToolbox
	---***
	---@param key any Get the strings subtable/value at this key
	---***
	---@return table|string|nil # nil if **key** is specified but no match was found
	function wt.GetStrings(key)
		return wt.Clone(wt.FindKey(ns.toolboxStrings, key))
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
	---@param tableToCheck table Reference to the table to remove unused key, value pairs from
	---@param tableToSample table Reference to the table to sample data from
	---@param recoveredData? table
	---@param recoveredKey? string
	---***
	---@return table|nil recoveredData Table containing the removed key, value pairs (nested keys chained together with period characters in-between)
	local function CleanTable(tableToCheck, tableToSample, recoveredData, recoveredKey)
		recoveredData = recoveredData or {}
		local tc, ts = type(tableToCheck), type(tableToSample)

		--| Utilities

		--Go deeper to fully map out recoverable keys
		local function GoDeeper(ttc, rck)
			if type(ttc) ~= "table" then return end

			for k, v in pairs(ttc) do
				if type(v) == "table" then GoDeeper(v, rck .. (type(k) == "number" and ("[" .. k .. "]") or ("." .. k)))
				else recoveredData[(rck .. (type(k) == "number" and ("[" .. k .. "]") or ("." .. k))):sub(2)] = v end
			end
		end

		--| Compare types

		if tc ~= ts then
			local rk = (recoveredKey or "") .. (type(recoveredKey) == "number" and ("[" .. recoveredKey .. "]") or ("." .. recoveredKey))

			--Save the old item to the recovered data container
			if tc ~= "table" then recoveredData[rk:sub(2)] = tableToCheck else GoDeeper(tableToCheck, rk) end

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
				if type(value) ~= "table" then recoveredData[rk:sub(2)] = value else GoDeeper(value, rk) end

				--Remove the unneeded item
				tableToCheck[key] = nil
			else recoveredData = CleanTable(tableToCheck[key], tableToSample[key], recoveredData, rk) end
		end

		return recoveredData
	end

	---Remove unused or outdated data from a table while comparing it to another table while restoring any removed values
	---***
	---@param tableToCheck table Reference to the table to remove unused key, value pairs from
	---@param tableToSample table Reference to the table to sample data from
	---@param recoveryMap? table<string, recoveryData> Save removed data from matching key chains to the specified table under the specified key
	--- - ***Example:*** String chain of keys pointing to the removed old data to be recovered from **tableToCheck**: `"keyOne[2].keyThree.keyFour[1]"`.
	---@param onRecovery? fun(recoveredData: table): recoveryMap: table<string, recoveryData>|nil Function to call when removed data is to be recovered, providing a way to dynamically create a recovery map based on the recovered data, replacing **recoveryMap** if it was specified
	---***
	---@return table tableToCheck Reference to **tableToCheck** (it was already overwritten during the operation, no need for setting it again)
	function wt.RemoveMismatch(tableToCheck, tableToSample, recoveryMap, onRecovery)
		local recoveredData = CleanTable(tableToCheck, tableToSample)

		if next(recoveredData) then
			recoveryMap = onRecovery and onRecovery(recoveredData) or recoveryMap

			if recoveryMap then for key, value in pairs(recoveredData) do if recoveryMap[key] then for i = 1, #recoveryMap[key].saveTo do
				recoveryMap[key].saveTo[i][recoveryMap[key].saveKey] = recoveryMap[key].convertSave and recoveryMap[key].convertSave(value) or value
			end end end end
		end

		return tableToCheck
	end

	--[ Frame Setup ]

	local positioningAid

	---Create an optional frame with the specified parameters
	---@generic T, Tp
	---@param type? `T`|FrameType|"nil" ***Default:*** nil *(create no frame)*
	---@param name? string Unique global name to set for the new frame | ***Default:*** nil *(anonymous frame)*
	---@param parent? Frame? Reference to the frame to set as the parent of the new frame | ***Default:*** nil *(parentless frame)*
	---@param template? `Tp`|TemplateType Comma-separated list of [FrameXML templates](https://warcraft.wiki.gg/wiki/Virtual_XML_template) to set up the frame with
	---@param id? number Custom ID to set for the new frame
	--- - ***Note:*** Can be set via [Frame:SetID](https://warcraft.wiki.gg/wiki/API_Frame_SetID) any time.
	---@return T|Tp|nil frame
	function wt.CreateFrame(type, name, parent, template, id)
		if not type then return end

		return CreateFrame(type, name, parent, template, id)
	end

	---Set the position and anchoring of a frame when it is unknown which parameters will be nil
	---***
	---@param frame Frame Reference to the frame to be moved
	---@param position? positionData Table of parameters to call **frame**:[SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	---@param safeMode? boolean If true, move a positioning aid frame to the target position first, convert it to absolute position, then move **frame** relative to that positioning aid to prevent anchor family connections | ***Default:*** false
	--- ***Note:*** The position of **frame** will be converted to absolute once the positioning is done, breaking the relative link to **position.relativeTo**.
	---@param userPlaced? boolean Remember the position if **frame**:[IsMovable()](https://wowpedia.fandom.com/wiki/API_Frame_IsMovable) | ***Default:*** true
	function wt.SetPosition(frame, position, safeMode, userPlaced)
		local anchor, relativeTo, relativePoint, offsetX, offsetY = wt.UnpackPosition(position)
		relativeTo = relativeTo ~= "nil" and relativeTo or nil

		--Set the position
		if relativeTo and safeMode then
			if not positioningAid then
				positioningAid = CreateFrame("Frame", ns.name .. "PositioningAid")

				positioningAid:SetSize(10, 10)
			end

			--[ Position the Aid ]

			positioningAid:ClearAllPoints()

			if (not relativeTo and not relativePoint) and (not offsetX and not offsetY) then positioningAid:SetPoint(anchor)
			elseif not relativeTo and not relativePoint then positioningAid:SetPoint(anchor, offsetX, offsetY)
			elseif not offsetX and not offsetY then print(relativeTo, relativePoint) positioningAid:SetPoint(anchor, relativeTo, relativePoint or anchor)
			else positioningAid:SetPoint(anchor, relativeTo, relativePoint or anchor, offsetX, offsetY) end

			wt.ConvertToAbsolutePosition(positioningAid)

			--[ Position the Frame ]

			frame:ClearAllPoints()

			frame:SetPoint("CENTER", positioningAid, "CENTER")

			wt.ConvertToAbsolutePosition(frame)
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

	---Convert the position of a frame positioned relative to another to absolute position (being positioned in the UIParent)
	---***
	---@param frame Frame Reference to the frame the position of which to be converted to absolute position
	function wt.ConvertToAbsolutePosition(frame)
		if not frame.IsMovable then return end

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
	--- - ***Note:*** The frames will be arranged into columns based on the the number of child frames assigned to a given row, anchored to "TOPLEFT", "TOP" and "TOPRIGHT" in order (by default) up to 3 frames. Columns in rows with more frames will be attempted to be spaced out evenly between the frames placed at the main 3 anchors.
	---***
	---@param container Frame Reference to the parent container frame the child frames of which are to be arranged based on the description in **arrangement**
	---@param t? arrangementData Arrange the child frames of **container** based on the specifications provided in this table
	function wt.ArrangeContent(container, t)
		t = t or {}
		t.parameters = t.parameters or {}
		t.parameters.margins = t.parameters.margins or {}
		t.parameters.margins = { l = t.parameters.margins.l or 12, r = t.parameters.margins.r or 12, t = t.parameters.margins.t or 12, b = t.parameters.margins.b or 12 }
		if t.parameters.flip then
			local temp = t.parameters.margins.l
			t.parameters.margins.l = t.parameters.margins.r
			t.parameters.margins.r = temp
		end
		t.parameters.gaps = t.parameters.gaps or 8
		local flipper = t.parameters.flip and -1 or 1
		local height = t.parameters.margins.t
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
			height = height + (i > 1 and t.parameters.gaps or 0)

			--First frame goes to the top left (or right if flipped)
			frames[t.order[i][1]]:SetPoint(t.parameters.flip and "TOPRIGHT" or "TOPLEFT", t.parameters.margins.l * flipper, -height)

			--Place the rest of the frames
			if #t.order[i] > 1 then
				local odd = #t.order[i] % 2 ~= 0

				--Middle frame goes to the top center
				local two = #t.order[i] == 2
				if odd or two then frames[t.order[i][two and 2 or math.ceil(#t.order[i] / 2)]]:SetPoint("TOP", container, "TOP", 0, -height) end

				if #t.order[i] > 2 then
					--Last frame goes to the top right (or left if flipped)
					frames[t.order[i][#t.order[i]]]:SetPoint(t.parameters.flip and "TOPLEFT" or "TOPRIGHT", -t.parameters.margins.r * flipper, -height)

					--Fill the space between the main anchor points with the remaining frames
					if #t.order[i] > 3 then
						local shift = odd and 0 or 0.5
						local w = container:GetWidth() / 2
						local n = (#t.order[i] - (odd and 1 or 0)) / 2 - shift
						local leftFillWidth = (w - frames[t.order[i][1]]:GetWidth() / 2 - t.parameters.margins.l) / -n * flipper
						local rightFillWidth = (w - frames[t.order[i][#t.order[i]]]:GetWidth() / 2 - t.parameters.margins.r) / n * flipper

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
		if t.parameters.resize ~= false then container:SetHeight(height + t.parameters.margins.b) end
	end

	---Set the movability of a frame based in the specified values
	---***
	---@param frame Frame Reference to the frame to make movable/unmovable
	---@param movable boolean Whether to make the frame movable or unmovable
	---@param t? movabilityData When specified, set **frame** as movable, dynamically updating the position options widgets when it's moved by the user
	---<hr><p></p>
	function wt.SetMovability(frame, movable, t)
		if not frame.SetMovable then return end

		t = t or {}
		t.triggers = t.triggers or { frame }
		if t.cursor == nil then t.cursor = t.modifier ~= nil end
		local modifier = t.modifier and wt.GetModifierChecker(t.modifier) or nil
		local position, hadEvent

		frame:SetMovable(movable)

		if movable then
			position = wt.PackPosition(frame:GetPoint())

			if modifier then
				hadEvent = frame:IsEventRegistered("MODIFIER_STATE_CHANGED")

				frame:HookScript("OnEvent", function(_, event, key, down) if event == "MODIFIER_STATE_CHANGED" and key:find(t.modifier) then
					if down > 0 then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") else SetCursor(nil) end
				end end)
			end
		end

		for i = 1, #t.triggers do
			t.triggers[i]:EnableMouse(movable)

			if movable then
				t.triggers[i]:HookScript("OnEnter", function()
					if not t.cursor or not frame:IsMovable() then return end

					if not modifier or modifier() then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") else frame:RegisterEvent("MODIFIER_STATE_CHANGED") end
				end)

				t.triggers[i]:HookScript("OnLeave", function()
					if not t.cursor or not frame:IsMovable() then return end

					if modifier and not hadEvent then frame:UnregisterEvent("MODIFIER_STATE_CHANGED") end

					SetCursor(nil)
				end)

				t.triggers[i]:HookScript("OnMouseDown", function()
					if not frame:IsMovable() or frame.isMoving then return end
					if modifier and not modifier() then return end

					--Store position
					position = wt.PackPosition(frame:GetPoint())

					--Start moving
					frame:StartMoving()
					frame.isMoving = true
					if (t.events or {}).onStart then t.events.onStart() end

					--| Start the movement updates

					if t.triggers[i]:HasScript("OnUpdate") then t.triggers[i]:SetScript("OnUpdate", function()
						if (t.events or {}).onMove then t.events.onMove() end

						--Check if the modifier key is pressed
						if modifier then
							if modifier() then return end

							--Cancel when the modifier key is released
							frame:StopMovingOrSizing()
							frame.isMoving = false
							if (t.events or {}).onCancel then t.events.onCancel() end

							--Reset the position
							wt.SetPosition(frame, position)

							--Stop checking if the modifier key is pressed
							t.triggers[i]:SetScript("OnUpdate", nil)
						end
					end) end
				end)

				t.triggers[i]:HookScript("OnMouseUp", function()
					if not frame:IsMovable() or not frame.isMoving then return end

					--Stop moving
					frame:StopMovingOrSizing()
					frame.isMoving = false
					if (t.events or {}).onStop then t.events.onStop() end

					--Stop the movement updates
					if t.triggers[i]:HasScript("OnUpdate") then t.triggers[i]:SetScript("OnUpdate", nil) end
				end)

				t.triggers[i]:HookScript("OnHide", function()
					if not frame:IsMovable() or not frame.isMoving then return end

					--Cancel moving
					frame:StopMovingOrSizing()
					frame.isMoving = false
					if (t.events or {}).onCancel then t.events.onCancel() end

					--Reset the position
					wt.SetPosition(frame, position)

					--Stop the movement updates
					if t.triggers[i]:HasScript("OnUpdate") then t.triggers[i]:SetScript("OnUpdate", nil) end
				end)
			end
		end
	end

	---Set the visibility of a frame based on the value provided
	---***
	---@param frame Frame Reference to the frame to hide or show
	---@param visible boolean If false, hide the frame, show it if true
	function wt.SetVisibility(frame, visible)
		if visible then frame:Show() else frame:Hide() end
	end

	---Set the backdrop of a frame with BackdropTemplate with the specified parameters
	---***
	---@param frame Frame Reference to the frame to set the backdrop of
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
				frame:SetBackdrop(nil)

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
	---@return boolean state
	function wt.CheckDependencies(rules)
		local state = true

		for i = 1, #rules do
			if wt.IsFrame(rules[i].frame) then --Base Blizzard frames
				if rules[i].frame:IsObjectType("CheckButton") then
					if rules[i].evaluate then state = rules[i].evaluate(rules[i].frame:GetChecked()) else state = rules[i].frame:GetChecked() end
				elseif rules[i].frame:IsObjectType("EditBox") then state = rules[i].evaluate(rules[i].frame:GetText())
				elseif rules[i].frame:IsObjectType("Slider") then state = rules[i].evaluate(rules[i].frame:GetValue())
				end
			elseif rules[i].frame.isType then --Custom WidgetTools widgets
				if rules[i].frame.isType("Toggle") then
					if rules[i].evaluate then state = rules[i].evaluate(rules[i].frame.getState()) else state = rules[i].frame.getState() end
				elseif rules[i].frame.isType("Selector") then state = rules[i].evaluate(rules[i].frame.getSelected())
				elseif rules[i].frame.isType("Textbox") then state = rules[i].evaluate(rules[i].frame.getText())
				elseif rules[i].frame.isType("Numeric") then state = rules[i].evaluate(rules[i].frame.getValue())
				end
			end

			if not state then break end
		end

		return state
	end

	---Assign dependency rule listeners from a defined a ruleset
	---***
	---@param rules dependencyRule[] Indexed table containing the dependency rules to add
	---@param setState fun(state: boolean) Function to call to set the state of the frame, enabling it on a true, or disabled it on a false input
	function wt.AddDependencies(rules, setState)
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
			elseif rules[i].frame.isType and rules[i].frame.frame then --Custom WidgetTools widgets
				--Watch value load events
				rules[i].frame.setListener("loaded", function(state) if state then setter() end end)

				--Watch value change events
				if rules[i].frame.isType("Toggle") then rules[i].frame.setListener("toggled", setter)
				elseif rules[i].frame.isType("Selector") then rules[i].frame.setListener("selected", setter)
				elseif rules[i].frame.isType("Textbox") or rules[i].frame.isType("Numeric") then rules[i].frame.setListener("changed", setter)
				end
			end
		end end

		--Initialize state
		setter()
	end

	--[ Options Data Management ]

	--| Batch Data Management

	--Collection of rules describing where to save/load options data to/from, and what to call in the process
	local optionsTable = { rules = {}, changeHandlers = {} }

	---Add a connection between an options widget and a DB entry to the options data table under the specified options key
	---***
	---@param widget checkbox|radioButton|selector|multiSelector|specialSelector|dropdownSelector|textbox|multilineTextbox|numericSlider|colorPicker Reference to the widget to be saved & loaded data to/from with defined **loadData** and **saveData** functions
	---@param optionsData booleanOptionsData|stringOptionsData|numberOptionsData|integerOptionsData|booleanArrayOptionsData|specialOptionsData|colorOptionsData Table with the information on options data handling
	function wt.AddToOptionsTable(widget, optionsData)
		if not optionsData.optionsKey then return end

		optionsTable.rules[optionsData.optionsKey] = optionsTable.rules[optionsData.optionsKey] or {}

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

		--Add widget reference
		optionsData.widget = widget

		--Add the options data rules to the collection
		table.insert(optionsTable.rules[optionsData.optionsKey], optionsData)
	end

	---Load all data from the storage table(s) to the widgets specified in the options data list referenced by the options key by calling **[*widget*].loadData(...)** for each
	---***
	---@param optionsKey table A unique key referencing the collection of widget options data to be loaded
	---@param changes boolean Whether to call **onChange** handlers or not | ***Default:*** false
	function wt.LoadOptionsData(optionsKey, changes)
		if not optionsTable.rules[optionsKey] then return end

		if changes then changes = {} end

		for i = 1, #optionsTable.rules[optionsKey] do
			optionsTable.rules[optionsKey][i].widget.loadData(false)

			--Register onChange handlers for call
			if changes and optionsTable.rules[optionsKey][i].onChange then
				for j = 1, #optionsTable.rules[optionsKey][i].onChange do changes[optionsTable.rules[optionsKey][i].onChange[j]] = true end
			end
		end

		--Call registered onChange handlers
		if changes then for k in pairs(changes) do optionsTable.changeHandlers[optionsKey][k]() end end
	end

	---Save all data from the widgets to the storage table(s) specified in the options data list referenced by the options key by calling **[*widget*].saveData(...)** for each
	---***
	---@param optionsKey table A unique key referencing the collection of widget options data to be saved
	function wt.SaveOptionsData(optionsKey)
		if not optionsTable.rules[optionsKey] then return end

		for i = 1, #optionsTable.rules[optionsKey] do optionsTable.rules[optionsKey][i].widget.saveData(nil, true) end
	end

	--Set a data snapshot for each widget specified in the options data list referenced by the options key by calling **[*widget*].revertData()** for each
	function wt.SnapshotOptionsData(optionsKey)
		if not optionsTable.rules[optionsKey] then return end

		for i = 1, #optionsTable.rules[optionsKey] do optionsTable.rules[optionsKey][i].widget.snapshotData() end
	end

	--Set and load the stored data managed by each widget specified in the options data list referenced by the options key by calling **[*widget*].snapshotData()** for each
	function wt.RevertOptionsData(optionsKey)
		if not optionsTable.rules[optionsKey] then return end

		for i = 1, #optionsTable.rules[optionsKey] do optionsTable.rules[optionsKey][i].widget.revertData() end
	end

	--| Widget Data Handlers

	---Load the data from the specified storage table under the specified storage key to the widget
	---***
	---@param widget checkbox|radioButton|selector|multiSelector|specialSelector|dropdownSelector|textbox|multilineTextbox|numericSlider|colorPicker Reference to the widget to be saved & loaded data to/from with defined **loadData** and **saveData** functions
	---@param optionsData booleanOptionsData|stringOptionsData|numberOptionsData|integerOptionsData|booleanArrayOptionsData|specialOptionsData|colorOptionsData Table with the information on options data handling
	---@param set fun(data?: any): data: any|nil Called to check the loaded (and converted) data retrieved from **optionsData.storageTable** and load it to **widget**
	---@param handleChanges? boolean If true, call **optionsData.onChange** (if set) | ***Default:*** true
	function wt.LoadWidgetData(widget, optionsData, set, handleChanges)
		if type(optionsData) ~= "table" then return end

		local data

		if widget.frame then
			widget.frame:SetAttributeNoHandler("loaded", false)

			if optionsData.storageKey and optionsData.storageTable then data = optionsData.storageTable[optionsData.storageKey] end
			if optionsData.convertLoad then data = optionsData.convertLoad(data) end
			data = set(data)

			--Invoke an event
			widget.frame:SetAttribute("loaded", true)
		end

		--Call listeners
		if optionsData.onLoad then optionsData.onLoad(widget, data) end
		if handleChanges ~= false and optionsData.onChange then
			for i = 1, #optionsData.onChange do optionsTable.changeHandlers[optionsData.optionsKey][optionsData.onChange[i]]() end
		end
	end

	---Save the provided data or the current value of the widget to the specified storage table under the specified storage key
	---***
	---@param widget checkbox|radioButton|selector|multiSelector|specialSelector|dropdownSelector|textbox|multilineTextbox|numericSlider|colorPicker Reference to the widget to be saved & loaded data to/from with defined **loadData** and **saveData** functions
	---@param optionsData booleanOptionsData|stringOptionsData|numberOptionsData|integerOptionsData|booleanArrayOptionsData|specialOptionsData|colorOptionsData Table with the information on options data handling
	---@param get fun(): data: any|nil Called to retrieve the data from the widget and save it to **optionsData.storageTable**
	function wt.SaveWidgetData(widget, optionsData, get)
		if type(optionsData) ~= "table" then return end

		local data = get()
		if optionsData.convertSave then data = optionsData.convertSave(data) end
		if optionsData.storageKey and optionsData.storageTable then optionsData.storageTable[optionsData.storageKey] = data end

		--Call listeners
		if optionsData.onSave then optionsData.onSave(widget, data) end
	end

	---Get the currently stored data from the specified storage table under the specified storage key
	---@param optionsData booleanOptionsData|stringOptionsData|numberOptionsData|integerOptionsData|booleanArrayOptionsData|specialOptionsData|colorOptionsData Table with the information on options data handling
	---@param unconverted? boolean If true, use **optionsData.convertLoad** (if set) when reading the data or return the raw data unconverted | ***Default:*** false
	---@return any
	function wt.GetWidgetData(optionsData, unconverted)
		if type(optionsData) ~= "table" or not optionsData.storageKey or not optionsData.storageTable then return end

		if not unconverted and optionsData.convertLoad then return optionsData.convertLoad(optionsData.storageTable[optionsData.storageKey]) end
		return optionsData.storageTable[optionsData.storageKey]
	end

	--[ Settings Page Management ]

	---Register the settings page to the Settings window if it wasn't already
	--- - ***Note:*** No settings page will be registered if **WidgetToolsDB.lite** is true.
	---@param page settingsPage Reference to the settings page to register to Settings
	---@param parent? settingsPage Reference to the parent settings page to set **page** as a child category page of | ***Default:*** *set as a parent category page*
	---@param icon? boolean If true, append the icon set for the settings page to its button title in the AddOns list of the Settings window as well | ***Default:*** true if **parent** == nil
	function wt.RegisterSettingsPage(page, parent, icon)
		if WidgetToolsDB.lite or type(page) ~= "table" or type(page.isType) ~= "function" or not page.isType("SettingsPage") or page.category then return end

		local title = (page.title and page.title:GetText() or "") .. (icon or not parent and page.icon and (" " .. CreateSimpleTextureMarkup(page.icon:GetTextureFileID())) or "")

		page.canvas.OnCommit = function() page.save(true) end
		page.canvas.OnRefresh = function() page.load(nil, true) end
		page.canvas.OnDefault = function() page.defaults(true) end

		if parent then page.category = Settings.RegisterCanvasLayoutSubcategory(parent.category, page.canvas, title)
		else page.category = Settings.RegisterCanvasLayoutCategory(page.canvas, title) end

		Settings.RegisterAddOnCategory(page.category)
	end

	--[ Hyperlink Handlers ]

	---Format a clickable hyperlink text via escape sequences
	---***
	---@param type HyperlinkType [Type of the hyperlink](https://wowpedia.fandom.com/wiki/Hyperlinks#Types) determining how it's being handled and what payload it carries
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
		return wt.Hyperlink(wt.classic and "item" or "addon", addon .. ":" .. (type or "-") .. ":" .. (content or ""), text)
	end

	--Collection of hyperlink handler scripts
	local hyperlinkHandlers = {}

	---Register a function to handle custom hyperlink clicks
	---***
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param type? string Unique custom hyperlink type key used to identify the specific handler function | ***Default:*** "-"
	---@param handler fun(...) Function to be called with the list of content data strings carried by the hyperlink returned one by one when clicking on a hyperlink text created via ***WidgetToolbox*.CustomHyperlink(...)**
	function wt.SetHyperlinkHandler(addon, type, handler)
		--Call the handler function if it has been registered
		local function callHandler(addonID, handlerID, payload)
			local handlerFunction = wt.FindKey(wt.FindKey(hyperlinkHandlers, addonID), handlerID)
			if handlerFunction then handlerFunction(strsplit(":", payload)) end
		end

		--Hook the hyperlink handler caller
		if not next(hyperlinkHandlers) then
			if not wt.classic then EventRegistry:RegisterCallback("SetItemRef", function(_, ...)
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
	---***
	---@param addon string The name of the addon's folder (the addon namespace not the display title)
	---@param keywords string[] List of keywords to register
	--- - ***Note:*** A slash character (`"/"`) will appended before each keyword specified here.
	---@param commands chatCommandData[] Indexed table with the list of commands to register under the specified **keywords**
	---@param defaultHandler? fun(command: string, ...: string) Default handler function to call when no matching command was typed after the keyword (separated by a space character)<hr><p>@*param* `command` string ― The unrecognized command typed after the keyword (separated by a space character)</p><p>@*param* `...` string Payload of the command typed, any words following the command name separated by spaces split and returned one by one</p>
	---***
	---@return table commandManager Table containing command handler functions
	--- - ***Note:*** Annotate `@type commandManager` for detailed field descriptions.
	function wt.RegisterChatCommands(addon, keywords, commands, defaultHandler)
		addon = addon:upper()

		---@class commandManager
		local commandManager = {}

		--Register the keywords
		for i = 1, #keywords do _G["SLASH_" .. addon .. i] = "/" .. keywords[i] end

		--| Create a command handler utility

		---Find and a specific command by its name and call its handler script
		---***
		---@param command string Name of the slash command word (no spaces)
		---@param ... any Any further arguments are used as the payload of the command, passed over to its handler
		---***
		---@return boolean # Whether the command was found and the handler called successfully
		function commandManager.handleCommand(command, ...)
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

		--| Set global keyword handler

		SlashCmdList[addon] = function(line)
			local payload = { strsplit(" ", line) }
			local command = payload[1]
			table.remove(payload, 1)

			--Find and handle the specific command or call the default handler script
			if not commandManager.handleCommand(command, unpack(payload)) and defaultHandler then defaultHandler(unpack(payload)) end
		end

		return commandManager
	end


	--[[ RESOURCES ]]

	--[ Data ]

	--Database table
	WidgetToolsDB = WidgetToolsDB or {}

	--Data checkup
	wt.RemoveEmpty(WidgetToolsDB)
	wt.AddMissing(WidgetToolsDB, ns.defaults)
	wt.RemoveMismatch(WidgetToolsDB, ns.defaults)

	--[ Assets ]

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
		alphaBG = "Interface/AddOns/" .. ns.name .. "/Textures/AlphaBG.tga",
		gradientBG = "Interface/AddOns/" .. ns.name .. "/Textures/GradientBG.tga",
		contextBG = "Interface/AddOns/" .. ns.name .. "/Textures/ContextBG.tga",
	}


	--[[ UX HELPERS ]]

	--[ Tooltip]

	local customTooltip

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

	---Set up a GameTooltip for a frame to be toggled on hover
	---***
	---@param owner Frame Owner frame the tooltip to be shown for
	--- - ***Note:*** A custom property named **tooltipData** will be added to **owner** with the value of the **tooltipData** parameter provided here.
	--- - ***Note:*** If **owner** doesn't have a **tooltipData** property, no tooltip will be shown.
	---@param tooltipData tooltipData The tooltip parameters are to be provided in this table
	---@param toggle? tooltipToggleData Further toggle rule parameters are to be provided in this table
	function wt.AddTooltip(owner, tooltipData, toggle)
		--Set custom property
		owner.tooltipData = tooltipData
		if not owner.tooltipData.tooltip then
			customTooltip = customTooltip or wt.CreateGameTooltip(ns.name .. toolboxVersion)
			owner.tooltipData.tooltip = customTooltip
		end

		--| Toggle events

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

		--| Hide with owner

		owner:HookScript("OnHide", function() if owner.tooltipData then owner.tooltipData.tooltip:Hide() end end)
	end

	---Update and show a GameTooltip already set up to be toggled for a frame
	---***
	---@param owner Frame Owner frame the tooltip to be shown for
	--- - ***Note:*** If **owner** doesn't have a **tooltipData** property, no tooltip will be shown.
	---@param tooltipData? tooltipUpdateData The tooltip parameters are to be provided in this table | ***Default:*** **owner.tooltipData**
	--- - ***Note:*** All values are optional, missing ones will be filled from **owner.tooltipData**.
	---@param clearLines? boolean Replace **owner.tooltipData.lines** with **tooltipData.lines** instead of adjusting existing values | ***Default:*** true if **tooltipData.lines** ~= nil
	---@param override? boolean Update **owner.tooltipData** values with corresponding values provided in **tooltipData** | ***Default:*** true
	function wt.UpdateTooltip(owner, tooltipData, clearLines, override)
		if not owner.tooltipData then return end

		--| Update the tooltip data

		tooltipData = tooltipData or {}

		if clearLines ~= false and tooltipData.lines then owner.tooltipData.lines = wt.Clone(tooltipData.lines) end
		tooltipData = wt.AddMissing(tooltipData, owner.tooltipData)
		if override ~= false then owner.tooltipData = wt.Clone(tooltipData) end

		--| Position

		tooltipData.position = tooltipData.position or {}
		tooltipData.position.offset = tooltipData.offset or {}

		if tooltipData.anchor == "ANCHOR_NONE" then
			tooltipData.tooltip:SetOwner(owner, tooltipData.anchor)
			wt.SetPosition(tooltipData.tooltip, tooltipData.position)
		else tooltipData.tooltip:SetOwner(owner, tooltipData.anchor, tooltipData.position.offset.x or 0, tooltipData.position.offset.y or 0) end

		--| Add title

		local titleColor = tooltipData.flipColors and colors.highlight or colors.normal

		tooltipData.tooltip:AddLine(tooltipData.title, titleColor.r, titleColor.g, titleColor.b, true)

		--| Add textlines

		if tooltipData.lines then
			for i = 1, #tooltipData.lines do

				--| Set FontString

				local left = tooltipData.tooltip:GetName() .. "TextLeft" .. i + 1
				local right = tooltipData.tooltip:GetName() .. "TextRight" .. i + 1
				local font = tooltipData.lines[i].font or "GameTooltipText"

				if not _G[left] or not _G[right] then
					tooltipData.tooltip:AddFontStrings(tooltipData.tooltip:CreateFontString(left, nil, font), tooltipData.tooltip:CreateFontString(right, nil, font))
				end

				_G[left]:SetFontObject(font)
				_G[left]:SetJustifyH("LEFT")
				_G[right]:SetFontObject(font)
				_G[right]:SetJustifyH("RIGHT")

				--| Add textline

				local color = tooltipData.lines[i].color or (tooltipData.flipColors and colors.normal or colors.highlight)

				tooltipData.tooltip:AddLine(tooltipData.lines[i].text, color.r, color.g, color.b, tooltipData.lines[i].wrap ~= false)
			end
		end

		--Display or update the displayed tooltip
		tooltipData.tooltip:Show()
		tooltipData.tooltip:SetScale(UIParent:GetScale())
	end

	--[ Addon Compartment ]

	---Set up the [Addon Compartment](https://warcraft.wiki.gg/wiki/Addon_compartment#Automatic_registration) functionality by registering global functions for call
	---***
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param calls? addonCompartmentFunctions Functions to call wrapped in a table
	--- - ***Note:*** `AddonCompartmentFunc`, `AddonCompartmentFuncOnEnter` and/or `AddonCompartmentFuncOnLeave` must be set in the specified **addon**'s TOC file to enable this functionality, defining the names of the global functions to be set for call.
	---@param tooltip? addonCompartmentTooltipData List of text lines to be added to the tooltip of the addon compartment button displayed when mousing over it
	--- - ***Note:*** Both `AddonCompartmentFuncOnEnter` and `AddonCompartmentFuncOnLeave` must be set in the specified **addon**'s TOC file to enable this functionality, defining the names of the global functions to be overloaded.
	function wt.SetUpAddonCompartment(addon, calls, tooltip)
		calls = calls or {}

		local onClickName = GetAddOnMetadata(addon, "AddonCompartmentFunc")
		local onEnterName = GetAddOnMetadata(addon, "AddonCompartmentFuncOnEnter")
		local onLeaveName = GetAddOnMetadata(addon, "AddonCompartmentFuncOnLeave")

		if onClickName and calls.onClick then _G[onClickName] = calls.onClick end

		if tooltip and onEnterName and onLeaveName then
			if not tooltip.tooltip then
				customTooltip = customTooltip or wt.CreateGameTooltip(ns.name .. toolboxVersion)
				tooltip.tooltip = customTooltip
			end
			tooltip.title = tooltip.title or GetAddOnMetadata(addon, "Title")

			_G[onEnterName] = function(addon, frame)
				--Set tooltipData property
				frame.tooltipData = frame.tooltipData or tooltip

				--Call handler
				if calls.onEnter then calls.onEnter(addon, frame) end

				--Show tooltip
				wt.UpdateTooltip(frame)
			end

			_G[onLeaveName] = function(addon, frame)
				--Call handler
				if calls.onLeave then calls.onLeave(addon, frame) end

				--Hide tooltip
				if frame.tooltipData and frame.tooltipData.tooltip then frame.tooltipData.tooltip:Hide() end
			end
		else
			if onEnterName and calls.onEnter then _G[onEnterName] = calls.onEnter end
			if onLeaveName and calls.onLeave then _G[onLeaveName] = calls.onLeave end
		end
	end

	--[ Popup ]

	--| Dialogue

	---Create a popup dialogue with an accept function and cancel button
	---***
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param name string Appended to **addon** as a unique identifier key in the global **StaticPopupDialogs** table<ul><li>***Note:*** Space characters will be replaced with "_".</li></ul>
	---@param t? popupDialogueData Parameters are to be provided in this table
	---***
	---@return string key The unique identifier key created for this popup in the global **StaticPopupDialogs** table used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
	function wt.CreatePopupDialogueData(addon, name, t)
		local key = addon:upper() .. "_" .. name:gsub("%s+", "_"):upper()

		--Create the popup dialogue
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

	---Update already existing popup dialogue data
	---***
	---@param key string The unique identifier key representing the defaults warning popup dialogue in the global **StaticPopupDialogs** table, and used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
	---@param t popupDialogueData Parameters are to be provided in this table
	function wt.UpdatePopupDialogueData(key, t)
		if not StaticPopupDialogs[key] then return end

		--Create the popup dialogue
		if t.text then StaticPopupDialogs[key].text = t.text end
		if t.accept then StaticPopupDialogs[key].button1 = t.accept end
		if t.cancel then StaticPopupDialogs[key].button2 = t.cancel end
		if t.alt then StaticPopupDialogs[key].button3 = t.alt end
		if t.onAccept then StaticPopupDialogs[key].OnAccept = t.onAccept end
		if t.onCancel then StaticPopupDialogs[key].OnCancel = t.onCancel end
		if t.onAlt then StaticPopupDialogs[key].OnAlt = t.onAlt end
	end

	--| Input Box

	local customPopupInputBoxFrame

	---Show a movable input window with a textbox, accept and cancel buttons
	---@param t? popupInputBoxData Parameters are to be provided in this table
	function wt.CreatePopupInputBox(t)
		t = t or {}
		customPopupInputBoxFrame = customPopupInputBoxFrame or {}
		customPopupInputBoxFrame.accept = t.accept
		customPopupInputBoxFrame.cancel = t.cancel
		t.position = t.position or {
			anchor = "TOP",
			offset = { y = -320 }
		}
		t.text = t.text or ""

		if customPopupInputBoxFrame.panel then
			wt.SetPosition(customPopupInputBoxFrame.panel, t.position)

			--Update textbox
			customPopupInputBoxFrame.textbox.setText(t.text)
			if t.title then
				if customPopupInputBoxFrame.textbox.label then customPopupInputBoxFrame.textbox.label:SetText(t.title) else customPopupInputBoxFrame.textbox.label = wt.AddTitle({
					parent = customPopupInputBoxFrame.textbox.frame,
					title = {
						offset = { x = -1, },
						text = t.title,
					},
				}) end
			end

			--Update arrangement
			if (t.title ~= nil) ~= (customPopupInputBoxFrame.textbox.label ~= nil) then wt.ArrangeContent(customPopupInputBoxFrame.panel) end

			customPopupInputBoxFrame.panel:Show()

			return
		end

		--[ Utilities ]

		local function accept()
			if type(customPopupInputBoxFrame.accept) == "function" then customPopupInputBoxFrame.accept(customPopupInputBoxFrame.textbox.getText()) end

			customPopupInputBoxFrame.panel:Hide()
		end

		local function cancel()
			if type(customPopupInputBoxFrame.cancel) == "function" then customPopupInputBoxFrame.cancel() end

			customPopupInputBoxFrame.panel:Hide()
		end

		--[ Frame Setup ]

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
			initialize = function(panel)

				--[ Textbox ]

				customPopupInputBoxFrame.textbox = wt.CreateTextbox({
					parent = panel,
					name = "TextInputBox",
					title = t.title,
					label = t.title or false,
					tooltip = { title = ns.toolboxStrings.popupInput.title, lines = { { text = ns.toolboxStrings.popupInput.tooltip }, } },
					size = { w = panel:GetWidth() - 24, },
					text = t.text,
					focusOnShow = true,
					events = {
						OnEnterPressed = accept,
						OnEscapePressed = cancel,
					},
					arrange = {},
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
			arrangement = {}
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
	---@param t? reloadFrameData Parameters are to be provided in this table
	---***
	---@return Frame reload Reference to the reload notice panel frame
	function wt.CreateReloadNotice(t)
		t = t or {}

		if reloadFrame then
			wt.SetPosition(reloadFrame, t.position or {
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
			title = t.title or ns.toolboxStrings.reload.title,
			description = t.message or ns.toolboxStrings.reload.description,
			position = t.position or {
				anchor = "TOPRIGHT",
				offset = { x = -300, y = -100 }
			},
			keepInBounds = true,
			size = { w = 240, h = 90 },
			frameStrata = "DIALOG",
			keepOnTop = true,
			background = { color = { a = 0.9 }, },
			lite = false,
		})

		--| Position & dimensions

		wt.SetMovability(reloadFrame, true)

		--| Title & description

		reloadFrame.title:SetPoint("TOPLEFT", 14, -14)
		reloadFrame.description:SetPoint("TOPLEFT", _G[reloadFrame:GetName() .. "Title"], "BOTTOMLEFT", 0, -4)

		--[ Buttons ]

		wt.CreateButton({
			parent = reloadFrame,
			name = "ReloadButton",
			title = ns.toolboxStrings.reload.accept.label,
			tooltip = { lines = { { text = ns.toolboxStrings.reload.accept.tooltip, }, } },
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
			title = ns.toolboxStrings.reload.cancel.label,
			tooltip = { lines = { { text = ns.toolboxStrings.reload.cancel.tooltip, }, } },
			position = {
				anchor = "BOTTOMRIGHT",
				offset = { x = -12, y = 12 }
			},
			action = function() reloadFrame:Hide() end,
			lite = false,
		})

		return reloadFrame
	end


	--[[ ART ELEMENTS ]]

	--[ Font ]

	---Create a new [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used when setting the look of a [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) using a [FontInstance](https://wowpedia.fandom.com/wiki/UIOBJECT_FontInstance)
	---***
	---@param t fontCreationData Parameters are to be provided in this table
	---@return string name, FontObject font
	---<hr><p></p>
	function wt.CreateFont(t)
		if _G[t.name] then return t.name, _G[t.name] end

		--[ Font Setup ]

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
	if wt.classic then wt.CreateFont({
		name = "GameFontDisableMed2",
		template = "GameFontHighlightMedium",
		color = wt.PackColor(GameFontDisable:GetTextColor()),
	}) end

	--[ Text ]

	---Create a [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) with the specified parameters
	---***
	---@param t textCreationData Parameters are to be provided in this table
	---@return FontString|nil text
	function wt.CreateText(t)
		if not t.parent then return end

		local text = t.parent:CreateFontString((t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Text"), t.layer, t.font and t.font or "GameFontNormal")

		--| Position & dimensions

		wt.SetPosition(text, t.position)
		if t.width then text:SetWidth(t.width) end

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

	---Add a title & description to a container frame
	---***
	---@param t titleCreationData Parameters are to be provided in this table
	---@return FontString|nil title
	---@return FontString|nil description
	function wt.AddTitle(t)
		if not t.parent then return end

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
	---***
	---@param contextMenu Frame Reference to the context menu to add this label to
	---@param t contextLabelData Parameters are to be provided in this table
	---@return FontString|nil label
	function wt.AddContextLabel(contextMenu, t)
		if not contextMenu then return end

		local contextHeight = contextMenu:GetHeight()

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
		contextMenu:SetHeight(contextHeight + 16)

		return label
	end

	--[ Texture ]

	---Create a [Texture](https://wowpedia.fandom.com/wiki/UIOBJECT_Texture) image [TextureBase](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) object
	---***
	---@param t textureCreationData Parameters are to be provided in this table
	---@param updates? table<AnyScriptType, textureUpdateRule> Table of key, value pairs containing the list of events to link texture changes to, and what parameters to change
	---@return Texture|nil texture
	function wt.CreateTexture(t, updates)
		if not t.parent then return end

		local texture = t.parent:CreateTexture((t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Texture"))

		--[ Set Texture Utility ]

		---@param data textureUpdateData
		local function setTexture(data)

			--| Position & dimensions

			wt.SetPosition(texture, data.position)
			texture:SetSize(data.size.w or t.size.w or t.parent:GetWidth(), data.size.h or t.size.h or t.parent:GetHeight())

			--| Asset & color

			texture:SetTexture(data.path or t.path, data.wrap.h or t.wrap.h, data.wrap.v or t.wrap.v, data.filterMode or t.filterMode)
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

		t.size = t.size or {}
		t.path = t.path or "Interface/ChatFrame/ChatFrameBackground"
		t.wrap = t.wrap or {}
		t.tile = t.tile or {}

		setTexture(t)

		--[ Events ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do texture:HookScript(key, value) end end

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

	---Create a [Line](https://warcraft.wiki.gg/wiki/UIOBJECT_Line) [TextureBase](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) object
	---***
	---@param t lineCreationData Parameters are to be provided in this table
	---@return Line|nil line
	function wt.CreateLine(t)
		if not t.parent then return end

		t.startPosition.offset = t.startPosition.offset or {}
		t.endPosition.offset = t.endPosition.offset or {}

		local line = t.parent:CreateLine((t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Line"), t.layer, nil, t.level)

		--Positions
		line:ClearAllPoints()
		line:SetStartPoint(t.startPosition.relativePoint, t.startPosition.relativeTo, t.startPosition.offset.x, t.startPosition.offset.y)
		line:SetEndPoint(t.endPosition.relativePoint, t.endPosition.relativeTo, t.endPosition.offset.x, t.endPosition.offset.y)

		--Color & thickness
		if t.thickness then line:SetThickness(t.thickness) end
		if t.color then line:SetColorTexture(wt.UnpackColor(t.color)) end

		return line
	end

	--[[ CONTAINERS ]]

	--[ Basic Frame ]

	---Create & set up a new basic frame
	---***
	---@param t? frameCreationData Parameters are to be provided in this table
	---@return Frame frame
	function wt.CreateBaseFrame(t)
		t = t or {}
		t.size = t.size or {}
		t.size.w = t.size.w or 0
		t.size.h = t.size.h or 0

		--[ Frame Setup ]

		local name = t.name and ((t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. t.name:gsub("%s+", "")) or nil
		local template = t.customizable and (BackdropTemplateMixin and "BackdropTemplate") or nil

		local frame = CreateFrame("Frame", name, t.parent, template)

		--| Position & dimensions

		if t.keepInBounds then frame:SetClampedToScreen(true) end
		if t.position then wt.SetPosition(frame, t.position) end
		if t.size then frame:SetSize(t.size.w, t.size.h) end

		--| Visibility

		wt.SetVisibility(frame, t.visible ~= false)
		if t.frameStrata then frame:SetFrameStrata(t.frameStrata) end
		if t.frameLevel then frame:SetFrameLevel(t.frameLevel) end
		if t.keepOnTop then frame:SetToplevel(t.keepOnTop) end

		--[ Events ]

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
			t.initialize(frame, t.size.w, t.size.h)

			--Arrange content
			if t.arrangement and frame then wt.ArrangeContent(frame, t.arrangement) end
		end

		return frame
	end

	--[ Scrollable Frame ]

	---Create an empty vertically scrollable frame
	---***
	---@param t? scrollFrameCreationData Parameters are to be provided in this table
	---@return Frame scrollChild
	---@return ScrollFrame scrollFrame
	function wt.CreateScrollFrame(t)
		t = t or {}

		--[ Frame Setup ]

		local parentName = t.parent and t.parent:GetName() or ""
		local name = t.name and t.name:gsub("%s+", "")

		local scrollFrame = CreateFrame("ScrollFrame", parentName .. (name or "") .. "ScrollParent", t.parent, ScrollControllerMixin and "ScrollFrameTemplate")

		--| Position & dimensions

		t.size = t.size or t.parent and { w = t.parent:GetWidth(), h = t.parent:GetHeight() } or { w = 0, h = 0 }

		wt.SetPosition(scrollFrame, t.position)
		scrollFrame:SetSize(t.size.w, t.size.h)

		--Scrollbar
		wt.SetPosition(scrollFrame.ScrollBar, {
			anchor = "RIGHT",
			relativeTo = scrollFrame,
			relativePoint = "RIGHT",
			offset = { x = -4, y = 0 }
		})
		scrollFrame.ScrollBar:SetHeight(t.size.h - 4)

		--[ Scroll Child ]

		--Create scrollable child frame
		local scrollChild = wt.CreateBaseFrame({
			parent = scrollFrame,
			name = parentName .. (name or "Scroller"),
			append = false,
			size = { w = t.scrollSize.w or scrollFrame:GetWidth() - (wt.classic and 32 or 16), h = t.scrollSize.h },
			initialize = t.initialize,
			arrangement = t.arrangement
		})

		--Register for scroll
		scrollFrame:SetScrollChild(scrollChild)

		--Update scroll speed
		t.scrollSpeed = t.scrollSpeed or 0.25

		--Override the built-in update function
		scrollFrame.ScrollBar.SetPanExtentPercentage = function() --WATCH: Change when Blizzard provides a better way
			local height = scrollFrame:GetHeight()
			scrollFrame.ScrollBar.panExtentPercentage = height * t.scrollSpeed / math.abs(scrollChild:GetHeight() - height)
		end

		return scrollChild, scrollFrame
	end

	--[ Panel Frame ]

	---Create a new simple panel frame
	---***
	---@param t? panelCreationData Parameters are to be provided in this table
	---***
	---@return panel? panel Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame) overloaded with custom fields or nil if **WidgetToolsDB.lite** is true**
	function wt.CreatePanel(t)
		t = t or {}

		if WidgetToolsDB.lite and t.lite ~= false then return wt.CreateBaseFrame(t) end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Panel")

		---@class panel : Frame
		---@field title? FontString Reference to the title textline appearing above the panel
		---@field description? FontString Reference to the description textline appearing in the panel
		---@field arrangementInfo? arrangementRules These parameters specify how to position the panel within its parent container frame during automatic content arrangement
		local panel = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

		--| Position & dimensions

		t.size = t.size or {}
		t.size.w = t.size.w or t.parent and t.parent:GetWidth() - 32 or 0
		t.size.h = t.size.h or 0

		if t.keepInBounds then panel:SetClampedToScreen(true) end
		if t.arrange then panel.arrangementInfo = t.arrange else wt.SetPosition(panel, t.position) end
		panel:SetSize(t.size.w, t.size.h)

		--| Visibility

		wt.SetVisibility(panel, t.visible ~= false)
		if t.frameStrata then panel:SetFrameStrata(t.frameStrata) end
		if t.frameLevel then panel:SetFrameLevel(t.frameLevel) end
		if t.keepOnTop then panel:SetToplevel(t.keepOnTop) end

		--| Title & description

		panel.title, panel.description = wt.AddTitle({
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

		--| Backdrop

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

		--[ Events ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do panel:HookScript(key, value) end end

		--[ Initialization ]

		--Add content, performs tasks
		if t.initialize then
			t.initialize(panel, t.size.w, t.size.h)

			--Arrange content
			if t.arrangement then wt.ArrangeContent(panel, wt.AddMissing(t.arrangement, { parameters = { margins = { t = t.description and 30 or nil, }, }, })) end
		end

		return panel
	end

	--[ Context Menu ]

	---Create an empty context menu frame
	---***
	---@param t? contextMenuCreationData Parameters are to be provided in this table
	---***
	---@return contextMenu|nil menu Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame) overloaded with custom fields and utility functions
	---***
	---***Custom Attributes • [OnAttributeChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) Events:***
	--- - **"open"** — Invoked when the context menu is opened or closed<hr><p>@*param* `self` Frame ― Reference to the context menu frame</p><p>@*param* `attribute` string ― Unique attribute key used to identify which OnAttributeChanged event to handle</p><p>@*param* `state` boolean ― True if the context menu is open, false if not</p><hr><p>***Example:*** Add a script handler as listener:</p><p></p>
	--- 	```
	--- 	contextMenu:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 		if attribute ~= "open" then return end
	--- 		--Do something
	--- 	end)
	--- 	```
	function wt.CreateContextMenu(t)
		t = t or {}

		if not t.parent then return end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "ContextMenu")

		---@class contextMenu : Frame
		---@field items table List of references to the content items added to this context menu<ul><li>***Example:*** Register an existing list item with `table.insert(contextMenu.items, item)`.</li></ul>
		---@field submenus table List of submenu frame references folding out of this context menu<ul><li>***Example:*** Add an existing submenu to the list with `table.insert(contextMenu.submenus, submenu)`.</li></ul>
		local menu = CreateFrame("Frame", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

		menu.items = {}
		menu.submenus = {}

		--| Position & dimensions

		menu:SetClampedToScreen(true)
		if t.cursor == false then wt.SetPosition(menu, t.position) end
		menu:SetSize(t.width or 140, 20)

		--| Visibility

		menu:SetFrameStrata("DIALOG")

		--| Backdrop

		wt.SetBackdrop(menu, {
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
			for i = 1, #menu.submenus do if menu.submenus[i]:IsMouseOver() then return true end end
			return false
		end

		--Base state
		menu:Hide()
		menu:SetAttributeNoHandler("open", false)

		--Invoke events
		menu:HookScript("OnShow", function() menu:SetAttribute("open", true) end)
		menu:HookScript("OnHide", function() menu:SetAttribute("open", false) end)

		--Pass global events to handlers
		menu:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)

		--| Open

		t.parent:HookScript("OnMouseUp", function(_, button, isInside)
			if not enabled then return end

			if button == "RightButton" and isInside then
				menu:RegisterEvent("GLOBAL_MOUSE_DOWN")

				--Open the menu
				menu:Show()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

				--Position
				if t.cursor ~= false then
					local x, y = GetCursorPosition()
					local s = UIParent:GetEffectiveScale()
					menu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
				end
			end
		end)

		--| Close

		function menu:GLOBAL_MOUSE_DOWN(button)
			if button == "LeftButton" or button == "RightButton" and not t.parent:IsMouseOver() and not menu:IsMouseOver() then
				menu:UnregisterEvent("GLOBAL_MOUSE_DOWN")
				menu:RegisterEvent("GLOBAL_MOUSE_UP")
			end
		end

		function menu:GLOBAL_MOUSE_UP(button)
			if (button == "LeftButton" or button == "RightButton") and not t.parent:IsMouseOver() and not menu:IsMouseOver() and not checkSubmenus() then
				menu:UnregisterEvent("GLOBAL_MOUSE_UP")

				--Close the menu
				menu:Hide()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end
		end

		--[ Getters & Setters ]

		---Check if the context menu is active
		---@return boolean
		function menu.isEnabled() return enabled end

		---Activate or deactivate the context menu
		---***
		---@param state? boolean Activate it if true, deactivate if not | ***Default:*** true
		function menu.setEnabled(state)
			enabled = state ~= false

			if not enabled then
				menu:UnregisterEvent("GLOBAL_MOUSE_DOWN")
				menu:UnregisterEvent("GLOBAL_MOUSE_UP")

				--Close the menu
				menu:Hide()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end

			--Invoke an event
			menu.frame:SetAttribute("enabled", state)
		end

		return menu
	end

	---Create an empty submenu as an item for an existing context menu
	---***
	---@param contextMenu contextMenu Reference to the context menu to add this submenu to
	---@param t? contextSubmenuCreationData Parameters are to be provided in this table
	---***
	---@return contextSubmenu submenu Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame) overloaded with custom fields and utility functions
	---@return Button toggle Reference to the toggle button list item of the submenu (placed in its parent context menu)
	---***
	---***Custom Attributes • [OnAttributeChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) Events:***
	--- - **"open"** ― Invoked when the context menu is opened or closed<hr><p>@*param* `self` Frame ― Reference to the context menu frame</p><p>@*param* `attribute` string ― Unique attribute key used to identify which OnAttributeChanged event to handle</p><p>@*param* `state` boolean ― True if the context menu is open, false if not</p><hr><p>***Example:*** Add a script handler as listener:</p><p></p>
	--- 	```
	--- 	submenu:HookScript("OnAttributeChanged", function(self, attribute, state)
	--- 		if attribute ~= "open" then return end
	--- 		--Do something
	--- 	end)
	--- 	```
	function wt.AddContextSubmenu(contextMenu, t)
		t = t or {}

		--[ Toggle Item ]

		local defaultName = "Item" .. #contextMenu.items + 1
		local name = (t.append ~= false and contextMenu:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or defaultName)

		local toggle = CreateFrame("Button", name, contextMenu, BackdropTemplateMixin and "BackdropTemplate")

		--Add to the context menu
		table.insert(contextMenu.items, toggle)

		--Increase the context menu height
		local contextHeight = contextMenu:GetHeight()
		contextMenu:SetHeight(contextHeight + 20)

		--| Position & dimensions

		toggle:SetPoint("TOP", contextMenu, "TOP", 0, -contextHeight + 10)
		toggle:SetSize(contextMenu:GetWidth() - 20, 20)

		--| Label

		local title = t.title or t.name or defaultName

		wt.CreateText({
			parent = toggle,
			name = "Label",
			position = { anchor = "CENTER", },
			width = toggle:GetWidth(),
			text = title,
			font = t.font or "GameFontHighlightSmall",
			justify = { h = t.justify or t.leftSide and "RIGHT" or "LEFT", },
		})

		--| Textures

		--Arrow
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

		--Background highlight
		wt.CreateTexture({
			parent = toggle,
			name = "Highlight",
			position = { anchor = "CENTER" },
			size = { w = toggle:GetWidth() + 4, h = toggle:GetHeight() - 2 },
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

		--| UX

		--Tooltip
		if t.tooltip then
			--Create a trigger to show the tooltip when the button is disabled
			toggle.hoverTarget = wt.CreateFrame("Frame", name .. "HoverTarget", toggle)
			toggle.hoverTarget:SetPoint("TOPLEFT")
			toggle.hoverTarget:SetSize(toggle:GetSize())
			toggle.hoverTarget:Hide()

			--Set the tooltip
			wt.AddTooltip(toggle, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_TOPLEFT",
				offset = { x = 20, },
			}, { triggers = { toggle.hoverTarget, }, })
		end

		--[ Flyout Menu ]

		---@class contextSubmenu : contextMenu
		local submenu = CreateFrame("Frame", name .. "Menu", contextMenu, BackdropTemplateMixin and "BackdropTemplate")

		submenu.items = {}
		submenu.submenus = {}

		--Add to the context menu
		table.insert(contextMenu.submenus, submenu)

		--| Position & dimensions

		submenu:SetClampedToScreen(true)
		submenu:SetPoint((t.leftSide or t.justify == "RIGHT") and "TOPRIGHT" or "TOPLEFT", toggle, (t.leftSide or t.justify == "RIGHT") and "TOPLEFT" or "TOPRIGHT", 0, 10)
		submenu:SetSize(t.width or 140, 20)

		--| Visibility

		submenu:SetFrameStrata("DIALOG")
		submenu:SetFrameLevel(contextMenu:GetFrameLevel() + 1)

		--| Backdrop

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

		--[ Toggle ]

		--Item mouseover utility
		local function checkItems()
			for i = 1, #submenu.items do if submenu.items[i]:IsMouseOver() then return true end end
			return false
		end

		--Fold out and open the context submenu
		function submenu.open()
			for i = 1, #contextMenu.submenus do contextMenu.submenus[i].close() end
			submenu:Show()

			--Invoke an event
			submenu:SetAttribute("open", true)
		end

		--Fold in and close the context submenu
		function submenu.close()
			submenu:Hide()

			--Invoke an event
			submenu:SetAttribute("open", false)
		end

		--Base state
		submenu:Hide()
		submenu:SetAttributeNoHandler("open", false)

		if t.hover ~= false then toggle:HookScript("OnEnter", function() submenu.open() end) else toggle:HookScript("OnClick", function() if not submenu:IsVisible() then
			submenu.open()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		else
			submenu.close()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		end end) end

		submenu:HookScript("OnLeave", function() if not checkItems() then submenu.close() end end)

		contextMenu:HookScript("OnHide", function() submenu.close() end)

		return submenu, toggle
	end

	---Create a classic context menu frame as a child of a frame
	---***
	---@param t classicContextMenuCreationData Parameters are to be provided in this table
	---@return Frame|nil contextMenu
	function wt.CreateClassicContextMenu(t)
		if not t.parent or not t.menu then return end

		--Create the context menu frame
		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "ContextMenu")
		local contextMenu = CreateFrame("Frame", name, t.parent, "UIDropDownMenuTemplate")
		--Dimensions
		UIDropDownMenu_SetWidth(contextMenu, t.width or 115)
		--Right-click event
		t.parent:HookScript("OnMouseUp", function(_, button, isInside)
			if button == "RightButton" and isInside then EasyMenu(t.menu, contextMenu, t.anchor or "cursor", (t.offset or {}).x or 0, (t.offset or {}).y or 0, "MENU") end
		end)
		return contextMenu
	end

	--[ Settings Pages ]

	---Create an new Settings Panel frame and add it to the Options
	---***
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param t? settingsPageCreationData Parameters are to be provided in this table
	---***
	---@return settingsPage page Table containing references to the options canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions
	function wt.CreateSettingsPage(addon, t)
		t = t or {}
		local width, height = 0, 0
		local defaultsWarning

		--[ Wrapper Table ]

		---@class settingsPage
		---@field canvas? Frame The settings page canvas frame to house the options widgets
		---@field category? table The registered settings category page
		---@field scroller? Frame Scrollable child frame of the [ScrollFrame](https://wowpedia.fandom.com/wiki/UIOBJECT_ScrollFrame) created as a child of **canvas** if **t.scroll** was set
		local page = {}

		--[ Getters & Setters ]

		---Returns the type of this object
		---***
		---@return WidgetType type ***Value:*** "SettingsPage"
		---<hr><p></p>
		function page.getType() return "SettingsPage" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string
		---@return boolean
		function page.isType(type) return type == "SettingsPage" end

		---Return a value at the specified key from the table used for creating the settings page
		---@param key string
		---@return any
		function page.getProperty(key) return wt.FindKey(t, key) end

		---Returns the unique identifier key representing the defaults warning popup dialogue in the global **StaticPopupDialogs** table, and used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
		---@return string
		function page.getDefaultsPopupKey() return defaultsWarning end

		--| Utilities

		---Open the Settings window to this category page
		--- - ***Note:*** No category page will be opened if **WidgetToolsDB.lite** is true.
		--- - ***Note:*** Only parent categories will be opened since the new Settings UI has been introduced. *Let's hope Blizzard fixes this soon™!*
		function page.open()
			if WidgetToolsDB.lite or not page.category then return end --ADD: tip about lite mode, how to disable it

			Settings.OpenToCategory(page.category:GetID()) --WATCH: Add support when they add support for opening to subcategories
		end

		--| Batch options data management

		---Call to force save the options in this category page
		---***
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		function page.save(user)
			--Retrieve data from settings widgets and commit to the storage table
			if t.autoSave ~= false and t.optionsKeys then for i = 1, #t.optionsKeys do wt.SaveOptionsData(t.optionsKeys[i]) end end

			--Call listener
			if t.onSave then t.onSave(user == true) end
		end

		---Call to force update the options widgets in this category page
		---***
		---@param changes? boolean Whether to call **onChange** handlers or not | ***Default:*** false
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		function page.load(changes, user)
			--Update settings widgets
			if t.autoLoad ~= false and t.optionsKeys then for i = 1, #t.optionsKeys do
				wt.LoadOptionsData(t.optionsKeys[i], changes)
				wt.SnapshotOptionsData(t.optionsKeys[i])
			end end

			--Call listener
			if t.onLoad then t.onLoad(user == true) end
		end

		---Call to cancel any changes made in this category page and reload all linked widget data
		---***
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		function page.cancel(user)
			--Update settings widgets
			if t.optionsKeys then for i = 1, #t.optionsKeys do wt.RevertOptionsData(t.optionsKeys[i]) end end

			--Call listener
			if t.onCancel then t.onCancel(user == true) end
		end

		---Call to reset all options in this category page to their default values
		---***
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		function page.defaults(user)
			--Update with default values
			if t.storage then for i = 1, #t.storage do wt.CopyValues(t.storage[i].storageTable, t.storage[i].defaultsTable) end end

			--Update settings widgets
			if t.optionsKeys then for i = 1, #t.optionsKeys do wt.LoadOptionsData(t.optionsKeys[i], true) end end

			--Call listener
			if t.onDefaults then t.onDefaults(user == true) end
		end

		--[ Settings Page ]

		if not WidgetToolsDB.lite then

			--[ Canvas Frame ]

			t.name = t.name and t.name:gsub("%s+", "")
			width, height = SettingsPanel.Container.SettingsCanvas:GetSize()

			page.canvas = wt.CreateBaseFrame({
				name = (t.append ~= false and t.name and addon or "") .. (t.name or addon) .. (t.appendOptions ~= false and "Options" or ""),
				size = { w = width, h = height },
				visible = false,
			})

			--| Title & description

			local title = t.title or wt.Clear(GetAddOnMetadata(addon, "title")):gsub("^%s*(.-)%s*$", "%1")

			--Title & description
			page.title, page.description = wt.AddTitle({
				parent = page.canvas,
				title = {
					offset = { x = 10, y = -16 },
					width = width - (t.icon and 72 or 32),
					text = title,
					font = "GameFontNormalLarge",
				},
				description = t.description and {
					offset = { y = -8 },
					width = width - (t.icon and 72 or 32),
					text = t.description,
				} or nil
			})

			--| Icon texture

			local icon = t.icon or GetAddOnMetadata(addon, "IconTexture")

			if icon then page.icon = wt.CreateTexture({
				parent = page.canvas,
				name = "Logo",
				position = {
					anchor = "TOPRIGHT",
					offset = { x = -16, y = -16 }
				},
				size = { w = 36, h = 36 },
				path = icon,
			}) end

			--[ Utility Widgets ]

			--Add save notice text
			wt.CreateText({
				parent = page.canvas,
				name = "SaveNotice",
				position = {
					anchor = "BOTTOMRIGHT",
					offset = { x = -106, y = -26.75 }
				},
				text = ns.toolboxStrings.settings.save,
			})

			wt.CreateButton({
				parent = page.canvas,
				name = "Cancel",
				title = ns.toolboxStrings.settings.cancel.label,
				tooltip = { lines = { { text = ns.toolboxStrings.settings.cancel.tooltip, }, } },
				position = {
					anchor = "BOTTOMLEFT",
					offset = { x = 138, y = -31 }
				},
				size = { w = 140, },
				action = function() page.cancel(true) end,
				disabled = t.static,
			})

			defaultsWarning = wt.CreatePopupDialogueData(addon, (t.name or "") .. "_Defaults", {
				text = ns.toolboxStrings.settings.warningSingle:gsub("#PAGE", wt.Color(title, colors.highlight)),
				accept = ACCEPT,
				onAccept = function() page.defaults(true) end
			})

			wt.CreateButton({
				parent = page.canvas,
				name = "Defaults",
				title = ns.toolboxStrings.settings.defaults.label,
				tooltip = { lines = { { text = ns.toolboxStrings.settings.defaults.tooltip, }, } },
				position = {
					anchor = "BOTTOMLEFT",
					offset = { x = -18, y = -31 }
				},
				size = { w = 140, },
				action = function() StaticPopup_Show(defaultsWarning) end,
				disabled = t.static,
			})

			--[ Make Scrollable ]

			if t.scroll then
				page.scroller = wt.CreateScrollFrame({
					parent = page.canvas,
					position = { offset = { x = 0, y = -4 } },
					size = { w = width - 8, h = height - 16 },
					scrollSize = { h = t.scroll.height, },
					scrollSpeed = t.scroll.speed
				})

				--| Reparent, reposition and resize default elements

				page.title:SetParent(page.scroller)
				page.title:SetPoint("TOPLEFT", 10, -12)
				page.title:SetWidth(page.title:GetWidth() - 20)

				if page.description then
					page.description:SetParent(page.scroller)
					page.description:SetWidth(page.description:GetWidth() - 20)
				end

				if page.icon then
					page.icon:SetParent(page.scroller)
					page.icon:SetPoint("TOPRIGHT", -16, -12)
				end
			end
		end

		--[ Initialization ]

		--Register to the Settings panel
		if t.register then
			local parent = type(t.register) == "table" and type(t.register.isType) == "function" and t.register.isType("SettingsPage") and t.register or nil

			wt.RegisterSettingsPage(page, parent, t.titleIcon)
		end

		--Add content, performs tasks
		if t.initialize then
			t.initialize(page.scroller or page.canvas, width, height)

			--Arrange content
			if t.arrangement and page.canvas then wt.ArrangeContent(page.scroller or page.canvas, wt.AddMissing(t.arrangement, { parameters = {
				margins = { l = 10, r = 10, t = t.scroll and 78 or 82, b = t.scroll and 10 or 22 },
				gaps = 32,
				resize = t.scroll ~= nil
			}, })) end
		end

		return page
	end

	---Create an new Settings category with a parent page, its child pages, and set up shared options data management for them
	---***
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param parent settingsPageCreationData|settingsPage Settings page creation parameters to create, or reference to an existing *unregistered* settings page to set as the parent page for the new category
	--- - ***Note:*** If the provided parent candidate page is already registered (containing a **category** value), it will be dismissed and no new category will be created at all.
	---@param pages? settingsPageCreationData[]|settingsPage[] List of settings page creation parameters to create, or references to an existing *unregistered* settings pages to add as subcategories under **parent**
	--- - ***Note:*** Already registered pages (which contain a **category** value) will be skipped and won't be included in the new category.
	---@param t? settingsCategoryCreationData Parameters are to be provided in this table
	---***
	---@return optionsCategory? category Table containing references to settings pages and utility functions or nil if the specified **parent** was invalid
	function wt.CreateSettingsCategory(addon, parent, pages, t)
		if not addon or type(parent) ~= "table" and not parent.category then return end

		t = t or {}

		--[ Wrapper Table ]

		---@class optionsCategory
		---@field pages settingsPage[]
		local category = { pages = {} }

		--[ Utilities ]

		--| Batch options data management

		---Call to force update the options widgets for all pages in this category
		---***
		---@param changes? boolean Whether to call **onChange** handlers or not | ***Default:*** false
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		function category.load(changes, user)
			for i = 1, #category.pages do category.pages[i].load(changes, user) end

			--Call listener
			if t.onLoad then t.onLoad(user == true) end
		end

		---Call to reset all options to their default values for all pages in this category
		---***
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		---@param callListeners? boolean If true, call the **onDefaults** listeners (if set) of each individual category page separately | ***Default:*** false
		function category.defaults(user, callListeners)
			for i = 1, #category.pages do
				local storage = category.pages[i].getProperty("storage")
				local optionsKeys = category.pages[i].getProperty("optionsKeys")
				local onDefaults = category.pages[i].getProperty("onDefaults")

				--Update with default values
				if storage then for i = 1, #storage do wt.CopyValues(storage[i].storageTable, storage[i].defaultsTable) end end

				--Update settings widgets
				if optionsKeys then for i = 1, #optionsKeys do wt.LoadOptionsData(optionsKeys[i], true) end end

				--Call listeners
				if callListeners and onDefaults then onDefaults(user == true) end
			end

			--Call listener
			if t.onDefaults then t.onDefaults(user == true) end
		end

		--[ Category Pages ]

		--| Parent

		local parentTitle = parent.title and parent.title:GetText() or ""

		if type(parent.isType) ~= "function" and not parent.isType("SettingsPage") then parent = wt.CreateSettingsPage(addon, parent) end

		table.insert(category.pages, parent)

		wt.RegisterSettingsPage(parent)

		--Override defaults warning and add all defaults option to dialogue
		wt.UpdatePopupDialogueData(parent.getDefaultsPopupKey(), {
			text = ns.toolboxStrings.settings.warning:gsub("#CATEGORY", wt.Color(parentTitle, colors.highlight)):gsub("#PAGE", wt.Color(parentTitle, colors.highlight)),
			accept = ALL_SETTINGS,
			alt = CURRENT_SETTINGS,
			onAccept = category.defaults,
			onAlt = function() parent.defaults(true) end
		})

		--| Subcategories

		for i = 1, #pages do if type(pages[i]) == "table" and not pages[i].category then
			if type(pages[i].isType) ~= "function" and not pages[i].isType("SettingsPage") then pages[i] = wt.CreateSettingsPage(addon, pages[i]) end

			table.insert(category.pages, pages[i])

			wt.RegisterSettingsPage(pages[i], parent, pages[i].getProperty("titleIcon"))

			--Override defaults warning and add all defaults option to dialogue
			wt.UpdatePopupDialogueData(pages[i].getDefaultsPopupKey(), {
				text = ns.toolboxStrings.settings.warning:gsub("#CATEGORY", wt.Color(parentTitle, colors.highlight)):gsub(
					"#PAGE", wt.Color(pages[i].title and pages[i].title:GetText() or "", colors.highlight)
				),
				accept = ALL_SETTINGS,
				alt = CURRENT_SETTINGS,
				onAccept = category.defaults,
				onAlt = function() pages[i].defaults(true) end
			})
		end end

		return category
	end


	--[[ WIDGETS ]]

	--[ Button ]

	---Create a button frame as a child of a container frame
	---***
	---@param t? buttonCreationData Parameters are to be provided in this table
	---***
	---@return actionButton button References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table
	function wt.CreateButton(t)
		t = t or {}
		local name, title, useHighlight

		--[ Wrapper Table ]

		---@class actionButton
		---@field hoverTarget? Frame
		local button = {}

		--[ Getters & Setters ]

		---Hook a handler function as a listener for an [OnAttributeChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) script event for a custom widget attribute
		---***
		---@param type string|ButtonAttributes Name of the custom attribute of **button.widget** to identify invoked events with
		---@param listener fun(state: boolean)|fun(...: any) Handler function to call when the events triggers
		--- - ***Overloads:***
		--- 	- **type** == "enabled"<p>Invoked after **button.setEnabled(...)** was called</p><hr><p>@*param* `state` boolean ― Whether the widget is enabled</p>
		---***
		---<p></p>
		function button.setListener(type, listener)
			if not button.widget then return end

			button.widget:HookScript("OnAttributeChanged", function(_, attribute, ...)
				if attribute ~= type then return end

				listener(...)
			end)
		end

		---Enable or disable the button widget based on the specified value
		---***
		---@param state boolean Enable the input if true, disable if not
		function button.setEnabled(state)
			if not button.widget then return end

			button.widget:SetEnabled(state)

			if state then
				if button.label then
					if useHighlight and button.widget:IsMouseOver() then button.label:SetFontObject(t.font.highlight) else button.label:SetFontObject(t.font.normal) end
				end
				if button.hoverTarget then button.hoverTarget:Hide() end
			else
				if button.label then button.label:SetFontObject(t.font.disabled) end
				if button.hoverTarget then button.hoverTarget:Show() end
			end

			--Invoke an event
			button.widget:SetAttribute("enabled", state)
		end

		---Modify the tooltip set for the button with this to make sure it works even when the button is disabled
		---***
		---@param tooltip? widgetTooltipTextData List of text lines to set as the tooltip of the button | ***Default:*** **t.tooltip** or *no changes will be made*
		function button.setTooltip(tooltip)
			if not button.widget then return end

			tooltip = tooltip or t.tooltip

			if not tooltip then return end

			--Create a trigger to show the tooltip when the button is disabled
			if not button.hoverTarget then
				button.hoverTarget = wt.CreateFrame("Frame", name .. "HoverTarget", button.widget)
				button.hoverTarget:SetPoint("TOPLEFT")
				button.hoverTarget:SetSize(button.widget:GetSize())
				button.hoverTarget:Hide()
			end

			--Set the tooltip
			wt.AddTooltip(button.widget, {
				title = tooltip.title or title,
				lines = tooltip.lines,
				anchor = "ANCHOR_TOPLEFT",
				offset = { x = 20, },
			}, { triggers = { button.hoverTarget, }, })
		end

		---Trigger the action registered for the button
		---@param user? boolean Whether to flag the action as being initiated by a user interaction or not | ***Default:*** false
		function button.trigger(user)
			if t.action then t.action(button, user) end
		end

		--[ GUI Widget ]

		if not WidgetToolsDB.lite or t.lite == false then

			--[ Frame Setup ]

			name = (t.append ~= false and t.parent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Button")
			local custom = t.customizable and (BackdropTemplateMixin and "BackdropTemplate") or nil

			button.widget = wt.CreateFrame("Button", name, t.parent, custom or "UIPanelButtonTemplate")

			--| Position & dimensions

			t.size = t.size or {}
			t.size.w = t.size.w or 80
			t.size.h = t.size.h or 22

			if t.arrange then button.widget.arrangementInfo = t.arrange else wt.SetPosition(button.widget, t.position) end
			button.widget:SetSize(t.size.w, t.size.h)

			--| Visibility

			wt.SetVisibility(button.widget, t.visible ~= false)
			if t.frameStrata then button.widget:SetFrameStrata(t.frameStrata) end
			if t.frameLevel then button.widget:SetFrameLevel(t.frameLevel) end
			if t.keepOnTop then button.widget:SetToplevel(t.keepOnTop) end

			--| Label

			title = t.title or t.name or "Button"
			local customFonts = custom or t.font ~= nil
			t.font = t.font or {}
			useHighlight = t.font.highlight or custom ~= nil
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
					if not custom then _G[name .. "Text"]:Hide() end
				else button.label = _G[name .. "Text"] end

				if t.titleOffset then button.label:SetPoint("CENTER", t.titleOffset.x or 0, t.titleOffset.y or 0) end

				button.label:SetText(title)
			elseif not custom then _G[name .. "Text"]:Hide() end

			--[ Events ]

			--Register script event handlers
			if t.events then for key, value in pairs(t.events) do button.widget:HookScript(key, value) end end

			--Register attribute event handlers
			if t.attributeEvents then for key, value in pairs(t.attributeEvents) do button.setListener(key, value) end end

			--| UX

			button.widget:HookScript("OnClick", function()
				if t.action then t.action(button, true) end

				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			end)

			if button.label and useHighlight then
				button.widget:HookScript("OnEnter", function() button.label:SetFontObject(t.font.highlight) end)
				button.widget:HookScript("OnLeave", function() button.label:SetFontObject(t.font.normal) end)
			end

			--Tooltip
			if t.tooltip then button.setTooltip() end

			--State & dependencies
			if t.disabled then button.setEnabled(false) else button.widget:SetAttributeNoHandler("enabled", true) end
			if t.dependencies then wt.AddDependencies(t.dependencies, button.setEnabled) end
		end

		return button
	end

	---Create a button widget as a child of a context menu frame
	---***
	---@param contextMenu contextMenu|contextSubmenu Reference to the context menu to add this button to
	---@param mainContextMenu? contextMenu Reference to the root context menu to hide after clicking the button | ***Default:*** **contextMenu**
	---@param t? contextButtonCreationData Parameters are to be provided in this table
	---***
	---@return contextButton contextButton Reference to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button) overloaded with custom fields and utility functions
	function wt.AddContextButton(contextMenu, mainContextMenu, t)
		mainContextMenu = mainContextMenu or contextMenu
		t = t or {}

		--[ Frame Setup ]

		local defaultName = "Item" .. #contextMenu.items + 1
		local name = (t.append ~= false and contextMenu:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or defaultName)

		---@class contextButton : Button
		---@field hoverTarget Frame
		local button = CreateFrame("Button", name, contextMenu, BackdropTemplateMixin and "BackdropTemplate")

		--| Register

		--Add to the context menu
		table.insert(contextMenu.items, button)

		--Increase the context menu height
		local contextHeight = contextMenu:GetHeight()
		contextMenu:SetHeight(contextHeight + 20)

		--| Position & dimensions

		button:SetPoint("TOP", contextMenu, "TOP", 0, -contextHeight + 10)
		button:SetSize(contextMenu:GetWidth() - 20, 20)

		--| Label

		local title = t.title or t.name or defaultName
		t.font = t.font or {}
		local useHighlight = t.font.highlight ~= nil
		t.font.normal = t.font.normal or "GameFontHighlightSmall"
		t.font.highlight = t.font.highlight or "GameFontHighlightSmall"
		t.font.disabled = t.font.disabled or "GameFontDisableSmall"

		button.label = wt.CreateText({
			parent = button,
			name = "Label",
			position = { anchor = "CENTER", },
			width = button:GetWidth(),
			text = title,
			font = t.font.normal,
			justify = { h = t.justify or "LEFT", },
		})

		--| Textures

		--Background highlight
		wt.CreateTexture({
			parent = button,
			name = "Highlight",
			position = { anchor = "CENTER" },
			size = { w = button:GetWidth() + 4, h = button:GetHeight() - 2 },
			path = textures.contextBG,
			color = colors.context.normal
		}, {
			OnEnter = { rule = function() return { color = IsMouseButtonDown() and colors.context.click or colors.context.highlight } end },
			OnLeave = {},
			OnHide = {},
			OnMouseDown = { rule = function(self) return self:IsEnabled() and { color = colors.context.click } or {} end },
			OnMouseUp = { rule = function(self) return self:IsEnabled() and self:IsMouseOver() and { color = colors.context.highlight } or {} end },
		})

		--[ Getters & Setters ]

		---Enable or disable the button widget based on the specified value
		---***
		---@param state boolean Enable the input if true, disable if not
		function button.setEnabled(state)
			button:SetEnabled(state)

			if state then
				if useHighlight and button:IsMouseOver() then button.label:SetFontObject(t.font.highlight) else button.label:SetFontObject(t.font.normal) end
				if button.hoverTarget then button.hoverTarget:Hide() end
			else
				button.label:SetFontObject(t.font.disabled)
				if button.hoverTarget then button.hoverTarget:Show() end
			end

			--Invoke an event
			button:SetAttribute("enabled", state)
		end

		--[ Events ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do button:HookScript(key, value) end end

		--| UX

		button:HookScript("OnClick", function()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

			--Close the root menu
			mainContextMenu:Hide()
		end)

		if useHighlight then
			button:HookScript("OnEnter", function() button.label:SetFontObject(t.font.highlight) end)
			button:HookScript("OnLeave", function() button.label:SetFontObject(t.font.normal) end)
		end

		--Tooltip
		if t.tooltip then
			--Create a trigger to show the tooltip when the button is disabled
			button.hoverTarget = wt.CreateFrame("Frame", name .. "HoverTarget", button)
			button.hoverTarget:SetPoint("TOPLEFT")
			button.hoverTarget:SetSize(button:GetSize())
			button.hoverTarget:Hide()

			--Set the tooltip
			wt.AddTooltip(button, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_TOPLEFT",
				offset = { x = 20, },
			}, { triggers = { button.hoverTarget, }, })
		end

		--State & dependencies
		if t.disabled then button.setEnabled(false) end
		if t.dependencies then wt.AddDependencies(t.dependencies, button.setEnabled) end

		return button
	end

	--[ Toggle ]

	---Set the parameters of a toggle widget
	---@param widget checkbox|radioButton
	---@param t toggleCreationData
	local function SetUpToggle(widget, t)
		---@class toggle
		local toggle = widget

		--[ Getters & Setters ]

		---Returns the object type of this widget
		---***
		---@return WidgetType type ***Value:*** "Toggle"
		---<hr><p></p>
		function toggle.getType() return "Toggle" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string
		---@return boolean
		function toggle.isType(type) return type == "Toggle" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function toggle.getProperty(key) return wt.FindKey(t, key) end

		---Hook a handler function as a listener for an [OnAttributeChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) script event for a custom widget attribute
		---***
		---@param type string|ToggleAttributes Name of the custom attribute of **selector.frame** to identify invoked events with
		---@param listener fun(state: boolean)|fun(value: toggleAttributeValueData)|fun(...: any) Handler function to call when the events triggers
		--- - ***Overloads:***
		--- 	- **type** == "enabled"<p>Invoked after **toggleFrame.setEnabled(...)** was called</p><hr><p>@*param* `state` boolean ― Whether the widget is enabled</p><p></p>
		--- 	- **type** == "loaded"<p>Invoked when options data is loaded automatically</p><hr><p>@*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true</p><p></p>
		--- 	- **type** == "toggled"<p>Invoked after **toggleFrame.setState(...)** was called or an option was clicked or cleared</p><hr><p>@*param* `value` toggleAttributeValueData ― Payload of the event wrapped in a table</p>
		---***
		---<p></p>
		function toggle.setListener(type, listener)
			if not toggle.frame then return end

			toggle.frame:HookScript("OnAttributeChanged", function(_, attribute, ...)
				if attribute ~= type then return end

				listener(...)
			end)
		end

		---Enable or disable the widget based on the specified value
		---***
		---@param state boolean Enable the input if true, disable if not
		function toggle.setEnabled(state)
			if not toggle.widget then return end

			toggle.widget:SetEnabled(state)

			if toggle.label then toggle.label:SetFontObject(state and "GameFontHighlight" or "GameFontDisable") end

			--Invoke an event
			toggle.frame:SetAttribute("enabled", state)
		end

		---Returns the current toggle state of the widget or the data stored in the storage table (if specified) in lite mode
		---@return boolean|nil
		function toggle.getState()
			if toggle.widget then return toggle.widget:GetChecked() else return toggle.getData() end
		end

		---Set the state of the widget inside the toggle frame (whether it's checked or not)
		---***
		---@param state? boolean ***Default:*** false
		---@param user? boolean Whether to flag the change as being done by a user interaction or not | ***Default:*** false
		function toggle.setState(state, user)
			if not toggle.widget then
				toggle.saveData(state == true)

				return
			end

			toggle.widget:SetChecked(state == true)

			--Invoke an event
			toggle.frame:SetAttribute("toggled", { user = user == true, state = state == true })
		end

		---Flip the current state of the widget inside the toggle frame (whether it's checked or not)
		---***
		---@param user? boolean Whether to flag the change as being done by a user interaction or not | ***Default:*** false
		--- - ***Note:*** When true, a click action will be simulated on the CheckButton as if interacted with by the user.
		function toggle.toggleState(user)
			if not toggle.widget then
				toggle.saveData(not toggle.getData())

				return
			end

			local state = not toggle.widget:GetChecked()

			if user then toggle.widget:Click() else
				toggle.widget:SetChecked(state)

				--Invoke an event
				toggle.frame:SetAttribute("toggled", { user = user == false, state = state })
			end
		end

		--| Options data management

		local snapshot

		---Load the data from the specified storage table under the specified storage key to the widget
		---***
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function toggle.loadData(handleChanges) wt.LoadWidgetData(toggle, t.optionsData, function(data)
			data = data == true

			toggle.setState(data)

			return data
		end, handleChanges) end

		---Save the provided data or the current value of the widget to the specified storage table under the specified storage key
		---***
		---@param state? boolean Data to be saved | ***Default:*** *the currently set value of the widget*
		function toggle.saveData(state) wt.SaveWidgetData(toggle, t.optionsData, function()
			if state == nil then return toggle.getState() else return state end
		end) end

		---Save the provided data to the specified storage table under the specified storage key then load it to the widget
		---***
		---@param state? boolean Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function toggle.setData(state, handleChanges)
			toggle.saveData(state)
			toggle.loadData(handleChanges)
		end

		---Get the currently stored data from the specified storage table under the specified storage key
		---@param unconverted? boolean If true, use the specified convert function when reading the data, or if not true, return the raw data unconverted | ***Default:*** false
		---@return any
		function toggle.getData(unconverted) return wt.GetWidgetData(t.optionsData, unconverted) end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **toggle.revertData()**
		function toggle.snapshotData() snapshot = toggle.getData() end

		--Set and load the stored data managed by the widget to the last saved data snapshot set via **toggle.snapshotData()**
		function toggle.revertData() toggle.setData(snapshot) end

		--[ GUI Widget ]

		if not WidgetToolsDB.lite then

			--[ Frame Setup ]

			--| Position & dimensions

			if t.arrange then toggle.frame.arrangementInfo = t.arrange else wt.SetPosition(toggle.frame, t.position) end
			toggle.widget:SetPoint("TOPLEFT")
			toggle.frame:SetSize(t.size.w, t.size.h)
			toggle.widget:SetSize(t.size.h, t.size.h) --1:1 aspect ratio applies

			--| Visibility

			wt.SetVisibility(toggle.frame, t.visible ~= false)
			if t.frameStrata then toggle.frame:SetFrameStrata(t.frameStrata) end
			if t.frameLevel then toggle.frame:SetFrameLevel(t.frameLevel) end
			if t.keepOnTop then toggle.frame:SetToplevel(t.keepOnTop) end

			--Update the frame order
			toggle.frame:SetFrameLevel(toggle.frame:GetFrameLevel() + 1)
			toggle.widget:SetFrameLevel(toggle.widget:GetFrameLevel() - 2)

			--[ Events ]

			--Register script event handlers
			if t.events then for key, value in pairs(t.events) do
				if key == "OnClick" then toggle.widget:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
				else toggle.widget:HookScript(key, value) end
			end end

			--Register attribute event handlers
			if t.attributeEvents then for key, value in pairs(t.attributeEvents) do toggle.setListener(key, value) end end

			--Tooltip
			if t.tooltip then wt.AddTooltip(toggle.frame, {
				title = t.tooltip.title or t.title or t.name or "Toggle",
				lines = t.tooltip.lines,
				anchor = "ANCHOR_NONE",
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = toggle.widget,
					relativePoint = "TOPRIGHT",
				},
			}, { triggers = { toggle.widget, }, }) end

			--State & dependencies
			if t.disabled then toggle.setEnabled(false) else toggle.frame:SetAttributeNoHandler("enabled", true) end
			if t.dependencies then wt.AddDependencies(t.dependencies, toggle.setEnabled) end
		end

		--[ Options Data ]

		--Register to the options data management
		if t.optionsData then wt.AddToOptionsTable(toggle, t.optionsData) end
	end

	---Create a checkbox frame as a child of a container frame
	---***
	---@param t? toggleCreationData Parameters are to be provided in this table
	---***
	---@return checkbox toggle References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
	function wt.CreateCheckbox(t)
		t = t or {}

		--[ Wrapper Table ]

		---@class checkbox: toggle
		local toggle = {}

		--[ GUI Widget ]

		if not WidgetToolsDB.lite then

			--[ Frame Setup ]

			local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")

			--Click target
			toggle.frame = wt.CreateFrame("Frame", name, t.parent)

			--Checkbox
			toggle.widget = wt.CreateFrame("CheckButton", name .. "Checkbox", toggle.frame, "InterfaceOptionsCheckButtonTemplate")

			--| Label

			local title = t.title or t.name or "Toggle"

			if t.label ~= false then
				toggle.label = _G[name .. "CheckboxText"]

				toggle.label:SetPoint("LEFT", toggle.widget, "RIGHT", 2, 0)
				toggle.label:SetFontObject("GameFontHighlight")

				toggle.label:SetText(title)
			else _G[name .. "CheckboxText"]:Hide() end
		end

		--[ Widget Setup ]

		t.size = t.size or {}
		t.size.h = t.size.h or 26
		t.size.w = t.label == false and t.size.h or t.size.w or 180

		SetUpToggle(toggle, t)

		--[ Events ]

		if not WidgetToolsDB.lite then

			--| UX

			toggle.widget:HookScript("OnClick", function(self)
				local state = self:GetChecked()

				PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

				--Invoke an event
				toggle.frame:SetAttribute("toggled", { user = true, state = state })

				--Manage data & call listeners
				if t.optionsData then
					toggle.saveData()

					--Call onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end
			end)

			--Linked mouse interactions
			toggle.frame:HookScript("OnEnter", function() if toggle.widget:IsEnabled() then
				toggle.widget:LockHighlight()
				if IsMouseButtonDown("LeftButton") or (IsMouseButtonDown("RightButton")) then toggle.widget:SetButtonState("PUSHED") end
			end end)
			toggle.frame:HookScript("OnLeave", function() if toggle.widget:IsEnabled() then
				toggle.widget:UnlockHighlight()
				toggle.widget:SetButtonState("NORMAL")
			end end)
			toggle.frame:HookScript("OnMouseDown", function(_, button) if toggle.widget:IsEnabled() and button == "LeftButton" or (button == "RightButton") then
				toggle.widget:SetButtonState("PUSHED")
			end end)
			toggle.frame:HookScript("OnMouseUp", function(_, button, isInside) if toggle.widget:IsEnabled() then
				toggle.widget:SetButtonState("NORMAL")

				if isInside and button == "LeftButton" or (button == "RightButton") then toggle.widget:Click(button) end
			end end)
		end

		return toggle
	end

	---Create a radio button frame as a child of a container frame
	---***
	---@param t? radioButtonCreationData Parameters are to be provided in this table
	---***
	---@return radioButton toggle References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
	function wt.CreateRadioButton(t)
		t = t or {}

		--[ Wrapper Table ]

		---@class radioButton: toggle
		local toggle = {}

		--[ GUI Widget ]

		if not WidgetToolsDB.lite then

			--[ Frame Setup ]

			local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")

			--Click target
			toggle.frame = wt.CreateFrame("Frame", name, t.parent)

			--Radio button
			toggle.widget = wt.CreateFrame("CheckButton", name .. "RadioButton", toggle.frame, "UIRadioButtonTemplate")

			--| Label

			local title = t.title or t.name or "Toggle"

			if t.label ~= false then
				toggle.label = _G[name .. "RadioButtonText"]

				toggle.label:SetPoint("LEFT", toggle.widget, "RIGHT", 3, 0)
				toggle.label:SetFontObject("GameFontHighlightSmall")

				toggle.label:SetText(title)
			else _G[name .. "RadioButtonText"]:Hide() end
		end

		--[ Widget Setup ]

		t.size = t.size or {}
		t.size.h = t.size.h or 16
		t.size.w = t.label == false and t.size.h or t.size.w or 160

		SetUpToggle(toggle, t)

		--[ Events ]

		if not WidgetToolsDB.lite then

			--| UX

			toggle.widget:HookScript("OnClick", function(self, button)
				if button == "LeftButton" then
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

					--Invoke an event
					toggle.frame:SetAttribute("toggled", { user = true, state = self:GetChecked() })
				elseif t.clearable and button == "RightButton" then
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

					toggle.setState(false)
				end

				--Manage data & call listeners
				if t.optionsData then
					toggle.saveData()

					--Call onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end
			end)

			--Linked mouse interactions
			toggle.frame:HookScript("OnEnter", function() if toggle.widget:IsEnabled() then
				toggle.widget:LockHighlight()
				if IsMouseButtonDown("LeftButton") or (t.clearable and IsMouseButtonDown("RightButton")) then toggle.widget:SetButtonState("PUSHED") end
			end end)
			toggle.frame:HookScript("OnLeave", function() if toggle.widget:IsEnabled() then
				toggle.widget:UnlockHighlight()
				toggle.widget:SetButtonState("NORMAL")
			end end)
			toggle.frame:HookScript("OnMouseDown", function(_, button) if toggle.widget:IsEnabled() and button == "LeftButton" or (t.clearable and button == "RightButton") then
				toggle.widget:SetButtonState("PUSHED")
			end end)
			toggle.frame:HookScript("OnMouseUp", function(_, button, isInside) if toggle.widget:IsEnabled() then
				toggle.widget:SetButtonState("NORMAL")

				if isInside and button == "LeftButton" or (t.clearable and button == "RightButton") then toggle.widget:Click(button) end
			end end)
		end

		--[ Getters & Setters ]

		---Enable or disable the widget based on the specified value
		---***
		---@param state boolean Enable the input if true, disable if not
		function toggle.setEnabled(state)
			if not toggle.widget then return end

			toggle.widget:SetEnabled(state)

			if toggle.label then toggle.label:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall") end

			--Invoke an event
			toggle.frame:SetAttribute("enabled", state)
		end

		return toggle
	end

	--[ Selector ]

	---Item naming utility
	---@param parentName string
	---@param index integer
	---@return string name
	local function findName(parentName, index)
		local name = "Item" .. index

		while _G[parentName .. name] do name = name .. "_" .. index end

		return name
	end

	---Create a selector frame, a collection of radio buttons to pick one out of multiple options
	---***
	---@param t? selectorCreationData Parameters are to be provided in this table
	---***
	---@return selector selector References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
	function wt.CreateSelector(t)
		t = t or {}

		--[ Wrapper Table ]

		---@class selector
		---@field widgets? radioButton[] The list of radio button widgets linked together in this selector
		local selector = {}

		--[ Getters & Setters ]

		---Returns the object type of this widget
		---***
		---@return WidgetType type ***Value:*** "Selector"
		---<hr><p></p>
		function selector.getType() return "Selector" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string
		---@return boolean
		function selector.isType(type) return type == "Selector" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function selector.getProperty(key) return wt.FindKey(t, key) end

		---Hook a handler function as a listener for an [OnAttributeChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) script event for a custom widget attribute
		---***
		---@param type string|SelectorAttributes Name of the custom attribute of **selector.frame** to identify invoked events with
		---@param listener fun(state: boolean)|fun(value: selectorAttributeValueData)|fun(...: any) Handler function to call when the events triggers
		--- - ***Overloads:***
		--- 	- **type** == "enabled"<p>Invoked after **selector.setEnabled(...)** was called</p><hr><p>@*param* `state` boolean ― Whether the widget is enabled</p><p></p>
		--- 	- **type** == "loaded"<p>Invoked when options data is loaded automatically</p><hr><p>@*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true</p><p></p>
		--- 	- **type** == "selected"<p>Invoked after **selector.setSelected(...)** was called or an option was clicked or cleared</p><hr><p>@*param* `value` selectorAttributeValueData ― Payload of the event wrapped in a table</p>
		---***
		---<p></p>
		function selector.setListener(type, listener)
			if not selector.frame then return end

			selector.frame:HookScript("OnAttributeChanged", function(_, attribute, ...)
				if attribute ~= type then return end

				listener(...)
			end)
		end

		---Enable or disable the selector widget based on the specified value
		---***
		---@param state boolean Enable the input if true, disable if not
		function selector.setEnabled(state)
			if not selector.frame then return end

			if selector.label then selector.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

			--Update the radio buttons
			if type(selector.widgets) == "table" then for i = 1, #selector.widgets do selector.widgets[i].setEnabled(state) end end

			--Invoke an event
			selector.frame:SetAttribute("enabled", state)
		end

		---Returns the index of the currently selected item or nil if there is no selection
		---@return integer|nil index
		function selector.getSelected()
			if not selector.frame then return t.optionsData and selector.getData() end

			for i = 1, #selector.widgets do if selector.widgets[i].getState() then return i end end

			return nil
		end

		---Set the specified item as selected (automatically called when an item is manually selected by clicking on a radio button)
		---***
		---@param index? integer ***Default:*** nil *(no selection)* if **t.clearable** is true or **user** is false
		---@param user? boolean Whether to call **t.item.onSelect** and **t.onSelection** | ***Default:*** false
		function selector.setSelected(index, user)
			if not selector.frame then
				selector.saveData({ index = index })

				return
			end
			if not next(selector.widgets) and (not index and (not t.clearable or user)) then return end

			if index then index = Clamp(index, 1, #selector.widgets) end

			for i = 1, #selector.widgets do selector.widgets[i].setState(i == index) end

			--| Call listeners

			if t.onSelection and user then t.onSelection(index) end

			--Invoke an event
			selector.frame:SetAttribute("selected", { user = user == true, selected = index })
		end

		--| Options data management

		local snapshot

		---Load the data from the specified storage table under the specified storage key to the widget
		---***
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function selector.loadData(handleChanges) wt.LoadWidgetData(selector, t.optionsData, function(data)
			data = type(data) == "number" and math.floor(data) or nil

			selector.setSelected(data)

			return data
		end, handleChanges) end

		---Save the provided data or the current value of the widget to the specified storage table under the specified storage key
		---***
		---@param data? wrappedIntegerValue If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		function selector.saveData(data) wt.SaveWidgetData(selector, t.optionsData, function()
			return type(data) == "table" and data.index or selector.getSelected()
		end) end

		---Save the provided data to the specified storage table under the specified storage key then load it to the widget
		---***
		---@param data? wrappedIntegerValue If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function selector.setData(data, handleChanges)
			selector.saveData(data)
			selector.loadData(handleChanges)
		end

		---Get the currently stored data from the specified storage table under the specified storage key
		---@param unconverted? boolean If true, use the specified convert function when reading the data, or if not true, return the raw data unconverted | ***Default:*** false
		---@return any
		function selector.getData(unconverted) return wt.GetWidgetData(t.optionsData, unconverted) end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
		function selector.snapshotData() snapshot = selector.getData() end

		--Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
		function selector.revertData() selector.setData({ index = snapshot }) end

		--[ GUI Widget ]

		if not WidgetToolsDB.lite then
			t.items = t.items or {}

			--[ Frame Setup ]

			local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Selector")

			selector.frame = wt.CreateFrame("Frame", name, t.parent)

			--| Position & dimensions

			t.columns = t.columns or 1

			if t.arrange then selector.frame.arrangementInfo = t.arrange else wt.SetPosition(selector.frame, t.position) end
			selector.frame:SetWidth(t.width or max(t.label ~= false and 160 or 0, (t.labels ~= false and 160 or 16) * t.columns))
			selector.frame:SetHeight(math.ceil((#t.items) / t.columns) * 16 + (t.label ~= false and 14 or 0))

			--| Visibility

			wt.SetVisibility(selector.frame, t.visible ~= false)
			if t.frameStrata then selector.frame:SetFrameStrata(t.frameStrata) end
			if t.frameLevel then selector.frame:SetFrameLevel(t.frameLevel) end
			if t.keepOnTop then selector.frame:SetToplevel(t.keepOnTop) end

			--| Label

			local title = t.title or t.name or "Selector"

			selector.label = wt.AddTitle({
				parent = selector.frame,
				title = t.label ~= false and {
					offset = { x = 4, },
					text = title,
				} or nil,
			})

			--[ Radio Buttons ]

			selector.widgets = {}
			local inactive = {}

			---Update an already existing selector item widget
			---***
			---@param item selectorItem|radioButton Parameters of a selector item to update or create a radio button at the specified **index** with, or an already existing radio button to use
			---@param index integer
			local function updateItem(item, index)
				--Label
				if selector.widgets[index].label then selector.widgets[index].label:SetText(item.title) end

				--Tooltip
				if selector.widgets[index].frame.tooltipData then
					selector.widgets[index].frame.tooltipData.title = item.title
					selector.widgets[index].frame.tooltipData.tooltip = item.tooltip
				end

				--Listener
				if item.onSelect then selector.widgets[index].setListener("toggled", function(value)
					if not value.user or not value.state then return end

					item.onSelect()
				end) else selector.widgets[index].frame:SetScript("OnAttributeChanged", nil) end
			end

			---Register, update or set up a new radio button item
			---***
			---@param item selectorItem|radioButton Parameters of a selector item to update or create a radio button at the specified **index** with, or an already existing radio button to use
			---@param index integer
			local function setRadioButton(item, index)
				if type(item) ~= "table" then return end

				if item.isType and item.isType("Toggle") then
					--| Register the already defined radio button widget

					selector.widgets[index] = item
				elseif selector.widgets[index] then
					--| Update the existing radio button at the specified index

					updateItem(item, index)
				elseif #inactive > 0 then
					--| Reenable an inactive radio button widget

					selector.widgets[index] = inactive[#inactive]
					table.remove(inactive, #inactive)

					--Reenable
					selector.widgets[index].frame:Show()

					updateItem(item, index)
				else
					--| Create a new radio button widget

					local sameRow = (index - 1) % t.columns > 0

					selector.widgets[index] = wt.CreateRadioButton({
						parent = selector.frame,
						name = findName(name, index),
						title = item.title,
						label = t.labels,
						tooltip = item.tooltip,
						position = {
							relativeTo = index ~= 1 and selector.widgets[sameRow and index - 1 or index - t.columns].frame or selector.label,
							relativePoint = index > 1 and (sameRow and "TOPRIGHT" or "BOTTOMLEFT") or (selector.label and "BOTTOMLEFT" or nil),
							offset = { x = selector.label and index == 1 and -4 or 0, y = selector.label and index == 1 and -2 or 0}
						},
						size = { w = (t.width and t.columns == 1) and t.width or nil, },
						clearable = t.clearable,
						events = { OnClick = function(_, _, button)
							if button == "LeftButton" then selector.setSelected(selector.widgets[index].index, true)
							elseif t.clearable and button == "RightButton" and not selector.getSelected() then selector.setSelected(nil, true) end
						end, },
						attributeEvents = item.onSelect and { toggled = function (value)
							if not value.user or not value.state then return end

							item.onSelect()
						end, } or nil,
					})
				end

				--Update the stored index
				selector.widgets[index].index = index
			end

			--Register starting items
			for i = 1, #t.items do setRadioButton(t.items[i], i) end

			--[ Getters & Setters ]

			---Update the list of items currently set for the selector widget, updating its parameters and radio buttons
			--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
			--- - ***Note:*** The currently selected item may not be the same after item were removed. In that case, the new item at the same index will be selected instead. If one or more items from the last indexes were removed, the new last item at the reduced count index will be selected. Make sure to use **selector.setSelected(...)** to correct the selection if needed!
			---***
			---@param items (selectorItem|radioButton)[] Table containing subtables with data used to update the radio buttons, or already existing radio button widget frames
			function selector.updateItems(items)
				t.items = items

				--Save selection
				local selected = selector.getSelected()

				--| Position & dimensions

				selector.frame:SetHeight(math.ceil((#items) / t.columns) * 16 + (t.label ~= false and 14 or 0))

				--| Update the radio buttons

				for i = 1, #items do setRadioButton(items[i], i) end

				while #items < #selector.widgets do
					selector.widgets[#selector.widgets].setState(false)
					selector.widgets[#selector.widgets].frame:Hide()

					table.insert(inactive, selector.widgets[#selector.widgets])
					table.remove(selector.widgets, #selector.widgets)
				end

				--| Update Selection

				if not t.clearable then
					selected = selected or #items
					selected = selected > #items and #items or selected
				end

				selector.setSelected(selected)

				--| Call listener

				if t.onItemsUpdated then t.onItemsUpdated() end
			end

			--[ Events ]

			--Register script event handlers
			if t.events then for key, value in pairs(t.events) do selector.frame:HookScript(key, value) end end

			--Register attribute event handlers
			if t.attributeEvents then for key, value in pairs(t.attributeEvents) do selector.setListener(key, value) end end

			--| UX

			--Manage data & call listeners
			selector.setListener("selected", function(value)
				if not value.user or not t.optionsData then return end

				selector.saveData()

				--Call onChange handlers
				if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
			end)

			--Tooltip
			if t.tooltip then wt.AddTooltip(selector.frame, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			}) end

			--State & dependencies
			if t.disabled then selector.setEnabled(false) else selector.frame:SetAttributeNoHandler("enabled", true) end
			if t.dependencies then wt.AddDependencies(t.dependencies, selector.setEnabled) end

			--[ Initialization ]

			--Starting value
			selector.setSelected(t.selected)
		end

		--[ Options Data ]

		--Register to the options data management
		if t.optionsData then wt.AddToOptionsTable(selector, t.optionsData) end

		return selector
	end

	---Create a selector frame, a collection of small checkboxes to pick multiple options out of a list
	---***
	---@param t? multiSelectorCreationData Parameters are to be provided in this table
	---***
	---@return multiSelector selector References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
	function wt.CreateMultipleSelector(t)
		t = t or {}

		--[ Base Selector ]

		local startingItems = t.items and wt.Clone(t.items) or {}
		local disabled = t.disabled
		local dependencies = wt.Clone(t.dependencies)
		t.limits = t.limits or {}
		t.limits.min = t.limits.min or 1
		t.limits.max = t.limits.max or #startingItems

		--Remove parameters of overwritten functionalities
		t.items = nil
		t.disabled = nil
		t.dependencies = nil

		---@class checkboxItem : checkbox
		---@field setLimited fun(min: boolean, max: boolean) Enable or disable the toggleability of the checkbox widget based on the specified limits applying<hr><p>@param min boolean Whether the minimal limit has been reached | ***Default:*** **selector**:[GetAttribute](https://wowpedia.fandom.com/wiki/API_Frame_GetAttribute)("min")<ul><li>***Note:*** If the item is selected and **min** is set to true, the checkbox will be faded and functionally disabled.</li></ul></p><p>@param max boolean Whether the maximal limit has been reached | ***Default:*** **selector**:[GetAttribute](https://wowpedia.fandom.com/wiki/API_Frame_GetAttribute)("max")<ul><li>***Note:*** If the item is not selected and **max** is set to true, the checkbox will be faded and functionally disabled.</li></ul></p>

		---@class multiSelector : selector
		---@field widgets? checkboxItem[] The list of checkbox widgets linked together in this selector
		local selector = wt.CreateSelector(t)

		--[ Getters & Setters ]

		---Hook a handler function as a listener for an [OnAttributeChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) script event for a custom widget attribute
		---***
		---@param type string|MultipleSelectorAttributes Name of the custom attribute of **selector.frame** to identify invoked events with
		---@param listener fun(state: boolean)|fun(value: multiSelectorAttributeValueData)|fun(...: any) Handler function to call when the events triggers
		--- - ***Overloads:***
		--- 	- **type** == "enabled"<p>Invoked after **selector.setEnabled(...)** was called</p><hr><p>@*param* `state` boolean ― Whether the widget is enabled</p><p></p>
		--- 	- **type** == "loaded"<p>Invoked when options data is loaded automatically</p><hr><p>@*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true</p><p></p>
		--- 	- **type** == "min"<p>Invoked after **selector.setSelected(...)** was called or an option was clicked or cleared</p><hr><p>@*param* `min` boolean — Whether **t.limits.min** ha been reached</p><p></p>
		--- 	- **type** == "max"<p>Invoked after **selector.setSelected(...)** was called or an option was clicked or cleared</p><hr><p>@*param* `max` boolean — Whether **t.limits.max** ha been reached</p><p></p>
		--- 	- **type** == "selected"<p>Invoked after **selector.setSelected(...)** was called or an option was clicked or cleared</p><hr><p>@*param* `value` multiSelectorAttributeValueData ― Payload of the event wrapped in a table</p>
		---***
		---<p></p>
		function selector.setListener(type, listener)
			if not selector.frame then return end

			selector.frame:HookScript("OnAttributeChanged", function(_, attribute, ...)
				if attribute ~= type then return end

				listener(...)
			end)
		end

		---Enable or disable the selector widget based on the specified value
		---***
		---@param state boolean Enable the input if true, disable if not
		function selector.setEnabled(state)
			if not selector.frame then return end

			if selector.label then selector.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

			--Update the checkboxes
			if type(selector.widgets) == "table" then for i = 1, #selector.widgets do selector.widgets[i].setEnabled(state) end end

			--Invoke an event
			selector.frame:SetAttribute("enabled", state)
		end

		---Returns the list of all items and their current states
		---***
		---@return boolean[] selections List of item states in order
		--- - **[*index*]** boolean? — Whether this item is currently selected or not | ***Default:*** false
		function selector.getSelected()
			if not selector.frame then return t.optionsData and selector.getData() end

			local selected = {}

			for i = 1, #selector.widgets do selected[i] = selector.widgets[i].getState() end

			return selected
		end

		---Set the specified items as selected (automatically called when an item is manually selected by clicking on a checkbox)
		---***
		---@param selections? boolean[] List of item states to set in order | ***Default:*** nil *(no selected items)* if t.limits.min == 0
		--- - **[*index*]** boolean? — Whether this item should be set as selected or not | ***Default:*** false
		---@param user? boolean Whether to call **t.item.onSelect** and **t.onSelection** | ***Default:*** false
		function selector.setSelected(selections, user)
			if not selector.frame then selector.saveData({ selections = selections }) end

			selections = selections or {}

			--| Update limits

			local count = 0

			if next(selections) then for _, v in pairs(selections) do if v then count = count + 1 end end end

			if count < t.limits.min or count > t.limits.max then return end

			local min = count <= t.limits.min
			local max = count >= t.limits.max

			--Invoke events
			selector.frame:SetAttribute("min", min)
			selector.frame:SetAttribute("max", max)

			--| Update selections

			local s = {}

			for index = 1, #selector.widgets do
				s[index] = selections[index]

				selector.widgets[index].setState(selections[index])
				selector.widgets[index].setLimited(min, max)
			end

			--| Call listeners

			if t.onSelection and user then t.onSelection(s) end

			--Invoke an event
			selector.frame:SetAttribute("selected", { user = user == true, selected = s })
		end

		--| Options data management

		local snapshot

		---Load the data from the specified storage table under the specified storage key to the widget
		---***
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function selector.loadData(handleChanges) wt.LoadWidgetData(selector, t.optionsData, function(data)
			data = type(data) == "table" and data or nil

			selector.setSelected(data)

			return data
		end, handleChanges) end

		---Save the provided data or the current value of the widget to the specified storage table under the specified storage key
		---***
		---@param data? wrappedBooleanArrayData If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		function selector.saveData(data) wt.SaveWidgetData(selector, t.optionsData, function()
			return type(data) == "table" and data.selections or selector.getSelected()
		end) end

		---Save the provided data to the specified storage table under the specified storage key then load it to the widget
		---***
		---@param data? wrappedBooleanArrayData If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function selector.setData(data, handleChanges)
			selector.saveData(data)
			selector.loadData(handleChanges)
		end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
		function selector.snapshotData() snapshot = selector.getData() end

		--Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
		function selector.revertData() selector.setData({ selections = snapshot }) end

		--[ GUI Widget ]

		if not WidgetToolsDB.lite then

			--[ Frame Setup ]

			--| Position & dimensions

			selector.frame:SetHeight(math.ceil((#startingItems) / t.columns) * 16 + (t.label ~= false and 14 or 0))

			--[ Checkboxes ]

			selector.widgets = {}
			local inactive = {}

			---Update an already existing selector item widget
			---***
			---@param item selectorItem|checkbox Parameters of a selector item to update or create the checkbox at the specified **index** with, or an already existing checkbox to use
			---@param index integer
			local function updateItem(item, index)
				--Label
				if selector.widgets[index].label then selector.widgets[index].label:SetText(item.title) end

				--Tooltip
				if selector.widgets[index].frame.tooltipData then
					selector.widgets[index].frame.tooltipData.title = item.title
					selector.widgets[index].frame.tooltipData.tooltip = item.tooltip
				end

				--Listener
				if item.onSelect then selector.widgets[index].setListener("toggled", function(value)
					if not value.user or not value.state then return end

					item.onSelect()
				end) else selector.widgets[index].frame:SetScript("OnAttributeChanged", nil) end
			end

			---Register, update or set up a new checkbox item
			---***
			---@param item selectorItem|checkbox Parameters of a selector item to update or create the checkbox at the specified **index** with, or an already existing checkbox to use
			---@param index integer
			local function setCheckbox(item, index)
				if type(item) ~= "table" then return end

				if item.isType and item.isType("Toggle") and item.widget then
					--| Register the already defined checkbox widget

					selector.widgets[index] = item
				elseif selector.widgets[index] then
					--| Update the existing checkbox at the specified index

					updateItem(item, index)
				elseif #inactive > 0 then
					--| Reenable an inactive checkbox widget

					selector.widgets[index] = inactive[#inactive]
					table.remove(inactive, #inactive)

					--Reenable
					selector.widgets[index].frame:Show()

					updateItem(item, index)
				else
					--| Create a new checkbox widget

					local sameRow = (index - 1) % t.columns > 0

					---@class linkedCheckbox : checkbox
					selector.widgets[index] = wt.CreateCheckbox({
						parent = selector.frame,
						name = findName(selector.frame:GetName(), index),
						title = item.title,
						label = t.labels,
						tooltip = item.tooltip,
						position = {
							relativeTo = index ~= 1 and selector.widgets[sameRow and index - 1 or index - t.columns].frame or selector.label,
							relativePoint = sameRow and "TOPRIGHT" or "BOTTOMLEFT",
							offset = { x = selector.label and index == 1 and -4 or 0, y = selector.label and index == 1 and -2 or 0}
						},
						size = { w = (t.width and t.columns == 1) and t.width or 160, h = 16 },
						events = { OnClick = function() selector.setSelected(selector.getSelected(), true) end, },
						attributeEvents = item.onSelect and { toggled = function(value)
							if not value.user or not value.state then return end

							item.onSelect()
						end, } or nil,
					})

					if selector.widgets[index].label then
						selector.widgets[index].label:SetFontObject("GameFontHighlightSmall")
						selector.widgets[index].label:SetIgnoreParentAlpha(true)
					end
				end

				--[ Getters & Setters ]

				selector.widgets[index].setEnabled = function(state)
					selector.widgets[index].widget:SetEnabled(state)

					if selector.widgets[index].label then selector.widgets[index].label:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall") end
				end

				selector.widgets[index].setLimited = function(min, max)
					min = min ~= nil and min or selector.frame:GetAttribute("min")
					max = max ~= nil and max or selector.frame:GetAttribute("max")
					local checked = selector.widgets[index].getState()

					if (checked and min) or (not checked and max) then
						selector.widgets[index].widget:SetButtonState("DISABLED")
						selector.widgets[index].widget:UnlockHighlight()
						selector.widgets[index].widget:SetAlpha(0.4)
					elseif selector.frame:GetAttribute("enabled") then
						selector.widgets[index].widget:SetButtonState("NORMAL")
						selector.widgets[index].widget:SetAlpha(1)
					end
				end
			end

			--Register starting items
			for i = 1, #startingItems do setCheckbox(startingItems[i], i) end

			--[ Getters & Setters ]

			---Update the list of items currently set for the selector widget, updating its parameters and checkboxes
			--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
			--- - ***Note:*** The current selections may not be valid after number of items changes. Make sure to verify the selections and call **selector.setSelected(...)** manually to fix the potential issue!
			---***
			---@param items (selectorItem|checkbox)[] Table containing subtables with data used to update the checkboxes, or already existing checkboxes widget frames
			function selector.updateItems(items)
				if #items < t.limits.min or #items > t.limits.max then return end

				startingItems = items

				--| Position &  dimensions

				selector.frame:SetHeight(math.ceil((#items) / t.columns) * 16 + (t.label ~= false and 14 or 0))

				--| Update the checkboxes

				for i = 1, #items do setCheckbox(items[i], i) end

				while #items < #selector.widgets do
					selector.widgets[#selector.widgets].setState(false)
					selector.widgets[#selector.widgets].frame:Hide()

					table.insert(inactive, selector.widgets[#selector.widgets])
					table.remove(selector.widgets, #selector.widgets)
				end

				--| Update selections

				selector.setSelected(selector.getSelected())

				--| Call listener

				if t.onItemsUpdated then t.onItemsUpdated() end
			end

			--[ Events ]

			--| UX

			--State & dependencies
			if disabled then selector.setEnabled(false) else selector.frame:SetAttributeNoHandler("enabled", true) end
			if dependencies then wt.AddDependencies(dependencies, selector.setEnabled) end

			--[ Initialization ]

			--Starting value
			selector.setSelected(t.selections)
		end

		return selector
	end

	--Anchor point index table
	local anchorPoints = {
		{ name = ns.toolboxStrings.points.top.left, value = "TOPLEFT" },
		{ name = ns.toolboxStrings.points.top.center, value = "TOP" },
		{ name = ns.toolboxStrings.points.top.right, value = "TOPRIGHT" },
		{ name = ns.toolboxStrings.points.left, value = "LEFT" },
		{ name = ns.toolboxStrings.points.center, value = "CENTER" },
		{ name = ns.toolboxStrings.points.right, value = "RIGHT" },
		{ name = ns.toolboxStrings.points.bottom.left, value = "BOTTOMLEFT" },
		{ name = ns.toolboxStrings.points.bottom.center, value = "BOTTOM" },
		{ name = ns.toolboxStrings.points.bottom.right, value = "BOTTOMRIGHT" },
	}

	--Horizontal alignment index table
	local horizontalAlignments = {
		{ name = ns.toolboxStrings.points.left, value = "LEFT" },
		{ name = ns.toolboxStrings.points.center, value = "CENTER" },
		{ name = ns.toolboxStrings.points.right, value = "RIGHT" },
	}

	--Vertical alignment index table
	local verticalAlignments = {
		{ name = ns.toolboxStrings.points.top.center, value = "TOP" },
		{ name = ns.toolboxStrings.points.center, value = "MIDDLE" },
		{ name = ns.toolboxStrings.points.bottom.center, value = "BOTTOM" },
	}

	--Vertical alignment index table
	local frameStratas = {
		{ name = ns.toolboxStrings.strata.lowest, value = "BACKGROUND" },
		{ name = ns.toolboxStrings.strata.lower, value = "LOW" },
		{ name = ns.toolboxStrings.strata.low, value = "MEDIUM" },
		{ name = ns.toolboxStrings.strata.lowMid, value = "HIGH" },
		{ name = ns.toolboxStrings.strata.highMid, value = "DIALOG" },
		{ name = ns.toolboxStrings.strata.high, value = "FULLSCREEN" },
		{ name = ns.toolboxStrings.strata.higher, value = "FULLSCREEN_DIALOG" },
		{ name = ns.toolboxStrings.strata.highest, value = "TOOLTIP" },
	}

	---Create a special selector frame, a collection of radio buttons to pick an Anchor Point, a horizontal or vertical text alignment or Frame Strata value
	---***
	---@param itemset string Specify what type of selector should be created | ***Value:*** "anchor"|"justifyH"|"justifyV"|"frameStrata"
	--- - ***Note:*** Setting this to "anchor" will use the set of [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) items.
	--- - ***Note:*** Setting this to "justifyH" will use the set of horizontal text alignment items (JustifyH).
	--- - ***Note:*** Setting this to "justifyV" will use the set of vertical text alignment items (JustifyV).
	--- - ***Note:*** Setting this to "frameStrata" will use the set of [FrameStrata](https://wowpedia.fandom.com/wiki/Frame_Strata) items (excluding "WORLD").</li></ul>
	---@param t? specialSelectorCreationData Parameters are to be provided in this table
	---***
	---@return specialSelector selector References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
	function wt.CreateSpecialSelector(itemset, t)
		t = t or {}

		--[ Base Selector ]

		--Select the item set
		if itemset == "anchor" then itemset = anchorPoints
		elseif itemset == "justifyH" then itemset = horizontalAlignments
		elseif itemset == "justifyV" then itemset = verticalAlignments
		elseif itemset == "frameStrata" then itemset = frameStratas end

		--Set unique parameters
		t.items = {}
		for i = 1, #itemset do
			t.items[i] = {}
			t.items[i].title = itemset[i].name
			t.items[i].tooltip = { lines = { { text = "(" .. itemset[i].value .. ")", }, } }
		end
		t.labels = false
		t.columns = itemset == frameStratas and 8 or 3

		---@class specialSelector : selector
		local selector = wt.CreateSelector(t)

		--[ Getters & Setters ]

		---Hook a handler function as a listener for an [OnAttributeChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) script event for a custom widget attribute
		---***
		---@param type string|SelectorAttributes Name of the custom attribute of **selector.frame** to identify invoked events with
		---@param listener fun(state: boolean)|fun(value: specialSelectorAttributeValueData)|fun(...: any) Handler function to call when the events triggers
		--- - ***Overloads:***
		--- 	- **type** == "enabled"<p>Invoked after **selector.setEnabled(...)** was called</p><hr><p>@*param* `state` boolean ― Whether the widget is enabled</p><p></p>
		--- 	- **type** == "loaded"<p>Invoked when options data is loaded automatically</p><hr><p>@*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true</p><p></p>
		--- 	- **type** == "selected"<p>Invoked after **selector.setSelected(...)** was called or an option was clicked or cleared</p><hr><p>@*param* `value` specialSelectorAttributeValueData ― Payload of the event wrapped in a table</p>
		---***
		---<p></p>
		function selector.setListener(type, listener)
			if not selector.frame then return end

			selector.frame:HookScript("OnAttributeChanged", function(_, attribute, ...)
				if attribute ~= type then return end

				listener(...)
			end)
		end

		---Convert an index to a corresponding value (based on the selected **itemset**)
		---@param index integer
		---@return AnchorPoint|JustifyH|JustifyV|FrameStrata value
		---<hr><p></p>
		function selector.toValue(index) return itemset[index].value end

		---Convert an specific value to a corresponding index (based on the selected **itemset**)
		---@param value AnchorPoint|JustifyH|JustifyV|FrameStrata
		---***
		---@return integer|nil index ***Default:*** nil *(no value)*
		---<hr><p></p>
		function selector.toIndex(value)
			for i = 1, #itemset do if itemset[i].value == value then return i end end

			return nil
		end

		---Returns the index of the currently selected item or nil if there is no selection
		---@return AnchorPoint|JustifyH|JustifyV|FrameStrata|nil point
		---<hr><p></p>
		function selector.getSelected()
			if not selector.frame then return selector.getData() end

			for i = 1, #selector.widgets do if selector.widgets[i].getState() then return selector.toValue(i) end end

			return nil
		end

		---Set the specified item as selected (automatically called when an item is manually selected by clicking on a radio button)
		---***
		---@param value? integer|AnchorPoint|JustifyH|JustifyV|FrameStrata ***Default:*** nil *(no selection)* if **t.clearable** is true or **user** is false
		---@param user? boolean Whether to call **t.item.onSelect** and **t.onSelection** | ***Default:*** false
		---<hr><p></p>
		function selector.setSelected(value, user)
			if not selector.frame then
				selector.saveData({ value = value })

				return
			end
			if not next(selector.widgets) and (not value and (not t.clearable or user)) then return end

			local index = nil

			if value then
				index = type(value) == "string" and selector.toIndex(value:upper()) or type(value) == "number" and math.floor(value) or 0
				if index > #selector.widgets then index = #selector.widgets end
			end

			for i = 1, #selector.widgets do selector.widgets[i].setState(i == index) end

			--| Call listeners

			value = type(value) == "number" and selector.toValue(value) or value

			if t.onSelection and user then t.onSelection(value) end

			--Invoke an event
			selector.frame:SetAttribute("selected", { user = user == true, selected = value })
		end

		--| Options data management

		local snapshot

		---Load the data from the specified storage table under the specified storage key to the widget
		---***
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function selector.loadData(handleChanges) wt.LoadWidgetData(selector, t.optionsData, function(data)
			data = wt.FindValue(itemset, data) and data or nil

			selector.setSelected(data)

			return data
		end, handleChanges) end

		---Save the provided data or the current value of the widget to the specified storage table under the specified storage key
		---***
		---@param data? wrappedSpecialData If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		function selector.saveData(data) wt.SaveWidgetData(selector, t.optionsData, function()
			return type(data) == "table" and data.value or selector.getSelected()
		end) end

		---Save the provided data to the specified storage table under the specified storage key then load it to the widget
		---***
		---@param data? wrappedSpecialData If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		---<hr><p></p>
		function selector.setData(data, handleChanges)
			selector.saveData(data)
			selector.loadData(handleChanges)
		end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
		function selector.snapshotData() snapshot = selector.getData() end

		--Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
		function selector.revertData() selector.setData({ value = snapshot }) end

		return selector
	end

	---Create a dropdown selector frame as a child of a container frame
	---***
	---@param t? dropdownSelectorCreationData Parameters are to be provided in this table
	---***
	---@return dropdownSelector dropdown References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), its child frames & widgets, utility functions and more wrapped in a table
	function wt.CreateDropdownSelector(t)
		t = t or {}
		local dropdown, previousDependencies, nextDependencies

		--[ Base Selector ]

		t.width = t.width or 160
		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Drorpdown")

		---@class dropdownSelector : selector
		---@field list? panel Panel frame holding the dropdown selector widget
		dropdown = wt.CreateSelector({
			name = name,
			append = false,
			label = false,
			width = t.width - 12,
			items = t.items,
			clearable = t.clearable,
			onItemsUpdated = function() dropdown.list:SetHeight(#t.items * 16 + 12) end,
			dependencies = t.dependencies,
			optionsData = t.optionsData
		})

		--[ Getters & Setters ]

		---Hook a handler function as a listener for an [OnAttributeChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) script event for a custom widget attribute
		---***
		---@param type string|DropdownAttributes Name of the custom attribute of **dropdown.frame** to identify invoked events with
		---@param listener fun(state: boolean)|fun(value: selectorAttributeValueData)|fun(...: any) Handler function to call when the events triggers
		--- - ***Overloads:***
		--- 	- **type** == "enabled"<p>Invoked after **dropdown.setEnabled(...)** was called</p><hr><p>@*param* `state` boolean ― Whether the widget is enabled</p><p></p>
		--- 	- **type** == "loaded"<p>Invoked when options data is loaded automatically</p><hr><p>@*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true</p><p></p>
		--- 	- **type** == "open"<p>Invoked when the dropdown menu is opened or closed</p><hr><p>@*param* `state` boolean ― Whether the dropdown menu is open or not</p><p></p>
		--- 	- **type** == "selected"<p>Invoked after **dropdown.setSelected(...)** was called or an option was clicked or cleared</p><hr><p>@*param* `value` selectorAttributeValueData ― Payload of the event wrapped in a table</p>
		---***
		---<p></p>
		function dropdown.setListener(type, listener)
			if not dropdown.frame then return end

			dropdown.frame:HookScript("OnAttributeChanged", function(_, attribute, ...)
				if attribute ~= type then return end

				listener(...)
			end)
		end

		---Enable or disable the dropdown selector widget based on the specified value
		---***
		---@param state boolean Enable the input if true, disable if not
		function dropdown.setEnabled(state)
			if not dropdown.frame then return end

			if dropdown.label then dropdown.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

			--Update the radio buttons
			if type(dropdown.widgets) == "table" then for i = 1, #dropdown.widgets do dropdown.widgets[i].setEnabled(state) end end

			dropdown.toggle.setEnabled(state)

			if t.cycleButtons ~= false then
				dropdown.previous.setEnabled(state and wt.CheckDependencies(previousDependencies))
				dropdown.next.setEnabled(state and wt.CheckDependencies(nextDependencies))
			end

			dropdown.list:Hide()

			--Invoke an event
			dropdown.frame:SetAttribute("enabled", state)
		end

		---Set the item at the specified index as selected, or set the displayed text if there is no selection
		---***
		---@param index? integer ***Default:*** nil *(no selection)* if **t.clearable** is true or **user** is false
		---@param user? boolean Whether to call **t.item.onSelect** and **t.onSelection** | ***Default:*** false
		---@param text? string Text to display on the label of the selected item / menu toggle button | ***Default:*** **index** and **t.items[*index*].title** or "…"
		function dropdown.setSelected(index, user, text)
			if not dropdown.frame then
				dropdown.saveData({ value = index })

				return
			end
			if not next(dropdown.widgets) and (not index and (not t.clearable or user)) then return end

			if index then index = Clamp(index, 1, #dropdown.widgets) end

			for i = 1, #dropdown.widgets do dropdown.widgets[i].setState(i == index) end

			--| Update the toggle button

			local item = t.items[index] or {}
			local itemTitle = text and text or item.title or "…"
			local tooltip = wt.Clone(item.tooltip) or {}

			table.insert(wt.AddMissing(tooltip, {
				title = itemTitle,
				lines = { { text = index and ns.toolboxStrings.dropdown.selected or ns.toolboxStrings.dropdown.none, }, }
			}).lines, { text = ns.toolboxStrings.dropdown.open, })

			dropdown.toggle.label:SetText(itemTitle)
			dropdown.toggle.setTooltip(tooltip)

			--| Close the menu

			if user and t.autoClose ~= false and dropdown.frame:GetAttribute("open") then
				dropdown.list:UnregisterEvent("GLOBAL_MOUSE_UP")

				dropdown.list:Hide()
			end

			--| Call listeners

			if t.onSelection and user then t.onSelection(index) end

			--Invoke an event
			dropdown.frame:SetAttribute("selected", { user = user == true, selected = index })
		end

		--[ GUI Widget ]

		if not WidgetToolsDB.lite then

			--[ Frame Setup ]

			dropdown.widget = wt.CreateFrame("Frame", name, t.parent)

			--| Position & dimensions

			if t.arrange then dropdown.widget.arrangementInfo = t.arrange else wt.SetPosition(dropdown.widget, t.position) end
			dropdown.widget:SetSize(t.width, 36)

			--| Visibility

			wt.SetVisibility(dropdown.widget, t.visible ~= false)
			if t.frameStrata then dropdown.widget:SetFrameStrata(t.frameStrata) end
			if t.frameLevel then dropdown.widget:SetFrameLevel(t.frameLevel) end
			if t.keepOnTop then dropdown.widget:SetToplevel(t.keepOnTop) end

			--| Label

			local title = t.title or name or "Dropdown"

			dropdown.label = wt.AddTitle({
				parent = dropdown.widget,
				title = t.label ~= false and {
					offset = { x = 4, },
					text = title,
				} or nil,
			})

			--[ Dropdown List ]

			dropdown.list = wt.CreatePanel({
				parent = dropdown.widget,
				label = false,
				position = {
					anchor = "TOP",
					relativeTo = dropdown.widget,
					relativePoint = "BOTTOM",
				},
				frameStrata = "DIALOG",
				keepInBound = true,
				background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
				border =  { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } },
				size = { w = t.width, h = 12 + #t.items * 16 },
				events = {
					OnShow = function() dropdown.frame:SetAttribute("open", true) end,
					OnHide = function() dropdown.frame:SetAttribute("open", false) end,
				},
				initialize = function(panel)
					--Reparent and position the selector
					dropdown.frame:SetParent(panel)
					wt.SetPosition(dropdown.frame, { anchor = "CENTER", })

					--Starting state
					panel:Hide()
				end,
			})

			--[ Toggle Button ]

			dropdown.toggle = wt.CreateButton({
				parent = dropdown.widget,
				name = "Toggle",
				append = t.append,
				title = "…",
				tooltip = { lines = {
					{ text = ns.toolboxStrings.dropdown.selected, },
					{ text = ns.toolboxStrings.dropdown.open, },
				} },
				position = { anchor = "BOTTOM", },
				size = { w = t.width - (t.cycleButtons ~= false and 44 or 0), },
				customizable = true,
				font = {
					normal = "GameFontHighlightSmall",
					highlight = "GameFontHighlightSmall",
					disabled = "GameFontDisableSmall",
				},
				events = { OnMouseUp = function(_, button, isInside)
					if t.clearable and button == "RightButton" and isInside and dropdown.toggle.widget:IsEnabled() then dropdown.setSelected(nil, true) end
				end, },
				dependencies = t.dependencies
			})

			wt.SetBackdrop(dropdown.toggle.widget, {
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
					} or (dropdown.frame:GetAttribute("open") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					})
				end },
				OnLeave = { rule = function()
					if dropdown.frame:GetAttribute("open") then return {
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

					return (dropdown.frame:GetAttribute("open") and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					})
				end },
				OnAttributeChanged = { trigger = dropdown.frame, rule = function(_, attribute, state)
					if attribute ~= "open" then return {} end

					if dropdown.toggle.widget:IsMouseOver() then return state and {
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} end
					return {}, true
				end },
			})

			--[ Cycle Buttons ]

			if t.cycleButtons ~= false then
				--Create a custom disabled font
				wt.CreateFont({
					name = "ChatFontSmallDisabled",
					template = "ChatFontSmall",
					color = wt.PackColor(GameFontDisable:GetTextColor()),
				})

				--[ Previous Item ]

				--Define the dependency rule
				previousDependencies = { { frame = dropdown, evaluate = function(value)
					if not value then return true end
					return value > 1
				end }, }

				dropdown.previous = wt.CreateButton({
					parent = dropdown.widget,
					name = "SelectPrevious",
					title = "◄",
					titleOffset = { y = 0.5 },
					tooltip = {
						title = ns.toolboxStrings.dropdown.previous.label,
						lines = { { text = ns.toolboxStrings.dropdown.previous.tooltip, }, }
					},
					position = { anchor = "BOTTOMLEFT", },
					size = { w = 22, },
					customizable = true,
					font = {
						normal = "ChatFontSmall",
						highlight = "ChatFontSmall",
						disabled = "ChatFontSmallDisabled",
					},
					action = function()
						local selected = dropdown.getSelected()

						dropdown.setSelected(selected and selected - 1 or #dropdown.widgets, true)
					end,
					dependencies = previousDependencies
				})

				wt.SetBackdrop(dropdown.previous.widget, {
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

				--Define the dependency rule
				nextDependencies = { { frame = dropdown, evaluate = function(value)
					if not value then return true end
					return value < #t.items
				end }, }

				dropdown.next = wt.CreateButton({
					parent = dropdown.widget,
					name = "SelectNext",
					title = "►",
					titleOffset = { x = 2, y = 0.5 },
					tooltip = {
						title = ns.toolboxStrings.dropdown.next.label,
						lines = { { text = ns.toolboxStrings.dropdown.next.tooltip, }, }
					},
					position = { anchor = "BOTTOMRIGHT", },
					size = { w = 22, },
					customizable = true,
					font = {
						normal = "ChatFontSmall",
						highlight = "ChatFontSmall",
						disabled = "ChatFontSmallDisabled",
					},
					action = function()
						local selected = dropdown.getSelected()

						dropdown.setSelected(selected and selected + 1 or 1, true)
					end,
					dependencies = nextDependencies
				})

				wt.SetBackdrop(dropdown.next.widget, {
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

			--[ Events ]

			--Register script event handlers
			if t.events then for key, value in pairs(t.events) do dropdown.widget:HookScript(key, value) end end

			--Register attribute event handlers
			if t.attributeEvents then for key, value in pairs(t.attributeEvents) do dropdown.setListener(key, value) end end

			--| Toggle

			--Pass global events to handlers
			dropdown.list:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)

			dropdown.toggle.widget:HookScript("OnClick", function()
				local state = not dropdown.list:IsVisible()

				wt.SetVisibility(dropdown.list, state)

				if state then dropdown.list:RegisterEvent("GLOBAL_MOUSE_DOWN") end
			end)

			function dropdown.list:GLOBAL_MOUSE_DOWN()
				if dropdown.toggle.widget:IsMouseOver() then return end

				dropdown.list:UnregisterEvent("GLOBAL_MOUSE_DOWN")
				dropdown.list:RegisterEvent("GLOBAL_MOUSE_UP")
			end

			function dropdown.list:GLOBAL_MOUSE_UP(button)
				if (button ~= "LeftButton" and button ~= "RightButton") or dropdown.list:IsMouseOver() then return end

				dropdown.list:UnregisterEvent("GLOBAL_MOUSE_UP")

				dropdown.list:Hide()
			end

			dropdown.setListener("open", function(state) if not state then PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF) end end)

			--| UX

			--Manage data & call listeners
			dropdown.setListener("selected", function(value)
				if not value.user or not t.optionsData then return end

				dropdown.saveData()

				--Call onChange handlers
				if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
			end)

			--Tooltip
			if t.tooltip then wt.AddTooltip(dropdown.widget, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			}) end

			--State & dependencies
			if t.disabled then dropdown.setEnabled(false) else dropdown.frame:SetAttributeNoHandler("enabled", true) end
			if t.dependencies then wt.AddDependencies(t.dependencies, dropdown.setEnabled) end

			--[ Initialization ]

			--Starting value
			dropdown.setSelected(t.selected)
		end

		return dropdown
	end

	---Create a classic dropdown frame as a child of a container frame
	---***
	--- - ***Note:*** If called on a non-classic client, ***WidgetToolbox*.CreateDropdown(...)** will be called instead, returning a custom dropdown selector frame.
	---@param t? dropdownSelectorCreationData Parameters are to be provided in this table
	---***
	---@return dropdownSelector dropdown Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame) overloaded with custom fields and utility functions
	function wt.CreateClassicDropdown(t)
		if WidgetToolsDB.lite then return wt.CreateDropdownSelector(t) end
		t = t or {}
		--Create the dropdown frame
		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Dropdown")
		---@type dropdownSelector
		local dropdown = CreateFrame("Frame", name, t.parent, "UIDropDownMenuTemplate")
		--Position & dimensions
		t.position = t.position or {}
		t.position.offset = t.position.offset or {}
		t.position.offset.y = (t.position.offset.y or 0) + (t.title ~= false and -16 or 0)
		wt.SetPosition(dropdown, t.position)
		UIDropDownMenu_SetWidth(dropdown, t.width or 115)
		--| Visibility
		wt.SetVisibility(dropdown, t.visible ~= false)
		if t.frameStrata then dropdown:SetFrameStrata(t.frameStrata) end
		if t.frameLevel then dropdown:SetFrameLevel(t.frameLevel) end
		if t.keepOnTop then dropdown:SetToplevel(t.keepOnTop) end
		--Initialize
		t.items = t.items or {}
		UIDropDownMenu_Initialize(dropdown, function()
			for i = 1, #t.items do
				local info = UIDropDownMenu_CreateInfo()
				info.text = t.items[i].title
				info.value = i
				info.func = function(self)
					t.items[i].onSelect()
					UIDropDownMenu_SetSelectedValue(dropdown, self.value)

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
		local snapshot
		function dropdown.getType() return "Selector" end
		function dropdown.isType(type) return type == "Selector" end
		function dropdown.getProperty(key) return wt.FindKey(t, key) end
		function dropdown.setListener(type, listener) dropdown:HookScript("OnAttributeChanged", function(_, attribute, ...)
			if attribute ~= type then return end
			listener(...)
		end) end
		function dropdown.getSelected() return UIDropDownMenu_GetSelectedValue(dropdown) end
		function dropdown.setSelected(index, text, user)
			UIDropDownMenu_SetSelectedValue(dropdown, index)
			UIDropDownMenu_SetText(dropdown, (t.items[index] or {}).title or text)
			if t.onSelection and user then t.onSelection(index) end
			dropdown:SetAttribute("selected", { user = user == true, selected = index })
		end
		function dropdown.setEnabled(state)
			if state then
				UIDropDownMenu_EnableDropDown(dropdown)
				if label then label:SetFontObject("GameFontNormal") end
			else
				UIDropDownMenu_DisableDropDown(dropdown)
				if label then label:SetFontObject("GameFontDisable") end
			end
			dropdown:SetAttribute("enabled", state)
		end
		function dropdown.loadData(handleChanges) wt.LoadWidgetData(dropdown, t.optionsData, function(data)
			data = type(data) == "number" and math.floor(data) or nil
			if data or t.clearable then dropdown.setSelected(data) end
			return data
		end, handleChanges) end
		function dropdown.saveData(data) wt.SaveWidgetData(dropdown, t.optionsData, function()
			return type(data) == "table" and data.index or dropdown.getSelected()
		end) end
		function dropdown.setData(data, handleChanges)
			dropdown.saveData(data)
			dropdown.loadData(handleChanges)
		end
		function dropdown.getData(unconverted) return wt.GetWidgetData(t.optionsData, unconverted) end
		function dropdown.snapshotData() snapshot = dropdown.getData() end
		function dropdown.revertData() dropdown.setData(snapshot) end
		--Manage data & call listeners
		dropdown.setListener("selected", function(value)
			if not value.user or not t.optionsData then return end
			dropdown.saveData()
			if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
		end)
		--Register attribute event handlers
		if t.attributeEvents then for key, value in pairs(t.attributeEvents) do dropdown.setListener(key, value) end end
		--State & dependencies
		if t.disabled then dropdown.setEnabled(false) end
		if t.dependencies then wt.AddDependencies(t.dependencies, dropdown.setEnabled) end
		--Starting value
		dropdown.setSelected(t.selected or 1)
		dropdown:SetAttributeNoHandler("open", false)
		--Register to the options data management
		if t.optionsData then wt.AddToOptionsTable(dropdown, t.optionsData) end
		return dropdown
	end

	--[ Text Box ]

	---Set the parameters of an editbox widget
	---@param widget textbox|multilineTextbox
	---@param t textboxCreationData
	local function SetTextbox(widget, t)
		---@class textbox
		local textbox = widget

		--[ Getters & Setters ]

		---Returns the object type of this widget
		---***
		---@return WidgetType type ***Value:*** "Textbox"
		---<hr><p></p>
		function textbox.getType() return "Textbox" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string
		---@return boolean
		function textbox.isType(type) return type == "Textbox" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function textbox.getProperty(key) return wt.FindKey(t, key) end

		---Hook a handler function as a listener for an [OnAttributeChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) script event for a custom widget attribute
		---***
		---@param type string|TextboxAttributes Name of the custom attribute of **selector.frame** to identify invoked events with
		---@param listener fun(state: boolean)|fun(value: textboxAttributeValueData)|fun(...: any) Handler function to call when the events triggers
		--- - ***Overloads:***
		--- 	- **type** == "enabled"<p>Invoked after **textbox.setEnabled(...)** was called</p><hr><p>@*param* `state` boolean ― Whether the widget is enabled</p><p></p>
		--- 	- **type** == "loaded"<p>Invoked when options data is loaded automatically</p><hr><p>@*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true</p><p></p>
		--- 	- **type** == "changed"<p>Invoked after **textbox.setText(...)** was called or an "[OnTextChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnTextChanged)" event triggered</p><hr><p>@*param* `value` textboxAttributeValueData ― Payload of the event wrapped in a table</p>
		---***
		---<p></p>
		function textbox.setListener(type, listener)
			if not textbox.frame then return end

			textbox.frame:HookScript("OnAttributeChanged", function(_, attribute, ...)
				if attribute ~= type then return end

				listener(...)
			end)
		end

		---Enable or disable the editbox widget based on the specified value
		---***
		---@param state boolean Enable the input if true, disable if not
		function textbox.setEnabled(state)
			if not textbox.frame then return end

			textbox.editbox:SetEnabled(state)

			if state then if t.font.normal then textbox.editbox:SetFontObject(t.font.normal) end elseif t.font.disabled then textbox.editbox:SetFontObject(t.font.disabled) end

			if textbox.label then textbox.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

			--Invoke an event
			textbox.frame:SetAttribute("enabled", true)
		end

		---Returns the text of the editbox
		---@return string
		function textbox.getText()
			if textbox.editbox then return textbox.editbox:GetText() else return textbox.getData() end
		end

		---Set the text of the editbox
		---***
		---@param text string Text to call the built-in [EditBox:SetText(**text**)](https://wowpedia.fandom.com/wiki/API_EditBox_SetText) with
		---@param resetCursor? boolean If true, set the cursor position to the beginning of the string after setting the text | ***Default:*** true
		function textbox.setText(text, resetCursor)
			if type(text) ~= "string" then return end
			if not textbox.editbox then
				textbox.saveData(text)

				return
			end

			textbox.editbox:SetText(text)

			if resetCursor ~= false then textbox.editbox:SetCursorPosition(0) end
		end

		--| Options data management

		local snapshot

		---Load the data from the specified storage table under the specified storage key to the widget
		---***
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function textbox.loadData(handleChanges) wt.LoadWidgetData(textbox, t.optionsData, function(data)
			textbox.setText(data)

			return data
		end, handleChanges) end

		---Save the provided data or the current value of the widget to the specified storage table under the specified storage key
		---***
		---@param text? string Text to be saved | ***Default:*** *the currently set value of the widget*
		function textbox.saveData(text) wt.SaveWidgetData(textbox, t.optionsData, function() return text or textbox.getText() end) end

		---Save the provided data to the specified storage table under the specified storage key then load it to the widget
		---***
		---@param text? string Text to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function textbox.setData(text, handleChanges)
			textbox.saveData(text)
			textbox.loadData(handleChanges)
		end

		---Get the currently stored data from the specified storage table under the specified storage key
		---@param unconverted? boolean If true, use the specified convert function when reading the data, or if not true, return the raw data unconverted | ***Default:*** false
		---@return any
		function textbox.getData(unconverted) return wt.GetWidgetData(t.optionsData, unconverted) end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **textbox.revertData()**
		function textbox.snapshotData() snapshot = textbox.getData() end

		--Set and load the stored data managed by the widget to the last saved data snapshot set via **textbox.snapshotData()**
		function textbox.revertData() textbox.setData(snapshot) end

		--[ GUI Widget ]

		if not WidgetToolsDB.lite then

			--[ Getters & Setters ]

			if textbox.editbox then
				textbox.editbox.setEnabled = textbox.setEnabled
				textbox.editbox.setText = textbox.setText
			end

			--[ Frame Setup ]

			--| Visibility

			wt.SetVisibility(textbox.frame, t.visible ~= false)
			if t.frameStrata then textbox.frame:SetFrameStrata(t.frameStrata) end
			if t.frameLevel then textbox.frame:SetFrameLevel(t.frameLevel) end
			if t.keepOnTop then textbox.frame:SetToplevel(t.keepOnTop) end

			--[ Font & Text ]

			t.font = t.font or {}

			t.insets = t.insets or {}
			t.insets = { l = t.insets.l or 0, r = t.insets.r or 0, t = t.insets.t or 0, b = t.insets.b or 0 }
			textbox.editbox:SetTextInsets(t.insets.l, t.insets.r, t.insets.t, t.insets.b)

			if t.font.normal then textbox.editbox:SetFontObject(t.font.normal) end

			if t.justify then
				if t.justify.h then textbox.editbox:SetJustifyH(t.justify.h) end
				if t.justify.v then textbox.editbox:SetJustifyV(t.justify.v) end
			end

			if t.maxLetters then textbox.editbox:SetMaxLetters(t.maxLetters) end

			--[ Events ]

			--Register script event handlers
			if t.events then for key, value in pairs(t.events) do
				if key == "OnChar" then textbox.editbox:SetScript("OnChar", function(self, char) value(self, char, self:GetText()) end)
				elseif key == "OnTextChanged" then textbox.editbox:SetScript("OnTextChanged", function(self, user) value(self, user, self:GetText()) end)
				elseif key == "OnEnterPressed" then textbox.editbox:SetScript("OnEnterPressed", function(self) value(self, self:GetText()) end)
				else textbox.editbox:HookScript(key, value) end
			end end

			--Register attribute event handlers
			if t.attributeEvents then for key, value in pairs(t.attributeEvents) do textbox.setListener(key, value) end end

			--| UX

			textbox.editbox:HookScript("OnTextChanged", function(_, user)
				--Invoke an event
				textbox.frame:SetAttribute("changed", { user = user == true, text = textbox.editbox:GetText() })

				--Manage data & call listeners
				if user and t.optionsData then
					textbox.saveData()

					--Call onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end
			end)

			textbox.editbox:SetAutoFocus(t.keepFocused)

			if t.focusOnShow then textbox.editbox:HookScript("OnShow", function(self) self:SetFocus() end) end

			if t.unfocusOnEnter ~= false then textbox.editbox:HookScript("OnEnterPressed", function(self)
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

				self:ClearFocus()
			end) end

			textbox.editbox:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)

			--State & dependencies
			if t.readOnly then textbox.editbox:Disable() end
			if t.disabled then textbox.editbox.setEnabled(false) else textbox.frame:SetAttributeNoHandler("enabled", true) end
			if t.dependencies then wt.AddDependencies(t.dependencies, textbox.editbox.setEnabled) end

			--[ Initialization ]

			--Starting value
			if t.text then textbox.setText(t.color and wt.Color(t.text, t.color) or t.text) end
		end

		--[ Options Data ]

		--Register to the options data management
		if t.optionsData then wt.AddToOptionsTable(textbox, t.optionsData) end
	end

	---Create a single line editbox frame as a child of a container frame
	---***
	---@param t? textboxCreationData Parameters are to be provided in this table
	---***
	---@return textbox textbox References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), its child widgets & their custom values, utility functions and more wrapped in a table
	function wt.CreateTextbox(t)
		t = t or {}

		--[ Wrapper Table ]

		---@class textbox
		local textbox = {}

		--[ GUI Widget ]

		textbox.editbox = nil

		if not WidgetToolsDB.lite then

			--[ Frame Setup ]

			local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Textbox")
			local custom = t.customizable and (BackdropTemplateMixin and "BackdropTemplate") or nil

			textbox.frame = wt.CreateFrame("Frame", name, t.parent)

			textbox.editbox = wt.CreateFrame("EditBox", name .. "EditBox", textbox.frame, custom or "InputBoxTemplate")

			--Set as single line
			textbox.editbox:SetMultiLine(false)

			--| Position & dimensions

			t.size = t.size or {}
			t.size.w = t.size.w or 180
			t.size.h = t.size.h or 18
			local templateOffsetX = custom and 0 or 6
			local templateOffsetY = custom and 0 or 1
			local titleOffset = t.label ~= false and -18 or 0

			if t.arrange then textbox.frame.arrangementInfo = t.arrange else wt.SetPosition(textbox.frame, t.position) end
			textbox.editbox:SetPoint("BOTTOMRIGHT")
			textbox.frame:SetSize(t.size.w, t.size.h - titleOffset)
			textbox.editbox:SetSize(t.size.w - templateOffsetX, t.size.h - templateOffsetY)

			--| Label

			local title = t.title or t.name or "Text Box"

			textbox.label = wt.AddTitle({
				parent = textbox.frame,
				title = t.label ~= false and {
					offset = { x = -1, },
					text = title,
				} or nil,
			})

			--[ Events ]

			--Custom behavior
			if custom then
				textbox.editbox:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
				textbox.editbox:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)
			end

			--Tooltip
			if t.tooltip then wt.AddTooltip(textbox.editbox, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			}) end
		end

		--[ Widget Setup ]

		SetTextbox(textbox, t)

		return textbox
	end

	---Create a scrollable multiline editbox as a child of a container frame
	---***
	---@param t? multilineTextboxCreationData Parameters are to be provided in this table
	---***
	---@return multilineTextbox textbox References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), its child widgets & their custom values, utility functions and more wrapped in a table
	function wt.CreateMultilineTextbox(t)
		t = t or {}

		--[ Wrapper Table ]

		---@class multilineTextbox : textbox
		local textbox = {}

		--[ GUI Widget ]

		if not WidgetToolsDB.lite then

			--[ Frame Setup ]

			local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Textbox")

			textbox.frame = wt.CreateFrame("Frame", name, t.parent)

			--| Position & dimensions

			if t.arrange then textbox.frame.arrangementInfo = t.arrange else wt.SetPosition(textbox.frame, t.position) end
			textbox.frame:SetSize(t.size.w, t.size.h)

			--| Label

			local title = t.title or t.name or "Text Box"

			textbox.label = wt.AddTitle({
				parent = textbox.frame,
				title = t.label ~= false and {
					offset = { x = 3, },
					text = title,
				} or nil,
			})

			--[ ScrollFrame & EditBox ]

			textbox.scrollFrame = wt.CreateFrame("ScrollFrame", name .. "ScrollFrame", textbox.frame, ScrollControllerMixin and "InputScrollFrameTemplate")

			---@type EditBox|nil
			textbox.editbox = textbox.scrollFrame.EditBox

			--Set as multiline
			textbox.editbox:SetMultiLine(true)

			--| Position & dimensions

			local scrollFrameHeight = t.size.h - (t.label ~= false and 24 or 10)

			textbox.scrollFrame:SetPoint("BOTTOM", 0, 5)
			textbox.scrollFrame:SetSize(t.size.w - 10, scrollFrameHeight)

			--Scrollbar
			wt.SetPosition(textbox.scrollFrame.ScrollBar, {
				anchor = "RIGHT",
				relativeTo = textbox.scrollFrame,
				relativePoint = "RIGHT",
				offset = { x = -4, y = 0 }
			})
			textbox.scrollFrame.ScrollBar:SetHeight(scrollFrameHeight - 4)

			--| Scroll speed

			t.scrollSpeed = t.scrollSpeed or 0.25

			textbox.scrollFrame.ScrollBar.SetPanExtentPercentage = function() --WATCH: Change when Blizzard provides a better way to overriding the built-in update function
				local height = textbox.scrollFrame:GetHeight()

				textbox.scrollFrame.ScrollBar.panExtentPercentage = height * t.scrollSpeed / math.abs(textbox.editbox:GetHeight() - height)
			end

			--| Character counter

			textbox.scrollFrame.CharCount:SetFontObject("GameFontDisableTiny2")
			if t.charCount == false or (t.maxLetters or 0) == 0 then textbox.scrollFrame.CharCount:Hide() end

			textbox.editbox.cursorOffset = 0 --WATCH: Remove when the character counter gets fixed..

			--[ Size Update Utility ]

			local function resizeEditBox(scrolling)
				local scrollBarOffset = scrolling and (wt.classic and 32 or 16) or 0
				local charCountWidth = t.charCount ~= false and (t.maxLetters or 0) > 0 and tostring(t.maxLetters - textbox.getText():len()):len() * 6 + 3 or 0

				textbox.editbox:SetWidth(textbox.scrollFrame:GetWidth() - scrollBarOffset - charCountWidth)

				--Update the character counter
				if textbox.scrollFrame.CharCount:IsVisible() and t.maxLetters then --WATCH: Remove when the character counter gets fixed..
					textbox.scrollFrame.CharCount:SetWidth(charCountWidth)
					textbox.scrollFrame.CharCount:SetText(t.maxLetters - textbox.getText():len())
					textbox.scrollFrame.CharCount:SetPoint("BOTTOMRIGHT", textbox.scrollFrame, "BOTTOMRIGHT", -scrollBarOffset + 1, 0)
				end
			end

			--[ Events ]

			--| UX

			textbox.editbox:HookScript("OnTextChanged", function(_, user) if not user and t.scrollToTop then textbox.scrollFrame:SetVerticalScroll(0) end end)

			textbox.editbox:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)

			textbox.editbox:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)

			--Resize events
			textbox.scrollFrame.ScrollBar:HookScript("OnShow", function() resizeEditBox(true) end)
			textbox.scrollFrame.ScrollBar:HookScript("OnHide", function() resizeEditBox(false) end)

			--Tooltip
			if t.tooltip then wt.AddTooltip(textbox.scrollFrame, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			}, { triggers = { textbox.frame, textbox.editbox }, }) end
		end

		--[ Widget Setup ]

		SetTextbox(textbox, t)

		return textbox
	end

	---Create a custom button with a textline and a single line editbox from which text can be copied
	---***
	---@param t? copyboxCreationData Parameters are to be provided in this table
	---***
	---@return copybox copybox References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), its child widgets & their custom values, utility functions and more wrapped in a table
	function wt.CreateCopybox(t)
		t = t or {}
		t.text = t.text or ""

		--[ Wrapper Table ]

		---@class copybox
		local copybox = {}

		--[ GUI Widget ]

		if not WidgetToolsDB.lite then

			--[ Frame Setup ]

			local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Copybox")

			copybox.frame = wt.CreateFrame("Frame", name, t.parent)

			--| Position & dimensions

			t.size = t.size or {}
			t.size.w = t.size.w or 180
			t.size.h = t.size.h or 17
			local titleOffset = t.label ~= false and -12 or 0

			if t.arrange then copybox.frame.arrangementInfo = t.arrange else wt.SetPosition(copybox.frame, t.position) end
			copybox.frame:SetSize(t.size.w, t.size.h - titleOffset)

			--| Visibility

			wt.SetVisibility(copybox.frame, t.visible ~= false)
			if t.frameStrata then copybox.frame:SetFrameStrata(t.frameStrata) end
			if t.frameLevel then copybox.frame:SetFrameLevel(t.frameLevel) end
			if t.keepOnTop then copybox.frame:SetToplevel(t.keepOnTop) end

			--| Label

			local title = t.title or t.name or "Copy Box"

			copybox.label = wt.AddTitle({
				parent = copybox.frame,
				title = t.label ~= false and {
					offset = { x = -1, },
					width = t.size.w,
					text = title,
				} or nil,
			})

			--[ Flipper Button ]

			copybox.flipper = wt.CreateFrame("Button", name .. "Flipper", copybox.frame)

			--| Position & dimensions

			copybox.flipper:SetPoint("TOPLEFT", 0, titleOffset)
			copybox.flipper:SetSize(t.size.w, t.size.h)

			--| Text

			copybox.flipper.textLine = wt.CreateText({
				parent = copybox.flipper,
				name = "DisplayText",
				position = { anchor = "LEFT", },
				width = t.size.w,
				layer = t.layer,
				text = t.text,
				font = t.font,
				color = t.color,
				justify = { h = t.justify or "LEFT", },
				wrap = false
			})

			--| UX

			--Tooltip
			wt.AddTooltip(copybox.flipper, {
				title = ns.toolboxStrings.copy.textline.label,
				lines = { { text = ns.toolboxStrings.copy.textline.tooltip, }, },
				anchor = "ANCHOR_RIGHT",
			})

			--[ Text Copybox ]

			copybox.textbox = wt.CreateTextbox({
				parent = copybox.frame,
				name = "CopyText",
				title = ns.toolboxStrings.copy.editbox.label,
				label = false,
				tooltip = { lines = { { text = ns.toolboxStrings.copy.editbox.tooltip, }, } },
				position = {
					anchor = "LEFT",
					relativeTo = copybox.flipper,
					relativePoint = "LEFT",
				},
				size = t.size,
				text = t.text,
				font = { normal = copybox.flipper.textLine:GetFontObject(), },
				color = t.colorOnMouse or t.color,
				justify = { h = t.justify, },
				events = {
					OnTextChanged = function(self, user)
						if not user then return end

						self:SetText((t.colorOnMouse or t.color) and wt.Color(t.text, t.colorOnMouse or t.color) or t.text)
						self:HighlightText()
						self:SetCursorPosition(0)
					end,
					[t.flipOnMouse and "OnLeave" or "OnEditFocusLost"] = function()
						copybox.textbox.frame:Hide()
						copybox.flipper:Show()

						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
					end,
				},
			})

			--[ Events ]

			--| Toggle

			--Base state
			copybox.textbox.frame:Hide()

			copybox.flipper:HookScript(t.flipOnMouse and "OnEnter" or "OnClick", function()
				copybox.flipper:Hide()
				copybox.textbox.frame:Show()
				copybox.textbox.editbox:SetFocus()
				copybox.textbox.editbox:HighlightText()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			end)

			--| UX

			if not t.flipOnMouse and t.colorOnMouse then
				copybox.flipper:HookScript("OnEnter", function() copybox.flipper.textLine:SetTextColor(wt.UnpackColor(t.colorOnMouse)) end)
				copybox.flipper:HookScript("OnLeave", function() copybox.flipper.textLine:SetTextColor(wt.UnpackColor(t.color)) end)
			end

			--Tooltip
			if t.tooltip then wt.AddTooltip(copybox.frame, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			}) end
		end

		return copybox
	end

	--[ Slider ]

	---Create a new numeric input with a slider frame and other controls as a child of a container frame
	---***
	---@param t numericSliderCreationData Parameters are to be provided in this table
	---***
	---@return numericSlider numeric References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), its child widgets & their custom values, utility functions and more wrapped in a table
	function wt.CreateNumericSlider(t)

		--[ Wrapper Table ]

		---@class numericSlider
		local numeric = {}

		--[ Getters & Setters ]

		---Returns the object type of this widget
		---***
		---@return WidgetType type ***Value:*** "Numeric"
		---<hr><p></p>
		function numeric.getType() return "Numeric" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string
		---@return boolean
		function numeric.isType(type) return type == "Numeric" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function numeric.getProperty(key) return wt.FindKey(t, key) end

		---Hook a handler function as a listener for an [OnAttributeChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) script event for a custom widget attribute
		---***
		---@param type string|NumericAttributes Name of the custom attribute of **selector.frame** to identify invoked events with
		---@param listener fun(state: boolean)|fun(value: numericAttributeValueData)|fun(...: any) Handler function to call when the events triggers
		--- - ***Overloads:***
		--- 	- **type** == "enabled"<p>Invoked after **numeric.setEnabled(...)** was called</p><hr><p>@*param* `state` boolean ― Whether the widget is enabled</p><p></p>
		--- 	- **type** == "loaded"<p>Invoked when options data is loaded automatically</p><hr><p>@*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true</p><p></p>
		--- 	- **type** == "changed"<p>Invoked after **numeric.setValue(...)** was called, the increase or decrease button was clicked, or a custom value was entered via the value box</p><hr><p>@*param* `value` numericAttributeValueData ― Payload of the event wrapped in a table</p>
		---***
		---<p></p>
		function numeric.setListener(type, listener)
			if not numeric.frame then return end

			numeric.frame:HookScript("OnAttributeChanged", function(_, attribute, ...)
				if attribute ~= type then return end

				listener(...)
			end)
		end

		---Enable or disable the slider widget based on the specified value
		---***
		---@param state boolean Enable the input if true, disable if not
		function numeric.setEnabled(state)
			if not numeric.frame then return end

			numeric.slider:SetEnabled(state)

			if t.valueBox ~= false then numeric.valueBox.setEnabled(state) end

			if t.sideButtons ~= false then
				numeric.decrease.setEnabled(state and wt.CheckDependencies({ { frame = numeric.slider, evaluate = function(value) return value > t.value.min end }, }))
				numeric.increase.setEnabled(state and wt.CheckDependencies({ { frame = numeric.slider, evaluate = function(value) return value < t.value.max end }, }))
			end

			if numeric.label then numeric.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

			--Invoke an event
			numeric.frame:SetAttribute("enabled", state)
		end

		---Returns the current value of the slider
		---@return number
		function numeric.getValue()
			if numeric.slider then return numeric.slider:GetValue() else return numeric.getData() end
		end

		---Set the value of the slider
		---***
		---@param value number A valid number value to call [Slider:SetValue(...)](https://wowpedia.fandom.com/wiki/Widget_API#Slider) with
		---@param user? boolean Whether to flag the change as being done via a user interaction | ***Default:*** false
		function numeric.setValue(value, user)
			if type(value) ~= "number" then return end
			if not numeric.slider then
				numeric.saveData(value)

				return
			end

			numeric.slider:SetValue(value, user)
		end

		---Set the lower numeric value limit of the slider widget
		---***
		---@param value number Updates the value set in **t.value.min** | ***Range:*** (any, **t.value.max**) *capped automatically*
		function numeric.setMin(value)
			if not numeric.slider then return end

			t.value.min = min(value, t.value.max)

			numeric.slider:SetMinMaxValues(t.value.min, t.value.max)
			numeric.slider.min:SetText(tostring(t.value.min))
		end

		---Set the upper numeric value limit of the slider widget
		---***
		---@param value number Updates the value set in **t.value.max** | ***Range:*** ( **t.value.min**, any) *floored automatically*
		function numeric.setMax(value)
			if not numeric.slider then return end

			t.value.max = max(value, t.value.min)

			numeric.slider:SetMinMaxValues(t.value.min, t.value.max)
			numeric.slider.max:SetText(tostring(t.value.max))
		end

		--| Options data management

		local snapshot

		---Load the data from the specified storage table under the specified storage key to the widget
		---***
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function numeric.loadData(handleChanges) wt.LoadWidgetData(numeric, t.optionsData, function(data)
			numeric.setValue(data)

			return data
		end, handleChanges) end

		---Save the provided data or the current value of the widget to the specified storage table under the specified storage key
		---***
		---@param value? number Data to be saved | ***Default:*** *the currently set value of the widget*
		function numeric.saveData(value) wt.SaveWidgetData(numeric, t.optionsData, function() return value or numeric.getValue() end) end

		---Save the provided data to the specified storage table under the specified storage key then load it to the widget
		---***
		---@param value? number Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function numeric.setData(value, handleChanges)
			numeric.saveData(value)
			numeric.loadData(handleChanges)
		end

		---Get the currently stored data from the specified storage table under the specified storage key
		---@param unconverted? boolean If true, use the specified convert function when reading the data, or if not true, return the raw data unconverted | ***Default:*** false
		---@return any
		function numeric.getData(unconverted) return wt.GetWidgetData(t.optionsData, unconverted) end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **numeric.revertData()**
		function numeric.snapshotData() snapshot = numeric.getData() end

		--Set and load the stored data managed by the widget to the last saved data snapshot set via **numeric.snapshotData()**
		function numeric.revertData() numeric.setData(snapshot) end

		--[ GUI Widget ]

		if not WidgetToolsDB.lite then

			--[ Frame Setup ]

			local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Slider")

			numeric.frame = wt.CreateFrame("Frame", name, t.parent)

			numeric.slider = wt.CreateFrame("Slider", name .. "Frame", numeric.frame, "OptionsSliderTemplate")

			--| Position & dimensions

			t.width = t.width or 160

			if t.arrange then numeric.frame.arrangementInfo = t.arrange else wt.SetPosition(numeric.frame, t.position) end
			numeric.frame:SetSize(t.width, t.valueBox ~= false and 48 or 31)
			numeric.slider:SetPoint("TOP", 0, -15)
			numeric.slider:SetWidth(t.width - (t.sideButtons ~= false and 40 or 0))

			--| Visibility

			wt.SetVisibility(numeric.frame, t.visible ~= false)
			if t.frameStrata then numeric.frame:SetFrameStrata(t.frameStrata) end
			if t.frameLevel then numeric.frame:SetFrameLevel(t.frameLevel) end
			if t.keepOnTop then numeric.frame:SetToplevel(t.keepOnTop) end

			--| Label

			local title = t.title or t.name or "Slider"

			if t.label ~= false then
				numeric.label = _G[name .. "FrameText"]

				numeric.label:SetPoint("TOP", numeric.frame, "TOP", 0, 2)
				numeric.label:SetFontObject("GameFontNormal")

				numeric.label:SetText(title)
			else _G[name .. "FrameText"]:Hide() end

			--| Min / Max

			numeric.slider.min = _G[name .. "FrameLow"]
			numeric.slider.max = _G[name .. "FrameHigh"]

			numeric.slider:SetMinMaxValues(t.value.min, t.value.max)

			numeric.slider.min:SetText(tostring(t.value.min))
			numeric.slider.max:SetText(tostring(t.value.max))
			numeric.slider.min:SetPoint("TOPLEFT", numeric.slider, "BOTTOMLEFT")
			numeric.slider.max:SetPoint("TOPRIGHT", numeric.slider, "BOTTOMRIGHT")

			--| Increment

			if t.value.increment then
				numeric.slider:SetValueStep(t.value.increment)
				numeric.slider:SetObeyStepOnDrag(true)
			end

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

				numeric.valueBox = wt.CreateTextbox({
					parent = numeric.frame,
					name = "ValueBox",
					label = false,
					tooltip = {
						title = ns.toolboxStrings.slider.value.label,
						lines = { { text = ns.toolboxStrings.slider.value.tooltip, }, }
					},
					position = {
						anchor = "TOP",
						relativeTo = numeric.slider,
						relativePoint = "BOTTOM",
					},
					size = { w = 64, },
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

							numeric.setValue(v, true)
						end,
						OnEscapePressed = function(self) self.setText(tostring(wt.Round(numeric.slider:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
					},
				}).editbox

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

				--Keep the value text updated
				numeric.slider:HookScript("OnValueChanged", function(_, v)
					numeric.valueBox.setText(tostring(wt.Round(v, decimals)):gsub(matchPattern, replacePattern))
				end)
			end

			--[ Side Buttons ]

			if t.sideButtons ~= false then
				t.step = t.step or t.value.increment or ((t.value.max - t.value.min) / 10)

				--[ Decrease Value ]

				--Create button frame
				numeric.decrease = wt.CreateButton({
					parent = numeric.frame,
					name = "SelectPrevious",
					title = "-",
					tooltip = {
						title = ns.toolboxStrings.slider.decrease.label,
						lines = {
							{ text = ns.toolboxStrings.slider.decrease.tooltip[1]:gsub("#VALUE", t.step), },
							t.altStep and { text = ns.toolboxStrings.slider.decrease.tooltip[2]:gsub("#VALUE", t.altStep), } or nil,
						}
					},
					position = {
						anchor = "LEFT",
						relativeTo = numeric.slider,
						relativePoint = "LEFT",
						offset = { x = -21, }
					},
					size = { w = 20, h = 20 },
					customizable = true,
					font = {
						normal = "GameFontHighlightMedium",
						highlight = "GameFontHighlightMedium",
						disabled = "GameFontDisableMed2",
					},
					action = function() numeric.setValue(numeric.slider:GetValue() - (IsAltKeyDown() and t.altStep or t.step), true) end,
					dependencies = { { frame = numeric.slider, evaluate = function(value) return value > t.value.min end }, }
				})

				wt.SetBackdrop(numeric.decrease.widget, {
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

				numeric.increase = wt.CreateButton({
					parent = numeric.frame,
					name = "SelectNext",
					title = "+",
					tooltip = {
						title = ns.toolboxStrings.slider.increase.label,
						lines = {
							{ text = ns.toolboxStrings.slider.increase.tooltip[1]:gsub("#VALUE", t.step), },
							t.altStep and { text = ns.toolboxStrings.slider.increase.tooltip[2]:gsub("#VALUE", t.altStep), } or nil,
						}
					},
					position = {
						anchor = "RIGHT",
						relativeTo = numeric.slider,
						relativePoint = "RIGHT",
						offset = { x = 21, }
					},
					size = { w = 20, h = 20 },
					customizable = true,
					font = {
						normal = "GameFontHighlightMedium",
						highlight = "GameFontHighlightMedium",
						disabled = "GameFontDisableMed2",
					},
					action = function() numeric.setValue(numeric.slider:GetValue() + (IsAltKeyDown() and t.altStep or t.step), true) end,
					dependencies = { { frame = numeric.slider, evaluate = function(value) return value < t.value.max end }, }
				})

				wt.SetBackdrop(numeric.increase.widget, {
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

			--[ Events ]

			--Register script event handlers
			if t.events then for key, value in pairs(t.events) do numeric.slider:HookScript(key, value) end end

			--Register attribute event handlers
			if t.attributeEvents then for key, value in pairs(t.attributeEvents) do numeric.setListener(key, value) end end

			--| UX

			numeric.slider:HookScript("OnValueChanged", function(_, value, user)
				--Invoke an event
				numeric.frame:SetAttribute("changed", { user = user, value = value })

				--Manage data & call listeners
				if user and t.optionsData then
					numeric.saveData()

					--Call onChange handlers
					if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
				end
			end)

			numeric.slider:HookScript("OnMouseUp", function() PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end)

			--Tooltip
			if t.tooltip then wt.AddTooltip(numeric.slider, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			}) end

			--State & dependencies
			if t.disabled then numeric.setEnabled(false) else numeric.frame:SetAttributeNoHandler("enabled", true) end
			if t.dependencies then wt.AddDependencies(t.dependencies, numeric.setEnabled) end
		end

		--[ Options Data ]

		--Register to the options data management
		if t.optionsData then wt.AddToOptionsTable(numeric, t.optionsData) end

		return numeric
	end

	--[ Color Picker ]

	---Create a custom color picker frame with HEX(A) input while utilizing the [ColorPickerFrame](https://wowpedia.fandom.com/wiki/Using_the_ColorPickerFrame) opened with a button
	---***
	---@param t? colorPickerCreationData Parameters are to be provided in this table
	---***
	---@return colorPicker colorPicker References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), its child widgets & their custom values, utility functions and more wrapped in a table
	function wt.CreateColorPicker(t)
		t = t or {}

		--[ Wrapper Table ]

		---@class colorPicker
		local colorPicker = {}

		--[ Getters & Setters ]

		---Returns the object type of this widget
		---***
		---@return WidgetType type ***Value:*** "ColorPicker"
		---<hr><p></p>
		function colorPicker.getType() return "ColorPicker" end

		---Checks and returns if the type of this widget matches the string provided entirely
		---@param type string
		---@return boolean
		function colorPicker.isType(type) return type == "ColorPicker" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function colorPicker.getProperty(key) return wt.FindKey(t, key) end

		---Hook a handler function as a listener for an [OnAttributeChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnAttributeChanged) script event for a custom widget attribute
		---***
		---@param type string|ColorPickerAttributes Name of the custom attribute of **selector.frame** to identify invoked events with
		---@param listener fun(state: boolean)|fun(value: colorPickerAttributeValueData)|fun(...: any) Handler function to call when the events triggers
		--- - ***Overloads:***
		--- 	- **type** == "enabled"<p>Invoked after **colorPicker.setEnabled(...)** was called</p><hr><p>@*param* `state` boolean ― Whether the widget is enabled</p><p></p>
		--- 	- **type** == "loaded"<p>Invoked when options data is loaded automatically</p><hr><p>@*param* `state` boolean ― Called evoking handlers after the widget's value has been successfully loaded with the value of true</p><p></p>
		--- 	- **type** == "active"<p>Invoked after **colorPicker.pickerButton** was clicked</p><hr><p>@*param* `state` boolean ― Whether this color picker is the active one the [ColorPickerFrame](https://wowpedia.fandom.com/wiki/Using_the_ColorPickerFrame) has been opened for</p><p></p>
		--- 	- **type** == "colored"<p>Invoked after **colorPicker.setColor(...)** was called</p><hr><p>@*param* `value` colorPickerAttributeValueData ― Payload of the event wrapped in a table</p>
		---***
		---<p></p>
		function colorPicker.setListener(type, listener)
			if not colorPicker.frame then return end

			colorPicker.frame:HookScript("OnAttributeChanged", function(_, attribute, ...)
				if attribute ~= type then return end

				listener(...)
			end)
		end

		---Enable or disable the color picker widget based on the specified value
		---***
		---@param state boolean Enable the input if true, disable if no
		function colorPicker.setEnabled(state)
			if not colorPicker.frame then return end

			colorPicker.pickerButton.setEnabled(state)
			colorPicker.hexBox.setEnabled(state)

			if colorPicker.label then colorPicker.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

			if ColorPickerFrame:IsVisible() then
				local active = colorPicker.frame:GetAttribute("active")

				colorPicker.pickerButton.widget:EnableMouse(false)
				colorPicker.hexBox:EnableMouse(false)
				colorPicker.setFaded(active)

				--Update the color when re-enabled
				if active then
					local r, g, b = ColorPickerFrame:GetColorRGB()
					local a = OpacitySliderFrame:GetValue() or 1

					colorPicker.setColor(r, g, b, a, true)
				end
			end

			--Invoke an event
			colorPicker.frame:SetAttribute("enabled", state)
		end

		---Toggle the fading of the color picker elements when [ColorPickerFrame](https://wowpedia.fandom.com/wiki/Using_the_ColorPickerFrame) is opened (and this is not the color picker frame it has been opened for)
		--- - ***Note:*** Inputs will still be blocked while the [ColorPickerFrame](https://wowpedia.fandom.com/wiki/Using_the_ColorPickerFrame) is open whether or not this color piker is the active one.
		---***
		---@param state boolean Wether to fade the color picker elements
		function colorPicker.setFaded(state)
			if not colorPicker.frame then return end

			local a = (state or not ColorPickerFrame:IsVisible()) and 1 or 0.4

			colorPicker.hexBox:SetAlpha(a)
			colorPicker.label:SetAlpha(a)
		end

		---Returns the currently set color values
		---***
		---@return number r Red | ***Range:*** (0, 1)
		---@return number g Green | ***Range:*** (0, 1)
		---@return number b Blue | ***Range:*** (0, 1)
		---@return number? a Opacity | ***Range:*** (0, 1)
		function colorPicker.getColor()
			if colorPicker.frame then return colorPicker.pickerButton.widget:GetBackdropColor() else return wt.UnpackColor(colorPicker.getData()) end
		end

		---Sets the color and text of each element
		---***
		---@param r number Red | ***Range:*** (0, 1)
		---@param g number Green | ***Range:*** (0, 1)
		---@param b number Blue | ***Range:*** (0, 1)
		---@param a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 1
		---@param user? boolean Whether to flag the call as a result of a user interaction calling registered listeners | ***Default:*** false
		function colorPicker.setColor(r, g, b, a, user)
			a = a or 1

			if not colorPicker.frame then
				colorPicker.saveData(wt.PackColor(r, g, b, a))

				return
			end

			colorPicker.pickerButton.widget:SetBackdropColor(r, g, b, a)
			colorPicker.pickerButton.gradient:SetVertexColor(r, g, b, 1)
			colorPicker.hexBox.setText(wt.ColorToHex(r, g, b, a))

			--| Call listeners

			if user and t.onColorUpdate then t.onColorUpdate(r, g, b, a) end

			--Invoke an event
			colorPicker.frame:SetAttribute("colored", { user = user == true, color = wt.PackColor(r, g, b, a) })
		end

		--| Options data management

		local snapshot

		---Load the data from the specified storage table under the specified storage key to the widget
		---***
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function colorPicker.loadData(handleChanges, snapshot) wt.LoadWidgetData(colorPicker, t.optionsData, function(data)
			colorPicker.setColor(wt.UnpackColor(data))

			return data
		end, handleChanges) end

		---Save the provided data or the current value of the widget to the specified storage table under the specified storage key
		---***
		---@param color? colorData Table containing the color values to be saved | ***Default:*** *the currently set value of the widget*
		function colorPicker.saveData(color) wt.SaveWidgetData(colorPicker, t.optionsData, function() return color or wt.PackColor(colorPicker.getColor()) end) end

		---Save the provided data to the specified storage table under the specified storage key then load it to the widget
		---***
		---@param color? colorData Table containing the color values to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean Whether to call the specified onChange handlers or not | ***Default:*** true
		function colorPicker.setData(color, handleChanges)
			colorPicker.saveData(color)
			colorPicker.loadData(handleChanges)
		end

		---Get the currently stored data from the specified storage table under the specified storage key
		---@param unconverted? boolean If true, use the specified convert function when reading the data, or if not true, return the raw data unconverted | ***Default:*** false
		---@return any
		function colorPicker.getData(unconverted) return wt.GetWidgetData(t.optionsData, unconverted) end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **colorPicker.revertData()**
		function colorPicker.snapshotData() snapshot = colorPicker.getData() end

		--Set and load the stored data managed by the widget to the last saved data snapshot set via **colorPicker.snapshotData()**
		function colorPicker.revertData() colorPicker.setData(snapshot) end

		--[ GUI Widget ]

		if not WidgetToolsDB.lite then

			--[ Frame Setup ]

			local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "ColorPicker")

			colorPicker.frame = wt.CreateFrame("Frame", name, t.parent)

			--| Position & dimensions

			t.width = t.width or 120

			if t.arrange then colorPicker.frame.arrangementInfo = t.arrange else wt.SetPosition(colorPicker.frame, t.position) end
			colorPicker.frame:SetSize(t.width, 36)

			--| Visibility

			wt.SetVisibility(colorPicker.frame, t.visible ~= false)
			if t.frameStrata then colorPicker.frame:SetFrameStrata(t.frameStrata) end
			if t.frameLevel then colorPicker.frame:SetFrameLevel(t.frameLevel) end
			if t.keepOnTop then colorPicker.frame:SetToplevel(t.keepOnTop) end

			--| Label

			local title = t.title or t.name or "Color Picker"

			colorPicker.label = wt.AddTitle({
				parent = colorPicker.frame,
				title = t.label ~= false and {
					offset = { x = 4, },
					text = title,
				} or nil,
			})

			--[ Color Picker Button ]

			if not t.startColor and t.optionsData and t.optionsData.storageTable and t.optionsData.storageKey or false then
				t.startColor = wt.Clone(t.optionsData.storageTable[t.optionsData.storageKey])
			else t.startColor = {} end

			--Color picker button background update utility
			local function colorUpdate()
				if not colorPicker.frame:GetAttribute("enabled") then return end

				local r, g, b, a = ColorPickerFrame:GetColorRGB()
				local a = ColorPickerFrame:GetColorAlpha() or 1

				colorPicker.setColor(r, g, b, a, true)
			end

			colorPicker.pickerButton = wt.CreateButton({
				parent = colorPicker.frame,
				name = "PickerButton",
				label = false,
				tooltip = {
					title = ns.toolboxStrings.color.picker.label,
					lines = { { text = ns.toolboxStrings.color.picker.tooltip:gsub("#ALPHA", t.startColor.a and ns.toolboxStrings.color.picker.alpha or ""), }, }
				},
				position = { offset = { y = -14 } },
				size = { w = 34, h = 22 },
				customizable = true,
				action = function(self)
					local startR, startG, startB, startA = self.widget:GetBackdropColor()

					ColorPickerFrame:SetupColorPickerAndShow({
						r = startR,
						g = startG,
						b = startB,
						opacity = startA,
						previousValues = {
							r = startR,
							g = startG,
							b = startB,
							opacity = startA,
						},
						hasOpacity = true,
						swatchFunc = colorUpdate,
						opacityFunc = colorUpdate,
						cancelFunc = function()
							colorPicker.setColor(startR, startG, startB, startA, true)
							if t.onCancel then t.onCancel() end
						end
					})

					colorPicker.setFaded(true)

					--Invoke an event
					colorPicker.frame:SetAttribute("active", true)
				end,
			})

			wt.SetBackdrop(colorPicker.pickerButton.widget, {
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
				parent = colorPicker.pickerButton.widget,
				name = "ColorGradient",
				position = { offset = { x = 2.5, y = -2.5 } },
				size = { w = 14, h = 17 },
				path = textures.gradientBG,
				layer = "BACKGROUND",
				level = -7,
			})

			--Texture: Checker pattern
			colorPicker.pickerButton.checker = wt.CreateTexture({
				parent = colorPicker.pickerButton.widget,
				name = "AlphaBG",
				position = { offset = { x = 2.5, y = -2.5 } },
				size = { w = 29, h = 17 },
				path = textures.alphaBG,
				layer = "BACKGROUND",
				level = -8,
				tile = { h = true, v = true },
				wrap = { h = true, v = true },
			})

			--[ HEX Box ]

			colorPicker.hexBox = wt.CreateTextbox({
				parent = colorPicker.frame,
				name = "HEXBox",
				title = ns.toolboxStrings.color.hex.label,
				label = false,
				tooltip = { lines = { {
					text = ns.toolboxStrings.color.hex.tooltip .. "\n\n" .. ns.toolboxStrings.example .. ": #2266BB" .. (t.startColor.a and "AA" or ""),
				}, } },
				position = {
					relativeTo = colorPicker.pickerButton.widget,
					relativePoint = "TOPRIGHT",
				},
				size = { w = t.width - colorPicker.pickerButton.widget:GetWidth(), h = colorPicker.pickerButton.widget:GetHeight() },
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
			}).editbox

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

			--[ Events ]

			--Register script event handlers
			if t.events then for key, value in pairs(t.events) do colorPicker.frame:HookScript(key, value) end end

			--Register attribute event handlers
			if t.attributeEvents then for key, value in pairs(t.attributeEvents) do colorPicker.setListener(key, value) end end

			--| UX

			--Manage data & call listeners
			colorPicker.frame:HookScript("OnAttributeChanged", function(_, attribute, value)
				if attribute ~= "colored" or not value.user or not t.optionsData then return end

				colorPicker.saveData()

				--Call onChange handlers
				if t.optionsData.onChange then for i = 1, #t.optionsData.onChange do optionsTable.changeHandlers[t.optionsData.optionsKey][t.optionsData.onChange[i]]() end end
			end)

			--| Toggle

			ColorPickerFrame:HookScript("OnShow", function()
				colorPicker.pickerButton.widget:EnableMouse(false)
				colorPicker.hexBox:EnableMouse(false)

				colorPicker.setFaded(false)

				colorPicker.frame:SetAttributeNoHandler("active", false)
			end)

			ColorPickerFrame:HookScript("OnHide", function()
				colorPicker.pickerButton.widget:EnableMouse(true)
				colorPicker.hexBox:EnableMouse(true)

				colorPicker.setFaded(true)

				--Invoke an event
				colorPicker.frame:SetAttribute("active", false)
			end)

			--Base state
			colorPicker.frame:SetAttributeNoHandler("active", false)

			--Tooltip
			if t.tooltip then wt.AddTooltip(colorPicker.frame, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			}) end

			--State & dependencies
			if t.disabled then colorPicker.setEnabled(false) else colorPicker.frame:SetAttributeNoHandler("enabled", true) end
			if t.dependencies then wt.AddDependencies(t.dependencies, colorPicker.setEnabled) end
		end

		--[ Initialization ]

		--Register to the options data management
		if t.optionsData then wt.AddToOptionsTable(colorPicker, t.optionsData) end

		return colorPicker
	end


	--[[ TEMPLATES ]]

	--[ Settings Pages ]

	---Create and set up a new settings page with about into for an addon
	---***
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param t? aboutPageCreationData Parameters are to be provided in this table
	---***
	---@return settingsPage aboutPage Table containing references to the options canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions
	function wt.CreateAboutPage(addon, t)
		t = t or {}
		local data = {
			version = GetAddOnMetadata(addon, "Version"),
			day = GetAddOnMetadata(addon, "X-Day"),
			month = GetAddOnMetadata(addon, "X-Month"),
			year = GetAddOnMetadata(addon, "X-Year"),
			author = GetAddOnMetadata(addon, "Author"),
			license = GetAddOnMetadata(addon, "X-License"),
			curse = GetAddOnMetadata(addon, "X-CurseForge"),
			wago = GetAddOnMetadata(addon, "X-Wago"),
			repo = GetAddOnMetadata(addon, "X-Repository"),
			issues = GetAddOnMetadata(addon, "X-Issues"),
			sponsors = GetAddOnMetadata(addon, "X-Sponsors"),
			topSponsors = GetAddOnMetadata(addon, "X-TopSponsors"),
		}

		--[ Settings Page ]

		return wt.CreateSettingsPage(addon, not WidgetToolsDB.lite and next(data) and {
			register = t.register,
			name = t.name or GetAddOnMetadata(addon, "Title"),
			description = t.description or GetAddOnMetadata(addon, "Notes"),
			static = t.static ~= false,
			initialize = function(canvas)

				--[ About ]

				wt.CreatePanel({
					parent = canvas,
					name = "About",
					title = ns.toolboxStrings.about.title,
					description = ns.toolboxStrings.about.description:gsub("#ADDON", GetAddOnMetadata(addon, "Title")),
					arrange = {},
					size = { h = 258 },
					initialize = function(panel)

						--[ Information ]

						local position = { offset = { x = 16, y = -32 } }
						local version

						if data.version then
							version = wt.CreateText({
								parent = panel,
								name = "VersionTitle",
								position = position,
								width = 45,
								text = ns.toolboxStrings.about.version .. ":",
								font = "GameFontNormalSmall",
								justify = { h = "RIGHT", },
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
								text = data.version,
								font = "GameFontHighlightSmall",
								justify = { h = "LEFT", },
							})

							position = {
								relativeTo = version,
								relativePoint = "BOTTOMLEFT",
								offset = { y = -8 }
							}
						end

						if data.day and data.month and data.year then
							local date = wt.CreateText({
								parent = panel,
								name = "DateTitle",
								position = position,
								width = 45,
								text = ns.toolboxStrings.about.date .. ":",
								font = "GameFontNormalSmall",
								justify = { h = "RIGHT", },
							})
							wt.CreateText({
								parent = panel,
								name = "Date",
								position = {
									relativeTo = date,
									relativePoint = "TOPRIGHT",
									offset = { x = 5 }
								},
								width = 140,
								text = ns.toolboxStrings.date:gsub(
									"#DAY", data.day
								):gsub(
									"#MONTH", data.month
								):gsub(
									"#YEAR", data.year
								),
								font = "GameFontHighlightSmall",
								justify = { h = "LEFT", },
							})

							position = {
								relativeTo = date,
								relativePoint = "BOTTOMLEFT",
								offset = { y = -8 }
							}
						end

						if data.author then
							local author = wt.CreateText({
								parent = panel,
								name = "AuthorTitle",
								position = position,
								width = 45,
								text = ns.toolboxStrings.about.author .. ":",
								font = "GameFontNormalSmall",
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
								font = "GameFontHighlightSmall",
								justify = { h = "LEFT", },
							})

							position = {
								relativeTo = author,
								relativePoint = "BOTTOMLEFT",
								offset = { y = -8 }
							}
						end

						if data.license then
							local license = wt.CreateText({
								parent = panel,
								name = "LicenseTitle",
								position = position,
								width = 45,
								text = ns.toolboxStrings.about.license .. ":",
								font = "GameFontNormalSmall",
								justify = { h = "RIGHT", },
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
								font = "GameFontHighlightSmall",
								justify = { h = "LEFT", },
							})

							position = {
								relativeTo = license,
								relativePoint = "BOTTOMLEFT",
								offset = { y = -8 }
							}
						end

						--[ Links ]

						if position.relativeTo then position.offset.y = -11 end

						if data.curse then
							local curse = wt.CreateCopybox({
								parent = panel,
								name = "CurseForge",
								title = ns.toolboxStrings.about.curseForge .. ":",
								position = position,
								size = { w = 190, },
								text = data.curse,
								font = "GameFontNormalSmall",
								color = { r = 0.6, g = 0.8, b = 1, a = 1 },
								colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
							})

							position = {
								relativeTo = curse.frame,
								relativePoint = "BOTTOMLEFT",
								offset = { y = -8 }
							}
						end

						if data.wago then
							local wago = wt.CreateCopybox({
								parent = panel,
								name = "Wago",
								title = ns.toolboxStrings.about.wago .. ":",
								position = position,
								size = { w = 190, },
								text = data.wago,
								font = "GameFontNormalSmall",
								color = { r = 0.6, g = 0.8, b = 1, a = 1 },
								colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
							})

							position = {
								relativeTo = wago.frame,
								relativePoint = "BOTTOMLEFT",
								offset = { y = -8 }
							}
						end

						if data.repo then
							local repo = wt.CreateCopybox({
								parent = panel,
								name = "Repository",
								title = ns.toolboxStrings.about.repository .. ":",
								position = position,
								size = { w = 190, },
								text = data.repo,
								font = "GameFontNormalSmall",
								color = { r = 0.6, g = 0.8, b = 1, a = 1 },
								colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
							})

							position = {
								relativeTo = repo.frame,
								relativePoint = "BOTTOMLEFT",
								offset = { y = -8 }
							}
						end

						if data.issues then wt.CreateCopybox({
							parent = panel,
							name = "Issues",
							title = ns.toolboxStrings.about.issues .. ":",
							position = position,
							size = { w = 190, },
							text = data.issues,
							font = "GameFontNormalSmall",
							color = { r = 0.6, g = 0.8, b = 1, a = 1 },
							colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
						}) end

						--[ Changelog ]

						if not t.changelog then return end

						local changelog = wt.CreateMultilineTextbox({
							parent = panel,
							name = "Changelog",
							title = ns.toolboxStrings.about.changelog.label,
							tooltip = { lines = { { text = ns.toolboxStrings.about.changelog.tooltip, }, } },
							arrange = {},
							size = { w = panel:GetWidth() - 225, h = panel:GetHeight() - 42 },
							text = wt.FormatChangelog(t.changelog, true),
							font = { normal = "GameFontDisableSmall", },
							color = ns.colors.grey[2],
							readOnly = true,
						})

						local fullChangelogFrame
						wt.CreateButton({
							parent = panel,
							name = "OpenFullChangelog",
							title = ns.toolboxStrings.about.fullChangelog.open.label,
							tooltip = { lines = { { text = ns.toolboxStrings.about.fullChangelog.open.tooltip, }, } },
							position = {
								anchor = "TOPRIGHT",
								relativeTo = changelog.frame,
								relativePoint = "TOPRIGHT",
								offset = { x = -3, y = 2 }
							},
							size = { w = 156, h = 14 },
							frameLevel = changelog.frame:GetFrameLevel() + 1, --Make sure it's on top to be clickable
							font = {
								normal = "GameFontNormalSmall",
								highlight = "GameFontHighlightSmall",
							},
							action = function()
								if fullChangelogFrame then fullChangelogFrame:Show()
								else
									fullChangelogFrame = wt.CreatePanel({
										parent = canvas,
										name = addon .. "Changelog",
										append = false,
										title = ns.toolboxStrings.about.fullChangelog.label:gsub("#ADDON", GetAddOnMetadata(addon, "Title")),
										position = { anchor = "BOTTOMRIGHT", },
										keepInBounds = true,
										size = { w = 678, h = 610 },
										frameStrata = "DIALOG",
										keepOnTop = true,
										background = { color = { a = 0.9 }, },
										initialize = function(windowPanel)
											wt.CreateMultilineTextbox({
												parent = windowPanel,
												name = "FullChangelog",
												title = ns.toolboxStrings.about.fullChangelog.label:gsub("#ADDON", GetAddOnMetadata(addon, "Title")),
												label = false,
												tooltip = { lines = { { text = ns.toolboxStrings.about.fullChangelog.tooltip, }, } },
												arrange = {},
												size = { w = windowPanel:GetWidth() - 32, h = windowPanel:GetHeight() - 88 },
												text = wt.FormatChangelog(t.changelog),
												font = { normal = "GameFontDisable", },
												color = ns.colors.grey[2],
												readOnly = true,
												scrollSpeed = 0.2,
											})

											wt.CreateButton({
												parent = windowPanel,
												name = "CloseButton",
												title = CLOSE,
												arrange = {},
												size = { w = 96, },
												action = function() windowPanel:Hide() end,
											})

											_G[windowPanel:GetName() .. "Title"]:SetPoint("TOPLEFT", 18, -18)

											windowPanel:EnableMouse(true)
										end,
										arrangement = { parameters = {
											margins = { l = 16, r = 16, t = 42, b = 16 },
											flip = true,
										}, }
									})
								end
							end,
						})
					end,
					arrangement = { parameters = {
						flip = true,
						resize = false
					}, }
				})

				--[ Sponsors ]

				if data.topSponsors or data.sponsors then
					local sponsorsPanel = wt.CreatePanel({
						parent = canvas,
						name = "Sponsors",
						title = ns.toolboxStrings.sponsors.title,
						description = ns.toolboxStrings.sponsors.description,
						arrange = {},
						size = { h = 64 + (data.topSponsors and data.sponsors and 24 or 0) },
						initialize = function(panel)
							if data.topSponsors then
								wt.CreateText({
									parent = panel,
									name = "Top",
									position = { offset = { x = 16, y = -33 } },
									width = panel:GetWidth() - 32,
									text = data.topSponsors:gsub("|", " • "),
									font = "GameFontNormalLarge",
									justify = { h = "LEFT", },
								})
							end

							if data.sponsors then
								wt.CreateText({
									parent = panel,
									name = "Normal",
									position = { offset = { x = 16, y = -33 -(data.topSponsors and 24 or 0) } },
									width = panel:GetWidth() - 32,
									text = data.sponsors:gsub("|", " • "),
									font = "GameFontHighlightMedium",
									justify = { h = "LEFT", },
								})
							end
						end,
					})

					wt.CreateText({
						parent = sponsorsPanel,
						name = "DescriptionHeart",
						position = {
							anchor = "TOPRIGHT",
							offset = { x = -12, y = -6 }
						},
						text = "♥",
						font = "NumberFont_Shadow_Large",
						justify = { h = "LEFT", },
					})
				end
			end,
			arrangement = {}
		} or nil)
	end

	---Create and set up a new settings page with profiles handling and advanced backup management options
	---***
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param t dataManagementPageCreationData Parameters are to be provided in this table
	---***
	---@return dataManagementPage|nil profilesPage Table containing references to the settings page, options widgets grouped in subtables and utility functions by category, or, if required parameters are missing, no settings page will be created and the returned value will be nil
	function wt.CreateDataManagementPage(addon, t)
		if not t.accountData or not t.characterData or not t.settingsData or not t.defaultsTable then return end

		local addonTitle = GetAddOnMetadata(addon, "Title")

		--[ Wrapper Table ]

		---@class dataManagementPage
		---@field profiles? table Collection of profiles settings widgets
		---@field backup? table Collection of backup settings widgets
		---@field backupAllProfiles? table Collection of all profiles backup settings widgets
		---@field refreshBackupBox? function
		---@field refreshAllProfilesBackupBox? function
		local dataManagement = {}

		--[ Getters & Setters ]

		---Returns the type of this object
		---***
		---@return WidgetType type ***Value:*** "DataManagementPage"
		---<hr><p></p>
		function dataManagement.getType() return "DataManagementPage" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string
		---@return boolean
		function dataManagement.isType(type) return type == "DataManagementPage" end

		---Return a value at the specified key from the table used for creating the data management page
		---@param key string
		---@return any
		function dataManagement.getProperty(key) return wt.FindKey(t, key) end

		--[ Settings Page ]

		dataManagement.page = wt.CreateSettingsPage(addon, {
			register = t.register,
			name = t.name or "DataManagement",
			title = t.title or ns.toolboxStrings.dataManagement.title,
			description = t.description or ns.toolboxStrings.dataManagement.description:gsub("#ADDON", addonTitle),
			optionsKeys = { addon .. "Backup" },
			onSave = t.onSave,
			onLoad = t.onLoad,
			onCancel = t.onCancel,
			onDefault = t.onDefaults,
			initialize = function(canvas)

				--[ Profile Management ]

				--| Utilities

				---Find a profile by its display title and return its index
				---@param title string
				---@param first? boolean ***Default:*** true
				---@return integer|nil
				local function findProfile(title, first)
					for i = 1, #t.accountData.profiles do if t.accountData.profiles[i].title == title then if first ~= false then return i else first = false end end end
				end

				---Find an unused profile name to be able to use it as an identifying display title
				---***
				---@param name? string Name tag to use as a base | ***Default:*** "Profile"
				---@param number? integer Starting value for the incremented number appended to **name** if it's used | ***Default:*** **name** *is unused* and *no number* or 2
				---@param first? boolean Stop checking for duplicate names at the first result | ***Default:*** true
				---@return string title
				local function checkName(name, number, first)
					name = name or ns.toolboxStrings.profiles.select.profile
					local title = name .. (number and (" " .. number) or "")

					--Find an unused name for the new profile
					if findProfile(title, first) then
						number = (number and number or 2)
						title = name .. " " .. number

						while findProfile(title) do
							number = number + 1
							title = name .. " " .. number
						end
					end

					return title
				end

				---Check & fix a profile data table based on the specified sample profile
				---***
				---@param profileData table Profile data table to check
				---@param compareWith? table  Profile data table to sample | ***Default:*** **t.defaultsTable**
				local function checkData(profileData, compareWith)
					compareWith = compareWith or t.defaultsTable

					wt.RemoveEmpty(profileData, t.valueChecker)
					wt.AddMissing(profileData, compareWith)
					if t.onRecovery then wt.Dump(profileData, "PRE", nil, 2) wt.RemoveMismatch(profileData, compareWith, nil, function(recoveredData) t.onRecovery(profileData, recoveredData) end)
					else wt.RemoveMismatch(profileData, compareWith) end
				end

				---Clean up a profile list table
				---***
				---@param list profile[] Reference to the profile list table
				local function validateProfiles(list)
					local i = 1

					--Check profile list
					for key, value in wt.SortedPairs(list) do
						if key == i and type(value) == "table" then
							--Check profile data
							if type(list[i].data) == "table" then checkData(list[i].data) else list[i].data = wt.Clone(t.defaultsTable) end
						else
							--Remove invalid entry
							list[key] = nil
						end

						i = i + 1
					end

					--Fill with default profile
					if not list[1] then list[1] = { title = ns.toolboxStrings.profiles.select.main, data = wt.Clone(t.defaultsTable) } end

					--Check profile names
					for i = 1, #list do list[i].title = checkName(list[i].title, nil, false) end
				end

				---Activate the specified profile
				---***
				---@param index integer Index of the profile to activate
				---@return number|nil
				local function activateProfile(index)
					if type(index) ~= "number" then return end

					index = Clamp(index, 1, #t.accountData.profiles)
					t.characterData.activeProfile = index

					--Call listener
					if t.onProfileActivated then t.onProfileActivated(t.characterData.activeProfile) end

					return t.characterData.activeProfile
				end

				---Activate the specified settings profile
				---***
				---@param index integer Index of the profile to set as the currently active settings profile
				function dataManagement.activateProfile(index)
					if not activateProfile(index) then return end

					--Update dropdown selection
					if dataManagement.profiles then dataManagement.profiles.apply.setSelected(index) end
				end

				---Create a new settings profile
				---***
				---@param name? string Name tag to use when setting the display title of the new profile | ***Default:*** **duplicate** and **t.accountData.profiles[duplicate].title** or "Profile"
				---@param number? integer Starting value for the incremented number appended to **name** if it's used | ***Default:*** **duplicate** == nil and **name** *is unused* and *no number* or 2
				---@param duplicate? integer Index of the profile to create the new profile as a duplicate of instead of using default data values
				---@param apply? boolean Whether to immediately set the new profile as the active profile or not | ***Default:*** true
				---@param index? integer Place the new profile under this specified index in **t.accountData.profile** instead of the end of the list | ***Range:*** (1, #**t.accountData.profiles** + 1)
				function dataManagement.newProfile(name, number, duplicate, index, apply)
					duplicate = t.accountData.profiles[duplicate] and duplicate or nil
					index = Clamp(index or #t.accountData.profiles + 1, 1, #t.accountData.profiles + 1)

					--Create profile data
					table.insert(t.accountData.profiles, index, {
						title = checkName(duplicate and t.accountData.profiles[duplicate].title or name, number),
						data = wt.Clone(duplicate and t.accountData.profiles[duplicate] or t.defaultsTable)
					})

					--Update dropdown items
					if dataManagement.profiles then dataManagement.profiles.apply.updateItems(t.accountData.profiles) end

					--Call listener
					if t.onProfileCreated then t.onProfileCreated(index) end

					--Activate the new profile
					if apply ~= false then dataManagement.activateProfile(index) end
				end

				---Delete the specified profile
				---***
				---@param index? integer Index of the profile to delete the data and dropdown item of | ***Default:*** **t.characterData.activeProfile**
				function dataManagement.deleteProfile(index)
					if index and not t.accountData.profiles[index] then return end

					index = index or t.characterData.activeProfile
					local title = t.accountData.profiles[index].title

					--Delete profile data
					table.remove(t.accountData.profiles, index)

					--Update dropdown items
					if dataManagement.profiles then dataManagement.profiles.apply.updateItems(t.accountData.profiles) end

					--Call listener
					if t.onProfileDeleted then t.onProfileDeleted(title, index) end

					--Activate the replacement profile
					if t.characterData.activeProfile == index then activateProfile(index) end
				end

				---Restore the specified profile data to default values
				---***
				---@param index? integer Index of the profile to restore to defaults | ***Default:*** **t.characterData.activeProfile**
				function dataManagement.resetProfile(index)
					if index and not t.accountData.profiles[index] then return end

					index = index or t.characterData.activeProfile

					--Update the profile in storage (without breaking table references)
					wt.CopyValues(t.accountData.profiles[index].data, t.defaultsTable)

					--Call listener
					if t.onProfileReset then t.onProfileReset(t.characterData.activeProfile) end
				end

				---Load profiles data
				---***
				---@param p? profileStorage Table holding the list of profiles to store | ***Default:*** *validate* **t.accountData** *(if the data is missing or invalid, set up a default profile)*
				---@param activeProfile? integer Index of the active profile to set | ***Default:*** **t.characterData.activeProfile** *clamped to fit* #**p.profiles** or 1
				local function loadProfiles(p, activeProfile)

					--| Profile list

					if type(p) == "table" then
						p.profiles = type(p.profiles) == "table" and p.profiles or {}

						validateProfiles(p.profiles)

						--Update the profile list in storage (without breaking table references)
						for i = 1, #p.profiles do
							t.accountData.profiles[i].title = p.profiles[i].title
							wt.CopyValues(t.accountData.profiles[i].data, p.profiles[i].data)
						end
					else
						t.accountData.profiles = type(t.accountData.profiles) == "table" and t.accountData.profiles or {}

						validateProfiles(t.accountData.profiles)
					end

					--| Activate profile

					t.characterData.activeProfile = Clamp(t.accountData.profiles[activeProfile] and activeProfile or t.characterData.activeProfile or 1, 1, #t.accountData.profiles)

					--| Recover misplaced data

					local recovered = {}

					--Remove & save misplaced possibly valuable data
					for key, value in pairs(t.accountData) do if key ~= "profiles" then
						recovered[key] = value
						t.accountData[key] = nil
					end end

					if next(recovered) then
						--Pack recovered data into the active profile data table (to be removed later if found irrelevant or invalid during validation)
						for key, value in pairs(recovered) do t.accountData.profiles[t.characterData.activeProfile].data[key] = value end

						--Validate active profile data
						checkData(t.accountData.profiles[t.characterData.activeProfile].data)
					end

					--| Call listener

					if t.onProfilesLoaded then t.onProfilesLoaded() end
				end

				--| Initialization

				loadProfiles()

				--[ GUI Widgets ]

				if not WidgetToolsDB.lite then

					--[ Profiles ]

					dataManagement.profiles = {}

					dataManagement.profiles.frame = wt.CreatePanel({
						parent = canvas,
						name = "Profiles",
						title = ns.toolboxStrings.profiles.title,
						description = ns.toolboxStrings.profiles.description:gsub("#ADDON", addonTitle),
						arrange = {},
						size = { h = 64 },
						initialize = function(panel)
							dataManagement.profiles.apply = wt.CreateDropdownSelector({
								parent = panel,
								title = ns.toolboxStrings.profiles.select.label,
								tooltip = ns.toolboxStrings.profiles.select.tooltip,
								arrange = {},
								width = 180,
								items = t.accountData.profiles,
								selected = t.characterData.activeProfile,
								onSelection = activateProfile,
							})

							dataManagement.profiles.new = wt.CreateButton({
								parent = panel,
								name = "New",
								title = ns.toolboxStrings.profiles.new.label,
								tooltip = { lines = { { text = ns.toolboxStrings.profiles.new.tooltip, }, } },
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -312, y = -30 }
								},
								size = { w = 112, h = 26 },
								action = function() dataManagement.newProfile(nil, #t.accountData.profiles) end,
							})

							dataManagement.profiles.duplicate = wt.CreateButton({
								parent = panel,
								name = "Duplicate",
								title = ns.toolboxStrings.profiles.duplicate.label,
								tooltip = { lines = { { text = ns.toolboxStrings.profiles.duplicate.tooltip, }, } },
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -192, y = -30 }
								},
								size = { w = 112, h = 26 },
								action = function() dataManagement.newProfile(nil, nil, t.characterData.activeProfile) end,
							})

							dataManagement.profiles.rename = wt.CreateButton({
								parent = panel,
								name = "Rename",
								title = ns.toolboxStrings.profiles.rename.label,
								tooltip = { lines = { { text = ns.toolboxStrings.profiles.rename.tooltip, }, } },
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -92, y = -30 }
								},
								size = { w = 92, h = 26 },
								action = function()
									wt.CreatePopupInputBox({
										title = ns.toolboxStrings.profiles.rename.description:gsub(
											"#PROFILE", WrapTextInColorCode(t.accountData.profiles[t.characterData.activeProfile].title, "FFFFFFFF")
										),
										position = {
											anchor = "TOPRIGHT",
											offset = { x = -92, y = -30 },
											relativeTo = panel,
										},
										text = t.accountData.profiles[t.characterData.activeProfile].title,
										accept = function(text)
											t.accountData.profiles[t.characterData.activeProfile].title = text

											--Update dropdown items
											dataManagement.profiles.apply.updateItems(t.accountData.profiles)
										end,
									})
								end,
							})

							local deleteProfilePopup = wt.CreatePopupDialogueData(addon, "DELETE_PROFILE", {
								text = ns.toolboxStrings.profiles.delete.warning,
								accept = DELETE,
								onAccept = function() dataManagement.deleteProfile() end,
							})

							dataManagement.profiles.delete = wt.CreateButton({
								parent = panel,
								name = "Delete",
								title = DELETE,
								tooltip = { lines = { { text = ns.toolboxStrings.profiles.delete.tooltip, }, } },
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -12, y = -30 }
								},
								size = { w = 72, h = 26 },
								action = function() StaticPopup_Show(deleteProfilePopup) end,
								dependencies = { { frame = dataManagement.profiles.apply, evaluate = function() return #t.accountData.profiles > 1 end }, }
							})
						end,
						arrangement = {}
					})

					--[ Backup ]

					dataManagement.backup = {}
					dataManagement.backupAllProfiles = {}

					dataManagement.backup.frame = wt.CreatePanel({
						parent = canvas,
						name = "Backup",
						title = ns.toolboxStrings.backup.title,
						description = ns.toolboxStrings.backup.description:gsub("#ADDON", addonTitle),
						arrange = {},
						size = { h = canvas:GetHeight() - 214 },
						initialize = function(panel)

							--[ Utilities ]

							--Update the backup box and load the current profile data of the selected scope to the backup string, formatted based on the compact setting
							function dataManagement.refreshBackupBox()
								dataManagement.backup.box.setText(wt.TableToString(t.accountData.profiles[t.characterData.activeProfile].data, t.settingsData.compactBackup))

								--Set focus after text change to set the scroll to the top and refresh the position character counter
								dataManagement.backup.box.scrollFrame.EditBox:SetFocus()
								dataManagement.backup.box.scrollFrame.EditBox:ClearFocus()
							end

							--Update the backup box and load all addon profile data of the selected scope to the backup string, formatted based on the compact setting
							function dataManagement.refreshAllProfilesBackupBox()
								dataManagement.backupAllProfiles.box.setText(wt.TableToString({
									activeProfile = t.characterData.activeProfile,
									profiles = t.accountData.profiles
								}, t.settingsData.compactBackup))

								--Set focus after text change to set the scroll to the top and refresh the position character counter
								dataManagement.backupAllProfiles.box.scrollFrame.EditBox:SetFocus()
								dataManagement.backupAllProfiles.box.scrollFrame.EditBox:ClearFocus()
							end

							--[ Active Profile ]

							dataManagement.backup.box = wt.CreateMultilineTextbox({
								parent = panel,
								name = "ImportExport",
								title = ns.toolboxStrings.backup.box.label,
								tooltip = { lines = {
									{ text = ns.toolboxStrings.backup.box.tooltip[1], },
									{ text = "\n" .. ns.toolboxStrings.backup.box.tooltip[2], },
									{ text = "\n" .. ns.toolboxStrings.backup.box.tooltip[3], },
									{ text = ns.toolboxStrings.backup.box.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 }, },
									{ text = "\n" .. ns.toolboxStrings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
								}, },
								arrange = {},
								size = { w = panel:GetWidth() - 24, h = panel:GetHeight() - 76 },
								font = { normal = "GameFontWhiteSmall", },
								scrollSpeed = 0.2,
								scrollToTop = false,
								unfocusOnEnter = false,
								optionsData = {
									optionsKey = addon .. "Backup",
									onLoad = dataManagement.refreshBackupBox,
								}
							})

							dataManagement.backup.compact = wt.CreateCheckbox({
								parent = panel,
								name = "Compact",
								title = ns.toolboxStrings.backup.compact.label,
								tooltip = { lines = { { text = ns.toolboxStrings.backup.compact.tooltip, }, } },
								position = {
									anchor = "BOTTOMLEFT",
									offset = { x = 12, y = 12 }
								},
								optionsData = {
									optionsKey = addon .. "Backup",
									storageTable = t.settingsData,
									storageKey = "compactBackup",
									onChange = { RefreshBackupBox = dataManagement.refreshBackupBox }
								}
							})

							local importPopup = wt.CreatePopupDialogueData(addon, "IMPORT", {
								text = ns.toolboxStrings.backup.warning,
								accept = ns.toolboxStrings.backup.import,
								onAccept = function()
									local success, load = pcall(loadstring("return " .. wt.Clear(dataManagement.backup.box.getText())))
									success = success and type(load) == "table"

									if success then
										checkData(load, t.accountData.profiles[t.characterData.activeProfile].data)
										wt.CopyValues(t.accountData.profiles[t.characterData.activeProfile].data, load)
									end

									t.onImport(success, load)
								end,
							})

							dataManagement.backup.load = wt.CreateButton({
								parent = panel,
								name = "Load",
								title = ns.toolboxStrings.backup.load.label,
								tooltip = { lines = {
									{ text = ns.toolboxStrings.backup.load.tooltip, },
									{ text = "\n" .. ns.toolboxStrings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
								} },
								arrange = {},
								size = { h = 26 },
								action = function() StaticPopup_Show(importPopup) end,
							})

							dataManagement.backup.reset = wt.CreateButton({
								parent = panel,
								name = "Reset",
								title = RESET,
								tooltip = { lines = { { text = ns.toolboxStrings.backup.reset.tooltip, }, } },
								position = {
									anchor = "BOTTOMRIGHT",
									offset = { x = -100, y = 12 }
								},
								size = { h = 26 },
								action = dataManagement.refreshBackupBox,
							})

							--[ All Profiles ]

							local allProfilesBackupFrame = wt.CreatePanel({
								parent = canvas,
								name = addon .. "AllProfilesBackup",
								append = false,
								title = ns.toolboxStrings.backup.allProfiles.title,
								position = { anchor = "BOTTOMRIGHT", },
								keepInBounds = true,
								size = { w = 678, h = 610 },
								frameStrata = "DIALOG",
								keepOnTop = true,
								background = { color = { a = 0.9 }, },
								initialize = function(windowPanel)
									dataManagement.backupAllProfiles.box = wt.CreateMultilineTextbox({
										parent = windowPanel,
										name = "ImportExportAllProfiles",
										title = ns.toolboxStrings.backup.allProfiles.label,
										label = false,
										tooltip = { lines = {
											{ text = ns.toolboxStrings.backup.allProfiles.tooltipLine, },
											{ text = "\n" .. ns.toolboxStrings.backup.box.tooltip[2], },
											{ text = "\n" .. ns.toolboxStrings.backup.box.tooltip[3], },
											{ text = ns.toolboxStrings.backup.box.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 }, },
											{ text = "\n" .. ns.toolboxStrings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
										}, },
										arrange = {},
										size = { w = windowPanel:GetWidth() - 32, h = windowPanel:GetHeight() - 88 },
										font = { normal = "GameFontWhiteSmall", },
										scrollSpeed = 0.2,
										scrollToTop = false,
										unfocusOnEnter = false,
										optionsData = {
											optionsKey = addon .. "Backup",
											onLoad = dataManagement.refreshAllProfilesBackupBox,
										}
									})

									wt.CreateButton({
										parent = windowPanel,
										name = "CloseButton",
										title = CLOSE,
										arrange = {},
										size = { w = 96, },
										action = function() windowPanel:Hide() end,
									})

									_G[windowPanel:GetName() .. "Title"]:SetPoint("TOPLEFT", 18, -18)

									windowPanel:EnableMouse(true)
									windowPanel:Hide()
								end,
								arrangement = { parameters = {
									margins = { l = 16, r = 16, t = 42, b = 16 },
									flip = true,
								}, }
							})

							wt.CreateButton({
								parent = panel,
								name = "OpenAllProfilesBackup",
								title = ns.toolboxStrings.backup.allProfiles.open.label,
								tooltip = ns.toolboxStrings.backup.allProfiles.open.tooltip,
								position = {
									anchor = "TOPRIGHT",
									relativeTo = dataManagement.backup.box.frame,
									relativePoint = "TOPRIGHT",
									offset = { x = -3, y = 2 }
								},
								size = { w = 216, h = 14 },
								frameLevel = dataManagement.backup.box.frame:GetFrameLevel() + 1, --Make sure it's on top to be clickable
								font = {
									normal = "GameFontNormalSmall",
									highlight = "GameFontHighlightSmall",
								},
								action = function()
									allProfilesBackupFrame:Show()

									dataManagement.backupAllProfiles.compact.setState(t.settingsData.compactBackup)

									dataManagement.refreshAllProfilesBackupBox()
								end,
							})

							dataManagement.backupAllProfiles.compact = wt.CreateCheckbox({
								parent = allProfilesBackupFrame,
								name = "Compact",
								title = ns.toolboxStrings.backup.compact.label,
								tooltip = { lines = { { text = ns.toolboxStrings.backup.compact.tooltip, }, } },
								position = {
									anchor = "BOTTOMLEFT",
									offset = { x = 12, y = 12 }
								},
								events = { OnClick = function()
									dataManagement.backup.compact.setData(not t.settingsData.compactBackup)

									dataManagement.refreshAllProfilesBackupBox()
								end},
							})

							local allProfilesImportPopup = wt.CreatePopupDialogueData(addon, "IMPORT_AllProfiles", {
								text = ns.toolboxStrings.backup.warning,
								accept = ns.toolboxStrings.backup.import,
								onAccept = function()
									local success, data = pcall(loadstring("return " .. wt.Clear(dataManagement.backupAllProfiles.box.getText())))
									data = type(data) == "table" and data or {}

									if success then loadProfiles(data.profiles, data.activeProfile) end

									--Set dropdown items 
									dataManagement.profiles.apply.updateItems(t.accountData.profiles)

									t.onImportAllProfiles(success and type(data) == "table", data)
								end,
							})

							dataManagement.backupAllProfiles.load = wt.CreateButton({
								parent = allProfilesBackupFrame,
								name = "Load",
								title = ns.toolboxStrings.backup.load.label,
								tooltip = { lines = {
									{ text = ns.toolboxStrings.backup.load.tooltip, },
									{ text = "\n" .. ns.toolboxStrings.backup.box.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
								} },
								position = {
									anchor = "BOTTOM",
									offset = { x = 45, y = 12 }
								},
								size = { h = 26 },
								action = function() StaticPopup_Show(allProfilesImportPopup) end,
							})

							dataManagement.backupAllProfiles.reset = wt.CreateButton({
								parent = allProfilesBackupFrame,
								name = "Reset",
								title = RESET,
								tooltip = { lines = { { text = ns.toolboxStrings.backup.reset.tooltip, }, } },
								position = {
									anchor = "BOTTOM",
									offset = { x = -45, y = 12 }
								},
								size = { h = 26 },
								action = dataManagement.refreshAllProfilesBackupBox,
							})
						end,
						arrangement = { parameters = {
							flip = true,
							resize = false
						}, }
					})
				end
			end,
			arrangement = {},
		})

		return dataManagement
	end

	--[ Settings Widget Panels ]

	--| Positioning

	local positioningVisualAids = {}
	if WidgetToolsDB.lite then WidgetToolsDB.positioningAids = false end

	---Create and set up position options for a specified frame within a panel frame
	---***
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param t positionOptionsCreationData Parameters are to be provided in this table
	---***
	---@return positionPanel table Components of the options panel wrapped in a table
	function wt.CreatePositionOptions(addon, t)

		--[ Wrapper Table ]

		---@class positionPanel
		---@field layer? table
		---@field presets? table
		local panel = {}

		--[ Visual Aids ]

		if WidgetToolsDB.positioningAids then
			positioningVisualAids.frame = positioningVisualAids.frame or wt.CreateBaseFrame({
				name = "WidgetToolsPositioningVisualAids",
				position = { anchor = "CENTER", },
				size = { w = UIParent:GetWidth() - 14, h = UIParent:GetHeight() - 14 },
				visible = false,
				frameStrata = "BACKGROUND",
				initialize = function(container)

					--[ Textures ]

					-- positioningVisualAids.highlight = positioningVisualAids.highlight or wt.CreateTexture({
					-- 	parent = container,
					-- 	name = "Highlight",
					-- 	wrap = { h = true, v = true },
					-- 	color = ns.colors.halfTransparent.grey,
					-- 	events = {
					-- 		OnEnter = function() positioningVisualAids.highlight:SetColorTexture(wt.UnpackColor(ns.colors.halfTransparent.blue)) end,
					-- 		OnLeave = function() positioningVisualAids.highlight:SetColorTexture(wt.UnpackColor(ns.colors.halfTransparent.grey)) end
					-- 	}
					-- })

					positioningVisualAids.anchor = positioningVisualAids.anchor or wt.CreateTexture({
						parent = container,
						name = "Anchor",
						size = { w = 14, h = 14 },
						path = "Interface/Common/common-mask-diamond",
					})

					positioningVisualAids.relativePoint = positioningVisualAids.relativePoint or wt.CreateTexture({
						parent = container,
						name = "RelativePoint",
						size = { w = 14, h = 14 },
						path = "Interface/Common/common-iconmask",
					})

					positioningVisualAids.line = positioningVisualAids.line or wt.CreateLine({
						parent = container,
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
					---@param frame Frame
					---@param position positionData_base
					function positioningVisualAids.update(frame, position)
						--Anchor
						wt.SetPosition(positioningVisualAids.anchor, {
							anchor = "CENTER",
							relativeTo = frame,
							relativePoint = position.anchor,
						})

						--Relative Point
						wt.SetPosition(positioningVisualAids.relativePoint, {
							anchor = "CENTER",
							relativeTo = positioningVisualAids.frame,
							relativePoint = position.relativePoint,
						})
					end

					function positioningVisualAids.show(frame, position)
						positioningVisualAids.frame:Show()
						positioningVisualAids.frame:SetScale(UIParent:GetScale())

						--Highlight
						-- wt.SetPosition(positioningVisualAids.highlight, {
						-- 	anchor = "CENTER",
						-- 	relativeTo = t.frame,
						-- })
						-- positioningVisualAids.highlight:SetSize(t.frame:GetSize())

						--Points
						positioningVisualAids.update(frame, position)
					end
				end
			})

			--Update the size of the highlight aid
			-- t.frame:HookScript("OnSizeChanged", function(_, ...) if positioningVisualAids.frame:IsVisible() then positioningVisualAids.highlight:SetSize(...) end end)

			--[ Toggle ]

			t.canvas:HookScript("OnShow", function() positioningVisualAids.show(t.frame, t.workingTable.position) end)
			t.canvas:HookScript("OnHide", function() positioningVisualAids.frame:Hide() end)
		end

		--[ Options Panel ]

		panel.frame = wt.CreatePanel({
			parent = t.canvas,
			name = "Position",
			title = ns.toolboxStrings.position.title,
			description = ns.toolboxStrings.position.description[t.setMovable and "movable" or "static"]:gsub("#FRAME", t.frameName),
			arrange = {},
			initialize = function(panelFrame)

				--[ Presets ]

				if t.presets then
					panel.presets = {}
					panel.presetList = t.presets.items

					--| Utilities

					local applyPreset = function(i)
						if not (panel.presetList[i] or {}).data then
							--Call the specified handler
							if t.presets.onPreset then t.presets.onPreset(i) end

							return
						end

						--Position
						if panel.presetList[i].data.position then
							--Update the frame
							wt.SetPosition(t.frame, panel.presetList[i].data.position, true)

							--Update the working table
							wt.ConvertToAbsolutePosition(t.frame)
							wt.CopyValues(t.workingTable.position, wt.PackPosition(t.frame:GetPoint()))

							--Update the options widgets
							panel.position.anchor.loadData(false)
							panel.position.relativePoint.loadData(false)
							-- panel.position.relativeTo.loadData(false)
							panel.position.offset.x.loadData(false)
							panel.position.offset.y.loadData(false)
						end

						--Keep in bounds
						if panel.presetList[i].data.keepInBounds then
							t.frame:SetClampedToScreen(panel.presetList[i].data.keepInBounds) --Update the frame
							t.workingTable.keepInBounds = panel.presetList[i].data.keepInBounds --Update the working table
							if panel.position.keepInBounds then panel.position.keepInBounds.loadData(false) end --Update the options widget
						end

						--Screen Layer
						if panel.presetList[i].data.layer then
							--Frame strata
							if panel.presetList[i].data.layer.strata then
								t.frame:SetFrameStrata(panel.presetList[i].data.layer.strata) --Update the frame
								t.workingTable.layer.strata = panel.presetList[i].data.layer.strata --Update the working table
								if panel.layer.strata then panel.layer.strata.loadData(false) end --Update the options widget
							end

							--Keep on top
							if panel.presetList[i].data.layer.keepOnTop then
								t.frame:SetToplevel(panel.presetList[i].data.layer.keepOnTop) --Update the frame
								t.workingTable.layer.keepOnTop = panel.presetList[i].data.layer.keepOnTop --Update the working table
								if panel.layer.keepOnTop then panel.layer.keepOnTop.loadData(false) end --Update the options widget
							end

							--Frame level
							if panel.presetList[i].data.layer.level then
								t.frame:SetFrameLevel(panel.presetList[i].data.layer.level) --Update the frame
								t.workingTable.layer.level = panel.presetList[i].data.layer.level --Update the working table
								if panel.layer.level then panel.layer.level.loadData(false) end --Update the options widget
							end
						end

						--Update the positioning visual aids
						if WidgetToolsDB.positioningAids then positioningVisualAids.update(t.frame, t.workingTable.position) end

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
						if not i or i < 1 or i > #panel.presetList then return false end

						--Apply the preset data to the frame & update the options widgets
						applyPreset(i)

						--Update the preset selection
						panel.presets.apply.setSelected(i)

						--Update the storage table
						if t.storageTable then
							wt.CopyValues(t.storageTable.position, t.workingTable.position)
							if t.storageTable.keepInBounds ~= nil then t.storageTable.keepInBounds = t.workingTable.keepInBounds end
							if t.storageTable.layer then wt.CopyValues(t.storageTable.layer, t.workingTable.layer) end
						end

						return true
					end

					--| Options widgets

					panel.presets.apply = wt.CreateDropdownSelector({
						parent = panelFrame,
						name = "ApplyPreset",
						title = ns.toolboxStrings.presets.apply.label,
						tooltip = { lines = { { text = ns.toolboxStrings.presets.apply.tooltip:gsub("#FRAME", t.frameName), }, } },
						arrange = {},
						width = 180,
						items = panel.presetList,
						onSelection = applyPreset,
						optionsData = {
							optionsKey = t.optionsKey,
							onLoad = function(self) self.setSelected(nil, nil, ns.toolboxStrings.presets.apply.select) end,
						}
					})

					--[ Custom Preset ]

					if t.presets.custom then
						t.presets.custom.index = t.presets.custom.index or 1
						t.presets.items[t.presets.custom.index].data = t.presets.custom.workingTable

						--| Utilities

						---Save the current position & visibility to the custom preset
						--- - ***Note:*** If the custom preset position data doesn't contain relative frame and point key, value pairs, the position will be converted to absolute position when saved.
						function panel.saveCustomPreset()
							--Update the custom preset
							panel.presetList[t.presets.custom.index].data.position = wt.PackPosition(t.frame:GetPoint())
							if panel.presetList[t.presets.custom.index].data.keepInBounds then
								panel.presetList[t.presets.custom.index].data.keepInBounds = t.frame:IsClampedToScreen()
							end
							if (panel.presetList[t.presets.custom.index].data.layer or {}).strata then
								panel.presetList[t.presets.custom.index].data.layer.strata = t.frame:GetFrameStrata()
							end
							if (panel.presetList[t.presets.custom.index].data.layer or {}).keepOnTop then
								panel.presetList[t.presets.custom.index].data.layer.keepOnTop = t.frame:IsToplevel()
							end
							if (panel.presetList[t.presets.custom.index].data.layer or {}).level then
								panel.presetList[t.presets.custom.index].data.layer.level = t.frame:IsToplevel()
							end

							--Save the custom preset
							wt.CopyValues(t.presets.custom.workingTable, panel.presetList[t.presets.custom.index].data)
							if t.presets.custom.storageTable then wt.CopyValues(t.presets.custom.storageTable, t.presets.custom.workingTable) end

							--Update the preset selection
							panel.presets.apply.setSelected(t.presets.custom.index)

							--Call the specified handler
							if t.presets.custom.onSave then t.presets.custom.onSave() end
						end

						--Reset the custom preset to its default state
						function panel.resetCustomPreset()
							--Reset the custom preset
							panel.presetList[t.presets.custom.index].data = wt.Clone(t.presets.custom.defaultsTable)

							--Save the custom preset
							wt.CopyValues(t.presets.custom.workingTable, panel.presetList[t.presets.custom.index].data)
							if t.presets.custom.storageTable then wt.CopyValues(t.presets.custom.storageTable, t.presets.custom.workingTable) end

							--Apply the custom preset
							panel.applyPreset(t.presets.custom.index)

							--Call the specified handler
							if t.presets.custom.onReset then t.presets.custom.onReset() end
						end

						--| Options Widgets

						local savePopup = wt.CreatePopupDialogueData(addon, "SAVEPRESET", {
							text = ns.toolboxStrings.presets.save.warning:gsub("#CUSTOM", panel.presetList[t.presets.custom.index].title),
							accept = ns.toolboxStrings.override,
							onAccept = panel.saveCustomPreset,
						})

						panel.presets.save = wt.CreateButton({
							parent = panelFrame,
							name = "SavePreset",
							title = ns.toolboxStrings.presets.save.label:gsub("#CUSTOM", panel.presetList[t.presets.custom.index].title),
							tooltip = { lines = {
								{ text = ns.toolboxStrings.presets.save.tooltip:gsub("#FRAME", t.frameName):gsub("#CUSTOM", panel.presetList[t.presets.custom.index].title), },
							} },
							arrange = { newRow = false, },
							size = { w = 170, h = 26 },
							action = function() StaticPopup_Show(savePopup) end,
							dependencies = t.dependencies
						})

						local resetPopup = wt.CreatePopupDialogueData(addon, "RESETPRESET", {
							text = ns.toolboxStrings.presets.reset.warning:gsub("#CUSTOM", panel.presetList[t.presets.custom.index].title),
							accept = ns.toolboxStrings.override,
							onAccept = panel.resetCustomPreset,
						})

						panel.presets.reset = wt.CreateButton({
							parent = panelFrame,
							name = "ResetPreset",
							title = ns.toolboxStrings.presets.reset.label:gsub("#CUSTOM", panel.presetList[t.presets.custom.index].title),
							tooltip = { lines = { { text = ns.toolboxStrings.presets.reset.tooltip:gsub("#CUSTOM", panel.presetList[t.presets.custom.index].title), }, } },
							arrange = { newRow = false, },
							size = { w = 170, h = 26 },
							action = function() StaticPopup_Show(resetPopup) end,
						})
					end
				end

				--[ Position ]

				panel.position = { offset = {}, }
				local previousAnchor = t.workingTable.position.anchor

				panel.position.relativePoint = wt.CreateSpecialSelector("anchor", {
					parent = panelFrame,
					name = "RelativePoint",
					title = ns.toolboxStrings.position.relativePoint.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.relativePoint.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = {},
					width = 140,
					onSelection = t.presets and function() panel.presets.apply.setSelected(nil, nil, ns.toolboxStrings.presets.apply.select) end or nil,
					dependencies = t.dependencies,
					optionsData = {
						optionsKey = t.optionsKey,
						workingTable = t.workingTable.position,
						storageKey = "relativePoint",
						onChange = {
							CustomPositionChangeHandler = function() if type(t.onChangePosition) == "function" then t.onChangePosition() end end,
							UpdateFramePosition = function() wt.SetPosition(t.frame, t.workingTable.position, true) end,
							UpdatePositioningVisualAids = function() if WidgetToolsDB.positioningAids then positioningVisualAids.update(t.frame, t.workingTable.position) end end,
						}
					}
				})

				panel.position.anchor = wt.CreateSpecialSelector("anchor", {
					parent = panelFrame,
					name = "AnchorPoint",
					title = ns.toolboxStrings.position.anchor.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.anchor.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = { newRow = false, },
					width = 140,
					onSelection = t.presets and function() panel.presets.apply.setSelected(nil, nil, ns.toolboxStrings.presets.apply.select) end or nil,
					dependencies = t.dependencies,
					optionsData = {
						optionsKey = t.optionsKey,
						workingTable = t.workingTable.position,
						storageKey = "anchor",
						onChange = {
							UpdateFrameOffsetsAndPosition = function() if not t.settingsData.keepInPlace then wt.SetPosition(t.frame, t.workingTable.position, true) else
								local x, y = 0, 0

								if previousAnchor:find("LEFT") then
									if t.workingTable.position.anchor:find("RIGHT") then x = -t.frame:GetWidth()
									elseif t.workingTable.position.anchor == "CENTER" or t.workingTable.position.anchor == "TOP" or t.workingTable.position.anchor == "BOTTOM" then
										x = -t.frame:GetWidth() / 2
									end
								elseif previousAnchor:find("RIGHT") then
									if t.workingTable.position.anchor:find("LEFT") then x = t.frame:GetWidth()
									elseif t.workingTable.position.anchor == "CENTER" or t.workingTable.position.anchor == "TOP" or t.workingTable.position.anchor == "BOTTOM" then
										x = t.frame:GetWidth() / 2
									end
								elseif previousAnchor == "CENTER" or previousAnchor == "TOP" or previousAnchor == "BOTTOM" then
									if t.workingTable.position.anchor:find("LEFT") then x = t.frame:GetWidth() / 2
									elseif t.workingTable.position.anchor:find("RIGHT") then x = -t.frame:GetWidth() / 2 end
								end

								if previousAnchor:find("TOP") then
									if t.workingTable.position.anchor:find("BOTTOM") then y = t.frame:GetHeight()
									elseif t.workingTable.position.anchor == "CENTER" or t.workingTable.position.anchor == "LEFT" or t.workingTable.position.anchor == "RIGHT" then
										y = t.frame:GetHeight() / 2
									end
								elseif previousAnchor:find("BOTTOM") then
									if t.workingTable.position.anchor:find("TOP") then y = -t.frame:GetHeight()
									elseif t.workingTable.position.anchor == "CENTER" or t.workingTable.position.anchor == "LEFT" or t.workingTable.position.anchor == "RIGHT" then
										y = -t.frame:GetHeight() / 2
									end
								elseif previousAnchor == "CENTER" or previousAnchor == "LEFT" or previousAnchor == "RIGHT" then
									if t.workingTable.position.anchor:find("TOP") then y = -t.frame:GetHeight() / 2
									elseif t.workingTable.position.anchor:find("BOTTOM") then y = t.frame:GetHeight() / 2 end
								end

								previousAnchor = t.workingTable.position.anchor

								--Update offsets
								panel.position.offset.x.setData(t.workingTable.position.offset.x - x, false, false)
								panel.position.offset.y.setData(t.workingTable.position.offset.y - y, false, false)

								--Update frame position
								wt.SetPosition(t.frame, t.workingTable.position, true)
							end end,
							"CustomPositionChangeHandler",
							"UpdatePositioningVisualAids"
						}
					}
				})

				panel.position.keepInPlace = wt.CreateCheckbox({
					parent = panelFrame,
					name = "KeepInPlace",
					title = ns.toolboxStrings.position.keepInPlace.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.keepInPlace.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = { newRow = false, },
					dependencies = t.dependencies,
					optionsData = {
						optionsKey = t.optionsKey,
						workingTable = t.settingsData,
						storageKey = "keepInPlace",
					}
				})

				panel.position.offset.x = wt.CreateNumericSlider({
					parent = panelFrame,
					name = "OffsetX",
					title = ns.toolboxStrings.position.offsetX.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.offsetX.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = {},
					value = { min = -500, max = 500, fractional = 2 },
					step = 1,
					altStep = 25,
					events = t.presets and {
						OnValueChanged = function(_, _, user) if user then panel.presets.apply.setSelected(nil, nil, ns.toolboxStrings.presets.apply.select) end end,
					} or nil,
					dependencies = t.dependencies,
					optionsData = {
						optionsKey = t.optionsKey,
						workingTable = t.workingTable.position.offset,
						storageKey = "x",
						onChange = {
							"CustomPositionChangeHandler",
							"UpdateFramePosition",
						}
					}
				})

				panel.position.offset.y = wt.CreateNumericSlider({
					parent = panelFrame,
					name = "OffsetY",
					title = ns.toolboxStrings.position.offsetY.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.offsetY.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = { newRow = false, },
					value = { min = -500, max = 500, fractional = 2 },
					step = 1,
					altStep = 25,
					events = t.presets and {
						OnValueChanged = function(_, _, user) if user then panel.presets.apply.setSelected(nil, nil, ns.toolboxStrings.presets.apply.select) end end,
					} or nil,
					dependencies = t.dependencies,
					optionsData = {
						optionsKey = t.optionsKey,
						workingTable = t.workingTable.position.offset,
						storageKey = "y",
						onChange = {
							"CustomPositionChangeHandler",
							"UpdateFramePosition",
						}
					}
				})

				if t.workingTable.keepInBounds ~= nil then panel.position.keepInBounds = wt.CreateCheckbox({
					parent = panelFrame,
					name = "KeepInBounds",
					title = ns.toolboxStrings.position.keepInBounds.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.keepInBounds.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = { newRow = false, },
					dependencies = t.dependencies,
					optionsData = {
						optionsKey = t.optionsKey,
						workingTable = t.workingTable,
						storageKey = "keepInBounds",
						onChange = {
							CustomKeepInBoundsChangeHandler = function() if type(t.onChangeKeepInBounds) == "function" then t.onChangeKeepInBounds() end end,
							UpdateScreenClamp = function() t.frame:SetClampedToScreen(t.workingTable.keepInBounds) end,
						}
					}
				}) end

				-- panel.position.relativeTo = wt.CreateEditBox({ --TODO: Try out GetMouseFocus() instead
				-- 	parent = panelFrame,
				-- 	name = "RelativeFrame",
				-- 	title = strings.position.relativeTo.label,
				-- 	tooltip = { lines = { { text = strings.position.relativeTo.tooltip:gsub("#FRAME", t.frameName), }, } },
				-- 	arrange = { newRow = false, },
				-- 	width = 170,
				-- 	events = {
				-- 		OnTextChanged = function(self, _, text)
				-- 			print("SET TEXT CHANGED", t.frameName, text) --REMOVE
				-- 			if text then
				-- 				text = wt.Clear(text)
				-- 				self:SetText(wt.Color(text, wt.ToFrame(text) and { r = 1, g = 1, b = 1 } or { r = 1, g = 0.3, b = 0.3 }))
				-- 			else self:SetText("") end
				-- 		end,
				-- 		OnEnterPressed = function(self, text) local l = wt.ToFrame(wt.Clear(text)) if not l then
				-- 			self:SetText("")
				-- 			print("ON ENTER PRESSED", l) --REMOVE
				-- 			panel.position.relativePoint.setSelected(nil)
				-- 		end end,
				-- 		OnEscapePressed = function(self) self:SetText(t.workingTable.position.relativeTo) end,
				-- 	},
				-- 	dependencies = wt.MergeTable(wt.Clone(t.dependencies), { { frame = panel.position.absolute, evaluate = function(value) return not value end }, }),
				-- 	optionsData = {
				-- 		optionsKey = t.optionsKey,
				-- 		workingTable = t.workingTable.position,
				-- 		storageKey = "relativeTo",
				-- 		convertSave = function(value)
				-- 			local text = wt.Clear(value)
				-- 			local frame = wt.ToFrame(text)
				-- 			print("CONVERT SAVE", frame, frame and text or nil) --REMOVE
				-- 			return frame and text or nil
				-- 		end,
				-- 		convertLoad = function(value)
				-- 			if type(value) == "table" then if value.GetName then print(value:GetName() .. ".") end end --REMOVE
				-- 			return wt.Clear(wt.ToString(value))
				-- 		end,
				-- 		onChange = { "CustomPositionChangeHandler", "UpdateFramePosition", }
				-- 	}
				-- 	-- disabled = not t.workingTable.position.relativeTo,
				-- 	-- dependencies = t.workingTable.position.relativeTo and t.dependencies or nil,
				-- 	-- optionsData = t.workingTable.position.relativeTo and {
				-- 	-- 	optionsKey = t.optionsKey,
				-- 	-- 	workingTable = t.workingTable.position,
				-- 	-- 	storageKey = "relativeTo",
				-- 	-- 	convertSave = function(value)
				-- 	-- 		local text = wt.Clear(value)
				-- 	-- 		local frame = wt.ToFrame(text)
				-- 	-- 		print("CONVERT SAVE", frame, frame and text or nil) --REMOVE
				-- 	-- 		return frame and text or nil
				-- 	-- 	end,
				-- 	-- 	convertLoad = function(value)
				-- 	-- 		if type(value) == "table" then if value.GetName then print(value:GetName() .. ".") end end --REMOVE
				-- 	-- 		return wt.Clear(wt.ToString(value))
				-- 	-- 	end,
				-- 	-- 	onChange = { "CustomPositionChangeHandler", "UpdateFramePosition", }
				-- 	-- } or nil
				-- })

				--[ Screen Layer ]

				if t.workingTable.layer and next(t.workingTable.layer) then
					panel.layer = {}

					if t.workingTable.layer.strata then panel.layer.strata = wt.CreateSpecialSelector("frameStrata", {
						parent = panelFrame,
						name = "FrameStrata",
						title = ns.toolboxStrings.layer.strata.label,
						tooltip = { lines = { { text = ns.toolboxStrings.layer.strata.tooltip:gsub("#FRAME", t.frameName), }, } },
						arrange = {},
						width = 140,
						onSelection = t.presets and function() panel.presets.apply.setSelected(nil, nil, ns.toolboxStrings.presets.apply.select) end or nil,
						dependencies = t.dependencies,
						optionsData = {
							optionsKey = t.optionsKey,
							workingTable = t.workingTable.layer,
							storageKey = "strata",
							onChange = {
								CustomStrataChangeHandler = function() if type(t.onChangeStrata) == "function" then t.onChangeStrata() end end,
								UpdateFrameStrata = function() t.frame:SetFrameStrata(t.workingTable.layer.strata) end,
							}
						}
					}) end

					if t.workingTable.layer.keepOnTop ~= nil then
						panel.layer.keepOnTop = wt.CreateCheckbox({
							parent = panelFrame,
							name = "KeepOnTop",
							title = ns.toolboxStrings.layer.keepOnTop.label,
							tooltip = { lines = { { text = ns.toolboxStrings.layer.keepOnTop.tooltip:gsub("#FRAME", t.frameName), }, } },
							arrange = { newRow = false, },
							dependencies = t.dependencies,
							optionsData = {
								optionsKey = t.optionsKey,
								workingTable = t.workingTable.layer,
								storageKey = "keepOnTop",
								onChange = {
									CustomKeepOnTopChangeHandler = function() if type(t.onChangeKeepOnTop) == "function" then t.onChangeKeepOnTop() end end,
									UpdateTopLevel = function() t.frame:SetToplevel(t.workingTable.layer.keepOnTop) end,
								}
							}
						})
					end

					if t.workingTable.layer.level then
						panel.layer.level = wt.CreateNumericSlider({
							parent = panelFrame,
							name = "FrameLevel",
							title = ns.toolboxStrings.layer.level.label,
							tooltip = { lines = { { text = ns.toolboxStrings.layer.level.tooltip:gsub("#FRAME", t.frameName), }, } },
							arrange = { newRow = false, },
							value = { min = 0, max = 10000, },
							step = 1,
							altStep = 100,
							events = t.presets and {
								OnValueChanged = function(_, _, user) if user then panel.presets.apply.setSelected(nil, nil, ns.toolboxStrings.presets.apply.select) end end,
							} or nil,
							dependencies = t.dependencies,
							optionsData = {
								optionsKey = t.optionsKey,
								workingTable = t.workingTable.layer,
								storageKey = "level",
								onChange = {
									CustomLevelChangeHandler = function() if type(t.onChangeLevel) == "function" then t.onChangeLevel() end end,
									UpdateFrameLevel = function() t.frame:SetFrameLevel(t.workingTable.layer.level) end,
								}
							}
						})
					end
				end
			end,
			arrangement = {}
		})

		--[ Movability ]

		if t.setMovable and type(t.setMovable) == "table" then
			t.setMovable.events = t.setMovable.events or {}

			wt.SetMovability(t.frame, true, {
				modifier = t.setMovable.modifier or "SHIFT",
				triggers = t.setMovable.triggers,
				events = {
					onStart = t.setMovable.events.onStart,
					onMove = t.setMovable.events.onMove,
					onStop = function()
						--Update the data tables
						wt.CopyValues(t.workingTable.position, wt.PackPosition(t.frame:GetPoint()))
						if t.storageTable then wt.CopyValues(t.storageTable.position, t.workingTable.position) end

						--Update the options widgets
						panel.position.anchor.loadData(false)
						panel.position.relativePoint.loadData(false)
						-- panel.position.relativeTo.loadData(false)
						panel.position.offset.x.loadData(false)
						panel.position.offset.y.loadData(false)

						--Call the specified handler
						if t.setMovable.events.onStop then t.setMovable.events.onStop() end
					end,
					onCancel = function()
						--Reset the position
						wt.SetPosition(t.frame, t.workingTable.position, true)

						--Call the specified handler
						if t.setMovable.events.onCancel then t.setMovable.events.onCancel() end
					end
				}
			})
		end

		return panel
	end


	--[[ REGISTER ]]

	ns.WidgetToolbox = WidgetTools.RegisterToolbox(ns.name, toolboxVersion, ns.WidgetToolbox)
end