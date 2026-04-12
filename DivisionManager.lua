local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DivisionData = require(ReplicatedStorage.Information.DivisionInfo)

-- Create RemoteEvent if it doesn't exist
local DivisionRemote = ReplicatedStorage:FindFirstChild("DivisionRemote")
if not DivisionRemote then
    DivisionRemote = Instance.new("RemoteEvent")
    DivisionRemote.Name = "DivisionRemote"
    DivisionRemote.Parent = ReplicatedStorage
end

-- Handle RemoteEvent
DivisionRemote.OnServerEvent:Connect(function(player, action, divisionName)
    if action == "SelectDivision" then
		DivisionData.SetPlayerDivision(player, divisionName)
      
    end
end)