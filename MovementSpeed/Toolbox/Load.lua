--[[ NAMESPACE ]]

---@class WidgetToolsNamespace
local ns = select(2, ...)


--[[ TOOLBOX ]]

ns.WidgetToolboxVersion = "2.1"

--| Check for the toolbox

ns.WidgetToolbox = WidgetTools.RegisterToolbox(ns.name, ns.WidgetToolboxVersion)

if ns.WidgetToolbox then do return end end

--| Create a new toolbox

ns.WidgetToolbox = {}

ns.WidgetToolboxInitialization = true

WidgetTools.frame:RegisterEvent("ADDON_LOADED")

function WidgetTools.frame:ADDON_LOADED(addon)
	if addon ~= ns.name then return end

	WidgetTools.frame:UnregisterEvent("ADDON_LOADED")

	ns.WidgetToolbox = WidgetTools.RegisterToolbox(ns.name, ns.WidgetToolboxVersion, ns.WidgetToolbox)
end