--[[ RESOURCES ]]

---Addon namespace
---@class ns
local addonNameSpace, ns = ...

---WidgetTools toolbox
---@class wt
local wt = ns.WidgetToolbox

--Addon title
local addonTitle = wt.Clear(select(2, GetAddOnInfo(addonNameSpace))):gsub("^%s*(.-)%s*$", "%1")

--Custom Tooltip
ns.tooltip = wt.CreateGameTooltip(addonNameSpace)

--[ Data Tables ]

local db = {} --Account-wide options
local dbc = {} --Character-specific options
local cs --Cross-session account-wide data

--Default values
local dbDefault = {
	speedDisplay = {
		position = {
			anchor = "TOP",
			offset = { x = 0, y = -60 },
		},
		visibility = {
			frameStrata = "MEDIUM",
			autoHide = false,
			statusNotice = true,
		},
		font = {
			family = ns.fonts[0].path,
			size = 11,
			color = { r = 1, g = 1, b = 1, a = 1 },
		},
		background = {
			visible = false,
			colors = {
				bg = { r = 0, g = 0, b = 0, a = 0.5 },
				border = { r = 1, g = 1, b = 1, a = 0.4 },
			},
		},
		value = {
			type = 0,
			decimals = 0,
			noTrim = false,
		},
	},
	playerSpeed = {
		enabled = true,
		throttle = false,
		frequency = 0.1,
	},
	travelSpeed = {
		enabled = false,
		replacement = false,
		throttle = true,
		frequency = 0.1,
	},
	targetSpeed = {
		enabled = true,
		value = {
			type = 2,
			decimals = 0,
			noTrim = false,
		},
	},
}
local dbcDefault = {
	hidden = false,
}

--Preset data
local presets = {
	[0] = {
		name = ns.strings.misc.custom, --Custom
		data = {
			position = dbDefault.speedDisplay.position,
			visibility = {
				frameStrata = dbDefault.speedDisplay.visibility.frameStrata,
			},
		},
	},
	[1] = {
		name = ns.strings.options.speedDisplay.quick.presets.list[0], --Under Default Minimap
		data = {
			position = {
				anchor = "RIGHT",
				offset = { x = -100, y = 222 },
			},
			visibility = {
				frameStrata = "MEDIUM"
			},
		},
	},
}

--Add custom preset to DB
dbDefault.customPreset = wt.Clone(presets[0].data)

--[ References ]

--Local frame references
local frames = {
	playerSpeed = {},
	travelSpeed = {},
	options = {
		main = {},
		speedDisplays = {
			position = {},
			font = {},
			visibility = {},
			background = {
				colors = {},
				size = {},
			},
			value = {},
		},
		playerSpeed = {},
		travelSpeed = {},
		targetSpeed = {
			value = {},
		},
		advanced = {
			backup = {},
		},
	},
}


--[[ UTILITIES ]]

---Find the ID of the font provided
---@param fontPath string
---@return integer
local function GetFontID(fontPath)
	local id = 0
	for i = 0, #ns.fonts do
		if ns.fonts[i].path == fontPath then
			id = i
			break
		end
	end
	return id
end

--[ DB Management ]

--Check the validity of the provided key value pair
local function CheckValidity(k, v)
	if type(v) == "number" then
		--Non-negative
		if k == "size" then return v > 0 end
		--Range constraint: 0 - 1
		if k == "r" or k == "g" or k == "b" or k == "a" or k == "text" or k == "background" then return v >= 0 and v <= 1 end
	end return true
end

---Restore old data to an account-wide and character-specific DB by matching removed items to known old keys
---@param data table
---@param characterData table
---@param recoveredData? table
---@param recoveredCharacterData? table
local function RestoreOldData(data, characterData, recoveredData, recoveredCharacterData)
	if recoveredData ~= nil then for k, v in pairs(recoveredData) do
		if k == "preset.point" or k == "customPreset.position.point" then data.customPreset.position.anchor = v
		elseif k == "position.point" or k == "speedDisplay.position.point" then data.speedDisplay.position.anchor = v
		elseif k == "preset.offsetX" or k == "position.offset.x" then data.speedDisplay.position.offset.x = v
		elseif k == "preset.offsetY" or k == "position.offset.y" then data.speedDisplay.position.offset.y = v
		elseif k == "visibility.frameStrata" or  k == "appearance.frameStrata" then data.speedDisplay.visibility.frameStrata = v
		elseif k == "visibility.backdrop" or k == "appearance.backdrop.visible" then data.speedDisplay.background.visible = v
		elseif k == "appearance.backdrop.color.r" then data.speedDisplay.background.colors.bg.r = v
		elseif k == "appearance.backdrop.color.g" then data.speedDisplay.background.colors.bg.g = v
		elseif k == "appearance.backdrop.color.b" then data.speedDisplay.background.colors.bg.b = v
		elseif k == "appearance.backdrop.color.a" then data.speedDisplay.background.colors.bg.a = v
		elseif k == "fontSize" or k == "font.size" then data.speedDisplay.font.size = v
		elseif k == "font.family" then data.speedDisplay.font.family = v
		elseif k == "font.color.r" then data.speedDisplay.font.color.r = v
		elseif k == "font.color.g" then data.speedDisplay.font.color.g = v
		elseif k == "font.color.b" then data.speedDisplay.font.color.b = v
		elseif k == "font.color.a" then data.speedDisplay.font.color.a = v
		elseif k == "speedDisplay.font.text.valueType" then data.speedDisplay.value.type = v
		elseif k == "speedDisplay.font.text.decimals" then data.speedDisplay.value.decimals = v
		elseif k == "speedDisplay.font.text.noTrim" then data.speedDisplay.value.noTrim = v
		elseif k == "targetSpeed.tooltip.enabled" then data.targetSpeed.enabled = v
		elseif k == "targetSpeed.tooltip.text.valueType" then data.targetSpeed.value.type = v
		elseif k == "targetSpeed.tooltip.text.decimals" then data.targetSpeed.value.decimals = v
		elseif k == "targetSpeed.tooltip.text.noTrim" then data.targetSpeed.value.noTrim = v
		elseif k == "visibility.hidden" or k == "appearance.hidden" then characterData.hidden = v end
	end end
	if recoveredCharacterData ~= nil then for k, v in pairs(recoveredCharacterData) do
		if k == "hidden" then characterData.hidden = v
		-- elseif k == "" then characterData. = v
		end
	end end
end

---Load the addon databases from the SavedVariables tables specified in the TOC
---@return boolean firstLoad True is returned when the addon SavedVariables tabled didn't exist prior to loading, false otherwise
local function LoadDBs()
	local firstLoad = not MovementSpeedDB

	--Load storage DBs
	MovementSpeedDB = MovementSpeedDB or wt.Clone(dbDefault)
	MovementSpeedDBC = MovementSpeedDBC or wt.Clone(dbcDefault)

	--DB checkup & fix
	wt.RemoveEmpty(MovementSpeedDB, CheckValidity)
	wt.RemoveEmpty(MovementSpeedDBC, CheckValidity)
	wt.AddMissing(MovementSpeedDB, dbDefault)
	wt.AddMissing(MovementSpeedDBC, dbcDefault)
	RestoreOldData(MovementSpeedDB, MovementSpeedDBC, wt.RemoveMismatch(MovementSpeedDB, dbDefault), wt.RemoveMismatch(MovementSpeedDBC, dbcDefault))

	--Load working DBs
	db = wt.Clone(MovementSpeedDB)
	dbc = wt.Clone(MovementSpeedDBC)

	--Load cross-session data
	if MovementSpeedCS == nil then MovementSpeedCS = {} end
	cs = MovementSpeedCS

	return firstLoad
end

--[ Speed Update ]

local playerSpeed, travelSpeed = 0, 0
local pastPosition, mapWidth, mapHeight

---Get the current Player Speed in yards per seconds accessible through the local **playerSpeed**
local function UpdatePlayerSpeed()
	playerSpeed = GetUnitSpeed(UnitInVehicle("player") and "vehicle" or "player")
end

---Updates the current Travel Speed in yards since the last sample accessible through the local **travelSpeed**
---@param samplesPerSecond? number ***Default:*** 1
local function UpdateTravelSpeed(samplesPerSecond)
	local currentPosition
	local mapID = C_Map.GetBestMapForUnit("player")
	if mapID then currentPosition = C_Map.GetPlayerMapPosition(mapID, "player") or nil end

	if (pastPosition and currentPosition and not IsInInstance() and not C_Garrison.IsOnGarrisonMap()) then
		currentPosition.x = currentPosition.x * mapWidth
		currentPosition.y = currentPosition.y * mapHeight

		travelSpeed = math.sqrt((currentPosition.x - pastPosition.x) ^ 2 + (currentPosition.y - pastPosition.y) ^ 2) * (samplesPerSecond or 1)
	else travelSpeed = 0 end

	pastPosition = currentPosition
end

---Assemble the detailed text lines for Player Speed tooltip
---@return table textLines Table containing text lines to be added to the tooltip [indexed, 0-based]
--- - **text** string ― Text to be added to the line
--- - **font**? string | FontObject *optional* ― The FontObject to set for this line [Default: GameTooltipTextSmall]
--- - **color**? table *optional* ― Table containing the RGB values to color this line with [Default: HIGHLIGHT_FONT_COLOR (white)]
--- 	- **r** number ― Red [Range: 0 - 1]
--- 	- **g** number ― Green [Range: 0 - 1]
--- 	- **b** number ― Blue [Range: 0 - 1]
--- - **wrap**? boolean *optional* ― Allow this line to be wrapped [Default: true]
local function GetSpeedTooltipLines()
	return {
		{ text = ns.strings.speedTooltip.text[0], },
		{
			text = "\n" .. ns.strings.speedTooltip.text[1]:gsub("#YARDS", wt.Color(wt.FormatThousands(playerSpeed, 4, true),  ns.colors.yellow[0])),
			color = ns.colors.yellow[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.text[2]:gsub("#PERCENT", wt.Color(wt.FormatThousands(playerSpeed / 7 * 100, 4, true) .. "%%", ns.colors.green[0])),
			color = ns.colors.green[1],
		},
		{
			text = "\n" .. ns.strings.speedTooltip.hintOptions,
			font = GameFontNormalTiny,
			color = ns.colors.grey[0],
		},
		{
			text = ns.strings.speedTooltip.hintMove:gsub("#SHIFT", ns.strings.keys.shift),
			font = GameFontNormalTiny,
			color = ns.colors.grey[0],
		},
	}
end

--[ Speed Displays ]

---Set the size of the speed display
---@param height? number Text height [Default: speedDisplayText:GetStringHeight()]
---@param valueType? number Height:Width ratio [Default: db.speedDisplay.value.type]
---@param decimals? number Height:Width ratio [Default: db.speedDisplay.value.decimals]
local function SetDisplaySize(display, height, valueType, decimals)
	height = math.ceil(height or frames[display].text:GetStringHeight()) + 2
	local ratio = 3.08 + ((decimals or db.speedDisplay.value.decimals) > 0 and 0.25 + (decimals or db.speedDisplay.value.decimals) * 0.58 or 0)
	if (valueType or db.speedDisplay.value.type) == 1 then ratio = ratio + 0.46
	elseif (valueType or db.speedDisplay.value.type) == 2 then
		ratio = ratio + 3.37 + ((decimals or db.speedDisplay.value.decimals) > 0 and 0.25 + (decimals or db.speedDisplay.value.decimals) * 0.58 or 0)
	end
	local width = height * ratio - 4
	frames[display].display:SetSize(width, height)
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
---@param data table Account-wide data table to set the speed display values from
---@param characterData table Character-specific data table to set the speed display values from
local function SetDisplayValues(display, data, characterData)
	--Visibility
	frames.main:SetFrameStrata(data.speedDisplay.visibility.frameStrata)
	wt.SetVisibility(frames.main, not characterData.hidden)
	--Display
	SetDisplaySize(display, data.speedDisplay.font.size, data.speedDisplay.value.type, data.speedDisplay.value.decimals)
	SetDisplayBackdrop(display, data.speedDisplay.background.visible, data.speedDisplay.background.colors.bg, data.speedDisplay.background.colors.border)
	--Font & text
	frames[display].text:SetFont(data.speedDisplay.font.family, data.speedDisplay.font.size, "THINOUTLINE")
	frames[display].text:SetTextColor(wt.UnpackColor(data.speedDisplay.font.color))
end

--Set up the speed display frame parameters
local function LoadSpeedDisplays()
	--Separator text
	-- frames.main.separator = frames.main:CreateFontString(frames.main:GetName() .. "SeparatorText", "OVERLAY")

	--Player Speed
	-- frames.playerSpeed.text:SetPoint("CENTER", 0.9, math.fmod(db.speedDisplay.font.size, 2) ~= 0 and 0.1 or 0)
	SetDisplayValues("playerSpeed", db, dbc)

	--Travel Speed
	if db.travelSpeed.replacement then wt.SetPosition(frames.travelSpeed.display, { anchor = "CENTER", }) end
	SetDisplayValues("travelSpeed", db, dbc)
	wt.SetVisibility(frames.travelSpeed.display, db.travelSpeed.enabled)
	if not db.travelSpeed.enabled then frames.travelSpeed.display:UnregisterEvent("ZONE_CHANGED") end

	--Tooltip
	wt.AddTooltip({
		parent = frames.playerSpeed.display,
		tooltip = ns.tooltip,
		title = ns.strings.speedTooltip.title,
		lines = GetSpeedTooltipLines(),
		flipColors = true,
		anchor = "ANCHOR_BOTTOMRIGHT",
		offset = { y = frames.playerSpeed.display:GetHeight() },
	})
end

---Format the specified speed value based on the DB specifications
---@param speed number
---@return string
local function FormatSpeedValue(speed)
	local text = ""
	if db.speedDisplay.value.type == 0 then
		text = wt.FormatThousands(speed / 7 * 100, db.speedDisplay.value.decimals, true, not db.speedDisplay.value.noTrim) .. "%"
	elseif db.speedDisplay.value.type == 1 then
		text = ns.strings.yps:gsub(
			"#YARDS", wt.FormatThousands(speed, db.speedDisplay.value.decimals, true, not db.speedDisplay.value.noTrim)
		)
	elseif db.speedDisplay.value.type == 2 then
		text = wt.FormatThousands(speed / 7 * 100, db.speedDisplay.value.decimals, true, not db.speedDisplay.value.noTrim) .. "%" .. " ("
		text = text .. ns.strings.yps:gsub(
			"#YARDS", wt.FormatThousands(speed, db.speedDisplay.value.decimals, true, not db.speedDisplay.value.noTrim)
		) .. ")"
	end
	return text
end

--[ Player Speed ]

--Start updating the Player Speed display
local function StartPlayerSpeedUpdates()
	if db.playerSpeed.throttle then
		--Start a repeating timer
		frames.playerSpeed.updater.ticker = C_Timer.NewTicker(db.playerSpeed.frequency, function()
			UpdatePlayerSpeed()
			frames.playerSpeed.text:SetText(FormatSpeedValue(playerSpeed))
			wt.SetVisibility(frames.playerSpeed.display, not (db.speedDisplay.visibility.autoHide or (db.travelSpeed.replacement and travelSpeed ~= 0)) or playerSpeed ~= 0)
		end)
	else
		--Set an update event
		frames.playerSpeed.updater:SetScript("OnUpdate", function()
			UpdatePlayerSpeed()
			frames.playerSpeed.text:SetText(FormatSpeedValue(playerSpeed))
			wt.SetVisibility(frames.playerSpeed.display, not (db.speedDisplay.visibility.autoHide or (db.travelSpeed.replacement and travelSpeed ~= 0)) or playerSpeed ~= 0)
		end)
	end
end

--Stop updating the Player Speed display
local function StopPlayerSpeedUpdates()
	frames.playerSpeed.updater:SetScript("OnUpdate", nil)
	if frames.playerSpeed.updater.ticker then frames.playerSpeed.updater.ticker:Cancel() end
end

--[ Travel Speed ]

--Start updating the Travel Speed display
local function StartTravelSpeedUpdates()
	--Update map size
	frames.travelSpeed.updater:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	mapWidth, mapHeight = C_Map.GetMapWorldSize(C_Map.GetBestMapForUnit("player"))
	--Start speed updates
	if db.travelSpeed.throttle then
		--Start a repeating timer
		frames.travelSpeed.updater.ticker = C_Timer.NewTicker(db.travelSpeed.frequency, function()
			UpdateTravelSpeed(db.travelSpeed.frequency ^ -1)
			frames.travelSpeed.text:SetText(FormatSpeedValue(travelSpeed))
			wt.SetVisibility(frames.travelSpeed.display, (not db.speedDisplay.visibility.autoHide or travelSpeed ~= 0) and not (db.travelSpeed.replacement and playerSpeed ~= 0))
		end)
	else
		--Set an update event
		frames.travelSpeed.updater:SetScript("OnUpdate", function()
			UpdateTravelSpeed(GetFramerate())
			frames.travelSpeed.text:SetText(FormatSpeedValue(travelSpeed))
			wt.SetVisibility(frames.travelSpeed.display, (not db.speedDisplay.visibility.autoHide or travelSpeed ~= 0) and not (db.travelSpeed.replacement and playerSpeed ~= 0))
		end)
	end
end

--Stop updating the Travel Speed display
local function StopTravelSpeedUpdates()
	--Stop map size updates
	frames.travelSpeed.updater:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	--Stop speed updates
	frames.travelSpeed.updater:SetScript("OnUpdate", nil)
	if frames.travelSpeed.updater.ticker then frames.travelSpeed.updater.ticker:Cancel() end
end

--[ Target Speed ]

---Assemble the text for the mouseover target's speed
---@return string
local function GetTargetSpeedText()
	local speed = GetUnitSpeed("mouseover")
	local text
	if db.targetSpeed.value.type == 0 then
		text = wt.Color(wt.FormatThousands(speed / 7 * 100, db.targetSpeed.value.decimals, true, not db.targetSpeed.value.noTrim) .. "%%", ns.colors.green[0])
	elseif db.targetSpeed.value.type == 1 then
		text = wt.Color(ns.strings.yardsps:gsub(
			"#YARDS", wt.Color(wt.FormatThousands(speed, db.targetSpeed.value.decimals, true, not db.targetSpeed.value.noTrim), ns.colors.green[0])
		), ns.colors.green[1])
	elseif db.targetSpeed.value.type == 2 then
		text = wt.Color(wt.FormatThousands(speed / 7 * 100, db.targetSpeed.value.decimals, true, not db.targetSpeed.value.noTrim) .. "%%", ns.colors.green[0]) .. " ("
		text = text .. wt.Color(ns.strings.yardsps:gsub(
			"#YARDS", wt.Color(wt.FormatThousands(speed, db.targetSpeed.value.decimals, true, not db.targetSpeed.value.noTrim), ns.colors.yellow[0])
		) .. ")", ns.colors.yellow[1])
	end
	return "|T" .. ns.textures.logo .. ":0|t" .. " " .. ns.strings.targetSpeed:gsub("#SPEED", text)
end

--Set up the Target Speed unit tooltip integration
local function SetUpTargetSpeedUpdates()
	--Start mouseover Target Speed updates
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
		if not db.targetSpeed.enabled then return end

		frames.targetSpeed:SetScript("OnUpdate", function()
			if UnitName("mouseover") == nil then return end

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
				tooltip:AddLine(GetTargetSpeedText(), ns.colors.yellow[1].r, ns.colors.yellow[1].g, ns.colors.yellow[1].b, true)
				tooltip:Show() --Force the tooltip to be resized
			end
		end)
	end)

	--Stop mouseover Target Speed updates
	GameTooltip:HookScript("OnTooltipCleared", function() frames.targetSpeed:SetScript("OnUpdate", nil) end)
end


--[[ INTERFACE OPTIONS ]]

--[ Options Widgets ]

--Main page
local function CreateOptionsShortcuts(parentFrame)
	--Button: Speed Display page
	local speedDisplayPage = wt.CreateButton({
		parent = parentFrame,
		name = "SpeedDisplayPage",
		title = ns.strings.options.speedDisplay.title,
		tooltip = { lines = {
			{ text = ns.strings.options.speedDisplay.description:gsub("#ADDON", addonTitle), },
			{ text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, },
		} },
		position = { offset = { x = 10, y = -30 } },
		size = { width = 120, },
		events = { OnClick = function() frames.options.speedDisplays.page.open() end, },
		disabled = true,
	})
	--Button: Target Speed page
	wt.CreateButton({
		parent = parentFrame,
		name = "TargetSpeedPage",
		title = ns.strings.options.targetSpeed.title,
		tooltip = { lines = {
			{ text = ns.strings.options.targetSpeed.description:gsub("#ADDON", addonTitle), },
			{ text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, },
		} },
		position = {
			relativeTo = speedDisplayPage,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		size = { width = 120, },
		events = { OnClick = function() frames.options.targetSpeed.page.open() end, },
		disabled = true,
	})
	--Button: Advanced page
	wt.CreateButton({
		parent = parentFrame,
		name = "AdvancedPage",
		title = ns.strings.options.advanced.title,
		tooltip = { lines = {
			{ text = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle), },
			{ text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, },
		} },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -30 }
		},
		size = { width = 120 },
		events = { OnClick = function() frames.options.advanced.page.open() end, },
		disabled = true,
	})
end
local function CreateAboutInfo(parentFrame)
	--Text: Version
	local version = wt.CreateText({
		parent = parentFrame,
		name = "VersionTitle",
		position = { offset = { x = 16, y = -32 } },
		width = 45,
		text = ns.strings.options.main.about.version .. ":",
		font = "GameFontNormalSmall",
		justify = { h = "RIGHT", },
	})
	wt.CreateText({
		parent = parentFrame,
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
		parent = parentFrame,
		name = "DateTitle",
		position = {
			relativeTo = version,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		width = 45,
		text = ns.strings.options.main.about.date .. ":",
		font = "GameFontNormalSmall",
		justify = { h = "RIGHT", },
	})
	wt.CreateText({
		parent = parentFrame,
		name = "Date",
		position = {
			relativeTo = date,
			relativePoint = "TOPRIGHT",
			offset = { x = 5 }
		},
		width = 140,
		text = ns.strings.misc.date:gsub(
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
		parent = parentFrame,
		name = "AuthorTitle",
		position = {
			relativeTo = date,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		width = 45,
		text = ns.strings.options.main.about.author .. ":",
		font = "GameFontNormalSmall",
		justify = { h = "RIGHT", },
	})
	wt.CreateText({
		parent = parentFrame,
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
		parent = parentFrame,
		name = "LicenseTitle",
		position = {
			relativeTo = author,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		width = 45,
		text = ns.strings.options.main.about.license .. ":",
		font = "GameFontNormalSmall",
		justify = { h = "RIGHT", },
	})
	wt.CreateText({
		parent = parentFrame,
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
		parent = parentFrame,
		name = "CurseForge",
		title = ns.strings.options.main.about.curseForge .. ":",
		position = {
			relativeTo = license,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -11 }
		},
		size = { width = 190, },
		text = "curseforge.com/wow/addons/movement-speed",
		font = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Wago
	local wago = wt.CreateCopyBox({
		parent = parentFrame,
		name = "Wago",
		title = ns.strings.options.main.about.wago .. ":",
		position = {
			relativeTo = curse,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		size = { width = 190, },
		text = "addons.wago.io/addons/movement-speed",
		font = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Repository
	local repo = wt.CreateCopyBox({
		parent = parentFrame,
		name = "Repository",
		title = ns.strings.options.main.about.repository .. ":",
		position = {
			relativeTo = wago,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		size = { width = 190, },
		text = "github.com/Arxareon/MovementSpeed",
		font = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Issues
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Issues",
		title = ns.strings.options.main.about.issues .. ":",
		position = {
			relativeTo = repo,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -8 }
		},
		size = { width = 190, },
		text = "github.com/Arxareon/MovementSpeed/issues",
		font = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
	--EditScrollBox: Changelog
	local _, changelog = wt.CreateEditScrollBox({
		parent = parentFrame,
		name = "Changelog",
		title = ns.strings.options.main.about.changelog.label,
		tooltip = { lines = { { text = ns.strings.options.main.about.changelog.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -17.5, y = -30 }
		},
		size = { width = parentFrame:GetWidth() - 235.5, height = 192 },
		text = ns.GetChangelog(true),
		font = { normal = "GameFontDisableSmall", },
		color = ns.colors.grey[1],
		readOnly = true,
		scrollSpeed = 45,
	})
	--Button: Full changelog
	local changelogFrame
	wt.CreateButton({
		parent = parentFrame,
		name = "OpenFullChangelog",
		title = ns.strings.options.main.about.openFullChangelog.label,
		tooltip = { lines = { { text = ns.strings.options.main.about.openFullChangelog.tooltip, }, } },
		position = {
			anchor = "BOTTOMRIGHT",
			relativeTo = changelog,
			relativePoint = "TOPRIGHT",
			offset = { x = 2.5, y = 6 }
		},
		size = { width = 180, height = 14 },
		font = {
			nornal = "GameFontNormalSmall",
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
					title = ns.strings.options.main.about.fullChangelog.label:gsub("#ADDON", addonTitle),
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
					tooltip = { lines = { { text = ns.strings.options.main.about.fullChangelog.tooltip, }, } },
					position = {
						anchor = "TOPRIGHT",
						offset = { x = -16, y = -42 }
					},
					size = { width = changelogFrame:GetWidth() - 32, height = changelogFrame:GetHeight() - 90.5 },
					text = ns.GetChangelog(),
					font = { normal = "GameFontDisable", },
					color = ns.colors.grey[1],
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
end
local function CreateSponsorInfo(parentFrame, top, normal)
	if top then
		wt.CreateText({
			parent = parentFrame,
			name = "Top",
			position = { offset = { x = 16, y = -33 } },
			text = top:gsub("|", " • "),
			font = "GameFontNormalLarge",
			justify = { h = "LEFT", },
			width = parentFrame:GetWidth() - 32,
		})
	end
	if normal then
		wt.CreateText({
			parent = parentFrame,
			name = "Normal",
			position = { offset = { x = 16, y = -33 -(top and 24 or 0) } },
			text = normal:gsub("|", " • "),
			font = "GameFontHighlightMedium",
			justify = { h = "LEFT", },
			width = parentFrame:GetWidth() - 32,
		})
	end
end

--Speed Display page
local function CreateQuickOptions(parentFrame)
	--Checkbox: Hidden
	frames.options.speedDisplays.visibility.hidden = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Hidden",
		title = ns.strings.options.speedDisplay.quick.hidden.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.quick.hidden.tooltip:gsub("#ADDON", addonTitle), }, } },
		position = { offset = { x = 8, y = -30 } },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = dbc,
			storageKey = "hidden",
			onChange = { DispalyToggle = function() wt.SetVisibility(frames.main, not dbc.hidden) end }
		}
	})
	--Dropdown: Apply a preset
	local presetItems = {}
	for i = 0, #presets do
		presetItems[i] = {}
		presetItems[i].title = presets[i].name
		presetItems[i].onSelect = function()
			--Update the speed display
			frames.main:Show()
			frames.main:SetFrameStrata(presets[i].data.visibility.frameStrata)
			wt.SetPosition(frames.main, presets[i].data.position)
			--Update the options
			frames.options.speedDisplays.position.anchor.setSelected(presets[i].data.position.anchor)
			frames.options.speedDisplays.position.xOffset.setValue(presets[i].data.position.offset.x)
			frames.options.speedDisplays.position.yOffset.setValue(presets[i].data.position.offset.y)
			frames.options.speedDisplays.visibility.raise:SetChecked(presets[i].data.visibility.frameStrata == "HIGH")
			--Update the DBs
			db.speedDisplay.position = presets[i].data.position
			db.speedDisplay.visibility.frameStrata = presets[i].data.visibility.frameStrata
		end
	end
	frames.options.speedDisplays.visibility.presets = wt.CreateDropdown({
		parent = parentFrame,
		name = "ApplyPreset",
		title = ns.strings.options.speedDisplay.quick.presets.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.quick.presets.tooltip, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		width = 180,
		items = presetItems,
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			onLoad = function(self) self.setSelected(nil, ns.strings.options.speedDisplay.quick.presets.select) end,
		}
	})
	--Button & Popup: Save Custom preset
	local savePopup = wt.CreatePopup({
		addon = addonNameSpace,
		name = "SAVEPRESET",
		text = ns.strings.options.speedDisplay.quick.savePreset.warning,
		accept = ns.strings.misc.override,
		onAccept = function()
			--Update the Custom preset
			presets[0].data.position = wt.PackPosition(frames.main:GetPoint())
			presets[0].data.visibility.frameStrata = frames.options.speedDisplays.visibility.raise:GetChecked() and "HIGH" or "MEDIUM"
			--Save the Custom preset
			db.customPreset = wt.Clone(presets[0].data)
			--Response
			print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.save.response, ns.colors.yellow[1]))
		end,
	})
	wt.CreateButton({
		parent = parentFrame,
		name = "SavePreset",
		title = ns.strings.options.speedDisplay.quick.savePreset.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.quick.savePreset.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -43 }
		},
		size = { width = 170, },
		events = { OnClick = function() StaticPopup_Show(savePopup) end, },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
	})
end
local function CreatePlayerSpeedOptions(parentFrame)
	--Checkbox: Throttle
	frames.options.playerSpeed.throttle = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Throttle",
		title = ns.strings.options.speedDisplay.update.throttle.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.throttle.tooltip, }, } },
		position = { offset = { x = 8, y = -30 } },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.playerSpeed,
			storageKey = "throttle",
			onChange = { RefreshPlayerSpeedUpdates = function()
				StopPlayerSpeedUpdates()
				StartPlayerSpeedUpdates()
			end, }
		}
	})
	--Slider: Frequency
	frames.options.playerSpeed.frequency = wt.CreateSlider({
		parent = parentFrame,
		name = "Frequency",
		title = ns.strings.options.speedDisplay.update.frequency.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.frequency.tooltip, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		value = { min = 0.05, max = 1, step = 0.05 },
		dependencies = {
			{ frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = frames.options.playerSpeed.throttle },
		},
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.playerSpeed,
			storageKey = "frequency",
			onChange = { "RefreshPlayerSpeedUpdates", }
		}
	})
end
local function CreateTravelSpeedOptions(parentFrame)
	--Checkbox: Enabled
	frames.options.travelSpeed.enabled = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Toggle",
		title = ns.strings.options.speedDisplay.travelSpeed.enabled.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.travelSpeed.enabled.tooltip, }, } },
		position = { offset = { x = 8, y = -30 } },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.travelSpeed,
			storageKey = "enabled",
			onChange = { ToggleTravelSpeedUpdates = function()
				wt.SetVisibility(frames.travelSpeed.display, db.travelSpeed.enabled)
				if db.travelSpeed.enabled then StartTravelSpeedUpdates() else StopTravelSpeedUpdates() end
			end, }
		}
	})
	--Checkbox: Replacement
	frames.options.travelSpeed.replacement = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Replacement",
		title = ns.strings.options.speedDisplay.travelSpeed.replacement.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.travelSpeed.replacement.tooltip, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		autoOffset = true,
		dependencies = {
			{ frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = frames.options.travelSpeed.enabled, },
		},
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.travelSpeed,
			storageKey = "replacement",
			onChange = { ToggleTravelSpeedReplacement = function() wt.SetPosition(frames.travelSpeed.display, {
				anchor = "CENTER",
				offset = { y = db.travelSpeed.replacement and 0 or -14 }
			}) end, }
		}
	})
	--Checkbox: Throttle
	frames.options.travelSpeed.throttle = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Throttle",
		title = ns.strings.options.speedDisplay.update.throttle.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.throttle.tooltip, }, } },
		position = {
			relativeTo = frames.options.travelSpeed.enabled,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -4 }
		},
		dependencies = {
			{ frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = frames.options.travelSpeed.enabled, },
		},
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.travelSpeed,
			storageKey = "throttle",
			onChange = { RefreshTravelSpeedUpdates = function()
				StopTravelSpeedUpdates()
				if frames.options.travelSpeed.enabled:GetChecked() then StartTravelSpeedUpdates() end
			end, }
		}
	})
	--Slider: Frequency
	frames.options.travelSpeed.frequency = wt.CreateSlider({
		parent = parentFrame,
		name = "Frequency",
		title = ns.strings.options.speedDisplay.update.frequency.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.frequency.tooltip, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -62 }
		},
		value = { min = 0.05, max = 1, step = 0.05 },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.travelSpeed,
			storageKey = "frequency",
			onChange = { "RefreshTravelSpeedUpdates", }
		}
	})
end
local function CreateValueOptions(parentFrame)
	--Selector: Value type
	local valueTypes = {}
	for i = 0, 2 do
		valueTypes[i] = {}
		valueTypes[i].title = ns.strings.options.speedValue.type.list[i].label
		valueTypes[i].tooltip = { lines = { { text = ns.strings.options.speedValue.type.list[i].tooltip, }, } }
	end
	frames.options.speedDisplays.value.type = wt.CreateSelector({
		parent = parentFrame,
		name = "Type",
		title = ns.strings.options.speedValue.type.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.type.tooltip, }, } },
		position = { offset = { x = 12, y = -30 } },
		items = valueTypes,
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.value,
			storageKey = "type",
			onChange = { UpdateDisplaySizes = function()
				SetDisplaySize("playerSpeed")
				SetDisplaySize("travelSpeed")
			end, }
		}
	})
	--Slider: Decimals
	frames.options.speedDisplays.value.decimals = wt.CreateSlider({
		parent = parentFrame,
		name = "Decimals",
		title = ns.strings.options.speedValue.decimals.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.decimals.tooltip, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		value = { min = 0, max = 4, step = 1 },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.value,
			storageKey = "decimals",
			onChange = { "UpdateDisplaySizes", }
		}
	})
	--Checkbox: No trim
	frames.options.speedDisplays.value.noTrim = wt.CreateCheckbox({
		parent = parentFrame,
		name = "NoTrim",
		title = ns.strings.options.speedValue.noTrim.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.noTrim.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { y = -30 }
		},
		autoOffset = true,
		dependencies = {
			{ frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = frames.options.speedDisplays.value.decimals, evaluate = function(value) return value > 0 end },
		},
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.value,
			storageKey = "noTrim",
		}
	})
end
local function CreatePositionOptions(parentFrame)
	--Selector: Anchor point
	frames.options.speedDisplays.position.anchor = wt.CreateAnchorSelector({
		parent = parentFrame,
		name = "AnchorPoint",
		title = ns.strings.options.speedDisplay.position.anchor.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.anchor.tooltip, }, } },
		position = { offset = { x = 12, y = -30 } },
		width = 140,
		onSelection = function() frames.options.speedDisplays.visibility.presets.setSelected(nil, ns.strings.options.speedDisplay.quick.presets.select) end,
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.position,
			storageKey = "anchor",
			onChange = { UpdateDisplayPositions = function() wt.SetPosition(frames.main, db.speedDisplay.position) end, }
		}
	})
	--Slider: X offset
	frames.options.speedDisplays.position.xOffset = wt.CreateSlider({
		parent = parentFrame,
		name = "OffsetX",
		title = ns.strings.options.speedDisplay.position.xOffset.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.xOffset.tooltip, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		value = { min = -500, max = 500, fractional = 2 },
		events = { OnValueChanged = function() frames.options.speedDisplays.visibility.presets.setSelected(nil, ns.strings.options.speedDisplay.quick.presets.select) end, },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.position.offset,
			storageKey = "x",
			onChange = { "UpdateDisplayPositions", }
		}
	})
	--Slider: Y offset
	frames.options.speedDisplays.position.yOffset = wt.CreateSlider({
		parent = parentFrame,
		name = "OffsetY",
		title = ns.strings.options.speedDisplay.position.yOffset.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.yOffset.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -12, y = -30 }
		},
		value = { min = -500, max = 500, fractional = 2 },
		events = { OnValueChanged = function() frames.options.speedDisplays.visibility.presets.setSelected(nil, ns.strings.options.speedDisplay.quick.presets.select) end, },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.position.offset,
			storageKey = "y",
			onChange = { "UpdateDisplayPositions", }
		}
	})
end
local function CreateFontOptions(parentFrame)
	--Dropdown: Font family
	local fontItems = {}
	for i = 0, #ns.fonts do
		fontItems[i] = {}
		fontItems[i].title = ns.fonts[i].name
	end
	frames.options.speedDisplays.font.family = wt.CreateDropdown({
		parent = parentFrame,
		name = "FontFamily",
		title = ns.strings.options.speedDisplay.font.family.label,
		tooltip = { lines = {
			{ text = ns.strings.options.speedDisplay.font.family.tooltip[0], },
			{ text = "\n" .. ns.strings.options.speedDisplay.font.family.tooltip[1], },
			{ text = "\n" .. ns.strings.options.speedDisplay.font.family.tooltip[2]:gsub("#OPTION_CUSTOM", ns.strings.misc.custom):gsub("#FILE_CUSTOM", "CUSTOM.ttf"), },
			{ text = "[WoW]\\Interface\\AddOns\\" .. addonNameSpace .. "\\Fonts\\", color = { r = 0.185, g = 0.72, b = 0.84 }, wrap = false },
			{ text = ns.strings.options.speedDisplay.font.family.tooltip[3]:gsub("#FILE_CUSTOM", "CUSTOM.ttf"), },
			{ text = ns.strings.options.speedDisplay.font.family.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 }, },
		} },
		position = { offset = { x = 10, y = -30 } },
		items = fontItems,
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.font,
			storageKey = "family",
			convertSave = function(value) return ns.fonts[value].path end,
			convertLoad = function(font) return GetFontID(font) end,
			onChange = {
				UpdateDisplayFonts = function()
					--Player Speed
					frames.playerSpeed.text:SetFont(db.speedDisplay.font.family, db.speedDisplay.font.size, "THINOUTLINE")
					--Travel Speed
					frames.travelSpeed.text:SetFont(db.speedDisplay.font.family, db.speedDisplay.font.size, "THINOUTLINE")
				end,
				RefreshDisplayTexts = function() --Refresh the text so the font will be applied right away
					local text = frames.playerSpeed.text:GetText()
					frames.playerSpeed.text:SetText("")
					frames.playerSpeed.text:SetText(text)
				end,
			}
		}
	})
	--Slider: Font size
	frames.options.speedDisplays.font.size = wt.CreateSlider({
		parent = parentFrame,
		name = "FontSize",
		title = ns.strings.options.speedDisplay.font.size.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.size.tooltip .. "\n\n" .. ns.strings.misc.default .. ": " .. dbDefault.speedDisplay.font.size, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		value = { min = 8, max = 64, step = 1 },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.font,
			storageKey = "size",
			onChange = {
				"UpdateDisplayFonts",
				UpdateDisplayTextPlacements = function()
					--Player Speed
					frames.playerSpeed.text:SetPoint("CENTER", 0.9, math.fmod(db.speedDisplay.font.size, 2) ~= 0 and 0.1 or 0)
					SetDisplaySize("playerSpeed")
					--Travel Speed
					frames.travelSpeed.text:SetPoint("CENTER", 0.9, math.fmod(db.speedDisplay.font.size, 2) ~= 0 and 0.1 or 0)
					SetDisplaySize("travelSpeed")
				end,
			}
		}
	})
	--Color Picker: Font color
	frames.options.speedDisplays.font.color = wt.CreateColorPicker({
		parent = parentFrame,
		name = "FontColor",
		title = ns.strings.options.speedDisplay.font.color.label,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -12, y = -30 }
		},
		opacity = true,
		setColors = function() return frames.playerSpeed.text:GetTextColor() end,
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.font,
			storageKey = "color",
			onChange = { UpdateDisplayFontColors = function()
				--Player Speed
				frames.playerSpeed.text:SetTextColor(wt.UnpackColor(db.speedDisplay.font.color))
				--Travel Speed
				frames.travelSpeed.text:SetTextColor(wt.UnpackColor(db.speedDisplay.font.color))
			end, }
		}
	})
end
local function CreateBackgroundOptions(parentFrame)
	--Checkbox: Visible
	frames.options.speedDisplays.background.visible = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Visible",
		title = ns.strings.options.speedDisplay.background.visible.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.background.visible.tooltip, }, } },
		position = { offset = { x = 8, y = -30 } },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.background,
			storageKey = "visible",
			onChange = { ToggleDisplayBackdrops = function()
				--Player Speed
				SetDisplayBackdrop("playerSpeed", db.speedDisplay.background.visible, db.speedDisplay.background.colors.bg, db.speedDisplay.background.colors.border)
				--Travel Speed
				SetDisplayBackdrop("travelSpeed", db.speedDisplay.background.visible, db.speedDisplay.background.colors.bg, db.speedDisplay.background.colors.border)
			end, }
		}
	})
	--Color Picker: Background color
	frames.options.speedDisplays.background.colors.bg = wt.CreateColorPicker({
		parent = parentFrame,
		name = "BackgroundColor",
		title = ns.strings.options.speedDisplay.background.colors.bg.label,
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		opacity = true,
		setColors = function()
			if frames.options.speedDisplays.background.visible:GetChecked() then return frames.playerSpeed.display:GetBackdropColor() end
			return wt.UnpackColor(db.speedDisplay.background.colors.bg)
		end,
		dependencies = {
			{ frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = frames.options.speedDisplays.background.visible, },
		},
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.background.colors,
			storageKey = "bg",
			onChange = { UpdateDisplayBackdropBackgroundColors = function()
				--Player Speed
				if frames.playerSpeed.display:GetBackdrop() ~= nil then frames.playerSpeed.display:SetBackdropColor(wt.UnpackColor(db.speedDisplay.background.colors.bg)) end
				--Travel Speed
				if frames.travelSpeed.display:GetBackdrop() ~= nil then frames.travelSpeed.display:SetBackdropColor(wt.UnpackColor(db.speedDisplay.background.colors.bg)) end
			end }
		}
	})
	--Color Picker: Border color
	frames.options.speedDisplays.background.colors.border = wt.CreateColorPicker({
		parent = parentFrame,
		name = "BorderColor",
		title = ns.strings.options.speedDisplay.background.colors.border.label,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -12, y = -30 }
		},
		opacity = true,
		setColors = function()
			if frames.options.speedDisplays.background.visible:GetChecked() then return frames.playerSpeed.display:GetBackdropBorderColor() end
			return wt.UnpackColor(db.speedDisplay.background.colors.border)
		end,
		dependencies = {
			{ frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = frames.options.speedDisplays.background.visible, },
		},
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.background.colors,
			storageKey = "border",
			onChange = { UpdateDisplayBackdropBorderColors = function()
				--Player Speed
				if frames.playerSpeed.display:GetBackdrop() ~= nil then
					frames.playerSpeed.display:SetBackdropBorderColor(wt.UnpackColor(db.speedDisplay.background.colors.border))
				end
				--Travel Speed
				if frames.travelSpeed.display:GetBackdrop() ~= nil then
					frames.travelSpeed.display:SetBackdropBorderColor(wt.UnpackColor(db.speedDisplay.background.colors.border))
				end
			end }
		}
	})
end
local function CreateVisibilityOptions(parentFrame)
	--Checkbox: Raise
	frames.options.speedDisplays.visibility.raise = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Raise",
		title = ns.strings.options.speedDisplay.visibility.raise.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.raise.tooltip, }, } },
		position = { offset = { x = 8, y = -30 } },
		events = { OnClick = function() frames.options.speedDisplays.visibility.presets.setSelected(nil, ns.strings.options.speedDisplay.quick.presets.select) end, },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.visibility,
			storageKey = "frameStrata",
			convertSave = function(enabled) return enabled and "HIGH" or "MEDIUM" end,
			convertLoad = function(strata) return strata == "HIGH" end,
			onChange = { UpdateDisplayFrameStratas = function() frames.main:SetFrameStrata(db.speedDisplay.visibility.frameStrata) end, }
		}
	})
	--Checkbox: Auto-hide toggle
	frames.options.speedDisplays.visibility.autoHide = wt.CreateCheckbox({
		parent = parentFrame,
		name = "AutoHide",
		title = ns.strings.options.speedDisplay.visibility.autoHide.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.autoHide.tooltip, }, } },
		position = {
			relativeTo = frames.options.speedDisplays.visibility.raise,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -4 }
		},
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.visibility,
			storageKey = "autoHide",
		}
	})
	--Checkbox: Status notice
	frames.options.speedDisplays.visibility.status = wt.CreateCheckbox({
		parent = parentFrame,
		name = "StatusNotice",
		title = ns.strings.options.speedDisplay.visibility.statusNotice.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.statusNotice.tooltip:gsub("#ADDON", addonTitle), }, } },
		position = {
			relativeTo = frames.options.speedDisplays.visibility.autoHide,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -4 }
		},
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.visibility,
			storageKey = "statusNotice",
		}
	})
end

--Target Speed page
local function CreateTargetSpeedOptions(parentFrame)
	--Checkbox: Enabled
	frames.options.targetSpeed.enabled = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Enabled",
		title = ns.strings.options.targetSpeed.mouseover.enabled.label,
		tooltip = { lines = { { text = ns.strings.options.targetSpeed.mouseover.enabled.tooltip:gsub("#ADDON", addonTitle), }, } },
		position = { offset = { x = 8, y = -30 } },
		optionsData = {
			optionsKey = addonNameSpace .. "TargetSpeed",
			workingTable = db.targetSpeed,
			storageKey = "enabled",
		}
	})
	--Selector: Value type
	local valueTypes = {}
	for i = 0, 2 do
		valueTypes[i] = {}
		valueTypes[i].title = ns.strings.options.speedValue.type.list[i].label
		valueTypes[i].tooltip = { lines = { { text = ns.strings.options.speedValue.type.list[i].tooltip, }, } }
	end
	frames.options.targetSpeed.value.type = wt.CreateSelector({
		parent = parentFrame,
		name = "ValueType",
		title = ns.strings.options.speedValue.type.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.type.tooltip, }, } },
		position = { offset = { x = 12, y = -60 } },
		items = valueTypes,
		dependencies = { { frame = frames.options.targetSpeed.enabled, }, },
		optionsData = {
			optionsKey = addonNameSpace .. "TargetSpeed",
			workingTable = db.targetSpeed.value,
			storageKey = "type",
		}
	})
	--Slider: Decimals
	frames.options.targetSpeed.value.decimals = wt.CreateSlider({
		parent = parentFrame,
		name = "Decimals",
		title = ns.strings.options.speedValue.decimals.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.decimals.tooltip, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -60 }
		},
		value = { min = 0, max = 4, step = 1 },
		dependencies = { { frame = frames.options.targetSpeed.enabled, }, },
		optionsData = {
			optionsKey = addonNameSpace .. "TargetSpeed",
			workingTable = db.targetSpeed.value,
			storageKey = "decimals",
		}
	})
	--Checkbox: No trim
	frames.options.targetSpeed.value.noTrim = wt.CreateCheckbox({
		parent = parentFrame,
		name = "NoTrim",
		title = ns.strings.options.speedValue.noTrim.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.noTrim.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { y = -60 }
		},
		autoOffset = true,
		dependencies = {
			{ frame = frames.options.targetSpeed.enabled, },
			{ frame = frames.options.targetSpeed.value.decimals, evaluate = function(value) return value > 0 end },
		},
		optionsData = {
			optionsKey = addonNameSpace .. "TargetSpeed",
			workingTable = db.targetSpeed.value,
			storageKey = "noTrim",
		}
	})
end

--Advanced page
local function CreateOptionsProfiles(parentFrame)
	--TODO: Add profiles handler widgets
end
local function CreateBackupOptions(parentFrame)
	--EditScrollBox & Popup: Import & Export
	local importPopup = wt.CreatePopup({
		addon = addonNameSpace,
		name = "IMPORT",
		text = ns.strings.options.advanced.backup.warning,
		accept = ns.strings.options.advanced.backup.import,
		onAccept = function()
			--Load from string to a temporary table
			local success, t = pcall(loadstring("return " .. wt.Clear(frames.options.advanced.backup.string:GetText())))
			if success and type(t) == "table" then
				--Run DB checkup on the loaded table
				wt.RemoveEmpty(t.account, CheckValidity)
				wt.RemoveEmpty(t.character, CheckValidity)
				wt.AddMissing(t.account, db)
				wt.AddMissing(t.character, dbc)
				RestoreOldData(t.account, t.character, wt.RemoveMismatch(t.account, db), wt.RemoveMismatch(t.character, dbc))

				--Copy values from the loaded DBs to the addon DBs
				wt.CopyValues(t.account, db)
				wt.CopyValues(t.character, dbc)

				--Load the custom preset
				presets[0].data = wt.Clone(db.customPreset)

				--Load the options data & update the interface options
				frames.options.speedDisplays.page.load(true)
				frames.options.targetSpeed.page.load(true)
				frames.options.advanced.page.load(true)
			else print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.options.advanced.backup.error, ns.colors.yellow[1])) end
		end
	})
	local backupBox
	frames.options.advanced.backup.string, backupBox = wt.CreateEditScrollBox({
		parent = parentFrame,
		name = "ImportExport",
		title = ns.strings.options.advanced.backup.backupBox.label,
		tooltip = { lines = {
			{ text = ns.strings.options.advanced.backup.backupBox.tooltip[0], },
			{ text = "\n" .. ns.strings.options.advanced.backup.backupBox.tooltip[1], },
			{ text = "\n" .. ns.strings.options.advanced.backup.backupBox.tooltip[2]:gsub("#ENTER", ns.strings.keys.enter), },
			{ text = ns.strings.options.advanced.backup.backupBox.tooltip[3], color = { r = 0.89, g = 0.65, b = 0.40 }, },
			{ text = "\n" .. ns.strings.options.advanced.backup.backupBox.tooltip[4], color = { r = 0.92, g = 0.34, b = 0.23 }, },
		}, },
		position = { offset = { x = 17.5, y = -30 } },
		size = { width = parentFrame:GetWidth() - 35, height = 302 },
		font = { normal = "GameFontWhiteSmall", },
		maxLetters = 4000,
		scrollSpeed = 60,
		events = {
			OnEnterPressed = function() StaticPopup_Show(importPopup) end,
			OnEscapePressed = function(self) self.setText(wt.TableToString({ account = db, character = dbc }, frames.options.advanced.backup.compact:GetChecked(), true)) end,
		},
		optionsData = {
			optionsKey = addonNameSpace .. "Advanced",
			onLoad = function(self) self.setText(wt.TableToString({ account = db, character = dbc }, frames.options.advanced.backup.compact:GetChecked(), true)) end,
		}
	})
	--Checkbox: Compact
	frames.options.advanced.backup.compact = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Compact",
		title = ns.strings.options.advanced.backup.compact.label,
		tooltip = { lines = { { text = ns.strings.options.advanced.backup.compact.tooltip, }, } },
		position = {
			relativeTo = backupBox,
			relativePoint = "BOTTOMLEFT",
			offset = { x = -8, y = -13 }
		},
		events = { OnClick = function(_, state)
			frames.options.advanced.backup.string.setText(wt.TableToString({ account = db, character = dbc }, state, true))
			--Set focus after text change to set the scroll to the top and refresh the position character counter
			frames.options.advanced.backup.string:SetFocus()
			frames.options.advanced.backup.string:ClearFocus()
		end, },
		optionsData = {
			optionsKey = addonNameSpace .. "Advanced",
			workingTable = cs,
			storageKey = "compactBackup",
		}
	})
	--Button: Load
	local load = wt.CreateButton({
		parent = parentFrame,
		name = "Load",
		title = ns.strings.options.advanced.backup.load.label,
		tooltip = { lines = { { text = ns.strings.options.advanced.backup.load.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			relativeTo = backupBox,
			relativePoint = "BOTTOMRIGHT",
			offset = { x = 6, y = -13 }
		},
		events = { OnClick = function() StaticPopup_Show(importPopup) end, },
	})
	--Button: Reset
	wt.CreateButton({
		parent = parentFrame,
		name = "Reset",
		title = ns.strings.options.advanced.backup.reset.label,
		tooltip = { lines = { { text = ns.strings.options.advanced.backup.reset.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			relativeTo = load,
			relativePoint = "TOPLEFT",
			offset = { x = -10, }
		},
		events = { OnClick = function()
			frames.options.advanced.backup.string.setText(wt.TableToString({ account = db, character = dbc }, frames.options.advanced.backup.compact:GetChecked(), true))
			--Set focus after text change to set the scroll to the top and refresh the position character counter
			frames.options.advanced.backup.string:SetFocus()
			frames.options.advanced.backup.string:ClearFocus()
		end, },
	})
end

--[ Options Category Panels ]

--Create and add the options panels to the WoW Interface options
local function LoadInterfaceOptions()

	--[[ MAIN ]]

	--[ Options Category Page ]

	frames.options.main.page = wt.CreateOptionsCategory({
		addon = addonNameSpace,
		name = "Main",
		description = ns.strings.options.main.description:gsub("#ADDON", addonTitle):gsub("#KEYWORD", ns.strings.chat.keyword),
		logo = ns.textures.logo,
		titleLogo = true,
	})

	--[ Category Panels ]

	--Shortcuts
	local shortcutsPanel = wt.CreatePanel({
		parent = frames.options.main.page.canvas,
		name = "Shortcuts",
		title = ns.strings.options.main.shortcuts.title,
		description = ns.strings.options.main.shortcuts.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 10, y = -82 } },
		size = { height = 64 },
	})
	CreateOptionsShortcuts(shortcutsPanel) --Add widgets

	--About
	local aboutPanel = wt.CreatePanel({
		parent = frames.options.main.page.canvas,
		name = "About",
		title = ns.strings.options.main.about.title,
		description = ns.strings.options.main.about.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = shortcutsPanel,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 260 },
	})
	CreateAboutInfo(aboutPanel) --Add widgets

	--Sponsors
	local top = GetAddOnMetadata(addonNameSpace, "X-TopSponsors")
	local normal = GetAddOnMetadata(addonNameSpace, "X-Sponsors")
	if top or normal then
		local sponsorsPanel = wt.CreatePanel({
			parent = frames.options.main.page.canvas,
			name = "Sponsors",
			title = ns.strings.options.main.sponsors.title,
			description = ns.strings.options.main.sponsors.description,
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
		CreateSponsorInfo(sponsorsPanel, top, normal) --Add names
	end


	--[[ SPEED DISPLAYS ]]

	--[ Options Category Page ]

	frames.options.speedDisplays.page = wt.CreateOptionsCategory({
		parent = frames.options.main.page.category,
		addon = addonNameSpace,
		name = "SpeedDisplays",
		title = ns.strings.options.speedDisplay.title,
		description = ns.strings.options.speedDisplay.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		scroll = {
			height = 1104,
			speed = 130,
		},
		optionsKeys = { addonNameSpace .. "SpeedDisplays" },
		storage = {
			{
				workingTable =  dbc,
				storageTable = MovementSpeedDBC,
				defaultsTable = dbcDefault,
			},
			{
				workingTable =  db.playerSpeed,
				storageTable = MovementSpeedDB.playerSpeed,
				defaultsTable = dbDefault.playerSpeed,
			},
			{
				workingTable =  db.travelSpeed,
				storageTable = MovementSpeedDB.travelSpeed,
				defaultsTable = dbDefault.travelSpeed,
			},
			{
				workingTable =  db.speedDisplay,
				storageTable = MovementSpeedDB.speedDisplay,
				defaultsTable = dbDefault.speedDisplay,
			},
		},
		onSave = function()
			MovementSpeedDB = wt.Clone(db)
		end,
		onDefault = function()
			--Reset the Custom preset and set it as selected
			presets[0].data = wt.Clone(db.customPreset)
			frames.options.speedDisplays.visibility.presets.setSelected(0)
			--Notification
			print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.reset.response, ns.colors.yellow[1]))
		end
	})

	--[ Category Panels ]

	--Quick settings
	local quickOptions = wt.CreatePanel({
		parent = frames.options.speedDisplays.page.scrollChild,
		name = "QuickSettings",
		title = ns.strings.options.speedDisplay.quick.title,
		description = ns.strings.options.speedDisplay.quick.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 10, y = -78 } },
		size = { height = 77 },
	})
	CreateQuickOptions(quickOptions) --Add widgets

	--Player Speed
	local playerSpeedOptions = wt.CreatePanel({
		parent = frames.options.speedDisplays.page.scrollChild,
		name = "PlayerSpeed",
		title = ns.strings.options.speedDisplay.playerSpeed.title,
		description = ns.strings.options.speedDisplay.playerSpeed.description,
		position = {
			relativeTo = quickOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 91 },
	})
	CreatePlayerSpeedOptions(playerSpeedOptions) --Add widgets

	--Travel Speed
	local travelSpeedOptions = wt.CreatePanel({
		parent = frames.options.speedDisplays.page.scrollChild,
		name = "TravelSpeed",
		title = ns.strings.options.speedDisplay.travelSpeed.title,
		description = ns.strings.options.speedDisplay.travelSpeed.description,
		position = {
			relativeTo = playerSpeedOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 123 },
	})
	CreateTravelSpeedOptions(travelSpeedOptions) --Add widgets

	--Value
	local valueOptions = wt.CreatePanel({
		parent = frames.options.speedDisplays.page.scrollChild,
		name = "Value",
		title = ns.strings.options.speedValue.title,
		description = ns.strings.options.speedValue.description,
		position = {
			relativeTo = travelSpeedOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 103 },
	})
	CreateValueOptions(valueOptions) --Add widgets

	--Position
	local positionOptions = wt.CreatePanel({
		parent = frames.options.speedDisplays.page.scrollChild,
		name = "Position",
		title = ns.strings.options.speedDisplay.position.title,
		description = ns.strings.options.speedDisplay.position.description:gsub("#SHIFT", ns.strings.keys.shift),
		position = {
			relativeTo = valueOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 103 },
	})
	CreatePositionOptions(positionOptions) --Add widgets

	--Font
	local fontOptions = wt.CreatePanel({
		parent = frames.options.speedDisplays.page.scrollChild,
		name = "Font",
		title = ns.strings.options.speedDisplay.font.title,
		description = ns.strings.options.speedDisplay.font.description,
		position = {
			relativeTo = positionOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 91 },
	})
	CreateFontOptions(fontOptions) --Add widgets

	--Background
	local backgroundOptions = wt.CreatePanel({
		parent = frames.options.speedDisplays.page.scrollChild,
		name = "Background",
		title = ns.strings.options.speedDisplay.background.title,
		description = ns.strings.options.speedDisplay.background.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = fontOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 80 },
	})
	CreateBackgroundOptions(backgroundOptions) --Add widgets

	--Visibility
	local visibilityOptions = wt.CreatePanel({
		parent = frames.options.speedDisplays.page.scrollChild,
		name = "Visibility",
		title = ns.strings.options.speedDisplay.visibility.title,
		description = ns.strings.options.speedDisplay.visibility.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = backgroundOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 123 },
	})
	CreateVisibilityOptions(visibilityOptions) --Add widgets


	--[[ TARGET SPEED ]]

	--[ Options Category Page ]

	frames.options.targetSpeed.page = wt.CreateOptionsCategory({
		parent = frames.options.main.page.category,
		addon = addonNameSpace,
		name = "TargetSpeed",
		title = ns.strings.options.targetSpeed.title,
		description = ns.strings.options.targetSpeed.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		optionsKeys = { addonNameSpace .. "TargetSpeed" },
		storage = {
			{
				workingTable =  db.targetSpeed,
				storageTable = MovementSpeedDB.targetSpeed,
				defaultsTable = dbDefault.targetSpeed,
			},
		},
		onDefault = function()
			--Notification
			print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.reset.response, ns.colors.yellow[1]))
		end
	})

	--[ Category Panels ]

	--Target Speed
	local targetSpeedOptions = wt.CreatePanel({
		parent = frames.options.targetSpeed.page.canvas,
		name = "TargetSpeed",
		title = ns.strings.options.targetSpeed.mouseover.title,
		description = ns.strings.options.targetSpeed.mouseover.description,
		position = { offset = { x = 10, y = -82 } },
		size = { height = 133 },
	})
	CreateTargetSpeedOptions(targetSpeedOptions) --Add widgets


	--[[ ADVANCED ]]

	--[ Options Category Page ]

	frames.options.advanced.page = wt.CreateOptionsCategory({
		parent = frames.options.main.page.category,
		addon = addonNameSpace,
		name = "Advanced",
		title = ns.strings.options.advanced.title,
		description = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		optionsKeys = { addonNameSpace .. "Advanced" },
	})

	--[ Category Panels ]

	--Profiles
	local profilesPanel = wt.CreatePanel({
		parent = frames.options.advanced.page.canvas,
		name = "Profiles",
		title = ns.strings.options.advanced.profiles.title,
		description = ns.strings.options.advanced.profiles.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 10, y = -82 } },
		size = { height = 64 },
	})
	CreateOptionsProfiles(profilesPanel) --Add widgets

	--Backup
	local backupOptions = wt.CreatePanel({
		parent = frames.options.advanced.page.canvas,
		name = "Backup",
		title = ns.strings.options.advanced.backup.title,
		description = ns.strings.options.advanced.backup.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = profilesPanel,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 400 },
	})
	CreateBackupOptions(backupOptions) --Add widgets
end


--[[ CHAT CONTROL ]]

--[ Chat Utilities ]

---Print visibility info
---@param load boolean [Default: false]
local function PrintStatus(load)
	if load == true and not db.speedDisplay.visibility.statusNotice then return end
	print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(frames.main:IsVisible() and (
		not frames.playerSpeed.display:IsVisible() and ns.strings.chat.status.notVisible or ns.strings.chat.status.visible
	) or ns.strings.chat.status.hidden, ns.colors.yellow[0]):gsub(
		"#AUTO", wt.Color(ns.strings.chat.status.auto:gsub(
			"#STATE", wt.Color(db.speedDisplay.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.green[1])
		), ns.colors.yellow[1])
	))
end
--Print help info
local function PrintInfo()
	print(wt.Color(ns.strings.chat.help.thanks:gsub("#ADDON", wt.Color(addonTitle, ns.colors.green[0])), ns.colors.yellow[0]))
	PrintStatus()
	print(wt.Color(ns.strings.chat.help.hint:gsub("#HELP_COMMAND", wt.Color(ns.strings.chat.keyword .. " " .. ns.strings.chat.help.command, ns.colors.green[1])), ns.colors.yellow[1]))
	print(wt.Color(ns.strings.chat.help.move:gsub("#SHIFT", wt.Color(ns.strings.keys.shift, ns.colors.green[1])):gsub("#ADDON", addonTitle), ns.colors.yellow[1]))
end
--Print the command list with basic functionality info
local function PrintCommands()
	print(wt.Color(addonTitle .. " ", ns.colors.green[0]) .. wt.Color(ns.strings.chat.help.list .. ":", ns.colors.yellow[0]))
	--Index the commands (skipping the help command) and put replacement code segments in place
	local commands = {
		[0] = {
			command = ns.strings.chat.options.command,
			description = ns.strings.chat.options.description:gsub("#ADDON", addonTitle)
		},
		[1] = {
			command = ns.strings.chat.save.command,
			description = ns.strings.chat.save.description
		},
		[2] = {
			command = ns.strings.chat.preset.command,
			description = ns.strings.chat.preset.description:gsub(
				"#INDEX", wt.Color(ns.strings.chat.preset.command .. " " .. 0, ns.colors.green[1])
			)
		},
		[3] = {
			command = ns.strings.chat.toggle.command,
			description = ns.strings.chat.toggle.description:gsub(
				"#HIDDEN", wt.Color(dbc.hidden and ns.strings.chat.toggle.hidden or ns.strings.chat.toggle.notHidden, ns.colors.green[1])
			)
		},
		[4] = {
			command = ns.strings.chat.auto.command,
			description = ns.strings.chat.auto.description:gsub(
				"#STATE", wt.Color(db.speedDisplay.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.green[1])
			)
		},
		[5] = {
			command = ns.strings.chat.size.command,
			description =  ns.strings.chat.size.description:gsub(
				"#SIZE", wt.Color(ns.strings.chat.size.command .. " " .. dbDefault.speedDisplay.font.size, ns.colors.green[1])
			)
		},
		[6] = {
			command = ns.strings.chat.reset.command,
			description =  ns.strings.chat.reset.description
		},
	}
	--Print the listŁ
	for i = 0, #commands do
		print("    " .. wt.Color(ns.strings.chat.keyword .. " " .. commands[i].command, ns.colors.green[1])  .. wt.Color(" - " .. commands[i].description, ns.colors.yellow[1]))
	end
end
--Reset to defaults confirmation
local resetPopup = wt.CreatePopup({
	addon = addonNameSpace,
	name = "DefaultOptions",
	text = (wt.GetStrings("warning") or ""):gsub("#TITLE", wt.Clear(addonTitle)),
	onAccept = function()
		--Reset the options data & update the interface options
		frames.options.speedDisplays.page.default()
		frames.options.targetSpeed.page.default()
		frames.options.advanced.page.default()
	end,
})

--[ Slash Command Handlers ]

local function SaveCommand()
	--Update the Custom preset
	presets[0].data.position = wt.PackPosition(frames.main:GetPoint())
	presets[0].data.visibility.frameStrata = frames.options.speedDisplays.visibility.raise:GetChecked() and "HIGH" or "MEDIUM"
	--Save the Custom preset in the DB
	wt.CopyValues(presets[0].data, db.customPreset)
	--Update in the SavedVariabes DB
	MovementSpeedDB.customPreset = wt.Clone(db.customPreset)
	--Response
	print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.save.response, ns.colors.yellow[1]))
end
local function PresetCommand(parameter)
	local i = tonumber(parameter)
	if i ~= nil and i >= 0 and i <= #presets then
		--Update the speed display
		frames.main:Show()
		frames.main:SetFrameStrata(presets[i].data.visibility.frameStrata)
		wt.SetPosition(frames.main, presets[i].data.position)
		--Update the GUI options in case the window was open
		frames.options.speedDisplays.visibility.hidden:SetChecked(false)
		frames.options.speedDisplays.visibility.hidden:SetAttribute("loaded", true) --Update dependent widgets
		frames.options.speedDisplays.position.anchor.setSelected(presets[i].data.position.anchor)
		frames.options.speedDisplays.position.xOffset.setValue(presets[i].data.position.offset.x)
		frames.options.speedDisplays.position.yOffset.setValue(presets[i].data.position.offset.y)
		frames.options.speedDisplays.visibility.raise:SetChecked(presets[i].data.visibility.frameStrata == "HIGH")
		--Update the DBs
		dbc.hidden = false
		wt.CopyValues(presets[i].data.position, db.speedDisplay.position)
		db.speedDisplay.visibility.frameStrata = presets[i].data.visibility.frameStrata
		--Update in the SavedVariabes DB
		MovementSpeedDBC.hidden = false
		MovementSpeedDB.speedDisplay.position = wt.Clone(db.speedDisplay.position)
		MovementSpeedDB.speedDisplay.visibility.frameStrata = db.speedDisplay.visibility.frameStrata
		--Response
		print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.preset.response:gsub(
			"#PRESET", wt.Color(presets[i].name, ns.colors.green[1])
		), ns.colors.yellow[1]))
	else
		--Error
		print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.preset.unchanged, ns.colors.yellow[0]))
		print(wt.Color(ns.strings.chat.preset.error:gsub("#INDEX", wt.Color(ns.strings.chat.preset.command .. " " .. 0, ns.colors.green[1])), ns.colors.yellow[1]))
		print(wt.Color(ns.strings.chat.preset.list, ns.colors.green[1]))
		for j = 0, #presets, 2 do
			local list = "    " .. wt.Color(j, ns.colors.green[1]) .. wt.Color(" - " .. presets[j].name, ns.colors.yellow[1])
			if j + 1 <= #presets then list = list .. "    " .. wt.Color(j + 1, ns.colors.green[1]) .. wt.Color(" - " .. presets[j + 1].name, ns.colors.yellow[1]) end
			print(list)
		end
	end
end
local function ToggleCommand()
	--Update the DBs
	dbc.hidden = not dbc.hidden
	MovementSpeedDBC.hidden = dbc.hidden
	--Update the GUI option in case it was open
	frames.options.speedDisplays.visibility.hidden:SetChecked(dbc.hidden)
	frames.options.speedDisplays.visibility.hidden:SetAttribute("loaded", true) --Update dependent widgets
	--Update the visibility
	wt.SetVisibility(frames.main, not dbc.hidden)
	--Response
	print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(dbc.hidden and ns.strings.chat.toggle.hiding or ns.strings.chat.toggle.unhiding, ns.colors.yellow[1]))
end
local function AutoCommand()
	--Update the DBs
	db.speedDisplay.visibility.autoHide = not db.speedDisplay.visibility.autoHide
	MovementSpeedDB.speedDisplay.visibility.autoHide = db.speedDisplay.visibility.autoHide
	--Update the GUI option in case it was open
	frames.options.speedDisplays.visibility.autoHide:SetChecked(db.speedDisplay.visibility.autoHide)
	frames.options.speedDisplays.visibility.autoHide:SetAttribute("loaded", true) --Update dependent widgets
	--Response
	print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.auto.response:gsub(
		"#STATE", wt.Color(db.speedDisplay.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.green[1])
	), ns.colors.yellow[1]))
end
local function SizeCommand(parameter)
	local size = tonumber(parameter)
	if size ~= nil then
		--Update the DBs
		db.speedDisplay.font.size = size
		MovementSpeedDB.speedDisplay.text.font.size = db.speedDisplay.font.size
		--Update the GUI option in case it was open
		frames.options.speedDisplays.font.size.setValue(size)
		--Update the font
		frames.playerSpeed.text:SetFont(db.speedDisplay.font.family, db.speedDisplay.font.size, "THINOUTLINE")
		frames.playerSpeed.text:SetPoint("CENTER", 0.9, math.fmod(db.speedDisplay.font.size, 2) ~= 0 and 0.1 or 0)
		SetDisplaySize("playerSpeed")
		SetDisplaySize("travelSpeed")
		--Response
		print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.size.response:gsub("#VALUE", wt.Color(size, ns.colors.green[1])), ns.colors.yellow[1]))
	else
		--Error
		print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.size.unchanged, ns.colors.yellow[0]))
		print(wt.Color(ns.strings.chat.size.error:gsub(
			"#SIZE", wt.Color(ns.strings.chat.size.command .. " " .. dbDefault.speedDisplay.font.size, ns.colors.green[1])
		), ns.colors.yellow[1]))
	end
end
local function ResetCommand()
	StaticPopup_Show(resetPopup)
end

SLASH_MOVESPEED1 = ns.strings.chat.keyword
function SlashCmdList.MOVESPEED(line)
	local command, parameter = strsplit(" ", line)
	if command == ns.strings.chat.help.command then PrintCommands()
	elseif command == ns.strings.chat.options.command then frames.options.main.page.open()
	elseif command == ns.strings.chat.save.command then SaveCommand()
	elseif command == ns.strings.chat.preset.command then PresetCommand(parameter)
	elseif command == ns.strings.chat.toggle.command then ToggleCommand()
	elseif command == ns.strings.chat.auto.command then AutoCommand()
	elseif command == ns.strings.chat.size.command then SizeCommand(parameter)
	elseif command == ns.strings.chat.reset.command then ResetCommand()
	else PrintInfo() end
end


--[[ INITIALIZATION ]]

--[ Frames & Events ]

--Set up the speed display context menu
local function CreateContextMenu()
	local contextMenu = wt.CreateContextMenu({ parent = frames.playerSpeed.display, })

	--[ Items ]

	wt.AddContextLabel(contextMenu, { text = addonTitle, })

	--Options submenu
	local optionsMenu = wt.AddContextSubmenu(contextMenu, {
		title = ns.strings.misc.options,
	})

	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.main.name,
		tooltip = { lines = { { text = ns.strings.options.main.description:gsub("#ADDON", addonTitle):gsub("#KEYWORD", ns.strings.chat.keyword), }, } },
		events = { OnClick = function() frames.options.main.page.open() end, },
	})
	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.speedDisplay.title,
		tooltip = { lines = {
			{ text = ns.strings.options.speedDisplay.description:gsub("#ADDON", addonTitle), },
			{ text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, },
		} },
		events = { OnClick = function() frames.options.speedDisplays.page.open() end, },
		disabled = true,
	})
	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.targetSpeed.title,
		tooltip = { lines = {
			{ text = ns.strings.options.targetSpeed.description:gsub("#ADDON", addonTitle), },
			{ text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, },
		} },
		events = { OnClick = function() frames.options.targetSpeed.page.open() end, },
		disabled = true,
	})
	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.advanced.title,
		tooltip = { lines = {
			{ text = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle), },
			{ text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, },
		} },
		events = { OnClick = function() frames.options.advanced.page.open() end, },
		disabled = true,
	})

	--Presets submenu
	local presetsMenu = wt.AddContextSubmenu(contextMenu, {
		title = ns.strings.options.speedDisplay.quick.presets.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.quick.presets.tooltip, }, } },
	})

	wt.AddContextButton(presetsMenu, contextMenu, {
		title = presets[0].name,
		events = { OnClick = function() PresetCommand(0) end, },
	})
	wt.AddContextButton(presetsMenu, contextMenu, {
		title = presets[1].name,
		events = { OnClick = function() PresetCommand(1) end, },
	})
end

--Main frame
frames.main = wt.CreateFrame({
	parent = UIParent,
	name = addonNameSpace,
	keepInBounds = true,
	size = { width = 33, height = 10 },
	keepOnTop = true,
	onEvent = {
		ADDON_LOADED = function(self, addon)
			if addon ~= addonNameSpace then return end
			self:UnregisterEvent("ADDON_LOADED")

			--[ DBs ]

			--Load & check the DBs
			if LoadDBs() then PrintInfo() end

			--Load the custom preset
			presets[0].data = wt.Clone(db.customPreset)

			--Create cross-session character-specific variables
			if cs.compactBackup == nil then cs.compactBackup = true end

			--[ Frame Setup ]

			--Position
			wt.SetPosition(self, db.speedDisplay.position)

			--Make movable
			wt.SetMovability(frames.main, true, "SHIFT", { frames.playerSpeed.display, frames.travelSpeed.display }, {
				onStop = function()
					--Save the position (for account-wide use)
					wt.CopyValues(wt.PackPosition(frames.main:GetPoint()), db.speedDisplay.position)

					--Update in the SavedVariabes DB
					MovementSpeedDB.speedDisplay.position = wt.Clone(db.speedDisplay.position)

					--Update the GUI options in case the window was open
					frames.options.speedDisplays.position.anchor.setSelected(db.speedDisplay.position.anchor)
					frames.options.speedDisplays.position.xOffset.setValue(db.speedDisplay.position.offset.x)
					frames.options.speedDisplays.position.yOffset.setValue(db.speedDisplay.position.offset.y)

					--Chat response
					print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.position.save, ns.colors.yellow[1]))
				end,
				onCancel = function()
					--Reset the position
					wt.SetPosition(frames.main, db.speedDisplay.position)

					--Chat response
					print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.position.cancel, ns.colors.yellow[0]))
					print(wt.Color(ns.strings.chat.position.error:gsub("#SHIFT", ns.strings.keys.shift), ns.colors.yellow[1]))
				end
			})

			--Speed displays
			LoadSpeedDisplays()
			CreateContextMenu()

			--Set up the interface options
			LoadInterfaceOptions()
		end,
		PLAYER_ENTERING_WORLD = function(self)
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")

			--Visibility notice
			if not self:IsVisible() or not frames.playerSpeed.display:IsVisible() then PrintStatus(true) end

			--Start speed updates
			StartPlayerSpeedUpdates()
			if db.travelSpeed.enabled then StartTravelSpeedUpdates() end
			if db.targetSpeed.enabled then SetUpTargetSpeedUpdates() end
		end,
		PET_BATTLE_OPENING_START = function(self) self:Hide() end,
		PET_BATTLE_CLOSE = function(self) self:Show() end,
	}
})

--Player Speed display
frames.playerSpeed.display = wt.CreateFrame({
	parent = frames.main,
	name = "PlayerSpeed",
	customizable = true,
	position = { anchor = "CENTER" },
	keepInBounds = true,
	events = {
		OnUpdate = function()
			--Update the speed display tooltip
			if frames.playerSpeed.display:IsMouseOver() and ns.tooltip:IsVisible() then wt.UpdateTooltip({
				parent = frames.playerSpeed.display,
				tooltip = ns.tooltip,
				title = ns.strings.speedTooltip.title,
				lines = GetSpeedTooltipLines(),
				flipColors = true,
				anchor = "ANCHOR_BOTTOMRIGHT",
				offset = { y = frames.playerSpeed.display:GetHeight() },
			}) end
		end,
	},
})
frames.playerSpeed.text = wt.CreateText({
	parent = frames.playerSpeed.display,
	position = { anchor = "CENTER", },
	layer = "OVERLAY",
})
frames.playerSpeed.updater = wt.CreateFrame({
	parent = frames.main,
	name = "PlayerSpeedUpdater",
})

--Travel Speed display
frames.travelSpeed.display = wt.CreateFrame({
	parent = frames.main,
	name = "TravelSpeed",
	customizable = true,
	position = {
		anchor = "CENTER",
		offset = { y = -14 }
	},
	keepInBounds = true,
})
frames.travelSpeed.text = wt.CreateText({
	parent = frames.travelSpeed.display,
	position = { anchor = "CENTER", },
	layer = "OVERLAY",
})
frames.travelSpeed.updater = wt.CreateFrame({
	parent = frames.main,
	name = "TravelSpeedUpdater",
	onEvent = { ZONE_CHANGED_NEW_AREA = function() mapWidth, mapHeight = C_Map.GetMapWorldSize(C_Map.GetBestMapForUnit("player")) end, }
})

--Target Speed updater
frames.targetSpeed = wt.CreateFrame({
	parent = frames.main,
	name = addonNameSpace .. "TargetSpeed",
	append = false,
})