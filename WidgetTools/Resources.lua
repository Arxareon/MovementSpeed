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
	},
	{
		"#V_Version 1.7_# #H_(3/11/2023)_#",
		"#N_Updates:_#",
		"Added an option to disable addons using Widget Toolboxes from the Widget Tools settings.",
		"Added 10.0.7 (Dragonflight) support.",
		"#C_Changes:_#",
		"The Shortcuts section form the main settings page has been removed in Dragonflight (since the new expansion broke the feature - I may readd it if it gets resolved).",
		"Other smaller changes.",
		"#F_Fixes:_#",
		"Several under the hood fixes & improvements.",
	},
	{
		"#V_Version 1.8_# #H_(4/5/2023)_#",
		"#N_Updates:_#",
		"Added 10.1 (Dragonflight) support.",
		"#F_Fixes:_#",
		"The old scrollbars have been replaced with the new scrollbars in Dragonflight, fixing any bugs that emerged with 10.1 as a result of deprecation.",
		"Several other under the hood fixes & improvements.",
	},
	{
		"#V_Version 1.9_# #H_(5/17/2023)_#",
		"#C_Changes:_#",
		"Upgraded to the new Dragonflight addon logo handling. (Custom addon logos may not appear in the Interface Options in Classic clients.)",
		"#F_Fixes:_#",
		"Fixed an issue with actions being blocked after closing the Settings panel in certain situation (like changing Keybindings) in Dragonflight.",
		"The current version will now run in the WotLK Classic 3.4.2 PTR but it's not yet fully polished (as parts of the UI are still being modernized).",
		"Other small under the hood improvements & code cleanup.",
	},
	{
		"#V_Version 1.10_# #H_(6/15/2023)_#",
		"#N_Updates:_#",
		"Added 10.1.5 (Dragonflight) support.",
		"#F_Fixes:_#",
		"No tooltip will stay on the screen after its target was hidden.",
		"Under the hood fixes & improvements.",
	},
	{
		"#V_Version 1.11_# #H_(7/18/2023)_#",
		"#C_Changes:_#",
		"Added 1.14.4 (Classic) support with 1.14.3 backwards compatibility (until the Hardcore patch goes live).",
		"Scrolling has been improved in WotLK Classic.",
		"Backwards compatibility ensuring editboxes work with Toolbox version 1.5 has been removed.",
		"Other small improvements.",
		"#H_If you encounter any issues, do not hesitate to report them! Try including when & how they occur, and which other addons are you using to give me the best chance of being able to reproduce & fix them. Try proving any LUA script error messages and if you know how, taint logs as well (when relevant). Thanks a lot for helping!_#",
	},
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

--# flags will be replaced with code
--\n represents the newline character

local english = {
	shortcuts = {
		title = "Shortcuts",
		description = "Access specific information by expanding the #ADDON categories on the left or by clicking a button here.",
	},
	about = {
		title = "About",
		description = "Thanks for using #ADDON! Copy the links to see how to share feedback, get help & support development.",
		version = "Version",
		date = "Date",
		author = "Author",
		license = "License",
		curseForge = "CurseForge Page",
		wago = "Wago Page",
		repository = "GitHub Repository",
		issues = "Issues & Feedback",
		compactVersion = "Version: #VERSION",
		compactDate = "Date: #DATE",
		compactAuthor = "Author: #AUTHOR",
		compactLicense = "License: #LICENSE",
		dateFormat = "#MONTH/#DAY/#YEAR",
		changelog = {
			label = "Update Notes",
			tooltip = "Notes of all the changes, updates & fixes introduced with the latest version.\n\nThe changelog is only available in English for now.",
		},
		openFullChangelog = {
			label = "Open the full Changelog",
			tooltip = "Access the full list of update notes of all addon versions.",
		},
		fullChangelog = {
			label = "#ADDON Changelog",
			tooltip = "Notes of all the changes included in the addon updates for all versions.\n\nThe changelog is only available in English for now.",
		},
		toggle = {
			label = "Enabled",
			tooltip = "Shortcut to disable this addon.\n\nThis change will only take effect after the interface is reloaded. Once it has been disabled, this addon will not show up in this list until it's reenabled within the main AddOns menu.",
		},
	},
	sponsors = {
		title = "Sponsors",
		description = "Your continued support is greatly appreciated! Thank you!",
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
}

--Load the proper localization table based on the client language
local function LoadLocale()
	local strings
	local locale = GetLocale()

	if (locale == "") then
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
		{ r = 0.7, g = 0.7, b = 0.7 },
		{ r = 0.54, g = 0.54, b = 0.54 },
	},
	gold = {
		{ r = 1, g = 0.76, b = 0.07 },
		{ r = 0.8, g = 0.62, b = 0.1 },
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
---|"Toggle"
---|"Selector"
---|"Dropdown"
---|"TextBox"
---|"ValueSlider"
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