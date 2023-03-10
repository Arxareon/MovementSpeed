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

	--[ Resources ]

	---WidgetTools toolbox
	---@class wt
	local wt = ns.WidgetToolbox

	--Addon display name
	local addonTitle = wt.Clear(select(2, GetAddOnInfo(addonNameSpace))):gsub("^%s*(.-)%s*$", "%1")

	--Local frame references
	local frames = {}


	--[ Settings Category Pages ]

	--Main page
	local mainPage = wt.CreateOptionsCategory({
		addon = addonNameSpace,
		name = "About",
		appendOptions = false,
		description = GetAddOnMetadata(addonNameSpace, "Notes"),
		logo = ns.textures.logo,
		titleLogo = true,
		initialize = function(canvas)
			--Panel: Shortcuts
			if wt.classic then wt.CreatePanel({ --FIXME: Reinstate once opening settings subcategories programmatically is once again supported in Dragonflight
				parent = canvas,
				name = "Shortcuts",
				title = ns.strings.shortcuts.title,
				description = ns.strings.shortcuts.description:gsub("#ADDON", addonTitle),
				arrange = {},
				size = { height = 64 },
				initialize = function(panel)
					--Button: Addon List page
					wt.CreateButton({
						parent = panel,
						name = "AddonsPage",
						title = ns.strings.addons.title,
						tooltip = { lines = { { text =  ns.strings.addons.description:gsub("#ADDON", addonTitle), }, } },
						arrange = {},
						size = { width = 160, },
						events = { OnClick = function() frames.addonsPage.open() end, },
					})
				end,
				arrangement = {}
			}) end

			--Panel: About
			wt.CreatePanel({
				parent = canvas,
				name = "About",
				title = ns.strings.about.title,
				description = ns.strings.about.description:gsub("#ADDON", addonTitle),
				arrange = {},
				size = { height = 258 },
				initialize = function(panel)
					--Text: Version
					local version = wt.CreateText({
						parent = panel,
						name = "VersionTitle",
						position = { offset = { x = 16, y = -32 } },
						width = 45,
						text = ns.strings.about.version .. ":",
						font = "GameFontNormalSmall",
						justify = { h = "RIGHT", },
					})
					wt.CreateText({
						parent = panel,
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
						parent = panel,
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
						parent = panel,
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
						parent = panel,
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
						parent = panel,
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
						parent = panel,
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
						parent = panel,
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
						parent = panel,
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
						parent = panel,
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
						parent = panel,
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
						parent = panel,
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
					local changelog = wt.CreateEditScrollBox({
						parent = panel,
						name = "Changelog",
						title = ns.strings.about.changelog.label,
						tooltip = { lines = { { text = ns.strings.about.changelog.tooltip, }, } },
						arrange = {},
						size = { width = panel:GetWidth() - 225, height = panel:GetHeight() - 42 },
						text = ns.GetChangelog(true),
						font = { normal = "GameFontDisableSmall", },
						color = ns.colors.grey[0],
						readOnly = true,
						scrollSpeed = 50,
					})

					--Button: Full changelog
					local changelogFrame
					wt.CreateButton({
						parent = panel,
						name = "OpenFullChangelog",
						title = ns.strings.about.openFullChangelog.label,
						tooltip = { lines = { { text = ns.strings.about.openFullChangelog.tooltip, }, } },
						position = {
							anchor = "TOPRIGHT",
							relativeTo = changelog,
							relativePoint = "TOPRIGHT",
							offset = { x = -3, y = 2 }
						},
						size = { width = 176, height = 14 },
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
						},
						events = { OnClick = function()
							if changelogFrame then changelogFrame:Show()
							else
								--Panel: Changelog frame
								changelogFrame = wt.CreatePanel({
									parent = UIParent,
									name = addonNameSpace .. "Changelog",
									append = false,
									title = ns.strings.about.fullChangelog.label:gsub("#ADDON", addonTitle),
									position = { anchor = "CENTER", },
									keepInBounds = true,
									size = { width = 740, height = 560 },
									background = { color = { a = 0.9 }, },
									initialize = function(windowPanel)
										--EditScrollBox: Full changelog
										wt.CreateEditScrollBox({
											parent = windowPanel,
											name = "FullChangelog",
											title = ns.strings.about.fullChangelog.label:gsub("#ADDON", addonTitle),
											label = false,
											tooltip = { lines = { { text = ns.strings.about.fullChangelog.tooltip, }, } },
											arrange = {},
											size = { width = windowPanel:GetWidth() - 32, height = windowPanel:GetHeight() - 88 },
											text = ns.GetChangelog(),
											font = { normal = "GameFontDisable", },
											color = ns.colors.grey[0],
											readOnly = true,
											scrollSpeed = 120,
										})

										--Button: Close
										wt.CreateButton({
											parent = windowPanel,
											name = "CancelButton",
											title = wt.GetStrings("close"),
											arrange = {},
											events = { OnClick = function() windowPanel:Hide() end },
										})
									end,
									arrangement = {
										margins = { l = 16, r = 16, t = 42, b = 16 },
										flip = true,
									}
								})
								_G[changelogFrame:GetName() .. "Title"]:SetPoint("TOPLEFT", 18, -18)
								wt.SetMovability(changelogFrame, true)
								changelogFrame:SetFrameStrata("DIALOG")
								changelogFrame:IsToplevel(true)
							end
						end, },
					}):SetFrameLevel(changelog:GetFrameLevel() + 1) --Make sure it's on top to be clickable
				end,
				arrangement = {
					flip = true,
					resize = false
				}
			})

			--Panel: Sponsors
			local top = GetAddOnMetadata(addonNameSpace, "X-TopSponsors")
			local normal = GetAddOnMetadata(addonNameSpace, "X-Sponsors")
			if top or normal then
				local sponsorsPanel = wt.CreatePanel({
					parent = canvas,
					name = "Sponsors",
					title = ns.strings.sponsors.title,
					description = ns.strings.sponsors.description,
					arrange = {},
					size = { height = 64 + (top and normal and 24 or 0) },
					initialize = function(panel)
						if top then
							wt.CreateText({
								parent = panel,
								name = "Top",
								position = { offset = { x = 16, y = -33 } },
								width = panel:GetWidth() - 32,
								text = top:gsub("|", " • "),
								font = "GameFontNormalLarge",
								justify = { h = "LEFT", },
							})
						end
						if normal then
							wt.CreateText({
								parent = panel,
								name = "Normal",
								position = { offset = { x = 16, y = -33 -(top and 24 or 0) } },
								width = panel:GetWidth() - 32,
								text = normal:gsub("|", " • "),
								font = "GameFontHighlightMedium",
								justify = { h = "LEFT", },
							})
						end
					end,
				})
				wt.CreateText({
					parent = sponsorsPanel,
					name = "DescriptionHeart",
					position = { offset = { x = _G[sponsorsPanel:GetName() .. "Description"]:GetStringWidth() + 16, y = -10 } },
					text = "♥",
					font = "ChatFontSmall",
					justify = { h = "LEFT", },
				})
			end
		end,
		arrangement = {}
	})

	--Addons page
	frames.addonsPage = wt.CreateOptionsCategory({
		parent = mainPage.category,
		addon = addonNameSpace,
		name = "Addons",
		appendOptions = false,
		title = ns.strings.addons.title,
		description = ns.strings.addons.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		scroll = { speed = 72, },
		optionsKeys = { addonNameSpace, },
		initialize = function(canvas)
			--List Toolbox versions in use
			for key, value in wt.SortedPairs(registry.addons) do
				--Panel: Toolbox
				wt.CreatePanel({
					parent = canvas,
					name = "Toolbox" .. key,
					title = ns.strings.addons.toolbox:gsub("#VERSION", ns.strings.about.compactVersion:gsub("#VERSION", WrapTextInColorCode(key, "FFFFFFFF"))),
					arrange = {},
					size = { height = 32 },
					initialize = function(toolboxPanel)
						--List reliant addons
						for k, v in wt.SortedPairs(value) do
							--Panel: Addon info
							wt.CreatePanel({
								parent = toolboxPanel,
								name = k,
								title = wt.Clear(GetAddOnMetadata(k, "title")),
								description = GetAddOnMetadata(k, "Notes") or "…",
								arrange = {},
								size = { width = toolboxPanel:GetWidth() - 40, height = 48 },
								background = { color = { r = 0.1, g = 0.1, b = 0.1, a = 0.6 } },
								initialize = function(addonPanel)
									--Logo texture
									local logo = wt.CreateTexture({
										parent = addonPanel,
										name = "Logo",
										position = {
											anchor = "LEFT",
											offset = { x = -16, }
										},
										size = { width = 44, height = 44 },
										path = v or ns.textures.missing,
									})

									--Update the addon info panel title & description
									_G[addonPanel:GetName() .. "Title"]:SetPoint("TOPLEFT", logo, "TOPLEFT", 8, 18)
									_G[addonPanel:GetName() .. "Description"]:SetPoint("TOPLEFT", logo, "TOPRIGHT", 8, -9)
									_G[addonPanel:GetName() .. "Title"]:SetWidth(_G[addonPanel:GetName() .. "Title"]:GetWidth() + 20)
									_G[addonPanel:GetName() .. "Description"]:SetWidth(_G[addonPanel:GetName() .. "Description"]:GetWidth() - 30)

									--Checkbox: Toggle
									local function toggleAddon(state)
										if state then
											EnableAddOn(k)
											addonPanel:SetAlpha(1)
										else
											DisableAddOn(k)
											addonPanel:SetAlpha(0.5)
										end
									end
									wt.CreateCheckbox({
										parent = addonPanel,
										title = ns.strings.about.toggle.label,
										tooltip = { lines = { { text = ns.strings.about.toggle.tooltip }, } },
										position = {
											anchor = "BOTTOMRIGHT",
											relativeTo = addonPanel,
											relativePoint = "TOPRIGHT",
											offset = { x = -12, }
										},
										size = { width = 80, height = 20 },
										events = { OnClick = function(_, state) toggleAddon(state) end, },
										optionsData = {
											optionsKey = addonNameSpace,
											convertLoad = function() return GetAddOnEnableState(nil, k) > 0 end,
											onSave = function(_, state) if not state then wt.CreateReloadNotice() end end,
											onLoad = function(_, state) toggleAddon(state) end,
										}
									})

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
								end,
							})
						end
					end,
					arrangement = {
						margins = { t = 28, },
						gaps = 24,
						flip = true,
					}
				})
			end

			--Panel: Old toolboxes
			wt.CreatePanel({
				parent = canvas,
				name = "OldList",
				title = ns.strings.addons.old.title,
				description = ns.strings.addons.old.description,
				arrange = {},
				size = { height = 60 },
				initialize = function (panel)
					--Find old toolboxes
					local oldToolboxes = ns.strings.addons.old.none:gsub("#ADDON", addonTitle)
					if WidgetToolbox then if next(WidgetToolbox) then
						local toolboxes = ""
						for key, _ in wt.SortedPairs(WidgetToolbox) do toolboxes = toolboxes .. " • " .. key end
						oldToolboxes = WrapTextInColorCode(ns.strings.addons.old.inUse:gsub(
							"#TOOLBOXES",  WrapTextInColorCode(toolboxes:sub(5),  "FFFFFFFF")
						), wt.ColorToHex(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1, true, false))
					end end

					--Text: Old toolboxes
					wt.CreateText({
						parent = panel,
						name = "OldToolboxes",
						position = { offset = { x = 16, y = -33 } },
						text = oldToolboxes,
						font = "GameFontDisableSmall",
						justify = { h = "LEFT", },
					})
				end
			})
		end,
		arrangement = {}
	})
end