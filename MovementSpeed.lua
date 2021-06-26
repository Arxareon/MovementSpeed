--Colors
local colors= {
	["lg"] = "|cFF" .. "8FD36E", --light green
	["sg"] = "|cFF" .. "4ED836", --strong green
	["ly"] = "|cFF" .. "FFFB99", --light yellow
	["sy"] = "|cFF" .. "FFDD47", --strong yellow
}

--Slash keywords and commands
local keyword = "/movespeed"
local helpCommand = { ["name"] = "help", ["description"] = "see the full command list", }
local commands = {
	["resetPosition"] = { ["name"] = "reset", ["description"] = "set location to the specified preset location" },
	["savePreset"] = { ["name"] = "save", ["description"] = "save the current location as the preset location" },
	["defaultPreset"] = { ["name"] = "default", ["description"] = "set the preset location to the default location" },
	["hideDisplay"] = { ["name"] = "hide", ["description"] = "hide the text display" },
	["showDisplay"] = { ["name"] = "show", ["description"] = "show the text display" },
	["fontSize"] = { ["name"] = "size", ["description"] = "change the font size to the specified number: " .. colors["lg"] .. " size 11" },
}

--Creating the frame & text
local movSpeed = CreateFrame("Frame", "MovementSpeed", UIParent)
local text = movSpeed:CreateFontString("text", "HIGH")

--Registering events
movSpeed:RegisterEvent("ADDON_LOADED")
movSpeed:RegisterEvent("PLAYER_LOGIN")
movSpeed:SetScript("OnEvent", function(self, event, ...) --Event handler
	return self[event] and self[event](self, ...)
end)

--DB table & defaults
local db
local defaultDB = {
	["preset"] = {
		["point"] = "TOPRIGHT",
		["offsetX"] = -68,
		["offsetY"] = -179
	},
	["hidden"] = false,
	["fontSize"] = 11,
}

--Display visibility utilities
local function GetVisibility()
	if text:IsShown() then
		return "The text display is visible."
	else
		return "The text display is hidden."
	end
	return ""
end

local function FlipVisibility(visible)
	if visible then
		text:Hide()
	else
		text:Show()
	end
end

--Chat control utilities
local function PrintHelp()
	print(colors["sy"] .. "Thank you for using " .. colors["sg"] .. "Movement Speed" .. colors["sy"] .. "!")
	print(colors["ly"] .. "Type " .. colors["lg"] .. keyword .. " " .. helpCommand["name"] .. colors["ly"] .. " to " .. helpCommand["description"])
	print(colors["ly"] .. "Hold " .. colors["lg"] .. "SHIFT" .. colors["ly"] .. " to drag the Movement Speed display anywhere you like.")
end

local function PrintCommands()
	print(colors["sg"] .. "Movement Speed: " .. colors["ly"] .. GetVisibility())
	print(colors["sg"] .. "Movement Speed" .. colors["ly"] ..  " chat command list:")
	for k,v in pairs(commands) do
		print("    " .. colors["lg"] .. keyword .. " " .. v["name"] .. colors["ly"] .. " - " .. v["description"])
	end
end

--Setting up the frame & text
local function SetParameters()
	movSpeed:SetFrameStrata("HIGH")
	movSpeed:SetFrameLevel(0)
	movSpeed:SetSize(32, 10)
	if not movSpeed:IsUserPlaced() then
		movSpeed:ClearAllPoints()
		movSpeed:SetPoint(defaultDB["preset"]["point"], defaultDB["preset"]["offsetX"], defaultDB["preset"]["offsetY"])
		movSpeed:SetUserPlaced(true)
	end
	text:SetPoint("CENTER")
	text:SetFont("Fonts\\FRIZQT__.TTF", db["size"], "THINOUTLINE")
	text:SetTextColor(1,1,1,1)
	FlipVisibility(db["hidden"])
end

--Initialization
function movSpeed:ADDON_LOADED(addon)
	if addon == "MovementSpeed" then
		movSpeed:UnregisterEvent("ADDON_LOADED")
		--First load
		if MovementSpeedDB == nil then
			MovementSpeedDB = defaultDB
			PrintHelp()
		end
		--Load the db
		db = MovementSpeedDB
		--Set up the UI
		SetParameters()
	end
end

function movSpeed:PLAYER_LOGIN()
	if not text:IsShown() then
		print(colors["sg"] .. "Movement Speed: " .. colors["ly"] .. "The text display is hidden.")
	end
end

--Recalculate the movement speed value and update the displayed text
local function UpdateSpeed()
	local unit = "player";
	if  UnitInVehicle("player") then
		unit = "vehicle"
	end
	text:SetText(string.format("%d%%", math.floor(GetUnitSpeed(unit) / 7 * 100 + .5)))
end
movSpeed:SetScript("OnUpdate", function(self)
	UpdateSpeed()
end)

--Making the frame moveable
movSpeed:SetMovable(true)
movSpeed:SetScript("OnMouseDown", function(self)
	if (IsShiftKeyDown() and not self.isMoving) then
		movSpeed:StartMoving()
		self.isMoving = true
	end
end)
movSpeed:SetScript("OnMouseUp", function(self)
	if (self.isMoving) then
		movSpeed:StopMovingOrSizing()
		self.isMoving = false
	end
end)

--Set up slash commands
SLASH_MOVESPEED1 = keyword
function SlashCmdList.MOVESPEED(command)
	if command == helpCommand["name"] then
		PrintCommands()
	elseif command == commands["resetPosition"]["name"] then
		movSpeed:ClearAllPoints()
		movSpeed:SetUserPlaced(false)
		movSpeed:SetPoint(db["preset"]["point"], db["preset"]["offsetX"], db["preset"]["offsetY"])
		movSpeed:SetUserPlaced(true)
		print(colors["sg"] .. "Movement Speed:" .. colors["ly"] .. " The location has been set to the preset location.")
	elseif command == commands["savePreset"]["name"] then
		local x; local y; db["preset"]["point"], x, y, db["preset"]["offsetX"], db["preset"]["offsetY"] = movSpeed:GetPoint()
		print(colors["sg"] .. "Movement Speed:" .. colors["ly"] .. " The current location was saved as the preset location.")
	elseif command == commands["defaultPreset"]["name"] then
		db["preset"] = defaultDB["preset"]
		print(colors["sg"] .. "Movement Speed:" .. colors["ly"] .. " The preset location has been reset to the default location.")
	elseif command == commands["hideDisplay"]["name"] then
		db["hidden"] = true
		text:Hide()
		print(colors["sg"] .. "Movement Speed: " .. colors["ly"] .. GetVisibility())
	elseif command == commands["showDisplay"]["name"] then
		db["hidden"] = false
		text:Show()
		print(colors["sg"] .. "Movement Speed: " .. colors["ly"] .. GetVisibility())
	elseif command == commands["fontSize"]["name"] .. ".*" then
		local x, size = strsplit(" ", command)
		db["fontSize"] = tonumber(size) or defaultDB["fontSize"]
	else
		PrintHelp()
	end
end