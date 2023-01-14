--[[ WIDGET TOOLS DATA ]]

--Local toolbox registry
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


--[[ INITIALIZATION ]]

---Addon namespace
---@class ns
local addonNameSpace, ns = ...

--Frame
local frame = CreateFrame("Frame", addonNameSpace .. "Frame")

--Event handler
frame:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)

--Add the WidgetTools about info to the Settings
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
function frame:PLAYER_ENTERING_WORLD()
	frame:UnregisterEvent("PLAYER_ENTERING_WORLD")


	--[[ RESOURCES ]]

	---WidgetTools toolbox
	---@class wt
	local wt = ns.WidgetToolbox

	--Addon display name
	local addonTitle = wt.Clear(select(2, GetAddOnInfo(addonNameSpace))):gsub("^%s*(.-)%s*$", "%1")


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
		position = { offset = { x = wt.classic and 16 or 10, y = -82 } },
		size = { height = 64 },
	})

	--Button: Addon List page
	wt.CreateButton({
		parent = shortcutsPanel,
		name = "AddonsPage",
		title = ns.strings.addons.title,
		tooltip = { lines = {
			{ text =  ns.strings.addons.description:gsub("#ADDON", addonTitle), },
			[2] = not wt.classic and { text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON",  addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, } or nil,
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
		size = { height = 260 },
	})

	--Text: Version
	local version = wt.CreateText({
		parent = aboutPanel,
		name = "VersionTitle",
		position = { offset = { x = 16, y = -32 } },
		width = 45,
		text = ns.strings.about.version .. ":",
		font = "GameFontNormalSmall",
		justify = { h = "RIGHT", },
	})
	wt.CreateText({
		parent = aboutPanel,
		name = "Version",
		position = {
			relativeTo = version,
			relativePoint = "TOPRIGHT",
			offset = { x = 5 }
		},
		width = 140,
		text = GetAddOnMetadata(addonNameSpace, "Version"),
		font = "GameFontHighlightSmall",
		justify = { h = "LEFT", },
	})

	--Text: Date
	local date = wt.CreateText({
		parent = aboutPanel,
		name = "DateTitle",
		position = {
			relativeTo = version,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		width = 45,
		text = ns.strings.about.date .. ":",
		font = "GameFontNormalSmall",
		justify = { h = "RIGHT", },
	})
	wt.CreateText({
		parent = aboutPanel,
		name = "Date",
		position = {
			relativeTo = date,
			relativePoint = "TOPRIGHT",
			offset = { x = 5 }
		},
		width = 140,
		text = ns.strings.about.dateFormat:gsub(
			"#DAY", GetAddOnMetadata(addonNameSpace, "X-Day")
		):gsub(
			"#MONTH", GetAddOnMetadata(addonNameSpace, "X-Month")
		):gsub(
			"#YEAR", GetAddOnMetadata(addonNameSpace, "X-Year")
		),
		font = "GameFontHighlightSmall",
		justify = { h = "LEFT", },
	})

	--Text: Author
	local author = wt.CreateText({
		parent = aboutPanel,
		name = "AuthorTitle",
		position = {
			relativeTo = date,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		width = 45,
		text = ns.strings.about.author .. ":",
		font = "GameFontNormalSmall",
		justify = { h = "RIGHT", },
	})
	wt.CreateText({
		parent = aboutPanel,
		name = "Author",
		position = {
			relativeTo = author,
			relativePoint = "TOPRIGHT",
			offset = { x = 5 }
		},
		width = 140,
		text = GetAddOnMetadata(addonNameSpace, "Author"),
		font = "GameFontHighlightSmall",
		justify = { h = "LEFT", },
	})

	--Text: License
	local license = wt.CreateText({
		parent = aboutPanel,
		name = "LicenseTitle",
		position = {
			relativeTo = author,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		width = 45,
		text = ns.strings.about.license .. ":",
		font = "GameFontNormalSmall",
		justify = { h = "RIGHT", },
	})
	wt.CreateText({
		parent = aboutPanel,
		name = "License",
		position = {
			relativeTo = license,
			relativePoint = "TOPRIGHT",
			offset = { x = 5 }
		},
		width = 140,
		text = GetAddOnMetadata(addonNameSpace, "X-License"),
		font = "GameFontHighlightSmall",
		justify = { h = "LEFT", },
	})

	--Copybox: CurseForge
	local curse = wt.CreateCopyBox({
		parent = aboutPanel,
		name = "CurseForge",
		title = ns.strings.about.curseForge .. ":",
		position = {
			relativeTo = license,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -11 }
		},
		size = { width = 190, },
		text = "curseforge.com/wow/addons/widget-tools",
		font = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})

	--Copybox: Wago
	local wago = wt.CreateCopyBox({
		parent = aboutPanel,
		name = "Wago",
		title = ns.strings.about.wago .. ":",
		position = {
			relativeTo = curse,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		size = { width = 190, },
		text = "addons.wago.io/addons/widget-tools",
		font = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})

	--Copybox: Repository
	local repo = wt.CreateCopyBox({
		parent = aboutPanel,
		name = "Repository",
		title = ns.strings.about.repository .. ":",
		position = {
			relativeTo = wago,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		size = { width = 190, },
		text = "github.com/Arxareon/widgetTools",
		font = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})

	--Copybox: Issues
	wt.CreateCopyBox({
		parent = aboutPanel,
		name = "Issues",
		title = ns.strings.about.issues .. ":",
		position = {
			relativeTo = repo,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		size = { width = 190, },
		text = "github.com/Arxareon/WidgetTools/issues",
		font = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})

	--EditScrollBox: Changelog
	local _, changelog = wt.CreateEditScrollBox({
		parent = aboutPanel,
		name = "Changelog",
		title = ns.strings.about.changelog.label,
		tooltip = { lines = { { text = ns.strings.about.changelog.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -17.5, y = -30 }
		},
		size = { width = aboutPanel:GetWidth() - 235.5, height = 192 },
		text = ns.GetChangelog(true),
		font = { normal = "GameFontDisableSmall", },
		color = ns.colors.grey[0],
		readOnly = true,
		scrollSpeed = 45,
	})

	--Button: Full changelog
	local changelogFrame
	wt.CreateButton({
		parent = aboutPanel,
		name = "OpenFullChangelog",
		title = ns.strings.about.openFullChangelog.label,
		tooltip = { lines = { { text = ns.strings.about.openFullChangelog.tooltip, }, } },
		position = {
			anchor = "BOTTOMRIGHT",
			relativeTo = changelog,
			relativePoint = "TOPRIGHT",
			offset = { x = 2.5, y = 6 }
		},
		size = { width = 180, height = 14 },
		font = {
			normal = "GameFontNormalSmall",
			highlight = "GameFontHighlightSmall",
		},
		events = { OnClick = function()
			if changelogFrame then changelogFrame:Show()
			else
				--Create the full changelog frame
				changelogFrame = wt.CreatePanel({
					parent = UIParent,
					name = addonNameSpace .. "Changelog",
					append = false,
					title = ns.strings.about.fullChangelog.label:gsub("#ADDON", addonTitle),
					position = { anchor = "CENTER", },
					size = { width = 740, height = 560 },
					background = { color = { a = 0.9 }, },
				})
				wt.SetPosition(_G[changelogFrame:GetName() .. "Title"], { offset = { x = 16, y = -16 } })
				wt.SetMovability(changelogFrame, true)
				changelogFrame:SetClampedToScreen(true)
				changelogFrame:SetFrameStrata("DIALOG")
				changelogFrame:IsToplevel(true)

				--EditScrollBox: Full changelog
				local _, fullChangelog = wt.CreateEditScrollBox({
					parent = changelogFrame,
					name = "FullChangelog",
					label = false,
					tooltip = { lines = { { text = ns.strings.about.fullChangelog.tooltip, }, } },
					position = {
						anchor = "TOPRIGHT",
						offset = { x = -16, y = -42 }
					},
					size = { width = changelogFrame:GetWidth() - 32, height = changelogFrame:GetHeight() - 90.5 },
					text = ns.GetChangelog(),
					font = { normal = "GameFontDisable", },
					color = ns.colors.grey[0],
					readOnly = true,
					scrollSpeed = 90,
				})

				--Button: Close
				wt.CreateButton({
					parent = changelogFrame,
					name = "CancelButton",
					title = wt.GetStrings("Close"),
					position = {
						anchor = "TOPRIGHT",
						relativeTo = fullChangelog,
						relativePoint = "BOTTOMRIGHT",
						offset = { x = 6, y = -13 }
					},
					events = { OnClick = function() changelogFrame:Hide() end },
				})
			end
		end, },
	})

	--[ Sponsors ]

	local top = GetAddOnMetadata(addonNameSpace, "X-TopSponsors")
	local normal = GetAddOnMetadata(addonNameSpace, "X-Sponsors")
	if top or normal then
		--Main panel
		local sponsorsPanel = wt.CreatePanel({
			parent = mainPage.canvas,
			name = "Sponsors",
			title = ns.strings.sponsors.title,
			description = ns.strings.sponsors.description,
			position = {
				relativeTo = aboutPanel,
				relativePoint = "BOTTOMLEFT",
				offset = { y = -32 }
			},
			size = { height = 64 + (top and normal and 24 or 0) },
		})
		wt.CreateText({
			parent = sponsorsPanel,
			name = "DescriptionHeart",
			position = { offset = { x = _G[sponsorsPanel:GetName() .. "Description"]:GetStringWidth() + 16, y = -10 } },
			text = "♥",
			font = "ChatFontSmall",
			justify = { h = "LEFT", },
		})

		--Top sponsors
		if top then
			wt.CreateText({
				parent = sponsorsPanel,
				name = "Top",
				position = { offset = { x = 16, y = -33 } },
				width = sponsorsPanel:GetWidth() - 32,
				text = top:gsub("|", " • "),
				font = "GameFontNormalLarge",
				justify = { h = "LEFT", },
			})
		end

		--Sponsors
		if normal then
			wt.CreateText({
				parent = sponsorsPanel,
				name = "Normal",
				position = { offset = { x = 16, y = -33 -(top and 24 or 0) } },
				width = sponsorsPanel:GetWidth() - 32,
				text = normal:gsub("|", " • "),
				font = "GameFontHighlightMedium",
				justify = { h = "LEFT", },
			})
		end
	end


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
			title = ns.strings.addons.toolbox:gsub("#VERSION", ns.strings.about.compactVersion:gsub("#VERSION", WrapTextInColorCode(key, "FFFFFFFF"))),
			position = {
				anchor = "TOPLEFT",
				relativeTo = previousToolbox,
				relativePoint = "BOTTOMLEFT",
				offset = { x = previousToolbox and 0 or (wt.classic and 16 or 10), y = previousToolbox and -32 or -78 }
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
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = logo,
					relativePoint = "BOTTOMRIGHT",
					offset = { x = 8, y = 9 }
				},
				text = ns.strings.about.compactVersion:gsub("#VERSION", WrapTextInColorCode(GetAddOnMetadata(k, "Version") or "?", "FFFFFFFF")),
				font = "GameFontNormalSmall",
				justify = { h = "LEFT", },
			})

			--Text: Date
			local addonDate = wt.CreateText({
				parent = addonPanel,
				name = "Date",
				position = {
					relativeTo = addonVersion,
					relativePoint = "TOPRIGHT",
					offset = { x = 10, }
				},
				text = ns.strings.about.compactDate:gsub(
					"#DATE", WrapTextInColorCode(ns.strings.about.dateFormat:gsub(
						"#DAY", GetAddOnMetadata(k, "X-Day") or "?"
					):gsub(
						"#MONTH", GetAddOnMetadata(k, "X-Month") or "?"
					):gsub(
						"#YEAR", GetAddOnMetadata(k, "X-Year") or "?"
					), "FFFFFFFF")
				),
				font = "GameFontNormalSmall",
				justify = "LEFT",
			})

			--Text: Credits
			local addonAuthor = wt.CreateText({
				parent = addonPanel,
				name = "Credits",
				position = {
					relativeTo = addonDate,
					relativePoint = "TOPRIGHT",
					offset = { x = 10, }
				},
				text = ns.strings.about.compactAuthor:gsub("#AUTHOR", WrapTextInColorCode(GetAddOnMetadata(k, "Author") or "?", "FFFFFFFF")),
				font = "GameFontNormalSmall",
				justify = { h = "LEFT", },
			})

			--Text: License
			wt.CreateText({
				parent = addonPanel,
				name = "License",
				position = {
					relativeTo = addonAuthor,
					relativePoint = "TOPRIGHT",
					offset = { x = 10, }
				},
				text = ns.strings.about.compactLicense:gsub("#LICENSE", WrapTextInColorCode(GetAddOnMetadata(k, "X-License") or "?", "FFFFFFFF")),
				font = "GameFontNormalSmall",
				justify = { h = "LEFT", },
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
		description = ns.strings.addons.old.description,
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
		oldToolboxesText = WrapTextInColorCode(ns.strings.addons.old.inUse:gsub(
			"#TOOLBOXES",  WrapTextInColorCode(toolboxes:sub(5),  "FFFFFFFF")
		), wt.ColorToHex(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1, true, false))
	end end

	--Text: Old toolboxes
	wt.CreateText({
		parent = oldToolboxes,
		name = "OldToolboxes",
		position = { offset = { x = 16, y = -33 } },
		text = oldToolboxesText,
		font = "GameFontDisableSmall",
		justify = { h = "LEFT", },
	})

	--Increase the scroll height
	scrollHeight = scrollHeight + 92
	addonsPage.scrollChild:SetHeight(addonsPage.scrollChild:GetHeight() + scrollHeight + 12)
end