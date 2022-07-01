--[[ ADDON INFO ]]

--Addon namespace string & table
local addonNameSpace, ns = ...

--Addon display name
local _, addonTitle = GetAddOnInfo(addonNameSpace)

--Addon root folder
local root = "Interface/AddOns/" .. addonNameSpace .. "/"


--[[ ASSETS & RESOURCES ]]

--WidgetTools reference
local wt = WidgetToolbox[ns.WidgetToolsVersion]

--Strings & Localization
local strings = ns.LoadLocale()
strings.chat.keyword = "/movespeed"

--Colors
local colors = {
	grey = {
		[0] = { r = 0.54, g = 0.54, b = 0.54 },
	},
	green = {
		[0] = { r = 0.31, g = 0.85, b = 0.21 },
		[1] = { r = 0.56, g = 0.83, b = 0.43 },
	},
	yellow = {
		[0] = { r = 1, g = 0.87, b = 0.28 },
		[1] = { r = 1, g = 0.98, b = 0.60 },
	},
}

--Fonts
local fonts = {
	[0] = { name = strings.misc.default, path = strings.options.speedDisplay.text.font.family.default },
	[1] = { name = "Arbutus Slab", path = root .. "Fonts/ArbutusSlab.ttf" },
	[2] = { name = "Caesar Dressing", path = root .. "Fonts/CaesarDressing.ttf" },
	[3] = { name = "Germania One", path = root .. "Fonts/GermaniaOne.ttf" },
	[4] = { name = "Mitr", path = root .. "Fonts/Mitr.ttf" },
	[5] = { name = "Oxanium", path = root .. "Fonts/Oxanium.ttf" },
	[6] = { name = "Pattaya", path = root .. "Fonts/Pattaya.ttf" },
	[7] = { name = "Reem Kufi", path = root .. "Fonts/ReemKufi.ttf" },
	[8] = { name = "Source Code Pro", path = root .. "Fonts/SourceCodePro.ttf" },
	[9] = { name = strings.misc.custom, path = root .. "Fonts/CUSTOM.ttf" },
}

--Textures
local textures = {
	logo = root .. "Textures/Logo.tga",
}

--Anchor Points
local anchors = {
	[0] = { name = strings.points.top.left, point = "TOPLEFT" },
	[1] = { name = strings.points.top.center, point = "TOP" },
	[2] = { name = strings.points.top.right, point = "TOPRIGHT" },
	[3] = { name = strings.points.left, point = "LEFT" },
	[4] = { name = strings.points.center, point = "CENTER" },
	[5] = { name = strings.points.right, point = "RIGHT" },
	[6] = { name = strings.points.bottom.left, point = "BOTTOMLEFT" },
	[7] = { name = strings.points.bottom.center, point = "BOTTOM" },
	[8] = { name = strings.points.bottom.right, point = "BOTTOMRIGHT" },
}


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
			point = "TOP",
			offset = { x = 0, y = -100 },
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
				family = fonts[0].path,
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

--[ Preset data ]

local presets = {
	[0] = {
		name = strings.misc.custom, --Custom
		data = {
			position = dbDefault.speedDisplay.position,
			visibility = {
				frameStrata = dbDefault.speedDisplay.visibility.frameStrata,
			},
		},
	},
	[1] = {
		name = strings.options.speedDisplay.quick.presets.list[0], --Under Minimap Clock
		data = {
			position = {
				point = "TOPRIGHT",
				offset = { x = -69, y = -178 },
			},
			visibility = {
				frameStrata = "MEDIUM"
			},
		},
	},
}

--Add custom preset to DB
dbDefault.customPreset = presets[0].data


--[[ FRAMES & EVENTS ]]

--[ Speed Display ]

--Create frames
local moveSpeed = CreateFrame("Frame", addonNameSpace, UIParent)
local speedDisplay = CreateFrame("Frame", moveSpeed:GetName() .. "SpeedDisplay", moveSpeed, BackdropTemplateMixin and "BackdropTemplate")
local speedDisplayText = speedDisplay:CreateFontString(speedDisplay:GetName() .. "Text", "OVERLAY")

--Register events
moveSpeed:RegisterEvent("ADDON_LOADED")
moveSpeed:RegisterEvent("PLAYER_ENTERING_WORLD")

--Event handler
moveSpeed:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)

--Custom tooltip
local speedDisplayTooltip = wt.CreateGameTooltip(addonNameSpace)

--[ Target Speed ]

--Create frame
local targetSpeed = CreateFrame("Frame", addonNameSpace .. "TargetSpeed", UIParent)

--Event handler
targetSpeed:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)


--[[ UTILITIES ]]

---Find the ID of the font provided
---@param fontPath string
---@return integer
local function GetFontID(fontPath)
	local id = 0
	for i = 0, #fonts do
		if fonts[i].path == fontPath then
			id = i
			break
		end
	end
	return id
end

---Find the ID of the anchor point provided
---@param point AnchorPoint
---@return integer
local function GetAnchorID(point)
	local id = 0
	for i = 0, #anchors do
		if anchors[i].point == point then
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
		if k == "point" then data.speedDisplay.position.point = v
		elseif k == "x" then data.speedDisplay.position.offset.x = v
		elseif k == "offsetX" then data.speedDisplay.position.offset.x = v
		elseif k == "y" then data.speedDisplay.position.offset.y = v
		elseif k == "offsetY" then data.speedDisplay.position.offset.y = v
		elseif k == "frameStrata" then data.speedDisplay.visibility.frameStrata = v
		elseif k == "visible" then data.speedDisplay.background.visible = v
		elseif k == "family" then data.speedDisplay.text.font.family = v
		elseif k == "size" then data.speedDisplay.text.font.size = v
		end
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
	return GetUnitSpeed("player")
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
local function GetSpeedTooltipDetails()
	local speed = GetPlayerSpeed()
	return {
		[0] = {
			text = strings.speedTooltip.text[0],
		},
		[1] = {
			text = "\n" .. strings.speedTooltip.text[1]:gsub(
				"#YARDS", wt.Color(wt.FormatThousands(speed, 4, true),  colors.yellow[0])
			),
			color = colors.yellow[1],
		},
		[2] = {
			text = "\n" .. strings.speedTooltip.text[2]:gsub(
				"#PERCENT", wt.Color(wt.FormatThousands(speed / 7 * 100, 4, true) .. "%%", colors.green[0])
			),
			color = colors.green[1],
		},
		[3] = {
			text = "\n" .. strings.speedTooltip.hintOptions,
			font = GameFontNormalTiny,
			color = colors.grey[0],
		},
		[4] = {
			text = strings.speedTooltip.hintMove:gsub("#SHIFT", strings.keys.shift),
			font = GameFontNormalTiny,
			color = colors.grey[0],
		},
	}
end

---Assemble the text for the mouseover target's speed
---@return string
local function GetTargetSpeedText()
	local speed = GetUnitSpeed("mouseover")
	local text
	if db.targetSpeed.tooltip.text.valueType == 0 then
		text = wt.Color(wt.FormatThousands(speed / 7 * 100, db.targetSpeed.tooltip.text.decimals, true, not db.targetSpeed.tooltip.text.noTrim) .. "%%", colors.green[0])
	elseif db.targetSpeed.tooltip.text.valueType == 1 then
		text = wt.Color(strings.yardsps:gsub(
			"#YARDS", wt.Color(wt.FormatThousands(speed, db.targetSpeed.tooltip.text.decimals, true, not db.targetSpeed.tooltip.text.noTrim), colors.green[0])
		), colors.green[1])
	elseif db.targetSpeed.tooltip.text.valueType == 2 then
		text = wt.Color(wt.FormatThousands(speed / 7 * 100, db.targetSpeed.tooltip.text.decimals, true, not db.targetSpeed.tooltip.text.noTrim) .. "%%", colors.green[0]) .. " ("
		text = text .. wt.Color(strings.yardsps:gsub(
			"#YARDS", wt.Color(wt.FormatThousands(speed, db.targetSpeed.tooltip.text.decimals, true, not db.targetSpeed.tooltip.text.noTrim), colors.yellow[0])
		) .. ")", colors.yellow[1])
	end
	return "|T" .. textures.logo .. ":0|t" .. " " .. strings.targetSpeed:gsub("#SPEED", text)
end

--[ Speed Display ]

---Set the size of the speed display
---@param height? number Text height [Default: speedDisplayText:GetStringHeight()]
---@param valueType? number Height:Width ratio [Default: db.speedDisplay.text.valueType]
---@param decimals? number Height:Width ratio [Default: db.speedDisplay.text.decimals]
local function SetDisplaySize(height, valueType, decimals)
	height = math.ceil(height or speedDisplayText:GetStringHeight()) + 2
	local ratio = 3.1 + ((decimals or db.speedDisplay.text.decimals) > 0 and 0.25 + (decimals or db.speedDisplay.text.decimals) * 0.58 or 0)
	if (valueType or db.speedDisplay.text.valueType) == 1 then ratio = ratio + 0.3
	elseif (valueType or db.speedDisplay.text.valueType) == 2 then
		ratio = ratio + 3.1 + ((decimals or db.speedDisplay.text.decimals) > 0 and 0.25 + (decimals or db.speedDisplay.text.decimals) * 0.58 or 0)
	end
	local width = height * ratio - 4
	speedDisplay:SetSize(width, height)
end

---Set the backdrop of the speed display elements
---@param enabled boolean Whether to add or remove the backdrop elements of the speed display
---@param backdropColors table Table containing the backdrop color values of all speed display elements
--- - **bg** table
--- 	- **r** number ― Red (Range: 0 - 1)
--- 	- **g** number ― Green (Range: 0 - 1)
--- 	- **b** number ― Blue (Range: 0 - 1)
--- 	- **a** number ― Opacity (Range: 0 - 1)
--- - **border** table
--- 	- **r** number ― Red (Range: 0 - 1)
--- 	- **g** number ― Green (Range: 0 - 1)
--- 	- **b** number ― Blue (Range: 0 - 1)
--- 	- **a** number ― Opacity (Range: 0 - 1)
local function SetDisplayBackdrop(enabled, backdropColors)
	if not enabled then speedDisplay:SetBackdrop(nil)
	else
		speedDisplay:SetBackdrop({
			bgFile = "Interface/ChatFrame/ChatFrameBackground",
			edgeFile = "Interface/ChatFrame/ChatFrameBackground",
			tile = true, tileSize = 5, edgeSize = 1,
			insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
		speedDisplay:SetBackdropColor(wt.UnpackColor(backdropColors.bg))
		speedDisplay:SetBackdropBorderColor(wt.UnpackColor(backdropColors.border))
	end
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
	SetDisplayBackdrop(data.speedDisplay.background.visible, data.speedDisplay.background.colors)
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
		title = strings.options.speedDisplay.title,
		tooltip = { [0] = { text = strings.options.speedDisplay.description:gsub("#ADDON", addonTitle) }, },
		position = { offset = { x = 10, y = -30 } },
		width = 120,
		onClick = function() InterfaceOptionsFrame_OpenToCategory(options.speedDisplayOptionsPage) end,
	})
	--Button: Target Speed page
	wt.CreateButton({
		parent = parentFrame,
		name = "TargetSpeedPage",
		title = strings.options.targetSpeed.title,
		tooltip = { [0] = { text = strings.options.targetSpeed.description:gsub("#ADDON", addonTitle) }, },
		position = {
			relativeTo = speedDisplayPage,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		width = 120,
		onClick = function() InterfaceOptionsFrame_OpenToCategory(options.targetSpeedOptionsPage) end,
	})
	--Button: Advanced page
	wt.CreateButton({
		parent = parentFrame,
		name = "AdvancedPage",
		title = strings.options.advanced.title,
		tooltip = { [0] = { text = strings.options.advanced.description:gsub("#ADDON", addonTitle) }, },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -30 }
		},
		width = 120,
		onClick = function() InterfaceOptionsFrame_OpenToCategory(options.advancedOptionsPage) end,
	})
end
local function CreateAboutInfo(parentFrame)
	--Text: Version
	local version = wt.CreateText({
		parent = parentFrame,
		name = "Version",
		position = { offset = { x = 16, y = -33 } },
		width = 84,
		text = strings.options.main.about.version:gsub("#VERSION", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "Version"), "FFFFFFFF")),
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
		text = strings.options.main.about.date:gsub(
			"#DATE", WrapTextInColorCode(strings.misc.date:gsub(
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
		text = strings.options.main.about.author:gsub("#AUTHOR", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "Author"), "FFFFFFFF")),
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
		text = strings.options.main.about.license:gsub("#LICENSE", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "X-License"), "FFFFFFFF")),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})
	--EditScrollBox: Changelog
	options.about.changelog = wt.CreateEditScrollBox({
		parent = parentFrame,
		name = "Changelog",
		title = strings.options.main.about.changelog.label,
		tooltip = { [0] = { text = strings.options.main.about.changelog.tooltip }, },
		position = {
			relativeTo = version,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -12 }
		},
		size = { width = parentFrame:GetWidth() - 32, height = 139 },
		text = ns.GetChangelog(),
		fontObject = "GameFontDisableSmall",
		readOnly = true,
		scrollSpeed = 45,
	})
end
local function CreateSupportInfo(parentFrame)
	--Copybox: CurseForge
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "CurseForge",
		title = strings.options.main.support.curseForge .. ":",
		position = { offset = { x = 16, y = -33 } },
		width = parentFrame:GetWidth() / 2 - 22,
		text = "curseforge.com/wow/addons/movement-speed",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.75, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Wago
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Wago",
		title = strings.options.main.support.wago .. ":",
		position = {
			anchor = "TOP",
			offset = { x = (parentFrame:GetWidth() / 2 - 22) / 2 + 8, y = -33 }
		},
		width = parentFrame:GetWidth() / 2 - 22,
		text = "addons.wago.io/addons/movement-speed",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.75, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: BitBucket
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "BitBucket",
		title = strings.options.main.support.bitBucket .. ":",
		position = { offset = { x = 16, y = -70 } },
		width = parentFrame:GetWidth() / 2 - 22,
		text = "bitbucket.org/Arxareon/movement-speed",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.75, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Issues
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Issues",
		title = strings.options.main.support.issues .. ":",
		position = {
			anchor = "TOP",
			offset = { x = (parentFrame:GetWidth() / 2 - 22) / 2 + 8, y = -70 }
		},
		width = parentFrame:GetWidth() / 2 - 22,
		text = "bitbucket.org/Arxareon/movement-speed/issues",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.75, g = 0.95, b = 1, a = 1 },
	})
end
local function CreateMainCategoryPanels(parentFrame) --Add the main page widgets to the category panel frame
	--Shortcuts
	local shortcutsPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "Shortcuts",
		title = strings.options.main.shortcuts.title,
		description = strings.options.main.shortcuts.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 16, y = -82 } },
		size = { height = 64 },
	})
	CreateOptionsShortcuts(shortcutsPanel)
	--About
	local aboutPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "About",
		title = strings.options.main.about.title,
		description = strings.options.main.about.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = shortcutsPanel,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 231 },
	})
	CreateAboutInfo(aboutPanel)
	--Support
	local supportPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "Support",
		title = strings.options.main.support.title,
		description = strings.options.main.support.description:gsub("#ADDON", addonTitle),
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
		title = strings.options.speedDisplay.quick.hidden.label,
		tooltip = { [0] = { text = strings.options.speedDisplay.quick.hidden.tooltip:gsub("#ADDON", addonTitle) }, },
		position = { offset = { x = 8, y = -30 } },
		onClick = function(self) wt.SetVisibility(moveSpeed, not (self:GetChecked())) end,
		optionsData = {
			storageTable = dbc,
			key = "hidden",
		},
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
			wt.PositionFrame(moveSpeed, presets[i].data.position.point, nil, nil, presets[i].data.position.offset.x, presets[i].data.position.offset.y)
			--Update the options
			options.position.anchor.setSelected(GetAnchorID(presets[i].data.position.point))
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
		title = strings.options.speedDisplay.quick.presets.label,
		tooltip = { [0] = { text = strings.options.speedDisplay.quick.presets.tooltip }, },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		width = 160,
		items = presetItems,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		onLoad = function(self)
			UIDropDownMenu_SetSelectedValue(self, nil)
			UIDropDownMenu_SetText(self, strings.options.speedDisplay.quick.presets.select)
		end,
	})
	--Button & Popup: Save Custom preset
	local savePopup = wt.CreatePopup({
		addon = addonNameSpace,
		name = "SAVEPRESET",
		text = strings.options.speedDisplay.quick.savePreset.warning,
		accept = strings.misc.override,
		onAccept = function()
			--Update the Custom preset
			presets[0].data.position.point, _, _, presets[0].data.position.offset.x, presets[0].data.position.offset.y = moveSpeed:GetPoint()
			presets[0].data.visibility.frameStrata = options.visibility.raise:GetChecked() and "HIGH" or "MEDIUM"
			--Save the Custom preset
			db.customPreset = presets[0].data
			--Response
			print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(strings.chat.save.response, colors.yellow[1]))
		end,
	})
	wt.CreateButton({
		parent = parentFrame,
		name = "SavePreset",
		title = strings.options.speedDisplay.quick.savePreset.label,
		tooltip = { [0] = { text = strings.options.speedDisplay.quick.savePreset.tooltip }, },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -50 }
		},
		width = 160,
		onClick = function() StaticPopup_Show(savePopup) end,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
	})
end
local function CreatePositionOptions(parentFrame)
	--Selector: Anchor point
	local anchorItems = {}
	for i = 0, #anchors do
		anchorItems[i] = {}
		anchorItems[i].title = anchors[i].name
		anchorItems[i].onSelect = function()
			wt.PositionFrame(moveSpeed, anchors[i].point, nil, nil, options.position.xOffset:GetValue(), options.position.yOffset:GetValue())
			--Clear the presets dropdown selection
			UIDropDownMenu_SetSelectedValue(options.visibility.presets, nil)
			UIDropDownMenu_SetText(options.visibility.presets, strings.options.speedDisplay.quick.presets.select)
		end
	end
	options.position.anchor = wt.CreateSelector({
		parent = parentFrame,
		name = "AnchorPoint",
		title = strings.options.speedDisplay.position.anchor.label,
		tooltip = { [0] = { text = strings.options.speedDisplay.position.anchor.tooltip }, },
		position = { offset = { x = 8, y = -30 } },
		items = anchorItems,
		labels = false,
		columns = 3,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		optionsData = {
			storageTable = db.speedDisplay.position,
			key = "point",
			convertSave = function(value) return anchors[value].point end,
			convertLoad = function(point) return GetAnchorID(point) end,
		},
	})
	--Slider: X offset
	options.position.xOffset = wt.CreateSlider({
		parent = parentFrame,
		name = "OffsetX",
		title = strings.options.speedDisplay.position.xOffset.label,
		tooltip = { [0] = { text = strings.options.speedDisplay.position.xOffset.tooltip }, },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		value = { min = -500, max = 500, fractional = 2 },
		onValueChanged = function(_, value)
			wt.PositionFrame(moveSpeed, anchors[options.position.anchor.getSelected()].point, nil, nil, value, options.position.yOffset:GetValue())
			--Clear the presets dropdown selection
			UIDropDownMenu_SetSelectedValue(options.visibility.presets, nil)
			UIDropDownMenu_SetText(options.visibility.presets, strings.options.speedDisplay.quick.presets.select)
		end,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		optionsData = {
			storageTable = db.speedDisplay.position.offset,
			key = "x",
		},
	})
	--Slider: Y offset
	options.position.yOffset = wt.CreateSlider({
		parent = parentFrame,
		name = "OffsetY",
		title = strings.options.speedDisplay.position.yOffset.label,
		tooltip = { [0] = { text = strings.options.speedDisplay.position.yOffset.tooltip }, },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -14, y = -30 }
		},
		value = { min = -500, max = 500, fractional = 2 },
		onValueChanged = function(_, value)
			wt.PositionFrame(moveSpeed, anchors[options.position.anchor.getSelected()].point, nil, nil, options.position.xOffset:GetValue(), value)
			--Clear the presets dropdown selection
			UIDropDownMenu_SetSelectedValue(options.visibility.presets, nil)
			UIDropDownMenu_SetText(options.visibility.presets, strings.options.speedDisplay.quick.presets.select)
		end,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		optionsData = {
			storageTable = db.speedDisplay.position.offset,
			key = "y",
		},
	})
end
local function CreateTextOptions(parentFrame)
	--Selector: Value type
	local valueTypes = {}
	for i = 0, 2 do
		valueTypes[i] = {}
		valueTypes[i].title = strings.options.speedText.valueType.list[i].label
		valueTypes[i].tooltip = { [0] = { text = strings.options.speedText.valueType.list[i].tooltip }, }
		valueTypes[i].onSelect = function()
			db.speedDisplay.text.valueType = i
			SetDisplaySize()
		end
	end
	options.text.valueType = wt.CreateSelector({
		parent = parentFrame,
		name = "ValueType",
		title = strings.options.speedText.valueType.label,
		tooltip = { [0] = { text = strings.options.speedText.valueType.tooltip }, },
		position = { offset = { x = 8, y = -30 } },
		items = valueTypes,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		optionsData = {
			storageTable = db.speedDisplay.text,
			key = "valueType",
		},
	})
	--Slider: Decimals
	options.text.decimals = wt.CreateSlider({
		parent = parentFrame,
		name = "Decimals",
		title = strings.options.speedText.decimals.label,
		tooltip = { [0] = { text = strings.options.speedText.decimals.tooltip }, },
		position = {
			anchor = "TOP",
			offset = { y = -30 }
		},
		value = { min = 0, max = 4, step = 1 },
		onValueChanged = function(_, value)
			db.speedDisplay.text.decimals = value
			SetDisplaySize()
		end,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		optionsData = {
			storageTable = db.speedDisplay.text,
			key = "decimals",
		},
	})
	--Checkbox: No trim
	options.text.noTrim = wt.CreateCheckbox({
		parent = parentFrame,
		name = "NoTrim",
		title = strings.options.speedText.noTrim.label,
		tooltip = { [0] = { text = strings.options.speedText.noTrim.tooltip }, },
		position = {
			anchor = "TOPRIGHT",
			offset = { y = -30 }
		},
		autoOffset = true,
		onClick = function(self) db.speedDisplay.text.noTrim = self:GetChecked() end,
		dependencies = {
			[0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, },
			[1] = { frame = options.text.decimals, evaluate = function(value) return value > 0 end },
		},
		optionsData = {
			storageTable = db.speedDisplay.text,
			key = "noTrim",
		},
	})
	--Dropdown: Font family
	local fontItems = {}
	for i = 0, #fonts do
		fontItems[i] = {}
		fontItems[i].title = fonts[i].name
		fontItems[i].onSelect = function()
			speedDisplayText:SetFont(fonts[i].path, options.text.font.size:GetValue(), "THINOUTLINE")
			--Refresh the text so the font will be applied even the first time as well not just subsequent times
			local text = speedDisplayText:GetText()
			speedDisplayText:SetText("")
			speedDisplayText:SetText(text)
		end
	end
	options.text.font.family = wt.CreateDropdown({
		parent = parentFrame,
		name = "FontFamily",
		title = strings.options.speedDisplay.text.font.family.label,
		tooltip = {
			[0] = { text = strings.options.speedDisplay.text.font.family.tooltip[0] },
			[1] = { text = "\n" .. strings.options.speedDisplay.text.font.family.tooltip[1] },
			[2] = { text = "\n" .. strings.options.speedDisplay.text.font.family.tooltip[2]:gsub("#OPTION_CUSTOM", strings.misc.custom):gsub("#FILE_CUSTOM", "CUSTOM.ttf") },
			[3] = { text = "[WoW]\\Interface\\AddOns\\" .. addonNameSpace .. "\\Fonts\\", color = { r = 0.185, g = 0.72, b = 0.84 }, wrap = false },
			[4] = { text = strings.options.speedDisplay.text.font.family.tooltip[3]:gsub("#FILE_CUSTOM", "CUSTOM.ttf") },
			[5] = { text = strings.options.speedDisplay.text.font.family.tooltip[4], color = { r = 0.89, g = 0.65, b = 0.40 } },
		},
		position = { offset = { x = -6, y = -101 } },
		items = fontItems,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		optionsData = {
			storageTable = db.speedDisplay.text.font,
			key = "family",
			convertSave = function(value) return fonts[value].path end,
			convertLoad = function(font) return GetFontID(font) end,
		},
	})
	--Slider: Font size
	options.text.font.size = wt.CreateSlider({
		parent = parentFrame,
		name = "FontSize",
		title = strings.options.speedDisplay.text.font.size.label,
		tooltip = { [0] = { text = strings.options.speedDisplay.text.font.size.tooltip .. "\n\n" .. strings.misc.default .. ": " .. dbDefault.speedDisplay.text.font.size }, },
		position = {
			anchor = "TOP",
			offset = { y = -101 }
		},
		value = { min = 8, max = 64, step = 1 },
		onValueChanged = function(_, value)
			speedDisplayText:SetFont(speedDisplayText:GetFont(), value, "THINOUTLINE")
			speedDisplayText:SetPoint("CENTER", 0.9, math.fmod(db.speedDisplay.text.font.size, 2) ~= 0 and 0.1 or 0)
			SetDisplaySize()
		end,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		optionsData = {
			storageTable = db.speedDisplay.text.font,
			key = "size",
		},
	})
	--Color Picker: Font color
	options.text.font.color = wt.CreateColorPicker({
		parent = parentFrame,
		name = "FontColor",
		title = strings.options.speedDisplay.text.font.color.label,
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -12, y = -101 }
		},
		opacity = true,
		setColors = function() return speedDisplayText:GetTextColor() end,
		onColorUpdate = function(r, g, b, a) speedDisplayText:SetTextColor(r, g, b, a) end,
		onCancel = function(r, g, b, a) speedDisplayText:SetTextColor(r, g, b, a) end,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		optionsData = {
			storageTable = db.speedDisplay.text.font,
			key = "color",
		},
	})
end
local function CreateBackgroundOptions(parentFrame)
	--Checkbox: Visible
	options.background.visible = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Visible",
		title = strings.options.speedDisplay.background.visible.label,
		tooltip = { [0] = { text = strings.options.speedDisplay.background.visible.tooltip }, },
		position = { offset = { x = 8, y = -30 } },
		onClick = function(self)
			SetDisplayBackdrop(self:GetChecked(), {
				bg = wt.PackColor(options.background.colors.bg.getColor()),
				border = wt.PackColor(options.background.colors.border.getColor()),
			})
		end,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		optionsData = {
			storageTable = db.speedDisplay.background,
			key = "visible",
		},
	})
	--Color Picker: Background color
	options.background.colors.bg = wt.CreateColorPicker({
		parent = parentFrame,
		name = "BackgroundColor",
		title = strings.options.speedDisplay.background.colors.bg.label,
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
			[0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, },
			[1] = { frame = options.background.visible },
		},
		optionsData = {
			storageTable = db.speedDisplay.background.colors,
			key = "bg",
		},
	})
	--Color Picker: Border color
	options.background.colors.border = wt.CreateColorPicker({
		parent = parentFrame,
		name = "BorderColor",
		title = strings.options.speedDisplay.background.colors.border.label,
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
			[0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, },
			[1] = { frame = options.background.visible },
		},
		optionsData = {
			storageTable = db.speedDisplay.background.colors,
			key = "border",
		},
	})
end
local function CreateVisibilityOptions(parentFrame)
	--Checkbox: Raise
	options.visibility.raise = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Raise",
		title = strings.options.speedDisplay.visibility.raise.label,
		tooltip = { [0] = { text = strings.options.speedDisplay.visibility.raise.tooltip }, },
		position = { offset = { x = 8, y = -30 } },
		onClick = function(self)
			moveSpeed:SetFrameStrata(self:GetChecked() and "HIGH" or "MEDIUM")
			--Clear the presets dropdown selection
			UIDropDownMenu_SetSelectedValue(options.visibility.presets, nil)
			UIDropDownMenu_SetText(options.visibility.presets, strings.options.speedDisplay.quick.presets.select)
		end,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		optionsData = {
			storageTable = db.speedDisplay.visibility,
			key = "frameStrata",
			convertSave = function(enabled) return enabled and "HIGH" or "MEDIUM" end,
			convertLoad = function(strata) return strata == "HIGH" end,
		},
	})
	--Checkbox: Auto-hide toggle
	options.visibility.autoHide = wt.CreateCheckbox({
		parent = parentFrame,
		name = "AutoHide",
		title = strings.options.speedDisplay.visibility.autoHide.label,
		tooltip = { [0] = { text = strings.options.speedDisplay.visibility.autoHide.tooltip }, },
		position = {
			relativeTo = options.visibility.raise,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -4 }
		},
		onClick = function(self) db.speedDisplay.visibility.autoHide = self:GetChecked() end,
		dependencies = { [0] = { frame = options.visibility.hidden, evaluate = function(state) return not state end, }, },
		optionsData = {
			storageTable = db.speedDisplay.visibility,
			key = "autoHide",
		},
	})
	--Checkbox: Status notice
	options.visibility.status = wt.CreateCheckbox({
		parent = parentFrame,
		name = "StatusNotice",
		title = strings.options.speedDisplay.visibility.statusNotice.label,
		tooltip = { [0] = { text = strings.options.speedDisplay.visibility.statusNotice.tooltip:gsub("#ADDON", addonTitle) }, },
		position = {
			relativeTo = options.visibility.autoHide,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -4 }
		},
		optionsData = {
			storageTable = db.speedDisplay.visibility,
			key = "statusNotice",
		},
	})
end
local function CreateSpeedDisplayCategoryPanels(parentFrame) --Add the speed display page widgets to the category panel frame
	--Quick settings
	local quickOptions = wt.CreatePanel({
		parent = parentFrame,
		name = "QuickSettings",
		title = strings.options.speedDisplay.quick.title,
		description = strings.options.speedDisplay.quick.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 16, y = -78 } },
		size = { height = 84 },
	})
	CreateQuickOptions(quickOptions)
	--Position
	local positionOptions = wt.CreatePanel({
		parent = parentFrame,
		name = "Position",
		title = strings.options.speedDisplay.position.title,
		description = strings.options.speedDisplay.position.description:gsub("#SHIFT", strings.keys.shift),
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
		title = strings.options.speedDisplay.text.title,
		description = strings.options.speedDisplay.text.description,
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
		title = strings.options.speedDisplay.background.title,
		description = strings.options.speedDisplay.background.description:gsub("#ADDON", addonTitle),
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
		title = strings.options.speedDisplay.visibility.title,
		description = strings.options.speedDisplay.visibility.description:gsub("#ADDON", addonTitle),
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
		title = strings.options.targetSpeed.mouseover.enabled.label,
		tooltip = { [0] = { text = strings.options.targetSpeed.mouseover.enabled.tooltip:gsub("#ADDON", addonTitle) }, },
		position = { offset = { x = 8, y = -30 } },
		onClick = function(self) db.targetSpeed.tooltip.enabled = self:GetChecked() end,
		optionsData = {
			storageTable = db.targetSpeed.tooltip,
			key = "enabled",
		},
	})
	--Selector: Value type
	local valueTypes = {}
	for i = 0, 2 do
		valueTypes[i] = {}
		valueTypes[i].title = strings.options.speedText.valueType.list[i].label
		valueTypes[i].tooltip = { [0] = { text = strings.options.speedText.valueType.list[i].tooltip }, }
		valueTypes[i].onSelect = function() db.targetSpeed.tooltip.text.valueType = i end
	end
	options.mouseover.valueType = wt.CreateSelector({
		parent = parentFrame,
		name = "ValueType",
		title = strings.options.speedText.valueType.label,
		tooltip = { [0] = { text = strings.options.speedText.valueType.tooltip }, },
		position = { offset = { x = 8, y = -60 } },
		items = valueTypes,
		dependencies = { [0] = { frame = options.mouseover.enabled }, },
		optionsData = {
			storageTable = db.targetSpeed.tooltip.text,
			key = "valueType",
		},
	})
	--Slider: Decimals
	options.mouseover.decimals = wt.CreateSlider({
		parent = parentFrame,
		name = "Decimals",
		title = strings.options.speedText.decimals.label,
		tooltip = { [0] = { text = strings.options.speedText.decimals.tooltip }, },
		position = {
			anchor = "TOP",
			offset = { y = -60 }
		},
		value = { min = 0, max = 4, step = 1 },
		onValueChanged = function(_, value) db.targetSpeed.tooltip.text.decimals = value end,
		dependencies = { [0] = { frame = options.mouseover.enabled }, },
		optionsData = {
			storageTable = db.targetSpeed.tooltip.text,
			key = "decimals",
		},
	})
	--Checkbox: No trim
	options.mouseover.noTrim = wt.CreateCheckbox({
		parent = parentFrame,
		name = "NoTrim",
		title = strings.options.speedText.noTrim.label,
		tooltip = { [0] = { text = strings.options.speedText.noTrim.tooltip }, },
		position = {
			anchor = "TOPRIGHT",
			offset = { y = -60 }
		},
		autoOffset = true,
		onClick = function(self) db.targetSpeed.tooltip.text.noTrim = self:GetChecked() end,
		dependencies = {
			[0] = { frame = options.mouseover.enabled },
			[1] = { frame = options.mouseover.decimals, evaluate = function(value) return value > 0 end },
		},
		optionsData = {
			storageTable = db.targetSpeed.tooltip.text,
			key = "noTrim",
		},
	})
end
local function CreateTargetSpeedCategoryPanels(parentFrame) --Add the speed display page widgets to the category panel frame
	--Mouseover
	local mouseoverOptions = wt.CreatePanel({
		parent = parentFrame,
		name = "Mouseover",
		title = strings.options.targetSpeed.mouseover.title,
		description = strings.options.targetSpeed.mouseover.description,
		position = { offset = { x = 16, y = -82 } },
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
		text = strings.options.advanced.backup.warning,
		accept = strings.options.advanced.backup.import,
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
				--Reset the custom preset
				presets[0].data = db.customPreset
				--Reset the speed display
				wt.PositionFrame(moveSpeed, db.speedDisplay.position.point, nil, nil, db.speedDisplay.position.offset.x, db.speedDisplay.position.offset.y)
				SetDisplayValues(db, dbc)
				--Update the interface options
				wt.LoadOptionsData()
			else print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(strings.options.advanced.backup.error, colors.yellow[1])) end
		end
	})
	local backupBox
	options.backup.string, backupBox = wt.CreateEditScrollBox({
		parent = parentFrame,
		name = "ImportExport",
		title = strings.options.advanced.backup.backupBox.label,
		tooltip = {
			[0] = { text = strings.options.advanced.backup.backupBox.tooltip[0] },
			[1] = { text = "\n" .. strings.options.advanced.backup.backupBox.tooltip[1] },
			[2] = { text = "\n" .. strings.options.advanced.backup.backupBox.tooltip[2]:gsub("#ENTER", strings.keys.enter) },
			[3] = { text = strings.options.advanced.backup.backupBox.tooltip[3], color = { r = 0.89, g = 0.65, b = 0.40 } },
			[4] = { text = "\n" .. strings.options.advanced.backup.backupBox.tooltip[4], color = { r = 0.92, g = 0.34, b = 0.23 } },
		},
		position = { offset = { x = 16, y = -30 } },
		size = { width = parentFrame:GetWidth() - 32, height = 276 },
		maxLetters = 3500,
		fontObject = "GameFontWhiteSmall",
		scrollSpeed = 60,
		onEnterPressed = function() StaticPopup_Show(importPopup) end,
		onEscapePressed = function(self) self:SetText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true)) end,
		onLoad = function(self) self:SetText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true)) end,
	})
	--Checkbox: Compact
	options.backup.compact = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Compact",
		title = strings.options.advanced.backup.compact.label,
		tooltip = { [0] = { text = strings.options.advanced.backup.compact.tooltip }, },
		position = {
			relativeTo = backupBox,
			relativePoint = "BOTTOMLEFT",
			offset = { x = -8, y = -13 }
		},
		onClick = function(self)
			options.backup.string:SetText(wt.TableToString({ account = db, character = dbc }, self:GetChecked(), true))
			--Set focus after text change to set the scroll to the top and refresh the position character counter
			options.backup.string:SetFocus()
			options.backup.string:ClearFocus()
		end,
		optionsData = {
			storageTable = cs,
			key = "compactBackup",
		},
	})
	--Button: Load
	local load = wt.CreateButton({
		parent = parentFrame,
		name = "Load",
		title = strings.options.advanced.backup.load.label,
		tooltip = { [0] = { text = strings.options.advanced.backup.load.tooltip }, },
		position = {
			anchor = "TOPRIGHT",
			relativeTo = backupBox,
			relativePoint = "BOTTOMRIGHT",
			offset = { x = 6, y = -13 }
		},
		width = 80,
		onClick = function() StaticPopup_Show(importPopup) end,
	})
	--Button: Reset
	wt.CreateButton({
		parent = parentFrame,
		name = "Reset",
		title = strings.options.advanced.backup.reset.label,
		tooltip = { [0] = { text = strings.options.advanced.backup.reset.tooltip }, },
		position = {
			anchor = "TOPRIGHT",
			relativeTo = load,
			relativePoint = "TOPLEFT",
			offset = { x = -10, }
		},
		width = 80,
		onClick = function()
			options.backup.string:SetText("") --Remove text to make sure OnTextChanged will get called
			options.backup.string:SetText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true))
			--Set focus after text change to set the scroll to the top and refresh the position character counter
			options.backup.string:SetFocus()
			options.backup.string:ClearFocus()
		end,
	})
end
local function CreateAdvancedCategoryPanels(parentFrame) --Add the advanced page widgets to the category panel frame
	--Profiles
	local profilesPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "Profiles",
		title = strings.options.advanced.profiles.title,
		description = strings.options.advanced.profiles.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 16, y = -82 } },
		size = { height = 64 },
	})
	CreateOptionsProfiles(profilesPanel)
	---Backup
	local backupOptions = wt.CreatePanel({
		parent = parentFrame,
		name = "Backup",
		title = strings.options.advanced.backup.title,
		description = strings.options.advanced.backup.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = profilesPanel,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 374 },
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
	wt.PositionFrame(moveSpeed, db.speedDisplay.position.point, nil, nil, db.speedDisplay.position.offset.x, db.speedDisplay.position.offset.y)
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
	presets[0].data = db.customPreset
	--Reset the speed display
	wt.PositionFrame(moveSpeed, db.speedDisplay.position.point, nil, nil, db.speedDisplay.position.offset.x, db.speedDisplay.position.offset.y)
	SetDisplayValues(db, dbc)
	--Update the interface options
	wt.LoadOptionsData()
	--Set the preset selection to Custom
	UIDropDownMenu_SetSelectedValue(options.visibility.presets, 0)
	UIDropDownMenu_SetText(options.visibility.presets, presets[0].name)
	--Notification
	print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(strings.options.defaults, colors.yellow[1]))
end

--Create and add the options panels to the WoW Interface options
local function LoadInterfaceOptions()
	--Main options panel
	options.mainOptionsPage = wt.CreateOptionsPanel({
		addon = addonNameSpace,
		name = "Main",
		description = strings.options.main.description:gsub("#ADDON", addonTitle):gsub("#KEYWORD", strings.chat.keyword),
		logo = textures.logo,
		titleLogo = true,
		okay = SaveOptions,
		cancel = CancelChanges,
		default = DefaultOptions,
	})
	CreateMainCategoryPanels(options.mainOptionsPage) --Add categories & GUI elements to the panel
	--Display options panel
	local displayOptionsScrollFrame
	options.speedDisplayOptionsPage, displayOptionsScrollFrame = wt.CreateOptionsPanel({
		parent = options.mainOptionsPage.name,
		addon = addonNameSpace,
		name = "SpeedDisplay",
		title = strings.options.speedDisplay.title,
		description = strings.options.speedDisplay.description:gsub("#ADDON", addonTitle),
		logo = textures.logo,
		scroll = {
			height = 768,
			speed = 45,
		},
		default = DefaultOptions,
		autoSave = false,
		autoLoad = false,
	})
	CreateSpeedDisplayCategoryPanels(displayOptionsScrollFrame) --Add categories & GUI elements to the panel
	--Target Speed options panel
	options.targetSpeedOptionsPage = wt.CreateOptionsPanel({
		parent = options.mainOptionsPage.name,
		addon = addonNameSpace,
		name = "TargetSpeed",
		title = strings.options.targetSpeed.title,
		description = strings.options.targetSpeed.description:gsub("#ADDON", addonTitle),
		logo = textures.logo,
		default = DefaultOptions,
		autoSave = false,
		autoLoad = false,
	})
	CreateTargetSpeedCategoryPanels(options.targetSpeedOptionsPage) --Add categories & GUI elements to the panel
	--Advanced options panel
	options.advancedOptionsPage = wt.CreateOptionsPanel({
		parent = options.mainOptionsPage.name,
		addon = addonNameSpace,
		name = "Advanced",
		title = strings.options.advanced.title,
		description = strings.options.advanced.description:gsub("#ADDON", addonTitle),
		logo = textures.logo,
		default = DefaultOptions,
		autoSave = false,
		autoLoad = false,
	})
	CreateAdvancedCategoryPanels(options.advancedOptionsPage) --Add categories & GUI elements to the panel
end


--[[ CHAT CONTROL ]]

--[ Chat Utilities ]

---Print visibility info
---@param load boolean [Default: false]
local function PrintStatus(load)
	if load == true and not db.speedDisplay.visibility.statusNotice then return end
	print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(moveSpeed:IsVisible() and (
		not speedDisplay:IsVisible() and strings.chat.status.notVisible or strings.chat.status.visible
	) or strings.chat.status.hidden, colors.yellow[0]):gsub(
		"#AUTO", wt.Color(strings.chat.status.auto:gsub(
			"#STATE", wt.Color(db.speedDisplay.visibility.autoHide and strings.misc.enabled or strings.misc.disabled, colors.green[1])
		), colors.yellow[1])
	))
end
--Print help info
local function PrintInfo()
	print(wt.Color(strings.chat.help.thanks:gsub("#ADDON", wt.Color(addonTitle, colors.green[0])), colors.yellow[0]))
	PrintStatus()
	print(wt.Color(strings.chat.help.hint:gsub("#HELP_COMMAND", wt.Color(strings.chat.keyword .. " " .. strings.chat.help.command, colors.green[1])), colors.yellow[1]))
	print(wt.Color(strings.chat.help.move:gsub("#SHIFT", wt.Color(strings.keys.shift, colors.green[1])):gsub("#ADDON", addonTitle), colors.yellow[1]))
end
--Print the command list with basic functionality info
local function PrintCommands()
	print(wt.Color(addonTitle .. " ", colors.green[0]) .. wt.Color(strings.chat.help.list .. ":", colors.yellow[0]))
	--Index the commands (skipping the help command) and put replacement code segments in place
	local commands = {
		[0] = {
			command = strings.chat.options.command,
			description = strings.chat.options.description:gsub("#ADDON", addonTitle)
		},
		[1] = {
			command = strings.chat.save.command,
			description = strings.chat.save.description
		},
		[2] = {
			command = strings.chat.preset.command,
			description = strings.chat.preset.description:gsub(
				"#INDEX", wt.Color(strings.chat.preset.command .. " " .. 0, colors.green[1])
			)
		},
		[3] = {
			command = strings.chat.toggle.command,
			description = strings.chat.toggle.description:gsub(
				"#HIDDEN", wt.Color(dbc.hidden and strings.chat.toggle.hidden or strings.chat.toggle.notHidden, colors.green[1])
			)
		},
		[4] = {
			command = strings.chat.auto.command,
			description = strings.chat.auto.description:gsub(
				"#STATE", wt.Color(db.speedDisplay.visibility.autoHide and strings.misc.enabled or strings.misc.disabled, colors.green[1])
			)
		},
		[5] = {
			command = strings.chat.size.command,
			description =  strings.chat.size.description:gsub(
				"#SIZE", wt.Color(strings.chat.size.command .. " " .. dbDefault.speedDisplay.text.font.size, colors.green[1])
			)
		},
	}
	--Print the listŁ
	for i = 0, #commands do
		print("    " .. wt.Color(strings.chat.keyword .. " " .. commands[i].command, colors.green[1])  .. wt.Color(" - " .. commands[i].description, colors.yellow[1]))
	end
end

--[ Slash Command Handlers ]

local function SaveCommand()
	--Update the Custom preset
	presets[0].data.position.point, _, _, presets[0].data.position.offset.x, presets[0].data.position.offset.y = moveSpeed:GetPoint()
	presets[0].data.visibility.frameStrata = options.visibility.raise:GetChecked() and "HIGH" or "MEDIUM"
	--Save the Custom preset
	db.customPreset = presets[0].data
	--Update in the SavedVariabes DB
	MovementSpeedDB.customPreset = wt.Clone(db.customPreset)
	--Response
	print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(strings.chat.save.response, colors.yellow[1]))
end
local function PresetCommand(parameter)
	local i = tonumber(parameter)
	if i ~= nil and i >= 0 and i <= #presets then
		--Update the speed display
		moveSpeed:Show()
		moveSpeed:SetFrameStrata(presets[i].data.visibility.frameStrata)
		wt.PositionFrame(moveSpeed, presets[i].data.position.point, nil, nil, presets[i].data.position.offset.x, presets[i].data.position.offset.y)
		--Update the GUI options in case the window was open
		options.visibility.hidden:SetChecked(false)
		options.visibility.hidden:SetAttribute("loaded", true) --Update dependent widgets
		options.position.anchor.setSelected(GetAnchorID(presets[i].data.position.point))
		options.position.xOffset:SetValue(presets[i].data.position.offset.x)
		options.position.yOffset:SetValue(presets[i].data.position.offset.y)
		options.visibility.raise:SetChecked(presets[i].data.visibility.frameStrata == "HIGH")
		--Update the DBs
		dbc.hidden = false
		db.speedDisplay.position = presets[i].data.position
		db.speedDisplay.visibility.frameStrata = presets[i].data.visibility.frameStrata
		--Update in the SavedVariabes DB
		MovementSpeedDBC.hidden = false
		MovementSpeedDB.speedDisplay.position = wt.Clone(db.speedDisplay.position)
		MovementSpeedDB.speedDisplay.visibility.frameStrata = db.speedDisplay.visibility.frameStrata
		--Response
		print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(strings.chat.preset.response:gsub(
			"#PRESET", wt.Color(presets[i].name, colors.green[1])
		), colors.yellow[1]))
	else
		--Error
		print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(strings.chat.preset.unchanged, colors.yellow[0]))
		print(wt.Color(strings.chat.preset.error:gsub("#INDEX", wt.Color(strings.chat.preset.command .. " " .. 0, colors.green[1])), colors.yellow[1]))
		print(wt.Color(strings.chat.preset.list, colors.green[1]))
		for j = 0, #presets, 2 do
			local list = "    " .. wt.Color(j, colors.green[1]) .. wt.Color(" - " .. presets[j].name, colors.yellow[1])
			if j + 1 <= #presets then list = list .. "    " .. wt.Color(j + 1, colors.green[1]) .. wt.Color(" - " .. presets[j + 1].name, colors.yellow[1]) end
			print(list)
		end
	end
end
local function ToggleCommand()
	dbc.hidden = not dbc.hidden
	wt.SetVisibility(moveSpeed, not dbc.hidden)
	--Update the GUI option in case it was open
	options.visibility.hidden:SetChecked(dbc.hidden)
	options.visibility.hidden:SetAttribute("loaded", true) --Update dependent widgets
	--Response
	print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(dbc.hidden and strings.chat.toggle.hiding or strings.chat.toggle.unhiding, colors.yellow[1]))
	--Update in the SavedVariabes DB
	MovementSpeedDBC.hidden = dbc.hidden
end
local function AutoCommand()
	db.speedDisplay.visibility.autoHide = not db.speedDisplay.visibility.autoHide
	--Update the GUI option in case it was open
	options.visibility.autoHide:SetChecked(db.speedDisplay.visibility.autoHide)
	options.visibility.autoHide:SetAttribute("loaded", true) --Update dependent widgets
	--Response
	print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(strings.chat.auto.response:gsub(
		"#STATE", wt.Color(db.speedDisplay.visibility.autoHide and strings.misc.enabled or strings.misc.disabled, colors.green[1])
	), colors.yellow[1]))
	--Update in the SavedVariabes DB
	MovementSpeedDB.speedDisplay.visibility.autoHide = db.speedDisplay.visibility.autoHide
end
local function SizeCommand(parameter)
	local size = tonumber(parameter)
	if size ~= nil then
		db.speedDisplay.text.font.size = size
		speedDisplayText:SetFont(db.speedDisplay.text.font.family, db.speedDisplay.text.font.size, "THINOUTLINE")
		SetDisplaySize()
		--Update the GUI option in case it was open
		options.text.font.size:SetValue(size)
		--Response
		print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(strings.chat.size.response:gsub("#VALUE", wt.Color(size, colors.green[1])), colors.yellow[1]))
	else
		--Error
		print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(strings.chat.size.unchanged, colors.yellow[0]))
		print(wt.Color(strings.chat.size.error:gsub(
			"#SIZE", wt.Color(strings.chat.size.command .. " " .. dbDefault.speedDisplay.text.font.size, colors.green[1])
		), colors.yellow[1]))
	end
	--Update in the SavedVariabes DB
	MovementSpeedDB.speedDisplay.text.font.size = db.speedDisplay.text.font.size
end

SLASH_MOVESPEED1 = strings.chat.keyword
function SlashCmdList.MOVESPEED(line)
	local command, parameter = strsplit(" ", line)
	if command == strings.chat.help.command then
		PrintCommands()
	elseif command == strings.chat.options.command then
		InterfaceOptionsFrame_OpenToCategory(options.mainOptionsPage)
		InterfaceOptionsFrame_OpenToCategory(options.mainOptionsPage) --Load twice to make sure the proper page and category is loaded
	elseif command == strings.chat.save.command then
		SaveCommand()
	elseif command == strings.chat.preset.command then
		PresetCommand(parameter)
	elseif command == strings.chat.toggle.command then
		ToggleCommand()
	elseif command == strings.chat.auto.command then
		AutoCommand()
	elseif command == strings.chat.size.command then
		SizeCommand(parameter)
	else
		PrintInfo()
	end
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
		if speedDisplay:IsMouseOver() and speedDisplayTooltip:IsVisible() then
			wt.AddTooltip(speedDisplayTooltip, speedDisplay, "ANCHOR_BOTTOMRIGHT", strings.speedTooltip.title, GetSpeedTooltipDetails(), 0, speedDisplay:GetHeight())
		end
		--Update the speed display text
		local text = ""
		if db.speedDisplay.text.valueType == 0 then
			text = wt.FormatThousands(speed / 7 * 100, db.speedDisplay.text.decimals, true, not db.speedDisplay.text.noTrim) .. "%"
		elseif db.speedDisplay.text.valueType == 1 then
			text = strings.yps:gsub(
				"#YARDS", wt.FormatThousands(speed, db.speedDisplay.text.decimals, true, not db.speedDisplay.text.noTrim)
			)
		elseif db.speedDisplay.text.valueType == 2 then
			text = wt.FormatThousands(speed / 7 * 100, db.speedDisplay.text.decimals, true, not db.speedDisplay.text.noTrim) .. "%" .. " ("
			text = text .. strings.yps:gsub(
				"#YARDS", wt.FormatThousands(speed, db.speedDisplay.text.decimals, true, not db.speedDisplay.text.noTrim)
			) .. ")"
		end
		speedDisplayText:SetText(text)
	end)
end


--[[ MOUSEOVER TARGET SPEED ]]

GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip)
	if not db.targetSpeed.tooltip.enabled then return end
	--Start mouseover target speed updates
	targetSpeed:SetScript("OnUpdate", function()
		if UnitName("mouseover") == nil then return end
		--Find the speed line
		local lineAdded = false
		for i = 2, tooltip:NumLines() do
			local line = _G["GameTooltipTextLeft" .. i]
			if string.match(line:GetText() or "", "|T" .. textures.logo .. ":0|t") then
				--Update the speed line
				line:SetText(GetTargetSpeedText())
				lineAdded = true
				break
			end
		end
		--Add the speed line if the target is moving
		if not lineAdded and GetUnitSpeed("mouseover") ~= 0 then
			tooltip:AddLine(GetTargetSpeedText(), colors.yellow[1].r, colors.yellow[1].g, colors.yellow[1].b, true)
			tooltip:Show() --Force the tooltip to be resized
		end
	end)
end)

GameTooltip:HookScript("OnTooltipCleared", function()
	--Stop mouseover target speed updates
	targetSpeed:SetScript("OnUpdate", nil)
end)


--[[ INITIALIZATION ]]

local function CreateContextMenuItems()
	return {
		{
			text = strings.options.name:gsub("#ADDON", addonTitle),
			isTitle = true,
			notCheckable = true,
		},
		{
			text = strings.options.main.name,
			notCheckable = true,
			func = function()
				InterfaceOptionsFrame_OpenToCategory(options.mainOptionsPage)
				InterfaceOptionsFrame_OpenToCategory(options.mainOptionsPage) --Load twice to make sure the proper page and category is loaded
			end,
		},
		{
			text = strings.options.speedDisplay.title,
			notCheckable = true,
			func = function()
				InterfaceOptionsFrame_OpenToCategory(options.speedDisplayOptionsPage)
				InterfaceOptionsFrame_OpenToCategory(options.speedDisplayOptionsPage) --Load twice to make sure the proper page and category is loaded
			end,
		},
		{
			text = strings.options.targetSpeed.title,
			notCheckable = true,
			func = function()
				InterfaceOptionsFrame_OpenToCategory(options.targetSpeedOptionsPage)
				InterfaceOptionsFrame_OpenToCategory(options.targetSpeedOptionsPage) --Load twice to make sure the proper page and category is loaded
			end,
		},
		{
			text = strings.options.advanced.title,
			notCheckable = true,
			func = function()
				InterfaceOptionsFrame_OpenToCategory(options.advancedOptionsPage)
				InterfaceOptionsFrame_OpenToCategory(options.advancedOptionsPage) --Load twice to make sure the proper page and category is loaded
			end,
		},
	}
end

--[ Speed Display Setup ]

--Set frame parameters
local function SetUpSpeedDisplayFrame()
	--Main frame
	moveSpeed:SetToplevel(true)
	moveSpeed:SetSize(33, 10)
	wt.PositionFrame(moveSpeed, db.speedDisplay.position.point, nil, nil, db.speedDisplay.position.offset.x, db.speedDisplay.position.offset.y)
	--Display elements
	speedDisplay:SetPoint("CENTER")
	speedDisplayText:SetPoint("CENTER")
	SetDisplayValues(db, dbc)
	--Context menu
	wt.CreateContextMenu({
		parent = speedDisplay,
		menu = CreateContextMenuItems(),
	})
	--Toggling the speed display tooltip
	speedDisplay:SetScript('OnEnter', function()
		--Show tooltip
		wt.AddTooltip(speedDisplayTooltip, speedDisplay, "ANCHOR_BOTTOMRIGHT", strings.speedTooltip.title, GetSpeedTooltipDetails(), 0, speedDisplay:GetHeight())
	end)
	speedDisplay:SetScript('OnLeave', function()
		--Hide tooltip
		speedDisplayTooltip:Hide()
	end)
end

--Making the frame moveable
moveSpeed:SetMovable(true)
speedDisplay:SetScript("OnMouseDown", function()
	if IsShiftKeyDown() and not moveSpeed.isMoving then
		moveSpeed:StartMoving()
		moveSpeed.isMoving = true
		--Stop moving when SHIFT is released
		speedDisplay:SetScript("OnUpdate", function ()
			if IsShiftKeyDown() then return end
			moveSpeed:StopMovingOrSizing()
			moveSpeed.isMoving = false
			--Reset the position
			wt.PositionFrame(moveSpeed, db.speedDisplay.position.point, nil, nil, db.speedDisplay.position.offset.x, db.speedDisplay.position.offset.y)
			--Chat response
			print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(strings.chat.position.cancel, colors.yellow[0]))
			print(wt.Color(strings.chat.position.error:gsub("#SHIFT", strings.keys.shift), colors.yellow[1]))
			--Stop checking if SHIFT is pressed
			speedDisplay:SetScript("OnUpdate", nil)
		end)
	end
end)
speedDisplay:SetScript("OnMouseUp", function()
	if not moveSpeed.isMoving then return end
	moveSpeed:StopMovingOrSizing()
	moveSpeed.isMoving = false
	--Save the position (for account-wide use)
	db.speedDisplay.position.point, _, _, db.speedDisplay.position.offset.x, db.speedDisplay.position.offset.y = moveSpeed:GetPoint()
	MovementSpeedDB.speedDisplay.position = wt.Clone(db.speedDisplay.position) --Update in the SavedVariabes DB
	--Update the GUI options in case the window was open
	options.position.anchor.setSelected(GetAnchorID(db.speedDisplay.position.point))
	options.position.xOffset:SetValue(db.speedDisplay.position.offset.x)
	options.position.yOffset:SetValue(db.speedDisplay.position.offset.y)
	--Chat response
	print(wt.Color(addonTitle .. ":", colors.green[0]) .. " " .. wt.Color(strings.chat.position.save, colors.yellow[1]))
	--Stop checking if SHIFT is pressed
	speedDisplay:SetScript("OnUpdate", nil)
end)

--[ Loading ]

function moveSpeed:ADDON_LOADED(name)
	if name ~= addonNameSpace then return end
	moveSpeed:UnregisterEvent("ADDON_LOADED")
	--Load & check the DB
	if LoadDBs() then PrintInfo() end
	--Create cross-session character-specific variables
	if cs.compactBackup == nil then cs.compactBackup = true end
	--Load the custom preset
	presets[0].data = db.customPreset
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