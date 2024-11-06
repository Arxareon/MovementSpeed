--[[ ADDON INFO ]]

---Addon namespace table
---@class WidgetToolsNamespace
---@field name string Addon namespace name
local ns = select(2, ...)

ns.name = ...


--Addon root folder
local root = "Interface/AddOns/" .. ns.name .. "/"


--[[ CHANGELOG ]]

ns.changelog = {
	{
		"#V_Version 2.0_# #H_(11/6/2024)_#",
		"#N_New:_#",
		"Added Cataclysm Classic 4.4.1, vanilla Classic 1.15.4 & The War Within 11.0.5 support.",
		"A new Lite mode has been introduced. When enabled, no settings managed by Widget Tools will be loaded for addons built with Widget Tools saving resources in the process. Disable to access addon settings again.",
		"An option to enable positioning visual aids for addons built with Widget Tools have been added.",
		"Added an option for developers to make the Frame Attributes window (TableAttributeDisplay Frame) wider.",
		"Added chat commands for Widget Tools, use: #H_/wt_# to access.",
		"#H_#C_Changes_# & #F_Fixes_#:_#",
		"The look of checkboxes have been updated to match the new settings style.",
		"Significant under the hood improvements & fixes.",
		"#H_If you encounter any issues, do not hesitate to report them! Try including when & how they occur, and which other addons are you using to give me the best chance of being able to reproduce & fix them. Try proving any LUA script error messages and if you know how, taint logs as well (when relevant). Thanks a lot for helping!_#",
	},
	{
		"#V_Version 1.12_# #H_(8/9/2023)_#",
		"#C_Changes:_#",
		"Shortcuts have been removed from the main addon settings page in Classic.",
		"Under the hood improvements.",
	},
	{
		"#V_Version 1.11_# #H_(7/18/2023)_#",
		"#C_Changes:_#",
		"Added 1.14.4 (Classic) support with 1.14.3 backwards compatibility (until the Hardcore patch goes live).",
		"Scrolling has been improved in WotLK Classic.",
		"Backwards compatibility ensuring editboxes work with Toolbox version 1.5 has been removed.",
		"Other small improvements.",
	},
	{
		"#V_Version 1.10_# #H_(6/15/2023)_#",
		"#N_Updates:_#",
		"Added 10.1.5 (Dragonflight) support.",
		"#F_Fixes:_#",
		"No tooltip will stay on the screen after its target was hidden.",
		"Under the hood fixes & improvements.",
	},
	{
		"#V_Version 1.9_# #H_(5/17/2023)_#",
		"#C_Changes:_#",
		"Upgraded to the new Dragonflight addon logo handling. (Custom addon logos may not appear in the Interface Options in Classic clients.)",
		"#F_Fixes:_#",
		"Fixed an issue with actions being blocked after closing the Settings panel in certain situation (like changing Keybindings) in Dragonflight.",
		"The current version will now run in the WotLK Classic 3.4.2 PTR but it's not yet fully polished (as parts of the UI are still being modernized).",
		"Other small under the hood improvements & code cleanup.",
	},
	{
		"#V_Version 1.8_# #H_(4/5/2023)_#",
		"#N_Updates:_#",
		"Added 10.1 (Dragonflight) support.",
		"#F_Fixes:_#",
		"The old scrollbars have been replaced with the new scrollbars in Dragonflight, fixing any bugs that emerged with 10.1 as a result of deprecation.",
		"Several other under the hood fixes & improvements.",
	},
	{
		"#V_Version 1.7_# #H_(3/11/2023)_#",
		"#N_Updates:_#",
		"Added an option to disable addons using Widget Toolboxes from the Widget Tools settings.",
		"Added 10.0.7 (Dragonflight) support.",
		"#C_Changes:_#",
		"The Shortcuts section form the main settings page has been removed in Dragonflight (since the new expansion broke the feature - I may readd it if it gets resolved).",
		"Other smaller changes.",
		"#F_Fixes:_#",
		"Several under the hood fixes & improvements.",
	},
	{
		"#V_Version 1.6_# #H_(2/7/2023)_#",
		"#N_Updates:_#",
		"A new Sponsors section has been added to the main Settings page.\n#H_Thank you for your support! It helps me continue to spend time on developing and maintaining these addons. If you are considering supporting development as well, follow the links to see what ways are currently available._#",
		"The About info has been rearranged and combined with the Support links.",
		"Only the most recent update notes will be loaded now. The full Changelog is available in a bigger window when clicking on a new button.",
		"Made checkboxes more easily clickable, their tooltips are now visible even when the input is disabled.",
		"Added 10.0.5 (Dragonflight) & 3.4.1 (WotLK Classic) support.",
		"Numerous less notable changes & improvements.",
		"#F_Fixes:_#",
		"Widget Tools will no longer copies of its Settings after each loading screen.",
		"Settings should now be properly saved in Dragonflight, the custom Restore Defaults and Revert Changes functionalities should also work as expected now, on a per Settings page basis (with the option of restoring defaults for the whole addon kept).",
		"All other open custom Context Submenus on the same level should now close when one is opened (more Context Menu improvements are planned for a later release).",
		"Many other under the hood fixes.",
	},
	{
		"#V_Version 1.5_# #H_(11/28/2020)_#",
		"#H_Widget Tools has been supporting other addons in the background for over a year. Now, it has been separated into its own addon for more visibility, transparency and to offer wider development options._#",
     	"#N_Update:_#",
		"Added Dragonflight (Retail 10.0) support with backwards compatibility.",
	},
}


--[[ LOCALIZATIONS ]]

--# flags will be replaced with code
--\n represents the newline character

local english = {
	about = {
		version = "Version: #VERSION",
		date = "Date: #DATE",
		author = "Author: #AUTHOR",
		license = "License: #LICENSE",
		toggle = {
			label = "Enabled",
			tooltip = "Shortcut to disable this addon.\n\nThis change will only take effect after the interface is reloaded. Once it has been disabled, this addon will not show up in this list until it's reenabled within the main AddOns menu.",
		},
	},
	specifications = {
		title = "Specifications",
		description = "Tune & toggle select optional features. Type /wt in chat to use chat commands.",
		general = {
			title = "General",
			description = "Options affecting all reliant addons.",
			lite = {
				label = "Lite Mode",
				tooltip = "Disable the settings of ALL addons using Widget Toolboxes to conserve resources and make the interface load faster.\nAddon settings data will still be saved & loaded in the background, and chat control will remain available for addons that use it.\n\nTo turn Lite Mode off and settings back on, use the #COMMAND chat command, or click on Widget Tools within the AddOns list under the calendar button in the header of the Minimap (not available in Classic)",
			},
			positioningAids = {
				label = "Positioning Visual Aids",
				tooltip = "Display visual aids when positioning frames wia settings widgets of addons which use Widget Toolboxes under the hood.\n\nNot yet available in Classic.", --TODO fix in Classic
			},
		},
		dev = {
			title = "Development Tools",
			description = "Useful tools and nobs for developers.",
			frameAttributes = {
				enabled = {
					label = "Resize Frame Attributes Table",
					tooltip = "Customize the width of the table inside the Frame Attributes window (TableAttributeDisplay Frame).",
				},
				width = {
					label = "Frame Attributes Table Width",
					tooltip = "Specify the width of the scrollable content table in the Frame Attributes window.",
				},
			},
		},
	},
	addons = {
		title = "Addons & Toolboxes",
		description = "The list of currently loaded addons using specific versions of registered #ADDON toolboxes.",
		old = {
			title = "Old versions",
			description = "Versions of toolboxes older than 1.5 don't have addon data. It is visible if they are in use, however.",
			none = "There are no recognized older versions of #ADDON toolboxes currently in use.",
			inUse = "Old toolboxes currently in use:#TOOLBOXES",
		},
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Click to open specific settings.",
		lite = "Lite mode is enabled. Click to disable.",
	},
	lite = {
		enable = {
			warning = "When #ADDON is in Lite Mode, the settings UI for dependant addons will not be loaded.\n\nAre you sure you want to turn on Lite Mode and disable full settings functionality?",
			accept = "Enable Lite Mode",
		},
		disable = {
			warning = "#ADDON is in Lite Mode, the settings UI for dependant addons have not been loaded.\n\nDo you wish to turn off Lite Mode to reenable settings with full functionality?",
			accept = "Disable Lite Mode",
		},
	},
	chat = {
		about = {
			description = "Open the Widget Tools about page",
		},
		lite = {
			description = "Toggle Lite Mode: to load dependant addon settings or not",
			response = "Lite Mode will be #STATE after the interface is reloaded.",
			reminder = "Lite Mode is enabled, settings for dependant addons have not been loaded.\nType #COMMAND to disable Lite Mode.",
		},
		dump = {
			description = "List out the Widget Tools settings data",
		},
		run = {
			description = "Run a WidgetToolbox function with the provided parameters (separated by a semicolon [;] character after the name of the function).\nExample: #EXAMPLE",
			success = "Run command initiated successfully.",
			error = "Run command failed.",
		},
	},
	date = "#MONTH/#DAY/#YEAR",
}

--Load the proper localization table based on the client language
local function LoadLocale()
	local locale = GetLocale()

	if (locale == "") then
		--TODO: Add localization for other languages (locales: https://wowpedia.fandom.com/wiki/API_GetLocale#Values)
		--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml#L8
	else --Default: English (UK & US)
		ns.strings = english
	end
end


--[[ ASSETS ]]

--Chat commands
ns.chat = {
	keyword = "wt",
	commands = {
		about = "about",
		lite = "lite",
		dump = "dump",
		run = "run",
	}
}

--Strings
LoadLocale()

--Colors
ns.colors = {
	grey = {
		{ r = 0.7, g = 0.7, b = 0.7 },
		{ r = 0.54, g = 0.54, b = 0.54 },
	},
	gold = {
		{ r = 1, g = 0.76, b = 0.07 },
		{ r = 0.8, g = 0.62, b = 0.1 },
	},
	halfTransparent = {
		grey = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 },
		blue = { r = 0.7, g = 0.9, b = 1, a = 0.5 },
		yellow = { r = 1, g = 0.9, b = 0.7, a = 0.5 },
	}
}

--Textures
ns.textures = {
	logo = root .. "Textures/Logo.tga",
	missing = root .. "Textures/MissingLogo.tga",
	alphaBG = root .. "Textures/AlphaBG.tga",
	gradientBG = root .. "Textures/GradientBG.tga",
}


--[[ DATA ]]

--Default values
ns.defaults = {
	lite = false,
	positioningAids = true,
	frameAttributes = {
		enabled = false,
		width = 620,
	},
}