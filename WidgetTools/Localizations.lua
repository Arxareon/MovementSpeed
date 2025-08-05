--[[ NAMESPACE ]]

---@class WidgetToolsNamespace
local ns = select(2, ...)


--[[ LOCALIZATIONS (WoW locales: https://warcraft.wiki.gg/wiki/API_GetLocale#Values) ]]

ns.localizations = {}

--TODO: verity AI translations (from enUS)
--TODO: adjust the date formats for the translated languages

--# flags will be replaced by text or number values via code
--\n represents the newline character

--[ English ]

ns.localizations.enUS = {
	about = {
		version = "Version: #VERSION",
		date = "Date: #DATE",
		author = "Author: #AUTHOR",
		license = "License: #LICENSE",
		toggle = {
			label = "Enabled",
			tooltip = "Uncheck to disable this addon.\n\nThis change will only take effect after the interface is reloaded. Once it has been disabled, this addon will not show up in this list until it's reenabled within the main AddOns menu.",
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
				tooltip = "Display visual aids when positioning frames wia settings widgets of addons which use Widget Toolboxes under the hood.",
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
			reminder = "Lite Mode is enabled, settings for dependant addons have not been loaded.\n#HINT",
			hint = "Type #COMMAND to disable Lite Mode.",
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