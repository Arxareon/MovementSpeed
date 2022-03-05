--Addon namespace table
local _, ns = ...


--[[ CHANGELOG ]]

local changelogDB = {
	[0] = {
		[0] = "#V_Version 1.0_# #H_(10/26/2020)_#",
		[1] = "#H_It's alive!_#",
		[2] = "If you have suggestions or problems, please don't hesitate to let me know in a comment!",
		[3] = "You can use the #H_/movespeed_# chat command to set up the text display as you'd like.",
	},
	[1] = {
		[0] = "#V_Version 1.0.1_# #H_(10/26/2020)_#",
		[1] = "#F_Hotfix:_#",
		[2] = "Fixed an issue with #H_/movespeed_# and #H_/movespeed help_# commands bringing up Remaining XP messages instead (if you were using both addons - check that out too btw). Oops.. how could that even happen?",
	},
	[2] = {
		[0] = "#V_Version: 1.1.0_# #H_(3/12/2021)_#",
		[1] = "#C_Update:_#",
		[2] = "Expanded functionality to also calculate the movement speed while in a vehicle. Finally!",
		[3] = "#F_Hotfix:_#",
		[4] = "Fixed all potential issues with previously non-local functions.",
	},
	[3] = {
		[0] = "#V_Version 1.2_# #H_(4/19/2021)_#",
		[1] = "#C_Update:_#",
		[2] = "Added 9.1 (with 9.0.5 still being supported!), Classic (1.13.7) and Burning Crusade Classic (2.5.1) multi-version support.",
	},
	[4] = {
		[0] = "#V_Version 1.3_# #H_(6/30/2021)_#",
		[1] = "#C_Updates:_#",
		[2] = "Added the ability to change the font size of the text display via chat commands. See #H_/movespeed help_# for details.",
		[3] = "Added data table checkup to allow for feature expansion in the future - like changing fonts, colors and more.",
		[4] = "Code cleanup.",
	},
	[5] = {
		[0] = "#V_Version 2.0_# #H_(11/3/2021)_#",
		[1] = "Support for 9.1.5 has been added (support for Season of Mastery will be added when it launches).",
		[2] = "#N_New features:_#",
		[3] = "#H_Interface Options:_# buttons, sliders, dropdowns and more have been added as alternatives to chat commands (some new options are not available as chat commands).",
		[4] = " • H_New options:_# Font family & color customization options have been added besides font size (with a fully custom font type option - see the in-game tooltip in the settings)\n • #H_New option:_# Background graphic (with customizable color)\n • #H_New option:_# Raise (or lower) display among other UI elements\n • #H_New feature:_# Import/Export to backup or move your settings between accounts (with the ability to manually edit them - for advanced coders)",
		[5] = "The main display will be moved to the default position when the preset or the options are being reset.",
		[6] = "The display now hides during pet battles (thanks for the request! ♥).",
		[7] = "Added localization support, so more languages can be supported besides English in the future (more info soon on how you can help me translate!).",
		[8] = "Various other improvements, fixes & cleanup.",
	},
	[6] = {
		[0] = "#V_Version 2.1_# #H_(11/16/2021)_#",
		[1] = "#C_Update:_#",
		[2] = "Added support for Season of Mastery.",
	},
	[7] = {
		[0] = "#V_Version 2.1.1_# #H_(11/18/2021)_#",
		[1] = "#F_Hotfix:_#",
		[2] = "Minor under the hood fixes and changes.",
	},
	[8] = {
		[0] = "#V_Version 2.2_# #H_(3/11/2022)_#",
		[1] = "#N_Update:_#",
		[2] = "Added 9.2 (Retail), 1.14.2 (Classic) and 2.5.3 (BCC) multi-version support.",
		[3] = "#N_New features:_#",
		[4] = "#H_Added Interface Options:_#",
		[5] = "Buttons, sliders, dropdowns and more have been added as alternatives to chat commands (many more new options have not been made available as chat commands).",
		[6] = "Included an about page where you can find contact and support links, changelogs and more.",
		[7] = "#H_New display options:_#",
		[8] = "Background graphic: the display now functions as a customizable XP bar with customizable colors, mouseover fade options.",
		[9] = "Font family & color customization (with a fully custom font type option - see the tooltip in the settings).",
		[10] = "Multiple display presets have been added to quickly set it up for your needs.",
		[11] = "Detailed XP value option.",
		[12] = "Fine-tune the position (select an anchor point and change the offset coordinates with sliders).",
		[13] = "Raise or lower the display among other UI elements.",
		[14] = "#N_New features:_#",
		[15] = "XP bar enhancement integration: detailed XP text and tooltip can be enabled to replace the default text and tooltip shown when mousing over the default XP bar.",
		[16] = "Added the ability to hide the default Status/XP/Reputation Bars (so it may be replaced with the Remaining XP display).",
		[17] = "Chat notifications on event updates like XP or Rested XP gain (with the amount gained), level up and more.",
		[18] = "Option for an accumulative Rested XP gain notification showing you a summary of the total amount of Rested XP gained while resting when leaving a rested area.",
		[19] = "Import/Export: Back up your settings (or manually edit them - for advanced users).",
		[20] = "#C_Other additions & changes:_#",
		[21] = "Right click on the display (or the default XP bar when the integration is enabled) to quickly open an options category page.",
		[22] = "The chat notification reminder when you are max level and Remaining XP is disabled can now be turned off.",
		[23] = "The display now hides during pet battles.",
		[24] = "Added localization support, so more languages can be supported besides English in the future (more info soon on how you can help me translate!).",
		[25] = "#O_Coming soon:_#",
		[26] = "Options profiles for character-specific customization.",
		[27] = "Tracking the playtime/real time spent on a level.",
		[28] = "Different styles and looks for the custom XP bar.",
		[29] = "Event update logs: track your XP, Rested XP gain and more.",
	},
}

ns.GetChangelog = function()
	--Colors
	local version = "FFFFFFFF"
	local new = "FF66EE66"
	local fix = "FFEE4444"
	local change = "FF8888EE"
	local note = "FFEEEE66"
	local highlight = "FFBBBBBB"
	--Assemble the changelog
	local changelog = ""
		for i = #changelogDB, 0, -1 do
			for j = 0, #changelogDB[i] do
				changelog = changelog .. (j > 0 and "\n\n" or "") .. changelogDB[i][j]:gsub(
					"#V_(.-)_#", (i < #changelogDB and "\n\n\n" or "") .. "|c" .. version .. "%1|r"
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
		end
	return changelog
end


--[[ LOCALIZATIONS ]]

local english = {
	options = {
		name = "#ADDON options",
		defaults = "The default options and the Custom preset have been reset.",
		main = {
			description = "Customize #ADDON to fit your needs. Type #KEYWORD for chat commands.", --# flags will be replaced with code
			shortcuts = {
				title = "Shortcuts",
				description = "Access customization options by expanding the #ADDON categories on the left or by clicking a button here.", --# flags will be replaced with code
			},
			about = {
				title = "About",
				description = "Thank you for using #ADDON!", --# flags will be replaced with code
				version = "Version: #VERSION", --# flags will be replaced with code
				date = "Date: #DATE", --# flags will be replaced with code
				author = "Author: #AUTHOR", --# flags will be replaced with code
				license = "License: #LICENSE", --# flags will be replaced with code
				changelog = {
					label = "Changelog",
					tooltip = "Notes of all the changes included in the addon updates for all versions.\n\nThe changelog is only available in English for now.", --\n represents the newline character
				},
			},
			support = {
				title = "Support",
				description = "Follow the links to see how you can provide feedback, report bugs, get help and support development.", --# flags will be replaced with code
				curseForge = "CurseForge Page",
				wago = "Wago Page",
				bitBucket = "BitBucket Repository",
				issues = "Issues & Ideas",
			},
			feedback = {
				title = "Feedback",
				description = "Visit #ADDON online if you have something to report.", --# flags will be replaced with code
			},
		},
		speedDisplay = {
			title = "Speed Display",
			description = "Customize the #ADDON display, change its background and font settings to make it your own.", --# flags will be replaced with code
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
						[0] = "Under Minimap Clock",
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
			position = {
				title = "Position",
				description = "You may drag the speed display while holding #SHIFT to position it anywhere on the screen, fine-tune it here.", --# flags will be replaced with code
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
			text = {
				title = "Text & Font",
				description = "Customize the font and select the information shown in the speed display text overlay.",
				font = {
					family = {
						label = "Font Family", --font family or type
						tooltip = {
							[0] = "Select the font of the displayed percentage value.",
							[1] = "The default option is the font used by Blizzard.",
							[2] = "You may set the #OPTION_CUSTOM option to any font of your liking by replacing the #FILE_CUSTOM file with another TrueType Font file found in:", --# flags will be replaced with code
							[3] = "while keeping the original #FILE_CUSTOM name.", --# flags will be replaced with code
							[4] = "You may need to restart the game client after replacing the Custom font.",
						},
					},
					size = {
						label = "Font Size",
						tooltip = "Specify the font size of the displayed percentage value.",
					},
					color = {
						label = "Font Color",
					},
				},
			},
			background = {
				title = "Background",
				description = "Customize the graphical background elements of the speed display.",
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
					tooltip = "Get a notice in chat about the state of the #ADDON display after the interface loads.", --# flags will be replaced with code
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
						[0] = "The backup string in this box contains the currently saved addon data and frame positions.",
						[1] = "Copy it to save, share or use it for another account.",
						[2] = "If you have a string, just override the text inside this box. Select it, and paste your string here. Press #ENTER to load the data stored in it.", --# flags will be replaced with code
						[3] = "Note: If you are using a custom font file, that file can not carry over with this string. It will need to be inserted into the addon folder to be applied.",
						[4] = "Only load strings that you have verified yourself or trust the source of!",
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
				error = "The provided backup string could not be validated and no data was loaded. It might be missing some characters or errors may heve been introduced if it was edited.",
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
	},
	speedDisplayTooltip = {
		title = "Speed info:",
		text = {
			[0] = "Displaying your current movement speed.",
			[1] = "The percentage value is comparative to the normal running speed which is equivalent to #YARDS yards / s (#PERCENT) without any speed altering effects.", --# flags will be replaced with code
		}
	},
	keys = {
		shift = "SHIFT",
		enter = "ENTER",
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
	misc = {
		date = "#MONTH/#DAY/#YEAR", --# flags will be replaced with code
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


--[[ Load Localization ]]

--Load the proper localization table based on the client language
ns.LoadLocale = function()
	local strings
	if (GetLocale() == "") then
		--TODO: Add localization for other languages (locales: https://wowwiki-archive.fandom.com/wiki/API_GetLocale#Locales)
		--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml
	else --Default: English (UK & US)
		strings = english
		strings.options.speedDisplay.text.font.family.default = UNIT_NAME_FONT_ROMAN:gsub("\\", "/")
	end
	return strings
end