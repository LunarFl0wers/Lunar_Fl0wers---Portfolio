local CustomNames = {}

CustomNames.Names = {
	[859791892] = { -- Lunar_Fl0wers
		["Mobile Task Forces"] = "Commissioner 'Grace'",
		["default"] = "Dr. Winters"
	}
}

function CustomNames.GetDisplayName(player)
	local userEntry = CustomNames.Names[player.UserId]
	if not userEntry then
		return player.Name
	end

	local teamName = player.Team and player.Team.Name or ""

	-- Check for a team-specific name first
	if userEntry[teamName] then
		return userEntry[teamName]
	elseif userEntry["default"] then
		return userEntry["default"]
	else
		return player.Name
	end
end

return CustomNames