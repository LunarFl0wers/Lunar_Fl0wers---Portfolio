local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.NameDisplayDistance = 0
	player.HealthDisplayDistance = 0
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.MaxHealth = 200
			humanoid.Health = 200
		end
	end)
end)