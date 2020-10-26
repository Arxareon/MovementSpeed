--Colors
local lg = "|cFF" .. "8FD36E" --light green
local sg = "|cFF" .. "4ED836" --strong green
local ly = "|cFF" .. "FFFB99" --light yellow
local sy = "|cFF" .. "FFDD47" --strong yellow

--Shash keywords and commands
local keyword = "/movespeed"
local resetPosition = "reset"
local defaultPreset = "default"
local savePreset = "save"
local hideDisplay = "hide"
local showDisplay = "show"

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
}

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
		print(sg .. "Movement Speed: " .. ly .. "The text display is hidden.")
	end
end

--Updating the movement speed value value
movSpeed:SetScript("OnUpdate", function(self)
	UpdateSpeed()
end)

--Setting up the frame & text
function SetParameters()
	movSpeed:SetFrameStrata("HIGH")
	movSpeed:SetFrameLevel(0)
	movSpeed:SetSize(32, 10)
	if not movSpeed:IsUserPlaced() then
		movSpeed:ClearAllPoints()
		movSpeed:SetPoint(defaultDB["preset"]["point"], defaultDB["preset"]["offsetX"], defaultDB["preset"]["offsetY"])
		movSpeed:SetUserPlaced(true)
	end
	text:SetPoint("CENTER")
	text:SetFont("Fonts\\FRIZQT__.TTF", 11, "THINOUTLINE")
	text:SetTextColor(1,1,1,1)
	FlipVisibility(db["hidden"])
end

--Recalculate the movement speed value and update the diplayed text
function UpdateSpeed()
	text:SetText(string.format("%d%%", math.floor(GetUnitSpeed("player") / 7 * 100 + .5)))
end

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
SLASH_movSpeed1 = keyword
function SlashCmdList.movSpeed(command)
	if command == "help" then
		PrintCommands()
	elseif command == resetPosition then
		movSpeed:ClearAllPoints()
		movSpeed:SetUserPlaced(false)
		movSpeed:SetPoint(db["preset"]["point"], db["preset"]["offsetX"], db["preset"]["offsetY"])
		movSpeed:SetUserPlaced(true)
		print(sg .. "Movement Speed:" .. ly .. " The location has been set to the preset location.")
	elseif command == savePreset then
		db["preset"]["point"], x, y, db["preset"]["offsetX"], db["preset"]["offsetY"] = movSpeed:GetPoint()
		print(sg .. "Movement Speed:" .. ly .. " The current location was saved as the preset location.")
	elseif command == defaultPreset then
		db["preset"] = defaultDB["preset"]
		print(sg .. "Movement Speed:" .. ly .. " The preset location has been reset to the default location.")
	elseif command == hideDisplay then
		db["hidden"] = true
		text:Hide()
		print(sg .. "Movement Speed: " .. ly .. GetVisibility())
	elseif command == showDisplay then
		db["hidden"] = false
		text:Show()
		print(sg .. "Movement Speed: " .. ly .. GetVisibility())
	else
		PrintHelp()
	end
end

function PrintHelp()
	print(sy .. "Thank you for using " .. sg .. "Movement Speed" .. sy .. "!")
	print(ly .. "Type " .. lg .. keyword .. " help" .. ly .. " to see the full command list.")
	print(ly .. "Hold " .. lg .. "SHIFT" .. ly .. " to drag the Movement Speed display anywhere you like.")
end

function PrintCommands()
	print(sg .. "Movement Speed: " .. ly .. GetVisibility())
	print(sg .. "Movement Speed" .. ly ..  " chat command list:")
	print("    " .. lg .. keyword .. " " .. resetPosition .. ly .. " - set location to the specified preset location")
	print("    " .. lg .. keyword .. " " .. savePreset .. ly .. " - save the current location as the preset location")
	print("    " .. lg .. keyword .. " " .. defaultPreset .. ly .. " - set the preset location to the default location")
	print("    " .. lg .. keyword .. " " .. hideDisplay .. ly .. " - hide the text display")
	print("    " .. lg .. keyword .. " " .. showDisplay .. ly .. " - show the text display")
end

--Set the display visibility (flipped)
function FlipVisibility(visible)
	if visible then
		text:Hide()
	else
		text:Show()
	end
end

--Get display toggle state
function GetVisibility()
	if text:IsShown() then
		return "The text display is visible."
	else
		return "The text display is hidden."
	end
	return ""
end