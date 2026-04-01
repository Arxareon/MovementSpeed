--[[ REFERENCES ]]

--[ Namespace ]

---@class addonNamespace
local ns = select(2, ...)


--[[ REFERENCES ]]

--[ Shortcuts ]

---@type widgetToolbox
local wt = ns[C_AddOns.GetAddOnMetadata(ns.name, "X-WidgetTools-AddToNamespace")]

---@type widgetToolsResources
local rs = WidgetTools.resources

---@type widgetToolsUtilities
local us = WidgetTools.utilities

local cr = WrapTextInColor

--[ Locals ]

local frames = {
	playerSpeed = {},
}

local options = {
	about = {},
	playerSpeed = {
		visibility = {},
		update = {},
		position = {},
		value = {},
		font = {},
		background = {
			colors = {},
			size = {},
		},
	},
	targetSpeed = {
		value = {},
		font = {},
	},
	dataManagement = {},
}

---@type chatCommandManager
local chatCommands

--Speed values
local speed = {
	playerSpeed = { yards = 0, },
	targetSpeed = { yards = 0, }
}

--Speed text templates
local speedText = {}

--Accumulated time since the last speed update
local timeSinceSpeedUpdate = {
	playerSpeed = 0,
}


--[[ UTILITIES ]]

--[ Data Management ]

---Convert an old speed value type to the new multi-selector table value
---@param value integer
local function ConvertOldValueType(value)
	if value ~= 0 or value ~= 1 or value ~= 2 then return { true, false, false }
	else return {
		value == 0 or value == 2,
		value == 1 or value == 2,
		false
	} end
end

--[ Chat Control ]

--Print visibility info
local function PrintStatus()
	print(cr((frames.main:IsVisible() and (
		not frames.playerSpeed.display:IsVisible() and ns.strings.chat.status.notVisible or ns.strings.chat.status.visible
	) or ns.strings.chat.status.hidden):gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub("#AUTO", ns.strings.chat.status.auto:gsub("#STATE", cr(
		MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[1]
	))), ns.colors.yellow[2]))
end

--[ Speed Update ]

---Format the raw string of the specified speed textline to be replaced by speed values later
---@param type "playerSpeed"|"targetSpeed"
---@param units? [boolean, boolean, boolean] ***Default:*** **MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.units**
---@param colors? speedColorList ***Default:*** **MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].font.colors**
local function FormatSpeedText(type, units, colors)
	units = units or MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.units
	colors = colors or MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].font.colors
	local secondaryColors = us.Clone(colors)
	wt.AdjustGamma(secondaryColors.percent)
	wt.AdjustGamma(secondaryColors.yards)
	wt.AdjustGamma(secondaryColors.coords)

	speedText[type] = ""

	if units[1] then
		local sign = (type == "targetSpeed" and "%%" or "%")
		speedText[type] = speedText[type] .. cr("#PERCENT", secondaryColors.percent) .. cr(sign, colors.percent)
	end
	if units[2] then
		speedText[type] = speedText[type] .. ns.strings.speedValue.separator .. cr(ns.strings.speedValue.yps:gsub(
			"#YARDS", cr("#YARDS", secondaryColors.yards)
		), colors.yards)
	end

	speedText[type] = speedText[type]:gsub("^" .. ns.strings.speedValue.separator, "")
end

---Return the specified speed textline with placeholders replaced by formatted speed values
---@param type "playerSpeed"|"targetSpeed"
---@return string
local function GetSpeedText(type)
	local f = max(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.fractionals, 1)

	return speedText[type]:gsub(
		"#PERCENT", us.Thousands(
			speed[type].percent,
			MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.fractionals,
			true,
			not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.zeros
		)
	):gsub(
		"#YARDS", us.Thousands(
			speed[type].yards,
			MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.fractionals,
			true,
			not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.zeros
		)
	)
end

--Update the Player Speed values
local function UpdatePlayerSpeed()
	speed.playerSpeed.yards = GetUnitSpeed("player")
	speed.playerSpeed.percent = speed.playerSpeed.yards / BASE_MOVEMENT_SPEED * 100

	--Hide when stationery
	if speed.playerSpeed.yards == 0 and MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide then
		frames.playerSpeed.display:Hide()

		return
	else frames.playerSpeed.display:Show() end

	--Update the display text
	frames.playerSpeed.text:SetText(" " .. GetSpeedText("playerSpeed"))
end

--[ Speed Displays ]

---Set the size of the specified speed display (width is calculated based on the displayed speed value types)
---@param display table
---@param displayData displayData
---@param height? number Text height | ***Default:*** frames[**display**].text:GetStringHeight()
local function SetDisplaySize(display, displayData, height)
	height = math.ceil(height or display.text:GetStringHeight()) + 2.4
	displayData.value.units = displayData.value.units or displayData.value.units
	displayData.value.fractionals = displayData.value.fractionals or displayData.value.fractionals

	--Calculate width to height ratio
	local ratio = 0
	if displayData.value.units[1] then ratio = ratio + 3.58 + (displayData.value.fractionals > 0 and 0.1 + 0.54 * displayData.value.fractionals or 0) end
	if displayData.value.units[2] then ratio = ratio + 3.52 + (displayData.value.fractionals > 0 and 0.1 + 0.54 * displayData.value.fractionals or 0) end
	for i = 1, 3 do if displayData.value.units[i] then ratio = ratio + 0.2 end end --Separators

	--Resize the display
	display.display:SetSize(height * ratio * 1.2 - 4, height)
end

---Set the backdrop of the specified speed display elements
---@param display table
---@param backgroundData displayBackgroundData
local function SetDisplayBackdrop(display, backgroundData)
	wt.SetBackdrop(display.display, backgroundData.visible and {
		background = {
			texture = { size = 5, },
			color = backgroundData.colors.bg
		},
		border = {
			texture = {
				path = "Interface/ChatFrame/ChatFrameBackground",
				width = 1,
			},
			color = backgroundData.colors.border
		}
	} or nil)
end

---Set the visibility, backdrop, font path, size and colors of the specified speed display to the currently saved values
---@param display table
---@param displayData displayData
local function SetDisplayValues(display, displayData)
	--Position
	display.display:SetClampedToScreen(displayData.keepInBounds)

	--Visibility
	display.display:SetFrameStrata(displayData.layer.strata)
	wt.SetVisibility(display.display, not displayData.visibility.hidden)

	--Display
	SetDisplaySize(display, displayData, displayData.font.size)
	SetDisplayBackdrop(display, displayData.background)

	--Font & text
	display.text:SetFont(displayData.font.path, displayData.font.size, "OUTLINE")
	display.text:SetJustifyH(displayData.font.alignment)
	wt.SetPosition(display.text, { anchor = displayData.font.alignment, })
	display.text:SetTextColor(wt.UnpackColor(displayData.font.colors.base))
end

--| Tooltip content

local playerSpeedTooltipLines

--Assemble the detailed text lines for the tooltip of the Player Speed display
local function GetPlayerSpeedTooltipLines()
	playerSpeedTooltipLines = {
		{ text = ns.strings.speedTooltip.description },
		{ text = "\n" .. ns.strings.speedTooltip.playerSpeed, },
		{
			text = "\n" .. ns.strings.speedTooltip.text[1]:gsub("#YARDS", cr(us.Thousands(speed.playerSpeed.yards, 2, true),  ns.colors.yellow[2])),
			font = GameTooltipText,
			color = ns.colors.yellow[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.text[2]:gsub(
				"#PERCENT", cr(us.Thousands(speed.playerSpeed.percent, 2, true) .. "%%", ns.colors.green[2])
			),
			font = GameTooltipText,
			color = ns.colors.green[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.hintOptions,
			font = GameFontNormalSmall,
			color = rs.colors.grey[1],
		},
		{
			text = ns.strings.speedTooltip.hintMove,
			font = GameFontNormalSmall,
			color = rs.colors.grey[1],
		},
	}

	return playerSpeedTooltipLines
end

--| Toggle updates

--Start updating the speed display
local function StartSpeedDisplayUpdates()
	--Update the speed values at start
	UpdatePlayerSpeed()

	--| Repeated updates

	frames.playerSpeed.updater:SetScript("OnUpdate", function(_, deltaTime) if MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.update.throttle then
		timeSinceSpeedUpdate.playerSpeed = timeSinceSpeedUpdate.playerSpeed + deltaTime

		if timeSinceSpeedUpdate.playerSpeed < MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.update.frequency then return else
			UpdatePlayerSpeed()

			timeSinceSpeedUpdate.playerSpeed = 0
		end
	else UpdatePlayerSpeed() end end)
end

--Stop updating the speed display
local function StopSpeedDisplayUpdates()
	frames.playerSpeed.updater:SetScript("OnUpdate", nil)
end

--[ Target Speed ]

---Assemble the text for the mouseover target's speed
---@return string
local function GetTargetSpeedText()
	return wt.Texture(ns.textures.logo) .. " " .. ns.strings.targetSpeed:gsub("#SPEED", cr(GetSpeedText("targetSpeed"), rs.colors.grey[2]))
end

--| Updates

local targetSpeedEnabled = false

--Set up the Target Speed unit tooltip integration
local function EnableTargetSpeedUpdates()
	local lineAdded, line

	targetSpeedEnabled = true

	--Start mouseover Target Speed updates
	GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip)
		if not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.enabled then return end

		frames.targetSpeed:SetScript("OnUpdate", function()
			if UnitName("mouseover") == nil then return end

			--Update target speed values
			speed.targetSpeed.yards = GetUnitSpeed("mouseover")
			speed.targetSpeed.percent = speed.targetSpeed.yards / BASE_MOVEMENT_SPEED * 100

			--Find the speed line
			lineAdded = false
			for i = 2, tooltip:NumLines() do
				line = _G["GameTooltipTextLeft" .. i]
				if line then if string.match(line:GetText() or "", wt.Texture(ns.textures.logo)) then
					--Update the speed line
					line:SetText(GetTargetSpeedText())
					lineAdded = true

					break
				end end
			end

			--Add the speed line if the target is moving
			if not lineAdded and GetUnitSpeed("mouseover") ~= 0 then
				tooltip:AddLine(GetTargetSpeedText(), ns.colors.green[1].r, ns.colors.green[1].g, ns.colors.green[1].b, true)
				tooltip:Show() --Force the tooltip to be resized --FIX flashing issue when hovering over unit frames
			end
		end)
	end)

	--Stop mouseover Target Speed updates
	GameTooltip:HookScript("OnTooltipCleared", function() frames.targetSpeed:SetScript("OnUpdate", nil) end)
end


--[[ SETTINGS ]]

local valueTypes = {}

for i = 1, #ns.strings.options.speedValue.units.list - 1 do
	valueTypes[i] = {}
	valueTypes[i].title = ns.strings.options.speedValue.units.list[i].label
	valueTypes[i].tooltip = { lines = { { text = ns.strings.options.speedValue.units.list[i].tooltip, }, } }
end

--[ Speed Display ]

--Create the widgets
local function CreateVisibilityOptions(panel, category, key)
	---@type toggle|checkbox
	options.playerSpeed.visibility.hidden = wt.CreateCheckbox({
		parent = panel,
		name = "Hidden",
		title = ns.strings.options.speedDisplay.visibility.hidden.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.hidden.tooltip:gsub("#ADDON", ns.title), }, } },
		arrange = {},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden = state end,
		default = ns.profileDefault.playerSpeed.visibility.hidden,
		dataManagement = {
			category = category,
			key = key,
			onChange = { DisplayToggle = function()
				wt.SetVisibility(frames.playerSpeed.display, not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden)
				if MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden then StopSpeedDisplayUpdates() else StartSpeedDisplayUpdates() end
			end, },
		},
	})

	---@type toggle|checkbox
	options.playerSpeed.visibility.autoHide = wt.CreateCheckbox({
		parent = panel,
		name = "AutoHide",
		title = ns.strings.options.speedDisplay.visibility.autoHide.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.autoHide.tooltip, }, } },
		arrange = { wrap = false, },
		dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide = state end,
		default = ns.profileDefault.playerSpeed.visibility.autoHide,
		dataManagement = {
			category = category,
			key = key,
		},
	})

	---@type toggle|checkbox
	options.playerSpeed.visibility.status = wt.CreateCheckbox({
		parent = panel,
		name = "StatusNotice",
		title = ns.strings.options.speedDisplay.visibility.statusNotice.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.statusNotice.tooltip, }, } },
		arrange = { wrap = false, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.statusNotice end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.statusNotice = state end,
		default = ns.profileDefault.playerSpeed.visibility.statusNotice,
		dataManagement = {
			category = category,
			key = key,
		},
	})
end
local function CreateUpdateOptions(panel, category, key)
	---@type toggle|checkbox
	options.playerSpeed.update.throttle = wt.CreateCheckbox({
		parent = panel,
		name = "Throttle",
		title = ns.strings.options.speedDisplay.update.throttle.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.throttle.tooltip, }, } },
		arrange = {},
		dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.update.throttle end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.update.throttle = state end,
		default = ns.profileDefault.playerSpeed.update.throttle,
		dataManagement = {
			category = category,
			key = key,
		},
	})

	---@type numeric|slider
	options.playerSpeed.update.frequency = wt.CreateSlider({
		parent = panel,
		name = "Frequency",
		title = ns.strings.options.speedDisplay.update.frequency.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.frequency.tooltip, }, } },
		arrange = { wrap = false, },
		min = 0.05,
		max = 1,
		increment = 0.05,
		altStep = 0.2,
		dependencies = {
			{ frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options.playerSpeed.update.throttle },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.update.frequency end,
		saveData = function(value) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.update.frequency = us.Round(value, 2) end,
		default = ns.profileDefault.playerSpeed.update.frequency,
		dataManagement = {
			category = category,
			key = key,
		},
	})
end
local function CreateSpeedValueOptions(panel, category, key)
	---@type checkgroup|multiselector
	options.playerSpeed.value.units = wt.CreateCheckgroup({
		parent = panel,
		name = "Units",
		title = ns.strings.options.speedValue.units.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.units.tooltip, }, } },
		arrange = {},
		items = valueTypes,
		limits = { min = 1, },
		dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.units end,
		saveData = function(selections) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.units = selections end,
		default = ns.profileDefault.playerSpeed.value.units,
		dataManagement = {
			category = category,
			key = key,
			onChange = {
				UpdateDisplaySize = function() SetDisplaySize(frames.playerSpeed, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed) end,
				UpdateSpeedTextTemplate = function() FormatSpeedText("playerSpeed") end,
			},
		},
	})

	---@type numeric|slider
	options.playerSpeed.value.fractionals = wt.CreateSlider({
		parent = panel,
		name = "Fractionals",
		title = ns.strings.options.speedValue.fractionals.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.fractionals.tooltip, }, } },
		arrange = { wrap = false, },
		min = 0,
		max = 4,
		increment = 1,
		dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.fractionals end,
		saveData = function(value) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.fractionals = value end,
		default = ns.profileDefault.playerSpeed.value.fractionals,
		dataManagement = {
			category = category,
			key = key,
			onChange = { "UpdateDisplaySize", },
		},
	})

	---@type toggle|checkbox
	options.playerSpeed.value.zeros = wt.CreateCheckbox({
		parent = panel,
		name = "Zeros",
		title = ns.strings.options.speedValue.zeros.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.zeros.tooltip, }, } },
		arrange = { wrap = false, },
		autoOffset = true,
		dependencies = {
			{ frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options.playerSpeed.value.fractionals, evaluate = function(value) return value > 0 end },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.zeros end,
		saveData = function(color) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.zeros = color end,
		default = ns.profileDefault.playerSpeed.value.zeros,
		dataManagement = {
			category = category,
			key = key,
		},
	})
end
local function CreateBackgroundOptions(panel, category, key)
	---@type toggle|checkbox
	options.playerSpeed.background.visible = wt.CreateCheckbox({
		parent = panel,
		name = "Visible",
		title = ns.strings.options.speedDisplay.background.visible.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.background.visible.tooltip, }, } },
		arrange = {},
		dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background.visible end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background.visible = state end,
		default = ns.profileDefault.playerSpeed.background.visible,
		dataManagement = {
			category = category,
			key = key,
			onChange = { ToggleDisplayBackdrops = function() SetDisplayBackdrop(frames.playerSpeed, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background) end, },
		},
	})

	---@type colormanager|colorpicker
	options.playerSpeed.background.colors.bg = wt.CreateColorpicker({
		parent = panel,
		name = "Color",
		title = ns.strings.options.speedDisplay.background.colors.bg.label,
		tooltip = {},
		arrange = { wrap = false, },
		dependencies = {
			{ frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options.playerSpeed.background.visible, },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background.colors.bg end,
		saveData = function(color) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background.colors.bg = color end,
		default = ns.profileDefault.playerSpeed.background.colors.bg,
		dataManagement = {
			category = category,
			key = key,
			onChange = { UpdateDisplayBackgroundColor = function() if frames.playerSpeed.display:GetBackdrop() ~= nil then
				frames.playerSpeed.display:SetBackdropColor(wt.UnpackColor(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background.colors.bg))
			end end },
		},
	})

	---@type colormanager|colorpicker
	options.playerSpeed.background.colors.border = wt.CreateColorpicker({
		parent = panel,
		name = "BorderColor",
		title = ns.strings.options.speedDisplay.background.colors.border.label,
		tooltip = {},
		arrange = { wrap = false, },
		dependencies = {
			{ frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options.playerSpeed.background.visible, },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background.colors.border end,
		saveData = function(color) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background.colors.border = color end,
		default = ns.profileDefault.playerSpeed.background.colors.border,
		dataManagement = {
			category = category,
			key = key,
			onChange = { UpdateDisplayBorderColor = function() if frames.playerSpeed.display:GetBackdrop() ~= nil then
				frames.playerSpeed.display:SetBackdropBorderColor(wt.UnpackColor(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background.colors.border))
			end end },
		},
	})
end

---Create the category page
---@return settingsPage
local function CreateSpeedDisplayOptionsPage()
	local displayName = ns.strings.options.playerSpeed.title:gsub("%s+", "")

	---@type settingsPage|nil
	options.playerSpeed.page = wt.CreateSettingsPage(ns.name, {
		name = displayName,
		title = ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options.playerSpeed.title),
		description = ns.strings.options.playerSpeed.description:gsub("#ADDON", ns.title),
		scroll = { speed = 0.21 },
		dataManagement = {
			category = ns.name .. displayName,
			keys = {
				"Font",
				"Background",
				"Value",
				"Updates",
				"Position",
				"Visibility",
			}
		},
		onDefault = function()
			chatCommands.print(ns.strings.chat.default.responseCategory:gsub(
				"#CATEGORY", cr(ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options.playerSpeed.title), ns.colors.yellow[2])
			):gsub(
				"#PROFILE", cr(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].title, ns.colors.yellow[2])
			))

			options.playerSpeed.position.resetCustomPreset()
		end,
		arrangement = {},
		initialize = function(canvas, _, _, category, keys)

			--[ Visibility ]

			wt.CreatePanel({
				parent = canvas,
				name = keys[6],
				title = ns.strings.options.speedDisplay.visibility.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel, _, _, key) CreateVisibilityOptions(panel, category, key) end,
			})

			--[ Position ]

			---@type positionPanel|nil
			options.playerSpeed.position = wt.CreatePositionOptions(ns.name, frames.playerSpeed.display, {
				canvas = canvas,
				name = ns.strings.options.speedDisplay.referenceName:gsub("#TYPE", ns.strings.options.playerSpeed.title),
				presets = {
					items = {
						{
							title = CUSTOM, --Custom
							onSelect = function() options.playerSpeed.position.presets[1].data.position.relativePoint = options.playerSpeed.position.presets[1].data.position.anchor end,
						},
						{
							title = ns.strings.presets[1], --Under the Minimap
							data = {
								position = {
									anchor = "TOP",
									relativeTo = Minimap,
									relativePoint = "BOTTOM",
									offset = { x = 2, y = -14 }
								},
								keepInBounds = true,
								layer = {
									strata = "MEDIUM",
									keepOnTop = false,
								},
							},
						},
					},
					onPreset = function(i)
						--Make sure the speed display is visible
						options.playerSpeed.visibility.hidden.setData(false)

						chatCommands.print(ns.strings.chat.preset.response:gsub(
							"#PRESET", cr(options.playerSpeed.position.presets[i].title, ns.colors.yellow[2])
						):gsub(
							"#TYPE", ns.strings.options.playerSpeed.title
						))
					end,
					custom = {
						getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.customPreset end,
						defaultsTable = ns.profileDefault.customPreset,
						onSave = function() chatCommands.print(ns.strings.chat.save.response:gsub(
							"#TYPE", ns.strings.options.playerSpeed.title
						):gsub("#CUSTOM", cr(CUSTOM, ns.colors.yellow[2]))) end,
						onReset = function() chatCommands.print(ns.strings.chat.reset.response:gsub("#CUSTOM", cr(CUSTOM, ns.colors.yellow[2]))) end
					}
				},
				setMovable = { events = {
					onStop = function() chatCommands.print(ns.strings.chat.position.save:gsub("#TYPE", ns.strings.options.playerSpeed.title)) end,
					onCancel = function()
						chatCommands.print(ns.strings.chat.position.cancel:gsub("#TYPE", ns.strings.options.playerSpeed.title))
						print(cr(ns.strings.chat.position.error, ns.colors.yellow[2]))
					end,
				}, },
				dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
				getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed end,
				defaultsTable = ns.profileDefault.playerSpeed,
				settingsData = MovementSpeedCS.playerSpeed,
				dataManagement = { category = ns.name .. displayName, },
			})

			if options.playerSpeed.position.frame.description then options.playerSpeed.position.frame.description:SetWidth(328) end

			--[ Updates ]

			wt.CreatePanel({
				parent = canvas,
				name = keys[4],
				title = ns.strings.options.speedDisplay.update.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel, _, _, key) CreateUpdateOptions(panel, category, key) end
			})

			--[ Value ]

			wt.CreatePanel({
				parent = canvas,
				name = keys[3],
				title = ns.strings.options.speedValue.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel, _, _, key) CreateSpeedValueOptions(panel, category, key) end,
			})

			--[ Font ]

			options.playerSpeed.font = wt.CreateFontOptions(ns.name, frames.playerSpeed.text, {
				canvas = canvas,
				colors = {
					percent = {
						name = ns.strings.options.speedValue.units.list[1].label,
						index = 1,
					},
					yards = {
						name = ns.strings.options.speedValue.units.list[2].label,
						index = 2,
					},
					coords = {
						name = ns.strings.options.speedValue.units.list[3].label,
						index = 3,
					},
				},
				dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
				getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font end,
				defaultsTable = ns.profileDefault.playerSpeed.font,
				settingsData = MovementSpeedCS.playerSpeed,
				dataManagement = { category = ns.name .. displayName, },
				onChangeFont = function()
					SetDisplaySize(frames.playerSpeed, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed)
					FormatSpeedText(display)
				end,
				onChangeSize = function() SetDisplaySize(frames.playerSpeed, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed) end,
				onChangeAlignment = function()
					wt.SetPosition(frames.playerSpeed.text, { anchor = MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.alignment, })
				end,
				onChangeColor = function() FormatSpeedText("playerSpeed") end
			})

			--[ Background ]

			wt.CreatePanel({
				parent = canvas,
				name = keys[2],
				title = ns.strings.options.speedDisplay.background.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel, _, _, key) CreateBackgroundOptions(panel, category, key) end,
			})
		end,
	})

	return options.playerSpeed.page
end

--[ Target Speed ]

---Create the category page
---@return settingsPage
local function CreateTargetSpeedOptionsPage()
	options.targetSpeed.page = wt.CreateSettingsPage(ns.name, {
		name = "TargetSpeed",
		title = ns.strings.options.targetSpeed.title,
		description = ns.strings.options.targetSpeed.description:gsub("#ADDON", ns.title),
		dataManagement = {},
		onDefault = function()
			chatCommands.print(ns.strings.chat.default.responseCategory:gsub(
				"#CATEGORY", cr(ns.strings.options.targetSpeed.title, ns.colors.yellow[2])
			):gsub(
				"#PROFILE", cr(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].title, ns.colors.yellow[2])
			))
		end,
		arrangement = {},
		initialize = function(canvas, _, _, category, keys)
			wt.CreatePanel({
				parent = canvas,
				name = "Mouseover",
				title = ns.strings.options.targetSpeed.mouseover.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel)
					options.targetSpeed.enabled = wt.CreateCheckbox({
						parent = panel,
						name = "Enabled",
						title = ns.strings.options.targetSpeed.mouseover.enabled.label,
						tooltip = { lines = { { text = ns.strings.options.targetSpeed.mouseover.enabled.tooltip:gsub("#ADDON", ns.title), }, } },
						arrange = {},
						getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.enabled end,
						saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.enabled = state end,
						default = ns.profileDefault.targetSpeed.enabled,
						dataManagement = {
							category = category,
							key = keys[1],
							onChange = { EnableTargetSpeedUpdates = function() if not targetSpeedEnabled then EnableTargetSpeedUpdates() end end, },
						},
					})
				end,
			})

			wt.CreatePanel({
				parent = canvas,
				name = "Value",
				title = ns.strings.options.speedValue.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel)
					options.targetSpeed.value.units = wt.CreateCheckgroup({
						parent = panel,
						name = "Units",
						title = ns.strings.options.speedValue.units.label,
						tooltip = { lines = { { text = ns.strings.options.speedValue.units.tooltip, }, } },
						arrange = {},
						items = valueTypes,
						limits = { min = 1, },
						dependencies = { { frame = options.targetSpeed.enabled, }, },
						getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.value.units end,
						saveData = function(selections) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.value.units = selections end,
						default = ns.profileDefault.targetSpeed.value.units,
						dataManagement = {
							category = category,
							key = keys[1],
							onChange = { UpdateTargetSpeedTextTemplate = function() FormatSpeedText("targetSpeed") end, },
						},
					})

					options.targetSpeed.value.fractionals = wt.CreateSlider({
						parent = panel,
						name = "Fractionals",
						title = ns.strings.options.speedValue.fractionals.label,
						tooltip = { lines = { { text = ns.strings.options.speedValue.fractionals.tooltip, }, } },
						arrange = { wrap = false, },
						min = 0,
						max = 4,
						increment = 1,
						dependencies = { { frame = options.targetSpeed.enabled, }, },
						getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.value.fractionals end,
						saveData = function(value) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.value.fractionals = value end,
						default = ns.profileDefault.targetSpeed.value.fractionals,
						dataManagement = {
							category = category,
							key = keys[1],
						},
					})

					options.targetSpeed.value.zeros = wt.CreateCheckbox({
						parent = panel,
						name = "Zeros",
						title = ns.strings.options.speedValue.zeros.label,
						tooltip = { lines = { { text = ns.strings.options.speedValue.zeros.tooltip, }, } },
						arrange = { wrap = false, },
						autoOffset = true,
						dependencies = {
							{ frame = options.targetSpeed.enabled, },
							{ frame = options.targetSpeed.value.fractionals, evaluate = function(value) return value > 0 end },
						},
						getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.value.zeros end,
						saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.value.zeros = state end,
						default = ns.profileDefault.targetSpeed.value.zeros,
						dataManagement = {
							category = category,
							key = keys[1],
						},
					})
				end,
			})

			wt.CreatePanel({
				parent = canvas,
				name = "Font",
				title = wt.strings.font.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel)
					local colors = {
						percent = {
							name = ns.strings.options.speedValue.units.list[1].label,
							index = 1,
						},
						yards = {
							name = ns.strings.options.speedValue.units.list[2].label,
							index = 2,
						},
						coords = {
							name = ns.strings.options.speedValue.units.list[3].label,
							index = 3,
						},
						base = {
							name = "Base",
							index = 4,
						}
					}

					---@type (colormanager|colorpicker)[]
					options.targetSpeed.font.colors = {}

					for key in pairs(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.font.colors) do
						if type(colors[key]) ~= "table" then colors[key] = {} end

						local name = colors[key].name == "string" and colors[key].name or (key:sub(1,1):upper() .. key:sub(2))

						options.targetSpeed.font.colors[key] = wt.CreateColorpicker({
							parent = panel,
							name = "Color",
							title = wt.strings.font.color.label:gsub("#COLOR_TYPE", name),
							tooltip = { lines = { { text = wt.strings.font.color.tooltip:gsub("#COLOR_TYPE", name), }, } },
							arrange = { wrap = false, index = colors[key].index },
							dependencies = { { frame = options.targetSpeed.enabled, }, },
							getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.font.colors[key] end,
							saveData = function(value) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.font.colors[key] = value end,
							default = ns.profileDefault.targetSpeed.font.colors[key],
							dataManagement = {
								category = category,
								key = keys[1],
								onChange = function() FormatSpeedText("targetSpeed") end,
							},
						})
					end
				end
			})
		end,
	})

	return options.targetSpeed.page
end


--[[ INITIALIZATION ]]

local firstLoad, newCharacter

--Custom Tooltip
ns.tooltip = wt.CreateGameTooltip(ns.name)

--Set up the speed display context menu
local function CreateContextMenu(display) wt.CreateContextMenu({
	triggers = { { frame = frames.playerSpeed.display, }, },
	initialize = function(menu)
		wt.CreateMenuTextline(menu, { text = ns.title, })
		wt.CreateSubmenu(menu, { title = ns.strings.misc.options, initialize = function(optionsMenu)
			wt.CreateMenuButton(optionsMenu, {
				title = wt.strings.about.title,
				tooltip = { lines = { { text = ns.strings.options.main.description:gsub("#ADDON", ns.title), }, } },
				action = options.about.page.open,
			})
			wt.CreateMenuButton(optionsMenu, {
				title = ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options.playerSpeed.title),
				tooltip = { lines = { { text = ns.strings.options.playerSpeed.description, }, } },
				action = options.playerSpeed.page.open,
			})
			wt.CreateMenuButton(optionsMenu, {
				title = ns.strings.options.targetSpeed.title,
				tooltip = { lines = { { text = ns.strings.options.targetSpeed.description:gsub("#ADDON", ns.title), }, } },
				action = options.targetSpeed.page.open,
			})
			wt.CreateMenuButton(optionsMenu, {
				title = wt.strings.dataManagement.title,
				tooltip = { lines = { { text = wt.strings.dataManagement.description:gsub("#ADDON", ns.title), }, } },
				action = options.dataManagement.page.open,
			})
		end })
		wt.CreateSubmenu(menu, { title = wt.strings.presets.apply.label, initialize = function(presetsMenu)
			for i = 1, #options.playerSpeed.position.presets do wt.CreateMenuButton(presetsMenu, {
				title = options.playerSpeed.position.presets[i].title,
				action = function() options.playerSpeed.position.applyPreset(i) end,
			}) end
		end })
	end
}) end

--Create main addon frame & display
frames.main = wt.CreateFrame({
	name = ns.name,
	position = {},
	onEvent = {
		ADDON_LOADED = function(self, addon)
			if addon ~= ns.name then return end

			self:UnregisterEvent("ADDON_LOADED")

			--[ Data ]

			---@type MovementSpeedDB
			MovementSpeedDB = MovementSpeedDB or {}

			---@type MovementSpeedDBC
			MovementSpeedDBC = MovementSpeedDBC or {}

			---@type MovementSpeedCS
			MovementSpeedCS = us.Fill(MovementSpeedCS or {}, {
				compactBackup = true,
				playerSpeed = { keepInPlace = true, },
				travelSpeed = { keepInPlace = true, },
				mainDisplay = "playerSpeed",
			})

			--| Initialize data management

			options.dataManagement, firstLoad, newCharacter = wt.CreateDataManagementPage(ns.name, {
				onDefault = function(_, category) if not category then options.dataManagement.resetProfile() end end,
				accountData = MovementSpeedDB,
				characterData = MovementSpeedDBC,
				settingsData = MovementSpeedCS,
				defaultsTable = ns.profileDefault,
				valueChecker = function(key, value)
					if type(value) == "number" then
						--Non-negative
						if key == "size" then return value > 0 end
						--Range constraint: 0 - 1
						if key == "r" or key == "g" or key == "b" or key == "a" then return value >= 0 and value <= 1 end
						--Corrupt Anchor Points
						if key == "anchor" then return false end
					end return true
				end,
				recoveryMap = function(data) return {
					["preset.point"] = { saveTo = { data.customPreset.position, }, saveKey = "anchor", },
					["customPreset.position.point"] = { saveTo = { data.customPreset.position, }, saveKey = "anchor", },
					["preset.offsetX"] = { saveTo = { data.customPreset.position.offset, }, saveKey = "x", },
					["preset.offsetY"] = { saveTo = { data.customPreset.position.offset, }, saveKey = "y", },
					["position.point"] = { saveTo = { data.playerSpeed.position, data.travelSpeed.position, }, saveKey = "anchor", },
					["speedDisplay.position.point"] = { saveTo = { data.playerSpeed.position, data.travelSpeed.position, }, saveKey = "anchor", },
					["speedDisplay.position.anchor"] = { saveTo = { data.playerSpeed.position, data.travelSpeed.position, }, saveKey = "anchor", },
					["position.offset.x"] = { saveTo = { data.playerSpeed.position.offset, data.travelSpeed.position.offset, }, saveKey = "x", },
					["speedDisplay.position.offset.x"] = { saveTo = { data.playerSpeed.position.offset, data.travelSpeed.position.offset, }, saveKey = "x", },
					["position.offset.y"] = { saveTo = { data.playerSpeed.position.offset, data.travelSpeed.position.offset, }, saveKey = "y", },
					["speedDisplay.position.offset.y"] = { saveTo = { data.playerSpeed.position.offset, data.travelSpeed.position.offset, }, saveKey = "y", },
					["visibility.frameStrata"] = { saveTo = { data.playerSpeed.layer, data.travelSpeed.layer, }, saveKey = "strata", },
					["appearance.frameStrata"] = { saveTo = { data.playerSpeed.layer, data.travelSpeed.layer, }, saveKey = "strata", },
					["speedDisplay.visibility.frameStrata"] = { saveTo = { data.playerSpeed.layer, data.travelSpeed.layer, }, saveKey = "strata", },
					["speedDisplay.layer.strata"] = { saveTo = { data.playerSpeed.layer, data.travelSpeed.layer, }, saveKey = "strata", },
					["visibility.backdrop"] = { saveTo = { data.playerSpeed.background, data.travelSpeed.background, }, saveKey = "visible", },
					["appearance.backdrop.visible"] = { saveTo = { data.playerSpeed.background, data.travelSpeed.background, }, saveKey = "visible", },
					["speedDisplay.background.visible"] = { saveTo = { data.playerSpeed.background, data.travelSpeed.background, }, saveKey = "visible", },
					["appearance.backdrop.color.r"] = { saveTo = { data.playerSpeed.background.colors.bg, data.travelSpeed.background.colors.bg, }, saveKey = "r", },
					["speedDisplay.background.colors.bg.r"] = { saveTo = { data.playerSpeed.background.colors.bg, data.travelSpeed.background.colors.bg, }, saveKey = "r", },
					["appearance.backdrop.color.g"] = { saveTo = { data.playerSpeed.background.colors.bg, data.travelSpeed.background.colors.bg, }, saveKey = "g", },
					["speedDisplay.background.colors.bg.g"] = { saveTo = { data.playerSpeed.background.colors.bg, data.travelSpeed.background.colors.bg, }, saveKey = "g", },
					["appearance.backdrop.color.b"] = { saveTo = { data.playerSpeed.background.colors.bg, data.travelSpeed.background.colors.bg, }, saveKey = "b", },
					["speedDisplay.background.colors.bg.b"] = { saveTo = { data.playerSpeed.background.colors.bg, data.travelSpeed.background.colors.bg, }, saveKey = "b", },
					["appearance.backdrop.color.a"] = { saveTo = { data.playerSpeed.background.colors.bg, data.travelSpeed.background.colors.bg, }, saveKey = "a", },
					["speedDisplay.background.colors.bg.a"] = { saveTo = { data.playerSpeed.background.colors.bg, data.travelSpeed.background.colors.bg, }, saveKey = "a", },
					["fontSize"] = { saveTo = { data.playerSpeed.font, data.travelSpeed.font, }, saveKey = "size", },
					["font.size"] = { saveTo = { data.playerSpeed.font, data.travelSpeed.font, }, saveKey = "size", },
					["speedDisplay.text.font.size"] = { saveTo = { data.playerSpeed.font, data.travelSpeed.font, }, saveKey = "size", },
					["speedDisplay.font.size"] = { saveTo = { data.playerSpeed.font, data.travelSpeed.font, }, saveKey = "size", },
					["font.family"] = { saveTo = { data.playerSpeed.font, data.travelSpeed.font, }, saveKey = "path", },
					["speedDisplay.text.font.family"] = { saveTo = { data.playerSpeed.font, data.travelSpeed.font, }, saveKey = "path", },
					["speedDisplay.font.family"] = { saveTo = { data.playerSpeed.font, data.travelSpeed.font, }, saveKey = "path", },
					["playerSpeed.font.family"] = { saveTo = { data.playerSpeed.font, }, saveKey = "path", },
					["travelSpeed.font.family"] = { saveTo = { data.travelSpeed.font, }, saveKey = "path", },
					["font.color.r"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "r", },
					["speedDisplay.text.font.color.r"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "r", },
					["speedDisplay.font.color.r"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "r", },
					["font.color.g"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "g", },
					["speedDisplay.text.font.color.g"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "g", },
					["speedDisplay.font.color.g"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "g", },
					["font.color.b"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "b", },
					["speedDisplay.text.font.color.b"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "b", },
					["speedDisplay.font.color.b"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "b", },
					["font.color.a"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "a", },
					["speedDisplay.text.font.color.a"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "a", },
					["speedDisplay.font.color.a"] = { saveTo = { data.playerSpeed.font.color, data.travelSpeed.font.color, }, saveKey = "a", },
					["speedDisplay.font.text.valueType"] = { saveTo = { data.playerSpeed.value, data.travelSpeed.value, }, saveKey = "units", convertSave = ConvertOldValueType },
					["speedDisplay.value.type"] = { saveTo = { data.playerSpeed.value, data.travelSpeed.value, }, saveKey = "units", convertSave = ConvertOldValueType },
					["speedDisplay.value.units[1]"] = { saveTo = { data.playerSpeed.value, data.travelSpeed.value.units, }, saveKey = 1, },
					["speedDisplay.value.units[2]"] = { saveTo = { data.playerSpeed.value, data.travelSpeed.value.units, }, saveKey = 2, },
					["speedDisplay.value.units[3]"] = { saveTo = { data.playerSpeed.value, data.travelSpeed.value.units, }, saveKey = 3, },
					["speedDisplay.font.text.decimals"] = { saveTo = { data.playerSpeed.value, data.travelSpeed.value, }, saveKey = "fractionals", },
					["speedDisplay.value.decimals"] = { saveTo = { data.playerSpeed.value, data.travelSpeed.value, }, saveKey = "fractionals", },
					["speedDisplay.value.fractionals"] = { saveTo = { data.playerSpeed.value, data.travelSpeed.value, }, saveKey = "fractionals", },
					["speedDisplay.font.text.noTrim"] = { saveTo = { data.playerSpeed.value, data.travelSpeed.value, }, saveKey = "zeros", },
					["speedDisplay.value.noTrim"] = { saveTo = { data.playerSpeed.value, data.travelSpeed.value, }, saveKey = "zeros", },
					["playerSpeed.enabled"] = { saveTo = { data.playerSpeed.visibility, }, saveKey = "hidden", convertSave = function(value) return not value end },
					["playerSpeed.throttle"] = { saveTo = { data.playerSpeed.update, }, saveKey = "throttle" },
					["playerSpeed.frequency"] = { saveTo = { data.playerSpeed.update, }, saveKey = "frequency" },
					["travelSpeed.enabled"] = { saveTo = { data.travelSpeed.visibility, }, saveKey = "hidden", convertSave = function(value) return not value end },
					["travelSpeed.throttle"] = { saveTo = { data.travelSpeed.update, }, saveKey = "throttle" },
					["travelSpeed.frequency"] = { saveTo = { data.travelSpeed.update, }, saveKey = "frequency" },
					["targetSpeed.tooltip.enabled"] = { saveTo = { data.targetSpeed, }, saveKey = "enabled", },
					["targetSpeed.tooltip.text.valueType"] = { saveTo = { data.targetSpeed.value, }, saveKey = "units", convertSave = ConvertOldValueType },
					["targetSpeed.value.type"] = { saveTo = { data.targetSpeed.value, }, saveKey = "units", convertSave = ConvertOldValueType },
					["targetSpeed.tooltip.text.decimals"] = { saveTo = { data.targetSpeed.value, }, saveKey = "fractionals", },
					["targetSpeed.value.decimals"] = { saveTo = { data.targetSpeed.value, }, saveKey = "fractionals", },
					["targetSpeed.tooltip.text.noTrim"] = { saveTo = { data.targetSpeed.value, }, saveKey = "zeros", },
					["targetSpeed.value.noTrim"] = { saveTo = { data.targetSpeed.value, }, saveKey = "zeros", },
					["visibility.hidden"] = { saveTo = { data.playerSpeed.visibility, }, saveKey = "hidden", },
					["appearance.hidden"] = { saveTo = { data.playerSpeed.visibility, }, saveKey = "hidden", },
				} end,
				onProfileActivated = function(title)
					--Update the interface options
					options.playerSpeed.page.load(true)
					options.targetSpeed.page.load(true)
					options.dataManagement.page.load(true)

					chatCommands.print(ns.strings.chat.profile.response:gsub("#PROFILE", cr(title, ns.colors.yellow[2])))
				end,
				onProfileDeleted = function(title) chatCommands.print(ns.strings.chat.default.response:gsub("#PROFILE", cr(title, ns.colors.yellow[2]))) end,
				onProfileReset = function(title) chatCommands.print(ns.strings.chat.default.response:gsub("#PROFILE", cr(title, ns.colors.yellow[2]))) end,
				onImport = function(success) if success then
					--Update the interface options
					options.playerSpeed.page.load(true)
					options.targetSpeed.page.load(true)
					options.dataManagement.page.load(true)
				else chatCommands.print(wt.strings.backup.error) end end,
				onImportAllProfiles = function(success) if not success then chatCommands.print(wt.strings.backup.error) end end,
			})

			--[ Settings Setup ]

			options.about.page = wt.CreateAboutPage(ns.name, {
				name = "Main",
				description = ns.strings.options.main.description:gsub("#ADDON", ns.title),
				changelog = ns.changelog
			})

			options.pageManager = wt.CreateSettingsCategory(ns.name, options.about.page, {
				CreateSpeedDisplayOptionsPage(),
				CreateTargetSpeedOptionsPage(),
				options.dataManagement.page
			})

			--[ Chat Control Setup ]

			---@type chatCommandManager
			chatCommands = wt.RegisterChatCommands(ns.name, ns.chat.keywords, {
				commands = {
					{
						command = ns.chat.commands.options,
						description = ns.strings.chat.options.description:gsub("#ADDON", ns.title),
						handler = options.about.page.open,
					},
					{
						command = ns.chat.commands.preset,
						description = ns.strings.chat.preset.description:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#INDEX", cr(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])
						),
						handler = function(_, p) return options.playerSpeed.position.applyPreset(tonumber(p)) end,
						error = ns.strings.chat.preset.unchanged .. "\n" .. cr(ns.strings.chat.preset.error:gsub(
							"#INDEX", cr(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])
						), ns.colors.yellow[2]),
						onError = function()
							print(cr(ns.strings.chat.preset.list, ns.colors.yellow[1]))
							for i = 1, #options.playerSpeed.position.presets, 2 do
								local list = "    " .. cr(i, ns.colors.green[2]) .. cr(" • " .. options.playerSpeed.position.presets[i].title, ns.colors.yellow[2])

								if i + 1 <= #options.playerSpeed.position.presets then
									list = list .. "    " .. cr(i + 1, ns.colors.green[2]) .. cr(" • " .. options.playerSpeed.position.presets[i + 1].title, ns.colors.yellow[2])
								end

								print(list)
							end
						end,
					},
					{
						command = ns.chat.commands.save,
						description = ns.strings.chat.save.description:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#CUSTOM", cr(options.playerSpeed.position.presets[1].title, ns.colors.yellow[1])
						),
						handler = function() options.playerSpeed.position.saveCustomPreset() end,
					},
					{
						command = ns.chat.commands.reset,
						description = ns.strings.chat.reset.description:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#CUSTOM", cr(options.playerSpeed.position.presets[1].title, ns.colors.yellow[1])
						),
						handler = function() options.playerSpeed.position.resetCustomPreset() end,
					},
					{
						command = ns.chat.commands.toggle,
						description = function() return (ns.strings.chat.toggle.description:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#HIDDEN", cr(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden and ns.strings.chat.toggle.hidden or ns.strings.chat.toggle.notHidden, ns.colors.yellow[1])
						)) end,
						handler = function()
							options.playerSpeed.visibility.hidden.setData(not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden)

							return true
						end,
						success = function() return ((MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden and ns.strings.chat.toggle.hiding or ns.strings.chat.toggle.unhiding):gsub(
							"#TYPE", ns.strings.options.playerSpeed.title
						)) end,
					},
					{
						command = ns.chat.commands.auto,
						description = function() return (ns.strings.chat.auto.description:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#STATE", cr(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[1])
						)) end,
						handler = function()
							options.playerSpeed.visibility.autoHide.setData(not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide)

							return true
						end,
						success = function()
							return (ns.strings.chat.auto.response:gsub(
								"#TYPE", ns.strings.options.playerSpeed.title
							):gsub(
								"#STATE", cr(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[2])
							))
						end,
					},
					{
						command = ns.chat.commands.size,
						description = function()
							return (ns.strings.chat.size.description:gsub(
								"#TYPE", ns.strings.options.playerSpeed.title
							):gsub(
								"#SIZE", cr(ns.chat.commands.size .. " " .. ns.profileDefault.playerSpeed.font.size, ns.colors.green[2])
							))
						end,
						handler = function(_, p)
							local size = tonumber(p)

							if not size then return false end

							options.playerSpeed.font.size.setData(size)

							return true, size
						end,
						success = function(size) return (ns.strings.chat.size.response:gsub(
							"#TYPE", ns.strings.options.playerSpeed.title
						):gsub("#VALUE", cr(size, ns.colors.yellow[2]))) end,
						error = function() return (ns.strings.chat.size.unchanged:gsub(
							"#TYPE", ns.strings.options.playerSpeed.title
						)) end,
						onError = function() print("    " .. cr(ns.strings.chat.size.error:gsub(
							"#SIZE", cr(ns.chat.commands.size .. " " .. ns.profileDefault.playerSpeed.font.size, ns.colors.green[2])
						), ns.colors.yellow[2])) end,
					},
					{
						command = ns.chat.commands.profile,
						description = ns.strings.chat.profile.description:gsub(
							"#INDEX", cr(ns.chat.commands.profile .. " " .. 1, ns.colors.green[2])
						),
						handler = function(_, p) return options.dataManagement.activateProfile(tonumber(p)) end,
						error = ns.strings.chat.profile.unchanged .. "\n" .. cr(ns.strings.chat.profile.error:gsub(
							"#INDEX", cr(ns.chat.commands.profile .. " " .. 1, ns.colors.green[2])
						), ns.colors.yellow[2]),
						onError = function()
							print(cr(ns.strings.chat.profile.list, ns.colors.yellow[1]))
							for i = 1, #MovementSpeedDB.profiles, 4 do
								local list = "    " .. cr(i, ns.colors.green[2]) .. cr(" • " .. MovementSpeedDB.profiles[i].title, ns.colors.yellow[2])

								for j = i + 1, min(i + 3, #MovementSpeedDB.profiles) do
									list = list .. "    " .. cr(j, ns.colors.green[2]) .. cr(" • " .. MovementSpeedDB.profiles[j].title, ns.colors.yellow[2])
								end

								print(list)
							end
						end,
					},
					{
						command = ns.chat.commands.default,
						description = function() return (ns.strings.chat.default.description:gsub(
							"#PROFILE", cr(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].title, ns.colors.yellow[1])
						)) end,
						handler = function() return options.dataManagement.resetProfile() end,
					},
					{
						command = "hi",
						hidden = true,
						handler = function(manager) manager.welcome() end,
					},
				},
				colors = {
					title = ns.colors.green[1],
					content = ns.colors.yellow[1],
					command = ns.colors.green[2],
					description = ns.colors.yellow[2]
				},
				onWelcome = function() print(cr(ns.strings.chat.help.move, ns.colors.yellow[2])) end,
			})

			--Welcome message
			if firstLoad then chatCommands.welcome() end

			--[ Display Setup ]

			CreateContextMenu()
			wt.SetPosition(frames.playerSpeed.display, us.Fill({ relativePoint = MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.position.anchor, }, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.position))
			wt.ConvertToAbsolutePosition(frames.playerSpeed.display)
			SetDisplayValues(frames.playerSpeed, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed)
		end,
		PLAYER_ENTERING_WORLD = function(self)
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")

			FormatSpeedText("playerSpeed")
			FormatSpeedText("targetSpeed")

			--Start speed updates
			if not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden then StartSpeedDisplayUpdates() end
			if MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.enabled then EnableTargetSpeedUpdates() end

			--Finish loading the active profile for new characters
			if newCharacter then
				--Update the interface options
				options.playerSpeed.page.load(true)
				options.targetSpeed.page.load(true)
				options.dataManagement.page.load(true)

				chatCommands.print(ns.strings.chat.profile.response:gsub("#PROFILE", cr(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].title, ns.colors.yellow[2])))
			end

			--Visibility notice
			if not frames.playerSpeed.display:IsVisible() and MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.statusNotice then PrintStatus() end
		end,
	},
	events = {
		OnShow = function() if not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden then frames.playerSpeed.display:Show() end end,
		OnHide = function() frames.playerSpeed.display:Hide() end
	},
	initialize = function(frame, _, _, name)
		--Custom Tooltip
		local tooltip = wt.CreateGameTooltip(ns.name)

		--| Player Speed

		frames.playerSpeed.display = wt.CreateCustomFrame({
			parent = UIParent,
			name = name .. "PlayerSpeed",
			events = { OnUpdate = function(self)
				--Update the tooltip
				if self:IsMouseOver() and frames.playerSpeed.tooltipData.tooltip:IsVisible() then wt.UpdateTooltip(self, { lines = GetPlayerSpeedTooltipLines(), }) end
			end, },
			initialize = function(display, _, height)
				--Tooltip
				frames.playerSpeed.tooltipData = wt.AddTooltip(display, {
					tooltip = tooltip,
					title = ns.strings.speedTooltip.title:gsub("#SPEED", ns.strings.options.playerSpeed.title),
					anchor = "ANCHOR_BOTTOMRIGHT",
					offset = { y = height },
					flipColors = true
				})

				--Speed text
				frames.playerSpeed.text = wt.CreateText({
					parent = display,
					layer = "OVERLAY",
					wrap = false,
				})
			end,
		})

		frames.playerSpeed.updater = wt.CreateFrame({
			parent = frame,
			name = "PlayerSpeedUpdater",
		})

		--| Target Speed

		frames.targetSpeed = wt.CreateFrame({
			parent = frame,
			name = "TargetSpeedUpdater",
		})
	end
})