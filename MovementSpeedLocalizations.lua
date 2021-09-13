--Addon namespace
local addonName, ns = ...


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
			},
			reset = {
				label = "Reset position",
				tooltip = "Reset the position of the text display to the specified preset location.",
			},
			default = {
				label = "Default preset",
				tooltip = "Restore the default preset location of the text display.",
			},
		},
		visibility = {
			title = "Visibility",
			description = "Set the visibility of Movement Speed.",
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
				tooltip = "Specify the font size of the displayed percentage value.\nDefault: 11",
			},
		},
	},
	chat = {
		help = {
			command = "help",
			thanks = "Thank you for using #!", --# will be replaced with code
			hint = "Type # to see the full command list.", --# will be replaced with code
			move = "Hold # to drag the Movement Speed display anywhere you like.", --# will be replaced with code
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
			description = "change the font size (e.g. #)", --# will be replaced with code
			response = "The font size has been set to #.", --# will be replaced with code
			unchanged = "The font size was not changed.",
			error = "Please enter a valid number value (e.g. #).", --# will be replaced with code
		},
	},
}