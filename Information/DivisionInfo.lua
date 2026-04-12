local playerDivisions = {}
local DivisionData = {}

function DivisionData.SetPlayerDivision(player, division)
    playerDivisions[player] = division
end

function DivisionData.GetPlayerDivision(player)
    return playerDivisions[player]
end

function DivisionData.ClearPlayerDivision(player)
    playerDivisions[player] = nil
end

game:GetService("Players").PlayerRemoving:Connect(function(player)
    playerDivisions[player] = nil
end)

return DivisionData