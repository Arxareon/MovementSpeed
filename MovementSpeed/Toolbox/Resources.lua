--[[ REFERENCES ]]

--[ Toolbox ]

---@class widgetToolbox
local wt = WidgetTools.toolboxes.initialization[C_AddOns.GetAddOnMetadata(..., "X-WidgetTools-ToolboxVersion")]

if not wt then return end


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


--[[ MISC ]]

--Classic vs Retail code separation
wt.classic = select(4, GetBuildInfo()) < 100000