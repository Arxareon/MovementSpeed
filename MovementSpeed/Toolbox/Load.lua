--[[ NAMESPACE ]]

--| Hook into the local addon namespace

---@class addonNamespace
local namespace = select(2, ...)

--Addon namespace name
local addon = ...

--Add the toolbox reference to local addon namespace
local function AddToNamespace(toolbox)
	local key = C_AddOns.GetAddOnMetadata(addon, "X-WidgetTools-AddToNamespace")

	if not key then return end

	---@type widgetToolbox
	namespace[key] = toolbox
end


--[[ TOOLBOX ]]

--Widget Toolbox version number
local version = C_AddOns.GetAddOnMetadata(addon, "X-WidgetTools-ToolboxVersion")

---Read-only reference to the Widget Toolbox table
---@type widgetToolbox
local toolbox = WidgetTools.toolboxes.Register(addon, version) or WidgetTools.toolboxes.Initialize(addon, version, AddToNamespace)

if toolbox then AddToNamespace(toolbox) end