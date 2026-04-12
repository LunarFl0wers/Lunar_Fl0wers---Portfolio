-- animations

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAppearanceLoaded:Connect(function(character)
		character.Animate:Destroy()
		game.ReplicatedStorage.Scripts.Animate:Clone().Parent = character
	end)
end)

-- base speed set + anticheat funny

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAppearanceLoaded:Connect(function(character)
		local humanoid = character:FindFirstChild("Humanoid")
		humanoid.WalkSpeed = 16
		if 
			humanoid.WalkSpeed >= 50
		then
			player:Kick("Flagged anti-cheat.")
		end
	end)
end)
