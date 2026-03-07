--[[ NAMESPACE ]]

---@class WidgetToolsNamespace
local ns = select(2, ...)


--[[ INITIALIZATION ]]

if not ns.WidgetToolboxInitialization then return end

---@class wt
local wt = ns.WidgetToolbox


--[[ STRINGS ]]

--[ Localization ]

---Localized strings
---@class toolboxStrings
wt.strings = wt.localizations[GetLocale()]

--| Fill static & internal references

wt.strings.backup.box.tooltip[3] = wt.strings.backup.box.tooltip[3]:gsub("#LOAD", wt.strings.backup.load.label)
wt.strings.position.keepInPlace.tooltip = wt.strings.position.keepInPlace.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.position.offsetX.tooltip = wt.strings.position.offsetX.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.position.offsetY.tooltip = wt.strings.position.offsetY.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.position.relativePoint.tooltip = wt.strings.position.relativePoint.tooltip:gsub("#ANCHOR", wt.strings.position.anchor.label)
wt.strings.layer.keepOnTop.tooltip = wt.strings.layer.keepOnTop.tooltip:gsub("#STRATA", wt.strings.layer.strata.label)
wt.strings.layer.level.tooltip = wt.strings.layer.level.tooltip:gsub("#STRATA", wt.strings.layer.strata.label)
wt.strings.about.changelog.tooltip = wt.strings.about.changelog.tooltip .. "\n\nThe changelog is only available in English for now."
wt.strings.about.fullChangelog.tooltip = wt.strings.about.fullChangelog.tooltip .. "\n\nThe changelog is only available in English for now."

--| Cleanup

wt.localizations = nil

--[[ ASSETS ]]

--Colors
wt.colors = {
	normal = wt.PackColor(NORMAL_FONT_COLOR:GetRGBA()),
	highlight = wt.PackColor(HIGHLIGHT_FONT_COLOR:GetRGBA()),
	disabled = wt.PackColor(GRAY_FONT_COLOR:GetRGB()),
	warning = wt.PackColor(RED_FONT_COLOR:GetRGB()),
}

--Fonts
wt.fonts = {
	{ name = DEFAULT, path = STANDARD_TEXT_FONT:gsub("\\", "/"), widthRatio = 1 },
	{ name = "Arbutus Slab", path = ns.root .. "Fonts/ArbutusSlab.ttf", widthRatio = 1.07 },
	{ name = "Caesar Dressing", path = ns.root .. "Fonts/CaesarDressing.ttf", widthRatio = 0.84 },
	{ name = "Germania One", path = ns.root .. "Fonts/GermaniaOne.ttf", widthRatio = 0.86 },
	{ name = "Mitr", path = ns.root .. "Fonts/Mitr.ttf", widthRatio = 1.07 },
	{ name = "Oxanium", path = ns.root .. "Fonts/Oxanium.ttf", widthRatio = 0.94 },
	{ name = "Pattaya", path = ns.root .. "Fonts/Pattaya.ttf", widthRatio = 0.87 },
	{ name = "Reem Kufi", path = ns.root .. "Fonts/ReemKufi.ttf", widthRatio = 0.92 },
	{ name = "Source Code Pro", path = ns.root .. "Fonts/SourceCodePro.ttf", widthRatio = 1.11 },
	{ name = CUSTOM, path = ns.root .. "Fonts/CUSTOM.ttf", widthRatio = 1.2 },
}

--Textures
wt.textures = {
	alphaBG = "Interface/AddOns/" .. ns.name .. "/Textures/AlphaBG.tga",
	gradientBG = "Interface/AddOns/" .. ns.name .. "/Textures/GradientBG.tga",
}


--[[ Data ]]

--WidgetTools main database table
WidgetToolsDB = WidgetToolsDB or {}

--Data checkup
wt.RemoveEmpty(WidgetToolsDB)
wt.AddMissing(WidgetToolsDB, ns.defaults)
wt.RemoveMismatch(WidgetToolsDB, ns.defaults)


--[[ MISC ]]

--Classic vs Retail code separation
wt.classic = select(4, GetBuildInfo()) < 100000