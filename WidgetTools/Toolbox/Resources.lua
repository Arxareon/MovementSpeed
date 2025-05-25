--[[ NAMESPACE ]]

---@class WidgetToolsNamespace
local ns = select(2, ...)


--[[ INITIALIZATION ]]

if not ns.WidgetToolboxInitialization then return end

---@class wt
local wt = ns.WidgetToolbox


--[[ LOCALIZATION ]]

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
		warning = "Are you sure you want to reset the settings on the #PAGE page or all settings in the whole #CATEGORY category to defaults?",
		warningSingle = "Are you sure you want to reset the settings on the #PAGE page to defaults?",
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
		wt.strings = english
	end

	--| Fill static & internal references

	wt.strings.backup.box.tooltip[3] = wt.strings.backup.box.tooltip[3]:gsub("#LOAD", wt.strings.backup.load.label)
	wt.strings.position.keepInPlace.tooltip = wt.strings.position.keepInPlace.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
	wt.strings.position.offsetX.tooltip = wt.strings.position.offsetX.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
	wt.strings.position.offsetY.tooltip = wt.strings.position.offsetY.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
	wt.strings.position.relativePoint.tooltip = wt.strings.position.relativePoint.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
	wt.strings.layer.keepOnTop.tooltip = wt.strings.layer.keepOnTop.tooltip:gsub("#STRATA", wt.strings.layer.strata.label)
	wt.strings.layer.level.tooltip = wt.strings.layer.level.tooltip:gsub("#STRATA", wt.strings.layer.strata.label)
	-- wt.strings.about.changelog.tooltip = wt.strings.about.changelog.tooltip .. "\n\nThe changelog is only available in English for now." --TODO reinstate when more languages are added
	-- wt.strings.about.fullChangelog.tooltip = wt.strings.about.fullChangelog.tooltip .. "\n\nThe changelog is only available in English for now."
end

loadLocale()


--[[ ASSETS ]]

--Colors
wt.colors = {
	normal = wt.PackColor(NORMAL_FONT_COLOR:GetRGBA()),
	highlight = wt.PackColor(HIGHLIGHT_FONT_COLOR:GetRGBA()),
	disabled = wt.PackColor(GRAY_FONT_COLOR:GetRGB()),
	warning = wt.PackColor(RED_FONT_COLOR:GetRGB()),
}

--Textures
wt.textures = {
	alphaBG = "Interface/AddOns/" .. ns.name .. "/Textures/AlphaBG.tga",
	gradientBG = "Interface/AddOns/" .. ns.name .. "/Textures/GradientBG.tga",
}


--[[ Data ]]

--WidgetTools main database table
WidgetToolsDB = WidgetToolsDB or {}

--Data checkup
wt.RemoveEmpty(WidgetToolsDB)
wt.AddMissing(WidgetToolsDB, ns.defaults)
wt.RemoveMismatch(WidgetToolsDB, ns.defaults)


--[[ MISC ]]

--Classic vs Retail code separation
wt.classic = select(4, GetBuildInfo()) < 100000