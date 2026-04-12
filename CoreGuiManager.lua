
-- variables/required stuff

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Groups = require(ReplicatedStorage.Information.Groups)
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local sgui = game:GetService("StarterGui")
local cs = game:GetService("TextChatService")
local uis = game:GetService("UserInputService")

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
		plr:IsInGroup(Groups.SCPF) and plr:GetRankInGroupAsync(Groups.SCPF) >= 250
		or plr:IsInGroup(Groups.MAD) and plr:GetRankInGroupAsync(Groups.MAD) >= 50 and plr.Team == game.Teams["Manufacturing Department"]
		or plr:IsInGroup(Groups.MOD) and plr:GetRankInGroupAsync(Groups.MOD) >= 50
		or (plr.Team == game.Teams["Anomaly Actors"])
		or (plr.Team == game.Teams["Lore Department"])

	local teamName = plr.Team

	-- playerlist checks
	sgui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, auth and not Blacklist[teamName])

	if ccopen and (not auth or Blacklist[teamName]) then
		cs.ChatWindowConfiguration.Enabled = false
		ccopen = false
	end
end

-- initial check
updateAuth()

-- Update on team change
plr:GetPropertyChangedSignal("Team"):Connect(updateAuth)

-- toggle chatbox
uis.InputEnded:Connect(function(input)
	if input.KeyCode ~= Enum.KeyCode.LeftBracket then
		return
	end

	local teamName = plr.Team and plr.Team.Name or ""

	if not auth then return end
	if Blacklist[teamName] then return end

	ccopen = not ccopen
	cs.ChatWindowConfiguration.Enabled = ccopen
end)
