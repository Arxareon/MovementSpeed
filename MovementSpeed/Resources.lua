--[[ RESOURCES ]]

---Addon namespace table
---@class MovementSpeedNamespace
---@field name string Addon namespace name
local ns = select(2, ...)

ns.name = ...

--Addon root folder
local root = "Interface/AddOns/" .. ns.name .. "/"


--[[ CHANGELOG ]]

ns.changelog = {
	{
		"#V_Version 1.0_# #H_(10/26/2020)_#",
		"#H_It's alive!_#",
		"If you have suggestions or problems, please don't hesitate to let me know in a comment!",
		"You can use the #H_/movespeed_# chat command to set up the text display as you'd like.",
	},
	{
		"#V_Version 1.0.1_# #H_(10/26/2020)_#",
		"#F_Hotfix:_#",
		"Fixed an issue with #H_/movespeed_# and #H_/movespeed help_# commands bringing up Remaining XP messages instead (if you were using both addons - check that out too btw). Oops.. how could that even happen?",
	},
	{
		"#V_Version: 1.1.0_# #H_(3/12/2021)_#",
		"#C_Update:_#",
		"Expanded functionality to also calculate the movement speed while in a vehicle. Finally!",
		"#F_Hotfix:_#",
		"Fixed all potential issues with previously non-local functions.",
	},
	{
		"#V_Version 1.2_# #H_(4/19/2021)_#",
		"#C_Update:_#",
		"Added 9.1 (with 9.0.5 still being supported!), Classic (1.13.7) and Burning Crusade Classic (2.5.1) multi-version support.",
	},
	{
		"#V_Version 1.3_# #H_(6/30/2021)_#",
		"#C_Updates:_#",
		"Added the ability to change the font size of the text display via chat commands. See #H_/movespeed help_# for details.",
		"Added data table checkup to allow for feature expansion in the future - like changing fonts, colors and more.",
		"Code cleanup.",
	},
	{
		"#V_Version 2.0_# #H_(11/3/2021)_#",
		"Support for 9.1.5 has been added (support for Season of Mastery will be added when it launches).",
		"#N_New features:_#",
		"#H_Interface Options:_# buttons, sliders, dropdowns and more have been added as alternatives to chat commands (some new options are not available as chat commands).",
		" • #H_New options:_# Font family & color customization options have been added besides font size (with a fully custom font type option - see the in-game tooltip in the settings)\n • #H_New option:_# Background graphic (with customizable color)\n • #H_New option:_# Raise (or lower) display among other UI elements\n • #H_New feature:_# Import/Export to backup or move your settings between accounts (with the ability to manually edit them - for advanced coders)",
		"The main display will be moved to the default position when the preset or the options are being reset.",
		"The display now hides during pet battles (thanks for the request! <3).",
		"Added localization support, so more languages can be supported besides English in the future (more info soon on how you can help me translate!).",
		"Various other improvements, fixes & cleanup.",
	},
	{
		"#V_Version 2.1_# #H_(11/16/2021)_#",
		"#C_Update:_#",
		"Added support for Season of Mastery.",
	},
	{
		"#V_Version 2.1.1_# #H_(11/18/2021)_#",
		"#F_Hotfix:_#",
		"Minor under the hood fixes and changes.",
	},
	{
		"#V_Version 2.2_# #H_(3/17/2022)_#",
		"#O_Movement Speed has been released on Wago!_#\n#H_Next to CurseForge, it can now also be updated through the Wago app as well as WoWUp if you enable Wago.io as an addon provider._#",
		"#H_Thank you for using my addons! Should you wish to support their development further, the Wago Subscription is now a new way to do so. <3_#",
		"#N_New:_#",
		"#H_New feature: Target speed!_#\nView the current movement speed of any player or NPC you inspect via mouseover. (Customize this integration in the interface options.)",
		"Added 9.2 (Retail), 1.14.2 (Classic) and 2.5.3 (BCC) multi-version support.",
		"Updated the look and feel of the interface options to be on par with the Remaining XP addon. #H_Right-click on the speed display to open specific options pages._#",
		"Added an about page with options page shortcuts, addon info with a changelog, and useful links.",
		"Added speed value text customization options: % and/or y/s & decimal places.",
		"Added an option to auto-hide the display when your character is not moving.",
		"Added the option to fine-tune the position of the speed display.",
		"Added a preset selector (with room to add more display presets in the future).",
		"Added an option to change the border color of the display background.",
		"Added a helpful tooltip to the display which currently shows your movement speed percentage and its equivalent in yards / second.",
		"#C_Changes:_#",
		"The saved display position will now be automatically applied on login for all characters.",
		"Hiding the speed display will now be character-specific.",
		"The Import/Export string editor can now be switched off of compact mode, making code review and manual edits easier. Also, the contents have been color coded for better readability.",
		"Several chat command descriptions and responses have been updated.",
		"The addon description has been updated.",
		"Additional changes & small fixes.",
		"#O_Coming soon:_#",
		"Options profiles for character-specific customization.",
		"Different styles and looks for the speed display.",
		"Some cool new features are being explored, more on that soon™!",
	},
	{
		"#V_Version 2.2.1_# #H_(3/19/2022)_#",
		"#F_Hotfix:_# #H_Thank you for your reports! Expect further fixes in the coming days should any problems remain._#",
		"I wasn't able to reproduce any of the problems reported recently, but hopefully this quick patch should help. \nPlease, keep reporting them with information such as when/how they occur, what WoW version and other addons you are using if you can. If the bugs don't happen for me, it's hard to get a grip on them - but I try! :)",
		"Fixed the issue of the speed display tooltip not disappearing under the bags or other frames.",
	},
	{
		"#V_Version 2.2.2_# #H_(3/20/2022)_#",
		"#F_Hotfix:_# #H_Thank you for your reports!_#",
		"Fixed an error that popped up when mousing over the speed display in the Retail version.",
	},
	{
		"#V_Version 2.2.3_# #H_(3/23/2022)_#",
		"#N_Update:_#",
		"New hints have been added to the speed display tooltip.",
		"Chat responses have been added when the speed display is dragged to confirm when the position is saved.",
		"Added 2.5.4 (BCC) support.",
		"#C_Change:_#",
		"The repositioning of the speed display will now be cancelled when SHIFT is released before the mouse button.",
		"The tooltips have been adjusted to fit in more with the base UI.",
		"#F_Hotfix:_# #H_Thank you for your reports!_#",
		"Further minor fixes to dodge LUA errors and improve reliability.\n#H_If you encounter any more issues, please, consider reporting them! Try to include when/how they occur, and which addons are you using to give me the best chance to be able to reproduce and fix them._#",
	},
	{
		"#V_Version 2.2.4_# #H_(7/5/2022)_#",
		"#N_Update:_#",
		"Added 9.2.5 (Retail) and 1.14.3 (Classic) support.",
		"Numerous under the hood changes & improvements.",
		"#F_Hotfix:_# #H_Thank you for your reports!_#",
		"Fixed the issue of the Speed Display tooltip sometimes appearing and being stuck on the screen.",
	},
	{
		"#V_Version 2.2.5_# #H_(7/9/2022)_#",
		"#F_Hotfix:_#",
		"Fixed an error that popped up when clicking on a color picker button.",
	},
	{
		"#V_Version 2.2.6_# #H_(8/20/2022)_#",
		"#N_Update:_#",
		"Added 9.2.7 (Retail) and 3.4 (WotLK Classic) support.",
		"Under the hood changes & improvements.",
		"#C_Change_# - left out of 2.2.6, included in a hotfix: #V_Version 2.2.6.1_# #H_(8/21/2022)_#:",
		"Movement Speed has moved from Bitbucket to GitHub. Links to the Repository & Issues have been updated.\n#H_There is now an opportunity to Sponsor my work on GitHub to support and justify the continued development of my addons should you wish and have the means to do so. Every bit of help is appreciated!_#",
	},
	{
		"#V_Version 2.3_# #H_(11/28/2022)_#",
		"#N_Update:_#",
		"Added Dragonflight (Retail 10.0) support.",
		"Added vehicle speed support for Wrath of the Lich King Classic.",
		"Significant under the hood changes & improvements, including new UI widgets and more functionality.",
		"Apply quick display presets right from the context menu (Dragonflight only, for now).",
		"Other smaller changes like an updated logo or improved data restoration from older versions of the addon.",
		"#F_Fix:_#",
		"Fixed an uncommon target speed tooltip related issue.",
	},
	{
		"#V_Version 2.4_# #H_(2/7/2023)_#",
		"#N_Updates:_#",
		"A new Sponsors section has been added to the main Settings page.\n#H_Thank you for your support! It helps me continue to spend time on developing and maintaining these addons. If you are considering supporting development as well, follow the links to see what ways are currently available._#",
		"#H_New feature: Travel Speed! (Dragonflight-only, currently in beta)_# Enable this feature to calculate an estimated value of the actual speed at which you are moving through the game world horizontally at any given moment.\nThe old functionality only showed what your character was capable of moving, or in other words, your maximum speed at any time. Moving up or down in elevation would reduce your effective travel speed.\nThere was no way for addons to access your player speed information while Dragonriding, however, this new feature will still work and provide speed info while soaring the skies.",
		"Added the option to slow down and specify the rate at which movement speed values are recalculated.",
		"The About info has been rearranged and combined with the Support links.",
		"Only the most recent update notes will be loaded now. The full Changelog is available in a bigger window when clicking on a new button.",
		"Made checkboxes more easily clickable, their tooltips are now visible even when the input is disabled.",
		"The backup string in the Advanced settings will now be updated live as changes are made.",
		"Added 10.0.5 (Dragonflight) & 3.4.1 (WotLK Classic) support.",
		"Numerous less notable changes & improvements.",
		"#F_Fixes:_#",
		"Widget Tools will no longer copies of its Settings after each loading screen.",
		"Settings should now be properly saved in Dragonflight, the custom Restore Defaults and Revert Changes functionalities should also work as expected now, on a per Settings page basis (with the option of restoring defaults for the whole addon kept).",
		"Many other under the hood fixes.",
	},
	{
		"#V_Version 2.5_# #H_(3/10/2023)_#",
		"#H_The new Travel Speed (Dragonflight only) beta feature added in the previous version will still remain as it is for now. If you have thoughts on it, I'd love to hear your feedback!_#",
		"#N_Updates:_#",
		"Added a new option to change the text alignment of the Speed Display.",
		"The Position Offset sliders now support changing the value by 1 point via holding the ALT key to allow for quick fine tuning.",
		"Added 10.0.7 (Dragonflight) support.",
		"#C_Changes:_#",
		"The Shortcuts section form the main settings page has been removed in Dragonflight (since the new expansion broke the feature - I may readd it when the issue gets resolved).",
		"The Font Family selection dropdown menu now provides a preview of how the fonts look.",
		"Several other under the hood changes & improvements.",
		"#F_Fixes:_#",
		"Fixed the \"Invalid region point\" error caused after adjusting the anchor point of the display via the settings or when loading the incorrectly saved position data.\nThe Speed Display Anchor Point setting has been restored to its default value for those affected.",
		"Fixed the issue of the font family only being changed when flipping through the menu with the side buttons and not when opening the menu and selecting them directly.",
		"The \"size\" chat command will now also update the font size of the Travel Speed display without requiring a UI reload.",
		"The Travel Speed and Player Speed displays will no longer overlap each other.",
		"Other smaller fixes.",
	},
	{
		"#V_Version 2.6_# #H_(5/4/2023)_#",
		"#N_New:_#",
		"Added 10.1 (Dragonflight) support.",
		"The (Dragonflight-only) Travel Speed feature is now out of beta as the speed value accuracy has been greatly improved.\n#H_This doesn't mean the feature won't be further improved with more functionality and customization options! If you have some ideas and valuable feedback, I'd love to hear it (see the About info for links)!_#",
		"Added coordinates per second as a speed vale unit type option (for Dragonflight only). Any combination of the current 3 types can be selected.",
		"The speed display tooltip will now include the size of the current zone map in yards (in Dragonflight only).",
		"There's now an option to use the speed value text coloring used in the Target Speed inspect tooltip for the main displays as well.",
		"Replaced the \"Appear on top\" checkbox with a new Screen Layer selector (now in the Position section) to allow for more adjustability.",
		"Added a Reset Custom Preset button to the settings.",
		"Added a new \"defaults\" chat command, replacing the old \"reset\" command which now performs the Custom preset restoring functionality.",
		"#C_Changes:_#",
		"Some settings have been rearranged, the preset options have been moved to the Position panel.",
		"The options shortcuts in the speed display right-click context menu have been replaced with a single button opening the main addon settings page in Dragonflight (until Blizzard readds the support for addons to open settings subcategories).",
		"The default value of the throttled speed update frequency will now be once every 0.15 seconds to be a bit more readable from the start.",
		"The \"As a Replacement\" option for the Travel Speed display will now be on by default.",
		"The Travel Speed display will now also have a detailed speed tooltip displaying Travel Speed values. It will also support the right-click menu.",
		"General polish & other smaller changes.",
		"#F_Fixes:_#",
		"The old scrollbars have been replaced with the new scrollbars in Dragonflight, fixing any bugs that emerged with 10.1 as a result of deprecation.",
		"The Target Speed feature will now be properly enabled without requiring a UI reload.",
		"Turning on the Travel Speed feature for the first time after logging in should now hopefully set up its position and background properly.",
		"The Speed Display Anchor Point setting will properly be updated when a preset is applied or the display is moved manually.",
		"Several old and inaccurate descriptions and tooltips have been updated.",
		"Other minor fixes & improvements.",
	},
	{
		"#V_Version 2.7_# #H_(5/17/2023)_#",
		"#F_Fixes:_#",
		"Fixed an issue with actions being blocked after closing the Settings panel in certain situation (like changing Keybindings) in Dragonflight.",
		"The current version will now run in the WotLK Classic 3.4.2 PTR but it's not yet fully polished (as parts of the UI are still being modernized).",
		"Other minor improvements.",
	},
	{
		"#V_Version 2.8_# #H_(6/15/2023)_#",
		"#C_Updates:_#",
		"Added 10.1.5 (Dragonflight) support.",
		"Chat notifications will be shown when changing the Custom preset via the Settings. Also, the preset selection will now reset when the display is moved manually while the Settings window was open.",
		"The Individual Value Coloring option will now be on by default.",
		"#F_Fixes:_#",
		"The speed displays will not appear after a pet battle when they are set as hidden.",
		"Importing addon data through the Backup Advanced options will keep the currently set values when filling in missing or invalid values instead of using defaults.",
		"No tooltip will stay on the screen after its target was hidden.",
		"Under the hood fixes & improvements.",
	},
	{
		"#V_Version 2.9_# #H_(8/5/2023)_#",
		"#C_Changes:_#",
		"Positioning the speed displays next to other frames via Presets (like Under Minimap) will now dynamically be updated to follow those frames instead of being assigned to a static position. After you move a frame, reapply the desired now updated preset to move the display back in relation to it.",
		"The Travel Speed feature (offering estimated speed values even during Dragonriding) will now be enabled by default (as a replacement when the Player Speed value is not available).",
		"Added more value step options to the other sliders as well. The default step value is now 1 for the position offset values.",
		"The settings category page shortcuts have been removed in WotLK Classic (because the new Settings window broke the feature - I may readd them when the issue gets resolved). The shortcuts have been replaced by an Options button in the right-click menu of the speed displays.",
		"The custom context menus have been replaced with the basic menu until their quirks are ironed out.",
		"Scrolling has been improved in WotLK Classic.",
		"Other small fixes, changes & improvements.",
	},
	{
		"#V_Version 3.0_# #H_(2/20/2024)_#",
		"#C_Changes:_#",
		"Shortcuts have been removed from the main addon settings page in Classic.",
		"Significant under the hood improvements.",
		"#H_If you encounter any issues, do not hesitate to report them! Try including when & how they occur, and which other addons are you using to give me the best chance of being able to reproduce & fix them. Try proving any LUA script error messages and if you know how, taint logs as well (when relevant). Thanks a lot for helping!_#",
	},
}


--[[ LOCALIZATIONS ]]

--# flags will be replaced with code
--\n represents the newline character

local english = {
	options = {
		main = {
			name = "About",
			description = "Customize #ADDON to fit your needs. Type #KEYWORD for chat commands.",
			shortcuts = {
				title = "Shortcuts",
				description = "Access specific options by expanding the #ADDON categories on the left or by clicking a button here.",
			},
		},
		speedValue = {
			title = "Speed Value",
			description = "Specify how the speed value should be displayed.",
			units = {
				label = "Displayed Units",
				tooltip = "Select which unit types should be present in the speed value text.",
				list = {
					{
						label = "Percentage",
						tooltip = "Show the speed value as a percentage of the base running speed (which is 7 yards per second)."
					},
					{
						label = "Yards/second",
						tooltip = "Show the speed value as distance in yards traveled per second.",
					},
					{
						label = "Coordinates/second",
						tooltip = "Show the speed value as distance in coordinates traveled per second.",
					},
				},
			},
			fractionals = {
				label = "Max Fractional Digits",
				tooltip = "Set the maximal number of decimal places that should be displayed in the fractional part of the speed values.\n\nEach speed value will be rounded to the nearest number based on the decimal accuracy specified here.\n\nCoordinate values are always displayed with at least one fractional digit.",
			},
			zeros = {
				label = "Show trailing zeros",
				tooltip = "Always show the specified number of decimal digits, don't trim trailing zeros.",
			},
		},
		speedDisplay = {
			title = "#TYPE Display",
			referenceName = "the #TYPE display",
			copy = {
				label = "Copy #TYPE values",
				tooltip = "Set these options to mirror the values of matching options set for the #TITLE.",
			},
			visibility = {
				title = "Visibility",
				description = "Set the visibility and behavior of the #ADDON display.",
				hidden = {
					label = "Hidden",
					tooltip = "Enable or disable the #ADDON displays.",
				},
				autoHide = {
					label = "Hide while stationary",
					tooltip = "Automatically hide the speed display while you are not moving.",
				},
				statusNotice = {
					label = "Chat notice if hidden",
					tooltip = "Get a chat notification about the status of the speed display if it's not visible after the interface loads.",
				},
			},
			update = {
				throttle = {
					label = "Throttle Updates",
					tooltip = "Slow the update rate of the speed value to match the specified #FREQUENCY instead of the framerate.\n\nThis will improve CPU performance by a small amount.",
				},
				frequency = {
					label = "Update Frequency",
					tooltip = "Set how many times the speed value should be updated every second.",
				},
			},
			font = {
				title = "Font & Text",
				description = "Customize the appearance of the speed value text.",
				family = {
					label = "Font",
					tooltip = "Select the font of the speed value text.",
					default = "This is a default font used by Blizzard.",
					custom = {
						"You may set the #OPTION_CUSTOM option to any font of your liking by replacing the #FILE_CUSTOM file with another TrueType Font file found in:",
						"while keeping the original #FILE_CUSTOM name.",
						"You may need to restart the game client after replacing the Custom font file.",
					},
				},
				size = {
					label = "Font Size",
					tooltip = "Set the size of the displayed text.",
				},
				valueColoring = {
					label = "Individual Value Coloring",
					tooltip = "Color the speed values in the display with the default #ADDON color palette.",
				},
				color = {
					label = "Font Color",
					tooltip = "The color of the entire speed value text when the #VALUE_COLORING option is turned off.",
				},
				alignment = {
					label = "Text Alignment",
					tooltip = "Select the horizontal alignment of the text inside the speed display.",
				},
			},
			background = {
				title = "Background",
				description = "Toggle and customize the background graphic.",
				visible = {
					label = "Visible",
					tooltip = "Toggle the visibility of the background elements of speed display.",
				},
				colors = {
					bg = {
						label = "Background Color",
					},
					border = {
						label = "Border Color",
					},
				},
			},
		},
		playerSpeed = {
			title = "Player Speed",
			description = "Calculate your speed, modified by your Speed stat, mounts, buffs, debuffs or the type movement activity.",
		},
		travelSpeed = {
			title = "Travel Speed",
			description = "Calculate the estimated speed at which you are actually traveling through the current zone horizontally.",
		},
		targetSpeed = {
			title = "Target Speed",
			description = "View the current movement speed of any player or NPC you are inspecting via mouseover.",
			mouseover = {
				title = "Inspect Tooltip",
				description = "Toggle and specify how the movement speed of your mouseover target is shown in the inspect tooltip.",
				enabled = {
					label = "Enable Integration",
					tooltip = "Enable or disable the #ADDON integration within the mouseover target inspect tooltip."
				},
			},
		},
	},
	presets = {
		"Under Minimap",
		"Under #TYPE display",
		"Above #TYPE display",
		"Right of #TYPE display",
		"Left of #TYPE display",
	},
	chat = {
		status = {
			visible = "The speed display is visible (#AUTO).",
			notVisible = "The speed display is not visible (#AUTO).",
			hidden = "The speed display is hidden (#AUTO).",
			auto = "auto-hide: #STATE",
		},
		help = {
			thanks = "Thank you for using #ADDON!",
			hint = "Type #HELP_COMMAND to see the full command list.",
			move = "Hold SHIFT to drag the #ADDON display anywhere you like.",
			list = "chat command list",
		},
		options = {
			description = "open the #ADDON options",
		},
		preset = {
			description = "apply a speed display preset (e.g. #INDEX)",
			response = "The #PRESET speed display preset was applied.",
			unchanged = "The preset could not be applied, no changes were made.",
			error = "Please enter a valid preset index (e.g. #INDEX).",
			list = "The following presets are available:",
		},
		save = {
			description = "save this speed display setup as the #CUSTOM preset",
			response = "The current speed display position and visibility was saved to the #CUSTOM preset.",
		},
		reset = {
			description = "reset the #CUSTOM preset to its default state",
			response = "The #CUSTOM preset has been reset to the default preset.",
		},
		toggle = {
			description = "show or hide the speed display (#HIDDEN)",
			hiding = "The speed display has been hidden.",
			unhiding = "The speed display has been made visible.",
			hidden = "hidden",
			notHidden = "not hidden",
		},
		auto = {
			description = "hide the speed display while stationary (#STATE)",
			response = "The speed display automatic hide was set to #STATE.",
		},
		size = {
			description = "change the font size (e.g. #SIZE)",
			response = "The font size was set to #VALUE.",
			unchanged = "The font size was not changed.",
			error = "Please enter a valid number value (e.g. #SIZE).",
		},
		profile = {
			description = "activate a settings profile",
			response = "The #PROFILE settings profile was activated.",
			unchanged = "The profile could not be activated, no changes were made.",
			error = "Please enter a valid profile name or index (e.g. #INDEX).",
			list = "The following profiles are available:",
		},
		defaults = {
			description = "restore the active profile to defaults",
			response = "The active #PROFILE settings profiles has been reset to defaults.",
		},
		position = {
			save = "The speed display position was saved.",
			cancel = "The repositioning of the speed display was cancelled.",
			error = "Hold SHIFT until the mouse button is released to save the position.",
		},
	},
	targetSpeed = "Speed: #SPEED",
	speedTooltip = {
		title = "#SPEED details:",
		description = "Live movement status summary.",
		playerSpeed = "Calculated based on the type of your current movement activity, modified by the Speed stat and various buffs, debuffs, mounts & other effects.",
		travelSpeed = "Estimated by tracking your horizontal movement through the current zone, negatively affected by obstacles and the angle of movement during flight.",
		text = {
			"#YARDS yards / second.",
			"#PERCENT of the base running speed.",
			"#COORDS coordinates / second.",
		},
		mapTitle = "Current zone: #MAP",
		mapSize = "Map size: #SIZE",
		mapSizeValues = "#W x #H yards",
		hintOptions = "Right-click to access specific options.",
		hintMove = "Hold SHIFT & drag to reposition.",
	},
	speedValue = {
		yardsps = "#YARDS yards/s",
		yps = "#YARDS y/s",
		coordsps = "#COORDS coords/s",
		cps = "#COORDS c/s",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR",
		options = "Options",
		default = "Default",
		custom = "Custom",
		enabled = "enabled",
		disabled = "disabled",
		days = "days",
		hours = "hours",
		minutes = "minutes",
		seconds = "seconds",
	},
}

--Load the proper localization table based on the client language
local LoadLocale = function()
	local locale = GetLocale()

	if (locale == "") then
		--TODO: Add localization for other languages (locales: https://wowwiki-archive.fandom.com/wiki/API_GetLocale#Locales)
		--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml
	else --Default: English (UK & US)
		ns.strings = english
		ns.strings.defaultFont = UNIT_NAME_FONT_ROMAN:gsub("\\", "/")
	end

	--Fill static & internal references
	ns.strings.options.main.description = ns.strings.options.main.description:gsub(
		"#KEYWORD", "/" .. ns.chat.keyword
	)
	ns.strings.options.speedDisplay.copy.tooltip = ns.strings.options.speedDisplay.copy.tooltip:gsub(
		"#TITLE", ns.strings.options.speedDisplay.title
	)
	ns.strings.options.speedDisplay.update.throttle.tooltip = ns.strings.options.speedDisplay.update.throttle.tooltip:gsub(
		"#FREQUENCY", ns.strings.options.speedDisplay.update.frequency.label
	)
	ns.strings.options.speedDisplay.font.color.tooltip = ns.strings.options.speedDisplay.font.color.tooltip:gsub(
		"#VALUE_COLORING", ns.strings.options.speedDisplay.font.valueColoring.label
	)
end


--[[ ASSETS ]]

--Chat commands
ns.chat = {
	keyword = "movespeed",
	commands = {
		help = "help",
		options = "options",
		preset = "preset",
		save = "save",
		reset = "reset",
		toggle = "toggle",
		auto = "auto",
		size = "size",
		defaults = "defaults",
	}
}

--Strings
LoadLocale()

--Colors
ns.colors = {
	grey = {
		{ r = 0.54, g = 0.54, b = 0.54 },
		{ r = 0.7, g = 0.7, b = 0.7 },
	},
	yellow = {
		{ r = 1, g = 0.87, b = 0.28 },
		{ r = 1, g = 0.98, b = 0.60 },
	},
	green = {
		{ r = 0.31, g = 0.85, b = 0.21 },
		{ r = 0.56, g = 0.91, b = 0.49 },
	},
	blue = {
		{ r = 0.33, g = 0.69, b = 0.91 },
		{ r = 0.62, g = 0.83, b = 0.96 },
	},
}

--Fonts
ns.fonts = {
	{ name = ns.strings.misc.default, path = ns.strings.defaultFont, widthRatio = 1 },
	{ name = "Arbutus Slab", path = root .. "Fonts/ArbutusSlab.ttf", widthRatio = 1.07 },
	{ name = "Caesar Dressing", path = root .. "Fonts/CaesarDressing.ttf", widthRatio = 0.84 },
	{ name = "Germania One", path = root .. "Fonts/GermaniaOne.ttf", widthRatio = 0.86 },
	{ name = "Mitr", path = root .. "Fonts/Mitr.ttf", widthRatio = 1.07 },
	{ name = "Oxanium", path = root .. "Fonts/Oxanium.ttf", widthRatio = 0.94 },
	{ name = "Pattaya", path = root .. "Fonts/Pattaya.ttf", widthRatio = 0.87 },
	{ name = "Reem Kufi", path = root .. "Fonts/ReemKufi.ttf", widthRatio = 0.92 },
	{ name = "Source Code Pro", path = root .. "Fonts/SourceCodePro.ttf", widthRatio = 1.11 },
	{ name = ns.strings.misc.custom, path = root .. "Fonts/CUSTOM.ttf", widthRatio = 1.2 },
}

--Textures
ns.textures = {
	logo = root .. "Textures/Logo.tga",
}


--[[ DATA ]]

--Default values
ns.profileDefault = {
	mainDisplay = "playerSpeed",
	customPreset = {
		position = {
			anchor = "TOP",
			relativePoint = "TOP",
			offset = { x = 0, y = -60 },
		},
		keepInBounds = true,
		layer = {
			strata = "MEDIUM",
			keepOnTop = false,
		},
	},
	playerSpeed = {
		visibility = {
			hidden = false,
			autoHide = false,
			statusNotice = true,
		},
		position = {
			anchor = "TOP",
			relativePoint = "TOP",
			offset = { x = 0, y = -60 },
		},
		keepInBounds = true,
		layer = {
			strata = "MEDIUM",
			keepOnTop = false,
		},
		update = {
			throttle = false,
			frequency = 0.15,
		},
		value = {
			units = { true, false, false },
			fractionals = 0,
			zeros = false,
		},
		font = {
			family = ns.fonts[1].path,
			size = 11,
			valueColoring = true,
			color = { r = 1, g = 1, b = 1, a = 1 },
			alignment = "CENTER",
		},
		background = {
			visible = false,
			colors = {
				bg = { r = 0, g = 0, b = 0, a = 0.5 },
				border = { r = 1, g = 1, b = 1, a = 0.4 },
			},
		},
	},
	travelSpeed = {
		visibility = {
			hidden = true,
			autoHide = false,
			statusNotice = true,
		},
		position = {
			anchor = "TOP",
			relativePoint = "TOP",
			offset = { x = 0, y = -60 },
		},
		keepInBounds = true,
		layer = {
			strata = "MEDIUM",
			keepOnTop = false,
		},
		update = {
			throttle = true,
			frequency = 0.15,
		},
		value = {
			units = { true, false, false },
			fractionals = 0,
			zeros = false,
		},
		font = {
			family = ns.fonts[1].path,
			size = 11,
			valueColoring = true,
			color = { r = 1, g = 1, b = 1, a = 1 },
			alignment = "CENTER",
		},
		background = {
			visible = false,
			colors = {
				bg = { r = 0, g = 0, b = 0, a = 0.5 },
				border = { r = 1, g = 1, b = 1, a = 0.4 },
			},
		},
	},
	targetSpeed = {
		enabled = true,
		value = {
			units = { true, true, false },
			fractionals = 0,
			zeros = false,
		},
	},
}