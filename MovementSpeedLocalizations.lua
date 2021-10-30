--Addon namespace
local _, ns = ...


--[[ LOCALIZATIONS ]]

local english = {
	options = {
		defaults = "The default options have been reset.",
		main = {
			description = "Customize #ADDON to fit your needs. Type #KEYWORD for chat commands.", --# flags will be replaced with code
		},
		advanced = {
			title = "Advanced",
			description = "Configure #ADDON settings further, change options manually or backup your data by importing, exporting settings." --# flags will be replaced with code
		},
		position = {
			title = "Position",
			description = "You may drag the main display while holding #SHIFT to position it anywhere on the screen.", --# flags will be replaced with code
			save = {
				label = "Save Position",
				tooltip = "Save the current position of the main display as the preset location.",
				warning = "Are you sure you want to override the saved preset with the current position?\n\nThe preset position is account-wide.", --\n represents the newline character
			},
			preset = {
				label = "Reset Position",
				tooltip = "Reset the position of the main display to the specified preset location.",
				warning = "Are you sure you want to reset the position to the current preset?",
			},
			reset = {
				label = "Default Preset",
				tooltip = "Restore the default preset location of the main display.",
				warning = "Are you sure you want to reset the preset position to the defaults?\n\nThe preset position is account-wide.", --\n represents the newline character
			},
		},
		appearance = {
			title = "Appearance",
			description = "Set the visibility and look of the main #ADDON percentage display elements.", --# flags will be replaced with code
			hidden = {
				label = "Hidden",
				tooltip = "Hide or show the main #ADDON display.", --# flags will be replaced with code
			},
			backdrop = {
				label = "Background Graphic",
				tooltip = "Toggle the visibility of the backdrop element of the main display.",
				color = {
					label = "Background Color",
				},
			},
		},
		font = {
			title = "Font",
			description = "Customize the font of the main speed percentage display.",
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
		backup = {
			title = "Backup",
			description = "Import or export #ADDON options to save, share or apply them between your accounts.", --# flags will be replaced with code
			box = {
				label = "Import & Export",
				tooltip = {
					[0] = "The backup string in this box contains the currently saved addon data and frame positions.",
					[1] = "Copy it to save, share or use it for another account.",
					[2] = "If you have a string, just override the text inside this box. Select it, and paste your string here. Press #ENTER to load the data stored in it.", --# flags will be replaced with code
					[3] = "Note: If you are using a custom font file, that file can not carry over with this string. It will need to be inserted into the addon folder to be applied.",
					[4] = "Only load strings that you have verified yourself or trust the source of!",
				},
				import = "Import & Load",
				warning = "Are you sure you want to attempt to load the currently inserted string?\n\nIf you've copied it from an online source or someone else has sent it to you, only load it after you've checked the code inside and you know what you are doing.\n\nIf don't trust the source, you may want to cancel to prevent any unwanted actions.", --\n represents the newline character
				error = "The provided backup string could not be validated and no data was loaded. It might be missing some characters or errors may heve been introduced if it was edited.",
			},
		},
	},
	chat = {
		help = {
			command = "help",
			thanks = "Thank you for using #ADDON!", --# flags will be replaced with code
			hint = "Type #HELP_COMMAND to see the full command list.", --# flags will be replaced with code
			move = "Hold #SHIFT to drag the #ADDON display anywhere you like.", --# flags will be replaced with code
			list = "chat command list",
		},
		options = {
			command = "options",
			description = "open the #ADDON options",
		},
		save = {
			command = "save",
			description = "save the current location as the preset location",
			response = "The current location was saved as the preset location.",
		},
		preset = {
			command = "preset",
			description = "set the location to the specified preset location",
			response = "The location has been set to the preset location.",
		},
		reset = {
			command = "reset",
			description = "reset the preset location to the default location",
			response = "The preset location has been reset to the default location.",
		},
		toggle = {
			command = "toggle",
			description = "show or hide the main display",
			response = "The main display is #HIDDEN.", --# flags will be replaced with code
			hidden = "hidden",
			shown = "not hidden",
		},
		size = {
			command = "size",
			description = "change the font size (e.g. #SIZE_DEFAULT)", --# flags will be replaced with code
			response = "The font size has been set to #VALUE.", --# flags will be replaced with code
			unchanged = "The font size was not changed.",
			error = "Please enter a valid number value (e.g. #SIZE_DEFAULT).", --# flags will be replaced with code
		},
	},
	color = {
		picker = {
			label = "Pick a color",
			tooltip = "Click to open the color picker to customize the color#ALPHA.", --# flags will be replaced with code
			alpha = " and change the opacity",
		},
		hex = {
			label = "Add via HEX color code",
			tooltip = "You may change the color via HEX code instead of using the color picker.",
		}
	},
	keys = {
		shift = "SHIFT",
		enter = "ENTER",
	},
	misc = {
		cancel = "Cancel",
		default = "Default",
		example = "Example",
		custom = "Custom",
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
		strings.options.font.family.default = "Fonts/FRIZQT__.TTF"
	end
	return strings
end