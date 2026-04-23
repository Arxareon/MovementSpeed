--| Namespace

---@class addonNamespace
local ns = select(2, ...)

--| Shortcuts

local cr = C_ColorUtil.WrapTextInColor

---@type toolbox
local wt = ns[C_AddOns.GetAddOnMetadata(ns.name, "X-WidgetTools-AddToNamespace")]

---@type widgetToolsResources
local rs = WidgetTools.resources

---@type widgetToolsUtilities
local us = WidgetTools.utilities

--| Locals

---@class main
local main = {}

---@class speedDisplay
local playerSpeed = {
	yards = 0,
	percent = 0,
	coords = { x = 0, y = 0 },
}

---@class speedDisplay
local travelSpeed = {
	yards = 0,
	percent = 0,
	coords = { x = 0, y = 0 },
}

---@type { playerSpeed: speedDisplay, travelSpeed: speedDisplay, }
local speedDisplay = { playerSpeed = playerSpeed, travelSpeed = travelSpeed, }
local displays = { "playerSpeed", "travelSpeed", }

---@class targetSpeed
local targetSpeed = {
	yards = 0,
	percent = 0,
	coords = { x = 0, y = 0 },
}

---@class options : { playerSpeed: speedDisplayOptions, travelSpeed: speedDisplayOptions, }
local options = {}

---@type profilemanager|profilesPage|{ data: profileData }
local profiles

---@type chatCommandManager
local chatCommands

--| Properties

local update = {}

--Speed text templates
local speedText = {}

--Accumulated time since the last speed update
local timeSinceSpeedUpdate = { playerSpeed = 0, travelSpeed = 0, }

--Player position at the last Travel Speed update
local pastPosition = CreateVector2D(0, 0)

---@type Vector2DMixin|nil
local currentPosition

--Map info
local map = { size = { w = 0, h = 0 } }


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

---Print visibility info
---@param display displayType
local function PrintStatus(display)
	print(cr((main.frame:IsVisible() and (
		not speedDisplay[display].frame:IsVisible() and ns.strings.chat.status.notVisible or ns.strings.chat.status.visible
	) or ns.strings.chat.status.hidden):gsub("#TYPE", ns.strings.options[display].title):gsub("#AUTO", ns.strings.chat.status.auto:gsub("#STATE", cr(
		profiles.data[display].visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[1]
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
---@param units? [boolean, boolean, boolean] ***Default:*** **profiles.data[type].value.units**
---@param colors? speedColorList ***Default:*** **profiles.data[type].font.colors**
local function FormatSpeedText(type, units, colors)
	units = units or profiles.data[type].value.units
	colors = colors or profiles.data[type].font.colors
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
	if units[3] then
		speedText[type] = speedText[type] .. ns.strings.speedValue.separator .. cr(ns.strings.speedValue.cps:gsub(
			"#COORDS", cr(ns.strings.speedValue.coordPair, secondaryColors.coords)
		), colors.coords)
	end

	speedText[type] = speedText[type]:gsub("^" .. ns.strings.speedValue.separator, "")
end

---Return the specified speed textline with placeholders replaced by formatted speed values
---@param speed speedDisplay|targetSpeed
---@param type speedType
---@return string
local function GetSpeedText(speed, type)
	local f = max(profiles.data[type].value.fractionals, 1)

	return speedText[type]:gsub(
		"#PERCENT", us.Thousands(speed.percent, profiles.data[type].value.fractionals, true, not profiles.data[type].value.zeros)
	):gsub(
		"#YARDS", us.Thousands(speed.yards, profiles.data[type].value.fractionals, true, not profiles.data[type].value.zeros)
	):gsub(
		"#X", us.Thousands(speed.coords.x, f, true, not profiles.data[type].value.zeros)
	):gsub(
		"#Y", us.Thousands(speed.coords.y, f, true, not profiles.data[type].value.zeros)
	)
end

--Update the Player Speed values
function update.playerSpeed()
	local advanced, _, flightSpeed = C_PlayerInfo.GetGlidingInfo()
	local r = GetPlayerFacing() or 0
	playerSpeed.yards = advanced and flightSpeed or GetUnitSpeed(UnitInVehicle("player") and "vehicle" or "player")

	if issecretvalue(playerSpeed.yards) then
		playerSpeed.yards = -1
		playerSpeed.percent = -1
		playerSpeed.coords.x, playerSpeed.coords.y = -1, -1
	else
		playerSpeed.percent = playerSpeed.yards / BASE_MOVEMENT_SPEED * 100
		playerSpeed.coords.x, playerSpeed.coords.y = playerSpeed.yards / (map.size.w / 100) * -math.sin(r), playerSpeed.yards / (map.size.h / 100) * math.cos(r)
	end

	--Hide when stationery
	if playerSpeed.yards == 0 and profiles.data.playerSpeed.visibility.autoHide then
		playerSpeed.frame:Hide()

		return
	else playerSpeed.frame:Show() end

	--Update the display text
	playerSpeed.text:SetText(" " .. GetSpeedText(playerSpeed, "playerSpeed"):gsub("-1", "X"))
end

---Updates the Travel Speed values since the last sample
---@param deltaTime number Time since last update
function update.travelSpeed(deltaTime)
	currentPosition = map.id and C_Map.GetPlayerMapPosition(map.id, "player") or nil

	if currentPosition and pastPosition.x then
		local dX, dY, dT = pastPosition.x - currentPosition.x, pastPosition.y - currentPosition.y, max(deltaTime, 0.01)
		travelSpeed.yards = math.sqrt((dX * map.size.w) ^ 2 + (dY * map.size.h) ^ 2) / dT
		travelSpeed.percent = travelSpeed.yards / BASE_MOVEMENT_SPEED * 100
		travelSpeed.coords.x = dX * -100 / dT
		travelSpeed.coords.y = dY * 100 / dT
	else
		travelSpeed.yards = -1
		travelSpeed.percent = -1
		travelSpeed.coords.x, travelSpeed.coords.y = -1, -1
	end

	if currentPosition then pastPosition:SetXY(currentPosition:GetXY()) end

	--Hide when stationery
	if profiles.data.travelSpeed.visibility.autoHide and travelSpeed.yards == 0 then
		travelSpeed.frame:Hide()

		return
	else travelSpeed.frame:Show() end

	--Update the display text
	travelSpeed.text:SetText(" " .. GetSpeedText(travelSpeed, "travelSpeed"):gsub("-1", "X"))
end

--[ Speed Displays ]

---Set the size of the specified speed display (width is calculated based on the displayed speed value types)
---@param display speedDisplay
---@param displayData displayData
---@param height? number Text height | ***Default:*** `display.text:GetStringHeight()`
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
	display.frame:SetSize(height * ratio * 1.2 - 4, height)
end

---Set the backdrop of the specified speed display elements
---@param display speedDisplay
---@param backgroundData displayBackgroundData
local function SetDisplayBackdrop(display, backgroundData)
	wt.SetBackdrop(display.frame, backgroundData.visible and {
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
---@param display speedDisplay
---@param displayData displayData
local function SetDisplayValues(display, displayData)
	--Position
	display.frame:SetClampedToScreen(displayData.keepInBounds)

	--Visibility
	display.frame:SetFrameStrata(displayData.layer.strata)
	wt.SetVisibility(display.frame, not displayData.visibility.hidden)

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

local playerSpeedTooltipLines, travelSpeedTooltipLines

--Assemble the detailed text lines for the tooltip of the Player Speed display
local function GetPlayerSpeedTooltipLines()
	playerSpeedTooltipLines = {
		{ text = ns.strings.speedTooltip.description },
		{ text = "\n" .. ns.strings.speedTooltip.playerSpeed, },
		{
			text = "\n" .. (playerSpeed.yards == -1 and (ns.strings.error.combat .. "\n\n") or "") ,
			font = GameTooltipText,
			color = { r = 0.92, g = 0.34, b = 0.23 },
		},
		{
			text = ns.strings.speedTooltip.text[1]:gsub(
				"#YARDS", cr(us.Thousands(playerSpeed.yards, 2, true),  ns.colors.yellow[2])
			):gsub("-1", "X"),
			font = GameTooltipText,
			color = ns.colors.yellow[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.text[2]:gsub(
				"#PERCENT", cr(us.Thousands(playerSpeed.percent, 2, true) .. "%%", ns.colors.green[2])
			):gsub("-1", "X"),
			font = GameTooltipText,
			color = ns.colors.green[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.text[3]:gsub(
				"#COORDS", cr(ns.strings.speedValue.coordPair:gsub(
					"#X", us.Thousands(playerSpeed.coords.x, 2, true)
				):gsub(
					"#Y", us.Thousands(playerSpeed.coords.y, 2, true)
				), ns.colors.blue[2])
			):gsub("-1", "X"),
			font = GameTooltipText,
			color = ns.colors.blue[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.mapTitle:gsub("#MAP", cr(map.name, { r = 1, g = 1, b = 1 })),
			color = NORMAL_FONT_COLOR,
		},
		{
			text = ns.strings.speedTooltip.mapSize:gsub(
				"#SIZE", cr(ns.strings.speedTooltip.mapSizeValues:gsub(
					"#W", cr(us.Thousands(map.size.w, 2), { r = 1, g = 1, b = 1 })
				):gsub(
					"#H", cr(us.Thousands(map.size.h, 2), { r = 1, g = 1, b = 1 })
				), rs.colors.grey[2])
			),
			color = NORMAL_FONT_COLOR,
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

--Assemble the detailed text lines for the tooltip of the Travel Speed display
local function GetTravelSpeedTooltipLines()
	travelSpeedTooltipLines = {
		{ text = ns.strings.speedTooltip.description },
		{ text = "\n" .. ns.strings.speedTooltip.travelSpeed, },
		{
			text = "\n" .. (not pastPosition.x and (ns.strings.error.instance .. "\n\n") or "") ,
			font = GameTooltipText,
			color = { r = 0.92, g = 0.34, b = 0.23 },
		},
		{
			text = ns.strings.speedTooltip.text[1]:gsub(
				"#YARDS", cr(us.Thousands(travelSpeed.yards, 2, true), ns.colors.yellow[2])
			):gsub("-1", "X"),
			font = GameTooltipText,
			color = ns.colors.yellow[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.text[2]:gsub(
				"#PERCENT", cr(us.Thousands(travelSpeed.percent, 2, true) .. "%%", ns.colors.green[2])
			):gsub("-1", "X"),
			font = GameTooltipText,
			color = ns.colors.green[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.text[3]:gsub(
				"#COORDS", cr(ns.strings.speedValue.coordPair:gsub(
					"#X", us.Thousands(travelSpeed.coords.x, 2, true)
				):gsub(
					"#Y", us.Thousands(travelSpeed.coords.y, 2, true)
				), ns.colors.blue[2])
			):gsub("-1", "X"),
			font = GameTooltipText,
			color = ns.colors.blue[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.mapTitle:gsub("#MAP", cr(map.name, { r = 1, g = 1, b = 1 })),
			color = NORMAL_FONT_COLOR,
		},
		{
			text = ns.strings.speedTooltip.mapSize:gsub(
				"#SIZE", cr(ns.strings.speedTooltip.mapSizeValues:gsub(
					"#W", cr(us.Thousands(map.size.w, 2), { r = 1, g = 1, b = 1 })
				):gsub(
					"#H", cr(us.Thousands(map.size.h, 2), { r = 1, g = 1, b = 1 })
				), rs.colors.grey[2])
			),
			color = NORMAL_FONT_COLOR,
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

	return travelSpeedTooltipLines
end

--| Toggle updates

---Start updating the specified speed display
---@param display displayType
local function StartSpeedDisplayUpdates(display)
	--Update the speed values at start
	update[display](timeSinceSpeedUpdate[display])

	--| Repeated updates

	speedDisplay[display].updateFrame:SetScript("OnUpdate", function(_, deltaTime) if profiles.data[display].update.throttle then
		timeSinceSpeedUpdate[display] = timeSinceSpeedUpdate[display] + deltaTime

		if timeSinceSpeedUpdate[display] < profiles.data[display].update.frequency then return else
			update[display](timeSinceSpeedUpdate[display])

			timeSinceSpeedUpdate[display] = 0
		end
	else update[display](deltaTime) end end)
end

---Stop updating the specified speed display
---@param display displayType
local function StopSpeedDisplayUpdates(display)
	speedDisplay[display].updateFrame:SetScript("OnUpdate", nil)
end

--[ Target Speed ]

---Assemble the text for the mouseover target's speed
---@return string
local function GetTargetSpeedText()
	return wt.Texture(ns.textures.logo) .. " " .. ns.strings.targetSpeed:gsub(
		"#SPEED", cr(GetSpeedText(targetSpeed, "targetSpeed"), profiles.data.targetSpeed.font.colors.base)
	)
end

--| Updates

local targetSpeedEnabled = false

--Set up the Target Speed unit tooltip integration
local function EnableTargetSpeedUpdates()
	local lineAdded, line

	targetSpeedEnabled = true

	--Start mouseover Target Speed updates
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
		if not profiles.data.targetSpeed.enabled then return end
		if IsInInstance() and not UnitIsFriend("player", "mouseover") then return end

		targetSpeed.frame:SetScript("OnUpdate", function()
			if UnitName("mouseover") == nil then return end

			--Update target speed values
			targetSpeed.yards = GetUnitSpeed("mouseover")

			if issecretvalue(targetSpeed.yards) then return end

			targetSpeed.percent = targetSpeed.yards / BASE_MOVEMENT_SPEED * 100
			targetSpeed.coords.x, targetSpeed.coords.y = targetSpeed.yards / (map.size.w / 100), targetSpeed.yards / (map.size.h / 100)

			--Find the speed line
			lineAdded = false
			for i = 2, tooltip:NumLines() do
				line = _G["GameTooltipTextLeft" .. i]

				if issecretvalue(line:GetText()) then return end

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
	GameTooltip:HookScript("OnTooltipCleared", function() targetSpeed.frame:SetScript("OnUpdate", nil) end)
end


--[[ INITIALIZATION ]]

--Create main addon frame & displays
main.frame = wt.CreateFrame({
	name = ns.name,
	position = {},
	onEvent = {
		ADDON_LOADED = function(self, addon)
			if addon ~= ns.name then return end

			self:UnregisterEvent("ADDON_LOADED")


			--[[ DATA ]]

			---@type database_warband
			MovementSpeedDB = MovementSpeedDB or {}

			---@type database_character
			MovementSpeedDBC = MovementSpeedDBC or {}

			---@type variables_warband
			MovementSpeedCS = us.Fill(MovementSpeedCS or {}, {
				compactBackup = true,
				playerSpeed = { keepInPlace = true, },
				travelSpeed = { keepInPlace = true, },
				mainDisplay = "playerSpeed",
			})

			---@type profilemanager|profilesPage|{ data: profileData }
			profiles = wt.CreateProfilemanager(MovementSpeedDB, MovementSpeedDBC, ns.profileDefault, {
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
				listeners = {
					activated = { { handler = function(_, _, title, success, user) if success and user then
						playerSpeed.settings.load(true)
						travelSpeed.settings.load(true)
						targetSpeed.settings.load(true)
						profiles.settings.load(true)

						chatCommands.print(ns.strings.chat.profile.response:gsub("#PROFILE", cr(title, ns.colors.yellow[2])))
					end end, }, },
					deleted = { { handler = function(_, success, _, title) if success then
						chatCommands.print(ns.strings.chat.delete.response:gsub("#PROFILE", cr(title, ns.colors.yellow[2])))
					end end, }, },
					reset = { { handler = function (_, success, _, title) if success then
						chatCommands.print(ns.strings.chat.reset.response:gsub("#PROFILE", cr(title, ns.colors.yellow[2])))
					end end, }, },
				},
			})


			--[[ SETTINGS ]]

			local fontColors = {
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
				base = { name = ns.strings.options.speedValue.base, }
			}

			--| Speed value types

			local valueTypes = {}

			for i = 1, #ns.strings.options.speedValue.units.list do
				valueTypes[i] = {}
				valueTypes[i].title = ns.strings.options.speedValue.units.list[i].label
				valueTypes[i].tooltip = { lines = { { text = ns.strings.options.speedValue.units.list[i].tooltip, }, } }
			end

			--[ Addon ]

			main.settings = wt.CreateAboutPage(ns.name, {
				register = true,
				name = "Main",
				description = ns.strings.options.main.description:gsub("#ADDON", ns.title),
				changelog = ns.changelog
			})

			--[ Speed Displays ]

			for type = 1, #displays do
				local displayType = displays[type]
				local displayName = ns.strings.options[displayType].title:gsub("%s+", "")

				---@class speedDisplay
				local display = speedDisplay[displayType]

				---@type customButtonCreationData
				local copyButtonData = {
					name = "Copy",
					title =  ns.strings.options.speedDisplay.copy.label:gsub("#TYPE", ns.strings.options[displays[3 - type]].title),
					tooltip = { lines = { { text = ns.strings.options.speedDisplay.copy.tooltip:gsub("#TYPE", ns.strings.options[displays[3 - type]].title), }, } },
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
					backdropUpdates = { { rules = {
						OnEnter = function(frame)
							if not frame:IsEnabled() then return {} end

							return IsMouseButtonDown("LeftButton") and {
								background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
								border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
							} or {
								background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
								border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
							}
						end,
						OnLeave = function(frame)
							if not frame:IsEnabled() then return {} end

							return {}, true
						end,
						OnMouseDown = function(frame)
							if not frame:IsEnabled() then return {} end

							return IsMouseButtonDown("LeftButton") and {
								background = { color = { r = 0.06, g = 0.06, b = 0.06, a = 0.9 } },
								border = { color = { r = 0.42, g = 0.42, b = 0.42, a = 0.9 } }
							} or {}
						end,
						OnMouseUp = function(frame, trigger)
							if not frame:IsEnabled() then return {} end

							return frame:IsEnabled() and trigger:IsMouseOver() and {
								background = { color = { r = 0.15, g = 0.15, b = 0.15, a = 0.9 } },
								border = { color = { r = 0.8, g = 0.8, b = 0.8, a = 0.9 } }
							} or {}
						end,
					}, }, },
				}

				display.settings = wt.CreateSettingsPage(ns.name, {
					register = main.settings,
					name = displayName,
					title = ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options[displayType].title),
					description = ns.strings.options[displayType].description:gsub("#ADDON", ns.title),
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
							"#CATEGORY", cr(ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options[displayType].title), ns.colors.yellow[2])
						):gsub(
							"#PROFILE", cr(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].title, ns.colors.yellow[2])
						))

						if not category or displayType == "playerSpeed" then options[displayType].position.resetCustomPreset() else options[displayType].position.applyPreset(1) end
						if displayType == "travelSpeed" then options.travelSpeed.visibility.hidden.setState(true, true) end
					end,
					arrangement = {},
					initialize = function(canvas, _, _, category, keys)
						---@class speedDisplayOptions
						options[displayType] = {}


						--[[ VISIBILITY ]]

						local displayHiddenDependency

						wt.CreatePanel({
							parent = canvas,
							name = keys[6],
							title = ns.strings.options.speedDisplay.visibility.title,
							arrange = {},
							arrangement = {},
							initialize = function(panel, _, _, key)
								local hidden = wt.CreateCheckbox({
									parent = panel,
									name = "Hidden",
									title = ns.strings.options.speedDisplay.visibility.hidden.label,
									tooltip = { lines = {
										[1] = { text = ns.strings.options.speedDisplay.visibility.hidden.tooltip:gsub("#ADDON", ns.title), },
										[2] = displayType == "playerSpeed" and { text = "\n" .. ns.strings.error.combat, color = { r = 0.92, g = 0.34, b = 0.23 }, } or nil,
									} },
									arrange = {},
									getData = function() return profiles.data[displayType].visibility.hidden end,
									saveData = function(state) profiles.data[displayType].visibility.hidden = state end,
									default = ns.profileDefault[displayType].visibility.hidden,
									dataManagement = {
										category = category,
										key = key,
										onChange = { DisplayToggle = function()
											wt.SetVisibility(display.frame, not profiles.data[displayType].visibility.hidden)
											if profiles.data[displayType].visibility.hidden then
												StopSpeedDisplayUpdates(displayType)
											else StartSpeedDisplayUpdates(displayType) end
										end, },
									},
								})

								displayHiddenDependency = { frame = hidden, evaluate = function(state) return not state end }

								---@type speedDisplayOptions_visibility
								options[displayType].visibility = {
									hidden = hidden,
									autoHide = wt.CreateCheckbox({
										parent = panel,
										name = "AutoHide",
										title = ns.strings.options.speedDisplay.visibility.autoHide.label,
										tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.autoHide.tooltip, }, } },
										arrange = { wrap = false, },
										dependencies = { displayHiddenDependency, },
										getData = function() return profiles.data[displayType].visibility.autoHide end,
										saveData = function(state) profiles.data[displayType].visibility.autoHide = state end,
										default = ns.profileDefault[displayType].visibility.autoHide,
										dataManagement = {
											category = category,
											key = key,
										}
									}),
									status = wt.CreateCheckbox({
										parent = panel,
										name = "StatusNotice",
										title = ns.strings.options.speedDisplay.visibility.statusNotice.label,
										tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.statusNotice.tooltip, }, } },
										arrange = { wrap = false, },
										getData = function() return profiles.data[displayType].visibility.statusNotice end,
										saveData = function(state)
											profiles.data[displayType].visibility.statusNotice = state
										end,
										default = ns.profileDefault[displayType].visibility.statusNotice,
										dataManagement = {
											category = category,
											key = key,
										},
									}),
								}

								wt.CreateCustomButton(us.Fill({
									parent = panel,
									action = function()
										us.CopyValues(profiles.data[displayType].visibility, profiles.data[displays[3 - type]].visibility)
										wt.LoadSettingsData(category, key, true)
									end,
									dependencies = { displayHiddenDependency, },
								}, copyButtonData))
							end,
						})


						--[[ POSITION ]]

						---@type positionPanel
						options[displayType].position = wt.CreatePositionOptions(ns.name, display.frame, function()
							return profiles.data[displayType]
						end, ns.profileDefault[displayType], MovementSpeedCS[displayType], {
							canvas = canvas,
							name = ns.strings.options.speedDisplay.referenceName:gsub("#TYPE", ns.strings.options[displayType].title),
							presets = {
								items = {
									{ title = CUSTOM, }, --Custom
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
										title = ns.strings.presets[2]:gsub("#TYPE", ns.strings.options[displays[3 - type]].title), --Under the other display
										data = {
											position = {
												anchor = "TOP",
												relativeTo = speedDisplay[displays[3 - type]].frame,
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
										title = ns.strings.presets[3]:gsub("#TYPE", ns.strings.options[displays[3 - type]].title), --Above the other display
										data = {
											position = {
												anchor = "BOTTOM",
												relativeTo = speedDisplay[displays[3 - type]].frame,
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
										title = ns.strings.presets[4]:gsub("#TYPE", ns.strings.options[displays[3 - type]].title), --Right of the other display
										data = {
											position = {
												anchor = "LEFT",
												relativeTo = speedDisplay[displays[3 - type]].frame,
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
										title = ns.strings.presets[5]:gsub("#TYPE", ns.strings.options[displays[3 - type]].title), --Left of the other display
										data = {
											position = {
												anchor = "RIGHT",
												relativeTo = speedDisplay[displays[3 - type]].frame,
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
								onPreset = function(preset)
									--Make sure the speed display is visible
									options[displayType].visibility.hidden.setData(false)

									chatCommands.print(ns.strings.chat.preset.response:gsub(
										"#PRESET", cr(preset.title, ns.colors.yellow[2])
									):gsub("#TYPE", ns.strings.options[displayType].title))
								end,
								custom = {
									getData = function() return profiles.data.customPreset end,
									defaultsTable = ns.profileDefault.customPreset,
									onSave = function() chatCommands.print(ns.strings.chat.save.response:gsub(
										"#TYPE", ns.strings.options[displayType].title
									):gsub("#CUSTOM", cr(CUSTOM, ns.colors.yellow[2]))) end,
									onReset = function() chatCommands.print(ns.strings.chat.reset.response:gsub("#CUSTOM", cr(CUSTOM, ns.colors.yellow[2]))) end
								}
							},
							setMovable = { events = {
								onStop = function() chatCommands.print(ns.strings.chat.position.save:gsub("#TYPE", ns.strings.options[displayType].title)) end,
								onCancel = function()
									chatCommands.print(ns.strings.chat.position.cancel:gsub("#TYPE", ns.strings.options[displayType].title))
									print(cr(ns.strings.chat.position.error, ns.colors.yellow[2]))
								end,
							}, },
							dependencies = { displayHiddenDependency, },
							dataManagement = { category = ns.name .. displayName, },
						})

						if options[displayType].position.frame.description then options[displayType].position.frame.description:SetWidth(328) end

						wt.CreateCustomButton(us.Fill({
							parent = options[displayType].position.frame,
							action = function()
								us.CopyValues(profiles.data[displayType].position, profiles.data[displays[3 - type]].position)
								wt.LoadSettingsData(category, keys[5], true)
							end,
							dependencies = { displayHiddenDependency, },
						}, copyButtonData))


						--[[ UPDATES ]]

						wt.CreatePanel({
							parent = canvas,
							name = keys[4],
							title = ns.strings.options.speedDisplay.update.title,
							arrange = {},
							arrangement = {},
							initialize = function(panel, _, _, key)
								local throttle = wt.CreateCheckbox({
									parent = panel,
									name = "Throttle",
									title = ns.strings.options.speedDisplay.update.throttle.label,
									tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.throttle.tooltip, }, } },
									arrange = {},
									dependencies = { displayHiddenDependency, },
									getData = function() return profiles.data[displayType].update.throttle end,
									saveData = function(state) profiles.data[displayType].update.throttle = state end,
									default = ns.profileDefault[displayType].update.throttle,
									dataManagement = {
										category = category,
										key = key,
									},
								})

								---@type speedDisplayOptions_update
								options[displayType].update = {
									throttle = throttle,
									frequency = wt.CreateSlider({
										parent = panel,
										name = "Frequency",
										title = ns.strings.options.speedDisplay.update.frequency.label,
										tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.frequency.tooltip, }, } },
										arrange = { wrap = false, },
										min = 0.05,
										max = 1,
										step = 0.05,
										altStep = 0.2,
										dependencies = {
											displayHiddenDependency,
											{ frame = throttle },
										},
										getData = function() return profiles.data[displayType].update.frequency end,
										saveData = function(value)
											profiles.data[displayType].update.frequency = us.Round(value, 2)
										end,
										default = ns.profileDefault[displayType].update.frequency,
										dataManagement = {
											category = category,
											key = key,
										},
									}),
								}

								wt.CreateCustomButton(us.Fill({
									parent = panel,
									action = function()
										us.CopyValues(profiles.data[displayType].update, profiles.data[displays[3 - type]].update)
										wt.LoadSettingsData(category, key, true)
									end,
									dependencies = { displayHiddenDependency, },
								}, copyButtonData))
							end,
						})


						--[[ VALUE ]]

						wt.CreatePanel({
							parent = canvas,
							name = keys[3],
							title = ns.strings.options.speedValue.title,
							arrange = {},
							arrangement = {},
							initialize = function(panel, _, _, key)
								local fractionals = wt.CreateSlider({
										parent = panel,
										name = "Fractionals",
										title = ns.strings.options.speedValue.fractionals.label,
										tooltip = { lines = { { text = ns.strings.options.speedValue.fractionals.tooltip, }, } },
										arrange = { wrap = false, },
										min = 0,
										max = 4,
										step = 1,
										dependencies = { displayHiddenDependency, },
										getData = function() return profiles.data[displayType].value.fractionals end,
										saveData = function(value) profiles.data[displayType].value.fractionals = value end,
										default = ns.profileDefault[displayType].value.fractionals,
										dataManagement = {
											category = category,
											key = key,
											onChange = { "UpdateDisplaySize", },
										},
									})

								---@type speedValueOptions
								options[displayType].value = {
									units = wt.CreateCheckgroup({
										parent = panel,
										name = "Units",
										title = ns.strings.options.speedValue.units.label,
										tooltip = { lines = { { text = ns.strings.options.speedValue.units.tooltip, }, } },
										arrange = { index = 1, },
										items = valueTypes,
										limits = { min = 1, },
										dependencies = { displayHiddenDependency, },
										getData = function() return profiles.data[displayType].value.units end,
										saveData = function(selections) profiles.data[displayType].value.units = selections end,
										default = ns.profileDefault[displayType].value.units,
										dataManagement = {
											category = category,
											key = key,
											onChange = {
												UpdateDisplaySize = function()
													SetDisplaySize(display, profiles.data[displayType])
												end,
												UpdateSpeedTextTemplate = function() FormatSpeedText(displayType) end,
											},
										},
									}),
									fractionals = fractionals,
									zeros = wt.CreateCheckbox({
										parent = panel,
										name = "Zeros",
										title = ns.strings.options.speedValue.zeros.label,
										tooltip = { lines = { { text = ns.strings.options.speedValue.zeros.tooltip, }, } },
										arrange = { wrap = false, },
										autoOffset = true,
										dependencies = {
											displayHiddenDependency,
											{ frame = fractionals, evaluate = function(value) return value > 0 end },
										},
										getData = function() return profiles.data[displayType].value.zeros end,
										saveData = function(state) profiles.data[displayType].value.zeros = state end,
										default = ns.profileDefault[displayType].value.zeros,
										dataManagement = {
											category = category,
											key = key,
										},
									}),
								}

								wt.CreateCustomButton(us.Fill({
									parent = panel,
									action = function()
										us.CopyValues(profiles.data[displayType].value, profiles.data[displays[3 - type]].value)
										wt.LoadSettingsData(category, key, true)
									end,
									dependencies = { displayHiddenDependency, },
								}, copyButtonData))
							end,
						})


						--[[ FONT ]]

						---@type fontPanel
						options[displayType].font = wt.CreateFontOptions(ns.name, display.text, function()
							return profiles.data[displayType].font
						end, ns.profileDefault[displayType].font, {
							canvas = canvas,
							colors = fontColors,
							dependencies = { displayHiddenDependency, },
							dataManagement = { category = ns.name .. displayName, },
							onChangeFont = function()
								SetDisplaySize(display, profiles.data[displayType])
								FormatSpeedText(displayType)
							end,
							onChangeSize = function() SetDisplaySize(display, profiles.data[displayType]) end,
							onChangeAlignment = function() wt.SetPosition(display.text, {
								anchor = profiles.data[displayType].font.alignment,
							}) end,
							onChangeColor = function() FormatSpeedText(displayType) end,
						})

						wt.CreateCustomButton(us.Fill({
							parent = options[displayType].font.frame,
							action = function()
								us.CopyValues(profiles.data[displayType].font, profiles.data[displays[3 - type]].font)
								wt.LoadSettingsData(category, keys[1], true)
							end,
							dependencies = { displayHiddenDependency, },
						}, copyButtonData))


						--[[ BACKGROUND ]]

						wt.CreatePanel({
							parent = canvas,
							name = keys[2],
							title = ns.strings.options.speedDisplay.background.title,
							arrange = {},
							arrangement = {},
							initialize = function(panel, _, _, key)
								local visible = wt.CreateCheckbox({
									parent = panel,
									name = "Visible",
									title = ns.strings.options.speedDisplay.background.visible.label,
									tooltip = { lines = { { text = ns.strings.options.speedDisplay.background.visible.tooltip, }, } },
									arrange = {},
									dependencies = { displayHiddenDependency, },
									getData = function() return profiles.data[displayType].background.visible end,
									saveData = function(state) profiles.data[displayType].background.visible = state end,
									default = ns.profileDefault[displayType].background.visible,
									dataManagement = {
										category = category,
										key = key,
										onChange = { ToggleDisplayBackdrops = function()
											SetDisplayBackdrop(display, profiles.data[displayType].background)
										end, },
									},
								})

								---@type speedDisplayOptions_background
								options[displayType].background = {
									visible = visible,
									colors = {
										bg = wt.CreateColorpicker({
											parent = panel,
											name = "Color",
											title = ns.strings.options.speedDisplay.background.colors.bg.label,
											tooltip = {},
											arrange = { wrap = false, },
											dependencies = {
												displayHiddenDependency,
												{ frame = visible, },
											},
											getData = function() return profiles.data[displayType].background.colors.bg end,
											saveData = function(color) profiles.data[displayType].background.colors.bg = color end,
											default = ns.profileDefault[displayType].background.colors.bg,
											dataManagement = {
												category = category,
												key = key,
												onChange = { UpdateDisplayBackgroundColor = function() if display.frame:GetBackdrop() ~= nil then
													display.frame:SetBackdropColor(wt.UnpackColor(profiles.data[displayType].background.colors.bg))
												end end },
											},
										}),
										border = wt.CreateColorpicker({
											parent = panel,
											name = "BorderColor",
											title = ns.strings.options.speedDisplay.background.colors.border.label,
											tooltip = {},
											arrange = { wrap = false, },
											dependencies = {
												displayHiddenDependency,
												{ frame = visible, },
											},
											getData = function() return profiles.data[displayType].background.colors.border end,
											saveData = function(color) profiles.data[displayType].background.colors.border = color end,
											default = ns.profileDefault[displayType].background.colors.border,
											dataManagement = {
												category = category,
												key = key,
												onChange = { UpdateDisplayBorderColor = function() if display.frame:GetBackdrop() ~= nil then
													display.frame:SetBackdropBorderColor(wt.UnpackColor(profiles.data[displayType].background.colors.border))
												end end },
											},
										}),
									},
								}

								wt.CreateCustomButton(us.Fill({
									parent = panel,
									action = function()
										us.CopyValues(profiles.data[displayType].background, profiles.data[displays[3 - type]].background)
										wt.LoadSettingsData(category, key, true)
									end,
									dependencies = { displayHiddenDependency, },
								}, copyButtonData))
							end,
						})
					end,
				})
			end

			--[ Target Speed ]

			targetSpeed.settings = wt.CreateSettingsPage(ns.name, {
				register = main.settings,
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
					options.targetSpeed = {}

					wt.CreatePanel({
						parent = canvas,
						name = "Mouseover",
						title = ns.strings.options.targetSpeed.mouseover.title,
						arrange = {},
						arrangement = {},
						initialize = function(panel) options.targetSpeed.enabled = wt.CreateCheckbox({
							parent = panel,
							name = "Enabled",
							title = ns.strings.options.targetSpeed.mouseover.enabled.label,
							tooltip = { lines = {
								{ text = ns.strings.options.targetSpeed.mouseover.enabled.tooltip:gsub("#ADDON", ns.title), },
								{ text = "\n" .. ns.strings.error.combat, color = { r = 0.92, g = 0.34, b = 0.23 }, },
							} },
							arrange = {},
							getData = function() return profiles.data.targetSpeed.enabled end,
							saveData = function(state) profiles.data.targetSpeed.enabled = state end,
							default = ns.profileDefault.targetSpeed.enabled,
							dataManagement = {
								category = category,
								key = keys[1],
								onChange = { EnableTargetSpeedUpdates = function() if not targetSpeedEnabled then EnableTargetSpeedUpdates() end end, },
							},
						}) end,
					})

					wt.CreatePanel({
						parent = canvas,
						name = "Value",
						title = ns.strings.options.speedValue.title,
						arrange = {},
						arrangement = {},
						initialize = function(panel)
							local fractionals = wt.CreateSlider({
								parent = panel,
								name = "Fractionals",
								title = ns.strings.options.speedValue.fractionals.label,
								tooltip = { lines = { { text = ns.strings.options.speedValue.fractionals.tooltip, }, } },
								arrange = { wrap = false, },
								min = 0,
								max = 4,
								step = 1,
								dependencies = { { frame = options.targetSpeed.enabled, }, },
								getData = function() return profiles.data.targetSpeed.value.fractionals end,
								saveData = function(value) profiles.data.targetSpeed.value.fractionals = value end,
								default = ns.profileDefault.targetSpeed.value.fractionals,
								dataManagement = {
									category = category,
									key = keys[1],
								},
							})

							options.targetSpeed.value = {
								units = wt.CreateCheckgroup({
									parent = panel,
									name = "Units",
									title = ns.strings.options.speedValue.units.label,
									tooltip = { lines = { { text = ns.strings.options.speedValue.units.tooltip, }, } },
									arrange = { index = 1, },
									items = valueTypes,
									limits = { min = 1, },
									dependencies = { { frame = options.targetSpeed.enabled, }, },
									getData = function() return profiles.data.targetSpeed.value.units end,
									saveData = function(selections) profiles.data.targetSpeed.value.units = selections end,
									default = ns.profileDefault.targetSpeed.value.units,
									dataManagement = {
										category = category,
										key = keys[1],
										onChange = { UpdateTargetSpeedTextTemplate = function() FormatSpeedText("targetSpeed") end, },
									},
								}),
								fractionals = fractionals,
								zeros = wt.CreateCheckbox({
									parent = panel,
									name = "Zeros",
									title = ns.strings.options.speedValue.zeros.label,
									tooltip = { lines = { { text = ns.strings.options.speedValue.zeros.tooltip, }, } },
									arrange = { wrap = false, },
									autoOffset = true,
									dependencies = {
										{ frame = options.targetSpeed.enabled, },
										{ frame = fractionals, evaluate = function(value) return value > 0 end },
									},
									getData = function() return profiles.data.targetSpeed.value.zeros end,
									saveData = function(state) profiles.data.targetSpeed.value.zeros = state end,
									default = ns.profileDefault.targetSpeed.value.zeros,
									dataManagement = {
										category = category,
										key = keys[1],
									},
								}),
							}
						end,
					})

					wt.CreatePanel({
						parent = canvas,
						name = "Font",
						title = wt.strings.font.title,
						arrange = {},
						arrangement = {},
						initialize = function(panel)
							options.targetSpeed.font = { colors = {} }

							for k, v in pairs(fontColors) do if type(v) == "table" then
								options.targetSpeed.font.colors[k] = wt.CreateColorpicker({
									parent = panel,
									name = "Color",
									title = wt.strings.font.color.label:gsub("#COLOR_TYPE", v.name),
									tooltip = { lines = { { text = wt.strings.font.color.tooltip:gsub("#COLOR_TYPE", v.name), }, } },
									arrange = { wrap = false, index = v.index },
									dependencies = { { frame = options.targetSpeed.enabled, }, },
									getData = function() return profiles.data.targetSpeed.font.colors[k] end,
									saveData = function(value) profiles.data.targetSpeed.font.colors[k] = value end,
									default = ns.profileDefault.targetSpeed.font.colors[k],
									dataManagement = {
										category = category,
										key = keys[1],
										onChange = { UpdateTargetSpeedText = function() FormatSpeedText("targetSpeed") end, },
									},
								})
							end end
						end
					})
				end,
			})

			--[ Profiles ]

			---@type profilemanager|profilesPage|{ data: profileData }
			profiles = wt.CreateProfilesPage(ns.name, MovementSpeedDB, MovementSpeedDBC, ns.profileDefault, MovementSpeedCS, {
				register = main.settings,
				onImport = function(success) if success then
					--Update the interface options
					playerSpeed.settings.load(true)
					travelSpeed.settings.load(true)
					targetSpeed.settings.load(true)
					profiles.settings.load(true)
				else chatCommands.print(wt.strings.backup.error) end end,
				onImportAllProfiles = function(success) if not success then chatCommands.print(wt.strings.backup.error) end end,
			}, profiles)


			--[[ CHAT CONTROL ]]

			---@type chatCommandManager
			chatCommands = wt.RegisterChatCommands(ns.name, ns.chat.keywords, {
				commands = {
					{
						command = ns.chat.commands.options,
						description = ns.strings.chat.options.description:gsub("#ADDON", ns.title),
						handler = main.settings.open,
					},
					{
						command = ns.chat.commands.preset,
						description = function()
							return (ns.strings.chat.preset.description:gsub(
								"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
							):gsub(
								"#INDEX", cr(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])
							))
						end,
						handler = function(_, p) return options[MovementSpeedCS.mainDisplay].position.applyPreset(tonumber(p)) end,
						error = ns.strings.chat.preset.unchanged .. "\n" .. cr(ns.strings.chat.preset.error:gsub(
							"#INDEX", cr(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])
						), ns.colors.yellow[2]),
						onError = function()
							print(cr(ns.strings.chat.preset.list, ns.colors.yellow[1]))

							for i = 1, #options[MovementSpeedCS.mainDisplay].position.presets, 2 do
								local list = "    " .. cr(tostring(i), ns.colors.green[2]) .. cr(" • " .. options[MovementSpeedCS.mainDisplay].position.presets[i].title, ns.colors.yellow[2])

								if i + 1 <= #options[MovementSpeedCS.mainDisplay].position.presets then
									list = list .. "    " .. cr(tostring(i + 1), ns.colors.green[2]) .. cr(" • " .. options[MovementSpeedCS.mainDisplay].position.presets[i + 1].title, ns.colors.yellow[2])
								end

								print(list)
							end
						end,
					},
					{
						command = ns.chat.commands.save,
						description = function()
							return (ns.strings.chat.save.description:gsub(
								"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
							):gsub(
								"#CUSTOM", cr(options[MovementSpeedCS.mainDisplay].position.presets[1].title, ns.colors.yellow[1])
							))
						end,
						handler = function() options[MovementSpeedCS.mainDisplay].position.saveCustomPreset() end,
					},
					{
						command = ns.chat.commands.reset,
						description = function()
							return (ns.strings.chat.reset.description:gsub(
								"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
							):gsub(
								"#CUSTOM", cr(options[MovementSpeedCS.mainDisplay].position.presets[1].title, ns.colors.yellow[1])
							))
						end,
						handler = function() options[MovementSpeedCS.mainDisplay].position.resetCustomPreset() end,
					},
					{
						command = ns.chat.commands.toggle,
						description = function() return (ns.strings.chat.toggle.description:gsub("#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title):gsub(
							"#HIDDEN", cr(profiles.data[MovementSpeedCS.mainDisplay].visibility.hidden and ns.strings.chat.toggle.hidden or ns.strings.chat.toggle.notHidden, ns.colors.yellow[1])
						)) end,
						handler = function()
							options[MovementSpeedCS.mainDisplay].visibility.hidden.setData(not profiles.data[MovementSpeedCS.mainDisplay].visibility.hidden)

							return true
						end,
						success = function() return ((profiles.data[MovementSpeedCS.mainDisplay].visibility.hidden and ns.strings.chat.toggle.hiding or ns.strings.chat.toggle.unhiding):gsub(
							"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
						)) end,
					},
					{
						command = ns.chat.commands.auto,
						description = function() return (ns.strings.chat.auto.description:gsub("#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title):gsub(
							"#STATE", cr(profiles.data[MovementSpeedCS.mainDisplay].visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[1])
						)) end,
						handler = function()
							options[MovementSpeedCS.mainDisplay].visibility.autoHide.setData(not profiles.data[MovementSpeedCS.mainDisplay].visibility.autoHide)

							return true
						end,
						success = function() return (ns.strings.chat.auto.response:gsub(
								"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
							):gsub(
								"#STATE", cr(profiles.data[MovementSpeedCS.mainDisplay].visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.yellow[2])
							))
						end,
					},
					{
						command = ns.chat.commands.size,
						description = function()
							return (ns.strings.chat.size.description:gsub(
								"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
							):gsub(
								"#SIZE", cr(ns.chat.commands.size .. " " .. ns.profileDefault[MovementSpeedCS.mainDisplay].font.size, ns.colors.green[2])
							))
						end,
						handler = function(_, p)
							local size = tonumber(p)

							if not size then return false end

							options[MovementSpeedCS.mainDisplay].font.widgets.size.setData(size)

							return true, size
						end,
						success = function(size) return (ns.strings.chat.size.response:gsub(
							"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
						):gsub("#VALUE", cr(size, ns.colors.yellow[2]))) end,
						error = function() return (ns.strings.chat.size.unchanged:gsub(
							"#TYPE", ns.strings.options[MovementSpeedCS.mainDisplay].title
						)) end,
						onError = function() print("    " .. cr(ns.strings.chat.size.error:gsub(
							"#SIZE", cr(ns.chat.commands.size .. " " .. ns.profileDefault[MovementSpeedCS.mainDisplay].font.size, ns.colors.green[2])
						), ns.colors.yellow[2])) end,
					},
					{
						command = ns.chat.commands.swap,
						description = function() return (ns.strings.chat.swap.description:gsub(
							"#ACTIVE", cr(ns.strings.options[MovementSpeedCS.mainDisplay].title, ns.colors.yellow[1])
						)) end,
						handler = function()
							MovementSpeedCS.mainDisplay = MovementSpeedCS.mainDisplay == "playerSpeed" and "travelSpeed" or "playerSpeed"

							return true
						end,
						success = function() return (ns.strings.chat.swap.response:gsub(
							"#ACTIVE", cr(ns.strings.options[MovementSpeedCS.mainDisplay].title, ns.colors.yellow[2])
						)) end,
					},
					{
						command = ns.chat.commands.profile,
						description = ns.strings.chat.profile.description:gsub(
							"#INDEX", cr(ns.chat.commands.profile .. " " .. 1, ns.colors.green[2])
						),
						handler = function(_, p) return profiles.activate(tonumber(p)) ~= nil end,
						error = ns.strings.chat.profile.unchanged .. "\n" .. cr(ns.strings.chat.profile.error:gsub(
							"#INDEX", cr(ns.chat.commands.profile .. " " .. 1, ns.colors.green[2])
						), ns.colors.yellow[2]),
						onError = function()
							print(cr(ns.strings.chat.profile.list, ns.colors.yellow[1]))
							for i = 1, #MovementSpeedDB.profiles, 4 do
								local list = "    " .. cr(tostring(i), ns.colors.green[2]) .. cr(" • " .. MovementSpeedDB.profiles[i].title, ns.colors.yellow[2])

								for j = i + 1, min(i + 3, #MovementSpeedDB.profiles) do
									list = list .. "    " .. cr(tostring(j), ns.colors.green[2]) .. cr(" • " .. MovementSpeedDB.profiles[j].title, ns.colors.yellow[2])
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
						handler = function() return profiles.reset() end,
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

			if profiles.firstLoad then chatCommands.welcome() end


			--[[ SPEED DISPLAY SETUP ]]

			for type = 1, #displays do
				local displayType = displays[type]

				wt.SetPosition(speedDisplay[displayType].frame, us.Fill({ relativePoint = profiles.data[displayType].position.anchor, }, profiles.data[displayType].position))
				wt.ConvertToAbsolutePosition(speedDisplay[displayType].frame)
				SetDisplayValues(speedDisplay[displayType], profiles.data[displayType])
				wt.CreateContextMenu({
					triggers = { { frame = speedDisplay[displayType].frame, }, },
					initialize = function(menu)
						wt.CreateMenuTextline(menu, { text = ns.title, })
						wt.CreateSubmenu(menu, { title = ns.strings.misc.options, initialize = function(optionsMenu)
							wt.CreateMenuButton(optionsMenu, {
								title = wt.strings.about.title,
								tooltip = { lines = { { text = ns.strings.options.main.description:gsub("#ADDON", ns.title), }, } },
								action = main.settings.open,
							})
							wt.CreateMenuButton(optionsMenu, {
								title = ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options.playerSpeed.title),
								tooltip = { lines = { { text = ns.strings.options.playerSpeed.description, }, } },
								action = playerSpeed.settings.open,
							})
							wt.CreateMenuButton(optionsMenu, {
								title = ns.strings.options.speedDisplay.title:gsub("#TYPE", ns.strings.options.travelSpeed.title),
								tooltip = { lines = { { text = ns.strings.options.travelSpeed.description:gsub("#ADDON", ns.title), }, } },
								action = travelSpeed.settings.open,
							})
							wt.CreateMenuButton(optionsMenu, {
								title = ns.strings.options.targetSpeed.title,
								tooltip = { lines = { { text = ns.strings.options.targetSpeed.description:gsub("#ADDON", ns.title), }, } },
								action = targetSpeed.settings.open,
							})
							wt.CreateMenuButton(optionsMenu, {
								title = wt.strings.dataManagement.title,
								tooltip = { lines = { { text = wt.strings.dataManagement.description:gsub("#ADDON", ns.title), }, } },
								action = profiles.settings.open,
							})
						end })
						wt.CreateSubmenu(menu, { title = wt.strings.presets.apply.label, initialize = function(presetsMenu)
							for i = 1, #options[displayType].position.presets do wt.CreateMenuButton(presetsMenu, {
								title = options[displayType].position.presets[i].title,
								action = function() options[displayType].position.applyPreset(i) end,
							}) end
						end })
					end
				})
			end
		end,
		PLAYER_ENTERING_WORLD = function(self)
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")

			UpdateMapInfo()

			FormatSpeedText("playerSpeed")
			FormatSpeedText("travelSpeed")
			FormatSpeedText("targetSpeed")

			--Start speed updates
			if not profiles.data.playerSpeed.visibility.hidden then StartSpeedDisplayUpdates("playerSpeed") end
			if not profiles.data.travelSpeed.visibility.hidden then StartSpeedDisplayUpdates("travelSpeed") end
			if profiles.data.targetSpeed.enabled then EnableTargetSpeedUpdates() end

			--Finish loading the active profile for new characters
			if profiles.newCharacter then
				--Update the interface options
				playerSpeed.settings.load(true)
				travelSpeed.settings.load(true)
				targetSpeed.settings.load(true)
				profiles.settings.load(true)

				chatCommands.print(ns.strings.chat.profile.response:gsub("#PROFILE", cr(MovementSpeedDB.profiles[MovementSpeedDBC.activeProfile].title, ns.colors.yellow[2])))
			end

			--Visibility notice
			if not playerSpeed.frame:IsVisible() and profiles.data.playerSpeed.visibility.statusNotice then
				PrintStatus("playerSpeed")
			end
			if not travelSpeed.frame:IsVisible() and profiles.data.travelSpeed.visibility.statusNotice then
				PrintStatus("travelSpeed")
			end
		end,
		ZONE_CHANGED_NEW_AREA = function() UpdateMapInfo() end,
		PET_BATTLE_OPENING_START = function(self) self:Hide() end,
		PET_BATTLE_CLOSE = function(self) self:Show() end,
	},
	events = {
		OnShow = function()
			if not profiles.data.playerSpeed.visibility.hidden then playerSpeed.frame:Show() end
			if not profiles.data.travelSpeed.visibility.hidden then travelSpeed.frame:Show() end
		end,
		OnHide = function()
			playerSpeed.frame:Hide()
			travelSpeed.frame:Hide()
		end
	},
	initialize = function(frame, _, _, name)
		local tooltip = wt.CreateGameTooltip(ns.name)

		--| Speed Displays

		for type = 1, #displays do
			local displayType = displays[type]
			local displayTypeName = (displayType:sub(1, 1):upper() .. displayType:sub(2))

			---@class speedDisplay
			local display = speedDisplay[displayType]

			local tooltipUpdater = displayType == "playerSpeed" and GetPlayerSpeedTooltipLines or GetTravelSpeedTooltipLines --REPLACE with optimized functions

			display.frame = wt.CreateCustomFrame({
				parent = UIParent,
				name = name .. displayTypeName,
				events = { OnUpdate = function(self)
					if self:IsMouseOver() and tooltip:IsVisible() then wt.UpdateTooltip(self, { lines = tooltipUpdater(), }) end
				end, },
				initialize = function(displayFrame, _, height)
					wt.AddTooltip(displayFrame, {
						tooltip = tooltip,
						title = ns.strings.speedTooltip.title:gsub("#SPEED", ns.strings.options[displayType].title),
						anchor = "ANCHOR_BOTTOMRIGHT",
						offset = { y = height },
						flipColors = true
					})

					display.text = wt.CreateText({
						parent = displayFrame,
						layer = "OVERLAY",
						wrap = false,
					})
				end,
			})

			display.updateFrame = wt.CreateFrame({
				parent = frame,
				name = displayTypeName .. "Updater",
			})
		end

		--| Target Speed

		targetSpeed.frame = wt.CreateFrame({
			parent = frame,
			name = "TargetSpeedUpdater",
		})
	end
})