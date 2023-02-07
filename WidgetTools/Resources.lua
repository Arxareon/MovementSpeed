--[[ ADDON INFO ]]

---Addon namespace
---@class ns
local addonNameSpace, ns = ...

--Addon root folder
local root = "Interface/AddOns/" .. addonNameSpace .. "/"


--[[ CHANGELOG ]]

local changelogDB = {
	{
		"#V_Version 1.5_# #H_(11/28/2020)_#",
		"#H_Widget Tools has been supporting other addons in the background for over a year. Now, it has been separated into its own addon for more visibility, transparency and to offer wider development options._#",
     	"#N_Update:_#",
		"Added Dragonflight (Retail 10.0) support with backwards compatibility.",
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
		"#H_If you encounter any issues, do not hesitate to report them! Try including when & how they occur, and which other addons are you using to give me the best chance of being able to reproduce & fix them. If you know how, try proving taint logs as well (if relevant). Thanks a lot for helping!_#",
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
	shortcuts = {
		title = "Shortcuts",
		description = "Access specific information by expanding the #ADDON categories on the left or by clicking a button here.", --# flags will be replaced with code
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
		compactVersion = "Version: #VERSION", --# flags will be replaced with code
		compactDate = "Date: #DATE", --# flags will be replaced with code
		compactAuthor = "Author: #AUTHOR", --# flags will be replaced with code
		compactLicense = "License: #LICENSE", --# flags will be replaced with code
		dateFormat = "#MONTH/#DAY/#YEAR", --# flags will be replaced with code
		changelog = {
			label = "Update Notes",
			tooltip = "Notes of all the changes, updates & fixes introduced with the latest version.\n\nThe changelog is only available in English for now.", --\n represents the newline character
		},
		openFullChangelog = {
			label = "Open the full Changelog",
			tooltip = "Access the full list of update notes of all addon versions.", --\n represents the newline character
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
	addons = {
		title = "Addons & Toolboxes",
		description = "The list of currently loaded addons using specific versions of registered #ADDON toolboxes.", --# flags will be replaced with code
		old = {
			title = "Old versions",
			description = "Versions of toolboxes older than 1.5 don't have addon data. It is visible if they are in use, however.",
			none = "There are no recognized older versions of #ADDON toolboxes currently in use.", --# flags will be replaced with code
			inUse = "Old toolboxes currently in use:#TOOLBOXES", --# flags will be replaced with code
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
---|"ValueSlider"
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