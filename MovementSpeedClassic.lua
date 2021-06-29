--Colors
local colors= {
	["lg"] = "|cFF" .. "8FD36E", --light green
	["sg"] = "|cFF" .. "4ED836", --strong green
	["ly"] = "|cFF" .. "FFFB99", --light yellow
	["sy"] = "|cFF" .. "FFDD47", --strong yellow
}

--DB table & defaults
local db
local defaultDB = {
	["preset"] = {
		["point"] = "TOPRIGHT",
		["offset"] = { ["x"] = -68, ["y"] = -179 },
	},
	["hidden"] = false,
	["font"] = {
		["family"] = "Fonts\\FRIZQT__.TTF",
		["size"] = 11,
	},
}

--Slash keywords and commands
local keyword = "/movespeed"
local helpCommand = { ["name"] = "help", ["description"] = "see the full command list", }
local commands = {
	["1resetPosition"] = { ["name"] = "reset", ["description"] = "set location to the specified preset location" },
	["2savePreset"] = { ["name"] = "save", ["description"] = "save the current location as the preset location" },
	["3defaultPreset"] = { ["name"] = "default", ["description"] = "set the preset location to the default location" },
	["4hideDisplay"] = { ["name"] = "hide", ["description"] = "hide the text display" },
	["5showDisplay"] = { ["name"] = "show", ["description"] = "show the text display" },
	["6fontSize"] = { ["name"] = "size", ["description"] = "change the font size (e.g. " .. colors["lg"] .. "size " .. defaultDB["font"]["size"] .. colors["ly"] .. ")" },
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
	local temp = {}
	for n in pairs(commands) do table.insert(temp, n) end
    table.sort(temp)
    for i,n in ipairs(temp) do 
		print("    " .. colors["lg"] .. keyword .. " " .. commands[n]["name"] .. colors["ly"] .. " - " .. commands[n]["description"])
	end
end

--Restore old data to the DB
local oldData = {};
local function RestoreOldData()
	for k,v in pairs(oldData) do
		if k == "offsetX" then
			db["preset"]["offset"]["x"] = v
		elseif k == "offsetY" then
			db["preset"]["offset"]["y"] = v
		end
	end
end

--Check for and fill in missing data
local function AddItems(dbToCheck, dbToSample)
	if type(dbToCheck) ~= "table"  and type(dbToSample) ~= "table" then return end
	for k,v in pairs(dbToSample) do
		if dbToCheck[k] == nil then
			dbToCheck[k] = v;
		else
			AddItems(dbToCheck[k], dbToSample[k])
		end
	end
end

--Remove unused or outdated data while trying to keep any old data
local function RemoveItems(dbToCheck, dbToSample)
	if type(dbToCheck) ~= "table"  and type(dbToSample) ~= "table" then return end
	for k,v in pairs(dbToCheck) do
		if dbToSample[k] == nil then
			oldData[k] = v;
			dbToCheck[k] = nil;
		else
			RemoveItems(dbToCheck[k], dbToSample[k])
		end
	end
end

--Setting up the frame & text
local function SetParameters()
	movSpeed:SetFrameStrata("HIGH")
	movSpeed:SetFrameLevel(0)
	movSpeed:SetSize(32, 10)
	if not movSpeed:IsUserPlaced() then
		movSpeed:ClearAllPoints()
		movSpeed:SetPoint(defaultDB["preset"]["point"], defaultDB["preset"]["offset"]["x"], defaultDB["preset"]["offset"]["y"])
		movSpeed:SetUserPlaced(true)
	end
	text:SetPoint("CENTER")
	text:SetFont(db["font"]["family"], db["font"]["size"], "THINOUTLINE")
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
		--Load the DB
		db = MovementSpeedDB
		AddItems(db, defaultDB) --Check for missing data
		RemoveItems(db, defaultDB) --Remove unneeded data
		RestoreOldData() --Save old data
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
	text:SetText(string.format("%d%%", math.floor(GetUnitSpeed("player") / 7 * 100 + .5)))
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
	local name, value = strsplit(" ", command)
	if name == helpCommand["name"] then
		PrintCommands()
	elseif name == commands["1resetPosition"]["name"] then
		movSpeed:ClearAllPoints()
		movSpeed:SetUserPlaced(false)
		movSpeed:SetPoint(db["preset"]["point"], db["preset"]["offset"]["x"], db["preset"]["offset"]["y"])
		movSpeed:SetUserPlaced(true)
		print(colors["sg"] .. "Movement Speed:" .. colors["ly"] .. " The location has been set to the preset location.")
	elseif name == commands["2savePreset"]["name"] then
		local x; local y; db["preset"]["point"], x, y, db["preset"]["offset"]["x"], db["preset"]["offset"]["y"] = movSpeed:GetPoint()
		print(colors["sg"] .. "Movement Speed:" .. colors["ly"] .. " The current location was saved as the preset location.")
	elseif name == commands["3defaultPreset"]["name"] then
		db["preset"] = defaultDB["preset"]
		print(colors["sg"] .. "Movement Speed:" .. colors["ly"] .. " The preset location has been reset to the default location.")
	elseif name == commands["4hideDisplay"]["name"] then
		db["hidden"] = true
		text:Hide()
		print(colors["sg"] .. "Movement Speed: " .. colors["ly"] .. GetVisibility())
	elseif name == commands["5showDisplay"]["name"] then
		db["hidden"] = false
		text:Show()
		print(colors["sg"] .. "Movement Speed: " .. colors["ly"] .. GetVisibility())
	elseif name == commands["6fontSize"]["name"] then
		local size = tonumber(value)
		if size ~= nil then
			db["font"]["size"] = size
			text:SetFont(db["font"]["family"], db["font"]["size"], "THINOUTLINE")
			print(colors["sg"] .. "Movement Speed: " .. colors["ly"] .. "The font size has been set to " .. size .. ".")
		else
			print(colors["sg"] .. "Movement Speed: " .. colors["ly"] .. "The font size was not changed.")
			print(colors["ly"] .. "Please enter a valid number value (e.g. " .. colors["lg"] .. "/movespeed size 11" ..  colors["ly"] .. ").")
		end
	else
		PrintHelp()
	end
end