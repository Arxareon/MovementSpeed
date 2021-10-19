--Addon namespace
local _, ns = ...


--[[ ENGLISH ]] --(English support only, for now..)

ns.english = {
	options = {
		description = "Customize Movement Speed to fit your needs. Type /movespeed for chat commands.",
		defaults = "The default options have been reset.",
		position = {
			title = "Position",
			description = "You may drag the main display while holding SHIFT to position it anywhere on the screen.",
			save = {
				label = "Save Position",
				tooltip = "Save the current position of the main display as the preset location.",
				warning = "Are you sure you want to override the saved preset with the current position?\n\nThe preset position is account-wide.", --\n represents the newline character
			},
			reset = {
				label = "Reset Position",
				tooltip = "Reset the position of the main display to the specified preset location.",
				warning = "Are you sure you want to reset the position to the current preset?",
			},
			default = {
				label = "Default Preset",
				tooltip = "Restore the default preset location of the main display.",
				warning = "Are you sure you want to reset the preset position to the defaults?\n\nThe preset position is account-wide.", --\n represents the newline character
			},
		},
		appearance = {
			title = "Appearance",
			description = "Set the visibility and look of the main Movement Speed percentage display elements.",
			hidden = {
				label = "Hidden",
				tooltip = "Hide or show the Movement Speed main display.",
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
					[2] = "\nYou may set the #OPTION_CUSTOM option to any font of your liking by replacing the #FILE_CUSTOM file with another TrueType Font file found in:", --\n represents the newline character, and # flags will be replaced with code
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
			description = "hide the main display",
			response = "The main display is hidden.",
		},
		show = {
			command = "show",
			description = "show the main display",
			response = "The main display is not hidden.",
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
	misc = {
		cancel = "Cancel",
		default = "Default",
		example = "Example",
		custom = "Custom",
	},
}