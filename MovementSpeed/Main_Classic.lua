--[[ NAMESPACE ]]

---@class MovementSpeedNamespace
local ns = select(2, ...)


--[[ REFERENCES ]]

---@class wt
local wt = ns.WidgetToolbox

local frames = {
	playerSpeed = {},
}

local options = {
	main = {},
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

--Sum of time since the last speed update
local timeSinceSpeedUpdate = {
	playerSpeed = 0,
}


--[[ UTILITIES ]]

--[ Resource Management ]

---Find the ID of the font provided
---@param fontPath string
---@return integer id ***Default:*** 1 *(if* **fontPath** *isn't found)*
local function GetFontID(fontPath)
	local id = 1

	for i = 1, #ns.fonts do
		if ns.fonts[i].path == fontPath then
			id = i

			break
		end
	end

	return id
end

--[ Data Management ]

---Check the validity of the provided key value pair
---@param key string
---@param value any
---@return boolean
local function CheckValidity(key, value)
	if type(value) == "number" then
		--Non-negative
		if key == "size" then return value > 0 end
		--Range constraint: 0 - 1
		if key == "r" or key == "g" or key == "b" or key == "a" then return value >= 0 and value <= 1 end
		--Corrupt Anchor Points
		if key == "anchor" then return false end
	end return true
end

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

local function GetRecoveryMap(data)
	return {
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
		["font.family"] = { saveTo = { data.playerSpeed.font, data.travelSpeed.font, }, saveKey = "family", },
		["speedDisplay.text.font.family"] = { saveTo = { data.playerSpeed.font, data.travelSpeed.font, }, saveKey = "family", },
		["speedDisplay.font.family"] = { saveTo = { data.playerSpeed.font, data.travelSpeed.font, }, saveKey = "family", },
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
	}
end

--[ Chat Control ]

---Print visibility info
local function PrintStatus()
	print(wt.Color((frames.main:IsVisible() and (
		not frames.playerSpeed.display:IsVisible() and ns.strings.chat.status.notVisible or ns.strings.chat.status.visible
	) or ns.strings.chat.status.hidden):gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub("#AUTO", ns.strings.chat.status.auto:gsub("#STATE", wt.Color(
		MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[1]
	))), ns.colors.yellow[2]))
end

--[ Speed Update ]

---Format the raw string of the specified speed textline to be replaced by speed values later
---@param type "playerSpeed"|"targetSpeed"
---@param units table
---@param color? boolean
local function FormatSpeedText(type, units, color)
	speedText[type] = ""

	if units[1] then
		local sign = (type == "targetSpeed" and "%%" or "%")
		speedText[type] = speedText[type] .. (color and wt.Color("#PERCENT" .. sign, ns.colors.green[2]) or "#PERCENT" .. sign)
	end
	if units[2] then
		speedText[type] = speedText[type] .. ns.strings.speedValue.separator .. (color and wt.Color(ns.strings.speedValue.yps:gsub(
			"#YARDS", wt.Color("#YARDS", ns.colors.yellow[2])
		), ns.colors.yellow[1]) or ns.strings.speedValue.yps)
	end

	speedText[type] = speedText[type]:gsub("^" .. ns.strings.speedValue.separator, "")
end

---Return the specified speed textline with placeholders replaced by formatted speed values
---@param type "playerSpeed"|"targetSpeed"
---@return string
local function GetSpeedText(type)
	local f = max(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.fractionals, 1)

	return speedText[type]:gsub(
		"#PERCENT", wt.Thousands(
			speed[type].percent,
			MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.fractionals,
			true,
			not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.zeros
		)
	):gsub(
		"#YARDS", wt.Thousands(
			speed[type].yards,
			MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.fractionals,
			true,
			not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.zeros
		)
	)
end

--Update the Player Speed values
local function UpdatePlayerSpeed()
	speed.playerSpeed.yards = GetUnitSpeed(UnitInVehicle("player") and "vehicle" or "player")
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

---Set the size of the speed display
---@param height? number Text height | ***Default:*** frames.playerSpeed.text:GetStringHeight()
---@param units? table Displayed units | ***Default:*** MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.units
---@param fractionals? number Height:Width ratio | ***Default:*** MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.fractionals
---@param font? string Font path | ***Default:*** MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.family
local function SetDisplaySize(height, units, fractionals, font)
	height = math.ceil(height or frames.playerSpeed.text:GetStringHeight()) + 2.4
	units = units or MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.units
	fractionals = fractionals or MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.fractionals

	--Calculate width to height ratio
	local ratio = 0
	if units[1] then ratio = ratio + 3.58 + (fractionals > 0 and 0.1 + 0.54 * fractionals or 0) end
	if units[2] then ratio = ratio + 3.52 + (fractionals > 0 and 0.1 + 0.54 * fractionals or 0) end
	for i = 1, 3 do if units[i] then ratio = ratio + 0.2 end end --Separators

	--Resize the display
	frames.playerSpeed.display:SetSize(height * ratio * ns.fonts[GetFontID(font or MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.family)].widthRatio - 4, height)
end

---Set the backdrop of the speed display elements
---@param enabled boolean Whether to add or remove the backdrop elements of the speed display
---@param bgColor table Table containing the backdrop background color values
--- - **r** number ― Red (Range: 0 - 1)
--- - **g** number ― Green (Range: 0 - 1)
--- - **b** number ― Blue (Range: 0 - 1)
--- - **a** number ― Opacity (Range: 0 - 1)
---@param borderColor table Table containing the backdrop border color values
--- - **r** number ― Red (Range: 0 - 1)
--- - **g** number ― Green (Range: 0 - 1)
--- - **b** number ― Blue (Range: 0 - 1)
--- - **a** number ― Opacity (Range: 0 - 1)
local function SetDisplayBackdrop(enabled, bgColor, borderColor)
	wt.SetBackdrop(frames.playerSpeed.display, enabled and {
		background = {
			texture = { size = 5, },
			color = bgColor
		},
		border = {
			texture = {
				path = "Interface/ChatFrame/ChatFrameBackground",
				width = 1,
			},
			color = borderColor
		}
	} or nil)
end

---Set the visibility, backdrop, font family, size and color of the speed display to the currently saved values
---@param data table Account-wide data table to set the speed display values from
local function SetDisplayValues(data)
	--Position
	frames.playerSpeed.display:SetClampedToScreen(data.playerSpeed.keepInBounds)

	--Visibility
	frames.playerSpeed.display:SetFrameStrata(data.playerSpeed.layer.strata)
	wt.SetVisibility(frames.playerSpeed.display, not data.playerSpeed.visibility.hidden)

	--Display
	SetDisplaySize(data.playerSpeed.font.size, data.playerSpeed.value.units, data.playerSpeed.value.fractionals, data.playerSpeed.font.family)
	SetDisplayBackdrop(data.playerSpeed.background.visible, data.playerSpeed.background.colors.bg, data.playerSpeed.background.colors.border)

	--Font & text
	frames.playerSpeed.text:SetFont(data.playerSpeed.font.family, data.playerSpeed.font.size, "THINOUTLINE")
	frames.playerSpeed.text:SetTextColor(wt.UnpackColor(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.valueColoring and ns.colors.grey[2] or MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.color))
	frames.playerSpeed.text:SetJustifyH(data.playerSpeed.font.alignment)
	wt.SetPosition(frames.playerSpeed.text, { anchor = data.playerSpeed.font.alignment, })
end

--| Tooltip content

local playerSpeedTooltipLines

--Assemble the detailed text lines for the tooltip of the Player Speed display
local function GetPlayerSpeedTooltipLines()
	playerSpeedTooltipLines = {
		{ text = ns.strings.speedTooltip.description },
		{ text = "\n" .. ns.strings.speedTooltip.playerSpeed, },
		{
			text = "\n" .. ns.strings.speedTooltip.text[1]:gsub("#YARDS", wt.Color(wt.Thousands(speed.playerSpeed.yards, 2, true),  ns.colors.yellow[2])),
			font = GameTooltipText,
			color = ns.colors.yellow[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.text[2]:gsub(
				"#PERCENT", wt.Color(wt.Thousands(speed.playerSpeed.percent, 2, true) .. "%%", ns.colors.green[2])
			),
			font = GameTooltipText,
			color = ns.colors.green[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.hintOptions,
			font = GameFontNormalTiny,
			color = ns.colors.grey[1],
		},
		{
			text = ns.strings.speedTooltip.hintMove,
			font = GameFontNormalTiny,
			color = ns.colors.grey[1],
		},
	}

	return playerSpeedTooltipLines
end

--| Toggle updates

---Start updating the speed display
local function StartSpeedDisplayUpdates()
	--Update the speed values at start
	UpdatePlayerSpeed(timeSinceSpeedUpdate.playerSpeed)

	--| Repeated updates

	frames.playerSpeed.updater:SetScript("OnUpdate", function(_, deltaTime) if MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.update.throttle then
		timeSinceSpeedUpdate.playerSpeed = timeSinceSpeedUpdate.playerSpeed + deltaTime

		if timeSinceSpeedUpdate.playerSpeed < MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.update.frequency then return else
			UpdatePlayerSpeed(timeSinceSpeedUpdate.playerSpeed)

			timeSinceSpeedUpdate.playerSpeed = 0
		end
	else UpdatePlayerSpeed(deltaTime) end end)
end

--Stop updating the speed display
local function StopSpeedDisplayUpdates()
	frames.playerSpeed.updater:SetScript("OnUpdate", nil)
end

--[ Target Speed ]

---Assemble the text for the mouseover target's speed
---@return string
local function GetTargetSpeedText()
	return wt.Texture(ns.textures.logo) .. " " .. ns.strings.targetSpeed:gsub("#SPEED", wt.Color(GetSpeedText("targetSpeed"), ns.colors.grey[2]))
end

--| Updates

local targetSpeedEnabled = false

--Set up the Target Speed unit tooltip integration
local function EnableTargetSpeedUpdates()
	local lineAdded, line

	targetSpeedEnabled = true

	--Start mouseover Target Speed updates
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
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
				tooltip:Show() --Force the tooltip to be resized
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
		arrange = { newRow = false, },
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
		arrange = { newRow = false, },
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
			onChange = { RefreshSpeedUpdates = function()
				StopSpeedDisplayUpdates()
				StartSpeedDisplayUpdates()
			end },
		},
	})

	---@type numeric|numericSlider
	options.playerSpeed.update.frequency = wt.CreateNumericSlider({
		parent = panel,
		name = "Frequency",
		title = ns.strings.options.speedDisplay.update.frequency.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.frequency.tooltip, }, } },
		arrange = { newRow = false, },
		min = 0.05,
		max = 1,
		increment = 0.05,
		altStep = 0.2,
		events = { OnValueChanged = function(_, value)  end, },
		dependencies = {
			{ frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options.playerSpeed.update.throttle },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.update.frequency end,
		saveData = function(value) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.update.frequency = wt.Round(value, 2) end,
		default = ns.profileDefault.playerSpeed.update.frequency,
		dataManagement = {
			category = category,
			key = key,
			onChange = { "RefreshSpeedUpdates", },
		},
	})
end
local function CreateSpeedValueOptions(panel, category, key)
	---@type checkboxSelector|multiselector
	options.playerSpeed.value.units = wt.CreateCheckboxSelector({
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
				UpdateDisplaySize = function() SetDisplaySize() end,
				UpdateSpeedTextTemplate = function() FormatSpeedText("playerSpeed", MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.units, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.valueColoring) end,
			},
		},
	})

	---@type numeric|numericSlider
	options.playerSpeed.value.fractionals = wt.CreateNumericSlider({
		parent = panel,
		name = "Fractionals",
		title = ns.strings.options.speedValue.fractionals.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.fractionals.tooltip, }, } },
		arrange = { newRow = false, },
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
		arrange = { newRow = false, },
		autoOffset = true,
		dependencies = {
			{ frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options.playerSpeed.value.fractionals, evaluate = function(value) return value > 0 end },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.zeros end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.zeros = state end,
		default = ns.profileDefault.playerSpeed.value.zeros,
		dataManagement = {
			category = category,
			key = key,
		},
	})
end
local function CreateFontOptions(panel, category, key)
	--Dropdown: Font family
	local fontItems = {}
	for i = 1, #ns.fonts do
		fontItems[i] = {}
		fontItems[i].title = ns.fonts[i].name
		fontItems[i].tooltip = {
			title = ns.fonts[i].name,
			lines = i == 1 and { { text = ns.strings.options.speedDisplay.font.family.default, }, } or (i == #ns.fonts and {
				{ text = ns.strings.options.speedDisplay.font.family.custom[1]:gsub("#OPTION_CUSTOM", ns.strings.misc.custom):gsub("#FILE_CUSTOM", "CUSTOM.ttf"), },
				{ text = "[WoW]\\Interface\\AddOns\\" .. ns.name .. "\\Fonts\\", color = { r = 0.185, g = 0.72, b = 0.84 }, wrap = false },
				{ text = ns.strings.options.speedDisplay.font.family.custom[2]:gsub("#FILE_CUSTOM", "CUSTOM.ttf"), },
				{ text = "\n" .. ns.strings.options.speedDisplay.font.family.custom[3], color = { r = 0.89, g = 0.65, b = 0.40 }, },
			} or nil),
		}
	end
	---@type selector|dropdownSelector
	options.playerSpeed.font.family = wt.CreateDropdownSelector({
		parent = panel,
		name = "Family",
		title = ns.strings.options.speedDisplay.font.family.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.family.tooltip, }, } },
		arrange = {},
		items = fontItems,
		dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return GetFontID(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.family) end,
		saveData = function(selected) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.family = ns.fonts[selected or 1].path end,
		default = GetFontID(ns.profileDefault.playerSpeed.font.family),
		dataManagement = {
			category = category,
			key = key,
			onChange = {
				UpdateDisplayFont = function() frames.playerSpeed.text:SetFont(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.family, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.size, "THINOUTLINE") end,
				"UpdateDisplaySize",
				RefreshDisplayText = function() --Refresh the text so the font will be applied right away (if the font is loaded)
					local text = frames.playerSpeed.text:GetText()
					frames.playerSpeed.text:SetText("")
					frames.playerSpeed.text:SetText(text)
				end,
				UpdateFontFamilyDropdownText = function()
					--Update the font of the dropdown toggle button label
					local _, size, flags = options.playerSpeed.font.family.toggle.label:GetFont()
					options.playerSpeed.font.family.toggle.label:SetFont(ns.fonts[options.playerSpeed.font.family.getSelected() or 1].path, size, flags)

					--Refresh the text so the font will be applied right away (if the font is loaded)
					local text = options.playerSpeed.font.family.toggle.label:GetText()
					options.playerSpeed.font.family.toggle.label:SetText("")
					options.playerSpeed.font.family.toggle.label:SetText(text)
				end,
			},
		},
	})
	--Update the font of the dropdown items
	if options.playerSpeed.font.family.frame then for i = 1, #options.playerSpeed.font.family.toggles do if options.playerSpeed.font.family.toggles[i].label then
		local _, size, flags = options.playerSpeed.font.family.toggles[i].label:GetFont()
		options.playerSpeed.font.family.toggles[i].label:SetFont(ns.fonts[i].path, size, flags)
	end end end

	---@type numeric|numericSlider
	options.playerSpeed.font.size = wt.CreateNumericSlider({
		parent = panel,
		name = "Size",
		title = ns.strings.options.speedDisplay.font.size.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.size.tooltip, }, } },
		arrange = { newRow = false, },
		min = 8,
		max = 64,
		increment = 1,
		altStep = 3,
		dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.size end,
		saveData = function(value) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.size = value end,
		default = ns.profileDefault.playerSpeed.font.size,
		dataManagement = {
			category = category,
			key = key,
			onChange = {
				"UpdateDisplayFont",
				"UpdateDisplaySize",
			},
		},
	})

	---@type specialSelector|specialRadioSelector
	options.playerSpeed.font.alignment = wt.CreateSpecialRadioSelector("justifyH", {
		parent = panel,
		name = "Alignment",
		title = ns.strings.options.speedDisplay.font.alignment.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.alignment.tooltip, }, } },
		arrange = { newRow = false, },
		width = 140,
		dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.alignment end,
		saveData = function(value) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.alignment = value end,
		default = ns.profileDefault.playerSpeed.font.alignment,
		dataManagement = {
			category = category,
			key = key,
			onChange = { UpdateDisplayTextAlignment = function()
				frames.playerSpeed.text:SetJustifyH(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.alignment)
				wt.SetPosition(frames.playerSpeed.text, { anchor = MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.alignment, })
			end, },
		},
	})

	---@type toggle|checkbox
	options.playerSpeed.font.valueColoring = wt.CreateCheckbox({
		parent = panel,
		name = "ValueColoring",
		title = ns.strings.options.speedDisplay.font.valueColoring.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.valueColoring.tooltip:gsub("#ADDON", ns.title), }, } },
		arrange = {},
		dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.valueColoring end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.valueColoring = state end,
		default = ns.profileDefault.playerSpeed.font.valueColoring,
		dataManagement = {
			category = category,
			key = key,
			onChange = {
				UpdateDisplayFontColor = function() frames.playerSpeed.text:SetTextColor(wt.UnpackColor(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.valueColoring and ns.colors.grey[2] or MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.color)) end,
				UpdateEmbeddedValueColoring = function()
					if MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.valueColoring then
						FormatSpeedText("playerSpeed", MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.units, true)
					else speedText.playerSpeed = wt.Clear(speedText.playerSpeed) end
				end,
			},
		},
	})

	---@type colorPicker|colorPickerFrame
	options.playerSpeed.font.color = wt.CreateColorPickerFrame({
		parent = panel,
		name = "Color",
		title = ns.strings.options.speedDisplay.font.color.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.color.tooltip, }, } },
		arrange = { newRow = false, },
		dependencies = {
			{ frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options.playerSpeed.font.valueColoring, evaluate = function(state) return not state end },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.color end,
		saveData = function(color) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.color = color end,
		default = ns.profileDefault.playerSpeed.font.color,
		dataManagement = {
			category = category,
			key = key,
			onChange = { "UpdateDisplayFontColor", },
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
			onChange = { ToggleDisplayBackdrops = function() SetDisplayBackdrop(
				MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background.visible,
				MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background.colors.bg,
				MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.background.colors.border
			) end, },
		},
	})

	---@type colorPicker|colorPickerFrame
	options.playerSpeed.background.colors.bg = wt.CreateColorPickerFrame({
		parent = panel,
		name = "Color",
		title = ns.strings.options.speedDisplay.background.colors.bg.label,
		tooltip = {},
		arrange = { newRow = false, },
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

	---@type colorPicker|colorPickerFrame
	options.playerSpeed.background.colors.border = wt.CreateColorPickerFrame({
		parent = panel,
		name = "BorderColor",
		title = ns.strings.options.speedDisplay.background.colors.border.label,
		tooltip = {},
		arrange = { newRow = false, },
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
		logo = ns.textures.logo,
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
		storage = { { storageTable = MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed, defaultsTable = ns.profileDefault.playerSpeed, }, },
		onDefault = function(_, category)
			chatCommands.print(ns.strings.chat.default.responseCategory:gsub(
				"#CATEGORY", wt.Color(ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options.playerSpeed.title), ns.colors.yellow[2])
			):gsub(
				"#PROFILE", wt.Color(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].title, ns.colors.yellow[2])
			))

			if not category then options.playerSpeed.position.resetCustomPreset() else options.playerSpeed.position.applyPreset(1) end
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
			options.playerSpeed.position = wt.CreatePositionOptions(ns.name, {
				canvas = canvas,
				frame = frames.playerSpeed.display,
				frameName = ns.strings.options.speedDisplay.referenceName:gsub("#TYPE", ns.strings.options.playerSpeed.title),
				presets = {
					items = {
						{
							title = ns.strings.misc.custom, --Custom
							onSelect = function() options.playerSpeed.position.presetList[1].data.position.relativePoint = options.playerSpeed.position.presetList[1].data.position.anchor end,
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
						wt.ConvertToAbsolutePosition(frames.playerSpeed.display)

						--Make sure the speed display is visible
						options.playerSpeed.visibility.hidden.setData(false)

						chatCommands.print(ns.strings.chat.preset.response:gsub(
							"#PRESET", wt.Color(options.playerSpeed.position.presetList[i].title, ns.colors.yellow[2])
						):gsub(
							"#TYPE", ns.strings.options.playerSpeed.title
						))
					end,
					custom = {
						getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.customPreset end,
						defaultsTable = ns.profileDefault.customPreset,
						onSave = function()
							chatCommands.print(ns.strings.chat.save.response:gsub(
								"#TYPE", ns.strings.options.playerSpeed.title
							):gsub(
								"#CUSTOM", wt.Color(ns.strings.misc.custom, ns.colors.yellow[2])
							))
						end,
						onReset = function()
							chatCommands.print(ns.strings.chat.reset.response:gsub(
								"#CUSTOM", wt.Color(ns.strings.misc.custom, ns.colors.yellow[2])
							))
						end
					}
				},
				setMovable = { events = {
					onStop = function() chatCommands.print(ns.strings.chat.position.save:gsub(
						"#TYPE", ns.strings.options.playerSpeed.title
					)) end,
					onCancel = function()
						chatCommands.print(ns.strings.chat.position.cancel:gsub(
							"#TYPE", ns.strings.options.playerSpeed.title
						))
						print(wt.Color(ns.strings.chat.position.error, ns.colors.yellow[2]))
					end,
				}, },
				dependencies = { { frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end }, },
				getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed end,
				defaultsTable = ns.profileDefault.playerSpeed,
				settingsData = MovementSpeedCS.playerSpeed,
				dataManagement = { category = ns.name .. displayName, },
			})

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

			wt.CreatePanel({
				parent = canvas,
				name = keys[1],
				title = ns.strings.options.speedDisplay.font.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel, _, _, key) CreateFontOptions(panel, category, key) end,
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
		logo = ns.textures.logo,
		storage = { { storageTable = MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed, defaultsTable = ns.profileDefault.targetSpeed, }, },
		dataManagement = {},
		onDefault = function()
			chatCommands.print(ns.strings.chat.default.responseCategory:gsub(
				"#CATEGORY", wt.Color(ns.strings.options.targetSpeed.title, ns.colors.yellow[2])
			):gsub(
				"#PROFILE", wt.Color(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].title, ns.colors.yellow[2])
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
				initialize =function(panel)
					options.targetSpeed.value.units = wt.CreateCheckboxSelector({
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
							onChange = { UpdateTargetSpeedTextTemplate = function()
								FormatSpeedText("targetSpeed", MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.value.units, true)
							end, },
						},
					})

					options.targetSpeed.value.fractionals = wt.CreateNumericSlider({
						parent = panel,
						name = "Fractionals",
						title = ns.strings.options.speedValue.fractionals.label,
						tooltip = { lines = { { text = ns.strings.options.speedValue.fractionals.tooltip, }, } },
						arrange = { newRow = false, },
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
						arrange = { newRow = false, },
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
		end,
	})

	return options.targetSpeed.page
end


--[[ INITIALIZATION ]]

--Custom Tooltip
ns.tooltip = wt.CreateGameTooltip(ns.name)

---Set up the speed display context menu
local function CreateContextMenu()
	wt.CreateContextMenu({ parent = frames.playerSpeed.display, initialize = function(menu)
		wt.CreateMenuTextline(menu, { text = ns.title, })
		wt.CreateSubmenu(menu, { title = ns.strings.misc.options, initialize = function(optionsMenu)
			wt.CreateMenuButton(optionsMenu, {
				title = wt.GetStrings("about").title,
				tooltip = { lines = { { text = ns.strings.options.main.description:gsub("#ADDON", ns.title), }, } },
				action = options.main.page.open,
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
				title = wt.GetStrings("dataManagement").title,
				tooltip = { lines = { { text = wt.GetStrings("dataManagement").description:gsub("#ADDON", ns.title), }, } },
				action = options.dataManagement.page.open,
			})
		end })
		wt.CreateSubmenu(menu, { title = wt.GetStrings("apply").label, initialize = function(presetsMenu)
			for i = 1, #options.playerSpeed.position.presetList do wt.CreateMenuButton(presetsMenu, {
				title = options.playerSpeed.position.presetList[i].title,
				action = function() options.playerSpeed.position.applyPreset(i) end,
			}) end
		end })
	end, })
end

--Create main addon frame & display
frames.main = wt.CreateFrame({
	name = ns.name,
	position = {},
	onEvent = {
		ADDON_LOADED = function(self, addon)
			if addon ~= ns.name then return end

			self:UnregisterEvent("ADDON_LOADED")

			--[ Data ]

			local firstLoad = not MovementSpeedDB

			--| Load storage DBs

			MovementSpeedDB = MovementSpeedDB or {}
			MovementSpeedDBC = MovementSpeedDBC or {}

			--| Load cross-session data

			MovementSpeedCS = wt.AddMissing(MovementSpeedCS or {}, {
				compactBackup = true,
				playerSpeed = { keepInPlace = true, },
			})

			--| Initialize data management

			options.dataManagement = wt.CreateDataManagementPage(ns.name, {
				onDefault = function(_, category) if not category then options.dataManagement.resetProfile() end end,
				accountData = MovementSpeedDB,
				characterData = MovementSpeedDBC,
				settingsData = MovementSpeedCS,
				defaultsTable = ns.profileDefault,
				onProfileActivated = function(title)
					--Update the interface options
					options.playerSpeed.page.load(true)
					options.targetSpeed.page.load(true)
					options.dataManagement.page.load(true)

					chatCommands.print(ns.strings.chat.profile.response:gsub("#PROFILE", wt.Color(title, ns.colors.yellow[2])))
				end,
				onProfileDeleted = function(title) chatCommands.print(ns.strings.chat.default.response:gsub("#PROFILE", wt.Color(title, ns.colors.yellow[2]))) end,
				onProfileReset = function(title) chatCommands.print(ns.strings.chat.default.response:gsub("#PROFILE", wt.Color(title, ns.colors.yellow[2]))) end,
				onImport = function(success) if success then
					--Update the interface options
					options.playerSpeed.page.load(true)
					options.targetSpeed.page.load(true)
					options.dataManagement.page.load(true)
				else chatCommands.print(wt.GetStrings("backup").error) end end,
				onImportAllProfiles = function(success) if not success then chatCommands.print(wt.GetStrings("backup").error) end end,
				valueChecker = CheckValidity,
				onRecovery = GetRecoveryMap
			})

			--[ Settings Setup ]

			options.main.page = wt.CreateAboutPage(ns.name, {
				name = "Main",
				description = ns.strings.options.main.description:gsub("#ADDON", ns.title),
				changelog = ns.changelog
			})

			options.pageManager = wt.CreateSettingsCategory(ns.name, options.main.page, {
				CreateSpeedDisplayOptionsPage(),
				CreateTargetSpeedOptionsPage(),
				options.dataManagement.page
			})

			--[ Chat Control Setup ]

			chatCommands = wt.RegisterChatCommands(ns.name, ns.chat.keywords, {
				commands = {
					{
						command = ns.chat.commands.options,
						description = ns.strings.chat.options.description:gsub("#ADDON", ns.title),
						handler = options.main.page.open,
					},
					{
						command = ns.chat.commands.preset,
						description = ns.strings.chat.preset.description:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#INDEX", wt.Color(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])
						),
						handler = function(_, p) return options.playerSpeed.position.applyPreset(tonumber(p)) end,
						error = ns.strings.chat.preset.unchanged .. "\n" .. wt.Color(ns.strings.chat.preset.error:gsub(
							"#INDEX", wt.Color(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])
						), ns.colors.yellow[2]),
						onError = function()
							print(wt.Color(ns.strings.chat.preset.list, ns.colors.yellow[1]))
							for i = 1, #options.playerSpeed.position.presetList, 2 do
								local list = "    " .. wt.Color(i, ns.colors.green[2]) .. wt.Color(" • " .. options.playerSpeed.position.presetList[i].title, ns.colors.yellow[2])

								if i + 1 <= #options.playerSpeed.position.presetList then
									list = list .. "    " .. wt.Color(i + 1, ns.colors.green[2]) .. wt.Color(" • " .. options.playerSpeed.position.presetList[i + 1].title, ns.colors.yellow[2])
								end

								print(list)
							end
						end,
					},
					{
						command = ns.chat.commands.save,
						description = ns.strings.chat.save.description:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#CUSTOM", wt.Color(options.playerSpeed.position.presetList[1].title, ns.colors.yellow[1])
						),
						handler = function() options.playerSpeed.position.saveCustomPreset() end,
					},
					{
						command = ns.chat.commands.reset,
						description = ns.strings.chat.reset.description:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#CUSTOM", wt.Color(options.playerSpeed.position.presetList[1].title, ns.colors.yellow[1])
						),
						handler = function() options.playerSpeed.position.resetCustomPreset() end,
					},
					{
						command = ns.chat.commands.toggle,
						description = function() return ns.strings.chat.toggle.description:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#HIDDEN", wt.Color(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden and ns.strings.chat.toggle.hidden or ns.strings.chat.toggle.notHidden, ns.colors.yellow[1])
						) end,
						handler = function()
							options.playerSpeed.visibility.hidden.setData(not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden, true)

							return true
						end,
						success = function() return (MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden and ns.strings.chat.toggle.hiding or ns.strings.chat.toggle.unhiding):gsub(
							"#TYPE", ns.strings.options.playerSpeed.title
						) end,
					},
					{
						command = ns.chat.commands.auto,
						description = function() return ns.strings.chat.auto.description:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#STATE", wt.Color(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[1])
						) end,
						handler = function()
							options.playerSpeed.visibility.autoHide.setData(not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide, true)

							return true
						end,
						success = function()
							return ns.strings.chat.auto.response:gsub(
								"#TYPE", ns.strings.options.playerSpeed.title
							):gsub(
								"#STATE", wt.Color(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[2])
							)
						end,
					},
					{
						command = ns.chat.commands.size,
						description = function() return ns.strings.chat.size.description:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#SIZE", wt.Color(ns.chat.commands.size .. " " .. ns.profileDefault.playerSpeed.font.size, ns.colors.green[2])
						) end,
						handler = function(_, p)
							local size = tonumber(p)

							if not size then return false end

							options.playerSpeed.font.size.setData(size, true)

							return true, size
						end,
						success = function(size) return ns.strings.chat.size.response:gsub("#TYPE", ns.strings.options.playerSpeed.title):gsub(
							"#VALUE", wt.Color(size, ns.colors.yellow[2])
						) end,
						error = function() return ns.strings.chat.size.unchanged:gsub("#TYPE", ns.strings.options.playerSpeed.title) end,
						onError = function() print("    " .. wt.Color(ns.strings.chat.size.error:gsub(
							"#SIZE", wt.Color(ns.chat.commands.size .. " " .. ns.profileDefault.playerSpeed.font.size, ns.colors.green[2])
						), ns.colors.yellow[2])) end,
					},
					{
						command = ns.chat.commands.profile,
						description = ns.strings.chat.profile.description:gsub(
							"#INDEX", wt.Color(ns.chat.commands.profile .. " " .. 1, ns.colors.green[2])
						),
						handler = function(_, p) return options.dataManagement.activateProfile(tonumber(p)) end,
						error = ns.strings.chat.profile.unchanged .. "\n" .. wt.Color(ns.strings.chat.profile.error:gsub(
							"#INDEX", wt.Color(ns.chat.commands.profile .. " " .. 1, ns.colors.green[2])
						), ns.colors.yellow[2]),
						onError = function()
							print(wt.Color(ns.strings.chat.profile.list, ns.colors.yellow[1]))
							for i = 1, #MovementSpeedDB.profiles, 4 do
								local list = "    " .. wt.Color(i, ns.colors.green[2]) .. wt.Color(" • " .. MovementSpeedDB.profiles[i].title, ns.colors.yellow[2])

								for j = i + 1, min(i + 3, #MovementSpeedDB.profiles) do
									list = list .. "    " .. wt.Color(j, ns.colors.green[2]) .. wt.Color(" • " .. MovementSpeedDB.profiles[j].title, ns.colors.yellow[2])
								end

								print(list)
							end
						end,
					},
					{
						command = ns.chat.commands.default,
						description = function() return ns.strings.chat.default.description:gsub(
							"#PROFILE", wt.Color(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].title, ns.colors.yellow[1])
						) end,
						handler = function() return options.dataManagement.resetProfile() end,
					},
					{
						command = "hi",
						hidden = true,
						handler = function(manager) manager.welcome() end,
					},
					{
						command = "delete",
						hidden = true,
						handler = function()
							MovementSpeedDB = nil
							ReloadUI()
						end,
					},
				},
				colors = {
					title = ns.colors.green[1],
					content = ns.colors.yellow[1],
					command = ns.colors.green[2],
					description = ns.colors.yellow[2]
				},
				onWelcome = function() print(wt.Color(ns.strings.chat.help.move, ns.colors.yellow[2])) end,
			})

			--Welcome message
			if firstLoad then chatCommands.welcome() end

			--[ Display Setup ]

			CreateContextMenu()
			wt.SetPosition(frames.playerSpeed.display, wt.AddMissing({ relativePoint = MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.position.anchor, }, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.position))
			wt.ConvertToAbsolutePosition(frames.playerSpeed.display)
			SetDisplayValues(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data)
		end,
		PLAYER_ENTERING_WORLD = function(self)
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")

			FormatSpeedText("playerSpeed", MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.units, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.valueColoring)
			FormatSpeedText("targetSpeed", MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.value.units, true)

			--Start speed updates
			if not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden then StartSpeedDisplayUpdates() end
			if MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.enabled then EnableTargetSpeedUpdates() end

			--Visibility notice
			if not frames.playerSpeed.display:IsVisible() and MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.statusNotice then PrintStatus() end
		end,
		PET_BATTLE_OPENING_START = function(self) self:Hide() end,
		PET_BATTLE_CLOSE = function(self) self:Show() end,
	},
	events = {
		OnShow = function() if not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden then frames.playerSpeed.display:Show() end end,
		OnHide = function() frames.playerSpeed.display:Hide() end
	},
	initialize = function(frame)

		--| Player Speed

		frames.playerSpeed.display = wt.CreateFrame({
			parent = UIParent,
			name = ns.name .. "PlayerSpeed",
			customizable = true,
			events = { OnUpdate = function(self)
				--Update the tooltip
				if self:IsMouseOver() and ns.tooltip:IsVisible() then wt.UpdateTooltip(self, { lines = GetPlayerSpeedTooltipLines("playerSpeed"), }) end
			end, },
			initialize = function(display, _, height)
				--Tooltip
				wt.AddTooltip(display, {
					tooltip = ns.tooltip,
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