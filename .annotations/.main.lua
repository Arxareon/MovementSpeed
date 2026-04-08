--NOTE: Annotations are for development purposes only, providing documentation for use with LUA Language Server. This file does not need to be loaded by the game client.


--[[ REFERENCES ]]

--[ Namespace ]

---Addon namespace table
---@class addonNamespace
---@field name string Addon namespace name


--[[ SAVED VARIABLES ]]

---@class MovementSpeedDB : profileStorage
---@field profiles MovementSpeedProfile[]

---@class MovementSpeedDBC : characterProfileData

---@class MovementSpeedCS : backupboxSettingsData
---@field playerSpeed positionOptionsSettingsData
---@field travelSpeed positionOptionsSettingsData
---@field mainDisplay displayType


--[[ PROFILE DATA ]]

---@class MovementSpeedProfileData
---@field customPreset positionPresetData
---@field playerSpeed displayData
---@field travelSpeed displayData
---@field targetSpeed targetSpeedData

---@class MovementSpeedProfile : profile
---@field data MovementSpeedProfileData

--[ Categories ]

---@class speedValueData
---@field units [boolean, boolean, boolean] Value types to display in order: percentage | yards/s | coords|s
---@field fractionals integer Number of fractional digits to show
---@field zeros boolean Show trailing zeros

---@class speedColorList : textColorData_base
---@field yards colorData
---@field percent colorData
---@field coords colorData

---@class displayFontData : fontOptionsData
---@field colors speedColorList

--| Speed Display

---@class displayData : positionPresetData
---@field visibility displayVisibilityData
---@field update speedUpdateData
---@field value speedValueData
---@field font displayFontData
---@field background displayBackgroundData

---@class speedUpdateData
---@field throttle boolean Slow down speed updates
---@field frequency number Speed update threshold in seconds

---@class displayVisibilityData
---@field hidden boolean The display is disabled
---@field autoHide boolean The display auto-hides when not moving
---@field statusNotice boolean Print a visibility notice in chat on load

---@class displayBackgroundColorData
---@field bg colorData Background texture color
---@field border colorData Border texture color

---@class displayBackgroundData
---@field visible boolean The background is shown
---@field colors displayBackgroundColorData

--| Target Speed

---@class tooltipFontData
---@field colors speedColorList

---@class targetSpeedData
---@field enabled boolean
---@field value speedValueData
---@field font tooltipFontData


--[[ MISC ]]

---@alias displayType
---| "playerSpeed"
---| "travelSpeed"

---@alias speedType
---| displayType
---| "targetSpeed"