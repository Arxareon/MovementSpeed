--[[ RESOURCES ]]

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
	if IsAddOnLoaded(addon) then
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

WidgetTools.frame:RegisterEvent("PLAYER_ENTERING_WORLD")

function WidgetTools.frame:PLAYER_ENTERING_WORLD()
	WidgetTools.frame:UnregisterEvent("PLAYER_ENTERING_WORLD")


	--[[ RESOURCES ]]

	---@class wt
	local wt = ns.WidgetToolbox

	--Addon title
	local addonTitle = wt.Clear(select(2, GetAddOnInfo(ns.name))):gsub("^%s*(.-)%s*$", "%1")

	--[ Data ]

	--Working DB reference
	local w = wt.Clone(WidgetToolsDB)

	--Loaded DB reference
	local loaded = wt.Clone(WidgetToolsDB)


	--[[ DEV TOOLS ]]

	if WidgetToolsDB.frameAttributes.enabled then WidgetTools.frame:RegisterEvent("FRAMESTACK_VISIBILITY_UPDATED") end


	--[[ SETTINGS ]]

	--| Main Page

	local mainPage = wt.CreateAboutPage(ns.name, {
		name = "About",
		changelog = ns.changelog
	})

	--| Specifications Page

	wt.CreateOptionsCategory(ns.name, {
		parent = mainPage,
		name = "Specifications",
		title = ns.strings.specifications.title,
		description = ns.strings.specifications.description,
		logo = ns.textures.logo,
		optionsKeys = { ns.name .. "Specifications", },
		storage = { {
			workingTable = w,
			storageTable = WidgetToolsDB,
			defaultsTable = ns.defaults,
		}, },
		initialize = function(canvas)
			wt.CreatePanel({
				parent = canvas,
				name = "General",
				title = ns.strings.specifications.general.title,
				description = ns.strings.specifications.general.description,
				arrange = {},
				initialize = function(panel)
					local lite

					local popup = wt.CreatePopup(ns.name, {
						name = "DISABLE_LITE_MODE",
						text = ns.strings.specifications.general.lite.warning:gsub("#ADDON", addonTitle),
						accept = ns.strings.specifications.general.lite.accept,
						onAccept = function() lite.setState(true) end,
					})

					lite = wt.CreateCheckbox({
						parent = panel,
						name = "LiteMode",
						title = ns.strings.specifications.general.lite.label,
						tooltip = { lines = { { text = ns.strings.specifications.general.lite.tooltip, }, } },
						arrange = {},
						events = { OnClick = function (_, state)
							if state then StaticPopup_Show(popup) end

							lite.setState(false)
						end, },
						optionsData = {
							optionsKey = ns.name .. "Specifications",
							storageKey = "lite",
							workingTable = w,
							onCommit = function() if loaded.lite ~= w.lite then wt.CreateReloadNotice() end end,
						},
					})

					wt.CreateCheckbox({
						parent = panel,
						name = "PositioningAids",
						title = ns.strings.specifications.general.positioningAids.label,
						tooltip = { lines = { { text = ns.strings.specifications.general.positioningAids.tooltip, }, } },
						arrange = {},
						optionsData = {
							optionsKey = ns.name .. "Specifications",
							storageKey = "positioningAids",
							workingTable = w,
							onCommit = function() if loaded.positioningAids ~= w.positioningAids then wt.CreateReloadNotice() end end,
						},
					})
				end,
				arrangement = {}
			})

			wt.CreatePanel({
				parent = canvas,
				name = "DevTools",
				title = ns.strings.specifications.dev.title,
				description = ns.strings.specifications.dev.description,
				arrange = {},
				initialize = function(panel)
					local toggle = wt.CreateCheckbox({
						parent = panel,
						name = "ToggleWideFrameAttributes",
						title = ns.strings.specifications.dev.frameAttributes.enabled.label,
						tooltip = { lines = { { text = ns.strings.specifications.dev.frameAttributes.enabled.tooltip, }, } },
						arrange = {},
						optionsData = {
							optionsKey = ns.name .. "Specifications",
							storageKey = "enabled",
							workingTable = w.frameAttributes,
							onChange = { ToggleWideFrameAttributes = function()
								if w.frameAttributes.enabled then
									if _G["TableAttributeDisplay"] then
										TableAttributeDisplay:SetWidth(w.frameAttributes.width + 70)
										TableAttributeDisplay.LinesScrollFrame:SetWidth(w.frameAttributes.width)
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
						value = { min = 200, max = 1400, },
						step = 20,
						altStep = 1,
						dependencies = { { frame = toggle, } },
						optionsData = {
							optionsKey = ns.name .. "Specifications",
							storageKey = "width",
							workingTable = w.frameAttributes,
							onChange = { ResizeWideFrameAttributes = function() if _G["TableAttributeDisplay"] then
								TableAttributeDisplay:SetWidth(w.frameAttributes.width + 70)
								TableAttributeDisplay.LinesScrollFrame:SetWidth(w.frameAttributes.width)
							end end, },
						},
					})
				end,
				arrangement = {}
			})
		end,
		arrangement = {}
	})

	--| Addons Page

	wt.CreateOptionsCategory(ns.name, {
		parent = mainPage,
		name = "Addons",
		appendOptions = false,
		title = ns.strings.addons.title,
		description = ns.strings.addons.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		scroll = { speed = 0.2 },
		optionsKeys = { ns.name .. "Addons", },
		initialize = function(canvas)
			--List Toolbox versions in use
			for k, v in wt.SortedPairs(registry.addons) do
				wt.CreatePanel({
					parent = canvas,
					name = "Toolbox" .. k,
					title = ns.strings.addons.toolbox:gsub("#VERSION", ns.strings.about.version:gsub("#VERSION", WrapTextInColorCode(k, "FFFFFFFF"))),
					arrange = {},
					size = { h = 32 },
					initialize = function(toolboxPanel, width)
						--List reliant addons
						for i = 1, #v do
							wt.CreatePanel({
								parent = toolboxPanel,
								name = v[i],
								title = wt.Clear(GetAddOnMetadata(v[i], "Title")),
								description = GetAddOnMetadata(v[i], "Notes") or "…",
								arrange = {},
								size = { w = width - 40, h = 48 },
								background = { color = { r = 0.1, g = 0.1, b = 0.1, a = 0.6 } },
								initialize = function(addonPanel)
									local logo = wt.CreateTexture({
										parent = addonPanel,
										name = "Logo",
										position = {
											anchor = "LEFT",
											offset = { x = -16, }
										},
										size = { w = 42, h = 42 },
										path = GetAddOnMetadata(v[i], "IconTexture") or ns.textures.missing,
									})

									--Update title & description
									if addonPanel then
										if addonPanel.title then
											addonPanel.title:SetPoint("TOPLEFT", logo, "TOPLEFT", 8, 18)
											addonPanel.title:SetWidth(addonPanel.title:GetWidth() + 20)
										end
										if addonPanel.description then
											addonPanel.description:SetPoint("TOPLEFT", logo, "TOPRIGHT", 8, -9)
											addonPanel.description:SetWidth(addonPanel.description:GetWidth() - 30)
										end
									end

									--| Toggle

									local function toggleAddon(state)
										if state then
											EnableAddOn(v[i])
											addonPanel:SetAlpha(1)
										else
											DisableAddOn(v[i])
											addonPanel:SetAlpha(0.5)
										end
									end

									local toggle = wt.CreateCheckbox({
										parent = addonPanel,
										name = "Toggle",
										title = ns.strings.about.toggle.label,
										tooltip = { lines = { { text = ns.strings.about.toggle.tooltip, }, } },
										position = {
											anchor = "BOTTOMRIGHT",
											relativeTo = addonPanel,
											relativePoint = "TOPRIGHT",
											offset = { x = -12, }
										},
										size = { w = 80, h = 20 },
										events = { OnClick = function(_, state) toggleAddon(state) end, },
										optionsData = {
											optionsKey = ns.name .. "Addons",
											convertLoad = function() return GetAddOnEnableState(nil, v[i]) > 0 end,
											onLoad = function(_, state) toggleAddon(state) end,
											onCommit = function(_, state) if not state then wt.CreateReloadNotice() end end,
										}
									})

									if toggle.frame then toggle.frame:SetIgnoreParentAlpha(true) end

									--| Info

									local addonVersion = wt.CreateText({
										parent = addonPanel,
										name = "Version",
										position = {
											anchor = "BOTTOMLEFT",
											relativeTo = logo,
											relativePoint = "BOTTOMRIGHT",
											offset = { x = 8, y = 9 }
										},
										text = ns.strings.about.version:gsub("#VERSION", WrapTextInColorCode(GetAddOnMetadata(v[i], "Version") or "?", "FFFFFFFF")),
										font = "GameFontNormalSmall",
										justify = { h = "LEFT", },
									})

									local addonDate = wt.CreateText({
										parent = addonPanel,
										name = "Date",
										position = {
											relativeTo = addonVersion,
											relativePoint = "TOPRIGHT",
											offset = { x = 10, }
										},
										text = ns.strings.about.date:gsub(
											"#DATE", WrapTextInColorCode(ns.toolboxStrings.about.date:gsub(
												"#DAY", GetAddOnMetadata(v[i], "X-Day") or "?"
											):gsub(
												"#MONTH", GetAddOnMetadata(v[i], "X-Month") or "?"
											):gsub(
												"#YEAR", GetAddOnMetadata(v[i], "X-Year") or "?"
											), "FFFFFFFF")
										),
										font = "GameFontNormalSmall",
										justify = "LEFT",
									})

									local addonAuthor = wt.CreateText({
										parent = addonPanel,
										name = "Credits",
										position = {
											relativeTo = addonDate,
											relativePoint = "TOPRIGHT",
											offset = { x = 10, }
										},
										text = ns.strings.about.author:gsub("#AUTHOR", WrapTextInColorCode(GetAddOnMetadata(v[i], "Author") or "?", "FFFFFFFF")),
										font = "GameFontNormalSmall",
										justify = { h = "LEFT", },
									})

									wt.CreateText({
										parent = addonPanel,
										name = "License",
										position = {
											relativeTo = addonAuthor,
											relativePoint = "TOPRIGHT",
											offset = { x = 10, }
										},
										text = ns.strings.about.license:gsub("#LICENSE", WrapTextInColorCode(GetAddOnMetadata(v[i], "X-License") or "?", "FFFFFFFF")),
										font = "GameFontNormalSmall",
										justify = { h = "LEFT", },
									})
								end,
							})
						end
					end,
					arrangement = { parameters = {
						margins = { t = 28, },
						gaps = 24,
						flip = true,
					}, }
				})
			end

			wt.CreatePanel({
				parent = canvas,
				name = "OldList",
				title = ns.strings.addons.old.title,
				description = ns.strings.addons.old.description,
				arrange = {},
				size = { h = 60 },
				initialize = function (panel)
					local oldToolboxes = ns.strings.addons.old.none:gsub("#ADDON", addonTitle)

					if type(WidgetToolbox) == "table" and next(WidgetToolbox) then
						local toolboxes = ""

						--Find old toolboxes
						for k, _ in wt.SortedPairs(WidgetToolbox) do toolboxes = toolboxes .. " • " .. k end

						oldToolboxes = WrapTextInColorCode(ns.strings.addons.old.inUse:gsub(
							"#TOOLBOXES",  WrapTextInColorCode(toolboxes:sub(5),  "FFFFFFFF")
						), wt.ColorToHex(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1, true, false))
					end

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


	--[[ ADDON COMPARTMENT ]]

	local litePopup

	wt.SetUpAddonCompartment(ns.name, {
		onClick = function()
			if WidgetToolsDB.lite then
				litePopup = litePopup or wt.CreatePopup(ns.name, {
					name = "DISABLE_LITE_MODE",
					text = ns.strings.lite.warning:gsub("#ADDON", addonTitle),
					accept = ns.strings.lite.accept,
					onAccept = function()
						WidgetToolsDB.lite = false

						wt.CreateReloadNotice()
					end,
				})

				StaticPopup_Show(litePopup)
			else mainPage.open() end
		end,
	}, { lines = {
		{ text = ns.strings.about.version:gsub("#VERSION", WrapTextInColorCode(GetAddOnMetadata(ns.name, "Version") or "?", "FFFFFFFF")), },
		{ text = ns.strings.about.date:gsub(
			"#DATE", WrapTextInColorCode(ns.toolboxStrings.about.date:gsub(
				"#DAY", GetAddOnMetadata(ns.name, "X-Day") or "?"
			):gsub(
				"#MONTH", GetAddOnMetadata(ns.name, "X-Month") or "?"
			):gsub(
				"#YEAR", GetAddOnMetadata(ns.name, "X-Year") or "?"
			), "FFFFFFFF")
		), },
		{ text = ns.strings.about.author:gsub("#AUTHOR", WrapTextInColorCode(GetAddOnMetadata(ns.name, "Author") or "?", "FFFFFFFF")), },
		{ text = ns.strings.about.license:gsub("#LICENSE", WrapTextInColorCode(GetAddOnMetadata(ns.name, "X-License") or "?", "FFFFFFFF")), },
	} })
end

function WidgetTools.frame:FRAMESTACK_VISIBILITY_UPDATED()
	WidgetTools.frame:UnregisterEvent("FRAMESTACK_VISIBILITY_UPDATED")

	if _G["TableAttributeDisplay"] then
		TableAttributeDisplay:SetWidth(WidgetToolsDB.frameAttributes.width + 70)
		TableAttributeDisplay.LinesScrollFrame:SetWidth(WidgetToolsDB.frameAttributes.width)
	end
end