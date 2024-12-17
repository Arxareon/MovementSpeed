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

WidgetTools.frame:RegisterEvent("PLAYER_ENTERING_WORLD")

function WidgetTools.frame:PLAYER_ENTERING_WORLD()
	WidgetTools.frame:UnregisterEvent("PLAYER_ENTERING_WORLD")


	--[[ RESOURCES ]]

	---@class wt
	local wt = ns.WidgetToolbox

	--Addon title
	local addonTitle = wt.Clear(select(2, C_AddOns.GetAddOnInfo(ns.name))):gsub("^%s*(.-)%s*$", "%1")

	---@type chatCommandManager
	local chatCommands

	--[ Data ]

	--Loaded DB reference
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
		optionsKeys = { ns.name .. "Specifications", },
		storage = { { storageTable = WidgetToolsDB, defaultsTable = ns.defaults, }, },
		initialize = function(canvas)
			wt.CreatePanel({
				parent = canvas,
				name = "General",
				title = ns.strings.specifications.general.title,
				description = ns.strings.specifications.general.description,
				arrange = {},
				initialize = function(panel)
					local silentSave = false

					local enableLitePopup = wt.CreatePopupDialogueData(ns.name, "ENABLE_LITE_MODE", {
						text = ns.strings.lite.enable.warning:gsub("#ADDON", addonTitle),
						accept = ns.strings.lite.enable.accept,
						onAccept = function()
							liteToggle.setState(true)
							liteToggle.saveData(nil, silentSave)

							chatCommands.print(ns.strings.chat.lite.response:gsub("#STATE", VIDEO_OPTIONS_ENABLED:lower()))
						end,
					})
					local disableLitePopup = wt.CreatePopupDialogueData(ns.name, "DISABLE_LITE_MODE", {
						text = ns.strings.lite.disable.warning:gsub("#ADDON", addonTitle),
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
						optionsKey = ns.name .. "Specifications",
						getData = function() return  end,
						saveData = function(state) WidgetToolsDB.lite = state end,
						events = { OnClick = function() silentSave = true end, },
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
						instantSave = false,
						default = false,
					})

					wt.CreateCheckbox({
						parent = panel,
						name = "PositioningAids",
						title = ns.strings.specifications.general.positioningAids.label,
						tooltip = { lines = { { text = ns.strings.specifications.general.positioningAids.tooltip, }, } },
						arrange = {},
						optionsKey = ns.name .. "Specifications",
						getData = function() return WidgetToolsDB.positioningAids end,
						saveData = function(state) WidgetToolsDB.positioningAids = state end,
						listeners = { saved = { { handler = function() if loaded.positioningAids ~= WidgetToolsDB.positioningAids then wt.CreateReloadNotice() end end, }, }, },
						instantSave = false,
						default = not wt.classic, --TODO fix in Classic
						disabled = wt.classic, --TODO fix in Classic
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
						optionsKey = ns.name .. "Specifications",
						getData = function() return WidgetToolsDB.frameAttributes.enabled end,
						saveData = function(state) WidgetToolsDB.frameAttributes.enabled = state end,
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
						default = false,
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
						optionsKey = ns.name .. "Specifications",
						getData = function() return WidgetToolsDB.frameAttributes.width end,
						saveData = function(value) WidgetToolsDB.frameAttributes.width = value end,
						onChange = { ResizeWideFrameAttributes = function() if _G["TableAttributeDisplay"] then
							TableAttributeDisplay:SetWidth(WidgetToolsDB.frameAttributes.width + 70)
							TableAttributeDisplay.LinesScrollFrame:SetWidth(WidgetToolsDB.frameAttributes.width)
						end end, },
						default = 620,
					})
				end,
				arrangement = {}
			})
		end,
		arrangement = {}
	})

	--| Addons Page

	local addonsPage = wt.CreateSettingsPage(ns.name, {
		register = mainPage,
		name = "Addons",
		appendOptions = false,
		title = ns.strings.addons.title,
		description = ns.strings.addons.description:gsub("#ADDON", addonTitle),
		scroll = { speed = 0.2 },
		static = true,
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
						for i = 1, #v do if C_AddOns.IsAddOnLoaded(v[i]) then
							wt.CreatePanel({
								parent = toolboxPanel,
								name = v[i],
								title = C_AddOns.GetAddOnMetadata(v[i], "Title"),
								description = C_AddOns.GetAddOnMetadata(v[i], "Notes") or "…",
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
										path = C_AddOns.GetAddOnMetadata(v[i], "IconTexture") or ns.textures.missing,
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
											C_AddOns.EnableAddOn(v[i])
											addonPanel:SetAlpha(1)
										else
											C_AddOns.DisableAddOn(v[i])
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
										optionsKey = ns.name .. "Addons",
										getData = function() return C_AddOns.GetAddOnEnableState(v[i]) > 0 end,
										saveData = function(state) toggleAddon(state) end,
										listeners = { saved = { { handler = function(self) if not self.getState() then wt.CreateReloadNotice() end end, }, }, },
										instantSave = false,
										showDefault = false,
										utilityMenu = false,
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
										text = ns.strings.about.version:gsub("#VERSION", WrapTextInColorCode(C_AddOns.GetAddOnMetadata(v[i], "Version") or "?", "FFFFFFFF")),
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
											"#DATE", WrapTextInColorCode(ns.strings.date:gsub(
												"#DAY", C_AddOns.GetAddOnMetadata(v[i], "X-Day") or "?"
											):gsub(
												"#MONTH", C_AddOns.GetAddOnMetadata(v[i], "X-Month") or "?"
											):gsub(
												"#YEAR", C_AddOns.GetAddOnMetadata(v[i], "X-Year") or "?"
											), "FFFFFFFF")
										),
										font = "GameFontNormalSmall",
										justify = { h = "LEFT" },
									})

									local addonAuthor = wt.CreateText({
										parent = addonPanel,
										name = "Credits",
										position = {
											relativeTo = addonDate,
											relativePoint = "TOPRIGHT",
											offset = { x = 10, }
										},
										text = ns.strings.about.author:gsub("#AUTHOR", WrapTextInColorCode(C_AddOns.GetAddOnMetadata(v[i], "Author") or "?", "FFFFFFFF")),
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
										text = ns.strings.about.license:gsub("#LICENSE", WrapTextInColorCode(C_AddOns.GetAddOnMetadata(v[i], "X-License") or "?", "FFFFFFFF")),
										font = "GameFontNormalSmall",
										justify = { h = "LEFT", },
									})
								end,
							})
						end end
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
				initialize = function(panel)
					local oldToolboxes = ns.strings.addons.old.none:gsub("#ADDON", addonTitle)

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
				handler = function(f, ...) return type(wt[f]) == "function", f, ... end,
				success = ns.strings.chat.run.success,
				error = ns.strings.chat.run.error,
				onSuccess = function(f, ...)
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
					wt.CreateMenuTextline(menu, { text = addonTitle, })
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