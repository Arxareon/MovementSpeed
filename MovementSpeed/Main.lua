--[[ NAMESPACE ]]

---@class MovementSpeedNamespace
local ns = select(2, ...)


--[[ REFERENCES ]]

---@class wt
local wt = ns.WidgetToolbox

local frames = {
	playerSpeed = {},
	travelSpeed = {},
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
	travelSpeed = {
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

local update = {}

--Speed values
local speed = {
	playerSpeed = {
		yards = 0,
		coords = { x = 0, y = 0 }
	},
	travelSpeed = {
		yards = 0,
		coords = { x = 0, y = 0 }
	},
	targetSpeed = {
		yards = 0,
		coords = { x = 0, y = 0 }
	}
}

--Speed text templates
local speedText = {}

--Accumulated time since the last speed update
local timeSinceSpeedUpdate = {
	playerSpeed = 0,
	travelSpeed = 0,
}

--Player position at the last Travel Speed update
local pastPosition = CreateVector2D(0, 0)

--Map info
local map = { size = { w = 0, h = 0 } }


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

---Print visibility info
---@param display displayType
local function PrintStatus(display)
	print(wt.Color((frames.main:IsVisible() and (
		not frames[display].display:IsVisible() and ns.strings.chat.status.notVisible or ns.strings.chat.status.visible
	) or ns.strings.chat.status.hidden):gsub("#TYPE", ns.strings.options[display].title):gsub("#AUTO", ns.strings.chat.status.auto:gsub("#STATE", wt.Color(
		MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[1]
	))), ns.colors.yellow[2]))
end

--[ Speed Update ]

local function UpdateMapInfo()
	map.id = C_Map.GetBestMapForUnit("player")

	if not map.id then return end

	map.name = C_Map.GetMapInfo(map.id).name
	map.size.w, map.size.h = C_Map.GetMapWorldSize(map.id)
end

---Format the raw string of the specified speed textline to be replaced by speed values later
---@param type speedType
---@param units [boolean, boolean, boolean]
---@param valueColoring? boolean
local function FormatSpeedText(type, units, valueColoring)
	speedText[type] = ""

	if units[1] then
		local sign = (type == "targetSpeed" and "%%" or "%")
		speedText[type] = speedText[type] .. (valueColoring and wt.Color("#PERCENT" .. sign, ns.colors.green[2]) or "#PERCENT" .. sign)
	end
	if units[2] then
		speedText[type] = speedText[type] .. ns.strings.speedValue.separator .. (valueColoring and wt.Color(ns.strings.speedValue.yps:gsub(
			"#YARDS", wt.Color("#YARDS", ns.colors.yellow[2])
		), ns.colors.yellow[1]) or ns.strings.speedValue.yps)
	end
	if units[3] then
		speedText[type] = speedText[type] .. ns.strings.speedValue.separator .. (valueColoring and wt.Color(ns.strings.speedValue.cps:gsub(
			"#COORDS", wt.Color(ns.strings.speedValue.coordPair, ns.colors.blue[2])
		), ns.colors.blue[1]) or ns.strings.speedValue.cps:gsub(
			"#COORDS", ns.strings.speedValue.coordPair
		))
	end

	speedText[type] = speedText[type]:gsub("^" .. ns.strings.speedValue.separator, "")
end

---Return the specified speed textline with placeholders replaced by formatted speed values
---@param type speedType
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
	):gsub(
		"#X", wt.Thousands(
			speed[type].coords.x, f, true, not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.zeros
		)
	):gsub(
		"#Y", wt.Thousands(
			speed[type].coords.y, f, true, not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[type].value.zeros
		)
	)
end

--Update the Player Speed values
update.playerSpeed = function()
	local advanced, _, flightSpeed = C_PlayerInfo.GetGlidingInfo()
	local r = GetPlayerFacing() or 0
	speed.playerSpeed.yards = advanced and flightSpeed or GetUnitSpeed(UnitInVehicle("player") and "vehicle" or "player")
	speed.playerSpeed.percent = speed.playerSpeed.yards / BASE_MOVEMENT_SPEED * 100
	speed.playerSpeed.coords.x, speed.playerSpeed.coords.y = speed.playerSpeed.yards / (map.size.w / 100) * -math.sin(r), speed.playerSpeed.yards / (map.size.h / 100) * math.cos(r)

	--Hide when stationery
	if speed.playerSpeed.yards == 0 and MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.autoHide then
		frames.playerSpeed.display:Hide()

		return
	else frames.playerSpeed.display:Show() end

	--Update the display text
	frames.playerSpeed.text:SetText(" " .. GetSpeedText("playerSpeed"))
end

---Updates the Travel Speed values since the last sample
---@param deltaTime number Time since last update
update.travelSpeed = function(deltaTime)
	local currentPosition = map.id and C_Map.GetPlayerMapPosition(map.id, "player") or nil --NOTE: this generates a lot of memory garbage over time (that eventually gets collected). Using UnitPosition() produces less accurate calculation results.

	if currentPosition and pastPosition.x then
		local dX, dY, dT = pastPosition.x - currentPosition.x, pastPosition.y - currentPosition.y, max(deltaTime, 0.01)
		speed.travelSpeed.yards = math.sqrt((dX * map.size.w) ^ 2 + (dY * map.size.h) ^ 2) / dT
		speed.travelSpeed.percent = speed.travelSpeed.yards / BASE_MOVEMENT_SPEED * 100
		speed.travelSpeed.coords.x = dX * -100 / dT
		speed.travelSpeed.coords.y = dY * 100 / dT
	else
		speed.travelSpeed.yards = -1
		speed.travelSpeed.percent = -1
		speed.travelSpeed.coords.x, speed.travelSpeed.coords.y = -1, -1
	end

	if currentPosition then
		pastPosition:SetXY(currentPosition:GetXY())

		wipe(currentPosition)
	end

	--Hide when stationery
	if MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.travelSpeed.visibility.autoHide and speed.travelSpeed.yards == 0 then
		frames.travelSpeed.display:Hide()

		return
	else frames.travelSpeed.display:Show() end

	--Update the display text
	frames.travelSpeed.text:SetText(" " .. GetSpeedText("travelSpeed"):gsub("-1", not pastPosition.x and GetUnitSpeed("player") ~= 0 and "X" or "0"))
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
	if displayData.value.units[3] then ratio = ratio + 5.34 + 1.08 * max(displayData.value.fractionals, 1) end
	for i = 1, 3 do if displayData.value.units[i] then ratio = ratio + 0.2 end end --Separators

	--Resize the display
	display.display:SetSize(height * ratio * ns.fonts[GetFontID(displayData.font.family)].widthRatio - 4, height)
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

---Set the visibility, backdrop, font family, size and color of the specified speed display to the currently saved values
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
	display.text:SetFont(displayData.font.family, displayData.font.size, "OUTLINE")
	display.text:SetJustifyH(displayData.font.alignment)
	wt.SetPosition(display.text, { anchor = displayData.font.alignment, })
	display.text:SetTextColor(wt.UnpackColor(displayData.font.valueColoring and ns.colors.grey[2] or displayData.font.color))
end

--| Tooltip content

local playerSpeedTooltipLines, travelSpeedTooltipLines

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
			text = "\n" .. ns.strings.speedTooltip.text[3]:gsub(
				"#COORDS", wt.Color(ns.strings.speedValue.coordPair:gsub(
					"#X", wt.Thousands(speed.playerSpeed.coords.x, 2, true)
				):gsub(
					"#Y", wt.Thousands(speed.playerSpeed.coords.y, 2, true)
				), ns.colors.blue[2])
			),
			font = GameTooltipText,
			color = ns.colors.blue[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.mapTitle:gsub("#MAP", wt.Color(map.name, { r = 1, g = 1, b = 1 })),
			color = NORMAL_FONT_COLOR,
		},
		{
			text = ns.strings.speedTooltip.mapSize:gsub(
				"#SIZE", wt.Color(ns.strings.speedTooltip.mapSizeValues:gsub(
					"#W", wt.Color(wt.Thousands(map.size.w, 2), { r = 1, g = 1, b = 1 })
				):gsub(
					"#H", wt.Color(wt.Thousands(map.size.h, 2), { r = 1, g = 1, b = 1 })
				), ns.colors.grey[2])
			),
			color = NORMAL_FONT_COLOR,
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

--Assemble the detailed text lines for the tooltip of the Travel Speed display
local function GetTravelSpeedTooltipLines()
	travelSpeedTooltipLines = {
		{ text = ns.strings.speedTooltip.description },
		{ text = "\n" .. ns.strings.speedTooltip.travelSpeed, },
		{
			text = "\n" .. (not pastPosition.x and (ns.strings.speedTooltip.instanceError .. "\n\n") or "") ,
			font = GameTooltipText,
			color = { r = 0.92, g = 0.34, b = 0.23 },
		},
		{
			text = ns.strings.speedTooltip.text[1]:gsub(
				"#YARDS", wt.Color(wt.Thousands(speed.travelSpeed.yards, 2, true), ns.colors.yellow[2])
			):gsub("-1", not pastPosition.x and GetUnitSpeed("player") ~= 0 and "X" or "0"),
			font = GameTooltipText,
			color = ns.colors.yellow[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.text[2]:gsub(
				"#PERCENT", wt.Color(wt.Thousands(speed.travelSpeed.percent, 2, true) .. "%%", ns.colors.green[2])
			):gsub("-1", not pastPosition.x and GetUnitSpeed("player") ~= 0 and "X" or "0"),
			font = GameTooltipText,
			color = ns.colors.green[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.text[3]:gsub(
				"#COORDS", wt.Color(ns.strings.speedValue.coordPair:gsub(
					"#X", wt.Thousands(speed.travelSpeed.coords.x, 2, true)
				):gsub(
					"#Y", wt.Thousands(speed.travelSpeed.coords.y, 2, true)
				), ns.colors.blue[2])
			):gsub("-1", not pastPosition.x and GetUnitSpeed("player") ~= 0 and "X" or "0"),
			font = GameTooltipText,
			color = ns.colors.blue[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.mapTitle:gsub("#MAP", wt.Color(map.name, { r = 1, g = 1, b = 1 })),
			color = NORMAL_FONT_COLOR,
		},
		{
			text = ns.strings.speedTooltip.mapSize:gsub(
				"#SIZE", wt.Color(ns.strings.speedTooltip.mapSizeValues:gsub(
					"#W", wt.Color(wt.Thousands(map.size.w, 2), { r = 1, g = 1, b = 1 })
				):gsub(
					"#H", wt.Color(wt.Thousands(map.size.h, 2), { r = 1, g = 1, b = 1 })
				), ns.colors.grey[2])
			),
			color = NORMAL_FONT_COLOR,
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

	return travelSpeedTooltipLines
end

--| Toggle updates

---Start updating the specified speed display
---@param display displayType
local function StartSpeedDisplayUpdates(display)
	--Update the speed values at start
	update[display](timeSinceSpeedUpdate[display])

	--| Repeated updates

	frames[display].updater:SetScript("OnUpdate", function(_, deltaTime) if MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].update.throttle then
		timeSinceSpeedUpdate[display] = timeSinceSpeedUpdate[display] + deltaTime

		if timeSinceSpeedUpdate[display] < MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].update.frequency then return else
			update[display](timeSinceSpeedUpdate[display])

			timeSinceSpeedUpdate[display] = 0
		end
	else update[display](deltaTime) end end)
end

---Stop updating the specified speed display
---@param display displayType
local function StopSpeedDisplayUpdates(display)
	frames[display].updater:SetScript("OnUpdate", nil)
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
			speed.targetSpeed.coords.x, speed.targetSpeed.coords.y = speed.targetSpeed.yards / (map.size.w / 100), speed.targetSpeed.yards / (map.size.h / 100)

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

for i = 1, #ns.strings.options.speedValue.units.list do
	valueTypes[i] = {}
	valueTypes[i].title = ns.strings.options.speedValue.units.list[i].label
	valueTypes[i].tooltip = { lines = { { text = ns.strings.options.speedValue.units.list[i].tooltip, }, } }
end

--[ Speed Display ]

--Create the widgets
local function CreateVisibilityOptions(panel, display, category, key)
	---@type toggle|checkbox
	options[display].visibility.hidden = wt.CreateCheckbox({
		parent = panel,
		name = "Hidden",
		title = ns.strings.options.speedDisplay.visibility.hidden.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.hidden.tooltip:gsub("#ADDON", ns.title), }, } },
		arrange = {},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].visibility.hidden end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].visibility.hidden = state end,
		default = ns.profileDefault[display].visibility.hidden,
		dataManagement = {
			category = category,
			key = key,
			onChange = { DisplayToggle = function()
				wt.SetVisibility(frames[display].display, not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].visibility.hidden)
				if MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].visibility.hidden then StopSpeedDisplayUpdates(display)
				else StartSpeedDisplayUpdates(display) end
			end, },
		},
	})

	---@type toggle|checkbox
	options[display].visibility.autoHide = wt.CreateCheckbox({
		parent = panel,
		name = "AutoHide",
		title = ns.strings.options.speedDisplay.visibility.autoHide.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.autoHide.tooltip, }, } },
		arrange = { newRow = false, },
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].visibility.autoHide end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].visibility.autoHide = state end,
		default = ns.profileDefault[display].visibility.autoHide,
		dataManagement = {
			category = category,
			key = key,
		},
	})

	---@type toggle|checkbox
	options[display].visibility.status = wt.CreateCheckbox({
		parent = panel,
		name = "StatusNotice",
		title = ns.strings.options.speedDisplay.visibility.statusNotice.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.statusNotice.tooltip, }, } },
		arrange = { newRow = false, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].visibility.statusNotice end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].visibility.statusNotice = state end,
		default = ns.profileDefault[display].visibility.statusNotice,
		dataManagement = {
			category = category,
			key = key,
		},
	})
end
local function CreateUpdateOptions(panel, display, category, key)
	---@type toggle|checkbox
	options[display].update.throttle = wt.CreateCheckbox({
		parent = panel,
		name = "Throttle",
		title = ns.strings.options.speedDisplay.update.throttle.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.throttle.tooltip, }, } },
		arrange = {},
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].update.throttle end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].update.throttle = state end,
		default = ns.profileDefault[display].update.throttle,
		dataManagement = {
			category = category,
			key = key,
			-- onChange = { RefreshSpeedUpdates = function() --CHECK if needed
			-- 	StopSpeedDisplayUpdates(display)
			-- 	StartSpeedDisplayUpdates(display)
			-- end },
		},
	})

	---@type numeric|numericSlider
	options[display].update.frequency = wt.CreateNumericSlider({
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
			{ frame = options[display].visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options[display].update.throttle },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].update.frequency end,
		saveData = function(value) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].update.frequency = wt.Round(value, 2) end,
		default = ns.profileDefault[display].update.frequency,
		dataManagement = {
			category = category,
			key = key,
			-- onChange = { "RefreshSpeedUpdates", }, --CHECK if needed
		},
	})
end
local function CreateSpeedValueOptions(panel, display, category, key)
	---@type checkboxSelector|multiselector
	options[display].value.units = wt.CreateCheckboxSelector({
		parent = panel,
		name = "Units",
		title = ns.strings.options.speedValue.units.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.units.tooltip, }, } },
		arrange = {},
		items = valueTypes,
		limits = { min = 1, },
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].value.units end,
		saveData = function(selections) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].value.units = selections end,
		default = ns.profileDefault[display].value.units,
		dataManagement = {
			category = category,
			key = key,
			onChange = {
				UpdateDisplaySize = function() SetDisplaySize(frames[display], MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display]) end,
				UpdateSpeedTextTemplate = function() FormatSpeedText(display, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].value.units, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.valueColoring) end,
			},
		},
	})

	---@type numeric|numericSlider
	options[display].value.fractionals = wt.CreateNumericSlider({
		parent = panel,
		name = "Fractionals",
		title = ns.strings.options.speedValue.fractionals.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.fractionals.tooltip, }, } },
		arrange = { newRow = false, },
		min = 0,
		max = 4,
		increment = 1,
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].value.fractionals end,
		saveData = function(value) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].value.fractionals = value end,
		default = ns.profileDefault[display].value.fractionals,
		dataManagement = {
			category = category,
			key = key,
			onChange = { "UpdateDisplaySize", },
		},
	})

	---@type toggle|checkbox
	options[display].value.zeros = wt.CreateCheckbox({
		parent = panel,
		name = "Zeros",
		title = ns.strings.options.speedValue.zeros.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.zeros.tooltip, }, } },
		arrange = { newRow = false, },
		autoOffset = true,
		dependencies = {
			{ frame = options[display].visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options[display].value.fractionals, evaluate = function(value) return value > 0 end },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].value.zeros end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].value.zeros = state end,
		default = ns.profileDefault[display].value.zeros,
		dataManagement = {
			category = category,
			key = key,
		},
	})
end
local function CreateFontOptions(panel, display, category, key)

	--| Font family

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
	options[display].font.family = wt.CreateDropdownSelector({
		parent = panel,
		name = "Family",
		title = ns.strings.options.speedDisplay.font.family.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.family.tooltip, }, } },
		arrange = {},
		items = fontItems,
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return GetFontID(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.family) end,
		saveData = function(selected) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.family = ns.fonts[selected or 1].path end,
		default = GetFontID(ns.profileDefault[display].font.family),
		dataManagement = {
			category = category,
			key = key,
			onChange = {
				UpdateDisplayFont = function() frames[display].text:SetFont(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.family, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.size, "OUTLINE") end,
				"UpdateDisplaySize",
				RefreshDisplayText = function() --WATCH if the text still needs to be refreshed so the font will be applied right away (if the font is loaded)
					local text = frames[display].text:GetText()
					frames[display].text:SetText("")
					frames[display].text:SetText(text)
				end,
				UpdateFontFamilyDropdownText = not WidgetToolsDB.lite and function()
					--Update the font of the dropdown toggle button label
					local _, size, flags = options[display].font.family.toggle.label:GetFont()
					options[display].font.family.toggle.label:SetFont(ns.fonts[options[display].font.family.getSelected() or 1].path, size, flags)

					--Refresh the text so the font will be applied right away (if the font is loaded)
					local text = options[display].font.family.toggle.label:GetText()
					options[display].font.family.toggle.label:SetText("")
					options[display].font.family.toggle.label:SetText(text)
				end or nil,
			},
		},
	})

	--Update the font of the dropdown items
	if options[display].font.family.frame then for i = 1, #options[display].font.family.toggles do if options[display].font.family.toggles[i].label then
		local _, size, flags = options[display].font.family.toggles[i].label:GetFont()
		options[display].font.family.toggles[i].label:SetFont(ns.fonts[i].path, size, flags)
	end end end

	--| Font size

	---@type numeric|numericSlider
	options[display].font.size = wt.CreateNumericSlider({
		parent = panel,
		name = "Size",
		title = ns.strings.options.speedDisplay.font.size.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.size.tooltip, }, } },
		arrange = { newRow = false, },
		min = 8,
		max = 64,
		increment = 1,
		altStep = 3,
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.size end,
		saveData = function(value) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.size = value end,
		default = ns.profileDefault[display].font.size,
		dataManagement = {
			category = category,
			key = key,
			onChange = {
				"UpdateDisplayFont",
				"UpdateDisplaySize",
			},
		},
	})

	--| Alignment

	---@type specialSelector|specialRadioSelector
	options[display].font.alignment = wt.CreateSpecialRadioSelector("justifyH", {
		parent = panel,
		name = "Alignment",
		title = ns.strings.options.speedDisplay.font.alignment.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.alignment.tooltip, }, } },
		arrange = { newRow = false, },
		width = 140,
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.alignment end,
		saveData = function(value) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.alignment = value end,
		default = ns.profileDefault[display].font.alignment,
		dataManagement = {
			category = category,
			key = key,
			onChange = { UpdateDisplayTextAlignment = function()
				frames[display].text:SetJustifyH(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.alignment)
				wt.SetPosition(frames[display].text, { anchor = MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.alignment, })
			end, },
		},
	})

	--| Value coloring

	---@type toggle|checkbox
	options[display].font.valueColoring = wt.CreateCheckbox({
		parent = panel,
		name = "ValueColoring",
		title = ns.strings.options.speedDisplay.font.valueColoring.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.valueColoring.tooltip:gsub("#ADDON", ns.title), }, } },
		arrange = {},
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.valueColoring end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.valueColoring = state end,
		default = ns.profileDefault[display].font.valueColoring,
		dataManagement = {
			category = category,
			key = key,
			onChange = {
				UpdateDisplayFontColor = function() frames[display].text:SetTextColor(wt.UnpackColor(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.valueColoring and ns.colors.grey[2] or MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.color)) end,
				UpdateEmbeddedValueColoring = function()
					if MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.valueColoring then
						FormatSpeedText(display, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].value.units, true)
					else speedText[display] = wt.Clear(speedText[display]) end
				end,
			},
		},
	})

	--| Font color

	---@type colorPicker|colorPickerFrame
	options[display].font.color = wt.CreateColorPickerFrame({
		parent = panel,
		name = "Color",
		title = ns.strings.options.speedDisplay.font.color.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.color.tooltip, }, } },
		arrange = { newRow = false, },
		dependencies = {
			{ frame = options[display].visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options[display].font.valueColoring, evaluate = function(state) return not state end },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.color end,
		saveData = function(color) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font.color = color end,
		default = ns.profileDefault[display].font.color,
		dataManagement = {
			category = category,
			key = key,
			onChange = { "UpdateDisplayFontColor", },
		},
	})
end
local function CreateBackgroundOptions(panel, display, category, key)
	---@type toggle|checkbox
	options[display].background.visible = wt.CreateCheckbox({
		parent = panel,
		name = "Visible",
		title = ns.strings.options.speedDisplay.background.visible.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.background.visible.tooltip, }, } },
		arrange = {},
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].background.visible end,
		saveData = function(state) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].background.visible = state end,
		default = ns.profileDefault[display].background.visible,
		dataManagement = {
			category = category,
			key = key,
			onChange = { ToggleDisplayBackdrops = function() SetDisplayBackdrop(frames[display], MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].background) end, },
		},
	})

	---@type colorPicker|colorPickerFrame
	options[display].background.colors.bg = wt.CreateColorPickerFrame({
		parent = panel,
		name = "Color",
		title = ns.strings.options.speedDisplay.background.colors.bg.label,
		tooltip = {},
		arrange = { newRow = false, },
		dependencies = {
			{ frame = options[display].visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options[display].background.visible, },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].background.colors.bg end,
		saveData = function(color) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].background.colors.bg = color end,
		default = ns.profileDefault[display].background.colors.bg,
		dataManagement = {
			category = category,
			key = key,
			onChange = { UpdateDisplayBackgroundColor = function() if frames[display].display:GetBackdrop() ~= nil then
				frames[display].display:SetBackdropColor(wt.UnpackColor(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].background.colors.bg))
			end end },
		},
	})

	---@type colorPicker|colorPickerFrame
	options[display].background.colors.border = wt.CreateColorPickerFrame({
		parent = panel,
		name = "BorderColor",
		title = ns.strings.options.speedDisplay.background.colors.border.label,
		tooltip = {},
		arrange = { newRow = false, },
		dependencies = {
			{ frame = options[display].visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options[display].background.visible, },
		},
		getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].background.colors.border end,
		saveData = function(color) MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].background.colors.border = color end,
		default = ns.profileDefault[display].background.colors.border,
		dataManagement = {
			category = category,
			key = key,
			onChange = { UpdateDisplayBorderColor = function() if frames[display].display:GetBackdrop() ~= nil then
				frames[display].display:SetBackdropBorderColor(wt.UnpackColor(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].background.colors.border))
			end end },
		},
	})
end

---Create the category page
---@param display displayType
---@return settingsPage
local function CreateSpeedDisplayOptionsPage(display)
	local displayName = ns.strings.options[display].title:gsub("%s+", "")
	local otherDisplay = display == "playerSpeed" and "travelSpeed" or "playerSpeed"
	---@type customButtonCreationData
	local copyButtonData = {
		name = "Copy",
		title =  ns.strings.options.speedDisplay.copy.label:gsub("#TYPE", ns.strings.options[otherDisplay].title),
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.copy.tooltip:gsub("#TYPE", ns.strings.options[otherDisplay].title), }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -6, y = 30 }
		},
		size = { w = 166, },
		font = {
			normal = "GameFontHighlightSmall",
			highlight = "GameFontHighlightSmall",
			disabled = "GameFontDisableSmall"
		},
		backdrop = {
			background = {
				texture = {
					size = 5,
					insets = { l = 3, r = 3, t = 3, b = 3 },
				},
				color = { r = 0.1, g = 0.1, b = 0.1, a = 0.9 },
			},
			border = {
				texture = { width = 12, },
				color = { r = 0.5, g = 0.5, b = 0.5, a = 0.9 },
			}
		},
		backdropUpdates = {
			OnEnter = { rule = function()
				return IsMouseButtonDown() and {
					background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
					border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
				} or {
					background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				}
			end },
			OnLeave = { rule = function() return {}, true end },
			OnMouseDown = { rule = function(self)
				return self:IsEnabled() and {
					background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
					border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
				} or {}
			end },
			OnMouseUp = { rule = function(self)
				return self:IsEnabled() and self:IsMouseOver() and {
					background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
					border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
				} or {}
			end },
		},
	}

	---@type settingsPage|nil
	options[display].page = wt.CreateSettingsPage(ns.name, {
		name = displayName,
		title = ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options[display].title),
		description = ns.strings.options[display].description:gsub("#ADDON", ns.title),
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
		onDefault = function(_, category)
			chatCommands.print(ns.strings.chat.default.responseCategory:gsub(
				"#CATEGORY", wt.Color(ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options[display].title), ns.colors.yellow[2])
			):gsub(
				"#PROFILE", wt.Color(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].title, ns.colors.yellow[2])
			))

			if not category or display == "playerSpeed" then options[display].position.resetCustomPreset() else options[display].position.applyPreset(1) end
			if display == "travelSpeed" then options.travelSpeed.visibility.hidden.setState(true, true) end
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
				initialize = function(panel, _, _, key)
					CreateVisibilityOptions(panel, display, category, key)

					wt.CreateCustomButton(wt.AddMissing({
						parent = panel,
						action = function()
							wt.CopyValues(
								MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].visibility,
								MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[otherDisplay].visibility
							)
							wt.LoadSettingsData(category, key, true)
						end,
						dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
					}, copyButtonData))
				end,
			})

			--[ Position ]

			---@type positionPanel|nil
			options[display].position = wt.CreatePositionOptions(ns.name, {
				canvas = canvas,
				frame = frames[display].display,
				frameName = ns.strings.options.speedDisplay.referenceName:gsub("#TYPE", ns.strings.options[display].title),
				presets = {
					items = {
						{
							title = ns.strings.misc.custom, --Custom
							onSelect = function() options[display].position.presetList[1].data.position.relativePoint = options[display].position.presetList[1].data.position.anchor end,
						},
						{
							title = ns.strings.presets[1], --Under the Minimap
							data = {
								position = {
									anchor = "TOP",
									relativeTo = MinimapBackdrop,
									relativePoint = "BOTTOM",
									offset = { y = -2 }
								},
								keepInBounds = true,
								layer = {
									strata = "MEDIUM",
									keepOnTop = false,
								},
							},
						},
						{
							title = ns.strings.presets[2]:gsub("#TYPE", ns.strings.options[otherDisplay].title), --Under the other display
							data = {
								position = {
									anchor = "TOP",
									relativeTo = frames[otherDisplay].display,
									relativePoint = "BOTTOM",
									offset = { y = -2 }
								},
								keepInBounds = true,
								layer = {
									strata = "MEDIUM",
									keepOnTop = false,
								},
							},
						},
						{
							title = ns.strings.presets[3]:gsub("#TYPE", ns.strings.options[otherDisplay].title), --Above the other display
							data = {
								position = {
									anchor = "BOTTOM",
									relativeTo = frames[otherDisplay].display,
									relativePoint = "TOP",
									offset = { y = 2 }
								},
								keepInBounds = true,
								layer = {
									strata = "MEDIUM",
									keepOnTop = false,
								},
							},
						},
						{
							title = ns.strings.presets[4]:gsub("#TYPE", ns.strings.options[otherDisplay].title), --Right of the other display
							data = {
								position = {
									anchor = "LEFT",
									relativeTo = frames[otherDisplay].display,
									relativePoint = "RIGHT",
									offset = { x = 2, }
								},
								keepInBounds = true,
								layer = {
									strata = "MEDIUM",
									keepOnTop = false,
								},
							},
						},
						{
							title = ns.strings.presets[5]:gsub("#TYPE", ns.strings.options[otherDisplay].title), --Left of the other display
							data = {
								position = {
									anchor = "RIGHT",
									relativeTo = frames[otherDisplay].display,
									relativePoint = "LEFT",
									offset = { x = -2, }
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
						options[display].visibility.hidden.setData(false)

						chatCommands.print(ns.strings.chat.preset.response:gsub(
							"#PRESET", wt.Color(options[display].position.presetList[i].title, ns.colors.yellow[2])
						):gsub(
							"#TYPE", ns.strings.options[display].title
						))
					end,
					custom = {
						getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.customPreset end,
						defaultsTable = ns.profileDefault.customPreset,
						onSave = function()
							chatCommands.print(ns.strings.chat.save.response:gsub(
								"#TYPE", ns.strings.options[display].title
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
						"#TYPE", ns.strings.options[display].title
					)) end,
					onCancel = function()
						chatCommands.print(ns.strings.chat.position.cancel:gsub(
							"#TYPE", ns.strings.options[display].title
						))
						print(wt.Color(ns.strings.chat.position.error, ns.colors.yellow[2]))
					end,
				}, },
				dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
				getData = function() return MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display] end,
				defaultsTable = ns.profileDefault[display],
				settingsData = MovementSpeedCS[display],
				dataManagement = { category = ns.name .. displayName, },
			})

			if options[display].position.frame.description then options[display].position.frame.description:SetWidth(328) end

			wt.CreateCustomButton(wt.AddMissing({
				parent = options[display].position.frame,
				action = function()
					wt.CopyValues(
						MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].position,
						MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[otherDisplay].position
					)
					wt.LoadSettingsData(category, keys[5], true)
				end,
				dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
			}, copyButtonData))

			--[ Updates ]

			wt.CreatePanel({
				parent = canvas,
				name = keys[4],
				title = ns.strings.options.speedDisplay.update.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel, _, _, key)
					CreateUpdateOptions(panel, display, category, key)

					wt.CreateCustomButton(wt.AddMissing({
						parent = panel,
						action = function()
							wt.CopyValues(
								MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].update,
								MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[otherDisplay].update
							)
							wt.LoadSettingsData(category, key, true)
						end,
						dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
					}, copyButtonData))
				end,
			})

			--[ Value ]

			wt.CreatePanel({
				parent = canvas,
				name = keys[3],
				title = ns.strings.options.speedValue.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel, _, _, key)
					CreateSpeedValueOptions(panel, display, category, key)

					wt.CreateCustomButton(wt.AddMissing({
						parent = panel,
						action = function()
							wt.CopyValues(
								MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].value,
								MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[otherDisplay].value
							)
							wt.LoadSettingsData(category, key, true)
						end,
						dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
					}, copyButtonData))
				end,
			})

			--[ Font ]

			wt.CreatePanel({
				parent = canvas,
				name = keys[1],
				title = ns.strings.options.speedDisplay.font.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel, _, _, key)
					CreateFontOptions(panel, display, category, key)

					wt.CreateCustomButton(wt.AddMissing({
						parent = panel,
						action = function()
							wt.CopyValues(
								MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].font,
								MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[otherDisplay].font
							)
							wt.LoadSettingsData(category, key, true)
						end,
						dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
					}, copyButtonData))
				end,
			})

			--[ Background ]

			wt.CreatePanel({
				parent = canvas,
				name = keys[2],
				title = ns.strings.options.speedDisplay.background.title,
				arrange = {},
				arrangement = {},
				initialize = function(panel, _, _, key)
					CreateBackgroundOptions(panel, display, category, key)

					wt.CreateCustomButton(wt.AddMissing({
						parent = panel,
						action = function()
							wt.CopyValues(
								MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[display].background,
								MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[otherDisplay].background
							)
							wt.LoadSettingsData(category, key, true)
						end,
						dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
					}, copyButtonData))
				end,
			})
		end,
	})

	return options[display].page
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

local firstLoad, newCharacter

--Custom Tooltip
ns.tooltip = wt.CreateGameTooltip(ns.name)

---Set up the speed display context menu
---@param display displayType
local function CreateContextMenu(display) wt.CreateContextMenu({
	triggers = { { frame = frames[display].display, }, },
	initialize = function(menu)
		wt.CreateMenuTextline(menu, { text = ns.title, })
		wt.CreateSubmenu(menu, { title = ns.strings.misc.options, initialize = function(optionsMenu)
			wt.CreateMenuButton(optionsMenu, {
				title = wt.GetStrings("about").title,
				tooltip = { lines = { { text = ns.strings.options.main.description:gsub("#ADDON", ns.title), }, } },
				action = options.about.page.open,
			})
			wt.CreateMenuButton(optionsMenu, {
				title = ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options.playerSpeed.title),
				tooltip = { lines = { { text = ns.strings.options.playerSpeed.description, }, } },
				action = options.playerSpeed.page.open,
			})
			wt.CreateMenuButton(optionsMenu, {
				title = ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options.travelSpeed.title),
				tooltip = { lines = { { text = ns.strings.options.travelSpeed.description:gsub("#ADDON", ns.title), }, } },
				action = options.travelSpeed.page.open,
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
			for i = 1, #options[display].position.presetList do wt.CreateMenuButton(presetsMenu, {
				title = options[display].position.presetList[i].title,
				action = function() options[display].position.applyPreset(i) end,
			}) end
		end })
	end
}) end

--Create main addon frame & displays
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
			MovementSpeedCS = wt.AddMissing(MovementSpeedCS or {}, {
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
				} end,
				onProfileActivated = function(title)
					--Update the interface options
					options.playerSpeed.page.load(true)
					options.travelSpeed.page.load(true)
					options.targetSpeed.page.load(true)
					options.dataManagement.page.load(true)

					chatCommands.print(ns.strings.chat.profile.response:gsub("#PROFILE", wt.Color(title, ns.colors.yellow[2])))
				end,
				onProfileDeleted = function(title) chatCommands.print(ns.strings.chat.default.response:gsub("#PROFILE", wt.Color(title, ns.colors.yellow[2]))) end,
				onProfileReset = function(title) chatCommands.print(ns.strings.chat.default.response:gsub("#PROFILE", wt.Color(title, ns.colors.yellow[2]))) end,
				onImport = function(success) if success then
					--Update the interface options
					options.playerSpeed.page.load(true)
					options.travelSpeed.page.load(true)
					options.targetSpeed.page.load(true)
					options.dataManagement.page.load(true)
				else chatCommands.print(wt.GetStrings("backup").error) end end,
				onImportAllProfiles = function(success) if not success then chatCommands.print(wt.GetStrings("backup").error) end end,
			})

			--[ Settings Setup ]

			options.about.page = wt.CreateAboutPage(ns.name, {
				name = "Main",
				description = ns.strings.options.main.description:gsub("#ADDON", ns.title),
				changelog = ns.changelog
			})

			options.pageManager = wt.CreateSettingsCategory(ns.name, options.about.page, {
				CreateSpeedDisplayOptionsPage("playerSpeed"),
				CreateSpeedDisplayOptionsPage("travelSpeed"),
				CreateTargetSpeedOptionsPage(),
				options.dataManagement.page
			})

			--[ Chat Control Setup ]

			chatCommands = wt.RegisterChatCommands(ns.name, ns.chat.keywords, {
				commands = {
					{
						command = ns.chat.commands.options,
						description = ns.strings.chat.options.description:gsub("#ADDON", ns.title),
						handler = options.about.page.open,
					},
					{
						command = ns.chat.commands.preset,
						description = function()
							return ns.strings.chat.preset.description:gsub(
								"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
							):gsub(
								"#INDEX", wt.Color(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])
							)
						end,
						handler = function(_, p) return options[MovementSpeedCS.mainDisplay].position.applyPreset(tonumber(p)) end,
						error = ns.strings.chat.preset.unchanged .. "\n" .. wt.Color(ns.strings.chat.preset.error:gsub(
							"#INDEX", wt.Color(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])
						), ns.colors.yellow[2]),
						onError = function()
							print(wt.Color(ns.strings.chat.preset.list, ns.colors.yellow[1]))
							for i = 1, #options[MovementSpeedCS.mainDisplay].position.presetList, 2 do
								local list = "    " .. wt.Color(i, ns.colors.green[2]) .. wt.Color(" • " .. options[MovementSpeedCS.mainDisplay].position.presetList[i].title, ns.colors.yellow[2])

								if i + 1 <= #options[MovementSpeedCS.mainDisplay].position.presetList then
									list = list .. "    " .. wt.Color(i + 1, ns.colors.green[2]) .. wt.Color(" • " .. options[MovementSpeedCS.mainDisplay].position.presetList[i + 1].title, ns.colors.yellow[2])
								end

								print(list)
							end
						end,
					},
					{
						command = ns.chat.commands.save,
						description = function()
							return ns.strings.chat.save.description:gsub(
								"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
							):gsub(
								"#CUSTOM", wt.Color(options[MovementSpeedCS.mainDisplay].position.presetList[1].title, ns.colors.yellow[1])
							)
						end,
						handler = function() options[MovementSpeedCS.mainDisplay].position.saveCustomPreset() end,
					},
					{
						command = ns.chat.commands.reset,
						description = function()
							return ns.strings.chat.reset.description:gsub(
								"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
							):gsub(
								"#CUSTOM", wt.Color(options[MovementSpeedCS.mainDisplay].position.presetList[1].title, ns.colors.yellow[1])
							)
						end,
						handler = function() options[MovementSpeedCS.mainDisplay].position.resetCustomPreset() end,
					},
					{
						command = ns.chat.commands.toggle,
						description = function() return ns.strings.chat.toggle.description:gsub("#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title):gsub(
							"#HIDDEN", wt.Color(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[MovementSpeedCS.mainDisplay].visibility.hidden and ns.strings.chat.toggle.hidden or ns.strings.chat.toggle.notHidden, ns.colors.yellow[1])
						) end,
						handler = function()
							options[MovementSpeedCS.mainDisplay].visibility.hidden.setData(not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[MovementSpeedCS.mainDisplay].visibility.hidden)

							return true
						end,
						success = function() return (MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[MovementSpeedCS.mainDisplay].visibility.hidden and ns.strings.chat.toggle.hiding or ns.strings.chat.toggle.unhiding):gsub(
							"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
						) end,
					},
					{
						command = ns.chat.commands.auto,
						description = function() return ns.strings.chat.auto.description:gsub("#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title):gsub(
							"#STATE", wt.Color(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[MovementSpeedCS.mainDisplay].visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[1])
						) end,
						handler = function()
							options[MovementSpeedCS.mainDisplay].visibility.autoHide.setData(not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[MovementSpeedCS.mainDisplay].visibility.autoHide)

							return true
						end,
						success = function()
							return ns.strings.chat.auto.response:gsub(
								"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
							):gsub(
								"#STATE", wt.Color(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data[MovementSpeedCS.mainDisplay].visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[2])
							)
						end,
					},
					{
						command = ns.chat.commands.size,
						description = function()
							return ns.strings.chat.size.description:gsub(
								"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
							):gsub(
								"#SIZE", wt.Color(ns.chat.commands.size .. " " .. ns.profileDefault[MovementSpeedCS.mainDisplay].font.size, ns.colors.green[2])
							)
						end,
						handler = function(_, p)
							local size = tonumber(p)

							if not size then return false end

							options[MovementSpeedCS.mainDisplay].font.size.setData(size)

							return true, size
						end,
						success = function(size) return ns.strings.chat.size.response:gsub(
							"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
						):gsub("#VALUE", wt.Color(size, ns.colors.yellow[2])) end,
						error = function() return ns.strings.chat.size.unchanged:gsub(
							"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
						) end,
						onError = function() print("    " .. wt.Color(ns.strings.chat.size.error:gsub(
							"#SIZE", wt.Color(ns.chat.commands.size .. " " .. ns.profileDefault[MovementSpeedCS.mainDisplay].font.size, ns.colors.green[2])
						), ns.colors.yellow[2])) end,
					},
					{
						command = ns.chat.commands.swap,
						description = function() return ns.strings.chat.swap.description:gsub(
							"#ACTIVE", wt.Color(ns.strings.options[MovementSpeedCS.mainDisplay].title, ns.colors.yellow[1])
						) end,
						handler = function()
							MovementSpeedCS.mainDisplay = MovementSpeedCS.mainDisplay == "playerSpeed" and "travelSpeed" or "playerSpeed"

							return true
						end,
						success = function() return ns.strings.chat.swap.response:gsub(
							"#ACTIVE", wt.Color(ns.strings.options[MovementSpeedCS.mainDisplay].title, ns.colors.yellow[2])
						) end,
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

			--Player Speed
			CreateContextMenu("playerSpeed")
			wt.SetPosition(frames.playerSpeed.display, wt.AddMissing({ relativePoint = MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.position.anchor, }, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.position))
			wt.ConvertToAbsolutePosition(frames.playerSpeed.display)
			SetDisplayValues(frames.playerSpeed, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed)

			--Travel Speed
			CreateContextMenu("travelSpeed")
			wt.SetPosition(frames.travelSpeed.display, wt.AddMissing({ relativePoint = MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.travelSpeed.position.anchor, }, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.travelSpeed.position))
			wt.ConvertToAbsolutePosition(frames.travelSpeed.display)
			SetDisplayValues(frames.travelSpeed, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.travelSpeed)
		end,
		PLAYER_ENTERING_WORLD = function(self)
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")

			UpdateMapInfo()

			FormatSpeedText("playerSpeed", MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.value.units, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.font.valueColoring)
			FormatSpeedText("travelSpeed", MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.travelSpeed.value.units, MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.travelSpeed.font.valueColoring)
			FormatSpeedText("targetSpeed", MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.value.units, true)

			--Start speed updates
			if not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden then StartSpeedDisplayUpdates("playerSpeed") end
			if not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.travelSpeed.visibility.hidden then StartSpeedDisplayUpdates("travelSpeed") end
			if MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.targetSpeed.enabled then EnableTargetSpeedUpdates() end

			--Finish loading the active profile for new characters
			if newCharacter then
				--Update the interface options
				options.playerSpeed.page.load(true)
				options.travelSpeed.page.load(true)
				options.targetSpeed.page.load(true)
				options.dataManagement.page.load(true)

				chatCommands.print(ns.strings.chat.profile.response:gsub("#PROFILE", wt.Color(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].title, ns.colors.yellow[2])))
			end

			--Visibility notice
			if not frames.playerSpeed.display:IsVisible() and MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.statusNotice then
				PrintStatus("playerSpeed")
			end
			if not frames.travelSpeed.display:IsVisible() and MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.travelSpeed.visibility.statusNotice then
				PrintStatus("travelSpeed")
			end
		end,
		ZONE_CHANGED_NEW_AREA = function() UpdateMapInfo() end,
		PET_BATTLE_OPENING_START = function(self) self:Hide() end,
		PET_BATTLE_CLOSE = function(self) self:Show() end,
	},
	events = {
		OnShow = function()
			if not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.playerSpeed.visibility.hidden then frames.playerSpeed.display:Show() end
			if not MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data.travelSpeed.visibility.hidden then frames.travelSpeed.display:Show() end
		end,
		OnHide = function()
			frames.playerSpeed.display:Hide()
			frames.travelSpeed.display:Hide()
		end
	},
	initialize = function(frame, _, _, name)

		--| Player Speed

		frames.playerSpeed.display = wt.CreateFrame({
			parent = UIParent,
			name = name .. "PlayerSpeed",
			customizable = true,
			events = { OnUpdate = function(self)
				--Update the tooltip
				if self:IsMouseOver() and ns.tooltip:IsVisible() then wt.UpdateTooltip(self, { lines = GetPlayerSpeedTooltipLines(), }) end
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

		--| Travel Speed

		frames.travelSpeed.display = wt.CreateFrame({
			parent = UIParent,
			name = name .. "TravelSpeed",
			customizable = true,
			events = { OnUpdate = function(self)
				--Update the tooltip
				if self:IsMouseOver() and ns.tooltip:IsVisible() then wt.UpdateTooltip(self, { lines = GetTravelSpeedTooltipLines(), }) end
			end, },
			initialize = function(display, _ , height)
				--Tooltip
				wt.AddTooltip(display, {
					tooltip = ns.tooltip,
					title = ns.strings.speedTooltip.title:gsub("#SPEED", ns.strings.options.travelSpeed.title),
					anchor = "ANCHOR_BOTTOMRIGHT",
					offset = { y = height },
					flipColors = true
				})

				--Speed text
				frames.travelSpeed.text = wt.CreateText({
					parent = display,
					layer = "OVERLAY",
					wrap = false,
				})
			end
		})

		frames.travelSpeed.updater = wt.CreateFrame({
			parent = frame,
			name = "TravelSpeedUpdater",
		})

		--| Target Speed

		frames.targetSpeed = wt.CreateFrame({
			parent = frame,
			name = "TargetSpeedUpdater",
		})
	end
})