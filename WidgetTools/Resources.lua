--[[ ADDON INFO ]]

--Addon namespace string & table
local addonNameSpace, ns = ...

--Addon root folder
local root = "Interface/AddOns/" .. addonNameSpace .. "/"


--[[ CHANGELOG ]]

local changelogDB = {
	[0] = {
		[0] = "#V_Version 1.5_# #H_(11/28/2020)_#",
		[1] = "#H_Widget Tools has been supporting other addons in the background for over a year. Now, it has been separated into its own addon for more visibility, transparency and to offer wider development options._#",
        [2] = "#N_Update:_#",
		[3] = "Added Dragonflight (Retail 10.0) support with backwards compatibility.",
		[4] = "#H_If you encounter any issues, do not hesitate reporting them! Try including when & how they occur, and which other addons are you using to give me the best chance to be able to reproduce and fix them. If you know how, try proving taint logs as well if relevant. Thanks for helping!_#",
	},
}

--Get an assembled & formatted string of the full changelog
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
	about = {
		title = "About",
		description = "Thank you for using #ADDON!", --# flags will be replaced with code
		version = "Version: #VERSION", --# flags will be replaced with code
		date = "Date: #DATE", --# flags will be replaced with code
		dateFormat = "#MONTH/#DAY/#YEAR", --# flags will be replaced with code
		author = "Author: #AUTHOR", --# flags will be replaced with code
		license = "License: #LICENSE", --# flags will be replaced with code
		changelog = {
			label = "Changelog",
			tooltip = "Notes of all the changes included in the addon updates for all versions.\n\nThe changelog is only available in English for now.", --\n represents the newline character
		},
	},
	shortcuts = {
		title = "Shortcuts",
		description = "Access specific information by expanding the #ADDON categories on the left or by clicking a button here.", --# flags will be replaced with code
	},
	support = {
		title = "Support",
		description = "Follow the links to see how you can provide feedback, report bugs, get help and support development.", --# flags will be replaced with code
		curseForge = "CurseForge Page",
		wago = "Wago Page",
		repository = "GitHub Repository",
		issues = "Issues & Feedback",
	},
	addons = {
		title = "Addons & Toolboxes",
		description = "The list of currently loaded addons using specific versions of registered #ADDON toolboxes.", --# flags will be replaced with code
		old = {
			title = "Old versions",
			description = "Versions of #ADDON toolboxes older than 1.5 don't have addon data. It is visible if they are in use, however.", --# flags will be replaced with code
			none = "There are no recognized older versions of #ADDON toolboxes currently in use.", --# flags will be replaced with code
			inUse = "Older versions of #ADDON toolboxes currently in use:#TOOLBOXES", --# flags will be replaced with code
		},
		toolbox = "Toolbox (#VERSION)", --# flags will be replaced with code
	},
}

--Load the proper localization table based on the client language
local function LoadLocale()
	local strings
	if (GetLocale() == "") then
		--TODO: Add localization for other languages (locales: https://wowpedia.fandom.com/wiki/API_GetLocale#Values)
		--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml#L8
	else --Default: English (UK & US)
		strings = english
	end
	return strings
end


--[[ ASSETS ]]

--Strings
ns.strings = LoadLocale()

--Colors
ns.colors = {
	grey = {
		[0] = { r = 0.7, g = 0.7, b = 0.7 },
		[1] = { r = 0.54, g = 0.54, b = 0.54 },
	},
	gold = {
		[0] = { r = 1, g = 0.76, b = 0.07 },
		[1] = { r = 0.8, g = 0.62, b = 0.1 },
	},
}

--Textures
ns.textures = {
	logo = root .. "Textures/Logo.tga",
	missing = root .. "Textures/MissingLogo.tga",
	alphaBG = root .. "Textures/AlphaBG.tga",
	gradientBG = root .. "Textures/GradientBG.tga",
}


--[[ ALIASES ]]

---@alias UniqueFrameType
---|"Selector"
---|"Dropdown"
---|"ColorPicker"

---@alias ModifierKey
---|"CTRL"
---|"SHIFT"
---|"ALT"
---|"LCTRL"
---|"RCTRL"
---|"LSHIFT"
---|"RSHIFT"
---|"LALT"
---|"RALT"
---|"any"