--[[ ADDON INFO ]]

--Addon namespace string & table
local addonNameSpace, ns = ...

--Addon display name
local _, addonTitle = GetAddOnInfo(addonNameSpace)


--[[ RESOURCES ]]

---@class WidgetToolbox
local wt = ns.WidgetToolbox

--Clean up the addon title
addonTitle = wt.Clear(addonTitle):gsub("^%s*(.-)%s*$", "%1")


--[[ DATA TABLES ]]

--[ Addon DBs ]

--References
local db --Account-wide options
local dbc --Character-specific options
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
		text = {
			valueType = 0,
			decimals = 0,
			noTrim = false,
			font = {
				family = ns.fonts[0].path,
				size = 11,
				color = { r = 1, g = 1, b = 1, a = 1 },
			},
		},
		background = {
			visible = false,
			colors = {
				bg = { r = 0, g = 0, b = 0, a = 0.5 },
				border = { r = 1, g = 1, b = 1, a = 0.4 },
			},
		},
	},
	targetSpeed = {
		tooltip = {
			enabled = true,
			text = {
				valueType = 2,
				decimals = 0,
				noTrim = false,
			},
		},
	},
}
local dbcDefault = {
	hidden = false,
}

--[ Preset Data ]

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


--[[ FRAMES & EVENTS ]]

--[ Speed Display ]

--Create frames
local moveSpeed = CreateFrame("Frame", addonNameSpace, UIParent)
local speedDisplay = CreateFrame("Frame", moveSpeed:GetName() .. "Display", moveSpeed, BackdropTemplateMixin and "BackdropTemplate")
local speedDisplayText = speedDisplay:CreateFontString(speedDisplay:GetName() .. "Text", "OVERLAY")

--Register events
moveSpeed:RegisterEvent("ADDON_LOADED")
moveSpeed:RegisterEvent("PLAYER_ENTERING_WORLD")
moveSpeed:RegisterEvent("PET_BATTLE_OPENING_START")
moveSpeed:RegisterEvent("PET_BATTLE_CLOSE")

--Event handler
moveSpeed:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)

--[ Target Speed ]

--Create frame
local targetSpeed = CreateFrame("Frame", addonNameSpace .. "TargetSpeed", UIParent)

--Event handler
targetSpeed:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)

--[ Custom Tooltip ]

ns.tooltip = wt.CreateGameTooltip(addonNameSpace)


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
		elseif k == "fontSize" or k == "font.size" then data.speedDisplay.text.font.size = v
		elseif k == "font.family" then data.speedDisplay.text.font.family = v
		elseif k == "font.color.r" then data.speedDisplay.text.font.color.r = v
		elseif k == "font.color.g" then data.speedDisplay.text.font.color.g = v
		elseif k == "font.color.b" then data.speedDisplay.text.font.color.b = v
		elseif k == "font.color.a" then data.speedDisplay.text.font.color.a = v
		elseif k == "visibility.hidden" or k == "appearance.hidden" then characterData.hidden = v
		elseif k == "targetSpeed.enabled" then data.targetSpeed.tooltip.enabled = v
		elseif k == "targetSpeed.text.valueType" then data.targetSpeed.tooltip.text.valueType = v
		elseif k == "targetSpeed.text.decimals" then data.targetSpeed.tooltip.text.decimals = v
		elseif k == "targetSpeed.text.noTrim" then data.targetSpeed.tooltip.text.noTrim = v end
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
	local firstLoad = false
	--First load
	if MovementSpeedDB == nil then
		MovementSpeedDB = wt.Clone(dbDefault)
		firstLoad = true
	end
	if MovementSpeedDBC == nil then MovementSpeedDBC = wt.Clone(dbcDefault) end
	if MovementSpeedCS == nil then MovementSpeedCS = {} end
	--Load the DBs
	db = wt.Clone(MovementSpeedDB) --Account-wide options DB copy
	dbc = wt.Clone(MovementSpeedDBC) --Character-specific options DB copy
	cs = MovementSpeedCS --Cross-session account-wide data direct reference
	--DB checkup & fix
	wt.RemoveEmpty(db, CheckValidity)
	wt.RemoveEmpty(dbc, CheckValidity)
	wt.AddMissing(db, dbDefault)
	wt.AddMissing(dbc, dbcDefault)
	RestoreOldData(db, dbc, wt.RemoveMismatch(db, dbDefault), wt.RemoveMismatch(dbc, dbcDefault))
	--Apply any potential fixes to the SavedVariables DBs
	MovementSpeedDB = wt.Clone(db)
	MovementSpeedDBC = wt.Clone(dbc)
	return firstLoad
end

--[ Speed Update ]

---Get the current player speed in yards / second
---@return number
local function GetPlayerSpeed()
	return GetUnitSpeed(UnitInVehicle("player") and "vehicle" or "player")
end

---Assemble the detailed text lines for player speed tooltip
---@return table textLines Table containing text lines to be added to the tooltip [indexed, 0-based]
--- - **text** string ― Text to be added to the line
--- - **font**? string | FontObject *optional* ― The FontObject to set for this line [Default: GameTooltipTextSmall]
--- - **color**? table *optional* ― Table containing the RGB values to color this line with [Default: HIGHLIGHT_FONT_COLOR (white)]
--- 	- **r** number ― Red [Range: 0 - 1]
--- 	- **g** number ― Green [Range: 0 - 1]
--- 	- **b** number ― Blue [Range: 0 - 1]
--- - **wrap**? boolean *optional* ― Allow this line to be wrapped [Default: true]
local function GetSpeedTooltipLines()
	local speed = GetPlayerSpeed()
	return {
		[0] = {
			text = ns.strings.speedTooltip.text[0],
		},
		[1] = {
			text = "\n" .. ns.strings.speedTooltip.text[1]:gsub(
				"#YARDS", wt.Color(wt.FormatThousands(speed, 4, true),  ns.colors.yellow[0])
			),
			color = ns.colors.yellow[1],
		},
		[2] = {
			text = "\n" .. ns.strings.speedTooltip.text[2]:gsub(
				"#PERCENT", wt.Color(wt.FormatThousands(speed / 7 * 100, 4, true) .. "%%", ns.colors.green[0])
			),
			color = ns.colors.green[1],
		},
		[3] = {
			text = "\n" .. ns.strings.speedTooltip.hintOptions,
			font = GameFontNormalTiny,
			color = ns.colors.grey[0],
		},
		[4] = {
			text = ns.strings.speedTooltip.hintMove:gsub("#SHIFT", ns.strings.keys.shift),
			font = GameFontNormalTiny,
			color = ns.colors.grey[0],
		},
	}
end

---Assemble the text for the mouseover target's speed
---@return string
local function GetTargetSpeedText()
	local speed = GetUnitSpeed("mouseover")
	local text
	if db.targetSpeed.tooltip.text.valueType == 0 then
		text = wt.Color(wt.FormatThousands(speed / 7 * 100, db.targetSpeed.tooltip.text.decimals, true, not db.targetSpeed.tooltip.text.noTrim) .. "%%", ns.colors.green[0])
	elseif db.targetSpeed.tooltip.text.valueType == 1 then
		text = wt.Color(ns.strings.yardsps:gsub(
			"#YARDS", wt.Color(wt.FormatThousands(speed, db.targetSpeed.tooltip.text.decimals, true, not db.targetSpeed.tooltip.text.noTrim), ns.colors.green[0])
		), ns.colors.green[1])
	elseif db.targetSpeed.tooltip.text.valueType == 2 then
		text = wt.Color(wt.FormatThousands(speed / 7 * 100, db.targetSpeed.tooltip.text.decimals, true, not db.targetSpeed.tooltip.text.noTrim) .. "%%", ns.colors.green[0]) .. " ("
		text = text .. wt.Color(ns.strings.yardsps:gsub(
			"#YARDS", wt.Color(wt.FormatThousands(speed, db.targetSpeed.tooltip.text.decimals, true, not db.targetSpeed.tooltip.text.noTrim), ns.colors.yellow[0])
		) .. ")", ns.colors.yellow[1])
	end
	return "|T" .. ns.textures.logo .. ":0|t" .. " " .. ns.strings.targetSpeed:gsub("#SPEED", text)
end

--[ Speed Display ]

---Set the size of the speed display
---@param height? number Text height [Default: speedDisplayText:GetStringHeight()]
---@param valueType? number Height:Width ratio [Default: db.speedDisplay.text.valueType]
---@param decimals? number Height:Width ratio [Default: db.speedDisplay.text.decimals]
local function SetDisplaySize(height, valueType, decimals)
	height = math.ceil(height or speedDisplayText:GetStringHeight()) + 2
	local ratio = 3.08 + ((decimals or db.speedDisplay.text.decimals) > 0 and 0.25 + (decimals or db.speedDisplay.text.decimals) * 0.58 or 0)
	if (valueType or db.speedDisplay.text.valueType) == 1 then ratio = ratio + 0.46
	elseif (valueType or db.speedDisplay.text.valueType) == 2 then
		ratio = ratio + 3.37 + ((decimals or db.speedDisplay.text.decimals) > 0 and 0.25 + (decimals or db.speedDisplay.text.decimals) * 0.58 or 0)
	end
	local width = height * ratio - 4
	speedDisplay:SetSize(width, height)
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
	wt.SetBackdrop(speedDisplay, enabled and {
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
local function SetDisplayValues(data, characterData)
	--Visibility
	moveSpeed:SetFrameStrata(data.speedDisplay.visibility.frameStrata)
	wt.SetVisibility(moveSpeed, not characterData.hidden)
	--Display
	SetDisplaySize(data.speedDisplay.text.font.size, data.speedDisplay.text.valueType, data.speedDisplay.text.decimals)
	SetDisplayBackdrop(data.speedDisplay.background.visible, data.speedDisplay.background.colors.bg, data.speedDisplay.background.colors.border)
	--Font & text
	speedDisplayText:SetFont(data.speedDisplay.text.font.family, data.speedDisplay.text.font.size, "THINOUTLINE")
	speedDisplayText:SetTextColor(wt.UnpackColor(data.speedDisplay.text.font.color))
end


--[[ INTERFACE OPTIONS ]]

--Options frame references
local options = {
	about = {},
	position = {},
	text = {
		font = {},
	},
	visibility = {},
	background = {
		colors = {},
		size = {},
	},
	mouseover = {},
	backup = {},
}

--[ Options Widgets ]

--Main page
local function CreateOptionsShortcuts(parentFrame)
	--Button: Speed Display page
	local speedDisplayPage = wt.CreateButton({
		parent = parentFrame,
		name = "SpeedDisplayPage",
		title = ns.strings.options.speedDisplay.title,
		tooltip = { lines = {
			[0] = { text = ns.strings.options.speedDisplay.description:gsub("#ADDON", addonTitle), },
			[1] = { text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, },
		} },
		position = { offset = { x = 10, y = -30 } },
		size = { width = 120, },
		events = { OnClick = function() options.speedDisplayOptions.open() end, },
		disabled = true,
	})
	--Button: Target Speed page
	wt.CreateButton({
		parent = parentFrame,
		name = "TargetSpeedPage",
		title = ns.strings.options.targetSpeed.title,
		tooltip = { lines = {
			[0] = { text = ns.strings.options.targetSpeed.description:gsub("#ADDON", addonTitle), },
			[1] = { text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, },
		} },
		position = {
			relativeTo = speedDisplayPage,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		size = { width = 120, },
		events = { OnClick = function() options.targetSpeedOptions.open() end, },
		disabled = true,
	})
	--Button: Advanced page
	wt.CreateButton({
		parent = parentFrame,
		name = "AdvancedPage",
		title = ns.strings.options.advanced.title,
		tooltip = { lines = {
			[0] = { text = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle), },
			[1] = { text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, },
		} },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -30 }
		},
		size = { width = 120 },
		events = { OnClick = function() options.advancedOptions.open() end, },
		disabled = true,
	})
end
local function CreateAboutInfo(parentFrame)
	--Text: Version
	local version = wt.CreateText({
		parent = parentFrame,
		name = "Version",
		position = { offset = { x = 16, y = -33 } },
		width = 84,
		text = ns.strings.options.main.about.version:gsub("#VERSION", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "Version"), "FFFFFFFF")),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})
	--Text: Date
	local date = wt.CreateText({
		parent = parentFrame,
		name = "Date",
		position = {
			relativeTo = version,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		width = 102,
		text = ns.strings.options.main.about.date:gsub(
			"#DATE", WrapTextInColorCode(ns.strings.misc.date:gsub(
				"#DAY", GetAddOnMetadata(addonNameSpace, "X-Day")
			):gsub(
				"#MONTH", GetAddOnMetadata(addonNameSpace, "X-Month")
			):gsub(
				"#YEAR", GetAddOnMetadata(addonNameSpace, "X-Year")
			), "FFFFFFFF")
		),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})
	--Text: Author
	local author = wt.CreateText({
		parent = parentFrame,
		name = "Author",
		position = {
			relativeTo = date,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		width = 186,
		text = ns.strings.options.main.about.author:gsub("#AUTHOR", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "Author"), "FFFFFFFF")),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})
	--Text: License
	wt.CreateText({
		parent = parentFrame,
		name = "License",
		position = {
			relativeTo = author,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		width = 156,
		text = ns.strings.options.main.about.license:gsub("#LICENSE", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "X-License"), "FFFFFFFF")),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})
	--EditScrollBox: Changelog
	options.about.changelog = wt.CreateEditScrollBox({
		parent = parentFrame,
		name = "Changelog",
		title = ns.strings.options.main.about.changelog.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.main.about.changelog.tooltip, }, } },
		position = {
			relativeTo = version,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -12 }
		},
		size = { width = parentFrame:GetWidth() - 32, height = 165 },
		font = "GameFontDisableSmall",
		text = ns.GetChangelog(),
		readOnly = true,
		scrollSpeed = 45,
	})
end
local function CreateSupportInfo(parentFrame)
	--Copybox: CurseForge
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "CurseForge",
		title = ns.strings.options.main.support.curseForge .. ":",
		position = { offset = { x = 16, y = -33 } },
		size = { width = parentFrame:GetWidth() / 2 - 22, },
		text = "curseforge.com/wow/addons/movement-speed",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Wago
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Wago",
		title = ns.strings.options.main.support.wago .. ":",
		position = {
			anchor = "TOP",
			offset = { x = (parentFrame:GetWidth() / 2 - 22) / 2 + 8, y = -33 }
		},
		size = { width = parentFrame:GetWidth() / 2 - 22, },
		text = "addons.wago.io/addons/movement-speed",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Repository
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Repository",
		title = ns.strings.options.main.support.repository .. ":",
		position = { offset = { x = 16, y = -70 } },
		size = { width = parentFrame:GetWidth() / 2 - 22, },
		text = "github.com/Arxareon/MovementSpeed",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Issues
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Issues",
		title = ns.strings.options.main.support.issues .. ":",
		position = {
			anchor = "TOP",
			offset = { x = (parentFrame:GetWidth() / 2 - 22) / 2 + 8, y = -70 }
		},
		size = { width = parentFrame:GetWidth() / 2 - 22, },
		text = "github.com/Arxareon/MovementSpeed/issues",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
end
local function CreateMainCategoryPanels(parentFrame) --Add the main page widgets to the category panel frame
	--Shortcuts
	local shortcutsPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "Shortcuts",
		title = ns.strings.options.main.shortcuts.title,
		description = ns.strings.options.main.shortcuts.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 10, y = -82 } },
		size = { height = 64 },
	})
	CreateOptionsShortcuts(shortcutsPanel)
	--About
	local aboutPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "About",
		title = ns.strings.options.main.about.title,
		description = ns.strings.options.main.about.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = shortcutsPanel,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 257 },
	})
	CreateAboutInfo(aboutPanel)
	--Support
	local supportPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "Support",
		title = ns.strings.options.main.support.title,
		description = ns.strings.options.main.support.description,
		position = {
			relativeTo = aboutPanel,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 111 },
	})
	CreateSupportInfo(supportPanel)
end

--Speed Display page
local function CreateQuickOptions(parentFrame)
	--Checkbox: Hidden
	options.visibility.hidden = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Hidden",
		title = ns.strings.options.speedDisplay.quick.hidden.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedDisplay.quick.hidden.tooltip:gsub("#ADDON", addonTitle), }, } },
		position = { offset = { x = 8, y = -30 } },
		events = { OnClick = function(_, state) wt.SetVisibility(moveSpeed, not state) end, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = dbc,
			storageKey = "hidden",
		}
	})
	--Dropdown: Apply a preset
	local presetItems = {}
	for i = 0, #presets do
		presetItems[i] = {}
		presetItems[i].title = presets[i].name
		presetItems[i].onSelect = function()
			--Update the speed display
			moveSpeed:Show()
			moveSpeed:SetFrameStrata(presets[i].data.visibility.frameStrata)
			wt.SetPosition(moveSpeed, presets[i].data.position)
			--Update the options
			options.position.anchor.setSelected(presets[i].data.position.anchor)
			options.position.xOffset:SetValue(presets[i].data.position.offset.x)
			options.position.yOffset:SetValue(presets[i].data.position.offset.y)
			options.visibility.raise:SetChecked(presets[i].data.visibility.frameStrata == "HIGH")
			--Update the DBs
			db.speedDisplay.position = presets[i].data.position
			db.speedDisplay.visibility.frameStrata = presets[i].data.visibility.frameStrata
		end
	end
	options.visibility.presets = wt.CreateDropdown({
		parent = parentFrame,
		name = "ApplyPreset",
		title = ns.strings.options.speedDisplay.quick.presets.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedDisplay.quick.presets.tooltip, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		width = 180,
		items = presetItems,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
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
			presets[0].data.position = wt.PackPosition(moveSpeed:GetPoint())
			presets[0].data.visibility.frameStrata = options.visibility.raise:GetChecked() and "HIGH" or "MEDIUM"
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
		tooltip = { lines = { [0] = { text = ns.strings.options.speedDisplay.quick.savePreset.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -43 }
		},
		size = { width = 160, },
		events = { OnClick = function() StaticPopup_Show(savePopup) end, },
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
	})
end
local function CreatePositionOptions(parentFrame)
	--Selector: Anchor point
	options.position.anchor = wt.CreateAnchorSelector({
		parent = parentFrame,
		name = "AnchorPoint",
		title = ns.strings.options.speedDisplay.position.anchor.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedDisplay.position.anchor.tooltip, }, } },
		position = { offset = { x = 8, y = -30 } },
		width = 140,
		onSelection = function(point)
			--Update the display position
			wt.SetPosition(moveSpeed, wt.PackPosition(point, nil, nil, options.position.xOffset:GetValue(), options.position.yOffset:GetValue()))
			--Clear the presets dropdown selection
			options.visibility.presets.setSelected(nil, ns.strings.options.speedDisplay.quick.presets.select)
		end,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.position,
			storageKey = "anchor",
		}
	})
	--Slider: X offset
	options.position.xOffset = wt.CreateSlider({
		parent = parentFrame,
		name = "OffsetX",
		title = ns.strings.options.speedDisplay.position.xOffset.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedDisplay.position.xOffset.tooltip, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		value = { min = -500, max = 500, fractional = 2 },
		events = { OnValueChanged = function(_, value, user)
			if not user then return end
			--Update the display position
			wt.SetPosition(moveSpeed, wt.PackPosition(options.position.anchor.getSelected(), nil, nil, value, options.position.yOffset:GetValue()))
			--Clear the presets dropdown selection
			options.visibility.presets.setSelected(nil, ns.strings.options.speedDisplay.quick.presets.select)
		end, },
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.position.offset,
			storageKey = "x",
		}
	}).slider
	--Slider: Y offset
	options.position.yOffset = wt.CreateSlider({
		parent = parentFrame,
		name = "OffsetY",
		title = ns.strings.options.speedDisplay.position.yOffset.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedDisplay.position.yOffset.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -8, y = -30 }
		},
		value = { min = -500, max = 500, fractional = 2 },
		events = { OnValueChanged = function(_, value, user)
			if not user then return end
			--Update the display position
			wt.SetPosition(moveSpeed, wt.PackPosition(options.position.anchor.getSelected(), nil, nil, options.position.xOffset:GetValue(), value))
			--Clear the presets dropdown selection
			options.visibility.presets.setSelected(nil, ns.strings.options.speedDisplay.quick.presets.select)
		end, },
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.position.offset,
			storageKey = "y",
		}
	}).slider
end
local function CreateTextOptions(parentFrame)
	--Selector: Value type
	local valueTypes = {}
	for i = 0, 2 do
		valueTypes[i] = {}
		valueTypes[i].title = ns.strings.options.speedText.valueType.list[i].label
		valueTypes[i].tooltip = { lines = { [0] = { text = ns.strings.options.speedText.valueType.list[i].tooltip, }, } }
		valueTypes[i].onSelect = function()
			db.speedDisplay.text.valueType = i
			SetDisplaySize()
		end
	end
	options.text.valueType = wt.CreateSelector({
		parent = parentFrame,
		name = "ValueType",
		title = ns.strings.options.speedText.valueType.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedText.valueType.tooltip, }, } },
		position = { offset = { x = 8, y = -30 } },
		items = valueTypes,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.text,
			storageKey = "valueType",
		}
	})
	--Slider: Decimals
	options.text.decimals = wt.CreateSlider({
		parent = parentFrame,
		name = "Decimals",
		title = ns.strings.options.speedText.decimals.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedText.decimals.tooltip, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		value = { min = 0, max = 4, step = 1 },
		events = { OnValueChanged = function(_, value, user)
			if not user then return end
			db.speedDisplay.text.decimals = value
			SetDisplaySize()
		end, },
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.text,
			storageKey = "decimals",
		}
	}).slider
	--Checkbox: No trim
	options.text.noTrim = wt.CreateCheckbox({
		parent = parentFrame,
		name = "NoTrim",
		title = ns.strings.options.speedText.noTrim.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedText.noTrim.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { y = -30 }
		},
		autoOffset = true,
		events = { OnClick = function(_, state) db.speedDisplay.text.noTrim = state end, },
		dependencies = {
			[0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end },
			[1] = { frame = options.text.decimals, evaluate = function(value) return value > 0 end },
		},
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.text,
			storageKey = "noTrim",
		}
	})
	--Dropdown: Font family
	local fontItems = {}
	for i = 0, #ns.fonts do
		fontItems[i] = {}
		fontItems[i].title = ns.fonts[i].name
		fontItems[i].onSelect = function()
			speedDisplayText:SetFont(ns.fonts[i].path, options.text.font.size:GetValue(), "THINOUTLINE")
			--Refresh the text so the font will be applied even the first time as well not just subsequent times
			local text = speedDisplayText:GetText()
			speedDisplayText:SetText("")
			speedDisplayText:SetText(text)
		end
	end
	options.text.font.family = wt.CreateDropdown({
		parent = parentFrame,
		name = "FontFamily",
		title = ns.strings.options.speedDisplay.text.font.family.label,
		tooltip = { lines = {
			[0] = { text = ns.strings.options.speedDisplay.text.font.family.tooltip[0], },
			[1] = { text = "\n" .. ns.strings.options.speedDisplay.text.font.family.tooltip[1], },
			[2] = { text = "\n" .. ns.strings.options.speedDisplay.text.font.family.tooltip[2]:gsub("#OPTION_CUSTOM", ns.strings.misc.custom):gsub("#FILE_CUSTOM", "CUSTOM.ttf"), },
			[3] = { text = "[WoW]\\Interface\\AddOns\\" .. addonNameSpace .. "\\Fonts\\", color = { r = 0.185, g = 0.72, b = 0.84 }, wrap = false },
			[4] = { text = ns.strings.options.speedDisplay.text.font.family.tooltip[3]:gsub("#FILE_CUSTOM", "CUSTOM.ttf"), },
			[5] = { text = ns.strings.options.speedDisplay.text.font.family.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 }, },
		} },
		position = { offset = { x = 8, y = -101 } },
		items = fontItems,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.text.font,
			storageKey = "family",
			convertSave = function(value) return ns.fonts[value].path end,
			convertLoad = function(font) return GetFontID(font) end,
		}
	})
	--Slider: Font size
	options.text.font.size = wt.CreateSlider({
		parent = parentFrame,
		name = "FontSize",
		title = ns.strings.options.speedDisplay.text.font.size.label,
		tooltip = { lines = {
			[0] = { text = ns.strings.options.speedDisplay.text.font.size.tooltip .. "\n\n" .. ns.strings.misc.default .. ": " .. dbDefault.speedDisplay.text.font.size, },
		} },
		position = {
			anchor = "TOP",
			offset = { y = -101 }
		},
		value = { min = 8, max = 64, step = 1 },
		events = { OnValueChanged = function(_, value, user)
			if not user then return end
			speedDisplayText:SetFont(speedDisplayText:GetFont(), value, "THINOUTLINE")
			speedDisplayText:SetPoint("CENTER", 0.9, math.fmod(db.speedDisplay.text.font.size, 2) ~= 0 and 0.1 or 0)
			SetDisplaySize()
		end, },
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.text.font,
			storageKey = "size",
		}
	}).slider
	--Color Picker: Font color
	options.text.font.color = wt.CreateColorPicker({
		parent = parentFrame,
		name = "FontColor",
		title = ns.strings.options.speedDisplay.text.font.color.label,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -12, y = -101 }
		},
		opacity = true,
		setColors = function() return speedDisplayText:GetTextColor() end,
		onColorUpdate = function(r, g, b, a) speedDisplayText:SetTextColor(r, g, b, a) end,
		onCancel = function(r, g, b, a) speedDisplayText:SetTextColor(r, g, b, a) end,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.text.font,
			storageKey = "color",
		}
	})
end
local function CreateBackgroundOptions(parentFrame)
	--Checkbox: Visible
	options.background.visible = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Visible",
		title = ns.strings.options.speedDisplay.background.visible.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedDisplay.background.visible.tooltip, }, } },
		position = { offset = { x = 8, y = -30 } },
		events = { OnClick = function(_, state)
			SetDisplayBackdrop(state, wt.PackColor(options.background.colors.bg.getColor()), wt.PackColor(options.background.colors.border.getColor()))
		end, },
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.background,
			storageKey = "visible",
		}
	})
	--Color Picker: Background color
	options.background.colors.bg = wt.CreateColorPicker({
		parent = parentFrame,
		name = "BackgroundColor",
		title = ns.strings.options.speedDisplay.background.colors.bg.label,
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		opacity = true,
		setColors = function()
			if options.background.visible:GetChecked() then return speedDisplay:GetBackdropColor() end
			return wt.UnpackColor(db.speedDisplay.background.colors.bg)
		end,
		onColorUpdate = function(r, g, b, a) if speedDisplay:GetBackdrop() ~= nil then speedDisplay:SetBackdropColor(r, g, b, a) end end,
		onCancel = function(r, g, b, a) if speedDisplay:GetBackdrop() ~= nil then speedDisplay:SetBackdropColor(r, g, b, a) end end,
		dependencies = {
			[0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end },
			[1] = { frame = options.background.visible, },
		},
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.background.colors,
			storageKey = "bg",
		}
	})
	--Color Picker: Border color
	options.background.colors.border = wt.CreateColorPicker({
		parent = parentFrame,
		name = "BorderColor",
		title = ns.strings.options.speedDisplay.background.colors.border.label,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -12, y = -30 }
		},
		opacity = true,
		setColors = function()
			if options.background.visible:GetChecked() then return speedDisplay:GetBackdropBorderColor() end
			return wt.UnpackColor(db.speedDisplay.background.colors.border)
		end,
		onColorUpdate = function(r, g, b, a) if speedDisplay:GetBackdrop() ~= nil then speedDisplay:SetBackdropBorderColor(r, g, b, a) end end,
		onCancel = function(r, g, b, a) if speedDisplay:GetBackdrop() ~= nil then speedDisplay:SetBackdropBorderColor(r, g, b, a) end end,
		dependencies = {
			[0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end },
			[1] = { frame = options.background.visible, },
		},
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.background.colors,
			storageKey = "border",
		}
	})
end
local function CreateVisibilityOptions(parentFrame)
	--Checkbox: Raise
	options.visibility.raise = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Raise",
		title = ns.strings.options.speedDisplay.visibility.raise.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedDisplay.visibility.raise.tooltip, }, } },
		position = { offset = { x = 8, y = -30 } },
		events = { OnClick = function(_, state)
			moveSpeed:SetFrameStrata(state and "HIGH" or "MEDIUM")
			--Clear the presets dropdown selection
			options.visibility.presets.setSelected(nil, ns.strings.options.speedDisplay.quick.presets.select)
		end, },
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.visibility,
			storageKey = "frameStrata",
			convertSave = function(enabled) return enabled and "HIGH" or "MEDIUM" end,
			convertLoad = function(strata) return strata == "HIGH" end,
		}
	})
	--Checkbox: Auto-hide toggle
	options.visibility.autoHide = wt.CreateCheckbox({
		parent = parentFrame,
		name = "AutoHide",
		title = ns.strings.options.speedDisplay.visibility.autoHide.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedDisplay.visibility.autoHide.tooltip, }, } },
		position = {
			relativeTo = options.visibility.raise,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -4 }
		},
		events = { OnClick = function(_, state) db.speedDisplay.visibility.autoHide = state end, },
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.visibility,
			storageKey = "autoHide",
		}
	})
	--Checkbox: Status notice
	options.visibility.status = wt.CreateCheckbox({
		parent = parentFrame,
		name = "StatusNotice",
		title = ns.strings.options.speedDisplay.visibility.statusNotice.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedDisplay.visibility.statusNotice.tooltip:gsub("#ADDON", addonTitle), }, } },
		position = {
			relativeTo = options.visibility.autoHide,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -4 }
		},
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.speedDisplay.visibility,
			storageKey = "statusNotice",
		}
	})
end
local function CreateSpeedDisplayCategoryPanels(parentFrame) --Add the speed display page widgets to the category panel frame
	--Quick settings
	local quickOptions = wt.CreatePanel({
		parent = parentFrame,
		name = "QuickSettings",
		title = ns.strings.options.speedDisplay.quick.title,
		description = ns.strings.options.speedDisplay.quick.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 10, y = -78 } },
		size = { height = 77 },
	})
	CreateQuickOptions(quickOptions)
	--Position
	local positionOptions = wt.CreatePanel({
		parent = parentFrame,
		name = "Position",
		title = ns.strings.options.speedDisplay.position.title,
		description = ns.strings.options.speedDisplay.position.description:gsub("#SHIFT", ns.strings.keys.shift),
		position = {
			relativeTo = quickOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 103 },
	})
	CreatePositionOptions(positionOptions)
	--Text
	local textOptions = wt.CreatePanel({
		parent = parentFrame,
		name = "Text",
		title = ns.strings.options.speedDisplay.text.title,
		description = ns.strings.options.speedDisplay.text.description,
		position = {
			relativeTo = positionOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 159 },
	})
	CreateTextOptions(textOptions)
	--Background
	local backgroundOptions = wt.CreatePanel({
		parent = parentFrame,
		name = "Background",
		title = ns.strings.options.speedDisplay.background.title,
		description = ns.strings.options.speedDisplay.background.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = textOptions,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 80 },
	})
	CreateBackgroundOptions(backgroundOptions)
	--Visibility
	local visibilityOptions = wt.CreatePanel({
		parent = parentFrame,
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
	CreateVisibilityOptions(visibilityOptions)
end

--Target Speed page
local function CreateTooltipOptions(parentFrame)
	--Checkbox: Enabled
	options.mouseover.enabled = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Enabled",
		title = ns.strings.options.targetSpeed.mouseover.enabled.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.targetSpeed.mouseover.enabled.tooltip:gsub("#ADDON", addonTitle), }, } },
		position = { offset = { x = 8, y = -30 } },
		events = { OnClick = function(_, state) db.targetSpeed.tooltip.enabled = state end, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.targetSpeed.tooltip,
			storageKey = "enabled",
		}
	})
	--Selector: Value type
	local valueTypes = {}
	for i = 0, 2 do
		valueTypes[i] = {}
		valueTypes[i].title = ns.strings.options.speedText.valueType.list[i].label
		valueTypes[i].tooltip = { lines = { [0] = { text = ns.strings.options.speedText.valueType.list[i].tooltip, }, } }
		valueTypes[i].onSelect = function() db.targetSpeed.tooltip.text.valueType = i end
	end
	options.mouseover.valueType = wt.CreateSelector({
		parent = parentFrame,
		name = "ValueType",
		title = ns.strings.options.speedText.valueType.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedText.valueType.tooltip, }, } },
		position = { offset = { x = 8, y = -60 } },
		items = valueTypes,
		dependencies = { [0] = { frame = options.mouseover.enabled, }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.targetSpeed.tooltip.text,
			storageKey = "valueType",
		}
	})
	--Slider: Decimals
	options.mouseover.decimals = wt.CreateSlider({
		parent = parentFrame,
		name = "Decimals",
		title = ns.strings.options.speedText.decimals.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedText.decimals.tooltip, }, } },
		position = {
			anchor = "TOP",
			offset = { y = -60 }
		},
		value = { min = 0, max = 4, step = 1 },
		events = { OnValueChanged = function(_, value, user)
			if not user then return end
			db.targetSpeed.tooltip.text.decimals = value end,
		},
		dependencies = { [0] = { frame = options.mouseover.enabled, }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.targetSpeed.tooltip.text,
			storageKey = "decimals",
		}
	}).slider
	--Checkbox: No trim
	options.mouseover.noTrim = wt.CreateCheckbox({
		parent = parentFrame,
		name = "NoTrim",
		title = ns.strings.options.speedText.noTrim.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedText.noTrim.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { y = -60 }
		},
		autoOffset = true,
		events = { OnClick = function(_, state) db.targetSpeed.tooltip.text.noTrim = state end, },
		dependencies = {
			[0] = { frame = options.mouseover.enabled, },
			[1] = { frame = options.mouseover.decimals, evaluate = function(value) return value > 0 end },
		},
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.targetSpeed.tooltip.text,
			storageKey = "noTrim",
		}
	})
end
local function CreateTargetSpeedCategoryPanels(parentFrame) --Add the speed display page widgets to the category panel frame
	--Mouseover
	local mouseoverOptions = wt.CreatePanel({
		parent = parentFrame,
		name = "Mouseover",
		title = ns.strings.options.targetSpeed.mouseover.title,
		description = ns.strings.options.targetSpeed.mouseover.description,
		position = { offset = { x = 10, y = -82 } },
		size = { height = 134 },
	})
	CreateTooltipOptions(mouseoverOptions)
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
			local success, t = pcall(loadstring("return " .. wt.Clear(options.backup.string:GetText())))
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
				--Update the custom preset
				presets[0].data = wt.Clone(db.customPreset)
				--Update the speed display
				wt.SetPosition(moveSpeed, db.speedDisplay.position)
				SetDisplayValues(db, dbc)
				--Update the interface options
				wt.LoadOptionsData(addonNameSpace)
			else print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.options.advanced.backup.error, ns.colors.yellow[1])) end
		end
	})
	local backupBox
	options.backup.string, backupBox = wt.CreateEditScrollBox({
		parent = parentFrame,
		name = "ImportExport",
		title = ns.strings.options.advanced.backup.backupBox.label,
		tooltip = { lines = {
			[0] = { text = ns.strings.options.advanced.backup.backupBox.tooltip[0], },
			[1] = { text = "\n" .. ns.strings.options.advanced.backup.backupBox.tooltip[1], },
			[2] = { text = "\n" .. ns.strings.options.advanced.backup.backupBox.tooltip[2]:gsub("#ENTER", ns.strings.keys.enter), },
			[3] = { text = ns.strings.options.advanced.backup.backupBox.tooltip[3], color = { r = 0.89, g = 0.65, b = 0.40 }, },
			[4] = { text = "\n" .. ns.strings.options.advanced.backup.backupBox.tooltip[4], color = { r = 0.92, g = 0.34, b = 0.23 }, },
		}, },
		position = { offset = { x = 16, y = -30 } },
		size = { width = parentFrame:GetWidth() - 32, height = 302 },
		font = "GameFontWhiteSmall",
		maxLetters = 3500,
		scrollSpeed = 60,
		events = {
			OnEnterPressed = function() StaticPopup_Show(importPopup) end,
			OnEscapePressed = function(self) self.setText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true)) end,
		},
		optionsData = {
			optionsKey = addonNameSpace,
			onLoad = function(self) self.setText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true)) end,
		}
	})
	--Checkbox: Compact
	options.backup.compact = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Compact",
		title = ns.strings.options.advanced.backup.compact.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.advanced.backup.compact.tooltip, }, } },
		position = {
			relativeTo = backupBox,
			relativePoint = "BOTTOMLEFT",
			offset = { x = -8, y = -13 }
		},
		events = { OnClick = function(_, state)
			options.backup.string.setText(wt.TableToString({ account = db, character = dbc }, state, true))
			--Set focus after text change to set the scroll to the top and refresh the position character counter
			options.backup.string:SetFocus()
			options.backup.string:ClearFocus()
		end, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = cs,
			storageKey = "compactBackup",
		}
	})
	--Button: Load
	local load = wt.CreateButton({
		parent = parentFrame,
		name = "Load",
		title = ns.strings.options.advanced.backup.load.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.advanced.backup.load.tooltip, }, } },
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
		tooltip = { lines = { [0] = { text = ns.strings.options.advanced.backup.reset.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			relativeTo = load,
			relativePoint = "TOPLEFT",
			offset = { x = -10, }
		},
		events = { OnClick = function()
			options.backup.string.setText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true))
			--Set focus after text change to set the scroll to the top and refresh the position character counter
			options.backup.string:SetFocus()
			options.backup.string:ClearFocus()
		end, },
	})
end
local function CreateAdvancedCategoryPanels(parentFrame) --Add the advanced page widgets to the category panel frame
	--Profiles
	local profilesPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "Profiles",
		title = ns.strings.options.advanced.profiles.title,
		description = ns.strings.options.advanced.profiles.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 10, y = -82 } },
		size = { height = 64 },
	})
	CreateOptionsProfiles(profilesPanel)
	---Backup
	local backupOptions = wt.CreatePanel({
		parent = parentFrame,
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
	CreateBackupOptions(backupOptions)
end

--[ Options Category Panels ]

--Save the pending changes
local function SaveOptions()
	--Update the SavedVariabes DBs
	MovementSpeedDB = wt.Clone(db)
	MovementSpeedDBC = wt.Clone(dbc)
end
--Cancel all potential changes made in all option categories
local function CancelChanges()
	LoadDBs()
	--Speed Display
	wt.SetPosition(moveSpeed, db.speedDisplay.position)
	SetDisplayValues(db, dbc)
end
--Restore all the settings under the main option category to their default values
local function DefaultOptions()
	--Reset the DBs
	MovementSpeedDB = wt.Clone(dbDefault)
	MovementSpeedDBC = wt.Clone(dbcDefault)
	wt.CopyValues(dbDefault, db)
	wt.CopyValues(dbcDefault, dbc)
	--Reset the Custom preset
	presets[0].data = wt.Clone(db.customPreset)
	--Reset the speed display
	wt.SetPosition(moveSpeed, db.speedDisplay.position)
	SetDisplayValues(db, dbc)
	--Update the interface options
	wt.LoadOptionsData(addonNameSpace)
	--Set the preset selection to Custom
	options.visibility.presets.setSelected(0)
	--Notification
	print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.reset.response, ns.colors.yellow[1]))
end

--Create and add the options panels to the WoW Interface options
local function LoadInterfaceOptions()
	--Main options panel
	options.mainOptions = wt.CreateOptionsCategory({
		addon = addonNameSpace,
		name = "Main",
		description = ns.strings.options.main.description:gsub("#ADDON", addonTitle):gsub("#KEYWORD", ns.strings.chat.keyword),
		logo = ns.textures.logo,
		titleLogo = true,
		save = SaveOptions,
		cancel = CancelChanges,
		default = DefaultOptions,
		optionsKey = addonNameSpace,
	})
	CreateMainCategoryPanels(options.mainOptions.canvas) --Add categories & GUI elements to the panel
	--Display options panel
	options.speedDisplayOptions = wt.CreateOptionsCategory({
		parent = options.mainOptions.category,
		addon = addonNameSpace,
		name = "MainDisplay",
		title = ns.strings.options.speedDisplay.title,
		description = ns.strings.options.speedDisplay.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		scroll = {
			height = 759,
			speed = 58,
		},
		save = SaveOptions,
		cancel = CancelChanges,
		default = DefaultOptions,
		optionsKey = addonNameSpace,
		autoSave = false,
		autoLoad = false,
	})
	CreateSpeedDisplayCategoryPanels(options.speedDisplayOptions.scrollChild) --Add categories & GUI elements to the panel
	--Target Speed options panel
	options.targetSpeedOptions = wt.CreateOptionsCategory({
		parent = options.mainOptions.category,
		addon = addonNameSpace,
		name = "TargetSpeed",
		title = ns.strings.options.targetSpeed.title,
		description = ns.strings.options.targetSpeed.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		save = SaveOptions,
		cancel = CancelChanges,
		default = DefaultOptions,
		optionsKey = addonNameSpace,
		autoSave = false,
		autoLoad = false,
	})
	CreateTargetSpeedCategoryPanels(options.targetSpeedOptions.canvas) --Add categories & GUI elements to the panel
	--Advanced options panel
	options.advancedOptions = wt.CreateOptionsCategory({
		parent = options.mainOptions.category,
		addon = addonNameSpace,
		name = "Advanced",
		title = ns.strings.options.advanced.title,
		description = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		save = SaveOptions,
		cancel = CancelChanges,
		default = DefaultOptions,
		optionsKey = addonNameSpace,
		autoSave = false,
		autoLoad = false,
	})
	CreateAdvancedCategoryPanels(options.advancedOptions.canvas) --Add categories & GUI elements to the panel
end


--[[ CHAT CONTROL ]]

--[ Chat Utilities ]

---Print visibility info
---@param load boolean [Default: false]
local function PrintStatus(load)
	if load == true and not db.speedDisplay.visibility.statusNotice then return end
	print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(moveSpeed:IsVisible() and (
		not speedDisplay:IsVisible() and ns.strings.chat.status.notVisible or ns.strings.chat.status.visible
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
				"#SIZE", wt.Color(ns.strings.chat.size.command .. " " .. dbDefault.speedDisplay.text.font.size, ns.colors.green[1])
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
	onAccept = DefaultOptions,
})

--[ Slash Command Handlers ]

local function SaveCommand()
	--Update the Custom preset
	presets[0].data.position = wt.PackPosition(moveSpeed:GetPoint())
	presets[0].data.visibility.frameStrata = options.visibility.raise:GetChecked() and "HIGH" or "MEDIUM"
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
		moveSpeed:Show()
		moveSpeed:SetFrameStrata(presets[i].data.visibility.frameStrata)
		wt.SetPosition(moveSpeed, presets[i].data.position)
		--Update the GUI options in case the window was open
		options.visibility.hidden:SetChecked(false)
		options.visibility.hidden:SetAttribute("loaded", true) --Update dependent widgets
		options.position.anchor.setSelected(presets[i].data.position.anchor)
		options.position.xOffset:SetValue(presets[i].data.position.offset.x)
		options.position.yOffset:SetValue(presets[i].data.position.offset.y)
		options.visibility.raise:SetChecked(presets[i].data.visibility.frameStrata == "HIGH")
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
	options.visibility.hidden:SetChecked(dbc.hidden)
	options.visibility.hidden:SetAttribute("loaded", true) --Update dependent widgets
	--Update the visibility
	wt.SetVisibility(moveSpeed, not dbc.hidden)
	--Response
	print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(dbc.hidden and ns.strings.chat.toggle.hiding or ns.strings.chat.toggle.unhiding, ns.colors.yellow[1]))
end
local function AutoCommand()
	--Update the DBs
	db.speedDisplay.visibility.autoHide = not db.speedDisplay.visibility.autoHide
	MovementSpeedDB.speedDisplay.visibility.autoHide = db.speedDisplay.visibility.autoHide
	--Update the GUI option in case it was open
	options.visibility.autoHide:SetChecked(db.speedDisplay.visibility.autoHide)
	options.visibility.autoHide:SetAttribute("loaded", true) --Update dependent widgets
	--Response
	print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.auto.response:gsub(
		"#STATE", wt.Color(db.speedDisplay.visibility.autoHide and ns.strings.misc.enabled or ns.strings.misc.disabled, ns.colors.green[1])
	), ns.colors.yellow[1]))
end
local function SizeCommand(parameter)
	local size = tonumber(parameter)
	if size ~= nil then
		--Update the DBs
		db.speedDisplay.text.font.size = size
		MovementSpeedDB.speedDisplay.text.font.size = db.speedDisplay.text.font.size
		--Update the GUI option in case it was open
		options.text.font.size:SetValue(size)
		--Update the font
		speedDisplayText:SetFont(db.speedDisplay.text.font.family, db.speedDisplay.text.font.size, "THINOUTLINE")
		speedDisplayText:SetPoint("CENTER", 0.9, math.fmod(db.speedDisplay.text.font.size, 2) ~= 0 and 0.1 or 0)
		SetDisplaySize()
		--Response
		print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.size.response:gsub("#VALUE", wt.Color(size, ns.colors.green[1])), ns.colors.yellow[1]))
	else
		--Error
		print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.size.unchanged, ns.colors.yellow[0]))
		print(wt.Color(ns.strings.chat.size.error:gsub(
			"#SIZE", wt.Color(ns.strings.chat.size.command .. " " .. dbDefault.speedDisplay.text.font.size, ns.colors.green[1])
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
	elseif command == ns.strings.chat.options.command then options.mainOptions.open()
	elseif command == ns.strings.chat.save.command then SaveCommand()
	elseif command == ns.strings.chat.preset.command then PresetCommand(parameter)
	elseif command == ns.strings.chat.toggle.command then ToggleCommand()
	elseif command == ns.strings.chat.auto.command then AutoCommand()
	elseif command == ns.strings.chat.size.command then SizeCommand(parameter)
	elseif command == ns.strings.chat.reset.command then ResetCommand()
	else PrintInfo() end
end


--[[ SPEED DISPLAY UPDATE ]]

--Recalculate the movement speed value and update the displayed text
local function StartSpeedDisplayUpdate()
	moveSpeed:SetScript("OnUpdate", function()
		--Calculate the current player movement speed
		local speed = GetPlayerSpeed()
		--Toggle the visibility of the speed display (if auto-hide is enabled)
		wt.SetVisibility(speedDisplay, not db.speedDisplay.visibility.autoHide or speed ~= 0)
		--Update the speed display tooltip
		if speedDisplay:IsMouseOver() and ns.tooltip:IsVisible() then wt.UpdateTooltip({
			parent = speedDisplay,
			tooltip = ns.tooltip,
			title = ns.strings.speedTooltip.title,
			lines = GetSpeedTooltipLines(),
			flipColors = true,
			anchor = "ANCHOR_BOTTOMRIGHT",
			offset = { y = speedDisplay:GetHeight() },
		}) end
		--Update the speed display text
		local text = ""
		if db.speedDisplay.text.valueType == 0 then
			text = wt.FormatThousands(speed / 7 * 100, db.speedDisplay.text.decimals, true, not db.speedDisplay.text.noTrim) .. "%"
		elseif db.speedDisplay.text.valueType == 1 then
			text = ns.strings.yps:gsub(
				"#YARDS", wt.FormatThousands(speed, db.speedDisplay.text.decimals, true, not db.speedDisplay.text.noTrim)
			)
		elseif db.speedDisplay.text.valueType == 2 then
			text = wt.FormatThousands(speed / 7 * 100, db.speedDisplay.text.decimals, true, not db.speedDisplay.text.noTrim) .. "%" .. " ("
			text = text .. ns.strings.yps:gsub(
				"#YARDS", wt.FormatThousands(speed, db.speedDisplay.text.decimals, true, not db.speedDisplay.text.noTrim)
			) .. ")"
		end
		speedDisplayText:SetText(text)
	end)
end


--[[ MOUSEOVER TARGET SPEED ]]

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
	if not db.targetSpeed.tooltip.enabled then return end
	--Start mouseover target speed updates
	targetSpeed:SetScript("OnUpdate", function()
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

GameTooltip:HookScript("OnTooltipCleared", function()
	--Stop mouseover target speed updates
	targetSpeed:SetScript("OnUpdate", nil)
end)


--[[ INITIALIZATION ]]

--Set up the speed display context menu
local function CreateContextMenu()
	local contextMenu = wt.CreateContextMenu({ parent = speedDisplay, })

	--[ Items ]

	wt.AddContextLabel(contextMenu, { text = addonTitle, })

	--Options submenu
	local optionsMenu = wt.AddContextSubmenu(contextMenu, nil, {
		title = ns.strings.misc.options,
	})

	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.main.name,
		tooltip = { lines = { [0] = { text = ns.strings.options.main.description:gsub("#ADDON", addonTitle):gsub("#KEYWORD", ns.strings.chat.keyword), }, } },
		events = { OnClick = function() options.mainOptions.open() end, },
	})
	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.speedDisplay.title,
		tooltip = { lines = {
			[0] = { text = ns.strings.options.speedDisplay.description:gsub("#ADDON", addonTitle), },
			[1] = { text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, }
		} },
		events = { OnClick = function() options.speedDisplayOptions.open() end, },
		disabled = true,
	})
	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.targetSpeed.title,
		tooltip = { lines = {
			[0] = { text = ns.strings.options.targetSpeed.description:gsub("#ADDON", addonTitle), },
			[1] = { text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, }
		} },
		events = { OnClick = function() options.targetSpeedOptions.open() end, },
		disabled = true,
	})
	wt.AddContextButton(optionsMenu, contextMenu, {
		title = ns.strings.options.advanced.title,
		tooltip = { lines = {
			[0] = { text = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle), },
			[1] = { text = (wt.GetStrings("dfOpenSettings") or ""):gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 }, }
		} },
		events = { OnClick = function() options.advancedOptions.open() end, },
		disabled = true,
	})

	--Presets submenu
	local presetsMenu = wt.AddContextSubmenu(contextMenu, nil, {
		title = ns.strings.options.speedDisplay.quick.presets.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.speedDisplay.quick.presets.tooltip, }, } },
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

--[ Speed Display Setup ]

--Set frame parameters
local function SetUpSpeedDisplayFrame()
	--Main frame
	moveSpeed:SetToplevel(true)
	moveSpeed:SetSize(33, 10)
	wt.SetPosition(moveSpeed, db.speedDisplay.position)
	--Display elements
	speedDisplay:SetPoint("CENTER")
	speedDisplayText:SetPoint("CENTER", 0.9, math.fmod(db.speedDisplay.text.font.size, 2) ~= 0 and 0.1 or 0)
	SetDisplayValues(db, dbc)
	--Make movable
	wt.SetMovability(moveSpeed, true, "SHIFT", speedDisplay, {
		onStop = function()
			--Save the position (for account-wide use)
			wt.CopyValues(wt.PackPosition(moveSpeed:GetPoint()), db.speedDisplay.position)
			--Update in the SavedVariabes DB
			MovementSpeedDB.speedDisplay.position = wt.Clone(db.speedDisplay.position)
			--Update the GUI options in case the window was open
			options.position.anchor.setSelected(db.speedDisplay.position.anchor)
			options.position.xOffset:SetValue(db.speedDisplay.position.offset.x)
			options.position.yOffset:SetValue(db.speedDisplay.position.offset.y)
			--Chat response
			print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.position.save, ns.colors.yellow[1]))
		end,
		onCancel = function()
			--Reset the position
			wt.SetPosition(moveSpeed, db.speedDisplay.position)
			--Chat response
			print(wt.Color(addonTitle .. ":", ns.colors.green[0]) .. " " .. wt.Color(ns.strings.chat.position.cancel, ns.colors.yellow[0]))
			print(wt.Color(ns.strings.chat.position.error:gsub("#SHIFT", ns.strings.keys.shift), ns.colors.yellow[1]))
		end
	})
	--Context menu
	CreateContextMenu()
	--Tooltip
	wt.AddTooltip({
		parent = speedDisplay,
		tooltip = ns.tooltip,
		title = ns.strings.speedTooltip.title,
		lines = GetSpeedTooltipLines(),
		flipColors = true,
		anchor = "ANCHOR_BOTTOMRIGHT",
		offset = { y = speedDisplay:GetHeight() },
	})
end

--Hide during Pet Battle
function moveSpeed:PET_BATTLE_OPENING_START()
	moveSpeed:Hide()
end
function moveSpeed:PET_BATTLE_CLOSE()
	moveSpeed:Show()
end

--[ Loading ]

function moveSpeed:ADDON_LOADED(name)
	if name ~= addonNameSpace then return end
	moveSpeed:UnregisterEvent("ADDON_LOADED")
	--Load & check the DB
	if LoadDBs() then PrintInfo() end
	--Create cross-session character-specific variables
	if cs.compactBackup == nil then cs.compactBackup = true end
	--Load the custom preset
	presets[0].data = wt.Clone(db.customPreset)
	--Set up the interface options
	LoadInterfaceOptions()
	--Set up the main frame & text
	SetUpSpeedDisplayFrame()
	StartSpeedDisplayUpdate()
end

function moveSpeed:PLAYER_ENTERING_WORLD()
	--Toggle the visibility of the speed display (before OnUpdate would trigger)
	wt.SetVisibility(speedDisplay, not db.speedDisplay.visibility.autoHide or GetPlayerSpeed() ~= 0)
	--Visibility notice
	if not moveSpeed:IsVisible() or not speedDisplay:IsVisible() then PrintStatus(true) end
end