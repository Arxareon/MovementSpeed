--[[ NAMESPACE ]]

--| Hook into the local addon namespace

---@class addonNamespace
local ns = select(2, ...)

--Addon namespace name
local name = ...


--[[ TOOLBOX ]]

--Widget Toolbox version number
local version = "2.3"

--| Check for the toolbox

ns.WidgetToolbox = WidgetTools.RegisterToolbox(name, version)

if type(ns.WidgetToolbox) == "table" then return end

--| Create a new toolbox

---@class widgetToolbox
ns.WidgetToolbox = { version = version, initialization = true }

WidgetTools.loaderFrame:RegisterEvent("ADDON_LOADED")

function WidgetTools.loaderFrame:ADDON_LOADED(addon)
	if addon ~= name then return end

	WidgetTools.loaderFrame:UnregisterEvent("ADDON_LOADED")

	ns.WidgetToolbox.initialization = false

	ns.WidgetToolbox = WidgetTools.RegisterToolbox(name, ns.WidgetToolbox.version, ns.WidgetToolbox)
end