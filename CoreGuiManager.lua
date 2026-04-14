
-- variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GroupInfo = require(ReplicatedStorage.Information.GroupInfo)
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local StarterGUI = game:GetService("StarterGui")
local ChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")

local Blacklist = {
	["Security Corps"] = true,
	["Chaos Insurgency"] = true,
	["IJAMEA"] = true,
	["Mobile Task Forces"] = true,
	["Class-D"] = true,
	["Pending"] = true
}

local ccopen = false
local auth = false

-- checks

local function updateAuth()
	auth =
		player:IsInGroup(GroupInfo.SCPF) and player:GetRankInGroupAsync(GroupInfo.SCPF) >= 250
		or player:IsInGroup(GroupInfo.MAD) and player:GetRankInGroupAsync(GroupInfo.MAD) >= 50 and player.Team == game.Teams["Manufacturing Department"]
		or player:IsInGroup(GroupInfo.MOD) and player:GetRankInGroupAsync(GroupInfo.MOD) >= 50
		or (player.Team == game.Teams["Anomaly Actors"])
		or (player.Team == game.Teams["Lore Department"])

	local teamName = player.Team

	-- PlayerList now also respects blacklist
	StarterGUI:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, auth and not Blacklist[teamName])

	if ccopen and (not auth or Blacklist[teamName]) then
		ChatService.ChatWindowConfiguration.Enabled = false
		ccopen = false
	end
end

-- initial auth
updateAuth()

-- update on team change
player:GetPropertyChangedSignal("Team"):Connect(updateAuth)

-- toggle chatbox

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode ~= Enum.KeyCode.LeftBracket then
		return
	end

	local teamName = player.Team and player.Team.Name or ""

	if not auth then return end
	if Blacklist[teamName] then return end

	ccopen = not ccopen
	ChatService.ChatWindowConfiguration.Enabled = ccopen
end)
