--[[ RESOURCES ]]

---Addon namespace
---@class ns
local addonNameSpace, ns = ...

---WidgetTools toolbox
---@class wt
local wt = ns.WidgetToolbox

--Addon title
local addonTitle = wt.Clear(select(2, C_AddOns.GetAddOnInfo(addonNameSpace))):gsub("^%s*(.-)%s*$", "%1")

--Custom Tooltip
ns.tooltip = wt.CreateGameTooltip(addonNameSpace)

--[ Data Tables ]

local db = {} --Account-wide options
local dbc = {} --Character-specific options
local cs --Cross-session account-wide data

--Default values
local dbDefault = {
	speedDisplay = {
		visibility = {
			autoHide = false,
			statusNotice = true,
		},
		position = {
			anchor = "TOP",
			offset = { x = 0, y = -100 }
		},
		layer = {
			strata = "MEDIUM",
		},
		value = {
			units = { true, false, false },
			fractionals = 0,
			noTrim = false,
		},
		font = {
			family = ns.fonts[1].path,
			size = 11,
			valueColoring = true,
			color = { r = 1, g = 1, b = 1, a = 1 },
			alignment = "CENTER",
		},
		background = {
			visible = false,
			colors = {
				bg = { r = 0, g = 0, b = 0, a = 0.5 },
				border = { r = 1, g = 1, b = 1, a = 0.4 },
			},
		},
	},
	playerSpeed = {
		enabled = true,
		throttle = false,
		frequency = 0.15,
	},
	targetSpeed = {
		enabled = true,
		value = {
			units = { true, true, false },
			fractionals = 0,
			noTrim = false,
		},
	},
}
local dbcDefault = {
	hidden = false,
}

--Preset data
local presets = {
	{
		name = ns.strings.misc.custom, --Custom
		data = {
			position = dbDefault.speedDisplay.position,
			layer = {
				strata = dbDefault.speedDisplay.layer.strata,
			},
		},
	},
	{
		name = ns.strings.options.speedDisplay.position.presets.list[1], --Under Minimap
		data = {
			position = {
				anchor = "TOPRIGHT",
				offset = { x = -69, y = -178 }
			},
			layer = {
				strata = "MEDIUM"
			},
		},
	},
}

--Add custom preset to DB
dbDefault.customPreset = wt.Clone(presets[1].data)

--[ References ]

--Local frame references
local frames = {
	playerSpeed = {},
	options = {
		main = {},
		speedDisplays = {
			visibility = {},
			position = {},
			value = {},
			font = {},
			background = {
				colors = {},
				size = {},
			},
		},
		playerSpeed = {},
		targetSpeed = {
			value = {},
		},
		advanced = {
			backup = {},
		},
	},
}

--Speed values
local speed = {
	player = {
		yards = 0,
	},
	target = {
		yards = 0,
	}
}

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

--[ DB Management ]

--Check the validity of the provided key value pair
local function CheckValidity(k, v)
	if type(v) == "number" then
		--Non-negative
		if k == "size" then return v > 0 end
		--Range constraint: 0 - 1
		if k == "r" or k == "g" or k == "b" or k == "a" then return v >= 0 and v <= 1 end
		--Corrupt Anchor Points
		if k == "anchor" then return false end
	end return true
end

--Check & fix the account-wide & character-specific DBs
---@param dbCheck table
---@param dbSample table
---@param dbcCheck table
---@param dbcSample table
local function CheckDBs(dbCheck, dbSample, dbcCheck, dbcSample)
	wt.RemoveEmpty(dbCheck, CheckValidity)
	wt.RemoveEmpty(dbcCheck, CheckValidity)
	wt.AddMissing(dbCheck, dbSample)
	wt.AddMissing(dbcCheck, dbcSample)
	wt.RemoveMismatch(dbCheck, dbSample, {
		["preset.point"] = { saveTo = dbCheck.customPreset.position, saveKey = "anchor" },
		["customPreset.position.point"] = { saveTo = dbCheck.customPreset.position, saveKey = "anchor" },
		["preset.offsetX"] = { saveTo = dbCheck.customPreset.position.offset, saveKey = "x" },
		["preset.offsetY"] = { saveTo = dbCheck.customPreset.position.offset, saveKey = "y" },
		["position.point"] = { saveTo = dbCheck.speedDisplay.position, saveKey = "anchor" },
		["speedDisplay.position.point"] = { saveTo = dbCheck.speedDisplay.position, saveKey = "anchor" },
		["position.offset.x"] = { saveTo = dbCheck.speedDisplay.position.offset, saveKey = "x" },
		["position.offset.y"] = { saveTo = dbCheck.speedDisplay.position.offset, saveKey = "y" },
		["visibility.frameStrata"] = { saveTo = dbCheck.speedDisplay.layer, saveKey = "strata" },
		["appearance.frameStrata"] = { saveTo = dbCheck.speedDisplay.layer, saveKey = "strata" },
		["speedDisplay.visibility.frameStrata"] = { saveTo = dbCheck.speedDisplay.layer, saveKey = "strata" },
		["visibility.backdrop"] = { saveTo = dbCheck.speedDisplay.background, saveKey = "visible" },
		["appearance.backdrop.visible"] = { saveTo = dbCheck.speedDisplay.background, saveKey = "visible" },
		["appearance.backdrop.color.r"] = { saveTo = dbCheck.speedDisplay.background.colors.bg, saveKey = "r" },
		["appearance.backdrop.color.g"] = { saveTo = dbCheck.speedDisplay.background.colors.bg, saveKey = "g" },
		["appearance.backdrop.color.b"] = { saveTo = dbCheck.speedDisplay.background.colors.bg, saveKey = "b" },
		["appearance.backdrop.color.a"] = { saveTo = dbCheck.speedDisplay.background.colors.bg, saveKey = "a" },
		["fontSize"] = { saveTo = dbCheck.speedDisplay.font, saveKey = "size" },
		["font.size"] = { saveTo = dbCheck.speedDisplay.font, saveKey = "size" },
		["speedDisplay.text.font.size"] = { saveTo = dbCheck.speedDisplay.font, saveKey = "size" },
		["font.family"] = { saveTo = dbCheck.speedDisplay.font, saveKey = "family" },
		["speedDisplay.text.font.family"] = { saveTo = dbCheck.speedDisplay.font, saveKey = "family" },
		["font.color.r"] = { saveTo = dbCheck.speedDisplay.font.color, saveKey = "r" },
		["speedDisplay.text.font.color.r"] = { saveTo = dbCheck.speedDisplay.font.color, saveKey = "r" },
		["font.color.g"] = { saveTo = dbCheck.speedDisplay.font.color, saveKey = "g" },
		["speedDisplay.text.font.color.g"] = { saveTo = dbCheck.speedDisplay.font.color, saveKey = "g" },
		["font.color.b"] = { saveTo = dbCheck.speedDisplay.font.color, saveKey = "b" },
		["speedDisplay.text.font.color.b"] = { saveTo = dbCheck.speedDisplay.font.color, saveKey = "b" },
		["font.color.a"] = { saveTo = dbCheck.speedDisplay.font.color, saveKey = "a" },
		["speedDisplay.text.font.color.a"] = { saveTo = dbCheck.speedDisplay.font.color, saveKey = "a" },
		["speedDisplay.font.text.valueType"] = { saveTo = dbCheck.speedDisplay.value, saveKey = "units" },
		["speedDisplay.value.type"] = { saveTo = dbCheck.speedDisplay.value, saveKey = "units" },
		["speedDisplay.font.text.decimals"] = { saveTo = dbCheck.speedDisplay.value, saveKey = "fractionals" },
		["speedDisplay.value.decimals"] = { saveTo = dbCheck.speedDisplay.value, saveKey = "fractionals" },
		["speedDisplay.font.text.noTrim"] = { saveTo = dbCheck.speedDisplay.value, saveKey = "noTrim" },
		["targetSpeed.tooltip.enabled"] = { saveTo = dbCheck.targetSpeed, saveKey = "enabled" },
		["targetSpeed.tooltip.text.valueType"] = { saveTo = dbCheck.targetSpeed.value, saveKey = "units" },
		["targetSpeed.value.type"] = { saveTo = dbCheck.targetSpeed.value, saveKey = "units" },
		["targetSpeed.tooltip.text.decimals"] = { saveTo = dbCheck.targetSpeed.value, saveKey = "fractionals" },
		["targetSpeed.value.decimals"] = { saveTo = dbCheck.targetSpeed.value, saveKey = "fractionals" },
		["targetSpeed.tooltip.text.noTrim"] = { saveTo = dbCheck.targetSpeed.value, saveKey = "noTrim" },
		["visibility.hidden"] = { saveTo = dbcCheck, saveKey = "hidden" },
		["appearance.hidden"] = { saveTo = dbcCheck, saveKey = "hidden" },
	})
	wt.RemoveMismatch(dbcCheck, dbcSample, {
		["hidden"] = { saveTo = dbcCheck, saveKey = "hidden" },
	})

	--Convert value type units
	if type(dbCheck.speedDisplay.value.units) == "number" then dbCheck.speedDisplay.value.units = {
		dbCheck.speedDisplay.value.units == 0 or dbCheck.speedDisplay.value.units == 2,
		dbCheck.speedDisplay.value.units == 1 or dbCheck.speedDisplay.value.units == 2,
		false
	} end
	if type(dbCheck.targetSpeed.value.units) == "number" then dbCheck.targetSpeed.value.units = {
		dbCheck.targetSpeed.value.units == 0 or dbCheck.targetSpeed.value.units == 2,
		dbCheck.targetSpeed.value.units == 1 or dbCheck.targetSpeed.value.units == 2,
		false
	} end
end

--[ Speed Update ]

--Get the current Player Speed values accessible through **speed**
local function UpdatePlayerSpeed()
	speed.player.yards = GetUnitSpeed("player")
end

---Format the specified speed value based on the DB specifications
---@param type string
---@return string
local function FormatSpeedValue(type)
	local target = type == "target"
	local key = target and "targetSpeed" or "speedDisplay"
	local f = max(db[key].value.fractionals, 1)

	return (target and speedText.target or db.speedDisplay.font.valueColoring and speedText.display or wt.Clear(speedText.display)):gsub(
		"#PERCENT", wt.FormatThousands(speed[type].yards / 7 * 100, db[key].value.fractionals, true, not db[key].value.noTrim) .. (target and "%%%%" or "")
	):gsub(
		"#YARDS", wt.FormatThousands(speed[type].yards, db[key].value.fractionals, true, not db[key].value.noTrim)
	)
end

---Refresh the specified speed text template string to be filled with speed values when displaying it
---@param template string
---@param units table
local function UpdateSpeedText(template, units)
	speedText[template] = ""

	if units[1] then speedText[template] = speedText[template] .. ns.strings.speedValue.separator .. wt.Color("#PERCENT%", ns.colors.green[2]) end
	if units[2] then speedText[template] = speedText[template] .. ns.strings.speedValue.separator .. wt.Color(ns.strings.speedValue.yps:gsub(
		"#YARDS", wt.Color("#YARDS", ns.colors.yellow[2])
	), ns.colors.yellow[1]) end

	speedText[template] = speedText[template]:sub(#ns.strings.speedValue.separator)
end

--[ Speed Displays ]

---Set the size of the speed display
---@param height? number Text height | ***Default:*** speedDisplayText:GetStringHeight()
---@param units? table Displayed units | ***Default:*** db.speedDisplay.value.units
---@param fractionals? number Height:Width ratio | ***Default:*** db.speedDisplay.value.fractionals
---@param font? string Font path | ***Default:*** db.speedDisplay.font.family
local function SetDisplaySize(display, height, units, fractionals, font)
	height = math.ceil(height or frames[display].text:GetStringHeight()) + 2.4
	units = units or db.speedDisplay.value.units
	fractionals = fractionals or db.speedDisplay.value.fractionals

	--Calculate width to height ratio
	local ratio = 0
	if units[1] then ratio = ratio + 3.58 + (fractionals > 0 and 0.1 + 0.54 * fractionals or 0) end
	if units[2] then ratio = ratio + 3.52 + (fractionals > 0 and 0.1 + 0.54 * fractionals or 0) end
	if units[3] then ratio = ratio + 5.34 + 1.08 * max(fractionals, 1) end
	for i = 1, 3 do if units[i] then ratio = ratio + 0.2 end end --Separators

	--Resize the display
	frames[display].display:SetSize(height * ratio * ns.fonts[GetFontID(font or db.speedDisplay.font.family)].widthRatio - 4, height)
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
	frames.main:SetFrameStrata(data.speedDisplay.layer.strata)
	wt.SetVisibility(frames.main, not characterData.hidden)

	--Display
	SetDisplaySize(display, data.speedDisplay.font.size, data.speedDisplay.value.units, data.speedDisplay.value.fractionals, data.speedDisplay.font.family)
	SetDisplayBackdrop(display, data.speedDisplay.background.visible, data.speedDisplay.background.colors.bg, data.speedDisplay.background.colors.border)

	--Font & text
	frames[display].text:SetFont(data.speedDisplay.font.family, data.speedDisplay.font.size, "THINOUTLINE")
	frames[display].text:SetTextColor(wt.UnpackColor(db.speedDisplay.font.valueColoring and ns.colors.grey[2] or db.speedDisplay.font.color))
	frames[display].text:SetJustifyH(data.speedDisplay.font.alignment)
	wt.SetPosition(frames[display].text, { anchor = data.speedDisplay.font.alignment, })
end

---Apply a specific display preset
---@param i integer Index of the preset
local function ApplyPreset(i)
	--Update the speed display
	frames.main:Show()
	wt.SetPosition(frames.main, presets[i].data.position)
	frames.main:SetFrameStrata(presets[i].data.layer.strata)

	--Convert to absolute position
	wt.ConvertToAbsolutePosition(frames.main)

	--Update the DBs
	dbc.hidden = false
	wt.CopyValues(wt.PackPosition(frames.main:GetPoint()), db.speedDisplay.position)
	db.speedDisplay.layer.strata = presets[i].data.layer.strata

	--Update the options widgets
	frames.options.speedDisplays.visibility.hidden.setState(false)
	frames.options.speedDisplays.visibility.hidden:SetAttribute("loaded", true) --Update dependent widgets
	frames.options.speedDisplays.position.anchor.setSelected(db.speedDisplay.position.anchor)
	frames.options.speedDisplays.position.xOffset.setValue(db.speedDisplay.position.offset.x)
	frames.options.speedDisplays.position.yOffset.setValue(db.speedDisplay.position.offset.y)
	frames.options.speedDisplays.position.frameStrata.setSelected(db.speedDisplay.layer.strata)
end

--Save the current display position & visibility to the custom preset
local function UpdateCustomPreset()
	--Update the Custom preset
	presets[1].data.position = wt.PackPosition(frames.main:GetPoint())
	presets[1].data.layer.strata = frames.main:GetFrameStrata()
	wt.CopyValues(presets[1].data, db.customPreset) --Update the DB
	MovementSpeedDB.customPreset = wt.Clone(db.customPreset) --Commit to the SavedVariables DB

	--Update the presets widget
	frames.options.speedDisplays.position.presets.setSelected(1)
end

--Reset the custom preset to its default state
local function ResetCustomPreset()
	--Reset the Custom preset
	presets[1].data = wt.Clone(dbDefault.customPreset)
	wt.CopyValues(presets[1].data, db.customPreset) --Update the DB
	MovementSpeedDB.customPreset = wt.Clone(db.customPreset) --Commit to the SavedVariables DB

	--Apply the Custom preset
	ApplyPreset(1)
	frames.options.speedDisplays.position.presets.setSelected(1) --Update the presets widget
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
			text = "\n" .. ns.strings.speedTooltip.text[2]:gsub("#PERCENT", wt.Color(wt.FormatThousands(speed[type].yards / 7 * 100, 2, true) .. "%%", ns.colors.green[2])),
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
end

--[ Player Speed ]

--Start updating the Player Speed display
local function StartPlayerSpeedUpdates()
	if db.playerSpeed.throttle then
		--Start a repeating timer
		frames.playerSpeed.updater.ticker = C_Timer.NewTicker(db.playerSpeed.frequency, function()
			UpdatePlayerSpeed()
			frames.playerSpeed.text:SetText(FormatSpeedValue("player"))
			wt.SetVisibility(frames.playerSpeed.display, not db.speedDisplay.visibility.autoHide or speed.player.yards ~= 0)
		end)
	else
		--Set an update event
		frames.playerSpeed.updater:SetScript("OnUpdate", function()
			UpdatePlayerSpeed()
			frames.playerSpeed.text:SetText(FormatSpeedValue("player"))
			wt.SetVisibility(frames.playerSpeed.display, not db.speedDisplay.visibility.autoHide or speed.player.yards ~= 0)
		end)
	end
end

--Stop updating the Player Speed display
local function StopPlayerSpeedUpdates()
	--Stop speed updates
	frames.playerSpeed.updater:SetScript("OnUpdate", nil)
	if frames.playerSpeed.updater.ticker then frames.playerSpeed.updater.ticker:Cancel() end
end

--[ Target Speed ]

---Assemble the text for the mouseover target's speed
---@return string
local function GetTargetSpeedText()
	return "|T" .. ns.textures.logo .. ":0|t" .. " " .. ns.strings.targetSpeed:gsub("#SPEED", wt.Color(FormatSpeedValue("target"), ns.colors.grey[2]))
end

--Set up the Target Speed unit tooltip integration
local targetSpeedEnabled = false
local function EnableTargetSpeedUpdates()
	targetSpeedEnabled = true

	--Start mouseover Target Speed updates
	GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip)
		if not db.targetSpeed.enabled then return end

		frames.targetSpeed:SetScript("OnUpdate", function()
			if UnitName("mouseover") == nil then return end

			--Update target speed values
			speed.target.yards = GetUnitSpeed("mouseover")

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


--[[ INTERFACE OPTIONS ]]

--Resources
local valueTypes = {}
for i = 1, #ns.strings.options.speedValue.units.list - 1 do
	valueTypes[i] = {}
	valueTypes[i].title = ns.strings.options.speedValue.units.list[i].label
	valueTypes[i].tooltip = { lines = { { text = ns.strings.options.speedValue.units.list[i].tooltip, }, } }
end

--[ Main ]

--Create the widgets
local function CreateOptionsShortcuts(panel)
	--Button: Speed Display page
	wt.CreateButton({
		parent = panel,
		name = "SpeedDisplayPage",
		title = ns.strings.options.speedDisplay.title,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.description:gsub("#ADDON", addonTitle), }, } },
		arrange = {},
		size = { width = 120, },
		events = { OnClick = function() frames.options.speedDisplays.page.open() end, },
	})

	--Button: Target Speed page
	wt.CreateButton({
		parent = panel,
		name = "TargetSpeedPage",
		title = ns.strings.options.targetSpeed.title,
		tooltip = { lines = { { text = ns.strings.options.targetSpeed.description:gsub("#ADDON", addonTitle), }, } },
		position = { offset = { x = 140, y = -30 } },
		size = { width = 120, },
		events = { OnClick = function() frames.options.targetSpeed.page.open() end, },
	})

	--Button: Advanced page
	wt.CreateButton({
		parent = panel,
		name = "AdvancedPage",
		title = ns.strings.options.advanced.title,
		tooltip = { lines = { { text = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle), }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -12, y = -30 }
		},
		size = { width = 120 },
		events = { OnClick = function() frames.options.advanced.page.open() end, },
	})
end
local function CreateAboutInfo(panel)
	--Text: Version
	local version = wt.CreateText({
		parent = panel,
		name = "VersionTitle",
		position = { offset = { x = 16, y = -32 } },
		width = 45,
		text = ns.strings.options.main.about.version .. ":",
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
		text = ns.strings.options.main.about.date .. ":",
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
		parent = panel,
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
		text = ns.strings.options.main.about.license .. ":",
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
		parent = panel,
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
		parent = panel,
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
		parent = panel,
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
	local changelog = wt.CreateEditScrollBox({
		parent = panel,
		name = "Changelog",
		title = ns.strings.options.main.about.changelog.label,
		tooltip = { lines = { { text = ns.strings.options.main.about.changelog.tooltip, }, } },
		arrange = {},
		size = { width = panel:GetWidth() - 225, height = panel:GetHeight() - 42 },
		text = ns.GetChangelog(true),
		font = { normal = "GameFontDisableSmall", },
		color = ns.colors.grey[2],
		readOnly = true,
		scrollSpeed = 50,
	})

	--Button: Full changelog
	local changelogFrame
	wt.CreateButton({
		parent = panel,
		name = "OpenFullChangelog",
		title = ns.strings.options.main.about.openFullChangelog.label,
		tooltip = { lines = { { text = ns.strings.options.main.about.openFullChangelog.tooltip, }, } },
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
					title = ns.strings.options.main.about.fullChangelog.label:gsub("#ADDON", addonTitle),
					position = { anchor = "CENTER", },
					keepInBounds = true,
					size = { width = 740, height = 560 },
					background = { color = { a = 0.9 }, },
					initialize = function(windowPanel)
						--EditScrollBox: Full changelog
						wt.CreateEditScrollBox({
							parent = windowPanel,
							name = "FullChangelog",
							title = ns.strings.options.main.about.fullChangelog.label:gsub("#ADDON", addonTitle),
							label = false,
							tooltip = { lines = { { text = ns.strings.options.main.about.fullChangelog.tooltip, }, } },
							arrange = {},
							size = { width = windowPanel:GetWidth() - 32, height = windowPanel:GetHeight() - 88 },
							text = ns.GetChangelog(),
							font = { normal = "GameFontDisable", },
							color = ns.colors.grey[2],
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
end

--Create the category page
local function CreateMainOptions()
	---@type optionsPage
	frames.options.main.page = wt.CreateOptionsCategory({
		addon = addonNameSpace,
		name = "Main",
		description = ns.strings.options.main.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		titleLogo = true,
		initialize = function(canvas)
			--Panel: Shortcuts
			wt.CreatePanel({
				parent = canvas,
				name = "Shortcuts",
				title = ns.strings.options.main.shortcuts.title,
				description = ns.strings.options.main.shortcuts.description:gsub("#ADDON", addonTitle),
				arrange = {},
				initialize = CreateOptionsShortcuts,
				arrangement = {}
			})

			--Panel: About
			wt.CreatePanel({
				parent = canvas,
				name = "About",
				title = ns.strings.options.main.about.title,
				description = ns.strings.options.main.about.description:gsub("#ADDON", addonTitle),
				arrange = {},
				size = { height = 258 },
				initialize = CreateAboutInfo,
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
					title = ns.strings.options.main.sponsors.title,
					description = ns.strings.options.main.sponsors.description,
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
end

--[ Speed Display ]

--Create the widgets
local function CreateVisibilityOptions(panel)
	--Checkbox: Hidden
	---@type checkbox
	frames.options.speedDisplays.visibility.hidden = wt.CreateCheckbox({
		parent = panel,
		name = "Hidden",
		title = ns.strings.options.speedDisplay.visibility.hidden.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.hidden.tooltip:gsub("#ADDON", addonTitle), }, } },
		arrange = {},
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = dbc,
			storageKey = "hidden",
			onChange = { DisplayToggle = function() wt.SetVisibility(frames.main, not dbc.hidden) end, }
		}
	})

	--Checkbox: Auto-hide toggle
	---@type checkbox
	frames.options.speedDisplays.visibility.autoHide = wt.CreateCheckbox({
		parent = panel,
		name = "AutoHide",
		title = ns.strings.options.speedDisplay.visibility.autoHide.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.autoHide.tooltip, }, } },
		arrange = { newRow = false, },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.visibility,
			storageKey = "autoHide",
		}
	})

	--Checkbox: Status notice
	---@type checkbox
	frames.options.speedDisplays.visibility.status = wt.CreateCheckbox({
		parent = panel,
		name = "StatusNotice",
		title = ns.strings.options.speedDisplay.visibility.statusNotice.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.visibility.statusNotice.tooltip, }, } },
		arrange = { newRow = false, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.visibility,
			storageKey = "statusNotice",
		}
	})
end
local function CreatePositionOptions(panel)
	--Dropdown: Apply a preset
	local presetItems = {}
	for i = 1, #presets do
		presetItems[i] = {}
		presetItems[i].title = presets[i].name
		presetItems[i].onSelect = function() ApplyPreset(i) end
	end
	---@type dropdown
	frames.options.speedDisplays.position.presets = wt.CreateDropdown({
		parent = panel,
		name = "ApplyPreset",
		title = ns.strings.options.speedDisplay.position.presets.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.presets.tooltip, }, } },
		arrange = {},
		width = 180,
		items = presetItems,
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			onLoad = function(self) self.setSelected(nil, ns.strings.options.speedDisplay.position.presets.select) end,
		}
	})

	--Button & Popup: Save Custom preset
	local savePopup = wt.CreatePopup({
		addon = addonNameSpace,
		name = "SAVEPRESET",
		text = ns.strings.options.speedDisplay.position.savePreset.warning:gsub("#CUSTOM", presets[1].name),
		accept = ns.strings.misc.override,
		onAccept = function()
			UpdateCustomPreset()

			--Notification
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.save.response:gsub(
				"#CUSTOM", wt.Color(presets[1].name, ns.colors.green[2])
			), ns.colors.yellow[2]))
		end,
	})
	wt.CreateButton({
		parent = panel,
		name = "SavePreset",
		title = ns.strings.options.speedDisplay.position.savePreset.label:gsub("#CUSTOM", presets[1].name),
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.savePreset.tooltip:gsub("#CUSTOM", presets[1].name), }, } },
		arrange = { newRow = false, },
		size = { width = 170, height = 26 },
		events = { OnClick = function() StaticPopup_Show(savePopup) end, },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
	})

	--Button & Popup: Reset Custom preset
	local resetPopup = wt.CreatePopup({
		addon = addonNameSpace,
		name = "RESETPRESET",
		text = ns.strings.options.speedDisplay.position.resetPreset.warning:gsub("#CUSTOM", presets[1].name),
		accept = ns.strings.misc.override,
		onAccept = function()
			ResetCustomPreset()

			--Notification
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.reset.response:gsub(
				"#CUSTOM", wt.Color(presets[1].name, ns.colors.green[2])
			), ns.colors.yellow[2]))
		end,
	})
	wt.CreateButton({
		parent = panel,
		name = "ResetPreset",
		title = ns.strings.options.speedDisplay.position.resetPreset.label:gsub("#CUSTOM", presets[1].name),
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.resetPreset.tooltip:gsub("#CUSTOM", presets[1].name), }, } },
		arrange = { newRow = false, },
		size = { width = 170, height = 26 },
		events = { OnClick = function() StaticPopup_Show(resetPopup) end, },
	})

	--Selector: Anchor point
	---@type specialSelector
	frames.options.speedDisplays.position.anchor = wt.CreateSpecialSelector({
		parent = panel,
		name = "AnchorPoint",
		title = ns.strings.options.speedDisplay.position.anchor.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.anchor.tooltip, }, } },
		arrange = {},
		width = 140,
		itemset = "anchor",
		onSelection = function() frames.options.speedDisplays.position.presets.setSelected(nil, ns.strings.options.speedDisplay.position.presets.select) end,
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.position,
			storageKey = "anchor",
			onChange = { UpdateDisplayPositions = function() wt.SetPosition(frames.main, db.speedDisplay.position) end, }
		}
	})

	--Slider: X offset
	---@type slider
	frames.options.speedDisplays.position.xOffset = wt.CreateSlider({
		parent = panel,
		name = "OffsetX",
		title = ns.strings.options.speedDisplay.position.xOffset.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.xOffset.tooltip, }, } },
		arrange = { newRow = false, },
		value = { min = -500, max = 500, fractional = 2 },
		step = 1,
		altStep = 25,
		events = { OnValueChanged = function(_, _, user) if user then
			frames.options.speedDisplays.position.presets.setSelected(nil, ns.strings.options.speedDisplay.position.presets.select)
		end end, },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.position.offset,
			storageKey = "x",
			onChange = { "UpdateDisplayPositions", }
		}
	})

	--Slider: Y offset
	---@type slider
	frames.options.speedDisplays.position.yOffset = wt.CreateSlider({
		parent = panel,
		name = "OffsetY",
		title = ns.strings.options.speedDisplay.position.yOffset.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.yOffset.tooltip, }, } },
		arrange = { newRow = false, },
		value = { min = -500, max = 500, fractional = 2 },
		step = 1,
		altStep = 25,
		events = { OnValueChanged = function(_, _, user) if user then
			frames.options.speedDisplays.position.presets.setSelected(nil, ns.strings.options.speedDisplay.position.presets.select)
		end end, },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.position.offset,
			storageKey = "y",
			onChange = { "UpdateDisplayPositions", }
		}
	})

	--Selector: Frame strata
	---@type specialSelector
	frames.options.speedDisplays.position.frameStrata = wt.CreateSpecialSelector({
		parent = panel,
		name = "FrameStrata",
		title = ns.strings.options.speedDisplay.position.strata.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.strata.tooltip, }, } },
		arrange = {},
		width = 140,
		itemset = "frameStrata",
		onSelection = function() frames.options.speedDisplays.position.presets.setSelected(nil, ns.strings.options.speedDisplay.position.presets.select) end,
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.layer,
			storageKey = "strata",
			onChange = { UpdateDisplayFrameStrata = function() frames.main:SetFrameStrata(db.speedDisplay.layer.strata) end, }
		}
	})
end
local function CreatePlayerSpeedOptions(panel)
	--Checkbox: Throttle
	---@type checkbox
	frames.options.playerSpeed.throttle = wt.CreateCheckbox({
		parent = panel,
		name = "Throttle",
		title = ns.strings.options.speedDisplay.update.throttle.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.throttle.tooltip, }, } },
		arrange = {},
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
	---@type slider
	frames.options.playerSpeed.frequency = wt.CreateSlider({
		parent = panel,
		name = "Frequency",
		title = ns.strings.options.speedDisplay.update.frequency.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.update.frequency.tooltip, }, } },
		arrange = { newRow = false, },
		value = { min = 0.05, max = 1, increment = 0.05 },
		altStep = 0.2,
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
local function CreateSpeedValueOptions(panel)
	--Selector: Units
	frames.options.speedDisplays.value.units = wt.CreateMultipleSelector({
		parent = panel,
		name = "Units",
		title = ns.strings.options.speedValue.units.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.units.tooltip, }, } },
		arrange = {},
		items = valueTypes,
		limits = { min = 1, },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.value,
			storageKey = "units",
			onChange = {
				UpdateDisplaySizes = function()
					--Player Speed
					SetDisplaySize("playerSpeed")
				end,
				UpdateSpeedTextTemplate = function() UpdateSpeedText("display", db.speedDisplay.value.units) end,
			}
		}
	})

	--Slider: Fractionals
	---@type slider
	frames.options.speedDisplays.value.fractionals = wt.CreateSlider({
		parent = panel,
		name = "Fractionals",
		title = ns.strings.options.speedValue.fractionals.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.fractionals.tooltip, }, } },
		arrange = { newRow = false, },
		value = { min = 0, max = 4, increment = 1 },
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.value,
			storageKey = "fractionals",
			onChange = { "UpdateDisplaySizes", }
		}
	})

	--Checkbox: No trim
	---@type checkbox
	frames.options.speedDisplays.value.noTrim = wt.CreateCheckbox({
		parent = panel,
		name = "NoTrim",
		title = ns.strings.options.speedValue.noTrim.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.noTrim.tooltip, }, } },
		arrange = { newRow = false, },
		autoOffset = true,
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.value,
			storageKey = "noTrim",
		}
	})
end
local function CreateFontOptions(panel)
	--Dropdown: Font family
	local fontItems = {}
	for i = 1, #ns.fonts do
		fontItems[i] = {}
		fontItems[i].title = ns.fonts[i].name
		fontItems[i].tooltip = {
			title = ns.fonts[i].name,
			lines = i == 1 and { { text = ns.strings.options.speedDisplay.font.family.default, }, } or (i == #ns.fonts and {
				{ text = ns.strings.options.speedDisplay.font.family.custom[1]:gsub("#OPTION_CUSTOM", ns.strings.misc.custom):gsub("#FILE_CUSTOM", "CUSTOM.ttf"), },
				{ text = "[WoW]\\Interface\\AddOns\\" .. addonNameSpace .. "\\Fonts\\", color = { r = 0.185, g = 0.72, b = 0.84 }, wrap = false },
				{ text = ns.strings.options.speedDisplay.font.family.custom[2]:gsub("#FILE_CUSTOM", "CUSTOM.ttf"), },
				{ text = "\n" .. ns.strings.options.speedDisplay.font.family.custom[3], color = { r = 0.89, g = 0.65, b = 0.40 }, },
			} or nil),
		}
	end
	---@type dropdown
	frames.options.speedDisplays.font.family = wt.CreateDropdown({
		parent = panel,
		name = "Family",
		title = ns.strings.options.speedDisplay.font.family.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.family.tooltip, }, } },
		arrange = {},
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
				end,
				"UpdateDisplaySizes",
				RefreshDisplayTexts = function() --Refresh the text so the font will be applied right away (if the font is loaded)
					--Player Speed
					local text = frames.playerSpeed.text:GetText()
					frames.playerSpeed.text:SetText("")
					frames.playerSpeed.text:SetText(text)
				end,
				UpdateFontFamilyDropdownText = function()
					--Update the font of the dropdown toggle button label
					local label = _G[frames.options.speedDisplays.font.family.toggle:GetName() .. "Text"]
					local _, size, flags = label:GetFont()
					label:SetFont(ns.fonts[frames.options.speedDisplays.font.family.getSelected()].path, size, flags)

					--Refresh the text so the font will be applied right away (if the font is loaded)
					local text = label:GetText()
					label:SetText("")
					label:SetText(text)
				end,
			}
		}
	})
	for i = 1, #frames.options.speedDisplays.font.family.selector.items do
		--Update fonts of the dropdown options
		local label = _G[frames.options.speedDisplays.font.family.selector.items[i]:GetName() .. "RadioButtonText"]
		local _, size, flags = label:GetFont()
		label:SetFont(ns.fonts[i].path, size, flags)
	end

	--Slider: Font size
	---@type slider
	frames.options.speedDisplays.font.size = wt.CreateSlider({
		parent = panel,
		name = "Size",
		title = ns.strings.options.speedDisplay.font.size.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.size.tooltip .. "\n\n" .. ns.strings.misc.default .. ": " .. dbDefault.speedDisplay.font.size, }, } },
		arrange = { newRow = false, },
		value = { min = 8, max = 64, increment = 1 },
		altStep = 3,
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.font,
			storageKey = "size",
			onChange = {
				"UpdateDisplayFonts",
				"UpdateDisplaySizes",
			}
		}
	})

	--Selector: Text alignment
	---@type specialSelector
	frames.options.speedDisplays.font.alignment = wt.CreateSpecialSelector({
		parent = panel,
		name = "Alignment",
		title = ns.strings.options.speedDisplay.font.alignment.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.alignment.tooltip, }, } },
		arrange = { newRow = false, },
		width = 140,
		itemset = "justifyH",
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.font,
			storageKey = "alignment",
			onChange = { UpdateDisplayTextAlignment = function()
				--Player Speed
				frames.playerSpeed.text:SetJustifyH(db.speedDisplay.font.alignment)
				wt.SetPosition(frames.playerSpeed.text, { anchor = db.speedDisplay.font.alignment, })
			end, }
		}
	})

	--Checkbox: Value coloring
	---@type checkbox
	frames.options.speedDisplays.font.valueColoring = wt.CreateCheckbox({
		parent = panel,
		name = "ValueColoring",
		title = ns.strings.options.speedDisplay.font.valueColoring.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.valueColoring.tooltip:gsub("#ADDON", addonTitle), }, } },
		arrange = {},
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.font,
			storageKey = "valueColoring",
			onChange = { UpdateDisplayFontColors = function()
				--Player Speed
				frames.playerSpeed.text:SetTextColor(wt.UnpackColor(db.speedDisplay.font.valueColoring and ns.colors.grey[2] or db.speedDisplay.font.color))
			end, }
		}
	})

	--Color Picker: Font color
	---@type colorPicker
	frames.options.speedDisplays.font.color = wt.CreateColorPicker({
		parent = panel,
		name = "Color",
		title = ns.strings.options.speedDisplay.font.color.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.font.color.tooltip, }, } },
		arrange = { newRow = false, },
		dependencies = {
			{ frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = frames.options.speedDisplays.font.valueColoring, evaluate = function(state) return not state end },
		},
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.font,
			storageKey = "color",
			onChange = { "UpdateDisplayFontColors", }
		}
	})
end
local function CreateBackgroundOptions(panel)
	--Checkbox: Visible
	---@type checkbox
	frames.options.speedDisplays.background.visible = wt.CreateCheckbox({
		parent = panel,
		name = "Visible",
		title = ns.strings.options.speedDisplay.background.visible.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.background.visible.tooltip, }, } },
		arrange = {},
		dependencies = { { frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.background,
			storageKey = "visible",
			onChange = { ToggleDisplayBackdrops = function()
				--Player Speed
				SetDisplayBackdrop("playerSpeed", db.speedDisplay.background.visible, db.speedDisplay.background.colors.bg, db.speedDisplay.background.colors.border)
			end, }
		}
	})

	--Color Picker: Background color
	---@type colorPicker
	frames.options.speedDisplays.background.colors.bg = wt.CreateColorPicker({
		parent = panel,
		name = "Color",
		title = ns.strings.options.speedDisplay.background.colors.bg.label,
		arrange = { newRow = false, },
		dependencies = {
			{ frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = frames.options.speedDisplays.background.visible, },
		},
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.background.colors,
			storageKey = "bg",
			onChange = { UpdateDisplayBackgroundColors = function()
				--Player Speed
				if frames.playerSpeed.display:GetBackdrop() ~= nil then frames.playerSpeed.display:SetBackdropColor(wt.UnpackColor(db.speedDisplay.background.colors.bg)) end
			end }
		}
	})

	--Color Picker: Border color
	---@type colorPicker
	frames.options.speedDisplays.background.colors.border = wt.CreateColorPicker({
		parent = panel,
		name = "BorderColor",
		title = ns.strings.options.speedDisplay.background.colors.border.label,
		arrange = { newRow = false, },
		dependencies = {
			{ frame = frames.options.speedDisplays.visibility.hidden, evaluate = function(state) return not state end },
			{ frame = frames.options.speedDisplays.background.visible, },
		},
		optionsData = {
			optionsKey = addonNameSpace .. "SpeedDisplays",
			workingTable = db.speedDisplay.background.colors,
			storageKey = "border",
			onChange = { UpdateDisplayBorderColors = function()
				--Player Speed
				if frames.playerSpeed.display:GetBackdrop() ~= nil then
					frames.playerSpeed.display:SetBackdropBorderColor(wt.UnpackColor(db.speedDisplay.background.colors.border))
				end
			end }
		}
	})
end

--Create the category page
local function CreateSpeedDisplayOptions()
	---@type optionsPage
	frames.options.speedDisplays.page = wt.CreateOptionsCategory({
		parent = frames.options.main.page.category,
		addon = addonNameSpace,
		name = "SpeedDisplays",
		title = ns.strings.options.speedDisplay.title,
		description = ns.strings.options.speedDisplay.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		scroll = { speed = 114, },
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
				workingTable =  db.speedDisplay,
				storageTable = MovementSpeedDB.speedDisplay,
				defaultsTable = dbDefault.speedDisplay,
			},
		},
		onSave = function() MovementSpeedDB = wt.Clone(db) end,
		onDefault = function(user)
			ResetCustomPreset()
			if not user then return end

			--Notification
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.reset.response:gsub(
				"#CUSTOM", wt.Color(presets[1].name, ns.colors.green[2])
			), ns.colors.yellow[2]))
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.defaults.response:gsub(
				"#CATEGORY", wt.Color(ns.strings.options.speedDisplay.title, ns.colors.green[2])
			), ns.colors.yellow[2]))
		end,
		initialize = function(canvas)
			--Panel: Visibility
			wt.CreatePanel({
				parent = canvas,
				name = "Visibility",
				title = ns.strings.options.speedDisplay.visibility.title,
				description = ns.strings.options.speedDisplay.visibility.description:gsub("#ADDON", addonTitle),
				arrange = {},
				initialize = CreateVisibilityOptions,
				arrangement = {}
			})

			--Panel: Position
			wt.CreatePanel({
				parent = canvas,
				name = "Position",
				title = ns.strings.options.speedDisplay.position.title,
				description = ns.strings.options.speedDisplay.position.description,
				arrange = {},
				initialize = CreatePositionOptions,
				arrangement = {}
			})

			--Panel: Player Speed
			wt.CreatePanel({
				parent = canvas,
				name = "PlayerSpeed",
				title = ns.strings.options.speedDisplay.playerSpeed.title,
				description = ns.strings.options.speedDisplay.playerSpeed.description,
				arrange = {},
				initialize = CreatePlayerSpeedOptions,
				arrangement = {}
			})

			--Panel: Value
			wt.CreatePanel({
				parent = canvas,
				name = "Value",
				title = ns.strings.options.speedValue.title,
				description = ns.strings.options.speedValue.description,
				arrange = {},
				initialize = CreateSpeedValueOptions,
				arrangement = {}
			})

			--Panel: Font
			wt.CreatePanel({
				parent = canvas,
				name = "Font",
				title = ns.strings.options.speedDisplay.font.title,
				description = ns.strings.options.speedDisplay.font.description,
				arrange = {},
				initialize = CreateFontOptions,
				arrangement = {}
			})

			--Panel: Background
			wt.CreatePanel({
				parent = canvas,
				name = "Background",
				title = ns.strings.options.speedDisplay.background.title,
				description = ns.strings.options.speedDisplay.background.description:gsub("#ADDON", addonTitle),
				arrange = {},
				initialize = CreateBackgroundOptions,
				arrangement = {}
			})
		end,
		arrangement = {}
	})
end

--[ Target Speed ]

--Create the widgets
local function CreateTargetSpeedTooltipOptions(panel)
	--Checkbox: Enabled
	---@type checkbox
	frames.options.targetSpeed.enabled = wt.CreateCheckbox({
		parent = panel,
		name = "Enabled",
		title = ns.strings.options.targetSpeed.mouseover.enabled.label,
		tooltip = { lines = { { text = ns.strings.options.targetSpeed.mouseover.enabled.tooltip:gsub("#ADDON", addonTitle), }, } },
		arrange = {},
		optionsData = {
			optionsKey = addonNameSpace .. "TargetSpeed",
			workingTable = db.targetSpeed,
			storageKey = "enabled",
			onChange = { EnableTargetSpeedUpdates = function() if not targetSpeedEnabled then EnableTargetSpeedUpdates() end end, }
		}
	})
end
local function CreateTargetSpeedValueOptions(panel)
	--Selector: Units
	frames.options.targetSpeed.value.units = wt.CreateMultipleSelector({
		parent = panel,
		name = "Units",
		title = ns.strings.options.speedValue.units.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.units.tooltip, }, } },
		arrange = {},
		items = valueTypes,
		limits = { min = 1, },
		dependencies = { { frame = frames.options.targetSpeed.enabled, }, },
		optionsData = {
			optionsKey = addonNameSpace .. "TargetSpeed",
			workingTable = db.targetSpeed.value,
			storageKey = "units",
			onChange = { UpdateTargetSpeedTextTemplate = function() UpdateSpeedText("target", db.targetSpeed.value.units) end, }
		}
	})

	--Slider: Fractionals
	---@type slider
	frames.options.targetSpeed.value.fractionals = wt.CreateSlider({
		parent = panel,
		name = "Fractionals",
		title = ns.strings.options.speedValue.fractionals.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.fractionals.tooltip, }, } },
		arrange = { newRow = false, },
		value = { min = 0, max = 4, increment = 1 },
		dependencies = { { frame = frames.options.targetSpeed.enabled, }, },
		optionsData = {
			optionsKey = addonNameSpace .. "TargetSpeed",
			workingTable = db.targetSpeed.value,
			storageKey = "fractionals",
		}
	})

	--Checkbox: No trim
	---@type checkbox
	frames.options.targetSpeed.value.noTrim = wt.CreateCheckbox({
		parent = panel,
		name = "NoTrim",
		title = ns.strings.options.speedValue.noTrim.label,
		tooltip = { lines = { { text = ns.strings.options.speedValue.noTrim.tooltip, }, } },
		arrange = { newRow = false, },
		autoOffset = true,
		dependencies = { { frame = frames.options.targetSpeed.enabled, }, },
		optionsData = {
			optionsKey = addonNameSpace .. "TargetSpeed",
			workingTable = db.targetSpeed.value,
			storageKey = "noTrim",
		}
	})
end

--Create the category page
local function CreateTargetSpeedOptions()
	---@type optionsPage
	frames.options.targetSpeed.page = wt.CreateOptionsCategory({
		parent = frames.options.main.page.category,
		addon = addonNameSpace,
		name = "TargetSpeed",
		title = ns.strings.options.targetSpeed.title,
		description = ns.strings.options.targetSpeed.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		optionsKeys = { addonNameSpace .. "TargetSpeed" },
		storage = { {
			workingTable =  db.targetSpeed,
			storageTable = MovementSpeedDB.targetSpeed,
			defaultsTable = dbDefault.targetSpeed,
		}, },
		onDefault = function(user)
			if not user then return end

			--Notification
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.defaults.response:gsub(
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

--[ Advanced ]

--Create the widgets
local function CreateOptionsProfiles(panel)
	--TODO: Add profiles handler widgets
end
local function CreateBackupOptions(panel)
	--EditScrollBox & Popup: Import & Export
	local importPopup = wt.CreatePopup({
		addon = addonNameSpace,
		name = "IMPORT",
		text = ns.strings.options.advanced.backup.warning,
		accept = ns.strings.options.advanced.backup.import,
		onAccept = function()
			--Load from string to a temporary table
			local success, t = pcall(loadstring("return " .. wt.Clear(frames.options.advanced.backup.string.getText())))
			if success and type(t) == "table" then
				--Run DB checkup on the loaded table
				CheckDBs(t.account, db, t.character, dbc)

				--Copy values from the loaded DBs to the addon DBs
				wt.CopyValues(t.account, db)
				wt.CopyValues(t.character, dbc)

				--Load the custom preset
				presets[1].data = wt.Clone(db.customPreset)

				--Load the options data & update the interface options
				frames.options.speedDisplays.page.load(true)
				frames.options.targetSpeed.page.load(true)
				frames.options.advanced.page.load(true)
			else print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.options.advanced.backup.error, ns.colors.yellow[2])) end
		end
	})
	frames.options.advanced.backup.string = wt.CreateEditScrollBox({
		parent = panel,
		name = "ImportExport",
		title = ns.strings.options.advanced.backup.backupBox.label,
		tooltip = { lines = {
			{ text = ns.strings.options.advanced.backup.backupBox.tooltip[1], },
			{ text = "\n" .. ns.strings.options.advanced.backup.backupBox.tooltip[2], },
			{ text = "\n" .. ns.strings.options.advanced.backup.backupBox.tooltip[3], },
			{ text = ns.strings.options.advanced.backup.backupBox.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 }, },
			{ text = "\n" .. ns.strings.options.advanced.backup.backupBox.tooltip[5], color = { r = 0.92, g = 0.34, b = 0.23 }, },
		}, },
		arrange = {},
		size = { width = panel:GetWidth() - 24, height = panel:GetHeight() - 76 },
		font = { normal = "GameFontWhiteSmall", },
		maxLetters = 4500,
		scrollSpeed = 60,
		events = {
			OnEnterPressed = function() StaticPopup_Show(importPopup) end,
			OnEscapePressed = function(self) self.setText(wt.TableToString({ account = db, character = dbc }, frames.options.advanced.backup.compact.getState(), true)) end,
		},
		optionsData = {
			optionsKey = addonNameSpace .. "Advanced",
			onLoad = function(self) self.setText(wt.TableToString({ account = db, character = dbc }, frames.options.advanced.backup.compact.getState(), true)) end,
		}
	})

	--Checkbox: Compact
	---@type checkbox
	frames.options.advanced.backup.compact = wt.CreateCheckbox({
		parent = panel,
		name = "Compact",
		title = ns.strings.options.advanced.backup.compact.label,
		tooltip = { lines = { { text = ns.strings.options.advanced.backup.compact.tooltip, }, } },
		position = {
			anchor = "BOTTOMLEFT",
			offset = { x = 12, y = 12 }
		},
		events = { OnClick = function(_, state)
			frames.options.advanced.backup.string.setText(wt.TableToString({ account = db, character = dbc }, state, true))

			--Set focus after text change to set the scroll to the top and refresh the position character counter
			frames.options.advanced.backup.string.scrollFrame.EditBox:SetFocus()
			frames.options.advanced.backup.string.scrollFrame.EditBox:ClearFocus()
		end, },
		optionsData = {
			optionsKey = addonNameSpace .. "Advanced",
			workingTable = cs,
			storageKey = "compactBackup",
		}
	})

	--Button: Load
	wt.CreateButton({
		parent = panel,
		name = "Load",
		title = ns.strings.options.advanced.backup.load.label,
		tooltip = { lines = { { text = ns.strings.options.advanced.backup.load.tooltip, }, } },
		arrange = {},
		size = { height = 26 },
		events = { OnClick = function() StaticPopup_Show(importPopup) end, },
	})

	--Button: Reset
	wt.CreateButton({
		parent = panel,
		name = "Reset",
		title = ns.strings.options.advanced.backup.reset.label,
		tooltip = { lines = { { text = ns.strings.options.advanced.backup.reset.tooltip, }, } },
		position = {
			anchor = "BOTTOMRIGHT",
			offset = { x = -100, y = 12 }
		},
		size = { height = 26 },
		events = { OnClick = function()
			frames.options.advanced.backup.string.setText(wt.TableToString({ account = db, character = dbc }, frames.options.advanced.backup.compact.getState(), true))

			--Set focus after text change to set the scroll to the top and refresh the position character counter
			frames.options.advanced.backup.string.scrollFrame.EditBox:SetFocus()
			frames.options.advanced.backup.string.scrollFrame.EditBox:ClearFocus()
		end, },
	})
end

--Create the category page
local function CreateAdvancedOptions()
	---@type optionsPage
	frames.options.advanced.page = wt.CreateOptionsCategory({
		parent = frames.options.main.page.category,
		addon = addonNameSpace,
		name = "Advanced",
		title = ns.strings.options.advanced.title,
		description = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		optionsKeys = { addonNameSpace .. "Advanced" },
		onDefault = function()
			ResetCustomPreset()

			--Notification
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.reset.response:gsub(
				"#CUSTOM", wt.Color(presets[1].name, ns.colors.green[2])
			), ns.colors.yellow[2]))
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.defaults.response:gsub(
				"#CATEGORY", wt.Color(ns.strings.options.speedDisplay.title, ns.colors.green[2])
			), ns.colors.yellow[2]))
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.defaults.response:gsub(
				"#CATEGORY", wt.Color(ns.strings.options.targetSpeed.title, ns.colors.green[2])
			), ns.colors.yellow[2]))
		end,
		initialize = function(canvas)
			--Panel: Profiles
			wt.CreatePanel({
				parent = canvas,
				name = "Profiles",
				title = ns.strings.options.advanced.profiles.title,
				description = ns.strings.options.advanced.profiles.description:gsub("#ADDON", addonTitle),
				arrange = {},
				size = { height = 64 },
				initialize = CreateOptionsProfiles,
			})

			--Panel: Backup
			wt.CreatePanel({
				parent = canvas,
				name = "Backup",
				title = ns.strings.options.advanced.backup.title,
				description = ns.strings.options.advanced.backup.description:gsub("#ADDON", addonTitle),
				arrange = {},
				size = { height = canvas:GetHeight() - 200 },
				initialize = CreateBackupOptions,
				arrangement = {
					flip = true,
					resize = false
				}
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
	if load == true and not db.speedDisplay.visibility.statusNotice then return end

	print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(frames.main:IsVisible() and (
		not frames.playerSpeed.display:IsVisible() and ns.strings.chat.status.notVisible or ns.strings.chat.status.visible
	) or ns.strings.chat.status.hidden, ns.colors.yellow[1]):gsub(
		"#AUTO", wt.Color(ns.strings.chat.status.auto:gsub(
			"#STATE", wt.Color(db.speedDisplay.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.green[2])
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
local resetDefaultsPopup = wt.CreatePopup({
	addon = addonNameSpace,
	name = "DefaultOptions",
	text = (wt.GetStrings("warning") or ""):gsub("#TITLE", wt.Clear(addonTitle)),
	onAccept = function()
		--Reset the options data & update the interface options
		frames.options.speedDisplays.page.default()
		frames.options.targetSpeed.page.default()
		frames.options.advanced.page.default(true)
	end,
})

--[ Commands ]

--Register handlers
local commandManager = wt.RegisterChatCommands(addonNameSpace, { ns.chat.keyword }, {
	{
		command = ns.chat.commands.help,
		handler = function() print(wt.Color(addonTitle .. " ", ns.colors.green[1]) .. wt.Color(ns.strings.chat.help.list .. ":", ns.colors.yellow[1])) end,
		help = true,
	},
	{
		command = ns.chat.commands.options,
		handler = function() frames.options.main.page.open() end,
		onHelp = function() PrintCommand(ns.chat.commands.options, ns.strings.chat.options.description:gsub("#ADDON", addonTitle)) end
	},
	{
		command = ns.chat.commands.preset,
		handler = function(parameter)
			local i = tonumber(parameter)
			if not i or i < 1 or i > #presets then return false end

			ApplyPreset(i)

			--Update in the SavedVariables DB
			MovementSpeedDBC.hidden = false
			MovementSpeedDB.speedDisplay.position = wt.Clone(db.speedDisplay.position)
			MovementSpeedDB.speedDisplay.layer.strata = db.speedDisplay.layer.strata

			--Update the options widget
			frames.options.speedDisplays.position.presets.setSelected(i)

			return true, i
		end,
		onSuccess = function(i) print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.preset.response:gsub(
			"#PRESET", wt.Color(presets[i].name, ns.colors.green[2])
		), ns.colors.yellow[2])) end,
		onError = function()
			--Error
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.preset.unchanged, ns.colors.yellow[1]))
			print(wt.Color(ns.strings.chat.preset.error:gsub("#INDEX", wt.Color(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])), ns.colors.yellow[2]))
			print(wt.Color(ns.strings.chat.preset.list, ns.colors.green[2]))
			for j = 1, #presets, 2 do
				local list = "    " .. wt.Color(j, ns.colors.green[2]) .. wt.Color(" - " .. presets[j].name, ns.colors.yellow[2])
				if j + 1 <= #presets then list = list .. "    " .. wt.Color(j + 1, ns.colors.green[2]) .. wt.Color(" - " .. presets[j + 1].name, ns.colors.yellow[2]) end
				print(list)
			end
		end,
		onHelp = function() PrintCommand(ns.chat.commands.preset, ns.strings.chat.preset.description:gsub(
			"#INDEX", wt.Color(ns.chat.commands.preset .. " " .. 1, ns.colors.green[2])
		)) end
	},
	{
		command = ns.chat.commands.save,
		handler = function()
			UpdateCustomPreset()

			return true
		end,
		onSuccess = function() print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.save.response:gsub(
			"#CUSTOM", wt.Color(presets[1].name, ns.colors.green[2])
		), ns.colors.yellow[2])) end,
		onHelp = function() PrintCommand(ns.chat.commands.save, ns.strings.chat.save.description:gsub("#CUSTOM", wt.Color(presets[1].name, ns.colors.green[2]))) end
	},
	{
		command = ns.chat.commands.reset,
		handler = function()
			ResetCustomPreset()

			return true
		end,
		onSuccess = function() print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.reset.response:gsub(
			"#CUSTOM", wt.Color(presets[1].name, ns.colors.green[2])
		), ns.colors.yellow[2])) end,
		onHelp = function() PrintCommand(ns.chat.commands.reset, ns.strings.chat.reset.description:gsub("#CUSTOM", wt.Color(presets[1].name, ns.colors.green[2]))) end
	},
	{
		command = ns.chat.commands.toggle,
		handler = function()
			--Update the DBs
			dbc.hidden = not dbc.hidden
			MovementSpeedDBC.hidden = dbc.hidden

			--Update the GUI option in case it was open
			frames.options.speedDisplays.visibility.hidden.setState(dbc.hidden)
			frames.options.speedDisplays.visibility.hidden:SetAttribute("loaded", true) --Update dependent widgets

			--Update the visibility
			wt.SetVisibility(frames.main, not dbc.hidden)

			return true
		end,
		onSuccess = function() print(
			wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(dbc.hidden and ns.strings.chat.toggle.hiding or ns.strings.chat.toggle.unhiding, ns.colors.yellow[2])
		) end,
		onHelp = function() PrintCommand(ns.chat.commands.toggle, ns.strings.chat.toggle.description:gsub(
			"#HIDDEN", wt.Color(dbc.hidden and ns.strings.chat.toggle.hidden or ns.strings.chat.toggle.notHidden, ns.colors.green[2])
		)) end
	},
	{
		command = ns.chat.commands.auto,
		handler = function()
			--Update the DBs
			db.speedDisplay.visibility.autoHide = not db.speedDisplay.visibility.autoHide
			MovementSpeedDB.speedDisplay.visibility.autoHide = db.speedDisplay.visibility.autoHide

			--Update the GUI option in case it was open
			frames.options.speedDisplays.visibility.autoHide.setState(db.speedDisplay.visibility.autoHide)
			frames.options.speedDisplays.visibility.autoHide:SetAttribute("loaded", true) --Update dependent widgets

			return true
		end,
		onSuccess = function() print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.auto.response:gsub(
			"#STATE", wt.Color(db.speedDisplay.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.green[2])
		), ns.colors.yellow[2])) end,
		onHelp = function() PrintCommand(ns.chat.commands.auto, ns.strings.chat.auto.description:gsub(
			"#STATE", wt.Color(db.speedDisplay.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.green[2])
		)) end
	},
	{
		command = ns.chat.commands.size,
		handler = function(parameter)
			local size = tonumber(parameter)
			if not size then return false end

			--Update the DBs
			db.speedDisplay.font.size = size
			MovementSpeedDB.speedDisplay.font.size = db.speedDisplay.font.size

			--Update the GUI option in case it was open
			frames.options.speedDisplays.font.size.setValue(size)

			--Update the Player Speed font
			frames.playerSpeed.text:SetFont(db.speedDisplay.font.family, db.speedDisplay.font.size, "THINOUTLINE")
			SetDisplaySize("playerSpeed")

			return true, size
		end,
		onSuccess = function(size) print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.size.response:gsub(
			"#VALUE", wt.Color(size, ns.colors.green[2])
		), ns.colors.yellow[2])) end,
		onError = function()
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.size.unchanged, ns.colors.yellow[1]))
			print(wt.Color(ns.strings.chat.size.error:gsub(
				"#SIZE", wt.Color(ns.chat.commands.size .. " " .. dbDefault.speedDisplay.font.size, ns.colors.green[2])
			), ns.colors.yellow[2]))
		end,
		onHelp = function() PrintCommand(ns.chat.commands.size, ns.strings.chat.size.description:gsub(
			"#SIZE", wt.Color(ns.chat.commands.size .. " " .. dbDefault.speedDisplay.font.size, ns.colors.green[2])
		)) end
	},
	{
		command = ns.chat.commands.defaults,
		handler = function() StaticPopup_Show(resetDefaultsPopup) end,
		onHelp = function() PrintCommand(ns.chat.commands.defaults, ns.strings.chat.defaults.description) end
	},
}, PrintInfo)


--[[ INITIALIZATION ]]

--[ Event Handlers ]

--Main frame
local function AddonLoaded(self, addon)
	if addon ~= addonNameSpace then return end
	self:UnregisterEvent("ADDON_LOADED")

	--[ DBs ]

	local firstLoad = not MovementSpeedDB

	--Load storage DBs
	MovementSpeedDB = MovementSpeedDB or wt.Clone(dbDefault)
	MovementSpeedDBC = MovementSpeedDBC or wt.Clone(dbcDefault)

	--DB checkup & fix
	CheckDBs(MovementSpeedDB, dbDefault, MovementSpeedDBC, dbcDefault)

	--Load working DBs
	db = wt.Clone(MovementSpeedDB)
	dbc = wt.Clone(MovementSpeedDBC)

	--Load cross-session DBs
	MovementSpeedCS = MovementSpeedCS or {}
	cs = MovementSpeedCS

	--Load the custom preset
	presets[1].data = wt.Clone(db.customPreset)

	--Welcome message
	if firstLoad then PrintInfo() end

	--[ Settings Setup ]

	--Load cross-session data
	if cs.compactBackup == nil then cs.compactBackup = true end

	--Set up the interface options
	CreateMainOptions()
	CreateSpeedDisplayOptions()
	CreateTargetSpeedOptions()
	CreateAdvancedOptions()

	--[ Frame Setup ]

	--Position
	wt.SetPosition(self, db.speedDisplay.position)

	--Make movable
	wt.SetMovability(frames.main, true, "SHIFT", { frames.playerSpeed.display, }, {
		onStop = function()
			--Save the position (for account-wide use)
			wt.CopyValues(wt.PackPosition(frames.main:GetPoint()), db.speedDisplay.position)

			--Update in the SavedVariables DB
			MovementSpeedDB.speedDisplay.position = wt.Clone(db.speedDisplay.position)

			--Update the GUI options in case the window was open
			frames.options.speedDisplays.position.presets.setSelected(nil, ns.strings.options.speedDisplay.position.presets.select)
			frames.options.speedDisplays.position.anchor.setSelected(db.speedDisplay.position.anchor)
			frames.options.speedDisplays.position.xOffset.setValue(db.speedDisplay.position.offset.x)
			frames.options.speedDisplays.position.yOffset.setValue(db.speedDisplay.position.offset.y)

			--Chat response
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.position.save, ns.colors.yellow[2]))
		end,
		onCancel = function()
			--Reset the position
			wt.SetPosition(frames.main, db.speedDisplay.position)

			--Chat response
			print(wt.Color(addonTitle .. ":", ns.colors.green[1]) .. " " .. wt.Color(ns.strings.chat.position.cancel, ns.colors.yellow[1]))
			print(wt.Color(ns.strings.chat.position.error, ns.colors.yellow[2]))
		end
	})

	--[ Display Setup ]

	--Player Speed
	SetDisplayValues("playerSpeed", db, dbc)
end
local function PlayerEnteringWorld(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	--Visibility notice
	if not self:IsVisible() or not frames.playerSpeed.display:IsVisible() then PrintStatus(true) end

	--Start speed updates
	UpdateSpeedText("display", db.speedDisplay.value.units)
	UpdateSpeedText("target", db.targetSpeed.value.units)
	StartPlayerSpeedUpdates()
	if db.targetSpeed.enabled then EnableTargetSpeedUpdates() end
end

--[ Frames ]

--Set up the speed display context menu
local function _CreateContextMenu(parent)
	---@type contextMenu
	local contextMenu = wt.CreateContextMenu({ parent = parent, })

	--[ Items ]

	wt.AddContextLabel(contextMenu, { text = addonTitle, })

	--Options submenu
	local optionsMenu = wt.AddContextSubmenu(contextMenu, { title = ns.strings.misc.options, })

	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.main.name,
		tooltip = { lines = { { text = ns.strings.options.main.description:gsub("#ADDON", addonTitle), }, } },
		events = { OnClick = function() frames.options.main.page.open() end, },
	})
	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.speedDisplay.title,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.description:gsub("#ADDON", addonTitle), }, } },
		events = { OnClick = function() frames.options.speedDisplays.page.open() end, },
	})
	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.targetSpeed.title,
		tooltip = { lines = { { text = ns.strings.options.targetSpeed.description:gsub("#ADDON", addonTitle), }, } },
		events = { OnClick = function() frames.options.targetSpeed.page.open() end, },
	})
	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.advanced.title,
		tooltip = { lines = { { text = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle), }, } },
		events = { OnClick = function() frames.options.advanced.page.open() end, },
	})

	--Presets submenu
	local presetsMenu = wt.AddContextSubmenu(contextMenu, {
		title = ns.strings.options.speedDisplay.position.presets.label,
		tooltip = { lines = { { text = ns.strings.options.speedDisplay.position.presets.tooltip, }, } },
	})
	for i = 1, #presets do wt.AddContextButton(presetsMenu, contextMenu, {
		title = presets[i].name,
		events = { OnClick = function() commandManager.handleCommand(ns.chat.commands.preset, i) end, },
	}) end
end --TODO: Reinstate after fix or delete
local function CreateContextMenu(parent)
	local menu = {
		{
			text = addonTitle,
			isTitle = true,
			notCheckable = true,
		},
		{
			text = ns.strings.misc.options,
			hasArrow = true,
			menuList = {
				{
					text = ns.strings.options.main.name,
					func = function() frames.options.main.page.open() end,
					notCheckable = true,
				},
				{
					text = ns.strings.options.speedDisplay.title,
					func = function() frames.options.speedDisplays.page.open() end,
					notCheckable = true,
				},
				{
					text = ns.strings.options.targetSpeed.title,
					func = function() frames.options.targetSpeed.page.open() end,
					notCheckable = true,
				},
				{
					text = ns.strings.options.advanced.title,
					func = function() frames.options.advanced.page.open() end,
					notCheckable = true,
				},
			},
			notCheckable = true,
		},
		{
			text = ns.strings.options.speedDisplay.position.presets.label,
			hasArrow = true,
			menuList = {},
			notCheckable = true,
		},
	}

	--Insert presets
	for i = 1, #presets do table.insert(menu[3].menuList, {
		text = presets[i].name,
		func = function() commandManager.handleCommand(ns.chat.commands.preset, i) end,
		notCheckable = true,
	}) end

	wt.CreateClassicContextMenu({
		parent = parent,
		menu = menu
	})
end

--Create main addon frame & display
frames.main = wt.CreateFrame({
	parent = UIParent,
	name = addonNameSpace,
	keepInBounds = true,
	size = { width = 33, height = 10 },
	keepOnTop = true,
	onEvent = {
		ADDON_LOADED = AddonLoaded,
		PLAYER_ENTERING_WORLD = PlayerEnteringWorld,
	},
	initialize = function(frame)
		--Player Speed
		frames.playerSpeed.display = wt.CreateFrame({
			parent = frame,
			name = "PlayerSpeed",
			customizable = true,
			position = { anchor = "CENTER" },
			keepInBounds = true,
			events = { OnUpdate = function(self)
				--Update the tooltip
				if self:IsMouseOver() and ns.tooltip:IsVisible() then wt.UpdateTooltip(self, { lines = GetSpeedDisplayTooltipLines("player"), }) end
			end, },
			initialize = function(display)
				--Tooltip
				wt.AddTooltip(display, {
					tooltip = ns.tooltip,
					title = ns.strings.speedTooltip.title:gsub("#SPEED", ns.strings.options.speedDisplay.playerSpeed.title),
					anchor = "ANCHOR_BOTTOMRIGHT",
					offset = { y = display:GetHeight() },
					flipColors = true
				})

				--Context menu
				CreateContextMenu(display)

				--Text
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

		--Target Speed
		frames.targetSpeed = wt.CreateFrame({
			parent = frame,
			name = "TargetSpeedUpdater",
		})
	end
})
