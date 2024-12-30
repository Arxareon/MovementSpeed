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

	---@class wt
	local wt = ns.WidgetToolbox


	--[[ LOCALIZATIONS ]]

	--# flags will be replaced with code
	--\n represents the newline character

	local english = {
		chat = {
			welcome = {
				thanks = "Thank you for using #ADDON!",
				hint = "Type #KEYWORD to see the chat command list.",
				keywords = "#KEYWORD or #KEYWORD_ALTERNATE",
			},
			help = {
				list = "#ADDON chat command list:",
			},
		},
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
			open = "Click to view the list of options.",
			previous = {
				label = "Previous option",
				tooltip = "Select the previous option.",
			},
			next = {
				label = "Next option",
				tooltip = "Select the next option.",
			},
		},
		copyBox = "Copy the text by pressing:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
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
			warning = "Are you sure you want to reset the settings on page #PAGE or all settings in the whole #CATEGORY category to defaults?",
			warningSingle = "Are you sure you want to reset the settings on page #PAGE to defaults?",
		},
		value = {
			revert = "Revert Changes",
			restore = "Restore Default",
			note = "Right-click to reset or revert changes.",
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
				tooltip = "Notes of all the changes, updates & fixes introduced with the latest version release: #VERSION.",
			},
			fullChangelog = {
				label = "#ADDON Changelog",
				tooltip = "The complete list of update notes of all addon version releases.",
				open = {
					label = "Changelog",
					tooltip = "Read the full list of update notes of all addon version releases.",
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
				warning = "Are you sure you want to remove the currently active #PROFILE #ADDON settings profile and permanently delete all settings data stored in it?"
			},
			reset = {
				warning = "Are you sure you want to override the currently active #PROFILE #ADDON settings profile with default values?",
			},
		},
		backup = {
			title = "Backup",
			description = "Import or export data in the currently active profile to save, share or move settings, or edit specific values manually.",
			box = {
				label = "Import or Export Current Profile",
				tooltip = {
					"The backup string in this box contains the currently active addon profile data.",
					"Copy the text to save, share or load data for another account from it.",
					"To load data from a string you have, override the text inside this box, then press " .. KEY_ENTER .. " or click the #LOAD button.",
					"Note: If you're using custom font or texture files, those files cannot carry over with this string. They will need to be saved separately, and pasted into the addon folder to become usable.",
					"Only load strings you have verified yourself or trust the source of!",
				},
			},
			allProfiles = {
				label = "Import or Export All Profiles",
				tooltipLine = "The backup string in this box contains the list of all addon profiles and the data stored in each specific one as well as the name of currently active profile.",
				open = {
					label = "All Profiles",
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
			warning = "Are you sure you want to attempt to load the currently inserted string?\n\nAll unsaved changes will be dismissed.\n\nIf you've copied it from an online source or someone else has sent it to you, only load it after you've checked the code inside and you know what you are doing.\n\nIf don't trust the source, you may want to cancel to prevent any unwanted actions.",
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
				warning = "Are you sure you want to override the #CUSTOM preset with the current values?",
			},
			reset = {
				label = "Reset #CUSTOM Preset",
				tooltip = "Override currently saved #CUSTOM preset data with the default values, then apply it.",
				warning = "Are you sure you want to override the #CUSTOM preset with the default values?",
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
		date = "#MONTH/#DAY/#YEAR",
		override = "Override",
		example = "Example",
		separator = ",", --Thousand separator character
		decimal = ".", --Decimal character
	}

	--Load the current localization
	local function loadLocale()

		--| Load localized strings

		local locale = GetLocale()

		if (locale == "") then
			--ADD localization for other languages (locales: https://warcraft.wiki.gg/wiki/API_GetLocale#Values)
			--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml#L8
		else --Default: English (UK & US)
			ns.toolboxStrings = english
		end

		--| Fill static & internal references

		ns.toolboxStrings.backup.box.tooltip[3] = ns.toolboxStrings.backup.box.tooltip[3]:gsub("#LOAD", ns.toolboxStrings.backup.load.label)
		ns.toolboxStrings.position.keepInPlace.tooltip = ns.toolboxStrings.position.keepInPlace.tooltip:gsub("#ANCHOR", ns.toolboxStrings.position.anchor.label)
		ns.toolboxStrings.position.offsetX.tooltip = ns.toolboxStrings.position.offsetX.tooltip:gsub("#ANCHOR", ns.toolboxStrings.position.anchor.label)
		ns.toolboxStrings.position.offsetY.tooltip = ns.toolboxStrings.position.offsetY.tooltip:gsub("#ANCHOR", ns.toolboxStrings.position.anchor.label)
		ns.toolboxStrings.position.relativePoint.tooltip = ns.toolboxStrings.position.relativePoint.tooltip:gsub("#ANCHOR", ns.toolboxStrings.position.anchor.label)
		ns.toolboxStrings.layer.keepOnTop.tooltip = ns.toolboxStrings.layer.keepOnTop.tooltip:gsub("#STRATA", ns.toolboxStrings.layer.strata.label)
		ns.toolboxStrings.layer.level.tooltip = ns.toolboxStrings.layer.level.tooltip:gsub("#STRATA", ns.toolboxStrings.layer.strata.label)
		-- ns.toolboxStrings.about.changelog.tooltip = ns.toolboxStrings.about.changelog.tooltip .. "\n\nThe changelog is only available in English for now." --TODO reinstate when more languages are added
		-- ns.toolboxStrings.about.fullChangelog.tooltip = ns.toolboxStrings.about.fullChangelog.tooltip .. "\n\nThe changelog is only available in English for now."
	end

	loadLocale()


	--[[ UTILITIES ]]

	--Classic vs Retail code separation
	wt.classic = select(4, GetBuildInfo()) < 100000

	---Check if a table is a frame (or a backdrop object)
	---@param t table
	---***
	---@return boolean|string # If **t** is recognized as a [FrameScriptObject](https://warcraft.wiki.gg/wiki/UIOBJECT_FrameScriptObject), return true, or, return the frame name if named or the debug name if unnamed but recognized as a UI [Object](https://warcraft.wiki.gg/wiki/UIOBJECT_Object) with a parent, otherwise, return false
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

	--[ String Formatting ]

	---Format a number string with thousands separation and optional value rounding
	---***
	---@param value number Number value to turn into a string with thousand separation
	---@param decimals? number Specify the number of decimal places to display if the number is a fractional value | ***Default:*** 0
	---@param round? boolean Round the number value to the specified number of decimal places | ***Default:*** true
	---@param trim? boolean Trim trailing zeros in decimal places | ***Default:*** true
	---@return string
	function wt.Thousands(value, decimals, round, trim)
		value = round == false and value or wt.Round(value, decimals)
		local fraction = math.fmod(value, 1)
		local integer = value - fraction
		local decimalText = tostring(fraction):sub(3, (decimals or 0) + 2)
		local leftover

		while true do
			integer, leftover = string.gsub(integer, "^(-?%d+)(%d%d%d)", '%1' .. ns.toolboxStrings.separator .. '%2')
			if leftover == 0 then break end
		end
		if trim == false then for i = 1, (decimals or 0) - #decimalText do decimalText = decimalText .. "0" end end

		return integer .. (((decimals or 0) > 0 and (fraction ~= 0 or trim == false)) and ns.toolboxStrings.decimal .. decimalText or "")
	end

	--| Escape sequences

	---Add coloring to a string via escape sequences
	---***
	---@param text string Text to add coloring to
	---@param color colorData Table containing the color values
	---@return string
	function wt.Color(text, color)
		local r, g, b, a = wt.UnpackColor(color)

		return WrapTextInColorCode(text, wt.ColorToHex(r, g, b, a, true, false))
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

	--| Hyperlinks

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
	---@param type? string Unique custom hyperlink type key used to identify the specific handler function | ***Default:*** "-"
	---@param handler fun(...) Function to be called with the list of content data strings carried by the hyperlink returned one by one when clicking on a hyperlink text created via ***WidgetToolbox*.CustomHyperlink(...)**
	function wt.SetHyperlinkHandler(addon, type, handler)
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
				local linkType, addonID, handlerID, payload = strsplit(":", ..., 4)

				if linkType == "addon" then callHandler(addonID, handlerID, payload) end
			end) end
		end

		--Add the hyperlink handler function to the registry
		if not hyperlinkHandlers[addon] then hyperlinkHandlers[addon] = {} end
		hyperlinkHandlers[addon][type or "-"] = handler
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
		return wt.Clone(wt.FindValueByKey(ns.toolboxStrings, key))
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
	---@param recoveryMap? table<string, recoveryData> Save removed data from matching key chains to the specified table under the specified key
	--- - ***Example:*** String chain of keys pointing to the removed old data to be recovered from **tableToCheck**: `"keyOne[2].keyThree.keyFour[1]"`.
	---@param onRecovery? fun(recoveredData: table): recoveryMap: table<string, recoveryData>|nil Function to call when removed data is to be recovered, providing a way to dynamically create a recovery map based on the recovered data, replacing **recoveryMap** if it was specified
	---***
	---@return table tableToCheck Reference to **tableToCheck** (it was already overwritten during the operation, no need for setting it again)
	function wt.RemoveMismatch(tableToCheck, tableToSample, recoveryMap, onRecovery)
		local recoveredData = cleanTable(tableToCheck, tableToSample)

		if next(recoveredData) then
			if onRecovery then recoveryMap = onRecovery(tableToCheck, recoveredData) end

			if recoveryMap then for key, value in pairs(recoveredData) do if recoveryMap[key] then for i = 1, #recoveryMap[key].saveTo do
				recoveryMap[key].saveTo[i][recoveryMap[key].saveKey] = recoveryMap[key].convertSave and recoveryMap[key].convertSave(value) or value
			end end end end
		end

		return tableToCheck
	end

	--[ Frame Setup ]

	--Used for a transitional step to avoid anchor family connections during safe frame positioning
	local positioningAid

	---Set the position and anchoring of a frame when it is unknown which parameters will be nil
	---***
	---@param frame AnyFrameObject Reference to the frame to be moved
	---@param position? positionData Table of parameters to call **frame**:[SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
	---@param safeMode? boolean If true, to prevent anchor family connections, move a positioning aid frame to the target position first, convert it to absolute position by breaking relative links, then move **frame** relative to the positioning aid | ***Default:*** false
	--- ***Note:*** The position of **frame** will be converted to absolute position once the positioning is done, breaking the relative link to **position.relativeTo**.
	---@param userPlaced? boolean Remember the position if **frame**:[IsMovable()](https://warcraft.wiki.gg/wiki/API_Frame_IsMovable) | ***Default:*** true
	function wt.SetPosition(frame, position, safeMode, userPlaced)
		if not frame.SetPoint then return end

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
			elseif not offsetX and not offsetY then positioningAid:SetPoint(anchor, relativeTo, relativePoint or anchor)
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
	---@param frame AnyFrameObject Reference to the frame the position of which to be converted to absolute position
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
	---@param frame AnyFrameObject Reference to the frame to make movable/unmovable
	---@param movable? boolean Whether to make the frame movable or unmovable | ***Default:*** false
	---@param t? movabilityData When specified, set **frame** as movable, dynamically updating the position options widgets when it's moved by the user
	---<hr><p></p>
	function wt.SetMovability(frame, movable, t)
		if not frame.SetMovable then return end

		movable = movable == true
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

			for i = 1, #t.triggers do
				t.triggers[i]:EnableMouse(true)

				t.triggers[i]:HookScript("OnEnter", function()
					if not t.cursor or not frame:IsMovable() then return end

					if not modifier then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") else
						if modifier() then SetCursor("Interface/Cursor/ui-cursor-move.crosshair") end

						frame:RegisterEvent("MODIFIER_STATE_CHANGED")
					end
				end)

				t.triggers[i]:HookScript("OnLeave", function()
					if not t.cursor or not frame:IsMovable() then return end

					SetCursor(nil)

					if modifier and not hadEvent then frame:UnregisterEvent("MODIFIER_STATE_CHANGED") end
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
	---@param frame AnyFrameObject Reference to the frame to set the backdrop of
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

	--[ Options Data Management ]

	--Options data management rule registry
	---@class optionsRegistry
	---@field rules table<string, optionsRule[]> Collection of rules describing where to save/load options data to/from, and what change handlers to call in the process linked to each specific options key under an addon
	---@field changeHandlers table<string, function> List of pairs of addon-specific unique keys and change handler scripts
	local optionsTable = { rules = {}, changeHandlers = {} }

	---Add a connection between an options widget and a DB entry to the options data table linked to the specified options key under the specified addon for batched data handling
	---***
	---@param widget checkbox|radioButton|radioSelector|checkboxSelector|specialSelector|dropdownSelector|textbox|multilineEditbox|numericSlider|colorPicker Reference to the widget to be saved & loaded data to/from with defined **widget.loadData()** & **widget.saveData()** functions
	---@param t optionsData Parameters are to be provided in this table
	function wt.AddOptionsRule(widget, t)
		if not widget or not type(t) == "table" then return end

		t.category = t.category or "WidgetTools"
		t.key = t.key or ""
		local key = t.category .. t.key

		optionsTable.rules[key] = optionsTable.rules[key] or {}

		--Add the onChange handlers to options data management
		if t.onChange then
			local newKeys = {}

			for k, v in pairs(t.onChange) do if type(k) == "string" and type(v) == "function" then
				--Store the function
				optionsTable.changeHandlers[t.category .. k] = v

				--Remove the function definitions, save their keys
				t.onChange[k] = nil
				table.insert(newKeys, k)
			end end

			--Add saved new keys
			for i = 1, #newKeys do table.insert(t.onChange, newKeys[i]) end
		end

		--Add the options data rules to the collection
		if type(t.index) ~= "number" then table.insert(optionsTable.rules[key], { widget = widget, onChange = t.onChange })
		else table.insert(optionsTable.rules[key], Clamp(wt.Round(t.index), 1, #optionsTable.rules[key] + 1), { widget = widget, onChange = t.onChange }) end
	end

	---Load all data from storage to the widgets specified in the options data list referenced by the specified options key under the specified addon by calling **[*widget*].loadData(...)** for each
	---***
	---@param category? string A unique string used for categorizing options data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
	---@param key? string A unique string appended to **category** linking a subset of options data rules to be handled together | ***Default:*** "" *(category-wide rule)*
	---@param handleChanges? boolean Whether to call **onChange** handlers or not | ***Default:*** false
	function wt.LoadOptionsData(category, key, handleChanges)
		category = category or "WidgetTools"
		key = category .. (key or "")

		if not optionsTable.rules[key] then return end

		if handleChanges then handleChanges = {} end

		for i = 1, #optionsTable.rules[key] do
			optionsTable.rules[key][i].widget.loadData(false)

			--Register onChange handlers for call
			if handleChanges and optionsTable.rules[key][i].onChange then
				for j = 1, #optionsTable.rules[key][i].onChange do handleChanges[category .. optionsTable.rules[key][i].onChange[j]] = true end
			end
		end

		--Call registered onChange handlers
		if handleChanges then for k in pairs(handleChanges) do optionsTable.changeHandlers[k]() end end
	end

	---Save all data from the widgets to storage specified in the options data list referenced by the specified options key under the specified addon by calling **[*widget*].saveData(...)** for each
	---***
	---@param category? string A unique string used for categorizing options data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
	---@param key? string A unique string appended to **category** linking a subset of options data rules to be handled together | ***Default:*** "" *(category-wide rule)*
	function wt.SaveOptionsData(category, key)
		key = (category or "WidgetTools") .. (key or "")

		if not optionsTable.rules[key] then return end

		for i = 1, #optionsTable.rules[key] do optionsTable.rules[key][i].widget.saveData() end
	end

	---Set a data snapshot for each widget specified in the options data list referenced by the specified options key by under the specified addon calling **[*widget*].revertData()** for each
	---***
	---@param category? string A unique string used for categorizing options data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
	---@param key? string A unique string appended to **category** linking a subset of options data rules to be handled together | ***Default:*** "" *(category-wide rule)*
	function wt.SnapshotOptionsData(category, key)
		key = (category or "WidgetTools") .. (key or "")

		if not optionsTable.rules[key] then return end

		for i = 1, #optionsTable.rules[key] do optionsTable.rules[key][i].widget.snapshotData() end
	end

	---Set & load the stored data managed by each widget specified in the options data list referenced by the specified options key under the specified addon by calling **[*widget*].revertData()** for each
	---***
	---@param category? string A unique string used for categorizing options data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
	---@param key? string A unique string appended to **category** linking a subset of options data rules to be handled together | ***Default:*** "" *(category-wide rule)*
	function wt.RevertOptionsData(category, key)
		category = category or "WidgetTools"
		key = category .. (key or "")

		if not optionsTable.rules[key] then return end

		local handleChanges = {}

		for i = 1, #optionsTable.rules[key] do
			optionsTable.rules[key][i].widget.revertData(false)

			--Register onChange handlers for call
			for i = 1, #optionsTable.rules[key] do if handleChanges and optionsTable.rules[key][i].onChange then
				for j = 1, #optionsTable.rules[key][i].onChange do handleChanges[category .. optionsTable.rules[key][i].onChange[j]] = true end
			end end
		end

		--Call registered onChange handlers
		if handleChanges then for k in pairs(handleChanges) do optionsTable.changeHandlers[k]() end end
	end

	---Set & load the default data managed by each widget specified in the options data list referenced by the specified options key under the specified addon by calling **[*widget*].resetData()** for each
	---***
	---@param category? string A unique string used for categorizing options data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
	---@param key? string A unique string appended to **category** linking a subset of options data rules to be handled together | ***Default:*** "" *(category-wide rule)*
	function wt.ResetOptionsData(category, key)
		category = category or "WidgetTools"
		key = category .. (key or "")

		if not optionsTable.rules[key] then return end

		local handleChanges = {}

		for i = 1, #optionsTable.rules[key] do
			optionsTable.rules[key][i].widget.resetData(false)

			--Register onChange handlers for call
			for i = 1, #optionsTable.rules[key] do if handleChanges and optionsTable.rules[key][i].onChange then
				for j = 1, #optionsTable.rules[key][i].onChange do handleChanges[category .. optionsTable.rules[key][i].onChange[j]] = true end
			end end
		end

		--Call registered onChange handlers
		if handleChanges then for k in pairs(handleChanges) do optionsTable.changeHandlers[k]() end end
	end

	--[ Settings Page Management ]

	---Register the settings page to the Settings window if it wasn't already
	--- - ***Note:*** No settings page will be registered if **WidgetToolsDB.lite** is true.
	---@param page settingsPage Reference to the settings page to register to Settings
	---@param parent? settingsPage Reference to the parent settings page to set **page** as a child category page of | ***Default:*** *set as a parent category page*
	---@param icon? boolean If true, append the icon set for the settings page to its button title in the AddOns list of the Settings window as well | ***Default:*** true if **parent** == nil
	function wt.RegisterSettingsPage(page, parent, icon)
		if WidgetToolsDB.lite or type(page) ~= "table" or type(page.isType) ~= "function" or not page.isType("SettingsPage") or page.category then return end

		local title = (page.title and page.title:GetText() or "") .. (icon or not parent and page.icon and (" " .. wt.Texture(page.icon:GetTextureFileID())) or "")

		page.canvas.OnCommit = function() page.save(true) end
		page.canvas.OnRefresh = function() page.load(nil, true) end
		page.canvas.OnDefault = function() page.default(true) end

		if parent then page.category = Settings.RegisterCanvasLayoutSubcategory(parent.category, page.canvas, title)
		else page.category = Settings.RegisterCanvasLayoutCategory(page.canvas, title) end

		Settings.RegisterAddOnCategory(page.category)
	end

	--[ Chat Control ]

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
		local addonTitle = wt.Clear(select(2, C_AddOns.GetAddOnInfo(addon))):gsub("^%s*(.-)%s*$", "%1")
		local branding = (logo and (wt.Texture(logo, 9) .. " ") or "") .. addonTitle .. ": "

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
				keyword = ns.toolboxStrings.chat.welcome.keywords:gsub("#KEYWORD_ALTERNATE", wt.Color(keywords[#keywords], t.colors.command)):gsub("#KEYWORD", keyword)
			end

			print(wt.Color(ns.toolboxStrings.chat.welcome.thanks:gsub(
				"#ADDON", wt.Color(addonTitle, t.colors.title) .. (logo and " " .. wt.Texture(logo) or "")
			), t.colors.content))
			print(wt.Color(ns.toolboxStrings.chat.welcome.hint:gsub("#KEYWORD", keyword), t.colors.description))

			if type(t.onWelcome) == "function" then t.onWelcome() end
		end

		--Trigger a help command, listing all registered chat commands with their specified descriptions, calling their onHelp handlers
		function manager.help()
			print(wt.Color(ns.toolboxStrings.chat.help.list:gsub("#ADDON", wt.Color(logo  .. addonTitle, t.colors.title)), t.colors.content))

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

				if t.commands[i].help then manager.help(t.listHelpCommands) end

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


	--[[ RESOURCES ]]

	--Addon title
	ns.title = wt.Clear(select(2, C_AddOns.GetAddOnInfo(ns.name))):gsub("^%s*(.-)%s*$", "%1")

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
	}

	--Textures
	local textures = {
		alphaBG = "Interface/AddOns/" .. ns.name .. "/Textures/AlphaBG.tga",
		gradientBG = "Interface/AddOns/" .. ns.name .. "/Textures/GradientBG.tga",
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
	---@param owner AnyFrameObject Owner frame the tooltip to be shown for
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

	---Add default value and utility menu hint tooltip lines to widget tooltip tables
	---@param t optionsFrame|tooltipDescribableObject Parameters are to be provided in this table
	---@param default? string Default value, formatted | ***Default:*** ""
	function wt.AddWidgetTooltipLines(t, default)
		if type(t) ~= "table" or (t.showDefault == false and t.utilityMenu == false) or type(t.tooltip) ~= "table" then return end

		local hadLines = type(t.tooltip.lines) == "table" and next(t.tooltip.lines) or false

		if not hadLines then t.tooltip.lines = { { text = " " } } end

		if t.showDefault ~= false then table.insert(t.tooltip.lines, {
			text = (hadLines and "\n" or "") .. WrapTextInColorCode(DEFAULT .. ": ", "FF66FF66") .. (type(default) == "string" and default or "")
		}) end
		if t.utilityMenu ~= false then table.insert(t.tooltip.lines, {
			text = (t.showDefault == false and "\n" or "") .. ns.toolboxStrings.value.note, font = GameFontNormalTiny, color = ns.colors.grey[1],
		})
		end
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
		if not addon or not C_AddOns.IsAddOnLoaded(addon) then return end

		calls = calls or {}

		local onClickName = C_AddOns.GetAddOnMetadata(addon, "AddonCompartmentFunc")
		local onEnterName = C_AddOns.GetAddOnMetadata(addon, "AddonCompartmentFuncOnEnter")
		local onLeaveName = C_AddOns.GetAddOnMetadata(addon, "AddonCompartmentFuncOnLeave")

		if onClickName and calls.onClick then _G[onClickName] = calls.onClick end

		if tooltip and onEnterName and onLeaveName then
			if not tooltip.tooltip then
				customTooltip = customTooltip or wt.CreateGameTooltip(ns.name .. toolboxVersion)
				tooltip.tooltip = customTooltip
			end
			tooltip.title = tooltip.title or C_AddOns.GetAddOnMetadata(addon, "Title")

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

	--| Dialog

	---Create a popup dialog with an accept function and cancel button
	---***
	---@param addon? string The name of the addon's folder (the addon namespace, not its displayed title) | ***Default:*** "WidgetTools" *(register as global)*
	---@param key? string Unique string appended to **addon** to be used as the identifier key in the global **StaticPopupDialogs** table | ***Default:*** "DIALOG"<ul><li>***Note:*** Dialog data registered under existing keys will be overwritten.</li><li>***Note:*** Space characters will be replaced with "_".</li></ul>
	---@param t? popupDialogData Parameters are to be provided in this table
	---***
	---@return string key The unique identifier key created for this popup in the global **StaticPopupDialogs** table used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
	function wt.RegisterPopupDialog(addon, key, t)
		t = t or {}
		key = addon:upper() .. "_" .. (type(key) == "string" and key:gsub("%s+", "_"):upper() or "DIALOG")

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
	---@return string|nil key The unique identifier key created for this popup in the global **StaticPopupDialogs** table used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide), or nil if no popup has been registered with the provided **key**
	function wt.UpdatePopupDialog(key, t)
		if not StaticPopupDialogs[key] then return end

		t = t or {}

		if t.text then StaticPopupDialogs[key].text = t.text end
		if t.accept then StaticPopupDialogs[key].button1 = t.accept end
		if t.cancel then StaticPopupDialogs[key].button2 = t.cancel end
		if t.alt then StaticPopupDialogs[key].button3 = t.alt end
		if t.onAccept then StaticPopupDialogs[key].OnAccept = t.onAccept end
		if t.onCancel then StaticPopupDialogs[key].OnCancel = t.onCancel end
		if t.onAlt then StaticPopupDialogs[key].OnAlt = t.onAlt end

		return key
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

				customPopupInputBoxFrame.textbox = wt.CreateEditbox({
					parent = panel,
					name = "TextInputBox",
					title = t.title,
					label = t.title ~= nil,
					tooltip = { title = ns.toolboxStrings.popupInput.title, lines = { { text = ns.toolboxStrings.popupInput.tooltip }, } },
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

				wt.CreateSimpleButton({
					parent = panel,
					name = "AcceptButton",
					title = ACCEPT ,
					arrange = {},
					size = { w = 110, },
					action = accept,
				})

				wt.CreateSimpleButton({
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

		wt.CreateSimpleButton({
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

		wt.CreateSimpleButton({
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

	---Create a new [Font](https://warcraft.wiki.gg/wiki/UIOBJECT_Font) object to be used when setting the look of a [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) using a [FontInstance](https://warcraft.wiki.gg/wiki/UIOBJECT_FontInstance)
	---***
	---@param t fontCreationData Parameters are to be provided in this table
	---@return string name, Font font
	---<hr><p></p>
	function wt.CreateFont(t)
		t = t or {}

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

	--| Create custom fonts for Classic

	if wt.classic then
		wt.CreateFont({
			name = "GameFontDisableMed2",
			template = "GameFontHighlightMedium",
			color = wt.PackColor(GameFontDisable:GetTextColor()),
		})

		wt.CreateFont({
			name = "NumberFont_Shadow_Large",
			font = { path = "Fonts/ARIALN.TTF", size = 20, style = "OUTLINE" },
		})
	end

	--[ Text ]

	---Create a [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) with the specified parameters
	---***
	---@param t textCreationData Parameters are to be provided in this table
	---@return FontString|nil text
	function wt.CreateText(t)
		t = t or {}

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
		t = t or {}

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

	--[ Texture ]

	---Create a [Texture](https://warcraft.wiki.gg/wiki/UIOBJECT_Texture) image [TextureBase](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) object
	---***
	---@param t textureCreationData Parameters are to be provided in this table
	---@param updates? table<AnyScriptType, textureUpdateRule> Table of key, value pairs containing the list of events to link texture changes to, and what parameters to change
	---@return Texture|nil texture
	function wt.CreateTexture(t, updates)
		t = t or {}

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
		if t.events then for key, value in pairs(t.events) do
			if key == "attribute" then texture:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
			else texture:HookScript(key, value) end
		end end

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
		t = t or {}

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

	--[ Base Frame ]

	---Create & set up a new base frame
	---***
	---@param t? frameCreationData Parameters are to be provided in this table
	---@return Frame frame
	function wt.CreateFrame(t)
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
		if t.arrange then frame.arrangementInfo = t.arrange elseif t.position then wt.SetPosition(frame, t.position) end

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
			t.initialize(frame, t.size.w, t.size.h, t.name)

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
		local scrollChild = wt.CreateFrame({
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
		t.scrollSpeed = (t.scrollSpeed or 0.25)

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
	---@return panel|Frame panel Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame) overloaded with custom fields or none if **WidgetToolsDB.lite** is true**
	function wt.CreatePanel(t)
		t = t or {}

		if WidgetToolsDB.lite and t.lite ~= false then return wt.CreateFrame(t) end

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
		if t.events then for key, value in pairs(t.events) do
			if key == "attribute" then panel:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
			else panel:HookScript(key, value) end
		end end

		--[ Initialization ]

		--Add content, performs tasks
		if t.initialize then
			t.initialize(panel, t.size.w, t.size.h, t.name or "Panel")

			--Arrange content
			if t.arrangement then wt.ArrangeContent(panel, wt.AddMissing(t.arrangement, { parameters = { margins = { t = t.description and 30 or nil, }, }, })) end
		end

		return panel
	end

	--[ Context Menu ]

	---Create a Blizzard context menu
	---***
	---@param t contextMenuCreationData Parameters are to be provided in this table
	---***
	---@return contextMenu|nil menu Table containing a reference to the root description of the context menu
	function wt.CreateContextMenu(t)
		t = t or {}

		if not wt.IsFrame(t.parent) then t.parent = UIParent end

		--[ Menu Setup ]

		---@class contextMenu
		---@field open function Call to open the context menu at will
		---@field rootDescription rootDescription Container of menu elements (such as titles, widgets, dividers or other frames)
		local menu = {}

		--| Utilities

		menu.open = function()
			if type(t.condition) == "function" and not t.condition() then return end

			MenuUtil.CreateContextMenu(t.parent, function(_, rootDescription)
				menu.rootDescription = rootDescription

				--Adding items
				if type(t.initialize) == "function" then t.initialize(rootDescription) end
			end
		) end

		--| Trigger events

		if t.rightClickMenu ~= false or t.leftClickMenu then t.parent:HookScript("OnMouseUp", function(_, button, isInside)
			if not isInside or (button == "RightButton" and t.rightClickMenu == false) or (button == "LeftButton" and not t.leftClickMenu) then return end

			menu.open()
		end) end

		if t.hoverMenu then t.parent:HookScript("OnEnter", menu.open) end

		return menu
	end

	---Create a Blizzard context menu attached to a custom button frame to open it
	---***
	---@param t popupMenuCreationData Parameters are to be provided in this table
	---***
	---@return Frame menu Table containing a reference to the root description of the context menu
	---@return contextMenu|nil menu Table containing a reference to the root description of the context menu
	function wt.CreatePopupMenu(t)
		t = t or {}
		t.size = t.size or {}
		t.size.w = t.size.w or 180
		t.size.h = t.size.h or 26

		local buttonFrame = wt.CreateFrame({
			parent = t.parent,
			name = t.name or "PopupMenu",
			customizable = true,
			position = t.position,
			arrange = t.arrange,
			size = t.size,
			events = t.events,
			onEvent = t.onEvent,
			initialize = function(frame)
				wt.CreateText({
					parent = frame,
					name = "Label",
					text = t.title,
					position = { anchor = "LEFT", offset = { x = 12, }, },
					justify = { h = "LEFT", },
					width = t.size.w - 48,
					font = "GameFontHighlight",
				})

				wt.CreateText({
					parent = frame,
					name = "Arrow",
					text = "►",
					position = { anchor = "RIGHT", offset = { x = -12, }, },
					justify = { h = "RIGHT", },
					width = 16,
					font = "ChatFontNormal",
					color = colors.highlight,
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
				{
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
					OnMouseDown = { rule = function() return {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} end },
				})
			end
		})

		local menu = wt.CreateContextMenu({
			parent = buttonFrame,
			leftClickMenu = true,
			rightClickMenu = false,
			initialize = t.initialize,
		})

		return buttonFrame, menu
	end

	---Create a submenu item for an already existing Blizzard context menu
	---***
	---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new submenu to
	---@param t contextSubmenuCreationData Parameters are to be provided in this table
	---***
	---@return contextSubmenu|nil menu Table containing a reference to the root description of the context menu
	function wt.CreateSubmenu(menu, t)
		if not menu then return end

		t = t or {}

		--[ Menu Setup ]

		---@class contextSubmenu
		---@field rootDescription rootDescription Container of menu elements (such as titles, widgets, dividers or other frames)
		local submenu = { rootDescription = menu:CreateButton(t.title or "Submenu") }

		--Adding items
		if type(t.initialize) == "function" then t.initialize(submenu.rootDescription) end

		return submenu
	end

	---Create a textline item for an already existing Blizzard context menu
	---***
	---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
	---@param t? menuTextlineCreationData Parameters are to be provided in this table
	---***
	---@return menuDivider|nil textline Reference to the context textline UI object
	function wt.CreateMenuTextline(menu, t)
		if not menu then return end

		t = t or {}

		--[ Item Setup ]

		---@class menuDivider
		local textline = t.queue ~= true and menu:CreateTitle(t.text or "Title") or menu:QueueTitle(t.text or "Title")

		return textline
	end

	---Create a divider item for an already existing Blizzard context menu
	---***
	---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
	---@param t? queuedMenuItem Parameters are to be provided in this table
	---***
	---@return menuDivider|nil divider Reference to the context divider UI object
	function wt.CreateMenuDivider(menu, t)
		if not menu then return end

		t = t or {}

		--[ Item Setup ]

		---@class menuDivider
		local divider = t.queue ~= true and menu:CreateDivider() or menu:QueueDivider()

		return divider
	end

	---Create a spacer item for an already existing Blizzard context menu
	---***
	---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
	---@param t? queuedMenuItem Parameters are to be provided in this table
	---***
	---@return menuSpacer|nil spacer Reference to the context spacer UI object
	function wt.CreateMenuSpacer(menu, t)
		if not menu then return end

		t = t or {}

		--[ Item Setup ]

		---@class menuSpacer
		local spacer = t.queue ~= true and menu:CreateSpacer() or menu:QueueSpacer()

		return spacer
	end

	---Create a button item for an already existing Blizzard context menu
	---***
	---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
	---@param t? menuButtonCreationData Parameters are to be provided in this table
	---***
	---@return menuButton|nil button Reference to the context button UI object
	function wt.CreateMenuButton(menu, t)
		if not menu then return end

		t = t or {}

		--[ Frame Setup ]

		---@class menuButton
		local button = menu:CreateButton(t.title or "Button", t.action)

		return button
	end

	--[ Settings Pages ]

	---Create an new Settings Panel frame and add it to the Options
	---***
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param t? settingsPageCreationData Parameters are to be provided in this table
	---***
	---@return settingsPage|nil page Table containing references to the settings canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions
	function wt.CreateSettingsPage(addon, t)
		if not addon or not C_AddOns.IsAddOnLoaded(addon) then return end

		t = t or {}
		t.name = t.name and t.name:gsub("%s+", "")
		if type(t.dataManagement) == "table" then
			t.dataManagement.category = t.dataManagement.category or addon
			t.dataManagement.keys = type((t.dataManagement.keys or {})[1]) == "string" and t.dataManagement.keys or { t.name or "" }
		end
		local width, height = 0, 0
		local defaultsWarning

		---@class settingsPage
		---@field canvas? Frame The settings page canvas frame to house the options widgets
		---@field category? table The registered settings category page
		---@field scroller? Frame Scrollable child frame of the [ScrollFrame](https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame) created as a child of **canvas** if **t.scroll** was set
		local page = {}

		--[ Getters & Setters ]

		---Returns the type of this object
		---***
		---@return "SettingsPage" string
		---<hr><p></p>
		function page.getType() return "SettingsPage" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|WidgetTypeName
		---@return boolean
		function page.isType(type) return type == "SettingsPage" end

		---Return a value at the specified key from the table used for creating the settings page
		---@param key string
		---@return any
		function page.getProperty(key) return wt.FindValueByKey(t, key) end

		---Returns the unique identifier key representing the defaults warning popup dialog in the global **StaticPopupDialogs** table, and used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
		---@return string
		function page.getDefaultsPopupKey() return defaultsWarning end

		--| Utilities

		---Open the Settings window to this category page
		--- - ***Note:*** No category page will be opened if **WidgetToolsDB.lite** is true.
		function page.open()
			if WidgetToolsDB.lite or not page.category then
				print(wt.Color(wt.Texture(ns.textures.logo, 9) .. " " .. ns.title, ns.colors.gold[1]) .. " " .. wt.Color(ns.strings.chat.lite.reminder:gsub(
					"#HINT", wt.Color(ns.strings.chat.lite.hint:gsub(
						"#COMMAND", wt.Color("/" .. ns.chat.keyword .. " " .. ns.chat.commands.lite, { r = 1, g = 1, b = 1, })
					), ns.colors.grey[1])
				), ns.colors.gold[2]))

				return
			end

			Settings.OpenToCategory(page.category:GetID())
		end

		--| Batched options data management

		---Call to force save the options in this category page
		---***
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		function page.save(user)
			--Retrieve data from settings widgets and commit to storage
			if t.autoSave ~= false and type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do
				wt.SaveOptionsData(t.dataManagement.category, t.dataManagement.keys[i])
			end end

			--Call listener
			if t.onSave then t.onSave(user == true) end
		end

		---Call to force update the options widgets in this category page
		---***
		---@param changes? boolean Whether to call **onChange** handlers or not | ***Default:*** false
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		function page.load(changes, user)
			--Update settings widgets
			if t.autoLoad ~= false and type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do
				wt.LoadOptionsData(t.dataManagement.category, t.dataManagement.keys[i], changes)
				wt.SnapshotOptionsData(t.dataManagement.category, t.dataManagement.keys[i])
			end end

			--Call listener
			if t.onLoad then t.onLoad(user == true) end
		end

		---Call to cancel any changes made in this category page and reload all linked widget data
		---***
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		function page.cancel(user)
			--Update settings widgets
			if type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do wt.RevertOptionsData(t.dataManagement.category, t.dataManagement.keys[i]) end end

			--Call listener
			if t.onCancel then t.onCancel(user == true) end
		end

		---Call to reset all options in this category page to their default values
		---***
		---@param user? boolean Whether to mark the call as being the result of a user interaction | ***Default:*** false
		function page.default(user)
			--Update with default values
			if type(t.dataManagement) == "table" then for i = 1, #t.dataManagement.keys do wt.ResetOptionsData(t.dataManagement.category, t.dataManagement.keys[i]) end end

			--Call listener
			if t.onDefault then t.onDefault(user == true, false) end
		end

		--[ Settings Page ]

		if not WidgetToolsDB.lite or t.lite == false then

			--[ Canvas Frame ]

			width, height = SettingsPanel.Container.SettingsCanvas:GetSize()

			page.canvas = wt.CreateFrame({
				name = (t.append ~= false and t.name and addon or "") .. (t.name or addon) .. (t.appendOptions ~= false and "Options" or ""),
				size = { w = width, h = height },
				visible = false,
			})

			--| Title & description

			local title = t.title or wt.Clear(C_AddOns.GetAddOnMetadata(addon, "title")):gsub("^%s*(.-)%s*$", "%1")

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

			local icon = t.icon or C_AddOns.GetAddOnMetadata(addon, "IconTexture")

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

			wt.CreateSimpleButton({
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

			defaultsWarning = wt.RegisterPopupDialog(addon, (t.name or "") .. "DEFAULT", {
				text = ns.toolboxStrings.settings.warningSingle:gsub("#PAGE", wt.Color(title, colors.highlight)),
				accept = ACCEPT,
				onAccept = function() page.default(true) end,
			})

			wt.CreateSimpleButton({
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
			t.initialize(page.scroller or page.canvas, width, height, (t.dataManagement or {}).category, (t.dataManagement or {}).keys, t.name or addon)

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
	---@return settingsCategory|nil category Table containing references to settings pages and utility functions or nil if the specified **parent** was invalid
	function wt.CreateSettingsCategory(addon, parent, pages, t)
		if not addon or not C_AddOns.IsAddOnLoaded(addon) or type(parent) ~= "table" and not parent.category then return end

		t = t or {}

		---@class settingsCategory
		---@field pages settingsPage[]
		local category = { pages = {} }

		--[ Utilities ]

		--| Batched options data management

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
		---@param callListeners? boolean If true, call the **onDefault** listeners (if set) of each individual category page separately | ***Default:*** true
		function category.defaults(user, callListeners)
			for i = 1, #category.pages do
				local dataManagement = category.pages[i].getProperty("dataManagement")
				local onDefault = callListeners ~= false and category.pages[i].getProperty("onDefault") or nil

				--Update with default values
				if type(dataManagement) == "table" and type(dataManagement.keys) == "table" then for i = 1, #dataManagement.keys do
					wt.ResetOptionsData(dataManagement.category, dataManagement.keys[i])
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

		if type(parent.isType) ~= "function" and not parent.isType("SettingsPage") then parent = wt.CreateSettingsPage(addon, parent) end

		table.insert(category.pages, parent)

		wt.RegisterSettingsPage(parent)

		--Override defaults warning and add all defaults option to dialog
		wt.UpdatePopupDialog(parent.getDefaultsPopupKey(), {
			text = ns.toolboxStrings.settings.warning:gsub("#CATEGORY", wt.Color(parentTitle, colors.highlight)):gsub("#PAGE", wt.Color(parentTitle, colors.highlight)),
			accept = ALL_SETTINGS,
			alt = CURRENT_SETTINGS,
			onAccept = function() category.defaults(true) end,
			onAlt = function() parent.default(true) end,
		})

		--| Subcategories

		for i = 1, #pages do if type(pages[i]) == "table" and not pages[i].category then
			if type(pages[i].isType) ~= "function" and not pages[i].isType("SettingsPage") then pages[i] = wt.CreateSettingsPage(addon, pages[i]) end

			table.insert(category.pages, pages[i])

			wt.RegisterSettingsPage(pages[i], parent, pages[i].getProperty("titleIcon"))

			--Override defaults warning and add all defaults option to dialog
			wt.UpdatePopupDialog(pages[i].getDefaultsPopupKey(), {
				text = ns.toolboxStrings.settings.warning:gsub("#CATEGORY", wt.Color(parentTitle, colors.highlight)):gsub(
					"#PAGE", wt.Color(pages[i].title and pages[i].title:GetText() or "", colors.highlight)
				),
				accept = ALL_SETTINGS,
				alt = CURRENT_SETTINGS,
				onAccept = function() category.defaults(true) end,
				onAlt = function() pages[i].default(true) end,
			})
		end end

		return category
	end


	--[[ WIDGETS ]]

	---Register a handler as a listener for **event**
	---@param listeners table<string, function[]>
	---@param event string
	---@param listener function
	---@param callIndex integer
	local function addListener(listeners, event, listener, callIndex)
		listeners[event] = type(listeners[event]) == "table" and listeners[event] or {}

		if type(callIndex) ~= "number" then table.insert(listeners[event], listener)
		else table.insert(listeners[event], Clamp(wt.Round(callIndex), 1, #listeners[event] + 1), listener) end
	end

	---Call registered listeners for **event**
	---@param widget AnyWidgetType
	---@param listeners table<string, function[]>
	---@param event string
	---@param ... any
	local function callListeners(widget, listeners, event, ...)
		if type(listeners[event]) ~= "table" then return end

		for i = 1, #listeners[event] do listeners[event][i](widget, ...) end
	end

	--[ Button ]

	---Create a non-GUI action button widget
	---***
	---@param t? actionButtonCreationData Parameters are to be provided in this table
	---***
	---@return actionButton button Reference to the new action button widget, utility functions and more wrapped in a table
	function wt.CreateActionButton(t)
		t = t or {}

		---@class actionButton
		local button = {}

		--[ Properties ]

		--| State

		local enabled = t.disabled ~= true

		--| Events

		---@type table<string, function[]>
		local listeners = {}

		--[ Getters & Setters ]

		---Returns the object type of this widget
		---***
		---@return "ActionButton" string
		---<hr><p></p>
		function button.getType() return "ActionButton" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string|WidgetTypeName
		---@return boolean
		function button.isType(type) return type == "ActionButton" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function button.getProperty(key) return wt.FindValueByKey(t, key) end

		--| Event handling

		--Get a trigger function to call all registered listeners for the specified custom widget event with
		button.invoke = {
			enabled = function() callListeners(button, listeners, "enabled", enabled) end,

			trigger = function(user) callListeners(button, listeners, "trigger", user) end,

			---@param event string Custom event tag
			---@param ... any
			_ = function(event, ...) callListeners(button, listeners, event, ...) end
		}

		--Hook a handler function as a listener for a custom widget event
		button.setListener = {
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
		function button.isEnabled() return enabled end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** true
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** false
		function button.setEnabled(state, silent)
			enabled = state ~= false

			if not silent then button.invoke.enabled() end
		end

		--| Action

		---Trigger the action registered for the button (if it is enabled)
		---@param user? boolean Whether to flag the action as being initiated by a user interaction or not | ***Default:*** false
		---@param silent? boolean If false, invoke a "trigger" event and call registered listeners | ***Default:*** false
		function button.trigger(user, silent)
			if enabled and t.action then t.action(button, user) end

			if not silent then button.invoke.trigger(user) end
		end

		--[ Initialization ]

		--Register event handlers
		if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
			if k == "_" then button.setListener._(v[i].event, v[i].handler, v[i].callIndex) else button.setListener[k](v[i].handler, v[i].callIndex) end
		end end end end

		--Assign dependencies
		if t.dependencies then wt.AddDependencies(t.dependencies, button.setEnabled) end

		return button
	end

	--| GUI

	---Set the parameters of a GUI button widget frame
	---@param button simpleButton
	---@param t simpleButtonCreationData
	---@param name string
	---@param title string
	---@param useHighlight boolean
	local function setUpButtonFrame(button, t, name, title, useHighlight)

		--[ Frame Setup ]

		--| Position & dimensions

		t.size = t.size or {}
		t.size.w = t.size.w or 80
		t.size.h = t.size.h or 22

		if t.arrange then button.frame.arrangementInfo = t.arrange else wt.SetPosition(button.frame, t.position) end

		button.frame:SetSize(t.size.w, t.size.h)

		--| Visibility

		wt.SetVisibility(button.frame, t.visible ~= false)

		if t.frameStrata then button.frame:SetFrameStrata(t.frameStrata) end
		if t.frameLevel then button.frame:SetFrameLevel(t.frameLevel) end
		if t.keepOnTop then button.frame:SetToplevel(t.keepOnTop) end

		--[ Getters & Setters ]

		---Modify the tooltip set for the button with this to make sure it works even when the button is disabled
		---***
		---@param tooltip? widgetTooltipTextData List of text lines to set as the tooltip of the button | ***Default:*** **t.tooltip** or *no changes will be made*
		function button.setTooltip(tooltip)
			tooltip = tooltip or t.tooltip

			if not tooltip then return end

			--Create a trigger to show the tooltip when the button is disabled
			if not button.hoverTarget then
				button.hoverTarget = CreateFrame("Frame", name .. "HoverTarget", button.frame)
				button.hoverTarget:SetPoint("TOPLEFT")
				button.hoverTarget:SetSize(button.frame:GetSize())
				button.hoverTarget:Hide()
			end

			--Set the tooltip
			wt.AddTooltip(button.frame, {
				title = tooltip.title or title,
				lines = tooltip.lines,
				anchor = "ANCHOR_TOPLEFT",
				offset = { x = 20, },
			}, { triggers = { button.hoverTarget, }, })
		end

		--[ Events ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "attribute" then button.frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
			else button.frame:HookScript(key, value) end
		end end

		--| UX

		button.frame:HookScript("OnClick", function()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

			button.trigger(true)
		end)

		if button.label and useHighlight then
			button.frame:HookScript("OnEnter", function() button.label:SetFontObject(t.font.highlight) end)
			button.frame:HookScript("OnLeave", function() button.label:SetFontObject(t.font.normal) end)
		end

		--| Tooltip

		if t.tooltip then button.setTooltip() end

		--| State

		---Update the widget UI based on its enabled state
		---@param _ simpleButton
		---@param state boolean
		local function updateState(_, state)
			button.frame:SetEnabled(state)

			if state then
				if button.label then
					if useHighlight and button.frame:IsMouseOver() then button.label:SetFontObject(t.font.highlight) else button.label:SetFontObject(t.font.normal) end
				end
				if button.hoverTarget then button.hoverTarget:Hide() end
			else
				if button.label then button.label:SetFontObject(t.font.disabled) end
				if button.hoverTarget then button.hoverTarget:Show() end
			end
		end

		--Set up starting state
		updateState(button, button.isEnabled())

		--Handle widget updates
		button.setListener.enabled(updateState, 1)
	end

	---Create a default Blizzard button GUI frame with enhanced widget functionality
	---***
	---@param t? simpleButtonCreationData Parameters are to be provided in this table
	---@param widget? toggle Reference to an already existing action button to set up as a simple button instead of creating a new base widget
	---***
	---@return simpleButton|actionButton button References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table
	function wt.CreateSimpleButton(t, widget)
		t = t or {}

		---@class simpleButton : actionButton
		local button = widget and widget.isType and widget.isType("ActionButton") and widget or wt.CreateActionButton(t)

		if WidgetToolsDB.lite and t.lite ~= false then return button end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Button")

		button.frame = CreateFrame("Button", name, t.parent, "UIPanelButtonTemplate")

		--| Label

		local title = t.title or t.name or "Button"
		local customFonts = t.font ~= nil
		t.font = t.font or {}
		local useHighlight = t.font.highlight ~= nil
		t.font.normal = t.font.normal or "GameFontNormal"
		t.font.highlight = t.font.highlight or "GameFontHighlight"
		t.font.disabled = t.font.disabled or "GameFontDisable"

		if t.label ~= false then
			if customFonts then
				button.label = wt.CreateText({
					parent = button.frame,
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

		setUpButtonFrame(button, t, name, title, useHighlight)

		return button
	end

	---Create a Blizzard button frame with custom GUI and enhanced widget functionality
	---@param t? customButtonCreationData Parameters are to be provided in this table
	---@param widget? toggle Reference to an already existing action button to set up as a custom button instead of creating a new base widget
	---***
	---@return customButton|actionButton button References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button) (inheriting [BackdropTemplate](https://warcraft.wiki.gg/wiki/BackdropTemplate)), utility functions and more wrapped in a table
	function wt.CreateCustomButton(t, widget)
		t = t or {}

		---@class customButton : actionButton
		local button = widget and widget.isType and widget.isType("ActionButton") and widget or wt.CreateActionButton(t)

		if WidgetToolsDB.lite and t.lite ~= false then return button end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Button")

		button.frame = CreateFrame("Button", name, t.parent, BackdropTemplateMixin and "BackdropTemplate")

		--| Label

		local title = t.title or t.name or "Button"
		t.font = t.font or {}
		t.font.normal = t.font.normal or "GameFontNormal"
		t.font.highlight = t.font.highlight or "GameFontHighlight"
		t.font.disabled = t.font.disabled or "GameFontDisable"

		if t.label ~= false then
			button.label = wt.CreateText({
				parent = button.frame,
				name = "Label",
				position = { anchor = "CENTER", },
				width = t.size.w,
				font = t.font.normal,
			})

			if t.titleOffset then button.label:SetPoint("CENTER", t.titleOffset.x or 0, t.titleOffset.y or 0) end

			button.label:SetText(title)
		end

		--| Backdrop

		wt.SetBackdrop(button.frame, t.backdrop, t.backdropUpdates)

		--| Shared setup

		setUpButtonFrame(button, t, name, title, true)

		return button
	end

	--[ Toggle ]

	---Create a non-GUI toggle widget with data management logic
	---***
	---@param t? toggleCreationData Parameters are to be provided in this table
	---***
	---@return toggle toggle Reference to the new toggle widget, utility functions and more wrapped in a table
	function wt.CreateToggle(t)
		t = t or {}

		--[ Wrapper table ]

		---@class toggle
		local toggle = {}

		--[ Properties ]

		--| Data

		t.default = t.default == true
		local default = t.default
		local value = t.value
		if type(value) ~= "boolean" and type(t.getData) == "function" then value = t.getData() end
		if type(value) ~= "boolean" then value = default end
		local snapshot = value

		--| State

		local enabled = t.disabled ~= true

		--| Events

		---@type table<string, function[]>
		local listeners = {}

		--[ Getters & Setters ]

		---Returns the object type of this widget
		---***
		---@return "Toggle" string
		---<hr><p></p>
		function toggle.getType() return "Toggle" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string|WidgetTypeName
		---@return boolean
		function toggle.isType(type) return type == "Toggle" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function toggle.getProperty(key) return wt.FindValueByKey(t, key) end

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

		---Read the data from storage via **t.getData()** then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** false
		function toggle.loadData(handleChanges, silent)
			handleChanges = handleChanges ~= false

			if type(t.getData) == "function" then
				toggle.setState(t.getData(), handleChanges, silent)

				if not silent then toggle.invoke.loaded(true) end
			else
				--Handle changes
				if handleChanges and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
					for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
				end

				if not silent then toggle.invoke.loaded(false) end
			end
		end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param state? boolean Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** false
		function toggle.saveData(state, silent)
			if type(t.saveData) == "function" then
				if state == nil then state = value end

				t.saveData(state == true)

				if not silent then toggle.invoke.saved(true) end
			elseif not silent then toggle.invoke.saved(false) end
		end

		---Get the currently stored data via **t.getData()**
		---@return boolean|nil
		function toggle.getData() return type(t.getData) == "function" and t.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param state? boolean Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function toggle.setData(state, handleChanges, silent)
			toggle.saveData(state, silent)
			toggle.loadData(handleChanges, silent)
		end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **toggle.revertData()**
		function toggle.snapshotData() snapshot = toggle.getData() end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **toggle.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function toggle.revertData(handleChanges, silent) toggle.setData(snapshot, handleChanges, silent) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function toggle.resetData(handleChanges, silent) toggle.setData(default, handleChanges, silent) end

		---Returns the current toggle state of the widget
		---@return boolean
		function toggle.getState() return value end

		---Verify and set the toggle value of the widget to the provided state
		---***
		---@param state? boolean ***Default:*** false
		---@param user? boolean If true, mark the change as being initiated via a user interaction and call change handlers | ***Default:*** false
		---@param silent? boolean If false, invoke a "toggled" event and call registered listeners | ***Default:*** false
		function toggle.setState(state, user, silent)
			value = state == true

			if not silent then toggle.invoke.toggled(user == true) end

			if user and t.instantSave ~= false then toggle.saveData(nil, silent) end

			--Handle changes
			if user and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
				for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
			end
		end

		---Flip the current toggle state of the widget
		---***
		---@param user? boolean If true, mark the change as being initiated via a user interaction and call change handlers | ***Default:*** false
		---@param silent? boolean If false, invoke a "toggled" event and call registered listeners | ***Default:*** false
		function toggle.toggleState(user, silent) toggle.setState(not value, user, silent) end

		--| State & dependencies

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function toggle.isEnabled() return enabled end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** true
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** false
		function toggle.setEnabled(state, silent)
			enabled = state ~= false

			if not silent then toggle.invoke.enabled() end
		end

		--[ Initialization ]

		--Register event handlers
		if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
			if k == "_" then toggle.setListener._(v[i].event, v[i].handler, v[i].callIndex) else toggle.setListener[k](v[i].handler, v[i].callIndex) end
		end end end end

		--Register to options data management
		if t.dataManagement then wt.AddOptionsRule(toggle, t.dataManagement) end

		--Assign dependencies
		if t.dependencies then wt.AddDependencies(t.dependencies, toggle.setEnabled) end

		--Set starting value
		toggle.setState(value, false, true)

		return toggle
	end

	--| GUI

	---Create a default Blizzard checkbox GUI frame with enhanced widget functionality
	---***
	---@param t? checkboxCreationData Parameters are to be provided in this table
	---@param widget? toggle Reference to an already existing toggle to set up as a checkbox instead of creating a new base widget
	---***
	---@return checkbox|toggle toggle References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
	function wt.CreateCheckbox(t, widget)
		t = t or {}

		---@class checkbox: toggle
		---@field label? FontString
		local toggle = widget and widget.isType and widget.isType("Toggle") and widget or wt.CreateToggle(t)

		if WidgetToolsDB.lite and t.lite ~= false then return toggle end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")

		toggle.frame = CreateFrame("Frame", name, t.parent)
		toggle.button = CreateFrame("CheckButton", name .. "Checkbox", toggle.frame, "SettingsCheckboxTemplate")

		--| Position & dimensions

		t.size = t.size or {}
		t.size.h = t.size.h or toggle.button:GetHeight()
		t.size.w = t.label == false and t.size.h * (30 / 29) or t.size.w or 190

		if t.arrange then toggle.frame.arrangementInfo = t.arrange else wt.SetPosition(toggle.frame, t.position) end
		toggle.button:SetPoint("LEFT")
		wt.SetPosition(toggle.button.HoverBackground, {
			anchor = "LEFT",
			offset = { x = -2, },
		})

		toggle.frame:SetSize(t.size.w, t.size.h)
		toggle.button:SetSize(t.size.h * (30 / 29), t.size.h)
		toggle.button.HoverBackground:SetSize(t.size.w + 2, t.size.h)

		--| Visibility

		wt.SetVisibility(toggle.frame, t.visible ~= false)

		if t.frameStrata then toggle.frame:SetFrameStrata(t.frameStrata) end
		if t.frameLevel then toggle.frame:SetFrameLevel(t.frameLevel) end
		if t.keepOnTop then toggle.frame:SetToplevel(t.keepOnTop) end

		--| Label

		t.font = t.font or {}
		t.font.normal = t.font.normal or "GameFontHighlight"
		t.font.highlight = t.font.highlight or "GameFontNormal"
		t.font.disabled = t.font.disabled or "GameFontDisable"

		local title = t.title or t.name or "Toggle"

		toggle.label = wt.AddTitle({
			parent = toggle.frame,
			title = t.label ~= false and {
				offset = { x = t.size.h * (30 / 29) + 6, },
				text = title,
				anchor = "LEFT",
				font = t.font.normal,
			} or nil,
		})

		--| Texture

		toggle.button:GetPushedTexture():SetVertexColor(.6, .6, .6, 1)

		--[ Events ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "attribute" then toggle.button:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
			elseif key == "OnClick" then toggle.button:SetScript("OnClick", function(self, button, down) value(self, self:GetChecked(), button, down) end)
			else toggle.button:HookScript(key, value) end
		end end

		--| UX

		---Update the widget UI based on the toggle state
		---@param _ toggle
		---@param state boolean
		local function updateToggleState(_, state) toggle.button:SetChecked(state) end

		--Handle widget updates
		toggle.setListener.toggled(updateToggleState, 1)

		toggle.button:HookScript("OnClick", function(self)
			local state = self:GetChecked()

			PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

			toggle.setState(state, true)
		end)

		--Linked mouse interactions
		toggle.frame:HookScript("OnEnter", function() if toggle.isEnabled() then
			toggle.button.HoverBackground:Show()
			if IsMouseButtonDown("LeftButton") then toggle.button:SetButtonState("PUSHED") end
		end end)
		toggle.frame:HookScript("OnLeave", function() if toggle.isEnabled() then
			toggle.button.HoverBackground:Hide()
			toggle.button:SetButtonState("NORMAL")
		end end)
		toggle.frame:HookScript("OnMouseDown", function(_, button) if toggle.isEnabled() and button == "LeftButton" or (button == "RightButton") then
			toggle.button:SetButtonState("PUSHED")
		end end)
		toggle.frame:HookScript("OnMouseUp", function(_, button, isInside) if toggle.isEnabled() then
			toggle.button:SetButtonState("NORMAL")

			if isInside and button == "LeftButton" then toggle.button:Click(button) end
		end end)

		--| Tooltip

		if t.tooltip then
			local defaultValue
			if t.showDefault ~= false then
				defaultValue = WrapTextInColorCode((t.default and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), t.default and "FFAAAAFF" or "FFFFAA66")
			end

			wt.AddWidgetTooltipLines(t, defaultValue)
			wt.AddTooltip(toggle.button, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_NONE",
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = toggle.button,
					relativePoint = "TOPRIGHT",
				},
			}, { triggers = { toggle.frame, }, })
		end

		--| Utility menu

		if t.utilityMenu ~= false then
			local menu = wt.CreateContextMenu({ parent = toggle.frame, initialize = function(menu)
				wt.CreateMenuTextline(menu, { text = title })
				wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.revert, action = function() toggle.revertData() end })
				if t.default ~= nil then wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.restore, action = function() toggle.resetData() end }) end
			end, condition = toggle.isEnabled })

			--Add trigger
			toggle.button:HookScript("OnMouseUp", function(_, button, isInside) if toggle.isEnabled() and isInside and button == "RightButton" then menu.open() end end)
		end

		--| State

		---Update the widget UI based on its enabled state
		---@param _ toggle
		---@param state boolean
		local function updateState(_, state)
			toggle.button:SetEnabled(state)
			toggle.button:EnableMouse(state)

			if toggle.label then toggle.label:SetFontObject(state and t.font.normal or t.font.disabled) end
		end

		--Handle widget updates
		toggle.setListener.enabled(updateState, 1)

		--[ Initialization ]

		--Set starting toggle state
		updateToggleState(nil, toggle.getState())

		--Set up starting state
		updateState(nil, toggle.isEnabled())

		return toggle
	end

	---Set the parameters of a GUI toggle widget frame
	---@param toggle checkbox|radioButton
	---@param t checkboxCreationData
	---@param title string
	local function setUpToggleFrame(toggle, t, title)

		--[ Frame Setup ]

		--| Position & dimensions

		if t.arrange then toggle.frame.arrangementInfo = t.arrange else wt.SetPosition(toggle.frame, t.position) end
		toggle.button:SetPoint("TOPLEFT")

		toggle.frame:SetSize(t.size.w, t.size.h)
		toggle.button:SetSize(t.size.h, t.size.h) --1:1 aspect ratio applies

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
		---@param _ toggle
		---@param state boolean
		local function updateToggleState(_, state) toggle.button:SetChecked(state) end

		--Handle widget updates
		toggle.setListener.toggled(updateToggleState, 1)

		--| Tooltip

		if t.tooltip then
			local defaultValue
			if t.showDefault ~= false then
				defaultValue = WrapTextInColorCode((t.default and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), t.default and "FFAAAAFF" or "FFFFAA66")
			end

			wt.AddWidgetTooltipLines(t, defaultValue)
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
		end

		--| Utility menu

		if t.utilityMenu ~= false then
			local menu = wt.CreateContextMenu({ parent = toggle.frame, initialize = function(menu)
				wt.CreateMenuTextline(menu, { text = title })
				wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.revert, action = function() toggle.revertData() end })
				if t.default ~= nil then wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.restore, action = function() toggle.resetData() end }) end
			end, condition = toggle.isEnabled })

			--Add trigger
			toggle.button:HookScript("OnMouseUp", function(_, button, isInside) if toggle.isEnabled() and isInside and button == "RightButton" then menu.open() end end)
		end

		--[ Initialization ]

		--Set starting toggle state
		updateToggleState(nil, toggle.getState())
	end

	---Create a classic Blizzard checkbox GUI frame with enhanced widget functionality
	---***
	---@param t? checkboxCreationData Parameters are to be provided in this table
	---@param widget? toggle Reference to an already existing toggle to set up as a checkbox instead of creating a new base widget
	---***
	---@return checkbox|toggle toggle References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
	function wt.CreateClassicCheckbox(t, widget)
		t = t or {}

		---@type checkbox
		local toggle = widget and widget.isType and widget.isType("Toggle") and widget or wt.CreateToggle(t)

		if WidgetToolsDB.lite and t.lite ~= false then return toggle end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")

		--Click target
		toggle.frame = CreateFrame("Frame", name, t.parent)

		--Checkbox
		toggle.button = CreateFrame("CheckButton", name .. "Checkbox", toggle.frame, "InterfaceOptionsCheckButtonTemplate")

		--| Label

		t.font = t.font or {}
		t.font.normal = t.font.normal or "GameFontHighlight"
		t.font.highlight = t.font.highlight or "GameFontNormal"
		t.font.disabled = t.font.disabled or "GameFontDisable"

		local title = t.title or t.name or "Toggle"

		if t.label ~= false then
			toggle.label = _G[name .. "CheckboxText"]

			toggle.label:SetPoint("LEFT", toggle.button, "RIGHT", 2, 0)
			toggle.label:SetFontObject(t.font.normal)

			toggle.label:SetText(title)
		else _G[name .. "CheckboxText"]:Hide() end

		--| Shared setup

		t.size = t.size or {}
		t.size.h = t.size.h or 26
		t.size.w = t.label == false and t.size.h or t.size.w or 180

		setUpToggleFrame(toggle, t, title)

		--[ Events ]

		--| UX

		toggle.button:HookScript("OnClick", function(self)
			local state = self:GetChecked()

			PlaySound(state and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

			toggle.setState(state, true)
		end)

		--Linked mouse interactions
		toggle.frame:HookScript("OnEnter", function() if toggle.isEnabled() then
			toggle.button:LockHighlight()
			if IsMouseButtonDown("LeftButton") or (IsMouseButtonDown("RightButton")) then toggle.button:SetButtonState("PUSHED") end
		end end)
		toggle.frame:HookScript("OnLeave", function() if toggle.isEnabled() then
			toggle.button:UnlockHighlight()
			toggle.button:SetButtonState("NORMAL")
		end end)
		toggle.frame:HookScript("OnMouseDown", function(_, button) if toggle.isEnabled() and button == "LeftButton" or (button == "RightButton") then
			toggle.button:SetButtonState("PUSHED")
		end end)
		toggle.frame:HookScript("OnMouseUp", function(_, button, isInside) if toggle.isEnabled() then
			toggle.button:SetButtonState("NORMAL")

			if isInside and button == "LeftButton" or (button == "RightButton") then toggle.button:Click(button) end
		end end)

		--| State

		---Update the widget UI based on its enabled state
		---@param _ toggle
		---@param state boolean
		local function updateState(_, state)
			toggle.button:SetEnabled(state)

			if toggle.label then toggle.label:SetFontObject(state and t.font.normal or t.font.disabled) end
		end

		--Handle widget updates
		toggle.setListener.enabled(updateState, 1)

		--[ Initialization ]

		--Set up starting state
		updateState(nil, toggle.isEnabled())

		return toggle
	end

	---Create a default Blizzard radio button GUI frame with enhanced widget functionality
	---***
	---@param t? radioButtonCreationData Parameters are to be provided in this table
	---@param widget? toggle Reference to an already existing toggle to set up as a radio button instead of creating a new base widget
	---***
	---@return radioButton|toggle toggle References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
	function wt.CreateRadioButton(t, widget)
		t = t or {}

		---@class radioButton: toggle
		---@field label? FontString
		local toggle = widget and widget.isType and widget.isType("Toggle") and widget or wt.CreateToggle(t)

		if WidgetToolsDB.lite and t.lite ~= false then return toggle end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Toggle")

		--Click target
		toggle.frame = CreateFrame("Frame", name, t.parent)

		--Radio button
		toggle.button = CreateFrame("CheckButton", name .. "RadioButton", toggle.frame, "UIRadioButtonTemplate")

		--| Label

		local title = t.title or t.name or "Toggle"

		if t.label ~= false then
			toggle.label = _G[name .. "RadioButtonText"]

			toggle.label:SetPoint("LEFT", toggle.button, "RIGHT", 3, 0)
			toggle.label:SetFontObject("GameFontHighlightSmall")

			toggle.label:SetText(title)
		else _G[name .. "RadioButtonText"]:Hide() end

		--| Shared setup

		t.size = t.size or {}
		t.size.h = t.size.h or 16
		t.size.w = t.label == false and t.size.h or t.size.w or 160

		setUpToggleFrame(toggle, t, title)

		--[ Events ]

		--| UX

		toggle.button:HookScript("OnClick", function(_, button)
			if button == "LeftButton" then
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

				toggle.setState(true, true)
			elseif t.clearable and button == "RightButton" then
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)

				toggle.setState(false, true)
			end
		end)

		--Linked mouse interactions
		toggle.frame:HookScript("OnEnter", function() if toggle.button:IsEnabled() then
			toggle.button:LockHighlight()
			if IsMouseButtonDown("LeftButton") or (t.clearable and IsMouseButtonDown("RightButton")) then toggle.button:SetButtonState("PUSHED") end
		end end)
		toggle.frame:HookScript("OnLeave", function() if toggle.button:IsEnabled() then
			toggle.button:UnlockHighlight()
			toggle.button:SetButtonState("NORMAL")
		end end)
		toggle.frame:HookScript("OnMouseDown", function(_, button) if toggle.button:IsEnabled() and button == "LeftButton" or (t.clearable and button == "RightButton") then
			toggle.button:SetButtonState("PUSHED")
		end end)
		toggle.frame:HookScript("OnMouseUp", function(_, button, isInside) if toggle.button:IsEnabled() then
			toggle.button:SetButtonState("NORMAL")

			if isInside and button == "LeftButton" or (t.clearable and button == "RightButton") then toggle.button:Click(button) end
		end end)

		--| State

		---Update the widget UI based on its enabled state
		---@param _ toggle
		---@param state boolean
		local function updateState(_, state)
			toggle.button:SetEnabled(state)

			if toggle.label then toggle.label:SetFontObject(state and "GameFontHighlightSmall" or "GameFontDisableSmall") end
		end

		--Handle widget updates
		toggle.setListener.enabled(updateState, 1)

		--[ Initialization ]

		--Set up starting state
		updateState(nil, toggle.isEnabled())

		return toggle
	end

	--[ Selector ]

	local itemsets = {
		anchor = {
			{ name = ns.toolboxStrings.points.top.left, value = "TOPLEFT" },
			{ name = ns.toolboxStrings.points.top.center, value = "TOP" },
			{ name = ns.toolboxStrings.points.top.right, value = "TOPRIGHT" },
			{ name = ns.toolboxStrings.points.left, value = "LEFT" },
			{ name = ns.toolboxStrings.points.center, value = "CENTER" },
			{ name = ns.toolboxStrings.points.right, value = "RIGHT" },
			{ name = ns.toolboxStrings.points.bottom.left, value = "BOTTOMLEFT" },
			{ name = ns.toolboxStrings.points.bottom.center, value = "BOTTOM" },
			{ name = ns.toolboxStrings.points.bottom.right, value = "BOTTOMRIGHT" },
		},
		justifyH = {
			{ name = ns.toolboxStrings.points.left, value = "LEFT" },
			{ name = ns.toolboxStrings.points.center, value = "CENTER" },
			{ name = ns.toolboxStrings.points.right, value = "RIGHT" },
		},
		justifyV = {
			{ name = ns.toolboxStrings.points.top.center, value = "TOP" },
			{ name = ns.toolboxStrings.points.center, value = "MIDDLE" },
			{ name = ns.toolboxStrings.points.bottom.center, value = "BOTTOM" },
		},
		frameStrata = {
			{ name = ns.toolboxStrings.strata.lowest, value = "BACKGROUND" },
			{ name = ns.toolboxStrings.strata.lower, value = "LOW" },
			{ name = ns.toolboxStrings.strata.low, value = "MEDIUM" },
			{ name = ns.toolboxStrings.strata.lowMid, value = "HIGH" },
			{ name = ns.toolboxStrings.strata.highMid, value = "DIALOG" },
			{ name = ns.toolboxStrings.strata.high, value = "FULLSCREEN" },
			{ name = ns.toolboxStrings.strata.higher, value = "FULLSCREEN_DIALOG" },
			{ name = ns.toolboxStrings.strata.highest, value = "TOOLTIP" },
		}
	}

	---@class selectorToggle : toggle
	---@field index integer The index of this toggle item inside a selector widget

	---Create a non-GUI selector widget (with a collection of toggle widgets) with data management logic
	---***
	---@param t? selectorCreationData Parameters are to be provided in this table
	---***
	---@return selector selector Reference to the new selector widget, utility functions and more wrapped in a table
	function wt.CreateSelector(t)
		t = t or {}

		--[ Wrapper table ]

		---@class selector
		local selector = {}

		--[ Properties ]

		--| Toggle items

		t.items = t.items or {}

		---@type selectorToggle[]
		selector.toggles = {}

		---@type selectorToggle[]
		local inactive = {}

		--| Data

		local default = 1

		---Data verification utility
		---@param v any
		---@return integer|nil
		local function verify(v)
			v = type(v) == "number" and Clamp(math.floor(v), 1, #selector.toggles) or nil

			return v and v or not t.clearable and default or nil
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

		---Returns the object type of this widget
		---***
		---@return "Selector" string
		---<hr><p></p>
		function selector.getType() return "Selector" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string|WidgetTypeName
		---@return boolean
		function selector.isType(type) return type == "Selector" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function selector.getProperty(key) return wt.FindValueByKey(t, key) end

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
		---@param silent? boolean ***Default:*** false
		local function setToggle(index, silent)
			local new = false

			if t.items[index].isType and t.items[index].isType("Toggle") then
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
		--- - ***Note:*** The currently selected item may not be the same after item were removed. In that case, the new item at the same index will be selected instead. If one or more items from the last indexes were removed, the new last item at the reduced count index will be selected. Make sure to use **selector.setSelected(...)** to correct the selection if needed!
		---***
		---@param items (selectorItem|toggle|selectorToggle)[] Table containing subtables with data used to update the toggle widgets, or already existing toggle widgets
		---@param silent? boolean If false, invoke "updated" or "added" events and call registered listeners | ***Default:*** false
		function selector.updateItems(items, silent)
			t.items = items

			--Update the toggle widgets
			for i = 1, #items do
				setToggle(i, silent)

				if not silent then selector.toggles[i].invoke._("activated", true) end
			end

			--Deactivate extra toggle widgets
			while #items < #selector.toggles do
				selector.toggles[#selector.toggles].setState(false)

				if not silent then selector.toggles[#selector.toggles].invoke._("activated", false) end

				table.insert(inactive, selector.toggles[#selector.toggles])
				table.remove(selector.toggles, #selector.toggles)
			end

			if not silent then selector.invoke.updated() end

			selector.setSelected(value)
		end

		--| Options data management

		---Read the data from storage via **t.getData()** then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** false
		function selector.loadData(handleChanges, silent)
			handleChanges = handleChanges ~= false

			if type(t.getData) == "function" then
				selector.setSelected(t.getData(), handleChanges)

				if not silent then selector.invoke.loaded(true) end
			else
				if handleChanges and type(t.dataManagement.onChange) == "table" then for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end end

				if not silent then selector.invoke.loaded(false) end
			end
		end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param data? wrappedIntegerValue If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** false
		function selector.saveData(data, silent)
			if type(t.saveData) == "function" then
				t.saveData(type(data) == "table" and verify(data.index) or value)

				if not silent then selector.invoke.saved(true) end
			elseif not silent then selector.invoke.saved(false) end
		end

		---Get the currently stored data via **t.getData()**
		---@return integer|nil
		function selector.getData() return type(t.getData) == "function" and t.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param data? wrappedIntegerValue If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function selector.setData(data, handleChanges, silent)
			selector.saveData(data, silent)
			selector.loadData(handleChanges, silent)
		end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
		function selector.snapshotData() snapshot = { index = selector.getData() } end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function selector.revertData(handleChanges, silent) selector.setData(snapshot, handleChanges, silent) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function selector.resetData(handleChanges, silent) selector.setData({ index = default }, handleChanges, silent) end

		---Returns the index of the currently selected item or nil if there is no selection
		---@return integer|nil index
		function selector.getSelected() return value end

		---Verify and set the specified item as selected
		---***
		---@param index? integer ***Default:*** nil *(no selection)*
		---@param user? boolean If true, mark the change as being initiated via a user interaction and call change handlers | ***Default:*** false
		---@param silent? boolean If false, invoke a "selected" event and call registered listeners | ***Default:*** false
		function selector.setSelected(index, user, silent)
			value = verify(index)

			--Update toggle states
			for i = 1, #selector.toggles do selector.toggles[i].setState(i == value, user, silent) end

			if user and t.instantSave ~= false then selector.saveData(nil, silent) end

			if not silent then selector.invoke.selected(user == true) end

			--Handle changes
			if user and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
				for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
			end
		end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function selector.isEnabled() return enabled end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** true
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** false
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

		--Register to options data management
		if t.dataManagement then wt.AddOptionsRule(selector, t.dataManagement) end

		--Assign dependencies
		if t.dependencies then wt.AddDependencies(t.dependencies, selector.setEnabled) end

		--Set starting value
		selector.setSelected(value, false, true)

		return selector
	end

	---Create a non-GUI special selector widget (with a collection of toggle widgets) with data management logic specific to the specified **itemset**
	---***
	---@param itemset SpecialSelectorItemset Specify what type of selector should be created
	---@param t? specialSelectorCreationData Parameters are to be provided in this table
	---***
	---@return selector selector Reference to the new selector widget, utility functions and more wrapped in a table
	function wt.CreateSpecialSelector(itemset, t)
		t = t or {}

		--[ Wrapper table ]

		---@class specialSelector
		local selector = {}

		--[ Properties ]

		t.items = {}
		for i = 1, #itemsets[itemset] do
			t.items[i] = {}
			t.items[i].title = itemsets[itemset][i].name
			t.items[i].tooltip = { lines = { { text = "(" .. itemsets[itemset][i].value .. ")", }, } }
		end

		---@type selectorToggle[]
		selector.toggles = {}

		---@type selectorToggle[]
		local inactive = {}

		--| Data

		local default = itemsets[itemset][1].value

		---Data verification utility
		---@param v any
		---@return FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata|nil
		---@return integer|nil
		local function verify(v)
			local index = type(v) == "number" and Clamp(math.floor(v), 1, #selector.toggles) or v
			if type(v) == "string" then for i = 1, #itemsets[itemset] do if itemsets[itemset][i].value == v then index = i break end end end
			v = itemsets[itemset][index]

			return type(v) == "table" and v.value or not t.clearable and default or nil, index
		end

		default, t.default = verify(t.default)
		local value = verify(t.value or type(t.getData) == "function" and t.getData() or nil)
		local snapshot = value

		--| State

		local enabled = t.disabled ~= true

		--| Events

		---@type table<string, function[]>
		local listeners = {}

		--[ Getters & Setters ]

		---Returns the object type of this widget
		---***
		---@return "SpecialSelector" string
		---<hr><p></p>
		function selector.getType() return "SpecialSelector" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string|WidgetTypeName
		---@return boolean
		function selector.isType(type) return type == "SpecialSelector" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function selector.getProperty(key) return wt.FindValueByKey(t, key) end

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

		---Read the data from storage via **t.getData()** then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** false
		function selector.loadData(handleChanges, silent)
			handleChanges = handleChanges ~= false

			if type(t.getData) == "function" then
				selector.setSelected(t.getData(), handleChanges)

				if not silent then selector.invoke.loaded(true) end
			else
				if handleChanges and type(t.dataManagement.onChange) == "table" then for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end end

				if not silent then selector.invoke.loaded(false) end
			end
		end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param data? wrappedSpecialData If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** false
		function selector.saveData(data, silent)
			if type(t.saveData) == "function" then
				t.saveData(type(data) == "table" and verify(data.value) or value)

				if not silent then selector.invoke.saved(true) end
			elseif not silent then selector.invoke.saved(false) end
		end

		---Get the currently stored data via **t.getData()**
		---@return FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata|nil
		function selector.getData() return type(t.getData) == "function" and t.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param data? wrappedSpecialData If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function selector.setData(data, handleChanges, silent)
			selector.saveData(data, silent)
			selector.loadData(handleChanges, silent)
		end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
		function selector.snapshotData() snapshot = { value = selector.getData() } end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function selector.revertData(handleChanges, silent) selector.setData(snapshot, handleChanges, silent) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function selector.resetData(handleChanges, silent) selector.setData({ value = default }, handleChanges, silent) end

		---Returns the value of the currently selected item or nil if there is no selection
		---@return FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata|nil
		function selector.getSelected() return value end

		---Set the specified item as selected
		---***
		---@param selected? integer|FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata The index or the value of the item to be set as selected ***Default:*** nil *(no selection)*
		---@param user? boolean If true, mark the change as being initiated via a user interaction and call change handlers | ***Default:*** false
		---@param silent? boolean If false, invoke a "selected" event and call registered listeners | ***Default:*** false
		function selector.setSelected(selected, user, silent)
			value, selected = verify(selected)

			--Update toggle states
			for i = 1, #selector.toggles do selector.toggles[i].setState(i == selected, user, silent) end

			if user and t.instantSave ~= false then selector.saveData(nil, silent) end

			if not silent then selector.invoke.selected(user == true) end

			--Handle changes
			if user and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
				for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
			end
		end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function selector.isEnabled() return enabled end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** true
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** false
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

		--Register to options data management
		if t.dataManagement then wt.AddOptionsRule(selector, t.dataManagement) end

		--Assign dependencies
		if t.dependencies then wt.AddDependencies(t.dependencies, selector.setEnabled) end

		--Set starting value
		selector.setSelected(value, false, true)

		return selector
	end

	---Create a non-GUI multiselector widget (with a collection of toggle widgets) with data management logic
	---***
	---@param t? multiselectorCreationData Parameters are to be provided in this table
	---***
	---@return multiselector selector Reference to the new multiselector widget, utility functions and more wrapped in a table
	function wt.CreateMultiselector(t)
		t = t or {}

		---@class multiselector
		local selector = {}

		--[ Properties ]

		--| Toggle items

		t.items = t.items or {}
		t.limits = t.limits or {}
		t.limits.min = t.limits.min or 1
		t.limits.max = t.limits.max or #t.items

		---@type selectorToggle[]
		selector.toggles = {}

		---@type selectorToggle[]
		local inactive = {}

		--| Data

		local default = {}
		for i = 1, #t.items do default[i] = false end

		---Data verification utility
		---@param v any
		---@return boolean[]|nil
		local function verify(v)
			return wt.AddMissing(wt.RemoveEmpty(type(v) == "table" and wt.Clone(v) or {}, function(_, itemValue) return type(itemValue) == "boolean" end), default)
		end

		default = verify(t.default)
		local value = verify(t.value or type(t.getData) == "function" and t.getData() or nil)
		local snapshot = wt.Clone(value)

		--| State

		local enabled = t.disabled ~= true

		--| Events

		---@type table<string, function[]>
		local listeners = {}

		--[ Getters & Setters ]

		---Returns the object type of this widget
		---***
		---@return "Selector" string
		---<hr><p></p>
		function selector.getType() return "Multiselector" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string|WidgetTypeName
		---@return boolean
		function selector.isType(type) return type == "Multiselector" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function selector.getProperty(key) return wt.FindValueByKey(t, key) end

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
		---@param silent? boolean ***Default:*** false
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
		---@param items (selectorItem|toggle|selectorToggle)[] Table containing subtables with data used to update the toggle widgets, or already existing toggle widgets
		---@param silent? boolean If false, invoke "updated" or "added" events and call registered listeners | ***Default:*** false
		function selector.updateItems(items, silent)
			t.items = items

			--Update the toggle widgets
			for i = 1, #items do
				setToggle(items[i], i, silent)

				if not silent then selector.toggles[i].invoke._("activated", true) end
			end

			--Deactivate extra toggle widgets
			while #items < #selector.toggles do
				selector.toggles[#selector.toggles].setState(nil, nil, silent)

				if not silent then selector.toggles[#selector.toggles].invoke._("activated", false) end

				table.insert(inactive, selector.toggles[#selector.toggles])
				table.remove(selector.toggles, #selector.toggles)
			end

			if not silent then selector.invoke.updated() end

			--Update limits
			if t.limits.min > #t.items then t.limits.min = #t.items end
			if t.limits.max > #t.items then t.limits.max = #t.items end

			selector.setSelections(value, silent)
		end

		--| Options data management

		---Read the data from storage via **t.getData()** then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** false
		function selector.loadData(handleChanges, silent)
			handleChanges = handleChanges ~= false

			if type(t.getData) == "function" then
				selector.setSelections(t.getData(), handleChanges)

				if not silent then selector.invoke.loaded(true) end
			else
				if handleChanges and type(t.dataManagement.onChange) == "table" then for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end end

				if not silent then selector.invoke.loaded(false) end
			end
		end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param data? wrappedBooleanArrayData If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** false
		function selector.saveData(data, silent)
			if type(t.saveData) == "function" then
				t.saveData(type(data) == "table" and verify(data.selections) or value)

				if not silent then selector.invoke.saved(true) end
			elseif not silent then selector.invoke.saved(false) end
		end

		---Get the currently stored data via **t.getData()**
		---@return boolean[]|nil
		function selector.getData() return type(t.getData) == "function" and t.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param data? wrappedBooleanArrayData If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function selector.setData(data, handleChanges, silent)
			selector.saveData(data, silent)
			selector.loadData(handleChanges, silent)
		end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
		function selector.snapshotData() snapshot = { selections = selector.getData() } end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function selector.revertData(handleChanges, silent) selector.setData(snapshot, handleChanges, silent) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function selector.resetData(handleChanges, silent) selector.setData({ selections = wt.Clone(default) }, handleChanges, silent) end

		---Returns the list of all items and their current states
		---***
		---@return boolean[] selections Indexed list of item states
		function selector.getSelections() return value end

		---Set the specified items as selected
		---***
		---@param selections? boolean[]|nil  Indexed list of item states | ***Default:*** false[] *(no selected items)*
		---@param user? boolean If true, mark the change as being initiated via a user interaction and call change handlers | ***Default:*** false
		---@param silent? boolean If false, invoke "selected" and "limited" events and call registered listeners | ***Default:*** false
		function selector.setSelections(selections, user, silent)
			value = verify(selections)

			--Update toggle states
			for i = 1, #selector.toggles do selector.toggles[i].setState(value[i], user, silent) end

			if user and t.instantSave ~= false then selector.saveData(nil, silent) end

			if not silent then
				selector.invoke.selected(user == true)

				--| Check limits

				local count = 0

				for _, v in pairs(value) do if v then count = count + 1 end end

				selector.invoke.limited(count)
			end

			--Handle changes
			if user and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
				for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
			end
		end

		---Set the specified item as selected
		---***
		---@param index integer Index of the item | ***Range:*** (1, #selector.toggles)
		---@param selected? boolean If true, set the item at this index as selected | ***Default:*** false
		---@param user? boolean If true, mark the change as being initiated via a user interaction and call change handlers | ***Default:*** false
		---@param silent? boolean If false, invoke "selected" and "limited" events and call registered listeners | ***Default:*** false
		function selector.setSelected(index, selected, user, silent)
			if not selector.toggles[index] then return end

			value[index] = selected == true

			--Update toggle state
			selector.toggles[index].setState(selected, user, silent)

			if user and t.instantSave ~= false then selector.saveData(nil, silent) end

			if not silent then
				selector.invoke.selected(user == true)

				--| Check limits

				local count = 0

				for _, v in pairs(value) do if v then count = count + 1 end end

				selector.invoke.limited(count)
			end

			--Handle changes
			if user and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
				for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
			end
		end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function selector.isEnabled() return enabled end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** true
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** false
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

		--Register to options data management
		if t.dataManagement then wt.AddOptionsRule(selector, t.dataManagement) end

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
	---@param selector radioSelector|checkboxSelector
	---@param t radioSelectorCreationData|checkboxSelectorCreationData
	---@param name string
	---@param title string
	local function setUpSelectorFrame(selector, t, name, title)

		--[ Frame Setup ]

		selector.frame = CreateFrame("Frame", name, t.parent)

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

		selector.label = wt.AddTitle({
			parent = selector.frame,
			title = t.label ~= false and {
				offset = { x = 4, },
				text = title,
			} or nil,
		})

		--[ Events ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "attribute" then selector.frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
			else selector.frame:HookScript(key, value) end
		end end

		--| State

		---Update the widget UI based on its enabled state
		---@param _ selector
		---@param state boolean
		local function updateState(_, state) if selector.label then selector.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end end

		--Handle widget updates
		selector.setListener.enabled(updateState, 1)

		--[ Initialization ]

		--Set up starting state
		updateState(nil, selector.isEnabled())
	end

	---Create a custom radio selector GUI frame to pick one out of multiple options with enhanced widget functionality
	---***
	---@param t? radioSelectorCreationData Parameters are to be provided in this table
	---@param widget? selector Reference to an already existing selector to set up as a radio selector instead of creating a new base widget
	---***
	---@return radioSelector|selector selector References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
	function wt.CreateRadioSelector(t, widget)
		t = t or {}

		---@class selectorRadioButton : selectorToggle, radioButton

		---@class radioSelector : selector
		---@field toggles? selectorRadioButton[] The list of radio button widgets linked together in this selector
		local selector = widget and widget.isType and (widget.isType("Selector") or widget.isType("SpecialSelector")) and widget or wt.CreateSelector(t)

		if WidgetToolsDB.lite and t.lite ~= false then return selector end

		--[ Frame Setup ]

		--| Shared setup

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Selector")
		local title = t.title or t.name or "Selector"

		setUpSelectorFrame(selector, t, name, title)

		--| Radio button items

		---Set up or create new radio button item
		---@param item selectorToggle|selectorRadioButton
		---@param active boolean
		local function setRadioButton(item, active)
			if active and not item.frame then
				local sameRow = (item.index - 1) % t.columns > 0

				wt.CreateRadioButton({
					parent = selector.frame,
					name = findName(name, item.index),
					title = t.items[item.index].title,
					label = t.labels,
					tooltip = t.items[item.index].tooltip,
					position = {
						relativeTo = item.index ~= 1 and selector.toggles[sameRow and item.index - 1 or item.index - t.columns].frame or selector.label,
						relativePoint = item.index > 1 and (sameRow and "TOPRIGHT" or "BOTTOMLEFT") or (selector.label and "BOTTOMLEFT" or nil),
						offset = { x = selector.label and item.index == 1 and -4 or 0, y = selector.label and item.index == 1 and -2 or 0}
					},
					size = { w = (t.width and t.columns == 1) and t.width or nil, },
					clearable = t.clearable,
					events = { OnClick = function(_, _, button)
						if button == "LeftButton" then selector.setSelected(item.index, true)
						elseif t.clearable and button == "RightButton" and not selector.getSelected() then selector.setSelected(nil, true) end
					end, },
					showDefault = false,
					utilityMenu = false,
				}, item)
			elseif active then
				--Update label
				if item.label then item.label:SetText(t.items[item.index].title) end

				--Update tooltip
				if t.items[item.index].tooltip and not item.frame.tooltipData then wt.AddTooltip(item.frame, {
					title = t.items[item.index].tooltip.title or t.title or t.name or "Toggle",
					lines = t.items[item.index].tooltip.lines,
					anchor = "ANCHOR_NONE",
					position = {
						anchor = "BOTTOMLEFT",
						relativeTo = item.button,
						relativePoint = "TOPRIGHT",
					},
				}, { triggers = { item.button, }, }) elseif item.frame.tooltipData then item.frame.tooltipData = t.items[item.index].tooltip end
			else wt.SetVisibility(item.frame, false) end
		end

		--Set up current items
		for i = 1, #selector.toggles do
			setRadioButton(selector.toggles[i], true)

			--Handle item updates
			selector.toggles[i].setListener._("activated", function(self, active) setRadioButton(self, active) end)
		end

		--Handle item list updates
		if selector.setListener.updated and selector.setListener.added then
			selector.setListener.updated(function() selector.frame:SetHeight(math.ceil((#selector.toggles) / t.columns) * 16 + (t.label ~= false and 14 or 0)) end, 1)
			selector.setListener.added(function (_, toggle)
				setRadioButton(toggle, true)

				--Handle item updates
				toggle.setListener._("activated", function(self, active) setRadioButton(self, active) end)
			end)
		end

		--[ Events ]

		--| Tooltip

		if t.tooltip then
			local defaultValue
			if t.showDefault ~= false then defaultValue = WrapTextInColorCode(t.default and t.items[t.default].title or tostring(t.default), "FFFFFFFF") end

			wt.AddWidgetTooltipLines(t, defaultValue)
			wt.AddTooltip(selector.frame, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			})
		end

		--| Utility menu

		if t.utilityMenu ~= false then
			wt.CreateContextMenu({ parent = selector.frame, initialize = function(menu)
				wt.CreateMenuTextline(menu, { text = title })
				wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.revert, action = function() selector.revertData() end })
				if t.default then wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.restore, action = function() selector.resetData() end }) end
			end, condition = selector.isEnabled })
		end

		return selector
	end

	---Create a custom special radio selector GUI frame to pick an Anchor Point, a horizontal or vertical text alignment or Frame Strata value with enhanced widget functionality
	---***
	---@param itemset SpecialSelectorItemset Specify what type of selector should be created
	---@param t? specialRadioSelectorCreationData Parameters are to be provided in this table
	---@param widget? selector Reference to an already existing special selector widget to set up as a special selector frame instead of creating a new base widget
	---***
	---@return specialSelector|specialRadioSelector selector References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
	function wt.CreateSpecialRadioSelector(itemset, t, widget)
		t = t or {}
		t.labels = false
		t.columns = itemset == "frameStrata" and 8 or 3

		---@class specialRadioSelector : radioSelector
		local selector = wt.CreateRadioSelector(t, widget and widget.isType and widget.isType("SpecialSelector") and widget or wt.CreateSpecialSelector(itemset, t))

		return selector
	end

	---Create a custom checkbox selector GUI frame to pick multiple options out of a list with enhanced widget functionality
	---***
	---@param t? checkboxSelectorCreationData Parameters are to be provided in this table
	---@param widget? selector Reference to an already existing selector to set up as a multiple selector instead of creating a new base widget
	---***
	---@return checkboxSelector|multiselector selector References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
	function wt.CreateCheckboxSelector(t, widget)
		t = t or {}

		---@class selectorCheckbox : selectorToggle, checkbox

		---@class checkboxSelector : multiselector
		---@field toggles? selectorCheckbox[] The list of checkbox widgets linked together in this selector
		local selector = widget and widget.isType and widget.isType("Multiselector") and widget or wt.CreateMultiselector(t)

		if WidgetToolsDB.lite and t.lite ~= false then return selector end

		--[ Frame Setup ]

		--| Shared setup

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Selector")
		local title = t.title or t.name or "Selector"

		setUpSelectorFrame(selector, t, name, title)

		--| Checkbox items

		---Update the lock state of a checkbox item
		---@param item selectorCheckbox
		---@param limited boolean
		local function setLock(item, limited)
			if limited then
				item.setEnabled(false, true)
				item.button:SetAlpha(0.4)
			elseif selector.isEnabled() then
				item.setEnabled(true, true)
				item.button:SetAlpha(1)
			end
		end

		---Set up or create new checkbox item
		---@param item selectorToggle|selectorCheckbox
		---@param active boolean
		local function setCheckbox(item, active)
			if active and not item.frame then
				local sameRow = (item.index - 1) % t.columns > 0

				wt.CreateClassicCheckbox({
					parent = selector.frame,
					name = findName(name, item.index),
					title = t.items[item.index].title,
					label = t.labels,
					tooltip = t.items[item.index].tooltip,
					position = {
						relativeTo = item.index ~= 1 and selector.toggles[sameRow and item.index - 1 or item.index - t.columns].frame or selector.label,
						relativePoint = sameRow and "TOPRIGHT" or "BOTTOMLEFT",
						offset = { x = selector.label and item.index == 1 and -4 or 0, y = selector.label and item.index == 1 and -2 or 0}
					},
					size = { w = (t.width and t.columns == 1) and t.width or 160, h = 16 },
					events = { OnClick = function(self) selector.setSelected(item.index, self:GetChecked(), true) end, },
					showDefault = false,
					utilityMenu = false,
				}, item)

				if item.label then item.label:SetIgnoreParentAlpha(true) end

				--Handle limit updates
				selector.setListener.limited(function(_, min, max)
					local state = item.getState()

					setLock(item, (min and state) or (max and not state))
				end, item.index)
			elseif active then
				--Update label
				if item.label then item.label:SetText(t.items[item.index].title) end

				--Update tooltip
				if t.items[item.index].tooltip and not item.frame.tooltipData then wt.AddTooltip(item.frame, {
					title = t.items[item.index].tooltip.title or t.title or t.name or "Toggle",
					lines = t.items[item.index].tooltip.lines,
					anchor = "ANCHOR_NONE",
					position = {
						anchor = "BOTTOMLEFT",
						relativeTo = item.button,
						relativePoint = "TOPRIGHT",
					},
				}, { triggers = { item.button, }, }) elseif item.frame.tooltipData then item.frame.tooltipData = t.items[item.index].tooltip end
			else wt.SetVisibility(item.frame, false) end
		end

		--Set up starting items
		for i = 1, #selector.toggles do
			setCheckbox(selector.toggles[i], true)

			--Handle item updates
			selector.toggles[i].setListener._("activated", function(self, active) setCheckbox(self, active) end)
		end

		--Handle item list updates
		selector.setListener.updated(function() selector.frame:SetHeight(math.ceil((#selector.toggles) / t.columns) * 16 + (t.label ~= false and 14 or 0)) end, 1)
		selector.setListener.added(function (_, toggle)
			setCheckbox(toggle, true)

			--Handle item updates
			toggle.setListener._("activated", function(self, active) setCheckbox(self, active) end)
		end)

		--[ Events ]

		--| Tooltip

		if t.tooltip then
			local defaultValue
			if t.showDefault ~= false then
				defaultValue = ""
				for i = 1, #t.items do
					defaultValue = defaultValue .. "\n" .. WrapTextInColorCode(t.items[i].title, "FFFFFFFF") .. WrapTextInColorCode(": ", "FF999999") .. WrapTextInColorCode(
						(t.default[i] and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED):lower(), t.default[i] and "FFAAAAFF" or "FFFFAA66"
					)
				end
			end

			wt.AddWidgetTooltipLines(t, defaultValue)
			wt.AddTooltip(selector.frame, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			})
		end

		--| Utility menu

		if t.utilityMenu ~= false then
			wt.CreateContextMenu({ parent = selector.frame, initialize = function(menu)
				wt.CreateMenuTextline(menu, { text = title })
				wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.revert, action = function() selector.revertData() end })
				if t.default then wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.restore, action = function() selector.resetData() end }) end
			end, condition = selector.isEnabled })
		end

		return selector
	end

	---Create a custom dropdown selector GUI frame to pick one out of multiple options with enhanced widget functionality
	---***
	---@param t? dropdownSelectorCreationData Parameters are to be provided in this table
	---@param widget? selector Reference to an already existing selector to set up as a radio selector instead of creating a new base widget
	---***
	---@return dropdownSelector|selector dropdown References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, a toggle [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table
	function wt.CreateDropdownSelector(t, widget)
		t = t or {}

		---@class dropdownSelector : radioSelector
		---@field list? panel Panel frame holding the dropdown selector widget
		local selector = widget and widget.isType and widget.isType("Selector") and widget or wt.CreateSelector(t)

		if WidgetToolsDB.lite and t.lite ~= false then return selector end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Drorpdown")

		selector.dropdown = CreateFrame("Frame", name, t.parent)

		--| Position & dimensions

		t.width = t.width or 160

		if t.arrange then selector.dropdown.arrangementInfo = t.arrange else wt.SetPosition(selector.dropdown, t.position) end

		selector.dropdown:SetSize(t.width, 36)

		--| Visibility

		wt.SetVisibility(selector.dropdown, t.visible ~= false)

		if t.frameStrata then selector.dropdown:SetFrameStrata(t.frameStrata) end
		if t.frameLevel then selector.dropdown:SetFrameLevel(t.frameLevel) end
		if t.keepOnTop then selector.dropdown:SetToplevel(t.keepOnTop) end

		--| Label

		local title = t.title or name or "Dropdown"

		selector.label = wt.AddTitle({
			parent = selector.dropdown,
			title = t.label ~= false and {
				offset = { x = 4, },
				text = title,
			} or nil,
		})

		--[ Dropdown List ]

		local open = false

		selector.list = wt.CreatePanel({
			parent = selector.dropdown,
			label = false,
			position = {
				anchor = "TOP",
				relativeTo = selector.dropdown,
				relativePoint = "BOTTOM",
			},
			visible = false,
			frameStrata = "DIALOG",
			keepInBound = true,
			background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
			border =  { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } },
			size = { w = t.width, h = 12 + #t.items * 16 },
			initialize = function(panel) wt.CreateRadioSelector({
				parent = panel,
				name = name,
				append = false,
				label = false,
				position = { anchor = "CENTER", },
				width = t.width - 12,
				items = t.items,
				clearable = t.clearable,
				listeners = t.listeners,
				dependencies = t.dependencies,
				getData = t.getData,
				saveData = t.saveData,
				default = t.default,
				instantSave = t.instantSave,
				dataManagement = t.dataManagement,
			}, selector) end,
		})

		--| Toggle button

		selector.toggle = wt.CreateCustomButton({
			parent = selector.dropdown,
			name = "Toggle",
			append = t.append,
			title = "…",
			tooltip = { lines = {
				{ text = ns.toolboxStrings.dropdown.selected, },
				{ text = "\n" .. ns.toolboxStrings.dropdown.open, },
			} },
			position = { anchor = "BOTTOM", },
			size = { w = t.width - (t.cycleButtons ~= false and 44 or 0), },
			font = {
				normal = "GameFontHighlightSmall",
				highlight = "GameFontHighlightSmall",
				disabled = "GameFontDisableSmall",
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
				OnEnter = { rule = function()
					return IsMouseButtonDown() and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
					} or (open and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					})
				end },
				OnLeave = { rule = function()
					if open then return {
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

					return (open and {
						background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					})
				end },
				OnAttributeChanged = { trigger = selector.dropdown, rule = function(_, attribute, state)
					if attribute ~= "open" then return {} end

					if selector.toggle.frame:IsMouseOver() then return state and {
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} or {
						background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
						border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
					} end
					return {}, true
				end },
			},
			events = { OnMouseUp = function(_, button, isInside)
				if t.clearable and button == "RightButton" and isInside and selector.toggle.frame:IsEnabled() then selector.setText(nil, true) end
			end, },
			dependencies = t.dependencies
		})

		--[ Cycle Buttons ]

		local previousDependencies, nextDependencies

		if t.cycleButtons ~= false then
			--Create a custom disabled font
			wt.CreateFont({
				name = "ChatFontSmallDisabled",
				template = "ChatFontSmall",
				color = wt.PackColor(GameFontDisable:GetTextColor()),
			})

			--| Previous item

			--Define the dependency rule
			previousDependencies = { { frame = selector, evaluate = function(value)
				if not value then return true end
				return value > 1
			end }, }

			selector.previous = wt.CreateCustomButton({
				parent = selector.dropdown,
				name = "SelectPrevious",
				title = "◄",
				titleOffset = { y = 0.5 },
				tooltip = {
					title = ns.toolboxStrings.dropdown.previous.label,
					lines = { { text = ns.toolboxStrings.dropdown.previous.tooltip, }, }
				},
				position = { anchor = "BOTTOMLEFT", },
				size = { w = 22, },
				font = {
					normal = "ChatFontSmall",
					highlight = "ChatFontSmall",
					disabled = "ChatFontSmallDisabled",
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
				backdropUpdates = {
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
				},
				action = function()
					local selected = selector.getSelected()

					selector.setSelected(selected and selected - 1 or #selector.toggles, true)
				end,
				dependencies = previousDependencies
			})

			--| Next item

			--Define the dependency rule
			nextDependencies = { { frame = selector, evaluate = function(value)
				if not value then return true end
				return value < #t.items
			end }, }

			selector.next = wt.CreateCustomButton({
				parent = selector.dropdown,
				name = "SelectNext",
				title = "►",
				titleOffset = { x = 2, y = 0.5 },
				tooltip = {
					title = ns.toolboxStrings.dropdown.next.label,
					lines = { { text = ns.toolboxStrings.dropdown.next.tooltip, }, }
				},
				position = { anchor = "BOTTOMRIGHT", },
				size = { w = 22, },
				font = {
					normal = "ChatFontSmall",
					highlight = "ChatFontSmall",
					disabled = "ChatFontSmallDisabled",
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
				backdropUpdates = {
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
				},
				action = function()
					local selected = selector.getSelected()

					selector.setSelected(selected and selected + 1 or 1, true)
				end,
				dependencies = nextDependencies
			})
		end

		--[ Getters & Setters ]

		---Set the text displayed on the label of the toggle button
		---***
		---@param text? string ***Default:*** **t.items[*index*].title** *(the title of the currently selected item)* or "…" *(if there is no selection)*
		---@param silent? boolean If false, invoke a "labeled" event and call registered listeners | ***Default:*** false
		function selector.setText(text, silent)
			local index = selector.getSelected()
			local item = t.items[index] or {}
			text = type(text) == "string" and text or item.title or "…"
			local tooltip = wt.Clone(item.tooltip) or {}

			table.insert(wt.AddMissing(tooltip, {
				title = text,
				lines = { { text = index and ns.toolboxStrings.dropdown.selected or ns.toolboxStrings.dropdown.none, }, }
			}).lines, { text = "\n" .. ns.toolboxStrings.dropdown.open, })

			selector.toggle.label:SetText(text)
			selector.toggle.setTooltip(tooltip)

			if not silent then selector.invoke._("labeled", text) end
		end

		---Toggle the dropdown menu
		---@param state? boolean ***Default:*** not **selector.list:IsVisible()**
		function selector.toggleMenu(state)
			if state == nil then open = not selector.list:IsVisible() else open = state end

			wt.SetVisibility(selector.list, open)

			if open then selector.list:RegisterEvent("GLOBAL_MOUSE_DOWN") else selector.list:UnregisterEvent("GLOBAL_MOUSE_UP") end

			selector.invoke._("open", open)
		end

		--[ Events ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "attribute" then selector.dropdown:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
			else selector.dropdown:HookScript(key, value) end
		end end

		--Pass global events to handlers
		selector.list:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)

		--| UX

		function selector.list:GLOBAL_MOUSE_DOWN()
			if selector.toggle.frame:IsMouseOver() then return end

			selector.list:UnregisterEvent("GLOBAL_MOUSE_DOWN")
			selector.list:RegisterEvent("GLOBAL_MOUSE_UP")
		end

		function selector.list:GLOBAL_MOUSE_UP(button)
			if (button ~= "LeftButton" and button ~= "RightButton") or selector.list:IsMouseOver() then return end

			selector.toggleMenu(false)
		end

		--Handle widget updates
		selector.toggle.setListener.trigger(function() selector.toggleMenu() end)
		selector.setListener.selected(function()
			selector.setText()

			if t.autoClose then selector.toggleMenu(false) end
		end, 1)
		selector.setListener._("open", function(state) if not state then PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF) end end)
		selector.setListener.updated(function(self) self.list:SetHeight(#self.toggles * 16 + 12) end, 1)

		--| Tooltip

		if t.tooltip then
			local defaultValue
			if t.showDefault ~= false then defaultValue = WrapTextInColorCode(t.default and t.items[t.default].title or tostring(t.default), "FFFFFFFF") end

			wt.AddWidgetTooltipLines(t, defaultValue)
			wt.AddTooltip(selector.dropdown, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			})
		end

		--| Utility menu

		if t.utilityMenu ~= false then
			wt.CreateContextMenu({ parent = selector.dropdown, initialize = function(menu)
				wt.CreateMenuTextline(menu, { text = title })
				wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.revert, action = function() selector.revertData() end })
				if t.default then wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.restore, action = function() selector.resetData() end }) end
			end, condition = selector.isEnabled })
		end

		--| State

		---Update the widget UI based on its enabled state
		---@param _ dropdownSelector
		---@param state boolean
		local function updateState(_, state)
			if selector.label then selector.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

			selector.toggle.setEnabled(state)

			if t.cycleButtons ~= false then
				selector.previous.setEnabled(state and wt.CheckDependencies(previousDependencies))
				selector.next.setEnabled(state and wt.CheckDependencies(nextDependencies))
			end

			selector.list:Hide()
		end

		selector.setListener.enabled(updateState, 1)

		--[ Initialization ]

		--Set up starting state
		updateState(nil, selector.isEnabled())

		--Set up starting selection
		selector.setText(t.defaultText)

		return selector
	end

	--[ Textbox ]

	---Create a non-GUI textbox widget with data management logic
	---***
	---@param t? textboxCreationData Parameters are to be provided in this table
	---***
	---@return textbox textbox Reference to the new textbox widget, utility functions and more wrapped in a table
	function wt.CreateTextbox(t)
		t = t or {}

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

		---Returns the object type of this widget
		---***
		---@return "Textbox" string
		---<hr><p></p>
		function textbox.getType() return "Textbox" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string|WidgetTypeName
		---@return boolean
		function textbox.isType(type) return type == "Textbox" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function textbox.getProperty(key) return wt.FindValueByKey(t, key) end

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

		---Read the data from storage via **t.getData()** then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** false
		function textbox.loadData(handleChanges, silent)
			handleChanges = handleChanges ~= false

			if type(t.getData) == "function" then
				textbox.setText(t.getData(), handleChanges, silent)

				if not silent then textbox.invoke.loaded(true) end
			else
				--Handle changes
				if handleChanges and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
					for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
				end

				if not silent then textbox.invoke.loaded(false) end
			end
		end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param text? string Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** false
		function textbox.saveData(text, silent)
			if type(t.saveData) == "function" then
				t.saveData(type(text) == "string" and text or value)

				if not silent then textbox.invoke.saved(true) end
			elseif not silent then textbox.invoke.saved(false) end
		end

		---Get the currently stored data via **t.getData()**
		---@return string|nil
		function textbox.getData() return type(t.getData) == "function" and t.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param text? string Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function textbox.setData(text, handleChanges, silent)
			textbox.saveData(text, silent)
			textbox.loadData(handleChanges, silent)
		end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **textbox.revertData()**
		function textbox.snapshotData() snapshot = textbox.getData() end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **textbox.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function textbox.revertData(handleChanges, silent) textbox.setData(snapshot, handleChanges, silent) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function textbox.resetData(handleChanges, silent) textbox.setData(default, handleChanges, silent) end

		---Returns the current text value of the widget
		---@return string
		function textbox.getText() return value end

		---Set the text value of the widget
		---***
		---@param text? string ***Default:*** ""
		---@param user? boolean If true, mark the change as being initiated via a user interaction and call change handlers | ***Default:*** false
		---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** false
		function textbox.setText(text, user, silent)
			value = type(text) == "string" and text or ""

			if not silent then textbox.invoke.changed(user == true) end

			if user and t.instantSave ~= false then textbox.saveData(nil, silent) end

			--Handle changes
			if user and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
				for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
			end
		end

		--| State & dependencies

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function textbox.isEnabled() return enabled end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** true
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** false
		function textbox.setEnabled(state, silent)
			enabled = state ~= false

			if not silent then textbox.invoke.enabled() end
		end

		--[ Initialization ]

		--Register event handlers
		if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
			if k == "_" then textbox.setListener._(v[i].event, v[i].handler, v[i].callIndex) else textbox.setListener[k](v[i].handler, v[i].callIndex) end
		end end end end

		--Register to options data management
		if t.dataManagement then wt.AddOptionsRule(textbox, t.dataManagement) end

		--Assign dependencies
		if t.dependencies then wt.AddDependencies(t.dependencies, textbox.setEnabled) end

		--Set starting value
		textbox.setText(t.color and wt.Color(value, t.color) or value)

		return textbox
	end

	--| GUI

	---Set the parameters of a GUI textbox widget frame
	---@param textbox singleLineEditbox|customSingleLineEditbox|multilineEditbox
	---@param t editboxCreationData
	local function setUpEditboxFrame(textbox, t)

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

		if t.charLimit then textbox.editbox:SetMaxLetters(t.charLimit) end

		--[ Events ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "attribute" then textbox.editbox:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
			elseif key == "OnChar" then textbox.editbox:SetScript("OnChar", function(self, char) value(self, char, self:GetText()) end)
			elseif key == "OnTextChanged" then textbox.editbox:SetScript("OnTextChanged", function(self, user) value(self, self:GetText(), user) end)
			elseif key == "OnEnterPressed" then textbox.editbox:SetScript("OnEnterPressed", function(self) value(self, self:GetText()) end)
			else textbox.editbox:HookScript(key, value) end
		end end

		--| UX

		local scriptEvent = false

		---Update the widget UI based on the text value
		---@param _ toggle
		---@param text string
		local function updateText(_, text) if not scriptEvent then
			textbox.editbox:SetText(text)

			if t.resetCursor ~= false then textbox.editbox:SetCursorPosition(0) end
		else scriptEvent = false end end

		--Handle widget updates
		textbox.setListener.changed(updateText, 1)

		--Link value changes
		textbox.editbox:HookScript("OnTextChanged", function(self, user)
			scriptEvent = true

			textbox.setText(self:GetText(), user)
		end)

		textbox.editbox:SetAutoFocus(t.keepFocused)

		if t.focusOnShow then textbox.editbox:HookScript("OnShow", function(self) self:SetFocus() end) end

		if t.unfocusOnEnter ~= false then textbox.editbox:HookScript("OnEnterPressed", function(self)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

			self:ClearFocus()
		end) end

		textbox.editbox:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)

		--| State

		--Inherit setter
		textbox.editbox.setEnabled = textbox.setEnabled

		---Update the widget UI based on its enabled state
		---@param _ textbox
		---@param state boolean
		local function updateState(_, state)
			if t.readOnly then textbox.editbox:Disable() else textbox.editbox:SetEnabled(state) end

			if state then if t.font.normal then textbox.editbox:SetFontObject(t.font.normal) end elseif t.font.disabled then textbox.editbox:SetFontObject(t.font.disabled) end

			if textbox.label then textbox.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end
		end

		--Handle widget updates
		textbox.setListener.enabled(updateState, 1)

		--[ Initialization ]

		--Set up starting state
		updateState(nil, textbox.isEnabled())

		--Set up starting text
		updateText(nil, textbox.getText())
	end

	---Set the parameters of a single-line GUI textbox widget frame
	---@param textbox singleLineEditbox|customSingleLineEditbox
	---@param t editboxCreationData
	local function setUpSingleLineEditbox(textbox, t)

		--Set as single line
		textbox.editbox:SetMultiLine(false)

		--| Position

		if t.arrange then textbox.frame.arrangementInfo = t.arrange else wt.SetPosition(textbox.frame, t.position) end
		textbox.editbox:SetPoint("BOTTOMRIGHT")

		--| Label

		local title = t.title or t.name or "Text Box"

		textbox.label = wt.AddTitle({
			parent = textbox.frame,
			title = t.label ~= false and {
				offset = { x = -1, },
				text = title,
			} or nil,
		})

		--| Shared setup

		setUpEditboxFrame(textbox, t)

		--[ Events ]

		--| Tooltip

		if t.tooltip then
			local defaultValue
			if t.showDefault ~= false then defaultValue = WrapTextInColorCode(t.default, "FF55DD55") end

			wt.AddWidgetTooltipLines(t, defaultValue)
			wt.AddTooltip(textbox.editbox, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			})
		end

		--| Utility menu

		if t.utilityMenu ~= false then
			wt.CreateContextMenu({ parent = textbox.editbox, initialize = function(menu)
				wt.CreateMenuTextline(menu, { text = title })
				wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.revert, action = function() textbox.revertData() end })
				if t.default then wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.restore, action = function() textbox.resetData() end }) end
			end, condition = function() return textbox.isEnabled() and not t.readOnly end })
		end
	end

	---Create a default single-line Blizzard editbox GUI frame with enhanced widget functionality
	---***
	---@param t? editboxCreationData Parameters are to be provided in this table
	---@param widget? selector Reference to an already existing selector to set up as a radio selector instead of creating a new base widget
	---***
	---@return singleLineEditbox|textbox textbox Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
	function wt.CreateEditbox(t, widget)
		t = t or {}

		---@class singleLineEditbox : textbox
		local textbox = widget and widget.isType and widget.isType("Textbox") and widget or wt.CreateTextbox(t)

		if WidgetToolsDB.lite and t.lite ~= false then return textbox end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Textbox")
		local custom = t.customizable and (BackdropTemplateMixin and "BackdropTemplate") or nil

		textbox.frame = CreateFrame("Frame", name, t.parent)
		textbox.editbox = CreateFrame("EditBox", name .. "EditBox", textbox.frame, custom or "InputBoxTemplate")

		--| Dimensions

		t.size = t.size or {}
		t.size.w = t.size.w or 180
		t.size.h = t.size.h or 18

		textbox.frame:SetSize(t.size.w, t.size.h + (t.label ~= false and 18 or 0))
		textbox.editbox:SetSize(t.size.w - 6, t.size.h - 1)

		--| Shared setup

		setUpSingleLineEditbox(textbox, t)

		return textbox
	end

	---Create a single-line Blizzard editbox frame with custom GUI and enhanced widget functionality
	---***
	---@param t? customEditboxCreationData Parameters are to be provided in this table
	---@param widget? selector Reference to an already existing selector to set up as a radio selector instead of creating a new base widget
	---***
	---@return customSingleLineEditbox|textbox textbox Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
	function wt.CreateCustomEditbox(t, widget)
		t = t or {}

		---@class customSingleLineEditbox : textbox
		local textbox = widget and widget.isType and widget.isType("Textbox") and widget or wt.CreateTextbox(t)

		if WidgetToolsDB.lite and t.lite ~= false then return textbox end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Textbox")

		textbox.frame = CreateFrame("Frame", name, t.parent)
		textbox.editbox = CreateFrame("EditBox", name .. "EditBox", textbox.frame, BackdropTemplateMixin and "BackdropTemplate")

		--| Dimensions

		t.size = t.size or {}
		t.size.w = t.size.w or 180
		t.size.h = t.size.h or 18

		textbox.frame:SetSize(t.size.w, t.size.h - (t.label ~= false and -18 or 0))
		textbox.editbox:SetSize(t.size.w, t.size.h)

		--| Backdrop

		wt.SetBackdrop(textbox.editbox, t.backdrop, t.backdropUpdates)

		--| Shared setup

		setUpSingleLineEditbox(textbox, t)

		--[ Events ]

		--| UX

		textbox.editbox:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
		textbox.editbox:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)

		return textbox
	end

	---Create a default multiline Blizzard editbox GUI frame with enhanced widget functionality
	---***
	---@param t? multilineEditboxCreationData Parameters are to be provided in this table
	---***
	---@return multilineEditbox|textbox textbox Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
	function wt.CreateMultilineEditbox(t, widget)
		t = t or {}

		---@class multilineEditbox : textbox
		local textbox = widget and widget.isType and widget.isType("Textbox") and widget or wt.CreateTextbox(t)

		if WidgetToolsDB.lite and t.lite ~= false then return textbox end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Textbox")

		textbox.frame = CreateFrame("Frame", name, t.parent)
		textbox.scrollFrame = CreateFrame("ScrollFrame", name .. "ScrollFrame", textbox.frame, ScrollControllerMixin and "InputScrollFrameTemplate")

		---@type EditBox|nil
		textbox.editbox = textbox.scrollFrame.EditBox

		--Set as multiline
		textbox.editbox:SetMultiLine(true)

		--| Position & dimensions

		local scrollFrameHeight = t.size.h - (t.label ~= false and 24 or 10)

		if t.arrange then textbox.frame.arrangementInfo = t.arrange else wt.SetPosition(textbox.frame, t.position) end
		textbox.scrollFrame:SetPoint("BOTTOM", 0, 5)
		wt.SetPosition(textbox.scrollFrame.ScrollBar, {
			anchor = "RIGHT",
			relativeTo = textbox.scrollFrame,
			relativePoint = "RIGHT",
			offset = { x = -4, y = 0 }
		})

		textbox.frame:SetSize(t.size.w, t.size.h)
		textbox.scrollFrame:SetSize(t.size.w - 10, scrollFrameHeight)
		textbox.scrollFrame.ScrollBar:SetHeight(scrollFrameHeight - 4)

		--| Label

		local title = t.title or t.name or "Text Box"

		textbox.label = wt.AddTitle({
			parent = textbox.frame,
			title = t.label ~= false and {
				offset = { x = 3, },
				text = title,
			} or nil,
		})

		--| Scroll speed

		t.scrollSpeed = t.scrollSpeed or 0.25

		textbox.scrollFrame.ScrollBar.SetPanExtentPercentage = function() --WATCH: Change when Blizzard provides a better way to overriding the built-in update function
			local height = textbox.scrollFrame:GetHeight()

			textbox.scrollFrame.ScrollBar.panExtentPercentage = height * t.scrollSpeed / math.abs(textbox.editbox:GetHeight() - height)
		end

		--| Character counter

		textbox.scrollFrame.CharCount:SetFontObject("GameFontDisableTiny2")
		if t.charCount == false or (t.charLimit or 0) == 0 then textbox.scrollFrame.CharCount:Hide() end

		textbox.editbox.cursorOffset = 0 --WATCH: Remove when the character counter gets fixed..

		--| Shared setup

		setUpEditboxFrame(textbox, t)

		--[ Events ]

		--| UX

		textbox.editbox:HookScript("OnTextChanged", function(_, _, user) if not user and t.scrollToTop then textbox.scrollFrame:SetVerticalScroll(0) end end)
		textbox.editbox:HookScript("OnEditFocusGained", function(self) self:HighlightText() end)
		textbox.editbox:HookScript("OnEditFocusLost", function(self) self:ClearHighlightText() end)

		---Update the width of the editbox
		---@param scrolling boolean
		local function resizeEditbox(scrolling)
			local scrollBarOffset = scrolling and (wt.classic and 32 or 16) or 0
			local charCountWidth = t.charCount ~= false and (t.charLimit or 0) > 0 and tostring(t.charLimit - textbox.getText():len()):len() * 6 + 3 or 0

			textbox.editbox:SetWidth(textbox.scrollFrame:GetWidth() - scrollBarOffset - charCountWidth)

			--Update the character counter
			if textbox.scrollFrame.CharCount:IsVisible() and t.charLimit then --WATCH: Remove when the character counter gets fixed..
				textbox.scrollFrame.CharCount:SetWidth(charCountWidth)
				textbox.scrollFrame.CharCount:SetText(t.charLimit - textbox.getText():len())
				textbox.scrollFrame.CharCount:SetPoint("BOTTOMRIGHT", textbox.scrollFrame, "BOTTOMRIGHT", -scrollBarOffset + 1, 0)
			end
		end

		--Resize updates
		textbox.scrollFrame.ScrollBar:HookScript("OnShow", function() resizeEditbox(true) end)
		textbox.scrollFrame.ScrollBar:HookScript("OnHide", function() resizeEditbox(false) end)

		--| Tooltip

		if t.tooltip then
			if t.readOnly ~= true then
				local defaultValue
				if t.showDefault ~= false then defaultValue = WrapTextInColorCode(t.default, "FF55DD55") end

				wt.AddWidgetTooltipLines(t, defaultValue)
			end

			wt.AddTooltip(textbox.scrollFrame, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			}, { triggers = { textbox.frame, textbox.editbox }, })
		end

		--| Utility menu

		if t.utilityMenu ~= false then
			wt.CreateContextMenu({ parent = textbox.frame, initialize = function(menu)
				wt.CreateMenuTextline(menu, { text = title })
				wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.revert, action = function() textbox.revertData() end })
				if t.default then wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.restore, action = function() textbox.resetData() end }) end
			end, condition = function() return textbox.isEnabled() and not t.readOnly end })
		end

		return textbox
	end

	---Create a custom button with a toggled textline & editbox from which text can be copied
	---***
	---@param t? copyboxCreationData Parameters are to be provided in this table
	---***
	---@return copybox copybox References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), its child widgets & their custom values, utility functions and more wrapped in a table
	function wt.CreateCopybox(t)
		t = t or {}
		t.value = t.value or ""

		---@class copybox
		local copybox = {}

		--[ GUI Widget ]

		if not WidgetToolsDB.lite or t.lite == false then

			--[ Frame Setup ]

			local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Copybox")

			copybox.frame = CreateFrame("Frame", name, t.parent)

			--| Position & dimensions

			t.size = t.size or {}
			t.size.w = t.size.w or 180
			t.size.h = t.size.h or 18

			if t.arrange then copybox.frame.arrangementInfo = t.arrange else wt.SetPosition(copybox.frame, t.position) end

			copybox.frame:SetSize(t.size.w, t.size.h + (t.label ~= false and 12 or 0))

			--| Visibility

			wt.SetVisibility(copybox.frame, t.visible ~= false)

			if t.frameStrata then copybox.frame:SetFrameStrata(t.frameStrata) end
			if t.frameLevel then copybox.frame:SetFrameLevel(t.frameLevel) end
			if t.keepOnTop then copybox.frame:SetToplevel(t.keepOnTop) end

			--| Label

			local title = t.title or t.name or "Copybox"

			copybox.label = wt.AddTitle({
				parent = copybox.frame,
				title = t.label ~= false and {
					offset = { x = -1, },
					width = t.size.w,
					text = title,
				} or nil,
			})

			--| Textbox

			t.font = t.font or "GameFontNormalSmall"
			t.color = t.color or { r = 0.6, g = 0.8, b = 1, a = 1 }
			t.colorOnMouse = t.colorOnMouse or { r = 0.8, g = 0.95, b = 1, a = 1 }

			copybox.textbox = wt.CreateCustomEditbox({
				parent = copybox.frame,
				name = "Textline",
				title = title,
				label = false,
				tooltip = { lines = { { text = ns.toolboxStrings.copyBox, }, } },
				position = { anchor = "BOTTOMLEFT", },
				size = t.size,
				font = { normal = t.font, disabled = t.font },
				color = t.color,
				justify = { h = t.justify, },
				events = {
					OnTextChanged = function(self, _, user)
						if not user then return end

						self:SetText(wt.Color(t.value, t.colorOnMouse))
						self:SetCursorPosition(0)
						self:HighlightText()
					end,
					OnEnter = function(self)
						self:SetText(wt.Color(t.value, t.colorOnMouse))
						self:SetCursorPosition(0)
						self:HighlightText()
						self:SetFocus()
					end,
					OnLeave = function(self)
						self:SetText(wt.Color(t.value, t.color))
						self:SetCursorPosition(0)
						self:ClearHighlightText()
						self:ClearFocus()
					end,
					OnMouseUp = function(self)
						self:SetCursorPosition(0)
						self:HighlightText()
					end,
				},
				value = t.value,
				showDefault = false,
				utilityMenu = false,
			})
		end

		return copybox
	end

	--[ Numeric ]

	---Create a non-GUI numeric widget with data management logic
	---***
	---@param t? numericCreationData Parameters are to be provided in this table
	---***
	---@return numeric numeric Reference to the new numeric widget, utility functions and more wrapped in a table
	function wt.CreateNumeric(t)
		t = t or {}

		--[ Wrapper table ]

		---@class numeric
		local numeric = {}

		--[ Properties ]

		--| Data

		local limitMin = t.min or 0
		local limitMax = t.max or 100
		t.step = t.step or t.increment or ((limitMin - limitMax) / 10)
		local default = limitMin

		---Data verification utility
		---@param v any
		---@return number|nil
		local function verify(v)
			v = Clamp(type(v) == "number" and v or default, limitMin, limitMax)

			return v
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

		---Returns the object type of this widget
		---***
		---@return "Numeric" string
		---<hr><p></p>
		function numeric.getType() return "Numeric" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string|WidgetTypeName
		---@return boolean
		function numeric.isType(type) return type == "Numeric" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function numeric.getProperty(key) return wt.FindValueByKey(t, key) end

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

		---Read the data from storage via **t.getData()** then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** false
		function numeric.loadData(handleChanges, silent)
			handleChanges = handleChanges ~= false

			if type(t.getData) == "function" then
				numeric.setNumber(t.getData(), handleChanges, silent)

				if not silent then numeric.invoke.loaded(true) end
			else
				--Handle changes
				if handleChanges and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
					for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
				end

				if not silent then numeric.invoke.loaded(false) end
			end
		end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param number? number Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** false
		function numeric.saveData(number, silent)
			if type(t.saveData) == "function" then
				t.saveData(number and verify(number) or value)

				if not silent then numeric.invoke.saved(true) end
			elseif not silent then numeric.invoke.saved(false) end
		end

		---Get the currently stored data via **t.getData()**
		---@return number|nil
		function numeric.getData() return type(t.getData) == "function" and t.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param number? number Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function numeric.setData(number, handleChanges, silent)
			numeric.saveData(number, silent)
			numeric.loadData(handleChanges, silent)
		end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **numeric.revertData()**
		function numeric.snapshotData() snapshot = numeric.getData() end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **numeric.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function numeric.revertData(handleChanges, silent) numeric.setData(snapshot, handleChanges, silent) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function numeric.resetData(handleChanges, silent) numeric.setData(default, handleChanges, silent) end

		---Returns the current value of the widget
		---@return number
		function numeric.getNumber() return value end

		---Set the value of the widget
		---***
		---@param number? number A valid number value within the specified **t.min**, **t.max** range | ***Default:*** **t.min**
		function numeric.setNumber(number, user, silent)
			value = verify(number)

			if not silent then numeric.invoke.changed(user == true) end

			if user and t.instantSave ~= false then numeric.saveData(nil, silent) end

			--Handle changes
			if user and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
				for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
			end
		end

		---Decrease the value of the widget by the specified **t.step** or **t.altStep** amount
		---@param alt? boolean If true, use **t.altStep** instead of **t.step** to decrease the value by | ***Default:*** false
		---@param user? boolean If true, mark the change as being initiated via a user interaction and call change handlers | ***Default:*** false
		---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** false
		function numeric.decrease(alt, user, silent) numeric.setNumber(value - (alt and t.altStep or t.step), user, silent) end

		---Increase the value of the widget by the specified **t.step** or **t.altStep** amount
		---@param alt? boolean If true, use **t.altStep** instead of **t.step** to increase the value by | ***Default:*** false
		---@param user? boolean If true, mark the change as being initiated via a user interaction and call change handlers | ***Default:*** false
		---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** false
		function numeric.increase(alt, user, silent) numeric.setNumber(value + (alt and t.altStep or t.step), user, silent) end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function numeric.isEnabled() return enabled end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** true
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** false
		function numeric.setEnabled(state, silent)
			enabled = state ~= false

			if not silent then numeric.invoke.enabled() end
		end

		--| Value limits

		---Set the lower value limit of the widget
		---***
		---@param number number Updates the lower limit value | ***Range:*** (any, *current upper limit*) *capped automatically*
		---@param silent? boolean If false, invoke a "min" event and call registered listeners | ***Default:*** false
		function numeric.setMin(number, silent)
			limitMin = min(number, limitMax)

			if not silent then numeric.invoke.min() end
		end

		function numeric.getMin() return limitMin end

		---Set the upper value limit of the widget
		---***
		---@param number number Updates the upper limit value | ***Range:*** (*current lower limit*, any) *floored automatically*
		---@param silent? boolean If false, invoke a "max" event and call registered listeners | ***Default:*** false
		function numeric.setMax(number, silent)
			limitMax = max(limitMin, number)

			if not silent then numeric.invoke.max() end
		end

		function numeric.getMax() return limitMax end

		--[ Initialization ]

		--Register event handlers
		if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
			if k == "_" then numeric.setListener._(v[i].event, v[i].handler, v[i].callIndex) else numeric.setListener[k](v[i].handler, v[i].callIndex) end
		end end end end

		--Register to options data management
		if t.dataManagement then wt.AddOptionsRule(numeric, t.dataManagement) end

		--Assign dependencies
		if t.dependencies then wt.AddDependencies(t.dependencies, numeric.setEnabled) end

		--Set starting value
		numeric.setNumber(value, false, true)

		return numeric
	end

	--| GUI

	---Create a default Blizzard slider GUI frame with enhanced widget functionality
	---***
	---@param t? numericSliderCreationData Parameters are to be provided in this table
	---@param widget? numeric Reference to an already existing numeric widget to set up as a slider instead of creating a new base widget
	---***
	---@return numericSlider|numeric numeric References to the new [Slider](https://warcraft.wiki.gg/wiki/UIOBJECT_Slider), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), child widgets, utility functions and more wrapped in a table
	function wt.CreateNumericSlider(t, widget)
		t = t or {}

		---@class numericSlider : numeric
		local numeric = widget and widget.isType and widget.isType("Numeric") and widget or wt.CreateNumeric(t)

		if WidgetToolsDB.lite and t.lite ~= false then return numeric end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "Slider")

		numeric.frame = CreateFrame("Frame", name, t.parent)
		numeric.slider = CreateFrame("Slider", name .. "Frame", numeric.frame, "OptionsSliderTemplate")
		numeric.slider.min = _G[name .. "FrameLow"]
		numeric.slider.max = _G[name .. "FrameHigh"]

		--| Position & dimensions

		t.width = t.width or 160

		if t.arrange then numeric.frame.arrangementInfo = t.arrange else wt.SetPosition(numeric.frame, t.position) end
		numeric.slider:SetPoint("TOP", 0, -15)
		numeric.slider.min:SetPoint("TOPLEFT", numeric.slider, "BOTTOMLEFT")
		numeric.slider.max:SetPoint("TOPRIGHT", numeric.slider, "BOTTOMRIGHT")

		numeric.frame:SetSize(t.width, t.valueBox ~= false and 48 or 31)
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

		--| Value step

		if t.increment then
			numeric.slider:SetValueStep(t.increment)
			numeric.slider:SetObeyStepOnDrag(true)
		end

		--| Value box

		local _min, _max = numeric.getMin(), numeric.getMax()

		if t.valueBox ~= false then
			--Calculate the required number of fractal digits, assemble string patterns for value validation
			local decimals = t.fractional or max(
				tostring(_min):gsub("-?[%d]+[%.]?([%d]*).*", "%1"):len(),
				tostring(_max):gsub("-?[%d]+[%.]?([%d]*).*", "%1"):len(),
				tostring(t.step or 0):gsub("-?[%d]+[%.]?([%d]*).*", "%1"):len()
			)
			local decimalPattern = ""
			for _ = 1, decimals do decimalPattern = decimalPattern .. "[%d]?" end
			local matchPattern = "(" .. (_min < 0 and "-?" or "") .. "[%d]*)" .. (decimals > 0 and "([%.]?" .. decimalPattern .. ")" or "") .. ".*"
			local replacePattern = "%1" .. (decimals > 0 and "%2" or "")

			numeric.valueBox = wt.CreateCustomEditbox({
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
				font = {
					normal = "GameFontHighlightSmall",
					disabled = "GameFontDisableSmall",
				},
				justify = { h = "CENTER", },
				charLimit = max(tostring(math.floor(t.step)):len(), tostring(math.floor(_min)):len(), tostring(math.floor(_max)):len()) + (decimals > 0 and decimals + 1 or 0),
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
				backdropUpdates = {
					OnEnter = { rule = function(self) return self:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end },
					OnLeave = {},
				},
				events = {
					OnChar = function(self, _, text) self:SetText(text:gsub(matchPattern, replacePattern)) end,
					OnEnterPressed = function(self)
						local v = self:GetNumber()
						if t.increment then v = max(numeric.getMin(), min(floor(v * (1 / t.increment) + 0.5) / (1 / t.increment)), numeric.getMax()) end

						numeric.setNumber(v, true)
					end,
					OnEscapePressed = function(self) self.setText(tostring(wt.Round(numeric.slider:GetValue(), decimals)):gsub(matchPattern, replacePattern)) end,
				},
				value = tostring(numeric.getNumber()):gsub(matchPattern, replacePattern),
				showDefault = false,
				utilityMenu = false,
			})

			--Handle widget updates
			numeric.setListener.changed(function(_, number) numeric.valueBox.setText(tostring(wt.Round(number, decimals)):gsub(matchPattern, replacePattern)) end)
		end

		--| Side buttons

		if t.sideButtons ~= false then

			--| Decrease

			numeric.decreaseButton = wt.CreateCustomButton({
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
				backdropUpdates = {
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
				},
				action = function() numeric.decrease(IsAltKeyDown(), true) end,
				dependencies = { { frame = numeric.slider, evaluate = function(value) return value > numeric.getMin() end }, }
			})

			--| Increase

			numeric.increaseButton = wt.CreateCustomButton({
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
				backdropUpdates = {
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
				},
				action = function() numeric.increase(IsAltKeyDown(), true) end,
				dependencies = { { frame = numeric.slider, evaluate = function(value) return value < numeric.getMax() end }, }
			})
		end

		--[ Events ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "attribute" then numeric.slider:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
			else numeric.slider:HookScript(key, value) end
		end end

		--| UX

		local scriptEvent = false

		---Update the widget UI based on the number value
		---***
		---@param _ numeric
		---@param number number
		---@param user? boolean ***Default:*** false
		local function updateNumber(_, number, user) if not scriptEvent then numeric.slider:SetValue(number, user) else scriptEvent = false end end

		---Update the min/max limits of the slider
		---@param limitMin? number
		---@param limitMax? number
		local function updateLimits(limitMin, limitMax)
			if limitMin then numeric.slider.min:SetText(tostring(limitMin)) else limitMin = numeric.getMin() end
			if limitMax then numeric.slider.max:SetText(tostring(limitMax)) else limitMax = numeric.getMax() end

			numeric.slider:SetMinMaxValues(limitMin, limitMax)
		end

		--Handle widget updates
		numeric.setListener.changed(updateNumber, 1)
		numeric.setListener.min(function(_, limitMin) updateLimits(limitMin) end, 1)
		numeric.setListener.max(function(_, limitMax) updateLimits(nil, limitMax) end, 1)

		--Link value changes
		numeric.slider:HookScript("OnValueChanged", function(_, number, user)
			scriptEvent = true

			numeric.setNumber(number, user)

			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end)

		--| Tooltip

		if t.tooltip then
			if t.readOnly ~= true then
				local defaultValue
				if t.showDefault ~= false then defaultValue = WrapTextInColorCode(tostring(t.default), "FFDDDD55") end

				wt.AddWidgetTooltipLines(t, defaultValue)
			end

			wt.AddTooltip(numeric.slider, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			}, { triggers = { numeric.frame } })
		end

		--| Utility menu

		if t.utilityMenu ~= false then
			wt.CreateContextMenu({ parent = numeric.frame, initialize = function(menu)
				wt.CreateMenuTextline(menu, { text = title })
				wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.revert, action = function() numeric.revertData() end })
				if t.default then wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.restore, action = function() numeric.resetData() end }) end
			end, condition = numeric.isEnabled })
		end

		--| State

		---Update the widget UI based on its enabled state
		---@param _ numeric
		---@param state boolean
		local function updateState(_, state)
			numeric.slider:SetEnabled(state)

			if numeric.label then numeric.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

			if t.valueBox ~= false then numeric.valueBox.setEnabled(state) end

			if t.sideButtons ~= false then
				numeric.decreaseButton.setEnabled(state and wt.CheckDependencies({ { frame = numeric.slider, evaluate = function(value) return value > numeric.getMin() end }, }))
				numeric.increaseButton.setEnabled(state and wt.CheckDependencies({ { frame = numeric.slider, evaluate = function(value) return value < numeric.getMax() end }, }))
			end
		end

		numeric.setListener.enabled(updateState, 1)

		--[ Initialization ]

		--Set up starting state
		updateState(nil, numeric.isEnabled())

		--Set up the limits
		updateLimits(_min, _max)

		--Set up slider value
		updateNumber(nil, numeric.getNumber(), false)

		return numeric
	end

	--[ Color Picker ]

	---Create a non-GUI color picker widget with data management logic
	---***
	---@param t? colorPickerCreationData Parameters are to be provided in this table
	---***
	---@return colorPicker colorPicker Reference to the new color picker widget, utility functions and more wrapped in a table
	function wt.CreateColorPicker(t)
		t = t or {}

		--[ Wrapper table ]

		---@class colorPicker
		local colorPicker = {}

		--[ Properties ]

		local active = false

		--| Data

		local default = wt.PackColor(wt.UnpackColor(t.default))
		wt.CopyValues(wt.AddMissing(wt.RemoveMismatch(wt.RemoveEmpty(t.default), default), default), default)
		local value = t.value or type(t.getData) == "function" and t.getData() or nil
		value = wt.PackColor(wt.UnpackColor(value))
		local snapshot = value

		--| State

		local enabled = t.disabled ~= true

		--| Events

		---@type table<string, function[]>
		local listeners = {}

		--[ Getters & Setters ]

		---Returns the object type of this widget
		---***
		---@return "ColorPicker" string
		---<hr><p></p>
		function colorPicker.getType() return "ColorPicker" end

		---Checks and returns if the type of this widget is equal to the string provided
		---@param type string|WidgetTypeName
		---@return boolean
		function colorPicker.isType(type) return type == "ColorPicker" end

		---Return a value at the specified key from the table used for creating the widget
		---@param key string
		---@return any
		function colorPicker.getProperty(key) return wt.FindValueByKey(t, key) end

		--| Event handling

		--Call all registered listeners for a custom widget event
		colorPicker.invoke = {
			enabled = function() callListeners(colorPicker, listeners, "enabled", enabled) end,

			---@param success boolean
			loaded = function(success) callListeners(colorPicker, listeners, "loaded", success) end,

			---@param success boolean
			saved = function(success) callListeners(colorPicker, listeners, "saved", success) end,

			---@param user boolean
			colored = function(user) callListeners(colorPicker, listeners, "colored", value, user) end,

			---@param event string Custom event tag
			---@param ... any
			_ = function(event, ...) callListeners(colorPicker, listeners, event, ...) end
		}

		--Hook a handler function as a listener for a custom widget event
		colorPicker.setListener = {
			---@param listener ColorPickerEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			enabled = function(listener, callIndex) addListener(listeners, "enabled", listener, callIndex) end,

			---@param listener ColorPickerEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			loaded = function(listener, callIndex) addListener(listeners, "loaded", listener, callIndex) end,

			---@param listener ColorPickerEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			saved = function(listener, callIndex) addListener(listeners, "saved", listener, callIndex) end,

			---@param listener ColorPickerEventHandler_colored Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			colored = function(listener, callIndex) addListener(listeners, "colored", listener, callIndex) end,

			---@param event string Custom event tag
			---@param listener ColorPickerEventHandler_any Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			_ = function(event, listener, callIndex) addListener(listeners, event, listener, callIndex) end
		}

		--| Options data management

		---Read the data from storage via **t.getData()** then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** false
		function colorPicker.loadData(handleChanges, silent)
			handleChanges = handleChanges ~= false

			if type(t.getData) == "function" then
				colorPicker.setColor(t.getData(), handleChanges, silent)

				if not silent then colorPicker.invoke.loaded(true) end
			else
				--Handle changes
				if handleChanges and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
					for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
				end

				if not silent then colorPicker.invoke.loaded(false) end
			end
		end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param color? colorData Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** false
		function colorPicker.saveData(color, silent)
			if type(t.saveData) == "function" then
				t.saveData(color and wt.PackColor(wt.UnpackColor(color)) or value)

				if not silent then colorPicker.invoke.saved(true) end
			elseif not silent then colorPicker.invoke.saved(false) end
		end

		---Get the currently stored data via **t.getData()**
		---@return colorData|nil
		function colorPicker.getData() return type(t.getData) == "function" and t.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param color? colorData Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function colorPicker.setData(color, handleChanges, silent)
			colorPicker.saveData(color, silent)
			colorPicker.loadData(handleChanges, silent)
		end

		--Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **colorPicker.revertData()**
		function colorPicker.snapshotData() snapshot = wt.Clone(colorPicker.getData()) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **colorPicker.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function colorPicker.revertData(handleChanges, silent) colorPicker.setData(snapshot, handleChanges, silent) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** true
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** false
		function colorPicker.resetData(handleChanges, silent) colorPicker.setData(default, handleChanges, silent) end

		---Returns the currently set color values
		---***
		---@return number r Red | ***Range:*** (0, 1)
		---@return number g Green | ***Range:*** (0, 1)
		---@return number b Blue | ***Range:*** (0, 1)
		---@return number|nil a Opacity | ***Range:*** (0, 1)
		function colorPicker.getColor() return wt.UnpackColor(value) end

		---Set the managed color values
		---***
		---@param color? optionalColorData ***Default:*** { r = 1, g = 1, b = 1, a = 1 } *(white)*
		---@param user? boolean Whether to flag the call as a result of a user interaction calling registered listeners | ***Default:*** false
		---@param silent? boolean If false, invoke a "colored" event and call registered listeners | ***Default:*** false
		function colorPicker.setColor(color, user, silent)
			value = wt.PackColor(wt.UnpackColor(color))

			if not silent then colorPicker.invoke.colored(user == true) end

			if user and t.instantSave ~= false then colorPicker.saveData(nil, silent) end

			--Handle changes
			if user and type(t.dataManagement) == "table" and type(t.dataManagement.onChange) == "table" then
				for i = 1, #t.dataManagement.onChange do optionsTable.changeHandlers[t.dataManagement.category .. t.dataManagement.onChange[i]]() end
			end
		end

		--| Color wheel

		--Color wheel value update utility
		local function colorUpdate()
			if not enabled then return end

			local r, g, b = ColorPickerFrame:GetColorRGB()

			colorPicker.setColor(wt.PackColor(r, g, b, ColorPickerFrame:GetColorAlpha()), true)
		end

		---Open the the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) for this color picker
		function colorPicker.openWheel()
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
					colorPicker.setColor(wt.PackColor(r, g, b, a), true)

					if t.onCancel then t.onCancel() end
				end
			})
		end

		---Return the active status of this color picker, whether the main color wheel window was opened for and is currently updating the color of this widget
		---@return boolean active True, if the color wheel has been opened for this color picker widget
		function colorPicker.isActive() return active end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function colorPicker.isEnabled() return enabled end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** true
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** false
		function colorPicker.setEnabled(state, silent)
			enabled = state ~= false

			--Update the color when re-enabled
			if active then colorUpdate() end

			if not silent then colorPicker.invoke.enabled() end
		end

		--[ Color Wheel Toggle ]

		--Button to open the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) on action with
		colorPicker.button = wt.CreateActionButton({ action = colorPicker.openWheel, })

		--Deactivate on close
		ColorPickerFrame:HookScript("OnHide", function() active = false end)

		--[ Initialization ]

		--Register event handlers
		if type(t.listeners) == "table" then for k, v in pairs(t.listeners) do if type(v) == "table" then for i = 1, #v do
			if k == "_" then colorPicker.setListener._(v[i].event, v[i].handler, v[i].callIndex) else colorPicker.setListener[k](v[i].handler, v[i].callIndex) end
		end end end end

		--Register to options data management
		if t.dataManagement then wt.AddOptionsRule(colorPicker, t.dataManagement) end

		--Assign dependencies
		if t.dependencies then wt.AddDependencies(t.dependencies, colorPicker.setEnabled) end

		--Set starting value
		colorPicker.setColor(value, false, true)

		return colorPicker
	end

	--| GUI

	---Create a custom color picker GUI frame with HEX(A) & RGB(A) input while utilizing the [ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame) wheel
	---***
	---@param t? colorPickerFrameCreationData Parameters are to be provided in this table
	---@param widget? colorPicker Reference to an already existing color picker to set up instead of creating a new base widget
	---***
	---@return colorPickerFrame|colorPicker colorPicker Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
	function wt.CreateColorPickerFrame(t, widget)
		t = t or {}

		---@class colorPickerFrame : colorPicker
		local colorPicker = widget and widget.isType and widget.isType("ColorPicker") and widget or wt.CreateColorPicker(t)

		if WidgetToolsDB.lite and t.lite ~= false then return colorPicker end

		--[ Frame Setup ]

		local name = (t.append ~= false and t.parent and t.parent~= UIParent and t.parent:GetName() or "") .. (t.name and t.name:gsub("%s+", "") or "ColorPicker")

		colorPicker.frame = CreateFrame("Frame", name, t.parent)

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

		--| Color wheel toggle button

		---Toggle the interactability of the color picker elements when [ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame) is opened
		---@param unlocked boolean
		local function setLock(unlocked)
			colorPicker.button.frame:EnableMouse(unlocked)
			colorPicker.hexBox.editbox:EnableMouse(unlocked)

			--| Fade inactive color pickers

			local opacity = (unlocked or colorPicker.isActive()) and 1 or 0.4

			colorPicker.label:SetAlpha(opacity)
			colorPicker.hexBox.editbox:SetAlpha(opacity)
		end

		if not t.value and t.getData then t.value = wt.Clone(t.getData()) else t.value = {} end

		if not colorPicker.button.frame then wt.CreateCustomButton({
			parent = colorPicker.frame,
			name = "PickerButton",
			label = false,
			tooltip = {
				title = ns.toolboxStrings.color.picker.label,
				lines = { { text = ns.toolboxStrings.color.picker.tooltip:gsub("#ALPHA", t.value.a and ns.toolboxStrings.color.picker.alpha or ""), }, }
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
			backdropUpdates = {
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
			},
		}, colorPicker.button) end

		colorPicker.button.gradient = wt.CreateTexture({
			parent = colorPicker.button.frame,
			name = "ColorGradient",
			position = { offset = { x = 2.5, y = -2.5 } },
			size = { w = 14, h = 17 },
			path = textures.gradientBG,
			layer = "BACKGROUND",
			level = -7,
		})

		colorPicker.button.checker = wt.CreateTexture({
			parent = colorPicker.button.frame,
			name = "AlphaBG",
			position = { offset = { x = 2.5, y = -2.5 } },
			size = { w = 29, h = 17 },
			path = textures.alphaBG,
			layer = "BACKGROUND",
			level = -8,
			tile = { h = true, v = true },
			wrap = { h = true, v = true },
		})

		--| HEX textbox

		colorPicker.hexBox = wt.CreateCustomEditbox({
			parent = colorPicker.frame,
			name = "HEXBox",
			title = ns.toolboxStrings.color.hex.label,
			label = false,
			tooltip = { lines = { {
				text = ns.toolboxStrings.color.hex.tooltip .. "\n\n" .. WrapTextInColorCode(ns.toolboxStrings.example .. ": ", "FF66FF66") .. WrapTextInColorCode(
					"#2266BB" .. (t.value.a and "AA" or ""), "FFFFFFFF"
				),
			}, } },
			position = {
				relativeTo = colorPicker.button.frame,
				relativePoint = "TOPRIGHT",
			},
			size = { w = t.width - colorPicker.button.frame:GetWidth(), h = colorPicker.button.frame:GetHeight() },
			insets = { l = 6, },
			font = {
				normal = "GameFontWhiteSmall",
				disabled = "GameFontDisableSmall",
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
			backdropUpdates = {
				OnEnter = { rule = function(self) return self:IsEnabled() and { border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } } } or {} end },
				OnLeave = {},
			},
			events = {
				OnChar = function(self, _, text) self.setText(text:gsub("^(#?)([%x]*).*", "%1%2"), false) end,
				OnEnterPressed = function(_, text) colorPicker.setColor(wt.PackColor(wt.HexToColor(text)), true) end,
				OnEscapePressed = function(self) self.setText(wt.ColorToHex(colorPicker.getColor())) end,
			},
			showDefault = false,
			utilityMenu = false,
		})

		--| RGBA textboxes

		--ADD textboxes

		--[ Events ]

		--Register script event handlers
		if t.events then for key, value in pairs(t.events) do
			if key == "attribute" then colorPicker.frame:HookScript("OnAttributeChanged", function(_, attribute, ...) if attribute == value.name then value.handler(...) end end)
			else colorPicker.frame:HookScript(key, value) end
		end end

		--| UX

		---Update the widget UI based on the color value
		---***
		---@param r? number ***Range:*** (0, 1) | ***Default:*** 1
		---@param g? number ***Range:*** (0, 1) | ***Default:*** 1
		---@param b? number ***Range:*** (0, 1) | ***Default:*** 1
		---@param a? number ***Range:*** (0, 1) | ***Default:*** 1
		local function updateColor(r, g, b, a)
			a = a or 1

			colorPicker.button.frame:SetBackdropColor(r, g, b, a)
			colorPicker.button.gradient:SetVertexColor(r, g, b, 1)
			colorPicker.hexBox.setText(wt.ColorToHex(r, g, b, a))
		end

		--Handle widget updates
		colorPicker.setListener.colored(function(_, color) updateColor(wt.UnpackColor(color)) end)

		--Color wheel toggle updates
		ColorPickerFrame:HookScript("OnShow", function() setLock(false) end)
		ColorPickerFrame:HookScript("OnHide", function() setLock(true) end)

		--| Tooltip

		if t.tooltip then
			local defaultValue
			if t.showDefault ~= false then defaultValue = "|TInterface/ChatFrame/ChatFrameBackground:12:12:0:0:16:16:0:16:0:16:" .. (t.default.r * 255) .. ":" .. (t.default.g * 255) .. ":" .. (t.default.b * 255) .. "|t " .. WrapTextInColorCode(wt.ColorToHex(wt.UnpackColor(t.default)), "FFFFFFFF") end

			wt.AddWidgetTooltipLines(t, defaultValue)
			wt.AddTooltip(colorPicker.frame, {
				title = t.tooltip.title or title,
				lines = t.tooltip.lines,
				anchor = "ANCHOR_RIGHT",
			})
		end

		--| Utility menu

		if t.utilityMenu ~= false then
			wt.CreateContextMenu({ parent = colorPicker.frame, initialize = function(menu)
				wt.CreateMenuTextline(menu, { text = title })
				wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.revert, action = function() colorPicker.revertData() end })
				if t.default then wt.CreateMenuButton(menu, { title = ns.toolboxStrings.value.restore, action = function() colorPicker.resetData() end }) end
			end, condition = function() return colorPicker.isEnabled() and not ColorPickerFrame:IsVisible() end })
		end

		--| State

		---Update the widget UI based on its enabled state
		---@param _ colorPicker
		---@param state boolean
		local function updateState(_, state)
			colorPicker.button.setEnabled(state)
			colorPicker.hexBox.setEnabled(state)

			if colorPicker.label then colorPicker.label:SetFontObject(state and "GameFontNormal" or "GameFontDisable") end

			if ColorPickerFrame:IsVisible() then setLock(false) end
		end

		colorPicker.setListener.enabled(updateState, 1)

		--[ Initialization ]

		--Set up starting state
		updateState(nil, colorPicker.isEnabled())

		--Set up coloring
		updateColor(colorPicker.getColor())

		return colorPicker
	end


	--[[ TEMPLATES ]]

	--[ Settings Pages ]

	---Create and set up a new settings page with about into for an addon
	---***
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param t? aboutPageCreationData Parameters are to be provided in this table
	---***
	---@return settingsPage|nil aboutPage Table containing references to the options canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions
	function wt.CreateAboutPage(addon, t)
		if not addon or not C_AddOns.IsAddOnLoaded(addon) then return end

		t = t or {}
		local data = {
			title = wt.Clear(C_AddOns.GetAddOnMetadata(addon, "Title")):sub(1, -2),
			version = C_AddOns.GetAddOnMetadata(addon, "Version"),
			day = C_AddOns.GetAddOnMetadata(addon, "X-Day"),
			month = C_AddOns.GetAddOnMetadata(addon, "X-Month"),
			year = C_AddOns.GetAddOnMetadata(addon, "X-Year"),
			author = C_AddOns.GetAddOnMetadata(addon, "Author"),
			license = C_AddOns.GetAddOnMetadata(addon, "X-License"),
			curse = C_AddOns.GetAddOnMetadata(addon, "X-CurseForge"),
			wago = C_AddOns.GetAddOnMetadata(addon, "X-Wago"),
			repo = C_AddOns.GetAddOnMetadata(addon, "X-Repository"),
			issues = C_AddOns.GetAddOnMetadata(addon, "X-Issues"),
			sponsors = C_AddOns.GetAddOnMetadata(addon, "X-Sponsors"),
			topSponsors = C_AddOns.GetAddOnMetadata(addon, "X-TopSponsors"),
		}

		--[ Settings Page ]

		return wt.CreateSettingsPage(addon, not WidgetToolsDB.lite and next(data) and {
			register = t.register,
			name = t.name or "About",
			title = t.title or data.title,
			description = t.description or C_AddOns.GetAddOnMetadata(addon, "Notes"),
			static = t.static ~= false,
			initialize = function(canvas)

				--[ About ]

				wt.CreatePanel({
					parent = canvas,
					name = "About",
					title = ns.toolboxStrings.about.title,
					description = ns.toolboxStrings.about.description:gsub("#ADDON", data.title),
					arrange = {},
					size = { h = 258 },
					initialize = function(panel)

						--[ Information ]

						local position = { offset = { x = 16, y = -30 } }

						if data.version then
							local version = wt.CreateText({
								parent = panel,
								name = "VersionTitle",
								position = position,
								width = 45,
								text = ns.toolboxStrings.about.version,
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

							position.relativeTo = version
							position.relativePoint = "BOTTOMLEFT"
							position.offset.x = 0
							position.offset.y = -8
						end

						if data.day and data.month and data.year then
							local date = wt.CreateText({
								parent = panel,
								name = "DateTitle",
								position = position,
								width = 45,
								text = ns.toolboxStrings.about.date,
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

							position.relativeTo = date
							position.relativePoint = "BOTTOMLEFT"
							position.offset.x = 0
							position.offset.y = -8
						end

						if data.author then
							local author = wt.CreateText({
								parent = panel,
								name = "AuthorTitle",
								position = position,
								width = 45,
								text = ns.toolboxStrings.about.author,
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

							position.relativeTo = author
							position.relativePoint = "BOTTOMLEFT"
							position.offset.x = 0
							position.offset.y = -8
						end

						if data.license then
							local license = wt.CreateText({
								parent = panel,
								name = "LicenseTitle",
								position = position,
								width = 45,
								text = ns.toolboxStrings.about.license,
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

							position.relativeTo = license
							position.relativePoint = "BOTTOMLEFT"
							position.offset.x = 0
						end

						--[ Links ]

						if position.relativeTo then position.offset.y = -12 end

						if data.curse then
							local curse = wt.CreateCopybox({
								parent = panel,
								name = "CurseForge",
								title = ns.toolboxStrings.about.curseForge,
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
								title = ns.toolboxStrings.about.wago,
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
								title = ns.toolboxStrings.about.repository,
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
							title = ns.toolboxStrings.about.issues,
							position = position,
							size = { w = 190, },
							value = data.issues,
						}) end

						--[ Changelog ]

						if not t.changelog then return end

						local changelog = wt.CreateMultilineEditbox({
							parent = panel,
							name = "Changelog",
							title = ns.toolboxStrings.about.changelog.label,
							tooltip = { lines = { { text = ns.toolboxStrings.about.changelog.tooltip:gsub("#VERSION", WrapTextInColorCode(data.version, "FFFFFFFF")), }, } },
							arrange = {},
							size = { w = panel:GetWidth() - 225, h = panel:GetHeight() - 42 },
							font = { normal = "GameFontDisableSmall", },
							color = ns.colors.grey[2],
							value = wt.FormatChangelog(t.changelog, true),
							readOnly = true,
						})

						local fullChangelogFrame
						wt.CreateSimpleButton({
							parent = panel,
							name = "ChangelogButton",
							title = ns.toolboxStrings.about.fullChangelog.open.label,
							tooltip = { lines = { { text = ns.toolboxStrings.about.fullChangelog.open.tooltip, }, } },
							position = {
								anchor = "TOPRIGHT",
								relativeTo = changelog.frame,
								relativePoint = "TOPRIGHT",
								offset = { x = -3, y = 2 }
							},
							size = { w = 100, h = 14 },
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
										title = ns.toolboxStrings.about.fullChangelog.label:gsub("#ADDON", data.title),
										position = { anchor = "BOTTOMRIGHT", },
										keepInBounds = true,
										size = { w = 678, h = 610 },
										frameStrata = "DIALOG",
										keepOnTop = true,
										background = { color = { a = 0.9 }, },
										initialize = function(windowPanel)
											wt.CreateMultilineEditbox({
												parent = windowPanel,
												name = "FullChangelog",
												title = ns.toolboxStrings.about.fullChangelog.label:gsub("#ADDON", data.title),
												label = false,
												tooltip = { lines = { { text = ns.toolboxStrings.about.fullChangelog.tooltip, }, } },
												arrange = {},
												size = { w = windowPanel:GetWidth() - 32, h = windowPanel:GetHeight() - 88 },
												font = { normal = "GameFontDisable", },
												color = ns.colors.grey[2],
												value = wt.FormatChangelog(t.changelog),
												readOnly = true,
												scrollSpeed = 0.2,
											})

											wt.CreateSimpleButton({
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
		if not addon or not C_AddOns.IsAddOnLoaded(addon) or not t.accountData or not t.characterData or not t.settingsData or not t.defaultsTable then return end

		local addonTitle = wt.Clear(C_AddOns.GetAddOnMetadata(addon, "Title"))

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
		---@return "DataManagementPage" string
		---<hr><p></p>
		function dataManagement.getType() return "DataManagementPage" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|WidgetTypeName
		---@return boolean
		function dataManagement.isType(type) return type == "DataManagementPage" end

		---Return a value at the specified key from the table used for creating the data management page
		---@param key string
		---@return any
		function dataManagement.getProperty(key) return wt.FindValueByKey(t, key) end

		--[ Settings Page ]

		dataManagement.page = wt.CreateSettingsPage(addon, {
			register = t.register,
			name = t.name or "DataManagement",
			title = t.title or ns.toolboxStrings.dataManagement.title,
			description = t.description or ns.toolboxStrings.dataManagement.description:gsub("#ADDON", addonTitle),
			dataManagement = {
				category = addon,
				keys = { "Backup" },
			},
			onSave = t.onSave,
			onLoad = t.onLoad,
			onCancel = t.onCancel,
			onDefault = t.onDefault,
			initialize = function(canvas, _, _, category, keys)

				--[ Profile Management ]

				--Profile delete confirmation
				local deleteProfilePopup = wt.RegisterPopupDialog(addon, "DELETE_PROFILE", { accept = DELETE, })

				--Profile reset confirmation
				local resetProfilePopup = wt.RegisterPopupDialog(addon, "RESET_PROFILE")

				--| Utilities

				---Find a profile by its display title and return its index
				---***
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
					wt.RemoveMismatch(profileData, compareWith, nil, t.onRecovery)
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
				---@param index integer
				---@return number|nil
				local function activateProfile(index)
					if type(index) ~= "number" then return end

					index = Clamp(index, 1, #t.accountData.profiles)
					t.characterData.activeProfile = index

					--Call listener
					if t.onProfileActivated then t.onProfileActivated(t.accountData.profiles[index].title, index) end

					return t.characterData.activeProfile
				end

				---Activate the specified settings profile
				---***
				---@param index integer Index of the profile to set as the currently active settings profile
				---@return boolean # True on success, false if the operation failed
				function dataManagement.activateProfile(index)
					if not activateProfile(index) then return false end

					--Update dropdown selection
					if dataManagement.profiles then dataManagement.profiles.apply.setText(index) end

					return true
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
					if t.onProfileCreated then t.onProfileCreated(t.accountData.profiles[index].title, index) end

					--Activate the new profile
					if apply ~= false then dataManagement.activateProfile(index) end
				end

				---Delete the specified profile
				---***
				---@param index? integer Index of the profile to delete the data and dropdown item of | ***Default:*** **t.characterData.activeProfile**
				---@param unsafe? boolean If false, show a popup confirmation before attempting to delete the specified profile | ***Default:*** false
				---@return boolean # True on success, false if the operation failed
				function dataManagement.deleteProfile(index, unsafe)
					if index and not t.accountData.profiles[index] then return false end

					index = index or t.characterData.activeProfile
					local title = t.accountData.profiles[index].title

					local delete = function()
						--Delete profile data
						table.remove(t.accountData.profiles, index)

						--Update dropdown items
						if dataManagement.profiles then dataManagement.profiles.apply.updateItems(t.accountData.profiles) end

						--Call listener
						if t.onProfileDeleted then t.onProfileDeleted(title, index) end

						--Activate the replacement profile
						if t.characterData.activeProfile == index then activateProfile(index) end
					end

					if unsafe then delete() else StaticPopup_Show(wt.UpdatePopupDialog(deleteProfilePopup, {
						text = ns.toolboxStrings.profiles.delete.warning:gsub("#PROFILE", wt.Color(t.accountData.profiles[index].title, colors.highlight)):gsub("#ADDON", addonTitle),
						onAccept = delete,
					})) end

					return true
				end

				---Reset the specified profile data to default values
				---***
				---@param index? integer Index of the profile to restore to defaults | ***Default:*** **t.characterData.activeProfile**
				---@param unsafe? boolean If false, show a popup confirmation before attempting to reset the specified profile | ***Default:*** false
				---@return boolean # True on success, false if the operation failed
				function dataManagement.resetProfile(index, unsafe)
					if index and not t.accountData.profiles[index] then return false end

					index = index or t.characterData.activeProfile

					local function reset()
						if index and not t.accountData.profiles[index] then return end

						index = index or t.characterData.activeProfile

						--Update the profile in storage (without breaking table references)
						wt.CopyValues(t.accountData.profiles[index].data, t.defaultsTable)

						--Call listener
						if t.onProfileReset then t.onProfileReset(t.accountData.profiles[index].title, index) end
					end

					if unsafe then reset() else StaticPopup_Show(wt.UpdatePopupDialog(resetProfilePopup, {
						text = ns.toolboxStrings.profiles.reset.warning:gsub("#PROFILE", wt.Color(t.accountData.profiles[index].title, colors.highlight)):gsub("#ADDON", addonTitle),
						onAccept = reset,
					}))end

					return true
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
						wt.AddMissing(t.accountData.profiles[t.characterData.activeProfile].data, recovered)
						wt.CopyValues(t.accountData.profiles[t.characterData.activeProfile].data, recovered)

						--Validate active profile data
						checkData(t.accountData.profiles[t.characterData.activeProfile].data)
					end

					--| Call listener

					if t.onProfilesLoaded then t.onProfilesLoaded() end
				end

				--| Initialization

				loadProfiles()

				--[ GUI Widgets ]

				if not WidgetToolsDB.lite or t.lite == false then

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
								tooltip = { lines = { { text = ns.toolboxStrings.profiles.select.tooltip, }, } },
								arrange = {},
								width = 180,
								items = t.accountData.profiles,
								selected = t.characterData.activeProfile,
								listeners = { selected = { { handler = function(_, index) activateProfile(index) end, }, }, },
							})

							dataManagement.profiles.new = wt.CreateSimpleButton({
								parent = panel,
								name = "New",
								title = ns.toolboxStrings.profiles.new.label,
								tooltip = { lines = { { text = ns.toolboxStrings.profiles.new.tooltip, }, } },
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -312, y = -30 }
								},
								size = { w = 112, h = 26 },
								action = function() dataManagement.newProfile(nil, #t.accountData.profiles + 1) end,
							})

							dataManagement.profiles.duplicate = wt.CreateSimpleButton({
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

							dataManagement.profiles.rename = wt.CreateSimpleButton({
								parent = panel,
								name = "Rename",
								title = ns.toolboxStrings.profiles.rename.label,
								tooltip = { lines = { { text = ns.toolboxStrings.profiles.rename.tooltip, }, } },
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -92, y = -30 }
								},
								size = { w = 92, h = 26 },
								action = function() wt.CreatePopupInputBox({
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
								}) end,
							})

							dataManagement.profiles.delete = wt.CreateSimpleButton({
								parent = panel,
								name = "Delete",
								title = DELETE,
								tooltip = { lines = { { text = ns.toolboxStrings.profiles.delete.tooltip, }, } },
								position = {
									anchor = "TOPRIGHT",
									offset = { x = -12, y = -30 }
								},
								size = { w = 72, h = 26 },
								action = function() dataManagement.deleteProfile() end,
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
						name = keys[1],
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

							dataManagement.backup.box = wt.CreateMultilineEditbox({
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
								dataManagement = {
									category = category,
									key = keys[1],
								},
								listeners = { loaded = { { handler = dataManagement.refreshBackupBox, }, }, },
								showDefault = false,
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
								getData = function() return t.settingsData.compactBackup end,
								saveData = function(state) t.settingsData.compactBackup = state end,
								dataManagement = {
									category = addon,
									key = keys[1],
									onChange = { RefreshBackupBox = dataManagement.refreshBackupBox },
								},
								listeners = { loaded = { { handler = function() dataManagement.backupAllProfiles.compact.button:SetChecked(t.settingsData.compactBackup) end, }, }, },
								events = { OnClick = function(_, state) dataManagement.backupAllProfiles.compact.button:SetChecked(state) end },
								showDefault = false,
								utilityMenu = false,
							})

							local importPopup = wt.RegisterPopupDialog(addon, "IMPORT", {
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

							dataManagement.backup.load = wt.CreateSimpleButton({
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

							dataManagement.backup.reset = wt.CreateSimpleButton({
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
								title = ns.toolboxStrings.backup.allProfiles.label,
								position = { anchor = "BOTTOMRIGHT", },
								keepInBounds = true,
								size = { w = 678, h = 610 },
								frameStrata = "DIALOG",
								keepOnTop = true,
								background = { color = { a = 0.9 }, },
								initialize = function(windowPanel)
									dataManagement.backupAllProfiles.box = wt.CreateMultilineEditbox({
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
										dataManagement = {
											category = category,
											key = keys[1],
										},
										listeners = { loaded = { { handler = dataManagement.refreshAllProfilesBackupBox, }, }, },
										showDefault = false,
									})

									wt.CreateSimpleButton({
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

							wt.CreateSimpleButton({
								parent = panel,
								name = "AllProfilesButton",
								title = ns.toolboxStrings.backup.allProfiles.open.label,
								tooltip = { lines = { { text = ns.toolboxStrings.backup.allProfiles.open.tooltip, }, } },
								position = {
									anchor = "TOPRIGHT",
									relativeTo = dataManagement.backup.box.frame,
									relativePoint = "TOPRIGHT",
									offset = { x = -3, y = 2 }
								},
								size = { w = 100, h = 14 },
								frameLevel = dataManagement.backup.box.frame:GetFrameLevel() + 1, --Make sure it's on top to be clickable
								font = {
									normal = "GameFontNormalSmall",
									highlight = "GameFontHighlightSmall",
								},
								action = function()
									allProfilesBackupFrame:Show()

									dataManagement.backupAllProfiles.compact.setState(t.settingsData.compactBackup, nil, true)

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
									dataManagement.backup.compact.toggleState(true)
									dataManagement.refreshAllProfilesBackupBox()
								end },
								showDefault = false,
								utilityMenu = false,
							})

							local allProfilesImportPopup = wt.RegisterPopupDialog(addon, "IMPORT_ALL", {
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

							dataManagement.backupAllProfiles.load = wt.CreateSimpleButton({
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

							dataManagement.backupAllProfiles.reset = wt.CreateSimpleButton({
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

	if WidgetToolsDB.lite or wt.classic then WidgetToolsDB.positioningAids = false end --TODO fix in Classic

	---Create and set up position options for a specified frame within a panel frame
	---***
	---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
	---@param t positionOptionsCreationData Parameters are to be provided in this table
	---***
	---@return positionPanel|nil table Components of the options panel wrapped in a table
	function wt. CreatePositionOptions(addon, t)
		if not addon or not C_AddOns.IsAddOnLoaded(addon) or not type(t) == "table" then return end

		t.dataManagement = t.dataManagement or {}
		t.dataManagement.category = t.dataManagement.category or addon
		t.dataManagement.key = t.dataManagement.key or "Position"

		---@class positionPanel
		---@field layer? table
		---@field presets? table
		local panel = {}

		--[ Visual Aids ]

		if WidgetToolsDB.positioningAids then
			positioningVisualAids.frame = positioningVisualAids.frame or wt.CreateFrame({
				name = "WidgetToolsPositioningVisualAids",
				position = { anchor = "CENTER", },
				size = { w = GetScreenWidth() / C_CVar.GetCVar("uiScale") - 14, h = GetScreenHeight() / C_CVar.GetCVar("uiScale") - 14 },
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
					---@param frame AnyFrameObject
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

			t.canvas:HookScript("OnShow", function() positioningVisualAids.show(t.frame, t.getData().position) end)
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

					local applyPreset = function(_, i)
						if not (panel.presetList[i] or {}).data then
							--Call the specified handler
							if t.presets.onPreset then t.presets.onPreset(i) end

							return
						end

						--Position
						if type(panel.presetList[i].data.position) == "table" then
							--Update the frame
							wt.SetPosition(t.frame, panel.presetList[i].data.position, true)

							--Update the storage
							wt.ConvertToAbsolutePosition(t.frame)
							wt.CopyValues(t.getData().position, wt.PackPosition(t.frame:GetPoint()))

							--Update the options widgets
							panel.position.anchor.loadData(false)
							panel.position.relativePoint.loadData(false)
							-- panel.position.relativeTo.loadData(false)
							panel.position.offset.x.loadData(false)
							panel.position.offset.y.loadData(false)
						end

						--Keep in bounds
						if panel.presetList[i].data.keepInBounds ~= nil then
							t.frame:SetClampedToScreen(panel.presetList[i].data.keepInBounds) --Update the frame
							t.getData().keepInBounds = panel.presetList[i].data.keepInBounds --Update the storage
							if panel.position.keepInBounds then panel.position.keepInBounds.loadData(false) end --Update the options widget
						end

						--Screen Layer
						if type(panel.presetList[i].data.layer) == "table" then
							--Frame strata
							if panel.presetList[i].data.layer.strata then
								t.frame:SetFrameStrata(panel.presetList[i].data.layer.strata) --Update the frame
								t.getData().layer.strata = panel.presetList[i].data.layer.strata --Update the storage
								if panel.layer.strata then panel.layer.strata.loadData(false) end --Update the options widget
							end

							--Keep on top
							if panel.presetList[i].data.layer.keepOnTop ~= nil then
								t.frame:SetToplevel(panel.presetList[i].data.layer.keepOnTop) --Update the frame
								t.getData().layer.keepOnTop = panel.presetList[i].data.layer.keepOnTop --Update the storage
								if panel.layer.keepOnTop then panel.layer.keepOnTop.loadData(false) end --Update the options widget
							end

							--Frame level
							if panel.presetList[i].data.layer.level then
								t.frame:SetFrameLevel(panel.presetList[i].data.layer.level) --Update the frame
								t.getData().layer.level = panel.presetList[i].data.layer.level --Update the storage
								if panel.layer.level then panel.layer.level.loadData(false) end --Update the options widget
							end
						end

						--Update the positioning visual aids
						if WidgetToolsDB.positioningAids then positioningVisualAids.update(t.frame, t.getData().position) end

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
						applyPreset(nil, i)

						return true
					end

					--| Options widgets

					panel.presets.applyButton, panel.presets.applyMenu = wt.CreatePopupMenu({
						parent = panelFrame,
						name = "ApplyPreset",
						title = ns.toolboxStrings.presets.apply.label,
						tooltip = { lines = { { text = ns.toolboxStrings.presets.apply.tooltip:gsub("#FRAME", t.frameName), }, } },
						arrange = {},
						initialize = function(menu)
							wt.CreateMenuTextline(menu, { text = ns.toolboxStrings.presets.apply.select, })

							for i = 1, #panel.presetList do wt.CreateMenuButton(menu, {
								title = panel.presetList[i].title,
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
								panel.presetList[t.presets.custom.index].data.layer.level = t.frame:GetFrameLevel()
							end

							--Save the custom preset
							wt.CopyValues(t.presets.custom.getData(), panel.presetList[t.presets.custom.index].data)
							if t.presets.custom.getData() then wt.CopyValues(t.presets.custom.getData(), t.presets.custom.getData()) end

							--Call the specified handler
							if t.presets.custom.onSave then t.presets.custom.onSave() end
						end

						--Reset the custom preset to its default state
						function panel.resetCustomPreset()
							--Reset the custom preset
							panel.presetList[t.presets.custom.index].data = wt.Clone(t.presets.custom.defaultsTable)

							--Save the custom preset
							wt.CopyValues(t.presets.custom.getData(), panel.presetList[t.presets.custom.index].data)
							if t.presets.custom.getData() then wt.CopyValues(t.presets.custom.getData(), t.presets.custom.getData()) end

							--Call the specified handler
							if t.presets.custom.onReset then t.presets.custom.onReset() end

							--Apply the custom preset
							panel.applyPreset(t.presets.custom.index)
						end

						--| Options Widgets

						local savePopup = wt.RegisterPopupDialog(addon, "SAVE_PRESET", {
							text = ns.toolboxStrings.presets.save.warning:gsub("#CUSTOM", wt.Color(panel.presetList[t.presets.custom.index].title, colors.highlight)),
							accept = ns.toolboxStrings.override,
							onAccept = panel.saveCustomPreset,
						})

						panel.presets.save = wt.CreateSimpleButton({
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

						local resetPopup = wt.RegisterPopupDialog(addon, "RESET_PRESET", {
							text = ns.toolboxStrings.presets.reset.warning:gsub("#CUSTOM", wt.Color(panel.presetList[t.presets.custom.index].title, colors.highlight)),
							accept = ns.toolboxStrings.override,
							onAccept = panel.resetCustomPreset,
						})

						panel.presets.reset = wt.CreateSimpleButton({
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
				local previousAnchor = t.getData().position.anchor

				--| Options widgets

				panel.position.relativePoint = wt.CreateSpecialRadioSelector("anchor", {
					parent = panelFrame,
					name = "RelativePoint",
					title = ns.toolboxStrings.position.relativePoint.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.relativePoint.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = {},
					width = 140,
					dependencies = t.dependencies,
					getData = function() return t.getData().position.relativePoint end,
					saveData = function(value) t.getData().position.relativePoint = value end,
					default = t.defaultsTable.position.relativePoint,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomPositionChangeHandler = function() if type(t.onChangePosition) == "function" then t.onChangePosition() end end,
							UpdateFramePosition = function() wt.SetPosition(t.frame, t.getData().position, true) end,
							UpdatePositioningVisualAids = function() if WidgetToolsDB.positioningAids then positioningVisualAids.update(t.frame, t.getData().position) end end,
						},
					},
				})

				panel.position.anchor = wt.CreateSpecialRadioSelector("anchor", {
					parent = panelFrame,
					name = "AnchorPoint",
					title = ns.toolboxStrings.position.anchor.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.anchor.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = { newRow = false, },
					width = 140,
					dependencies = t.dependencies,
					getData = function() return t.getData().position.anchor end,
					saveData = function(value) t.getData().position.anchor = value end,
					default = t.defaultsTable.position.anchor,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						index = 1,
						onChange = {
							"CustomPositionChangeHandler",
							UpdateFrameOffsetsAndPosition = function() if not t.settingsData.keepInPlace then wt.SetPosition(t.frame, t.getData().position, true) else
								local x, y = 0, 0

								if previousAnchor:find("LEFT") then
									if t.getData().position.anchor:find("RIGHT") then x = -t.frame:GetWidth()
									elseif t.getData().position.anchor == "CENTER" or t.getData().position.anchor == "TOP" or t.getData().position.anchor == "BOTTOM" then
										x = -t.frame:GetWidth() / 2
									end
								elseif previousAnchor:find("RIGHT") then
									if t.getData().position.anchor:find("LEFT") then x = t.frame:GetWidth()
									elseif t.getData().position.anchor == "CENTER" or t.getData().position.anchor == "TOP" or t.getData().position.anchor == "BOTTOM" then
										x = t.frame:GetWidth() / 2
									end
								elseif previousAnchor == "CENTER" or previousAnchor == "TOP" or previousAnchor == "BOTTOM" then
									if t.getData().position.anchor:find("LEFT") then x = t.frame:GetWidth() / 2
									elseif t.getData().position.anchor:find("RIGHT") then x = -t.frame:GetWidth() / 2 end
								end

								if previousAnchor:find("TOP") then
									if t.getData().position.anchor:find("BOTTOM") then y = t.frame:GetHeight()
									elseif t.getData().position.anchor == "CENTER" or t.getData().position.anchor == "LEFT" or t.getData().position.anchor == "RIGHT" then
										y = t.frame:GetHeight() / 2
									end
								elseif previousAnchor:find("BOTTOM") then
									if t.getData().position.anchor:find("TOP") then y = -t.frame:GetHeight()
									elseif t.getData().position.anchor == "CENTER" or t.getData().position.anchor == "LEFT" or t.getData().position.anchor == "RIGHT" then
										y = -t.frame:GetHeight() / 2
									end
								elseif previousAnchor == "CENTER" or previousAnchor == "LEFT" or previousAnchor == "RIGHT" then
									if t.getData().position.anchor:find("TOP") then y = -t.frame:GetHeight() / 2
									elseif t.getData().position.anchor:find("BOTTOM") then y = t.frame:GetHeight() / 2 end
								end

								previousAnchor = t.getData().position.anchor

								--Update offsets
								panel.position.offset.x.setData(t.getData().position.offset.x - x, false, false)
								panel.position.offset.y.setData(t.getData().position.offset.y - y, false, false)

								--Update frame position
								wt.SetPosition(t.frame, t.getData().position, true)
							end end,
							"UpdatePositioningVisualAids"
						},
					},
				})

				panel.position.keepInPlace = wt.CreateCheckbox({
					parent = panelFrame,
					name = "KeepInPlace",
					title = ns.toolboxStrings.position.keepInPlace.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.keepInPlace.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = { newRow = false, },
					dependencies = t.dependencies,
					getData = function() return t.settingsData.keepInPlace end,
					saveData = function(state) t.settingsData.keepInPlace = state end,
					default = true,
					showDefault = false,
					utilityMenu = false,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
					},
				})

				panel.position.offset.x = wt.CreateNumericSlider({
					parent = panelFrame,
					name = "OffsetX",
					title = ns.toolboxStrings.position.offsetX.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.offsetX.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = {},
					min = -500,
					max = 500,
					fractional = 2,
					step = 1,
					altStep = 25,
					dependencies = t.dependencies,
					getData = function() return t.getData().position.offset.x end,
					saveData = function(value) t.getData().position.offset.x = value end,
					default = t.defaultsTable.position.offset.x,
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

				panel.position.offset.y = wt.CreateNumericSlider({
					parent = panelFrame,
					name = "OffsetY",
					title = ns.toolboxStrings.position.offsetY.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.offsetY.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = { newRow = false, },
					min = -500,
					max = 500,
					fractional = 2,
					step = 1,
					altStep = 25,
					dependencies = t.dependencies,
					getData = function() return t.getData().position.offset.y end,
					saveData = function(value) t.getData().position.offset.y = value end,
					default = t.defaultsTable.position.offset.y,
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

				if t.getData().keepInBounds ~= nil then panel.position.keepInBounds = wt.CreateCheckbox({
					parent = panelFrame,
					name = "KeepInBounds",
					title = ns.toolboxStrings.position.keepInBounds.label,
					tooltip = { lines = { { text = ns.toolboxStrings.position.keepInBounds.tooltip:gsub("#FRAME", t.frameName), }, } },
					arrange = { newRow = false, },
					dependencies = t.dependencies,
					getData = function() return t.getData().keepInBounds end,
					saveData = function(state) t.getData().keepInBounds = state end,
					default = t.defaultsTable.keepInBounds,
					dataManagement = {
						category = t.dataManagement.category,
						key = t.dataManagement.key,
						onChange = {
							CustomKeepInBoundsChangeHandler = function() if type(t.onChangeKeepInBounds) == "function" then t.onChangeKeepInBounds() end end,
							UpdateScreenClamp = function() t.frame:SetClampedToScreen(t.getData().keepInBounds) end,
						},
					},
				}) end

				-- panel.position.relativeTo = wt.CreateEditBox({ --TODO: Try out GetMouseFocus() instead
				-- 	parent = panelFrame,
				-- 	name = "RelativeFrame",
				-- 	title = strings.position.relativeTo.label,
				-- 	tooltip = { lines = { { text = strings.position.relativeTo.tooltip:gsub("#FRAME", t.frameName), }, } },
				-- 	arrange = { newRow = false, },
				-- 	width = 170,
				-- 	events = {
				-- 		OnTextChanged = function(self, text)
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
				-- 		OnEscapePressed = function(self) self:SetText(t.getData().position.relativeTo) end,
				-- 	},
				-- 	dependencies = wt.MergeTable(wt.Clone(t.dependencies), { { frame = panel.position.absolute, evaluate = function(value) return not value end }, }),
				-- 	optionsKey = t.optionsKey,
				-- 	getData = function()
				-- 		if type(t.getData().position.relativeTo) == "table" then if t.getData().position.relativeTo.GetName then print(t.getData().position.relativeTo:GetName() .. ".") end end --REMOVE
				-- 		return wt.Clear(wt.ToString(t.getData().position.relativeTo))
				-- 	end,
				-- 	saveData = function(text)
				-- 		text = wt.Clear(value)
				-- 		local frame = wt.ToFrame(text)
				-- 		print("CONVERT SAVE", frame, frame and text or nil) --REMOVE
				--		
				-- 		t.getData().position.relativeTo = frame and text
				-- 	end,
				-- 	onChange = { "CustomPositionChangeHandler", "UpdateFramePosition", },
				-- 	-- disabled = not t.getData().position.relativeTo,
				-- 	-- dependencies = t.getData().position.relativeTo and t.dependencies or nil,
				-- 	-- optionsData = t.getData().position.relativeTo and {
				-- 	-- 	optionsKey = t.optionsKey,
				-- 	-- 	st = t.getData().position,
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

				if t.getData().layer and next(t.getData().layer) then
					panel.layer = {}

					--| Options widgets

					if t.getData().layer.strata then panel.layer.strata = wt.CreateSpecialRadioSelector("frameStrata", {
						parent = panelFrame,
						name = "FrameStrata",
						title = ns.toolboxStrings.layer.strata.label,
						tooltip = { lines = { { text = ns.toolboxStrings.layer.strata.tooltip:gsub("#FRAME", t.frameName), }, } },
						arrange = {},
						width = 140,
						dependencies = t.dependencies,
						getData = function() return t.getData().layer.strata end,
						saveData = function(value) t.getData().layer.strata = value end,
						default = t.defaultsTable.layer.strata,
						dataManagement = {
							category = t.dataManagement.category,
							key = t.dataManagement.key,
							onChange = {
								CustomStrataChangeHandler = function() if type(t.onChangeStrata) == "function" then t.onChangeStrata() end end,
								UpdateFrameStrata = function() t.frame:SetFrameStrata(t.getData().layer.strata) end,
							},
						},
					}) end

					if t.getData().layer.keepOnTop ~= nil then panel.layer.keepOnTop = wt.CreateCheckbox({
						parent = panelFrame,
						name = "KeepOnTop",
						title = ns.toolboxStrings.layer.keepOnTop.label,
						tooltip = { lines = { { text = ns.toolboxStrings.layer.keepOnTop.tooltip:gsub("#FRAME", t.frameName), }, } },
						arrange = { newRow = false, },
						dependencies = t.dependencies,
						getData = function() return t.getData().layer.keepOnTop end,
						saveData = function(state) t.getData().layer.keepOnTop = state end,
						default = t.defaultsTable.layer.keepOnTop,
						dataManagement = {
							category = t.dataManagement.category,
							key = t.dataManagement.key,
							onChange = {
								CustomKeepOnTopChangeHandler = function() if type(t.onChangeKeepOnTop) == "function" then t.onChangeKeepOnTop() end end,
								UpdateTopLevel = function() t.frame:SetToplevel(t.getData().layer.keepOnTop) end,
							},
						},
					}) end

					if t.getData().layer.level then panel.layer.level = wt.CreateNumericSlider({
						parent = panelFrame,
						name = "FrameLevel",
						title = ns.toolboxStrings.layer.level.label,
						tooltip = { lines = { { text = ns.toolboxStrings.layer.level.tooltip:gsub("#FRAME", t.frameName), }, } },
						arrange = { newRow = false, },
						min = 0,
						max = 10000,
						step = 1,
						altStep = 100,
						dependencies = t.dependencies,
						getData = function() return t.getData().layer.level end,
						saveData = function(value) t.getData().layer.level = value end,
						default = t.defaultsTable.layer.level,
						dataManagement = {
							category = t.dataManagement.category,
							key = t.dataManagement.key,
							onChange = {
								CustomLevelChangeHandler = function() if type(t.onChangeLevel) == "function" then t.onChangeLevel() end end,
								UpdateFrameLevel = function() t.frame:SetFrameLevel(t.getData().layer.level) end,
							},
						},
					}) end
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
						--Update the storage
						wt.CopyValues(t.getData().position, wt.PackPosition(t.frame:GetPoint()))

						--Update the options widgets
						panel.position.anchor.loadData(false)
						panel.position.relativePoint.loadData(false)
						-- panel.position.relativeTo.loadData(false)
						panel.position.offset.x.loadData(false)
						panel.position.offset.y.loadData(false)

						--Update the positioning visual aids
						if WidgetToolsDB.positioningAids then positioningVisualAids.update(t.frame, t.getData().position) end

						--Call the specified handler
						if t.setMovable.events.onStop then t.setMovable.events.onStop() end
					end,
					onCancel = function()
						--Reset the position
						wt.SetPosition(t.frame, t.getData().position, true)

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