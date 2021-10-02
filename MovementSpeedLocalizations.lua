--Addon namespace
local _, ns = ...


--[[ ENGLISH ]] --(English support only, for now..)

ns.english = {
	options = {
		description = "Customize Movement Speed to fit your needs. Type /movespeed for chat commands.",
		defaults = "The default options have been reset.",
		position = {
			title = "Position",
			description = "You may drag the text display while holding SHIFT to position it anywhere on the screen.",
			save = {
				label = "Save position",
				tooltip = "Save the current position of the text display as the preset location.",
				warning = "Are you sure you want to override the saved preset with the current position?\n\nThe preset position is account-wide.", --\n represents the newline character
			},
			reset = {
				label = "Reset position",
				tooltip = "Reset the position of the text display to the specified preset location.",
				warning = "Are you sure you want to reset the position to the current preset?",
			},
			default = {
				label = "Default preset",
				tooltip = "Restore the default preset location of the text display.",
				warning = "Are you sure you want to reset the preset position to the defaults?\n\nThe preset position is account-wide.", --\n represents the newline character
			},
		},
		visibility = {
			title = "Visibility",
			description = "Set the visibility of Movement Speed percentage value.",
			hidden = {
				label = "Hidden",
				tooltip = "Hide or show the Movement Speed text display.",
			},
		},
		font = {
			title = "Font",
			description = "Customize the font of the speed percentage text display.",
			size = {
				label = "Font size",
				tooltip = "Specify the font size of the displayed percentage value.\nDefault: 11", --\n represents the newline character
			},
			family = {
				label = "Font family",
				tooltip = "Select the font of the displayed percentage value.\nDefault is the font used by Blizzard.\nYou may set the #OPTION_CUSTOM option to any font of your liking by replacing the #FILE_CUSTOM found in #PATH_CUSTOM with another TrueType Font file while keeping the #NAME_CUSTOM name. You may need to restart the game client after replacing the custom font.", --\n represents the newline character; # flags will be replaced with code
				default = "Fonts/FRIZQT__.TTF", --Different locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml
			},
		},
	},
	chat = {
		help = {
			command = "help",
			thanks = "Thank you for using #ADDON!", --# flags will be replaced with code
			hint = "Type #HELP_COMMAND to see the full command list.", --# flags will be replaced with code
			move = "Hold #SHIFT to drag the Movement Speed display anywhere you like.", --# flags will be replaced with code
			list = "chat command list",
		},
		reset = {
			command = "reset",
			description = "set location to the specified preset location",
			response = "The location has been set to the preset location.",
		},
		save = {
			command = "save",
			description = "save the current location as the preset location",
			response = "The current location was saved as the preset location.",
		},
		default = {
			command = "default",
			description = "save the current location as the preset location",
			response = "The preset location has been reset to the default location.",
		},
		hide = {
			command = "hide",
			description = "hide the text display",
			response = "The text display is hidden.",
		},
		show = {
			command = "show",
			description = "show the text display",
			response = "The text display is visible.",
		},
		size = {
			command = "size",
			description = "change the font size (e.g. #SIZE_DEFAULT)", --# flags will be replaced with code
			response = "The font size has been set to #VALUE.", --# flags will be replaced with code
			unchanged = "The font size was not changed.",
			error = "Please enter a valid number value (e.g. #SIZE_DEFAULT).", --# flags will be replaced with code
		},
	},
	misc = {
		cancel = "Cancel",
		default = "Default",
		custom = "Custom (user set)",
	}
}