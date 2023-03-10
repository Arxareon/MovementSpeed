--[[ RESOURCES ]]

---Addon namespace
---@class ns
local addonNameSpace, ns = ...

--Addon root folder
local root = "Interface/AddOns/" .. addonNameSpace .. "/"


--[[ CHANGELOG ]]

local changelogDB = {
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
		"#H_If you encounter any issues, do not hesitate to report them! Try including when & how they occur, and which other addons are you using to give me the best chance of being able to reproduce & fix them. Try proving any LUA script error messages and if you know how, taint logs as well (when relevant). Thanks a lot for helping!_#",
	}
}

---Get an assembled & formatted string of the full changelog
---@param latest? boolean Whether to get the update notes of the latest version or the entire changelog | ***Default:*** false
---@return string
ns.GetChangelog = function(latest)
	--Colors
	local highlight = "FFFFFFFF"
	local new = "FF66EE66"
	local fix = "FFEE4444"
	local change = "FF8888EE"
	local note = "FFEEEE66"
	--Assemble the changelog
	local changelog = ""
		for i = #changelogDB, 1, -1 do
			local firstLine = latest and 2 or 1
			for j = firstLine, #changelogDB[i] do
				changelog = changelog .. (j > firstLine and "\n\n" or "") .. changelogDB[i][j]:gsub(
					"#V_(.-)_#", (i < #changelogDB and "\n\n\n" or "") .. "|c" .. highlight .. "• %1|r"
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
	return changelog
end


--[[ LOCALIZATIONS ]]

local english = {
	options = {
		main = {
			name = "Main page",
			description = "Customize #ADDON to fit your needs. Type #KEYWORD for chat commands.", --# flags will be replaced with code
			shortcuts = {
				title = "Shortcuts",
				description = "Access specific options by expanding the #ADDON categories on the left or by clicking a button here.", --# flags will be replaced with code
			},
			about = {
				title = "About",
				description = "Thanks for using #ADDON! Copy the links to see how to share feedback, get help & support development.", --# flags will be replaced with code
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
					tooltip = "Notes of all the changes, updates & fixes introduced with the latest version.\n\nThe changelog is only available in English for now.", --\n represents the newline character
				},
				openFullChangelog = {
					label = "Open the full Changelog",
					tooltip = "Access the full list of update notes of all addon versions.",
				},
				fullChangelog = {
					label = "#ADDON Changelog", --# flags will be replaced with code
					tooltip = "Notes of all the changes included in the addon updates for all versions.\n\nThe changelog is only available in English for now.", --\n represents the newline character
				},
			},
			sponsors = {
				title = "Sponsors",
				description = "Your continued support is greatly appreciated! Thank you!",
			},
			feedback = {
				title = "Feedback",
				description = "Visit #ADDON online if you have something to report.", --# flags will be replaced with code
			},
		},
		speedValue = {
			title = "Speed Value",
			description = "Customize how should the speed value appear.",
			type = {
				label = "Show Speed as…",
				tooltip = "Show the movement speed value as a percentage of the base running speed, its equivalent in yards/second instead or both.",
				list = {
					[0] = {
						label = "Percentage",
						tooltip = "Show the speed value as a percentage of the base running speed without any speed altering effects."
					},
					[1] = {
						label = "Yards/second",
						tooltip = "Show the movement speed value in yards/second instead of a percentage of the base running speed.",
					},
					[2] = {
						label = "Both",
						tooltip = "Show both the percentage value and its equivalent in yards/second.",
					},
				},
			},
			decimals = {
				label = "Max Displayed Decimals",
				tooltip = "Set the maximal number of decimals places displayed in the movement speed value.",
			},
			noTrim = {
				label = "Don't trim zeros",
				tooltip = "Always show the specified number of decimal digits - don't trim trailing zeros.",
			},
		},
		speedDisplay = {
			title = "Speed Display",
			description = "Customize the main #ADDON display where you view your own movement speed.", --# flags will be replaced with code
			quick = {
				title = "Quick settings",
				description = "Quickly settings enable or disable the #ADDON display or set it up via presets.", --# flags will be replaced with code
				hidden = {
					label = "Hidden",
					tooltip = "Hide or show the #ADDON main display.", --# flags will be replaced with code
				},
				presets = {
					label = "Apply a Preset",
					tooltip = "Swiftly change the position and visibility of the speed display by choosing and applying one of these presets.",
					list = {
						"Under Default Minimap",
					},
					classicList = {
						"Under Minimap Clock",
					},
					select = "Select a preset…",
				},
				savePreset = {
					label = "Update Custom Preset",
					tooltip = "Save the current position and visibility of the speed display to the Custom preset.",
					warning = "Are you sure you want to override the Custom Preset with the current customizations?\n\nThe Custom preset is account-wide.", --\n represents the newline character
					response = "The current speed display position and visibility have been applied to the Custom preset and will be saved along with the other options.",
				},
			},
			playerSpeed = {
				title = "Player Speed",
				description = "Select how to display the player (or vehicle) speed value.",
			},
			travelSpeed = {
				title = "Travel Speed (BETA)",
				description = "Calculate the estimated speed at which you are moving through the zone horizontally.",
				enabled = {
					label = "Enable Functionality",
					tooltip = "Enable the Travel Speed functionality, allowing you to view an estimation of the effective speed you are traveling through the world horizontally (moving up & down in elevation can't be calculated).",
				},
				replacement = {
					label = "As a Replacement",
					tooltip = "Replace the Player Speed value with the estimated horizontal Travel Speed value in the speed display when movement is detected but no information about your speed is available (e.g. during Dragonriding) instead of having Travel Speed always visible in the secondary display.",
				},
			},
			update = {
				throttle = {
					label = "Throttle Updates",
					tooltip = "Update the speed value slower at the specified frequency instead of the framerate.",
				},
				frequency = {
					label = "Update Frequency",
					tooltip = "Set how many times the speed value should be updated every second.",
				},
			},
			position = {
				title = "Position",
				description = "Drag & drop the speed display while holding #SHIFT to position it anywhere on the screen, fine-tune it here.", --# flags will be replaced with code
				anchor = {
					label = "Screen Anchor Point",
					tooltip = "Select which point of the screen should the speed display be anchored to.",
				},
				xOffset = {
					label = "Horizontal Offset",
					tooltip = "Set the amount of horizontal offset (X axis) of the speed display from the selected anchor point.",
				},
				yOffset = {
					label = "Vertical Offset",
					tooltip = "Set the amount of vertical offset (Y axis) of the speed display from the selected anchor point.",
				},
			},
			font = {
				title = "Font & Text",
				description = "Customize what information shown in the speed display text overlay and how it is presented.",
				family = {
					label = "Font Family", --font family or type
					tooltip = "Select the font of the displayed speed value.",
					default = "This is a default font used by Blizzard.",
					custom = {
						"You may set the #OPTION_CUSTOM option to any font of your liking by replacing the #FILE_CUSTOM file with another TrueType Font file found in:", --# flags will be replaced with code
						"while keeping the original #FILE_CUSTOM name.", --# flags will be replaced with code
						"You may need to restart the game client after replacing the Custom font file.",
					},
				},
				size = {
					label = "Font Size",
					tooltip = "Specify the font size of the displayed percentage value.",
				},
				color = {
					label = "Font Color",
				},
				alignment = {
					label = "Text Alignment",
					tooltip = "Select the alignment of the text inside the speed display.",
				},
			},
			background = {
				title = "Background",
				description = "Customize the background graphic element of the speed display.",
				visible = {
					label = "Visible",
					tooltip = "Toggle the visibility of the backdrop elements of the main XP display.",
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
			visibility = {
				title = "Visibility",
				description = "Set the visibility and behavior of the #ADDON display.", --# flags will be replaced with code
				raise = {
					label = "Appear on top",
					tooltip = "Raise the display above most of the other UI elements (like the World Map Pane).",
				},
				autoHide = {
					label = "Hide while stationary",
					tooltip = "Automatically hide the speed display while you are not moving.",
				},
				statusNotice = {
					label = "Status notice on load",
					tooltip = "Get a notice in chat about the visibility of the #ADDON display after the interface loads.", --# flags will be replaced with code
				},
			},
		},
		targetSpeed = {
			title = "Target Speed",
			description = "View the current movement speed of any player or NPC you are inspecting via mouseover.",
			mouseover = {
				title = "Inspect Tooltip",
				description = "Toggle and specify how the movement speed of your mouseover target is shown in the inspect tooltip.",
				enabled = {
					label = "Enable Integration",
					tooltip = "Enable or disable the #ADDON integration in the mouseover inspect tooltip."
				},
			},
		},
		advanced = {
			title = "Advanced",
			description = "Configure #ADDON settings further, change options manually or backup your data by importing, exporting settings.", --# flags will be replaced with code
			profiles = {
				title = "Profiles",
				description = "Create, edit and apply unique options profiles to customize #ADDON separately between your characters. (Soon™)", --# flags will be replaced with
			},
			backup = {
				title = "Backup",
				description = "Import or export #ADDON options to save, share or apply them between your accounts.", --# flags will be replaced with code
				backupBox = {
					label = "Import & Export",
					tooltip = {
						"The backup string in this box contains the currently saved addon data and frame positions.",
						"Copy it to save, share or use it for another account.",
						"If you have a string, just override the text inside this box. Select it, and paste your string here. Press #ENTER to load the data stored in it.", --# flags will be replaced with code
						"Note: If you are using a custom font file, that file can not carry over with this string. It will need to be inserted into the addon folder to be applied.",
						"Only load strings that you have verified yourself or trust the source of!",
					},
				},
				compact = {
					label = "Compact",
					tooltip = "Toggle between a compact and a readable view.",
				},
				load = {
					label = "Load",
					tooltip = "Check the current string, and attempt to load all data from it.",
				},
				reset = {
					label = "Reset",
					tooltip = "Reset the string to reflect the currently stored values.",
				},
				import = "Load the string",
				warning = "Are you sure you want to attempt to load the currently inserted string?\n\nIf you've copied it from an online source or someone else has sent it to you, only load it after you've checked the code inside and you know what you are doing.\n\nIf don't trust the source, you may want to cancel to prevent any unwanted actions.", --\n represents the newline character
				error = "The provided backup string could not be validated and no data was loaded. It might be missing some characters or errors may have been introduced if it was edited.",
			},
		},
	},
	chat = {
		status = {
			visible = "The speed display is visible (#AUTO).", --# flags will be replaced with code
			notVisible = "The speed display is not visible (#AUTO).", --# flags will be replaced with code
			hidden = "The speed display is hidden (#AUTO).", --# flags will be replaced with code
			auto = "auto-hide: #STATE", --# flags will be replaced with code
		},
		help = {
			command = "help",
			thanks = "Thank you for using #ADDON!", --# flags will be replaced with code
			hint = "Type #HELP_COMMAND to see the full command list.", --# flags will be replaced with code
			move = "Hold #SHIFT to drag the #ADDON display anywhere you like.", --# flags will be replaced with code
			list = "chat command list",
		},
		options = {
			command = "options",
			description = "open the #ADDON options", --# flags will be replaced with code
		},
		save = {
			command = "save",
			description = "save this speed display setup as the Custom preset",
			response = "The current speed display position and visibility was saved to the Custom preset.",
		},
		preset = {
			command = "preset",
			description = "apply a speed display preset (e.g. #INDEX)", --# flags will be replaced with code
			response = "The #PRESET speed display preset was applied.", --# flags will be replaced with code
			unchanged = "The preset could not be applied, no changes were made.",
			error = "Please enter a valid preset index (e.g. #INDEX).", --# flags will be replaced with code
			list = "The following presets are available:",
		},
		toggle = {
			command = "toggle",
			description = "show or hide the speed display (#HIDDEN)", --# flags will be replaced with code
			hiding = "The speed display has been hidden.",
			unhiding = "The speed display has been made visible.",
			hidden = "hidden",
			notHidden = "not hidden",
		},
		auto = {
			command = "auto",
			description = "hide the speed display while stationary (#STATE)",
			response = "The speed display automatic hide was set to #STATE.", --# flags will be replaced with code
		},
		size = {
			command = "size",
			description = "change the font size (e.g. #SIZE)", --# flags will be replaced with code
			response = "The font size was set to #VALUE.", --# flags will be replaced with code
			unchanged = "The font size was not changed.",
			error = "Please enter a valid number value (e.g. #SIZE).", --# flags will be replaced with code
		},
		reset = {
			command = "reset",
			description = "reset everything to defaults",
			response = "The default options and the Custom preset have been reset.",
		},
		position = {
			save = "The speed display position was saved.",
			cancel = "The repositioning of the speed display was cancelled.",
			error = "Hold #SHIFT until the mouse button is released to save the position.", --# flags will be replaced with code
		},
	},
	speedTooltip = {
		title = "Speed info:",
		text = {
			"Displaying your current movement speed.",
			"#YARDS yards / second.", --# flags will be replaced with code
			"#PERCENT of the base running speed.", --# flags will be replaced with code
		},
		hintOptions = "Right-click to access specific options.",
		hintMove = "Hold #SHIFT & drag to reposition.", --# flags will be replaced with code
	},
	targetSpeed = "Speed: #SPEED", --# flags will be replaced with code
	yardsps = "#YARDS yards/s", --# flags will be replaced with code
	yps = "#YARDS y/s", --# flags will be replaced with code
	keys = {
		shift = "SHIFT",
		enter = "ENTER",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR", --# flags will be replaced with code
		options = "Options",
		default = "Default",
		custom = "Custom",
		override = "Override",
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
	local strings
	if (GetLocale() == "") then
		--TODO: Add localization for other languages (locales: https://wowwiki-archive.fandom.com/wiki/API_GetLocale#Locales)
		--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml
	else --Default: English (UK & US)
		strings = english
		strings.defaultFont = UNIT_NAME_FONT_ROMAN:gsub("\\", "/")
	end
	return strings
end


--[[ ASSETS ]]

--Strings
ns.strings = LoadLocale()
ns.strings.chat.keyword = "/movespeed"

--Colors
ns.colors = {
	grey = {
		[0] = { r = 0.54, g = 0.54, b = 0.54 },
		[1] = { r = 0.7, g = 0.7, b = 0.7 },
	},
	green = {
		[0] = { r = 0.31, g = 0.85, b = 0.21 },
		[1] = { r = 0.56, g = 0.83, b = 0.43 },
	},
	yellow = {
		[0] = { r = 1, g = 0.87, b = 0.28 },
		[1] = { r = 1, g = 0.98, b = 0.60 },
	},
}

--Fonts
ns.fonts = {
	[0] = { name = ns.strings.misc.default, path = ns.strings.defaultFont },
	[1] = { name = "Arbutus Slab", path = root .. "Fonts/ArbutusSlab.ttf" },
	[2] = { name = "Caesar Dressing", path = root .. "Fonts/CaesarDressing.ttf" },
	[3] = { name = "Germania One", path = root .. "Fonts/GermaniaOne.ttf" },
	[4] = { name = "Mitr", path = root .. "Fonts/Mitr.ttf" },
	[5] = { name = "Oxanium", path = root .. "Fonts/Oxanium.ttf" },
	[6] = { name = "Pattaya", path = root .. "Fonts/Pattaya.ttf" },
	[7] = { name = "Reem Kufi", path = root .. "Fonts/ReemKufi.ttf" },
	[8] = { name = "Source Code Pro", path = root .. "Fonts/SourceCodePro.ttf" },
	[9] = { name = ns.strings.misc.custom, path = root .. "Fonts/CUSTOM.ttf" },
}

--Textures
ns.textures = {
	logo = root .. "Textures/Logo.tga",
}