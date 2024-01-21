--[[ RESOURCES ]]

---@class MovementSpeedNamespace
local ns = select(2, ...)

---@class wt
local wt = ns.WidgetToolbox

--Addon title
local addonTitle = wt.Clear(select(2, GetAddOnInfo(ns.name))):gsub("^%s*(.-)%s*$", "%1")
local addonChat = wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " "

--Custom Tooltip
ns.tooltip = wt.CreateGameTooltip(ns.name)

--Database tables
local s --Profile data storage table reference
local d = {} --Active profile data table

--[ References ]

--Local frames
local frames = {
	playerSpeed = {},
	travelSpeed = {},
}

--Options frames & utilities
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

--Speed values
local speed = {
	player = {
		yards = 0,
		coords = { x = 0, y = 0 }
	},
	travel = {
		yards = 0,
		coords = { x = 0, y = 0 }
	},
	target = {
		yards = 0,
		coords = { x = 0, y = 0 }
	}
}

--Map info
local map = { size = {} }

--Player position at the last Travel Speed update
local pastPosition

--System time of the last Travel Speed update
local lastTime = 0

--Speed text templates
local speedText = {}


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
		["speedDisplay.value.units"] = { saveTo = { data.playerSpeed.value, data.travelSpeed.value, }, saveKey = "units", },
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

--[ Speed Update ]

--Get the current Player Speed values accessible through **speed**
local function UpdatePlayerSpeed()
	local dragonriding, _, flightSpeed = C_PlayerInfo.GetGlidingInfo()
	speed.player.yards = dragonriding and flightSpeed or GetUnitSpeed(UnitInVehicle("player") and "vehicle" or "player")
	speed.player.coords.x, speed.player.coords.y = speed.player.yards / (map.size.w / 100), speed.player.yards / (map.size.h / 100)
end

--Updates the current Travel Speed since the last sample accessible through **speed**
local function UpdateTravelSpeed()
	local time = GetTime()
	local delta = time - lastTime
	delta = delta < 0.05 and 1 or delta
	local currentPosition = map.id and C_Map.GetPlayerMapPosition(map.id, "player") or nil

	if (pastPosition and currentPosition and not IsInInstance() and not C_Garrison.IsOnGarrisonMap()) then
		speed.travel.coords.x, speed.travel.coords.y = (currentPosition.x - pastPosition.x) * map.size.w, (currentPosition.y - pastPosition.y) * map.size.h
		speed.travel.yards = math.sqrt(speed.travel.coords.x ^ 2 + speed.travel.coords.y ^ 2) / (time - lastTime)
		speed.travel.coords.x, speed.travel.coords.y = math.abs(speed.travel.coords.x), math.abs(speed.travel.coords.y)
	else speed.travel.yards = 0 end

	pastPosition = currentPosition
	lastTime = time
end

---Format the specified speed value based on the DB specifications
---@param type "playerSpeed"|"travelSpeed"|"targetSpeed"
---@return string
local function FormatSpeedValue(type)
	local speedType = type:sub(1, -6)
	local f = max(d[type].value.fractionals, 1)

	return speedText[speedType]:gsub(
		"#PERCENT", wt.FormatThousands(
			speed[speedType].yards / BASE_MOVEMENT_SPEED * 100, d[type].value.fractionals, true, not d[type].value.zeros
		) .. (type == "targetSpeed" and "%%%%" or "")
	):gsub(
		"#YARDS", wt.FormatThousands(speed[speedType].yards, d[type].value.fractionals, true, not d[type].value.zeros)
	):gsub(
		"#X", wt.FormatThousands(speed[speedType].coords.x, f, true, not d[type].value.zeros)
	):gsub(
		"#Y", wt.FormatThousands(speed[speedType].coords.y, f, true, not d[type].value.zeros)
	)
end

---Refresh the specified speed text template string to be filled with speed values when displaying it
---@param template "player"|"travel"|"target"
---@param units table
---@param color? boolean
local function UpdateSpeedText(template, units, color)
	speedText[template] = ""

	if units[1] then speedText[template] = speedText[template] .. (color and wt.Color("#PERCENT%", ns.colors.green[2]) or "#PERCENT%") end
	if units[2] then speedText[template] = speedText[template] .. ns.strings.speedValue.separator .. (color and wt.Color(ns.strings.speedValue.yps:gsub(
		"#YARDS", wt.Color("#YARDS", ns.colors.yellow[2])
	), ns.colors.yellow[1]) or ns.strings.speedValue.yps) end
	if units[3] then speedText[template] = speedText[template] .. ns.strings.speedValue.separator .. (color and wt.Color(ns.strings.speedValue.cps:gsub(
		"#COORDS", wt.Color(ns.strings.speedValue.coordPair, ns.colors.blue[2])
	), ns.colors.blue[1]) or ns.strings.speedValue.cps:gsub(
		"#COORDS", ns.strings.speedValue.coordPair
	)) end

	speedText[template] = speedText[template]:gsub("^" .. ns.strings.speedValue.separator, "")
end

local function UpdateMapInfo()
	map.id = C_Map.GetBestMapForUnit("player")
	map.name = C_Map.GetMapInfo(map.id).name
	map.size.w, map.size.h = C_Map.GetMapWorldSize(map.id)
end

--[ Speed Displays ]

---Set the size of the speed display
---@param display "playerSpeed"|"travelSpeed"
---@param height? number Text height | ***Default:*** frames[**display**].text:GetStringHeight()
---@param units? table Displayed units | ***Default:*** db[**display**].value.units
---@param fractionals? number Height:Width ratio | ***Default:*** db[**display**].value.fractionals
---@param font? string Font path | ***Default:*** db[**display**].font.family
local function SetDisplaySize(display, height, units, fractionals, font)
	height = math.ceil(height or frames[display].text:GetStringHeight()) + 2.4
	units = units or d[display].value.units
	fractionals = fractionals or d[display].value.fractionals

	--Calculate width to height ratio
	local ratio = 0
	if units[1] then ratio = ratio + 3.58 + (fractionals > 0 and 0.1 + 0.54 * fractionals or 0) end
	if units[2] then ratio = ratio + 3.52 + (fractionals > 0 and 0.1 + 0.54 * fractionals or 0) end
	if units[3] then ratio = ratio + 5.34 + 1.08 * max(fractionals, 1) end
	for i = 1, 3 do if units[i] then ratio = ratio + 0.2 end end --Separators

	--Resize the display
	frames[display].display:SetSize(height * ratio * ns.fonts[GetFontID(font or d[display].font.family)].widthRatio - 4, height)
end

---Set the backdrop of the speed display elements
---@param display "playerSpeed"|"travelSpeed"
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
local function SetDisplayBackdrop(display, enabled, bgColor, borderColor)
	wt.SetBackdrop(frames[display].display, enabled and {
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
---@param display "playerSpeed"|"travelSpeed"
---@param data table Account-wide data table to set the speed display values from
local function SetDisplayValues(display, data)
	--Position
	frames[display].display:SetClampedToScreen(data[display].keepInBounds)

	--Visibility
	frames[display].display:SetFrameStrata(data[display].layer.strata)
	wt.SetVisibility(frames[display].display, not data[display].visibility.hidden)

	--Display
	SetDisplaySize(display, data[display].font.size, data[display].value.units, data[display].value.fractionals, data[display].font.family)
	SetDisplayBackdrop(display, data[display].background.visible, data[display].background.colors.bg, data[display].background.colors.border)

	--Font & text
	frames[display].text:SetFont(data[display].font.family, data[display].font.size, "THINOUTLINE")
	frames[display].text:SetTextColor(wt.UnpackColor(d[display].font.valueColoring and ns.colors.grey[2] or d[display].font.color))
	frames[display].text:SetJustifyH(data[display].font.alignment)
	wt.SetPosition(frames[display].text, { anchor = data[display].font.alignment, })
end

---Assemble the detailed text lines for the tooltip of the specified speed display
---@param type string
---@return table textLines Table containing text lines to be added to the tooltip [indexed, 0-based]
--- - **text** string ― Text to be added to the line
--- - **font**? string | FontObject *optional* ― The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
--- - **color**? table *optional* ― Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
--- 	- **r** number ― Red [Range: 0 - 1]
--- 	- **g** number ― Green [Range: 0 - 1]
--- 	- **b** number ― Blue [Range: 0 - 1]
--- - **wrap**? boolean *optional* ― Allow this line to be wrapped | ***Default:*** true
local function GetSpeedDisplayTooltipLines(type)
	return {
		{ text = ns.strings.speedTooltip.description },
		{ text = ns.strings.speedTooltip[type .. "Speed"], },
		{
			text = "\n" .. ns.strings.speedTooltip.text[1]:gsub("#YARDS", wt.Color(wt.FormatThousands(speed[type].yards, 2, true),  ns.colors.yellow[2])),
			font = GameTooltipText,
			color = ns.colors.yellow[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.text[2]:gsub(
				"#PERCENT", wt.Color(wt.FormatThousands(speed[type].yards / BASE_MOVEMENT_SPEED * 100, 2, true) .. "%%", ns.colors.green[2])
			),
			font = GameTooltipText,
			color = ns.colors.green[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.text[3]:gsub(
				"#COORDS", wt.Color(ns.strings.speedValue.coordPair:gsub(
					"#X", wt.FormatThousands(speed[type].coords.x, 2, true)
				):gsub(
					"#Y", wt.FormatThousands(speed[type].coords.y, 2, true)
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
					"#W", wt.Color(wt.FormatThousands(map.size.w, 2), { r = 1, g = 1, b = 1 })
				):gsub(
					"#H", wt.Color(wt.FormatThousands(map.size.h, 2), { r = 1, g = 1, b = 1 })
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
end

---Start updating the speed display
---@param display "playerSpeed"|"travelSpeed"
local function StartSpeedDisplayUpdates(display)
	local speedUpdater = display == "playerSpeed" and UpdatePlayerSpeed or UpdateTravelSpeed

	if d[display].update.throttle then
		frames[display].updater.ticker = C_Timer.NewTicker(d[display].update.frequency, function()
			speedUpdater()
			frames[display].text:SetText(" " .. FormatSpeedValue(display))
		end)
	else
		frames[display].updater:SetScript("OnUpdate", function()
			speedUpdater()
			frames[display].text:SetText(" " .. FormatSpeedValue(display))
		end)
	end
end

---Stop updating the speed display
---@param display "playerSpeed"|"travelSpeed"
local function StopSpeedDisplayUpdates(display)
	frames[display].updater:SetScript("OnUpdate", nil)
	if frames[display].updater.ticker then frames[display].updater.ticker:Cancel() end
end

--[ Target Speed ]

---Assemble the text for the mouseover target's speed
---@return string
local function GetTargetSpeedText()
	return "|T" .. ns.textures.logo .. ":0|t" .. " " .. ns.strings.targetSpeed:gsub("#SPEED", wt.Color(FormatSpeedValue("targetSpeed"), ns.colors.grey[2]))
end

--Set up the Target Speed unit tooltip integration
local targetSpeedEnabled = false
local function EnableTargetSpeedUpdates()
	targetSpeedEnabled = true

	--Start mouseover Target Speed updates
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
		if not d.targetSpeed.enabled then return end

		frames.targetSpeed:SetScript("OnUpdate", function()
			if UnitName("mouseover") == nil then return end

			--Update target speed values
			speed.target.yards = GetUnitSpeed("mouseover")
			speed.target.coords.x, speed.target.coords.y = speed.target.yards / (map.size.w / 100), speed.target.yards / (map.size.h / 100)

			--Find the speed line
			local lineAdded = false
			for i = 2, tooltip:NumLines() do
				local line = _G["GameTooltipTextLeft" .. i]
				if line then if string.match(line:GetText() or "", "|T" .. ns.textures.logo .. ":0|t") then
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
local function CreateVisibilityOptions(panel, display, optionsKey)
	options[display].visibility.hidden = wt.CreateCheckbox({
		parent = panel,
		name = "Hidden",
		title = ns.strings.options.speedDisplay.visibility.hidden.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.hidden.tooltip:gsub("#ADDON", addonTitle), }, } },
		arrange = {},
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].visibility,
			storageKey = "hidden",
			onChange = { DisplayToggle = function()
				wt.SetVisibility(frames[display].display, not d[display].visibility.hidden)
				if d[display].visibility.hidden then StopSpeedDisplayUpdates(display) else StartSpeedDisplayUpdates(display) end
			end, }
		}
	})

	options[display].visibility.autoHide = wt.CreateCheckbox({
		parent = panel,
		name = "AutoHide",
		title = ns.strings.options.speedDisplay.visibility.autoHide.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.autoHide.tooltip, }, } },
		arrange = { newRow = false, },
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].visibility,
			storageKey = "autoHide",
		}
	})

	options[display].visibility.status = wt.CreateCheckbox({
		parent = panel,
		name = "StatusNotice",
		title = ns.strings.options.speedDisplay.visibility.statusNotice.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.statusNotice.tooltip, }, } },
		arrange = { newRow = false, },
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].visibility,
			storageKey = "statusNotice",
		}
	})
end
local function CreateUpdateOptions(panel, display, optionsKey)
	options[display].update.throttle = wt.CreateCheckbox({
		parent = panel,
		name = "Throttle",
		title = ns.strings.options.speedDisplay.update.throttle.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.throttle.tooltip, }, } },
		arrange = {},
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].update,
			storageKey = "throttle",
			onChange = {
				RefreshSpeedUpdates = function()
					StopSpeedDisplayUpdates(display)
					StartSpeedDisplayUpdates(display)
				end
			}
		}
	})

	options[display].update.frequency = wt.CreateNumericSlider({
		parent = panel,
		name = "Frequency",
		title = ns.strings.options.speedDisplay.update.frequency.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.frequency.tooltip, }, } },
		arrange = { newRow = false, },
		value = { min = 0.05, max = 1, increment = 0.05 },
		altStep = 0.2,
		events = { OnValueChanged = function(_, value)  end, },
		dependencies = {
			{ frame = options[display].visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options[display].update.throttle },
		},
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].update,
			storageKey = "frequency",
			convertSave = function(value) return wt.Round(value, 2) end,
			onChange = { "RefreshSpeedUpdates", }
		}
	})

	-- if display ~= "playerSpeed" then return end
	--TODO: figure out how to implement it - or delete if unnecessary
	-- options.playerSpeed.update.dragonridingOnly = wt.CreateCheckbox({
	-- 	parent = panel,
	-- 	name = "DragonridingOnly",
	-- 	title = ns.strings.options.playerSpeed.dragonridingOnly.label,
	-- 	tooltip = { lines = { { text = ns.strings.options.playerSpeed.dragonridingOnly.tooltip, }, } },
	-- 	arrange = { newRow = false, },
	-- 	dependencies = {
	-- 		{ frame = options.playerSpeed.visibility.hidden, evaluate = function(state) return not state end },
	-- 		{ frame = options.playerSpeed.update.frequency, evaluate = function(value) return value < 1 end },
	-- 	},
	-- 	optionsData = {
	-- 		optionsKey = optionsKey,
	-- 		workingTable = db.playerSpeed.update,
	-- 		storageKey = "dragonridingOnly",
	-- 	}
	-- })
end
local function CreateSpeedValueOptions(panel, display, optionsKey, type)
	options[display].value.units = wt.CreateMultipleSelector({
		parent = panel,
		name = "Units",
		title = ns.strings.options.speedValue.units.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.units.tooltip, }, } },
		arrange = {},
		items = valueTypes,
		limits = { min = 1, },
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].value,
			storageKey = "units",
			onChange = {
				UpdateDisplaySize = function() SetDisplaySize(display) end,
				UpdateSpeedTextTemplate = function() UpdateSpeedText(type, d[display].value.units, d[display].font.valueColoring) end,
			}
		}
	})

	options[display].value.fractionals = wt.CreateNumericSlider({
		parent = panel,
		name = "Fractionals",
		title = ns.strings.options.speedValue.fractionals.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.fractionals.tooltip, }, } },
		arrange = { newRow = false, },
		value = { min = 0, max = 4, increment = 1 },
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].value,
			storageKey = "fractionals",
			onChange = { "UpdateDisplaySize", }
		}
	})

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
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].value,
			storageKey = "zeros",
		}
	})
end
local function CreateFontOptions(panel, display, optionsKey, type)
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
	options[display].font.family = wt.CreateDropdownSelector({
		parent = panel,
		name = "Family",
		title = ns.strings.options.speedDisplay.font.family.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.family.tooltip, }, } },
		arrange = {},
		items = fontItems,
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].font,
			storageKey = "family",
			convertSave = function(value) return ns.fonts[value or 1].path end,
			convertLoad = function(font) return GetFontID(font) end,
			onChange = {
				UpdateDisplayFont = function() frames[display].text:SetFont(d[display].font.family, d[display].font.size, "THINOUTLINE") end,
				UpdateDisplaySize = function() SetDisplaySize(display) end, --TODO: solve the duplication issue
				-- "UpdateDisplaySize",
				RefreshDisplayText = function() --Refresh the text so the font will be applied right away (if the font is loaded)
					local text = frames[display].text:GetText()
					frames[display].text:SetText("")
					frames[display].text:SetText(text)
				end,
				UpdateFontFamilyDropdownText = function()
					--Update the font of the dropdown toggle button label
					local _, size, flags = options[display].font.family.toggle.label:GetFont()
					options[display].font.family.toggle.label:SetFont(ns.fonts[options[display].font.family.getSelected() or 1].path, size, flags)

					--Refresh the text so the font will be applied right away (if the font is loaded)
					local text = options[display].font.family.toggle.label:GetText()
					options[display].font.family.toggle.label:SetText("")
					options[display].font.family.toggle.label:SetText(text)
				end,
			}
		}
	})
	--Update the font of the dropdown items
	if options[display].font.family.frame then for i = 1, #options[display].font.family.widgets do if options[display].font.family.widgets[i].label then
		local _, size, flags = options[display].font.family.widgets[i].label:GetFont()
		options[display].font.family.widgets[i].label:SetFont(ns.fonts[i].path, size, flags)
	end end end

	options[display].font.size = wt.CreateNumericSlider({
		parent = panel,
		name = "Size",
		title = ns.strings.options.speedDisplay.font.size.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.size.tooltip .. "\n\n" .. ns.strings.misc.default .. ": " .. ns.profileDefault[display].font.size, }, } },
		arrange = { newRow = false, },
		value = { min = 8, max = 64, increment = 1 },
		altStep = 3,
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].font,
			storageKey = "size",
			onChange = {
				"UpdateDisplayFont",
				"UpdateDisplaySize",
			}
		}
	})

	options[display].font.alignment = wt.CreateSpecialSelector({
		parent = panel,
		name = "Alignment",
		title = ns.strings.options.speedDisplay.font.alignment.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.alignment.tooltip, }, } },
		arrange = { newRow = false, },
		width = 140,
		itemset = "justifyH",
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].font,
			storageKey = "alignment",
			onChange = { UpdateDisplayTextAlignment = function()
				frames[display].text:SetJustifyH(d[display].font.alignment)
				wt.SetPosition(frames[display].text, { anchor = d[display].font.alignment, })
			end, }
		}
	})

	options[display].font.valueColoring = wt.CreateCheckbox({
		parent = panel,
		name = "ValueColoring",
		title = ns.strings.options.speedDisplay.font.valueColoring.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.valueColoring.tooltip:gsub("#ADDON", addonTitle), }, } },
		arrange = {},
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].font,
			storageKey = "valueColoring",
			onChange = {
				UpdateDisplayFontColor = function()
					frames[display].text:SetTextColor(wt.UnpackColor(d[display].font.valueColoring and ns.colors.grey[2] or d[display].font.color))
				end,
				UpdateEmbeddedValueColoring = function()
					if d[display].font.valueColoring then UpdateSpeedText(type, d[display].value.units, true) else speedText[type] = wt.Clear(speedText[type]) end
				end,
			}
		}
	})

	options[display].font.color = wt.CreateColorPicker({
		parent = panel,
		name = "Color",
		title = ns.strings.options.speedDisplay.font.color.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.color.tooltip, }, } },
		arrange = { newRow = false, },
		dependencies = {
			{ frame = options[display].visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options[display].font.valueColoring, evaluate = function(state) return not state end },
		},
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].font,
			storageKey = "color",
			onChange = { "UpdateDisplayFontColor", }
		}
	})
end
local function CreateBackgroundOptions(panel, display, optionsKey)
	options[display].background.visible = wt.CreateCheckbox({
		parent = panel,
		name = "Visible",
		title = ns.strings.options.speedDisplay.background.visible.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.background.visible.tooltip, }, } },
		arrange = {},
		dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].background,
			storageKey = "visible",
			onChange = { ToggleDisplayBackdrops = function()
				SetDisplayBackdrop(display, d[display].background.visible, d[display].background.colors.bg, d[display].background.colors.border)
			end, }
		}
	})

	options[display].background.colors.bg = wt.CreateColorPicker({
		parent = panel,
		name = "Color",
		title = ns.strings.options.speedDisplay.background.colors.bg.label,
		arrange = { newRow = false, },
		dependencies = {
			{ frame = options[display].visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options[display].background.visible, },
		},
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].background.colors,
			storageKey = "bg",
			onChange = { UpdateDisplayBackgroundColor = function()
				if frames[display].display:GetBackdrop() ~= nil then frames[display].display:SetBackdropColor(wt.UnpackColor(d[display].background.colors.bg)) end
			end }
		}
	})

	options[display].background.colors.border = wt.CreateColorPicker({
		parent = panel,
		name = "BorderColor",
		title = ns.strings.options.speedDisplay.background.colors.border.label,
		arrange = { newRow = false, },
		dependencies = {
			{ frame = options[display].visibility.hidden, evaluate = function(state) return not state end },
			{ frame = options[display].background.visible, },
		},
		optionsData = {
			optionsKey = optionsKey,
			workingTable = d[display].background.colors,
			storageKey = "border",
			onChange = { UpdateDisplayBorderColor = function()
				if frames[display].display:GetBackdrop() ~= nil then frames[display].display:SetBackdropBorderColor(wt.UnpackColor(d[display].background.colors.border)) end
			end }
		}
	})
end

---Create the category page
---@param display "playerSpeed"|"travelSpeed"
local function CreateSpeedDisplayOptions(display)
	local displayName = ns.strings.options[display].title:gsub("%s+", "")
	local displayType = display:sub(1, -6)
	local otherDisplay = display == "playerSpeed" and "travelSpeed" or "playerSpeed"
	local optionsKeys = {
		ns.name .. displayName .. "Visibility",
		ns.name .. displayName .. "Position",
		ns.name .. displayName .. "Updates",
		ns.name .. displayName .. "Value",
		ns.name .. displayName .. "Font",
		ns.name .. displayName .. "Background",
	}

	options[display].page = wt.CreateOptionsCategory(ns.name, {
		parent = options.main.page,
		name = ns.strings.options[display].title,
		title = ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options[display].title),
		description = ns.strings.options[display].description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		scroll = { speed = 0.21 },
		optionsKeys = optionsKeys,
		storage = { {
			workingTable = d[display],
			storageTable = s[display],
			defaultsTable = ns.profileDefault[display],
		}, },
		onDefault = function(user)
			options[display].position.resetCustomPreset()

			--Notification
			if user then print(addonChat .. wt.Color(ns.strings.chat.defaults.response:gsub(
				"#CATEGORY", wt.Color(ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options[display].title), ns.colors.green[2])
			), ns.colors.yellow[2])) end
		end,
		initialize = function(canvas)

			--[ Visibility ]

			wt.CreatePanel({
				parent = canvas,
				name = "Visibility",
				title = ns.strings.options.speedDisplay.visibility.title,
				description = ns.strings.options.speedDisplay.visibility.description:gsub("#ADDON", addonTitle),
				arrange = {},
				initialize = function(panel)
					CreateVisibilityOptions(panel, display, optionsKeys[1])

					wt.CreateButton({
						parent = canvas,
						name = "CopyVisibility",
						title =  ns.strings.options.speedDisplay.copy.label:gsub("#TYPE", ns.strings.options[otherDisplay].title),
						tooltip = { lines = { { text =  ns.strings.options.speedDisplay.copy.tooltip:gsub("#TYPE", ns.strings.options[otherDisplay].title), }, } },
						position = {
							anchor = "BOTTOMRIGHT",
							relativeTo = panel,
							relativePoint = "TOPRIGHT",
							offset = { x = -8, y = 4 }
						},
						size = { w = 164, h = 14 },
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
							disabled = "GameFontDisableSmall"
						},
						action = function()
							wt.CopyValues(d[display].visibility, d[otherDisplay].visibility)
							wt.LoadOptionsData(optionsKeys[1], true)
						end,
						dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
					})
				end,
				arrangement = {}
			})

			--[ Position ]

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
						wt.ConvertToAbsolutePosition(frames[display].display)

						--Make sure the speed display is visible
						options[display].visibility.hidden.setData(false)

						--Notification
						print(addonChat .. wt.Color(ns.strings.chat.preset.response:gsub(
							"#PRESET", wt.Color(options[display].position.presetList[i].title, ns.colors.green[2])
						), ns.colors.yellow[2]))
					end,
					custom = {
						workingTable = d.customPreset,
						storageTable = s.customPreset,
						defaultsTable = ns.profileDefault.customPreset,
						onSave = function() print(addonChat .. wt.Color(ns.strings.chat.save.response:gsub(
							"#CUSTOM", wt.Color(options[display].position.presetList[1].title, ns.colors.green[2])
						), ns.colors.yellow[2])) end,
						onReset = function() print(addonChat .. wt.Color(ns.strings.chat.reset.response:gsub(
							"#CUSTOM", wt.Color(options[display].position.presetList[1].title, ns.colors.green[2])
						), ns.colors.yellow[2])) end
					}
				},
				setMovable = { events = {
					onStop = function() print(addonChat .. wt.Color(ns.strings.chat.position.save, ns.colors.yellow[2])) end,
					onCancel = function()
						print(addonChat .. wt.Color(ns.strings.chat.position.cancel, ns.colors.yellow[1]))
						print(wt.Color(ns.strings.chat.position.error, ns.colors.yellow[2]))
					end,
				}, },
				dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
				optionsKey = optionsKeys[2],
				workingTable = d[display],
				storageTable = s[display],
				settingsData = MovementSpeedCS,
				onChangePosition = function() d[display].position.relativePoint = d[display].position.anchor end,
			})

			wt.CreateButton({
				parent = canvas,
				name = "CopyPosition",
				title =  ns.strings.options.speedDisplay.copy.label:gsub("#TYPE", ns.strings.options[otherDisplay].title),
				tooltip = { lines = { { text =  ns.strings.options.speedDisplay.copy.tooltip:gsub("#TYPE", ns.strings.options[otherDisplay].title), }, } },
				position = {
					anchor = "BOTTOMRIGHT",
					relativeTo = options[display].position.frame,
					relativePoint = "TOPRIGHT",
					offset = { x = -8, y = 4 }
				},
				size = { w = 164, h = 14 },
				font = {
					normal = "GameFontNormalSmall",
					highlight = "GameFontHighlightSmall",
					disabled = "GameFontDisableSmall"
				},
				action = function()
					wt.CopyValues(d[display].position, d[otherDisplay].position)
					wt.LoadOptionsData(optionsKeys[2], true)
				end,
				dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
			})

			--[ Updates ]

			wt.CreatePanel({
				parent = canvas,
				name = "Updates",
				title = ns.strings.options.speedDisplay.update.title,
				description = ns.strings.options.speedDisplay.update.description,
				arrange = {},
				initialize = function(panel)
					CreateUpdateOptions(panel, display, optionsKeys[3])

					wt.CreateButton({
						parent = canvas,
						name = "CopyUpdates",
						title =  ns.strings.options.speedDisplay.copy.label:gsub("#TYPE", ns.strings.options[otherDisplay].title),
						tooltip = { lines = { { text =  ns.strings.options.speedDisplay.copy.tooltip:gsub("#TYPE", ns.strings.options[otherDisplay].title), }, } },
						position = {
							anchor = "BOTTOMRIGHT",
							relativeTo = panel,
							relativePoint = "TOPRIGHT",
							offset = { x = -8, y = 4 }
						},
						size = { w = 164, h = 14 },
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
							disabled = "GameFontDisableSmall"
						},
						action = function()
							wt.CopyValues(d[display].updates, d[otherDisplay].updates)
							wt.LoadOptionsData(optionsKeys[3], true)
							d.travelSpeed.update.dragonridingOnly = nil
						end,
						dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
					})
				end,
				arrangement = {}
			})

			--[ Value ]

			wt.CreatePanel({
				parent = canvas,
				name = "Value",
				title = ns.strings.options.speedValue.title,
				description = ns.strings.options.speedValue.description,
				arrange = {},
				initialize = function(panel)
					CreateSpeedValueOptions(panel, display, optionsKeys[4], displayType)

					wt.CreateButton({
						parent = canvas,
						name = "CopyValue",
						title =  ns.strings.options.speedDisplay.copy.label:gsub("#TYPE", ns.strings.options[otherDisplay].title),
						tooltip = { lines = { { text =  ns.strings.options.speedDisplay.copy.tooltip:gsub("#TYPE", ns.strings.options[otherDisplay].title), }, } },
						position = {
							anchor = "BOTTOMRIGHT",
							relativeTo = panel,
							relativePoint = "TOPRIGHT",
							offset = { x = -8, y = 4 }
						},
						size = { w = 164, h = 14 },
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
							disabled = "GameFontDisableSmall"
						},
						action = function()
							wt.CopyValues(d[display].value, d[otherDisplay].value)
							wt.LoadOptionsData(optionsKeys[4], true)
						end,
						dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
					})
				end,
				arrangement = {}
			})

			--[ Font ]

			wt.CreatePanel({
				parent = canvas,
				name = "Font",
				title = ns.strings.options.speedDisplay.font.title,
				description = ns.strings.options.speedDisplay.font.description,
				arrange = {},
				initialize = function(panel)
					CreateFontOptions(panel, display, optionsKeys[5], displayType)

					wt.CreateButton({
						parent = canvas,
						name = "CopyFont",
						title =  ns.strings.options.speedDisplay.copy.label:gsub("#TYPE", ns.strings.options[otherDisplay].title),
						tooltip = { lines = { { text =  ns.strings.options.speedDisplay.copy.tooltip:gsub("#TYPE", ns.strings.options[otherDisplay].title), }, } },
						position = {
							anchor = "BOTTOMRIGHT",
							relativeTo = panel,
							relativePoint = "TOPRIGHT",
							offset = { x = -8, y = 4 }
						},
						size = { w = 164, h = 14 },
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
							disabled = "GameFontDisableSmall"
						},
						action = function()
							wt.CopyValues(d[display].font, d[otherDisplay].font)
							wt.LoadOptionsData(optionsKeys[5], true)
						end,
						dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
					})
				end,
				arrangement = {}
			})

			--[ Background ]

			wt.CreatePanel({
				parent = canvas,
				name = "Background",
				title = ns.strings.options.speedDisplay.background.title,
				description = ns.strings.options.speedDisplay.background.description:gsub("#ADDON", addonTitle),
				arrange = {},
				initialize = function(panel)
					CreateBackgroundOptions(panel, display, optionsKeys[6])

					wt.CreateButton({
						parent = canvas,
						name = "CopyBackground",
						title =  ns.strings.options.speedDisplay.copy.label:gsub("#TYPE", ns.strings.options[otherDisplay].title),
						tooltip = { lines = { { text =  ns.strings.options.speedDisplay.copy.tooltip:gsub("#TYPE", ns.strings.options[otherDisplay].title), }, } },
						position = {
							anchor = "BOTTOMRIGHT",
							relativeTo = panel,
							relativePoint = "TOPRIGHT",
							offset = { x = -8, y = 4 }
						},
						size = { w = 164, h = 14 },
						font = {
							normal = "GameFontNormalSmall",
							highlight = "GameFontHighlightSmall",
							disabled = "GameFontDisableSmall"
						},
						action = function()
							wt.CopyValues(d[display].background, d[otherDisplay].background)
							wt.LoadOptionsData(optionsKeys[6], true)
						end,
						dependencies = { { frame = options[display].visibility.hidden, evaluate = function(state) return not state end }, },
					})
				end,
				arrangement = {}
			})
		end,
		arrangement = {}
	})
end

--[ Target Speed ]

--Create the widgets
local function CreateTargetSpeedTooltipOptions(panel)
	options.targetSpeed.enabled = wt.CreateCheckbox({
		parent = panel,
		name = "Enabled",
		title = ns.strings.options.targetSpeed.mouseover.enabled.label,
		tooltip = { lines = { { text = ns.strings.options.targetSpeed.mouseover.enabled.tooltip:gsub("#ADDON", addonTitle), }, } },
		arrange = {},
		optionsData = {
			optionsKey = ns.name .. "TargetSpeed",
			workingTable = d.targetSpeed,
			storageKey = "enabled",
			onChange = { EnableTargetSpeedUpdates = function() if not targetSpeedEnabled then EnableTargetSpeedUpdates() end end, }
		}
	})
end
local function CreateTargetSpeedValueOptions(panel)
	options.targetSpeed.value.units = wt.CreateMultipleSelector({
		parent = panel,
		name = "Units",
		title = ns.strings.options.speedValue.units.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.units.tooltip, }, } },
		arrange = {},
		items = valueTypes,
		limits = { min = 1, },
		dependencies = { { frame = options.targetSpeed.enabled, }, },
		optionsData = {
			optionsKey = ns.name .. "TargetSpeed",
			workingTable = d.targetSpeed.value,
			storageKey = "units",
			onChange = { UpdateTargetSpeedTextTemplate = function() UpdateSpeedText("target", d.targetSpeed.value.units) end, }
		}
	})

	options.targetSpeed.value.fractionals = wt.CreateNumericSlider({
		parent = panel,
		name = "Fractionals",
		title = ns.strings.options.speedValue.fractionals.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.fractionals.tooltip, }, } },
		arrange = { newRow = false, },
		value = { min = 0, max = 4, increment = 1 },
		dependencies = { { frame = options.targetSpeed.enabled, }, },
		optionsData = {
			optionsKey = ns.name .. "TargetSpeed",
			workingTable = d.targetSpeed.value,
			storageKey = "fractionals",
		}
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
		optionsData = {
			optionsKey = ns.name .. "TargetSpeed",
			workingTable = d.targetSpeed.value,
			storageKey = "zeros",
		}
	})
end

--Create the category page
local function CreateTargetSpeedOptions()
	options.targetSpeed.page = wt.CreateOptionsCategory(ns.name, {
		parent = options.main.page,
		name = "TargetSpeed",
		title = ns.strings.options.targetSpeed.title,
		description = ns.strings.options.targetSpeed.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		optionsKeys = { ns.name .. "TargetSpeed" },
		storage = { {
			workingTable = d.targetSpeed,
			storageTable = s.targetSpeed,
			defaultsTable = ns.profileDefault.targetSpeed,
		}, },
		onDefault = function(user)
			if not user then return end

			--Notification
			print(addonChat .. wt.Color(ns.strings.chat.defaults.response:gsub(
				"#CATEGORY", wt.Color(ns.strings.options.targetSpeed.title, ns.colors.green[2])
			), ns.colors.yellow[2]))
		end,
		initialize = function(canvas)
			--Panel: Tooltip integration
			wt.CreatePanel({
				parent = canvas,
				name = "TargetSpeed",
				title = ns.strings.options.targetSpeed.mouseover.title,
				description = ns.strings.options.targetSpeed.mouseover.description,
				arrange = {},
				initialize = CreateTargetSpeedTooltipOptions,
				arrangement = {}
			})

			--Panel: Value
			wt.CreatePanel({
				parent = canvas,
				name = "Value",
				title = ns.strings.options.speedValue.title,
				description = ns.strings.options.speedValue.description,
				arrange = {},
				initialize = CreateTargetSpeedValueOptions,
				arrangement = {}
			})
		end,
		arrangement = {}
	})
end


--[[ CHAT CONTROL ]]

--[ Chat Utilities ]

---Print visibility info
---@param load boolean | ***Default:*** false
local function PrintStatus(load)
	if load == true and not d[d.mainDisplay].visibility.statusNotice then return end

	print(addonChat .. wt.Color(frames.main:IsVisible() and (
		not frames[d.mainDisplay].display:IsVisible() and ns.strings.chat.status.notVisible or ns.strings.chat.status.visible
	) or ns.strings.chat.status.hidden, ns.colors.yellow[1]):gsub(
		"#AUTO", wt.Color(ns.strings.chat.status.auto:gsub(
			"#STATE", wt.Color(d[d.mainDisplay].visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.green[2])
		), ns.colors.yellow[2])
	))
end

--Print help info
local function PrintInfo()
	print(wt.Color(ns.strings.chat.help.thanks:gsub("#ADDON", wt.Color(addonTitle, ns.colors.green[1])), ns.colors.yellow[1]))
	PrintStatus()
	print(wt.Color(ns.strings.chat.help.hint:gsub("#HELP_COMMAND", wt.Color("/" .. ns.chat.keyword .. " " .. ns.chat.commands.help, ns.colors.green[2])), ns.colors.yellow[2]))
	print(wt.Color(ns.strings.chat.help.move:gsub("#ADDON", addonTitle), ns.colors.yellow[2]))
end

---Format and print a command description
---@param command string Command name
---@param description string Command description text
local function PrintCommand(command, description)
	print("    " .. wt.Color("/" .. ns.chat.keyword .. " " .. command, ns.colors.green[2])  .. wt.Color(" - " .. description, ns.colors.yellow[2]))
end

--Reset to defaults confirmation
local resetDefaultsPopup = wt.CreatePopup(ns.name, {
	name = "DefaultOptions",
	text = (wt.GetStrings("warning") or ""):gsub("#TITLE", wt.Clear(addonTitle)),
	onAccept = function()
		--Reset the options data & update the interface options
		options.playerSpeed.page.default()
		options.travelSpeed.page.default()
		options.targetSpeed.page.default()
		options.dataManagement.page.default(true)
	end,
})

--[ Commands ]

--Register handlers
local commandManager = wt.RegisterChatCommands(ns.name, { ns.chat.keyword }, {
	{
		command = ns.chat.commands.help,
		handler = function() print(wt.Color(addonTitle .. " ", ns.colors.green[1]) .. wt.Color(ns.strings.chat.help.list .. ":", ns.colors.yellow[1])) end,
		help = true,
	},
	{
		command = ns.chat.commands.options,
		handler = function() options.main.page.open() end,
		onHelp = function() PrintCommand(ns.chat.commands.options, ns.strings.chat.options.description:gsub("#ADDON", addonTitle)) end
	},
	{
		command = ns.chat.commands.preset,
		handler = function(parameter) return options[d.mainDisplay].position.applyPreset(tonumber(parameter)) end,
		onError = function()
			print(addonChat .. wt.Color(ns.strings.chat.preset.unchanged, ns.colors.yellow[1]))
			print(wt.Color(ns.strings.chat.preset.error:gsub("#INDEX", wt.Color(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])), ns.colors.yellow[2]))
			print(wt.Color(ns.strings.chat.preset.list, ns.colors.green[2]))
			for j = 1, #options[d.mainDisplay].position.presetList, 2 do
				local list = "    " .. wt.Color(j, ns.colors.green[2]) .. wt.Color(" - " .. options[d.mainDisplay].position.presetList[j].name, ns.colors.yellow[2])
				if j + 1 <= #options[d.mainDisplay].position.presetList then
					list = list .. "    " .. wt.Color(j + 1, ns.colors.green[2]) .. wt.Color(" - " .. options[d.mainDisplay].position.presetList[j + 1].name, ns.colors.yellow[2])
				end
				print(list)
			end
		end,
		onHelp = function() PrintCommand(ns.chat.commands.preset, ns.strings.chat.preset.description:gsub(
			"#INDEX", wt.Color(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])
		)) end
	},
	{
		command = ns.chat.commands.save,
		handler = function() options[d.mainDisplay].position.saveCustomPreset() end,
		onHelp = function() PrintCommand(ns.chat.commands.save, ns.strings.chat.save.description:gsub(
			"#CUSTOM", wt.Color(options[d.mainDisplay].position.presetList[1].title, ns.colors.green[2])
		)) end
	},
	{
		command = ns.chat.commands.reset,
		handler = function() options[d.mainDisplay].position.resetCustomPreset() end,
		onHelp = function() PrintCommand(ns.chat.commands.reset, ns.strings.chat.reset.description:gsub(
			"#CUSTOM", wt.Color(options[d.mainDisplay].position.presetList[1].title, ns.colors.green[2])
		)) end
	},
	{
		command = ns.chat.commands.toggle,
		handler = function()
			options[d.mainDisplay].visibility.hidden.setData(not d[d.mainDisplay].visibility.hidden, true)

			return true
		end,
		onSuccess = function()
			print(addonChat .. wt.Color(d[d.mainDisplay].visibility.hidden and ns.strings.chat.toggle.hiding or ns.strings.chat.toggle.unhiding, ns.colors.yellow[2]))
		end,
		onHelp = function() PrintCommand(ns.chat.commands.toggle, ns.strings.chat.toggle.description:gsub(
			"#HIDDEN", wt.Color(d[d.mainDisplay].visibility.hidden and ns.strings.chat.toggle.hidden or ns.strings.chat.toggle.notHidden, ns.colors.green[2])
		)) end
	},
	{
		command = ns.chat.commands.auto,
		handler = function()
			options[d.mainDisplay].visibility.autoHide.setData(not d[d.mainDisplay].visibility.autoHide, true)

			return true
		end,
		onSuccess = function() print(addonChat .. wt.Color(ns.strings.chat.auto.response:gsub(
			"#STATE", wt.Color(d[d.mainDisplay].visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.green[2])
		), ns.colors.yellow[2])) end,
		onHelp = function() PrintCommand(ns.chat.commands.auto, ns.strings.chat.auto.description:gsub(
			"#STATE", wt.Color(d[d.mainDisplay].visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.green[2])
		)) end
	},
	{
		command = ns.chat.commands.size,
		handler = function(parameter)
			local size = tonumber(parameter)
			if not size then return false end

			options[d.mainDisplay].font.size.setData(size, true)

			return true, size
		end,
		onSuccess = function(size) print(addonChat .. wt.Color(ns.strings.chat.size.response:gsub("#VALUE", wt.Color(size, ns.colors.green[2])), ns.colors.yellow[2])) end,
		onError = function()
			print(addonChat .. wt.Color(ns.strings.chat.size.unchanged, ns.colors.yellow[1]))
			print(wt.Color(ns.strings.chat.size.error:gsub(
				"#SIZE", wt.Color(ns.chat.commands.size .. " " .. ns.profileDefault[d.mainDisplay].font.size, ns.colors.green[2])
			), ns.colors.yellow[2]))
		end,
		onHelp = function() PrintCommand(ns.chat.commands.size, ns.strings.chat.size.description:gsub(
			"#SIZE", wt.Color(ns.chat.commands.size .. " " .. ns.profileDefault[d.mainDisplay].font.size, ns.colors.green[2])
		)) end
	},
	{
		command = ns.chat.commands.defaults,
		handler = function() StaticPopup_Show(resetDefaultsPopup) end,
		onHelp = function() PrintCommand(ns.chat.commands.defaults, ns.strings.chat.defaults.description) end
	},
}, PrintInfo)


--[[ INITIALIZATION ]]

--Set up the speed display context menu
local function _CreateContextMenu(parent)
	local contextMenu = wt.CreateContextMenu({ parent = parent, })

	--[ Items ]

	wt.AddContextLabel(contextMenu, { text = addonTitle, })

	--Options submenu
	-- local optionsMenu = wt.AddContextSubmenu(contextMenu, { --WATCH: Restore the submenu and the buttons once opening settings subcategories programmatically is once again supported in Dragonflight
	-- 	title = ns.strings.misc.options,
	-- })

	-- wt.AddContextButton(optionsMenu, contextMenu, {
	wt.AddContextButton(contextMenu, contextMenu, {
		-- title = ns.strings.options.main.name,
		title = ns.strings.misc.options,
		tooltip = { lines = { { text = ns.strings.options.main.description:gsub("#ADDON", addonTitle), }, } },
		events = { OnClick = function() options.main.page.open() end, },
	})
	-- wt.AddContextButton(optionsMenu, contextMenu, {
	-- 	title = ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options.playerSpeed.title),
	-- 	tooltip = { lines = { { text = ns.strings.options.playerSpeed.description:gsub("#ADDON", addonTitle), }, } },
	-- 	events = { OnClick = function() options.playerSpeed.page.open() end, },
	-- })
	-- wt.AddContextButton(optionsMenu, contextMenu, {
	-- 	title = ns.strings.options.travelSpeed.title,
	-- 	tooltip = { lines = { { text = ns.strings.options.travelSpeed.description:gsub("#ADDON", addonTitle), }, } },
	-- 	events = { OnClick = function() options.travelSpeed.page.open() end, },
	-- })
	-- wt.AddContextButton(optionsMenu, contextMenu, {
	-- 	title = ns.strings.options.targetSpeed.title,
	-- 	tooltip = { lines = { { text = ns.strings.options.targetSpeed.description:gsub("#ADDON", addonTitle), }, } },
	-- 	events = { OnClick = function() options.targetSpeed.page.open() end, },
	-- })
	-- wt.AddContextButton(optionsMenu, contextMenu, {
	-- 	title = ns.strings.options.advanced.title,
	-- 	tooltip = { lines = { { text = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle), }, } },
	-- 	events = { OnClick = function() options.advanced.page.open() end, },
	-- })

	--Presets submenu
	local presetsMenu = wt.AddContextSubmenu(contextMenu, {
		title = ns.strings.options.speedDisplay.position.presets.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.presets.tooltip, }, } },
	})
	for i = 1, #options[d.mainDisplay].position.presetList do wt.AddContextButton(presetsMenu, contextMenu, {
		title = options[d.mainDisplay].position.presetList[i].title,
		events = { OnClick = function() commandManager.handleCommand(ns.chat.commands.preset, i) end, },
	}) end
end --TODO: Reinstate after fix or delete
local function CreateContextMenu(display)
	local menu = {
		{
			text = addonTitle,
			isTitle = true,
			notCheckable = true,
		},
		{
			text = ns.strings.misc.options,
			func = function() options.main.page.open() end,
			notCheckable = true,
		},
		{
			text = wt.GetStrings("apply").label,
			hasArrow = true,
			menuList = {},
			notCheckable = true,
		},
	}

	--Insert presets
	for i = 1, #options[display].position.presetList do table.insert(menu[3].menuList, {
		text = options[display].position.presetList[i].title,
		func = function() options[display].position.applyPreset(i) end,
		notCheckable = true,
	}) end

	wt.CreateClassicContextMenu({
		parent = frames[display].display,
		menu = menu
	})
end

--Create main addon frame & display
frames.main = wt.CreateBaseFrame({
	name = ns.name,
	position = {},
	onEvent = {
		ADDON_LOADED = function(self, addon)
			if addon ~= ns.name then return end
			self:UnregisterEvent("ADDON_LOADED")

			--[ Settings Addon Page]

			options.main.page = wt.CreateAboutPage(ns.name, {
				name = "Main",
				description = ns.strings.options.main.description:gsub("#ADDON", addonTitle),
				changelog = ns.changelog
			})

			--[ Data ]

			local firstLoad = not MovementSpeedDB

			--Load storage DBs
			MovementSpeedDB = MovementSpeedDB or {}
			MovementSpeedDBC = MovementSpeedDBC or {}

			--Load cross-session data
			MovementSpeedCS = wt.AddMissing(MovementSpeedCS or {}, { compactBackup = true, })

			--Initialize data management
			options.dataManagement = wt.CreateDataManagementPage(ns.name, {
				parent = options.main.page,
				register = false,
				onDefault = function()
					options[d.mainDisplay].position.resetCustomPreset()

					--Notifications
					print(addonChat .. wt.Color(ns.strings.chat.defaults.response:gsub(
						"#CATEGORY", wt.Color(ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options.playerSpeed.title), ns.colors.green[2])
					), ns.colors.yellow[2]))
					print(addonChat .. wt.Color(ns.strings.chat.defaults.response:gsub(
						"#CATEGORY", wt.Color(ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options.travelSpeed.title), ns.colors.green[2])
					), ns.colors.yellow[2]))
					print(addonChat .. wt.Color(ns.strings.chat.defaults.response:gsub(
						"#CATEGORY", wt.Color(ns.strings.options.targetSpeed.title, ns.colors.green[2])
					), ns.colors.yellow[2]))
				end,
				accountData = MovementSpeedDB,
				characterData = MovementSpeedDBC,
				settingsData = MovementSpeedCS,
				workingTable = d,
				defaultsTable = ns.profileDefault,
				onProfilesLoaded = function() s = MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data end,
				onProfileActivated = function()
					s = MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].data

					--Update the interface options
					options.playerSpeed.page.load(true)
					options.travelSpeed.page.load(true)
					options.targetSpeed.page.load(true)
					options.dataManagement.page.load(true)
				end,
				onImport = function(success) if success then
					--Update the interface options
					options.playerSpeed.page.load(true)
					options.travelSpeed.page.load(true)
					options.targetSpeed.page.load(true)
					options.dataManagement.page.load(true)
				else print(addonChat .. wt.Color(ns.strings.options.advanced.backup.error, ns.colors.yellow[2])) end end,
				onImportAllProfiles = function(success) if not success then print(addonChat .. wt.Color(ns.strings.options.advanced.backup.error, ns.colors.yellow[2])) end end,
				valueChecker = CheckValidity,
				onRecovery = GetRecoveryMap
			})

			--Welcome message
			if firstLoad then PrintInfo() end

			--[ Settings Setup ]

			CreateSpeedDisplayOptions("playerSpeed")
			CreateSpeedDisplayOptions("travelSpeed")
			CreateTargetSpeedOptions()
			options.dataManagement.page.register()

			--[ Display Setup ]

			--Player Speed
			CreateContextMenu("playerSpeed")
			wt.SetPosition(frames.playerSpeed.display, wt.AddMissing({ relativePoint = d.playerSpeed.position.anchor, }, d.playerSpeed.position))
			wt.ConvertToAbsolutePosition(frames.playerSpeed.display)
			SetDisplayValues("playerSpeed", d)

			--Travel Speed
			CreateContextMenu("travelSpeed")
			wt.SetPosition(frames.travelSpeed.display, wt.AddMissing({ relativePoint = d.travelSpeed.position.anchor, }, d.travelSpeed.position))
			wt.ConvertToAbsolutePosition(frames.travelSpeed.display)
			SetDisplayValues("travelSpeed", d)
		end,
		PLAYER_ENTERING_WORLD = function(self)
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")

			--Visibility notice
			if not self:IsVisible() or not frames[d.mainDisplay].display:IsVisible() then PrintStatus(true) end

			--Start speed updates
			UpdateMapInfo()
			UpdateSpeedText("player", d.playerSpeed.value.units, d.playerSpeed.font.valueColoring)
			UpdateSpeedText("travel", d.travelSpeed.value.units, d.travelSpeed.font.valueColoring)
			UpdateSpeedText("target", d.targetSpeed.value.units, true)
			if not d.playerSpeed.visibility.hidden then StartSpeedDisplayUpdates("playerSpeed") end
			if not d.travelSpeed.visibility.hidden then StartSpeedDisplayUpdates("travelSpeed") end
			if d.targetSpeed.enabled then EnableTargetSpeedUpdates() end
		end,
		ZONE_CHANGED_NEW_AREA = function() UpdateMapInfo() end,
		PET_BATTLE_OPENING_START = function(self) self:Hide() end,
		PET_BATTLE_CLOSE = function(self) self:Show() end,
	},
	events = {
		OnShow = function()
			frames.playerSpeed.display:Hide()
			frames.travelSpeed.display:Hide()
		end,
		OnHide = function()
			if not d.playerSpeed.visibility.hidden then frames.playerSpeed.display:Hide() end
			if not d.travelSpeed.visibility.hidden then frames.travelSpeed.display:Hide() end
		end
	},
	initialize = function(frame)

		--| Player Speed

		frames.playerSpeed.display = wt.CreateBaseFrame({
			parent = UIParent,
			name = ns.name .. "PlayerSpeed",
			customizable = true,
			events = { OnUpdate = function(self)
				--Update the tooltip
				if self:IsMouseOver() and ns.tooltip:IsVisible() then wt.UpdateTooltip(self, { lines = GetSpeedDisplayTooltipLines("player"), }) end
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

				--Text
				frames.playerSpeed.text = wt.CreateText({
					parent = display,
					layer = "OVERLAY",
					wrap = false,
				})
			end,
		})

		frames.playerSpeed.updater = wt.CreateBaseFrame({
			parent = frame,
			name = "PlayerSpeedUpdater",
		})

		--| Travel Speed

		frames.travelSpeed.display = wt.CreateBaseFrame({
			parent = UIParent,
			name = ns.name .. "TravelSpeed",
			customizable = true,
			events = { OnUpdate = function(self)
				--Update the tooltip
				if self:IsMouseOver() and ns.tooltip:IsVisible() then wt.UpdateTooltip(self, { lines = GetSpeedDisplayTooltipLines("travel"), }) end
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

				--Text
				frames.travelSpeed.text = wt.CreateText({
					parent = display,
					layer = "OVERLAY",
					wrap = false,
				})
			end
		})

		frames.travelSpeed.updater = wt.CreateBaseFrame({
			parent = frame,
			name = "TravelSpeedUpdater",
		})

		--| Target Speed

		frames.targetSpeed = wt.CreateBaseFrame({
			parent = frame,
			name = "TargetSpeedUpdater",
		})
	end
})