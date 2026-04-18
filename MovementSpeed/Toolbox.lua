--| Metadata

--Local addon namespace name
local addon = ...

local version = C_AddOns.GetAddOnMetadata(addon, "X-WidgetTools-ToolboxVersion")
local namespaceKey = C_AddOns.GetAddOnMetadata(addon, "X-WidgetTools-AddToNamespace")

if not version then return end

--| Registration

local addToNamespace = nil

if namespaceKey then
	--Local addon namespace table
	local ns = select(2, ...)

	--Add the toolbox reference to local addon namespace table
	addToNamespace = function(toolbox)
		ns[namespaceKey] = toolbox

		WidgetTools.debugging.Log(function()
			local ts = WidgetTools.utilities.ToString

			return "Toolbox version " .. ts(version) .. " has been added to the " .. WrapTextInColor(addon, LIGHTBLUE_FONT_COLOR) .. " namespace table under the " .. ts(namespaceKey) .. " key.", "Widget Toolbox loaded"
		end)
	end
end

local toolbox = WidgetTools.toolboxes.Register(addon, version, addToNamespace)

if toolbox and addToNamespace then addToNamespace(toolbox) end