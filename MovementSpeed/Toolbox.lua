--[[ REFERENCES ]]

--[ Namespace ]

--| Hook into the local addon namespace

---@class addonNamespace
local namespace = select(2, ...)

--Addon namespace name
local addon = ...


--[[ TOOLBOX REGISTRATION ]]

--Widget Toolbox version number
local version = C_AddOns.GetAddOnMetadata(addon, "X-WidgetTools-ToolboxVersion")

if not version then return end

--Add the toolbox reference to local addon namespace
local function AddToNamespace(toolbox)
	local key = C_AddOns.GetAddOnMetadata(addon, "X-WidgetTools-AddToNamespace")

	if not key then return end

	---@type widgetToolbox
	namespace[key] = toolbox

	WidgetTools.debugging.Log("Toolbox version " .. WidgetTools.utilities.ToString(version) .. " has been added to the " .. WrapTextInColor(addon, LIGHTBLUE_FONT_COLOR) .. " namespace table under the " .. WidgetTools.utilities.ToString(key) .. " key.", "Widget Toolbox loaded")
end

---@type widgetToolbox
local toolbox = WidgetTools.toolboxes.Register(addon, version, AddToNamespace)

if toolbox then AddToNamespace(toolbox) end