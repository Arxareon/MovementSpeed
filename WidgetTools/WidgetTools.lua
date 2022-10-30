--[[ ADDON INFO ]]

--Addon namespace string & table
local addonNameSpace, ns = ...

--Addon display name
local _, addonTitle = GetAddOnInfo(addonNameSpace)


--[[ WIDGET TOOLS DATA ]]

--Local WidgetTools toolbox registry
local registry = { toolbox = {}, addons = {} }

--Global WidgetTools table
WidgetTools = {}

---Register or get a read-only reference of a WidgetTools toolbox under the specified version key
---@param addon string Addon namespace (the name of the addon's folder, not its display title) to register for WidgetTools usage
---@param version string Version key the **toolbox** should be registered under
---@param toolbox? table Reference to the table to register as a WidgetTools toolbox
---@param logo? string Path to the texture file used by **addon** as its logo (to be featured in the Widget Tools addon list)
--- - ***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/**addon**/Textures/TextureImage.tga).
--- - ***Note - File format:*** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.
--- - ***Note - Size:*** Texture files must have powers of 2 dimensions to be handled by the WoW client.
---@return table|nil? toolbox Reference to the toolbox table registered under the **version** key
WidgetTools.RegisterToolbox = function(addon, version, toolbox, logo)
	if not addon or not version or (not registry.toolbox[version] and not toolbox) then return nil end
	--Register the addon
	if IsAddOnLoaded(addon) then
		registry.addons[version] = registry.addons[version] or {}
		registry.addons[version][addon] = logo or false
	end
	--Register the toolbox
	registry.toolbox[version] = registry.toolbox[version] or toolbox
	return registry.toolbox[version]
end


--[[ ABOUT ]]

--Frame & events
local frame = CreateFrame("Frame", addonNameSpace .. "Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

--Event handler
frame:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)

--[ Initialization ]

--Add the WidgetTools about info to the Settings
function frame:PLAYER_ENTERING_WORLD()

	---@class WidgetToolbox
	local wt = ns.WidgetToolbox

	--Clean up the addon title
	addonTitle = wt.Clear(addonTitle):gsub("^%s*(.-)%s*$", "%1")


	--[[ SETTINGS CATEGORY PAGES ]]

	--About page
	local mainPage = wt.CreateOptionsCategory({
		addon = addonNameSpace,
		name = "About",
		appendOptions = false,
		description = GetAddOnMetadata(addonNameSpace, "Notes"),
		logo = ns.textures.logo,
		titleLogo = true,
	})

	--Addons page
	local addonsPage = wt.CreateOptionsCategory({
		parent = mainPage.category,
		addon = addonNameSpace,
		name = "Addons",
		appendOptions = false,
		title = ns.strings.addons.title,
		description = ns.strings.addons.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		scroll = {
			height = 78,
			speed = 72,
		},
	})


	--[[ ABOUT PAGE ]]

	--[Shortcuts ]

	--Main panel
	local shortcutsPanel = wt.CreatePanel({
		parent = mainPage.canvas,
		name = "Shortcuts",
		title = ns.strings.shortcuts.title,
		description = ns.strings.shortcuts.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 10, y = -82 } },
		size = { height = 64 },
	})

	--Button: Addon List page
	wt.CreateButton({
		parent = shortcutsPanel,
		name = "AddonsPage",
		title = ns.strings.addons.title,
		tooltip = { lines = {
			[0] = { text =  ns.strings.addons.description:gsub("#ADDON", addonTitle), },
			[1] = not wt.classic and { text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON",  addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, } or nil,
		} },
		position = { offset = { x = 10, y = -30 } },
		size = { width = 160, },
		events = { OnClick = function() addonsPage.open() end, },
		disabled = wt.classic == false,
	})


	--[ About ]

	--Main panel
	local aboutPanel = wt.CreatePanel({
		parent = mainPage.canvas,
		name = "About",
		title = ns.strings.about.title,
		description = ns.strings.about.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = shortcutsPanel,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 257 },
	})

	--Text: Version
	local version = wt.CreateText({
		parent = aboutPanel,
		name = "Version",
		position = { offset = { x = 16, y = -33 } },
		width = 84,
		text = ns.strings.about.version:gsub("#VERSION", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "Version"), "FFFFFFFF")),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})

	--Text: Date
	local date = wt.CreateText({
		parent = aboutPanel,
		name = "Date",
		position = {
			relativeTo = version,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		width = 102,
		text = ns.strings.about.date:gsub(
			"#DATE", WrapTextInColorCode(ns.strings.about.dateFormat:gsub(
				"#DAY", GetAddOnMetadata(addonNameSpace, "X-Day")
			):gsub(
				"#MONTH", GetAddOnMetadata(addonNameSpace, "X-Month")
			):gsub(
				"#YEAR", GetAddOnMetadata(addonNameSpace, "X-Year")
			), "FFFFFFFF")
		),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})

	--Text: Author
	local author = wt.CreateText({
		parent = aboutPanel,
		name = "Author",
		position = {
			relativeTo = date,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		width = 186,
		text = ns.strings.about.author:gsub("#AUTHOR", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "Author"), "FFFFFFFF")),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})

	--Text: License
	wt.CreateText({
		parent = aboutPanel,
		name = "License",
		position = {
			relativeTo = author,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		width = 156,
		text = ns.strings.about.license:gsub("#LICENSE", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "X-License"), "FFFFFFFF")),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})

	--EditScrollBox: Changelog
	wt.CreateEditScrollBox({
		parent = aboutPanel,
		name = "Changelog",
		title = ns.strings.about.changelog.label,
		tooltip = { lines = { [0] = { text = ns.strings.about.changelog.tooltip, }, } },
		position = {
			relativeTo = version,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -12 }
		},
		size = { width = aboutPanel:GetWidth() - 32, height = 165 },
		text = ns.GetChangelog(),
		font = "GameFontDisableSmall",
		readOnly = true,
		scrollSpeed = 45,
	})

	--[ Support ]

	--Main panel
	local supportPanel = wt.CreatePanel({
		parent = mainPage.canvas,
		name = "Support",
		title = ns.strings.support.title,
		description = ns.strings.support.description,
		position = {
			relativeTo = aboutPanel,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 111 },
	})

	--Copybox: CurseForge
	wt.CreateCopyBox({
		parent = supportPanel,
		name = "CurseForge",
		title = ns.strings.support.curseForge .. ":",
		position = { offset = { x = 16, y = -33 } },
		size = { width = supportPanel:GetWidth() / 2 - 22, },
		text = "curseforge.com/wow/addons/widget-tools",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})

	--Copybox: Wago
	wt.CreateCopyBox({
		parent = supportPanel,
		name = "Wago",
		title = ns.strings.support.wago .. ":",
		position = {
			anchor = "TOP",
			offset = { x = (supportPanel:GetWidth() / 2 - 22) / 2 + 8, y = -33 }
		},
		size = { width = supportPanel:GetWidth() / 2 - 22, },
		text = "addons.wago.io/addons/widget-tools",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})

	--Copybox: Repository
	wt.CreateCopyBox({
		parent = supportPanel,
		name = "Repository",
		title = ns.strings.support.repository .. ":",
		position = { offset = { x = 16, y = -70 } },
		size = { width = supportPanel:GetWidth() / 2 - 22, },
		text = "github.com/Arxareon/widgetTools",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})

	--Copybox: Issues
	wt.CreateCopyBox({
		parent = supportPanel,
		name = "Issues",
		title = ns.strings.support.issues .. ":",
		position = {
			anchor = "TOP",
			offset = { x = (supportPanel:GetWidth() / 2 - 22) / 2 + 8, y = -70 }
		},
		size = { width = supportPanel:GetWidth() / 2 - 22, },
		text = "github.com/Arxareon/WidgetTools/issues",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})


	--[[ ADDON LIST ]]

	--[ Toolboxes ]

	--Increase the scroll height after the toolboxes are loaded
	local scrollHeight = 0

	--Toolbox versions in use
	local previousToolbox
	for key, value in wt.SortedPairs(registry.addons) do

		--Panel: Toolbox version
		local toolboxPanel = wt.CreatePanel({
			parent = addonsPage.scrollChild,
			name = "Toolbox" .. key,
			title = ns.strings.addons.toolbox:gsub("#VERSION", ns.strings.about.version:gsub("#VERSION", WrapTextInColorCode(key, "FFFFFFFF"))),
			position = {
				anchor = "TOPLEFT",
				relativeTo = previousToolbox,
				relativePoint = "BOTTOMLEFT",
				offset = { x = previousToolbox and 0 or 10, y = previousToolbox and -32 or -78 }
			},
			size = { width = addonsPage.scrollChild:GetWidth() - 32, height = 32 },
		})

		--Add to the scroll height
		scrollHeight = scrollHeight + (previousToolbox and 64 or 32)

		--Set toolbox reference
		previousToolbox = toolboxPanel

		--Reliant addons
		local previousAddon
		for k, v in wt.SortedPairs(value) do

			--Panel: Addon info
			local addonPanel = wt.CreatePanel({
				parent = toolboxPanel,
				name = k,
				title = wt.Clear(GetAddOnMetadata(k, "title")),
				description = GetAddOnMetadata(k, "Notes") or "…",
				position = {
					anchor = "TOPLEFT",
					relativeTo = previousAddon,
					relativePoint = "BOTTOMLEFT",
					offset = { x = previousAddon and 0 or 30, y = previousAddon and -24 or -30 }
				},
				size = { width = toolboxPanel:GetWidth() - 40, height = 48 },
				background = { color = { r = 0.1, g = 0.1, b = 0.1, a = 0.6 } },
			})

			--Logo texture
			local logo = wt.CreateTexture({
				parent = addonPanel,
				name = "Logo",
				position = {
					anchor = "LEFT",
					offset = { x = -18, }
				},
				size = { width = 44, height = 44 },
				path = v or ns.textures.missing,
			})

			--Update the addon info panel title & description
			_G[addonPanel:GetName() .. "Title"]:SetPoint("TOPLEFT", logo, "TOPLEFT", 8, 18)
			_G[addonPanel:GetName() .. "Description"]:SetPoint("TOPLEFT", logo, "TOPRIGHT", 8, -9)
			_G[addonPanel:GetName() .. "Title"]:SetWidth(_G[addonPanel:GetName() .. "Title"]:GetWidth() + 20)
			_G[addonPanel:GetName() .. "Description"]:SetWidth(_G[addonPanel:GetName() .. "Description"]:GetWidth() - 30)

			--Text: Version
			local addonVersion = wt.CreateText({
				parent = addonPanel,
				name = "Version",
				text = ns.strings.about.version:gsub("#VERSION", WrapTextInColorCode(GetAddOnMetadata(k, "Version") or "?", "FFFFFFFF")),
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = logo,
					relativePoint = "BOTTOMRIGHT",
					offset = { x = 8, y = 9 }
				},
				template = "GameFontNormalSmall",
				justify = "LEFT",
			})

			--Text: Date
			local addonDate = wt.CreateText({
				parent = addonPanel,
				name = "Date",
				text = ns.strings.about.date:gsub(
					"#DATE", WrapTextInColorCode(ns.strings.about.dateFormat:gsub(
						"#DAY", GetAddOnMetadata(k, "X-Day") or "?"
					):gsub(
						"#MONTH", GetAddOnMetadata(k, "X-Month") or "?"
					):gsub(
						"#YEAR", GetAddOnMetadata(k, "X-Year") or "?"
					), "FFFFFFFF")
				),
				position = {
					relativeTo = addonVersion,
					relativePoint = "TOPRIGHT",
					offset = { x = 10, }
				},
				template = "GameFontNormalSmall",
				justify = "LEFT",
			})

			--Text: Credits
			local addonAuthor = wt.CreateText({
				parent = addonPanel,
				name = "Credits",
				text = ns.strings.about.author:gsub("#AUTHOR", WrapTextInColorCode(GetAddOnMetadata(k, "Author") or "?", "FFFFFFFF")),
				position = {
					relativeTo = addonDate,
					relativePoint = "TOPRIGHT",
					offset = { x = 10, }
				},
				template = "GameFontNormalSmall",
				justify = "LEFT",
			})

			--Text: License
			wt.CreateText({
				parent = addonPanel,
				name = "License",
				text = ns.strings.about.license:gsub("#LICENSE", WrapTextInColorCode(GetAddOnMetadata(k, "X-License") or "?", "FFFFFFFF")),
				position = {
					relativeTo = addonAuthor,
					relativePoint = "TOPRIGHT",
					offset = { x = 10, }
				},
				template = "GameFontNormalSmall",
				justify = "LEFT",
			})

			--Increase the toolbox height
			local addonHeight = previousAddon and 72 or 59
			toolboxPanel:SetHeight(toolboxPanel:GetHeight() + addonHeight)

			--Add tot he scroll height
			scrollHeight = scrollHeight + addonHeight

			--Set addon reference
			previousAddon = addonPanel
		end
	end

	--[ Old Toolboxes ]

	--Panel: Old toolboxes
	local oldToolboxes = wt.CreatePanel({
		parent = addonsPage.scrollChild,
		name = "OldList",
		title = ns.strings.addons.old.title,
		description = ns.strings.addons.old.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = previousToolbox,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { width = previousToolbox:GetWidth(), height = 60 },
	})

	--Find old toolboxes
	local oldToolboxesText = ns.strings.addons.old.none:gsub("#ADDON", addonTitle)
	if WidgetToolbox then if next(WidgetToolbox) then
		local toolboxes = ""
		for key, _ in wt.SortedPairs(WidgetToolbox) do toolboxes = toolboxes .. " • " .. key end
		oldToolboxesText = WrapTextInColorCode(ns.strings.addons.old.inUse:gsub("#ADDON", addonTitle):gsub(
				"#TOOLBOXES",  WrapTextInColorCode(toolboxes:sub(5),  "FFFFFFFF")
			), wt.ColorToHex(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1, true, false))
	end end

	--Text: Old toolboxes
	wt.CreateText({
		parent = oldToolboxes,
		name = "OldToolboxes",
		text = oldToolboxesText,
		position = { offset = { x = 16, y = -33 } },
		template = "GameFontDisableSmall",
		justify = "LEFT",
	})

	--Increase the scroll height
	scrollHeight = scrollHeight + 92
	addonsPage.scrollChild:SetHeight(addonsPage.scrollChild:GetHeight() + scrollHeight + 12)
end