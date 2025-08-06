--[[ NAMESPACE ]]

---@class WidgetToolsNamespace
local ns = select(2, ...)


--[[ TOOLBOX MANAGEMENT ]]

local registry = { toolbox = {}, addons = {} }

--Global WidgetTools table
WidgetTools = {}

---Register or get a read-only reference of a WidgetTools toolbox under the specified version key
---***
---@param addon string Addon namespace (the name of the addon's folder, not its display title) to register for WidgetTools usage
---@param version string Version key the **toolbox** should be registered under
---@param toolbox? table Reference to the table to register as a WidgetTools toolbox
---***
---@return table|nil? toolbox Reference to the toolbox table registered under the **version** key
function WidgetTools.RegisterToolbox(addon, version, toolbox)
	if not addon or not version or (not registry.toolbox[version] and not toolbox) then return nil end

	--Register the addon
	if C_AddOns.IsAddOnLoaded(addon) then
		registry.addons[version] = registry.addons[version] or {}
		table.insert(registry.addons[version], addon)
	else return nil end

	--Register the toolbox
	registry.toolbox[version] = registry.toolbox[version] or toolbox

	return registry.toolbox[version]
end


--[[ INITIALIZATION ]]

--Initialization frame
WidgetTools.frame = CreateFrame("Frame", ns.name .. "InitializationFrame")

--Event handler
WidgetTools.frame:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)

WidgetTools.frame:RegisterEvent("PLAYER_LOGIN")

function WidgetTools.frame:PLAYER_LOGIN()
	WidgetTools.frame:UnregisterEvent("PLAYER_LOGIN")


	--[[ RESOURCES ]]

	---@class wt
	local wt = ns.WidgetToolbox

	---@type chatCommandManager
	local chatCommands

	--[ Data ]

	--Loaded DB snapshot
	local loaded = wt.Clone(WidgetToolsDB)


	--[[ DEV TOOLS ]]

	if WidgetToolsDB.frameAttributes.enabled then WidgetTools.frame:RegisterEvent("FRAMESTACK_VISIBILITY_UPDATED") end


	--[[ SETTINGS ]]

	--| Main Page

	local mainPage = wt.CreateAboutPage(ns.name, {
		register = true,
		name = "About",
		changelog = ns.changelog
	})

	--| Specifications Page

	---@type checkbox
	local liteToggle

	local specificationsPage = wt.CreateSettingsPage(ns.name, {
		register = mainPage,
		name = "Specifications",
		title = ns.strings.specifications.title,
		description = ns.strings.specifications.description,
		storage = { { storageTable = WidgetToolsDB, defaultsTable = ns.defaults, }, },
		dataManagement = {},
		arrangement = {},
		initialize = function(canvas, _, _, category, keys)
			wt.CreatePanel({
				parent = canvas,
				name = "General",
				title = ns.strings.specifications.general.title,
				description = ns.strings.specifications.general.description,
				arrange = {},
				arrangement = {},
				initialize = function(panel)
					local silentSave = false

					local enableLitePopup = wt.RegisterPopupDialog(ns.name, "ENABLE_LITE_MODE", {
						text = ns.strings.lite.enable.warning:gsub("#ADDON", ns.title),
						accept = ns.strings.lite.enable.accept,
						onAccept = function()
							liteToggle.setState(true)
							liteToggle.saveData(nil, silentSave)

							chatCommands.print(ns.strings.chat.lite.response:gsub("#STATE", VIDEO_OPTIONS_ENABLED:lower()))
						end,
					})
					local disableLitePopup = wt.RegisterPopupDialog(ns.name, "DISABLE_LITE_MODE", {
						text = ns.strings.lite.disable.warning:gsub("#ADDON", ns.title),
						accept = ns.strings.lite.disable.accept,
						onAccept = function()
							liteToggle.setState(false)
							liteToggle.saveData(nil, silentSave)

							chatCommands.print(ns.strings.chat.lite.response:gsub("#STATE", VIDEO_OPTIONS_DISABLED:lower()))
						end,
					})

					liteToggle = wt.CreateCheckbox({
						parent = panel,
						name = "LiteMode",
						title = ns.strings.specifications.general.lite.label,
						tooltip = { lines = { { text = ns.strings.specifications.general.lite.tooltip:gsub("#COMMAND", WrapTextInColorCode("/wt lite", "FFFFFFFF")), }, } },
						arrange = {},
						getData = function() return WidgetToolsDB.lite end,
						saveData = function(state) WidgetToolsDB.lite = state end,
						default = false,
						instantSave = false,
						listeners = {
							saved = { { handler = function()
								silentSave = false

								if loaded.lite ~= WidgetToolsDB.lite then wt.CreateReloadNotice() end end,
							}, },
							toggled = { { handler = function(_, state, user)
								if not user then return end

								if state then StaticPopup_Show(enableLitePopup) else StaticPopup_Show(disableLitePopup) end

								liteToggle.setState(not state, false) --Wait for popup response
							end }, },
						},
						events = { OnClick = function() silentSave = true end, },
						dataManagement = {
							category = category,
							key = keys[1],
						},
					})

					wt.CreateCheckbox({
						parent = panel,
						name = "PositioningAids",
						title = ns.strings.specifications.general.positioningAids.label,
						tooltip = { lines = { { text = ns.strings.specifications.general.positioningAids.tooltip, }, } },
						arrange = {},
						getData = function() return WidgetToolsDB.positioningAids end,
						saveData = function(state) WidgetToolsDB.positioningAids = state end,
						listeners = { saved = { { handler = function() if loaded.positioningAids ~= WidgetToolsDB.positioningAids then wt.CreateReloadNotice() end end, }, }, },
						instantSave = false,
						dataManagement = {
							category = category,
							key = keys[1],
						},
						default = true,
					})
				end,
			})

			wt.CreatePanel({
				parent = canvas,
				name = "DevTools",
				title = ns.strings.specifications.dev.title,
				description = ns.strings.specifications.dev.description,
				arrange = {},
				arrangement = {},
				initialize = function(panel)
					local toggle = wt.CreateCheckbox({
						parent = panel,
						name = "ToggleWideFrameAttributes",
						title = ns.strings.specifications.dev.frameAttributes.enabled.label,
						tooltip = { lines = { { text = ns.strings.specifications.dev.frameAttributes.enabled.tooltip, }, } },
						arrange = {},
						getData = function() return WidgetToolsDB.frameAttributes.enabled end,
						saveData = function(state) WidgetToolsDB.frameAttributes.enabled = state end,
						default = false,
						dataManagement = {
							category = category,
							key = keys[1],
							onChange = { ToggleWideFrameAttributes = function()
								if WidgetToolsDB.frameAttributes.enabled then
									if _G["TableAttributeDisplay"] then
										TableAttributeDisplay:SetWidth(WidgetToolsDB.frameAttributes.width + 70)
										TableAttributeDisplay.LinesScrollFrame:SetWidth(WidgetToolsDB.frameAttributes.width)
									end

									WidgetTools.frame:RegisterEvent("FRAMESTACK_VISIBILITY_UPDATED")
								else
									if _G["TableAttributeDisplay"] then
										TableAttributeDisplay:SetWidth(500)
										TableAttributeDisplay.LinesScrollFrame:SetWidth(430)
									end

									WidgetTools.frame:UnregisterEvent("FRAMESTACK_VISIBILITY_UPDATED")
								end
							end, },
						},
					})

					wt.CreateNumericSlider({
						parent = panel,
						name = "FrameAttributesWidth",
						title = ns.strings.specifications.dev.frameAttributes.width.label,
						tooltip = { lines = { { text = ns.strings.specifications.dev.frameAttributes.width.tooltip, }, } },
						arrange = { newRow = false, },
						min = 200,
						max = 1400,
						step = 20,
						altStep = 1,
						dependencies = { { frame = toggle, } },
						getData = function() return WidgetToolsDB.frameAttributes.width end,
						saveData = function(value) WidgetToolsDB.frameAttributes.width = value end,
						default = 620,
						dataManagement = {
							category = category,
							key = keys[1],
							onChange = { ResizeWideFrameAttributes = function() if _G["TableAttributeDisplay"] then
								TableAttributeDisplay:SetWidth(WidgetToolsDB.frameAttributes.width + 70)
								TableAttributeDisplay.LinesScrollFrame:SetWidth(WidgetToolsDB.frameAttributes.width)
							end end, },
						},
					})
				end,
			})
		end,
	})

	--| Addons Page

	local addonsPage = wt.CreateSettingsPage(ns.name, {
		register = mainPage,
		name = "Addons",
		title = ns.strings.addons.title,
		description = ns.strings.addons.description:gsub("#ADDON", ns.title),
		scroll = { speed = 0.2 },
		static = true,
		dataManagement = {},
		arrangement = {},
		initialize = function(canvas, _, _, category, keys)

			--[ List Toolbox Versions ]

			for toolboxVersion, addons in wt.SortedPairs(registry.addons) do
				wt.CreatePanel({
					parent = canvas,
					name = "Toolbox" .. toolboxVersion,
					title = ns.strings.addons.toolbox:gsub("#VERSION", ns.strings.about.version:gsub("#VERSION", WrapTextInColorCode(toolboxVersion, "FFFFFFFF"))),
					arrange = {},
					size = { h = 32 },
					arrangement = {
						margins = { l = 30, },
						gaps = 10,
					},
					initialize = function(toolboxPanel, width)

						--[ List Reliant Addons ]

						for i = 1, #addons do if C_AddOns.IsAddOnLoaded(addons[i]) then
							local data = {
								title = C_AddOns.GetAddOnMetadata(addons[i], "Title"),
								version = C_AddOns.GetAddOnMetadata(addons[i], "Version"),
								day = C_AddOns.GetAddOnMetadata(addons[i], "X-Day"),
								month = C_AddOns.GetAddOnMetadata(addons[i], "X-Month"),
								year = C_AddOns.GetAddOnMetadata(addons[i], "X-Year"),
								category = C_AddOns.GetAddOnMetadata(addons[i], "Category"),
								notes = C_AddOns.GetAddOnMetadata(addons[i], "Notes"),
								author = C_AddOns.GetAddOnMetadata(addons[i], "Author"),
								license = C_AddOns.GetAddOnMetadata(addons[i], "X-License"),
								curse = C_AddOns.GetAddOnMetadata(addons[i], "X-CurseForge"),
								wago = C_AddOns.GetAddOnMetadata(addons[i], "X-Wago"),
								repo = C_AddOns.GetAddOnMetadata(addons[i], "X-Repository"),
								issues = C_AddOns.GetAddOnMetadata(addons[i], "X-Issues"),
								sponsors = C_AddOns.GetAddOnMetadata(addons[i], "X-Sponsors"),
								topSponsors = C_AddOns.GetAddOnMetadata(addons[i], "X-TopSponsors"),
								logo = C_AddOns.GetAddOnMetadata(addons[i], "IconTexture"),
							}

							wt.CreatePanel({
								parent = toolboxPanel,
								name = addons[i],
								label = false,
								arrange = {},
								size = { w = width - 42, h = 84 },
								background = { color = { r = 0.1, g = 0.1, b = 0.1, a = 0.6 } },
								arrangement = {
									margins = { l = 34, },
									resize = false,
								},
								initialize = function(addonPanel)
									wt.CreateTexture({
										parent = addonPanel,
										name = "Logo",
										position = {
											anchor = "TOP",
											relativeTo = addonPanel,
											relativePoint = "TOPLEFT",
											offset = { x = 3, y = -3 }
										},
										size = { w = 38, h = 38 },
										path = data.logo or ns.textures.missing,
									})

									--| Toggle

									local function toggleAddon(state)
										if state then
											C_AddOns.EnableAddOn(addons[i])
											addonPanel:SetAlpha(1)
										else
											C_AddOns.DisableAddOn(addons[i])
											addonPanel:SetAlpha(0.5)
										end
									end

									local toggle = wt.CreateCheckbox({
										parent = addonPanel,
										name = "Toggle",
										title = wt.Color(C_AddOns.GetAddOnMetadata(addons[i], "Title"), wt.colors.highlight) .. " (" .. ns.strings.about.toggle.label .. ")",
										tooltip = { lines = { { text = ns.strings.about.toggle.tooltip, }, } },
										arrange = {},
										size = { w = 300, },
										font = { normal = "GameFontNormalMed1", },
										getData = function() return C_AddOns.GetAddOnEnableState(addons[i]) > 0 end,
										saveData = function(state) toggleAddon(state) end,
										instantSave = false,
										listeners = { saved = { { handler = function(self) if not self.getState() then wt.CreateReloadNotice() end end, }, }, },
										events = { OnClick = function(_, state) toggleAddon(state) end, },
										showDefault = false,
										utilityMenu = false,
										dataManagement = {
											category = category,
											key = keys[1],
										},
									})

									if toggle.frame then toggle.frame:SetIgnoreParentAlpha(true) end

									--| Description

									if data.notes then wt.CreateText({
										parent = addonPanel,
										name = "Notes",
										position = { offset = { x = 16, y = -49 } },
										width = 318,
										height = 20,
										text = data.notes,
										font = "GameFontHighlightSmall",
										justify = { h = "LEFT", v = "TOP" },
									}) end

									--| Information

									local position = { offset = { x = 344, y = -13 } }

									if data.version then
										local version = wt.CreateText({
											parent = addonPanel,
											name = "VersionTitle",
											position = position,
											width = 48,
											text = wt.strings.about.version,
											font = "GameFontHighlightSmall",
											justify = { h = "RIGHT", },
										})

										wt.CreateText({
											parent = addonPanel,
											name = "Version",
											position = {
												relativeTo = version,
												relativePoint = "TOPRIGHT",
												offset = { x = 5 }
											},
											width = 140,
											text = data.version .. (data.day and data.month and data.year and WrapTextInColorCode(" ( " .. wt.strings.about.date .. ": " .. wt.Color(wt.strings.date:gsub(
												"#DAY", data.day
											):gsub(
												"#MONTH", data.month
											):gsub(
												"#YEAR", data.year
											), wt.colors.normal) .. ")", "FFFFFFFF") or ""),
											font = "GameFontNormalSmall",
											justify = { h = "LEFT", },
										})

										position.relativeTo = version
										position.relativePoint = "BOTTOMLEFT"
										position.offset.x = 0
										position.offset.y = -6
									end

									if data.category then
										local category = wt.CreateText({
											parent = addonPanel,
											name = "Category",
											position = position,
											width = 48,
											text = CATEGORY,
											font = "GameFontHighlightSmall",
											justify = { h = "RIGHT", },
											wrap = false,
										})

										wt.CreateText({
											parent = addonPanel,
											name = "Category",
											position = {
												relativeTo = category,
												relativePoint = "TOPRIGHT",
												offset = { x = 5 }
											},
											width = 140,
											text = data.category,
											font = "GameFontNormalSmall",
											justify = { h = "LEFT", },
										})

										position.relativeTo = category
										position.relativePoint = "BOTTOMLEFT"
										position.offset.x = 0
										position.offset.y = -6
									end

									if data.author then
										local author = wt.CreateText({
											parent = addonPanel,
											name = "AuthorTitle",
											position = position,
											width = 48,
											text = wt.strings.about.author,
											font = "GameFontHighlightSmall",
											justify = { h = "RIGHT", },
										})

										wt.CreateText({
											parent = addonPanel,
											name = "Author",
											position = {
												relativeTo = author,
												relativePoint = "TOPRIGHT",
												offset = { x = 5 }
											},
											width = 140,
											text = data.author,
											font = "GameFontNormalSmall",
											justify = { h = "LEFT", },
										})

										position.relativeTo = author
										position.relativePoint = "BOTTOMLEFT"
										position.offset.x = 0
										position.offset.y = -6
									end

									if data.license then
										local license = wt.CreateText({
											parent = addonPanel,
											name = "LicenseTitle",
											position = position,
											width = 48,
											text = wt.strings.about.license,
											font = "GameFontHighlightSmall",
											justify = { h = "RIGHT", },
										})

										wt.CreateText({
											parent = addonPanel,
											name = "License",
											position = {
												relativeTo = license,
												relativePoint = "TOPRIGHT",
												offset = { x = 5 }
											},
											width = 140,
											text = data.license,
											font = "GameFontNormalSmall",
											justify = { h = "LEFT", },
										})
									end
								end,
							})
						end end
					end,
				})
			end

			wt.CreatePanel({
				parent = canvas,
				name = "OldList",
				title = ns.strings.addons.old.title,
				description = ns.strings.addons.old.description,
				arrange = {},
				size = { h = 42 },
				initialize = function(panel)
					local oldToolboxes = ns.strings.addons.old.none:gsub("#ADDON", ns.title)

					if type(WidgetToolbox) == "table" and next(WidgetToolbox) then
						local toolboxes = ""

						--Find old toolboxes
						for k, _ in wt.SortedPairs(WidgetToolbox) do toolboxes = toolboxes .. " • " .. k end

						oldToolboxes = WrapTextInColorCode(ns.strings.addons.old.inUse:gsub(
							"#TOOLBOXES",  WrapTextInColorCode(toolboxes:sub(5), "FFFFFFFF")
						), wt.ColorToHex(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1, true, false))
					end

					wt.CreateText({
						parent = panel,
						name = "OldToolboxes",
						position = { offset = { x = 16, y = -16 } },
						text = oldToolboxes,
						font = "GameFontDisable",
						justify = { h = "LEFT", },
					})
				end,
			})
		end,
	})


	--[[ CHAT CONTROL ]]

	chatCommands = wt.RegisterChatCommands(ns.name, { ns.chat.keyword }, {
		commands = {
			{
				command = ns.chat.commands.about,
				description = ns.strings.chat.about.description,
				handler = mainPage.open,
			},
			{
				command = ns.chat.commands.lite,
				description = ns.strings.chat.lite.description,
				handler = function() liteToggle.setState(not WidgetToolsDB.lite, true) end,
			},
			{
				command = ns.chat.commands.dump,
				description = ns.strings.chat.dump.description,
				handler = function() wt.Dump(WidgetToolsDB, "WidgetToolsDB") end,
			},
			{
				command = ns.chat.commands.run,
				description = ns.strings.chat.run.description:gsub("#EXAMPLE", wt.Color("/wt run Dump { 1, \"a\", true, { print, UIParent, { 2 } } }; \"T\"; _; 2", ns.colors.grey[2])),
				handler = function(_, f, ...) print(f, wt[f]) return type(wt[f]) == "function", f, ... end,
				success = ns.strings.chat.run.success,
				error = ns.strings.chat.run.error,
				onSuccess = function(_, f, ...)
					local p = strsplittable(";", table.concat({ ... }, " "), nil)

					for i = 1, #p do _, p[i] = pcall(loadstring("return " .. p[i])) end

					wt[f](unpack(p))
				end,
			},
		},
		colors = {
			title = ns.colors.gold[1],
			content = ns.colors.gold[2],
			command = { r = 1, g = 1, b = 1, },
			description = ns.colors.grey[1]
		},
	})


	--[[ ADDON COMPARTMENT ]]

	wt.SetUpAddonCompartment(ns.name, {
		onClick = function()
			if WidgetToolsDB.lite then liteToggle.setState(false, true) else wt.CreateContextMenu({
				initialize = function(menu)
					wt.CreateMenuTextline(menu, { text = ns.title, })
					wt.CreateMenuButton(menu, {
						title = wt.GetStrings("about").title,
						action = mainPage.open
					})
					wt.CreateMenuButton(menu, {
						title = ns.strings.specifications.title,
						action = specificationsPage.open
					})
					wt.CreateMenuButton(menu, {
						title = ns.strings.addons.title,
						action = addonsPage.open
					})
				end,
				rightClickMenu = false,
			}).open() end
		end,
		onEnter = function(_, frame) frame.tooltipData.lines[5] = {
			text = "\n" .. (WidgetToolsDB.lite and ns.strings.compartment.lite or ns.strings.compartment.open),
			font = GameFontNormalTiny,
			color = ns.colors.grey[1],
		} end
	}, { lines = {
		{ text = ns.strings.about.version:gsub("#VERSION", WrapTextInColorCode(C_AddOns.GetAddOnMetadata(ns.name, "Version") or "?", "FFFFFFFF")), },
		{ text = ns.strings.about.date:gsub(
			"#DATE", WrapTextInColorCode(ns.strings.date:gsub(
				"#DAY", C_AddOns.GetAddOnMetadata(ns.name, "X-Day") or "?"
			):gsub(
				"#MONTH", C_AddOns.GetAddOnMetadata(ns.name, "X-Month") or "?"
			):gsub(
				"#YEAR", C_AddOns.GetAddOnMetadata(ns.name, "X-Year") or "?"
			), "FFFFFFFF")
		), },
		{ text = ns.strings.about.author:gsub("#AUTHOR", WrapTextInColorCode(C_AddOns.GetAddOnMetadata(ns.name, "Author") or "?", "FFFFFFFF")), },
		{ text = ns.strings.about.license:gsub("#LICENSE", WrapTextInColorCode(C_AddOns.GetAddOnMetadata(ns.name, "X-License") or "?", "FFFFFFFF")), },
		{
			text = "\n" .. (WidgetToolsDB.lite and ns.strings.compartment.lite or ns.strings.compartment.open),
			font = GameFontNormalTiny,
			color = ns.colors.grey[1],
		},
	} })
end

function WidgetTools.frame:FRAMESTACK_VISIBILITY_UPDATED()
	WidgetTools.frame:UnregisterEvent("FRAMESTACK_VISIBILITY_UPDATED")

	if _G["TableAttributeDisplay"] then
		TableAttributeDisplay:SetWidth(WidgetToolsDB.frameAttributes.width + 70)
		TableAttributeDisplay.LinesScrollFrame:SetWidth(WidgetToolsDB.frameAttributes.width)
	end
end