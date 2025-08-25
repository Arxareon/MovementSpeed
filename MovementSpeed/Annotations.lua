--[[ MISC ]]

---@alias displayType
---| "playerSpeed"
---| "travelSpeed"

---@alias speedType
---| displayType
---| "targetSpeed"


--[[ PROFILE DATA ]]

--[ Types ]

---@class speedValueData
---@field units [boolean, boolean, boolean] Value types to display in order: percentage | yards/s | coords|s
---@field fractionals integer Number of fractional digits to show
---@field zeros boolean Show trailing zeros

---@class speedUpdateData
---@field throttle boolean Whether to slow speed updates down
---@field frequency number Speed update threshold in seconds

---@class displayVisibilityData
---@field hidden boolean Whether the display is disabled
---@field autoHide boolean Whether the display auto-hides when not moving
---@field statusNotice boolean Whether to print a visibility notice in chat on load

---@class displayFontData
---@field family string Path to font to use
---@field size integer Font size in pixels
---@field valueColoring boolean Whether to auto-color speed text by speed value types ignoring font color set
---@field color colorData Base text color (overwritten by value coloring if enabled)
---@field alignment JustifyHorizontal Horizontal text alignment

---@class displayBackgroundColors
---@field bg colorData Background texture color
---@field border colorData Border texture color

---@class displayBackgroundData
---@field visible boolean Whether the background is shown
---@field colors displayBackgroundColors

--[ Categories ]

---@class displayData : positionPresetData
---@field visibility displayVisibilityData
---@field update speedUpdateData
---@field value speedValueData
---@field font displayFontData
---@field background displayBackgroundData

---@class targetSpeedData
---@field enabled boolean
---@field value speedValueData

--[ Profile ]

---@class MovementSpeedProfileData
---@field customPreset positionPresetData
---@field playerSpeed displayData
---@field travelSpeed displayData
---@field targetSpeed targetSpeedData

---@class MovementSpeedProfile : profile
---@field data MovementSpeedProfileData

---@class MovementSpeedProfileStorage : profileStorage
---@field profiles MovementSpeedProfile[]


--[[ SAVED VARIABLES ]]

---@class MovementSpeedDB
---@field profiles MovementSpeedProfile[]

---@class MovementSpeedDBC : characterProfileData

---@class MovementSpeedCS : dataManagementSettingsData
---@field playerSpeed positionOptionsSettingsData
---@field travelSpeed positionOptionsSettingsData
---@field mainDisplay displayType