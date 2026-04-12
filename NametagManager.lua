local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- required stuff
local DivisionData = require(ReplicatedStorage.Information.DivisionInfo)
local teamPrefixes = require(ReplicatedStorage.Information.TeamInfo)
local CustomNames = require(ReplicatedStorage.Information.UsernameInfo)
local GroupInfo = require(ReplicatedStorage.Information.GroupInfo)

-- divisions
local function getPlayerDivision(player)
	return DivisionData.GetPlayerDivision(player)
end

-- nametag template
local nametagTemplate = ServerStorage:FindFirstChild("Nametag")
if not nametagTemplate then
	warn("Nametag template not found in ServerStorage")
	return
end

-- math for color thing
local function lightenColor(color, factor)
	local r = math.clamp(color.R + (1 - color.R) * factor, 0, 1)
	local g = math.clamp(color.G + (1 - color.G) * factor, 0, 1)
	local b = math.clamp(color.B + (1 - color.B) * factor, 0, 1)
	return Color3.new(r, g, b)
end

-- more color stuff
local function color3ToHex(color)
	return string.format("#%02X%02X%02X", math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255))
end

-- blah blah blah
local function setPrefixRankLabel(textLabel, prefix, prefixColor, rank, rankColor)
	textLabel.Text = string.format("<font color='%s'>%s</font> <font color='%s'>%s</font>", prefixColor, prefix, rankColor, rank)
	textLabel.TextColor3 = Color3.new(1, 1, 1) -- Set to white for rich text to work properly
end

-- CD numbers
local function CDNumberGenerator(player)
	local randomNumber = math.random(10000, 99999)
	return randomNumber
end

-- New random number storage
local playerNumbers = {}
Players.PlayerAdded:Connect(function(player)
	local randomNumber = CDNumberGenerator(player)
	playerNumbers[player] = randomNumber
end)

-- worst part of this script 
local function applyNametagToCharacter(character)
	local player = Players:GetPlayerFromCharacter(character)
	local head = character:FindFirstChild("Head")

	-- Create nametag if it doesn't exist
	local nametag = head:FindFirstChild("Nametag")
	if not nametag then
		local nametagClone = nametagTemplate:Clone()
		nametagClone.Adornee = head
		nametagClone.Parent = head
		nametag = nametagClone
	end
	
	local teamName = player.Team.Name
	
	-- Usernames, Lore names, blah blah blah
	local usernameLabel = nametag:FindFirstChild("UsernameLabel")
	if usernameLabel then
		local teamName = player.Team and player.Team.Name or ""
		if player.Team ~= game.Teams["Class-D"] then
			usernameLabel.Text = CustomNames.GetDisplayName(player)
		else
			usernameLabel.Text = player.Name
		end
	end

	-- Team and rank display
	local teamName = player.Team.Name
	local teamColor = player.TeamColor.Color
	local textLabel = nametag:FindFirstChild("TeamLabel")
	local extraLabel = nametag:FindFirstChild("ExtraLabel")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	
	if textLabel then

		-- default, just team name + team color
		textLabel.Text = teamName
		textLabel.TextColor3 = teamColor

		if player.Team == game.Teams["Class-D"] then
			textLabel.Text = "D-" .. playerNumbers[player]
			textLabel.TextColor3 = teamColor
		end

		if player:GetAttribute("Anomaly") and player.Team == game.Teams["Anomaly Actors"] then
				extraLabel.Text = player:GetAttribute("Anomaly", string)
			end
		end

		-- Group overrides with rich text and prefixes
		-- --// SECURITY CORPS \\--
		if player.Team == game.Teams["Security Corps"] then
			-- divs
			local selectedDivision = getPlayerDivision(player)
			if selectedDivision and selectedDivision ~= "None" then
				if selectedDivision == "SVSD" and player:isInGroupAsync(GroupInfo.SVSD) then
					setPrefixRankLabel(textLabel, "SVSD", "#ab1a39", player:GetRoleInGroupAsync(GroupInfo.SVSD), "#E9C1C7")
				elseif selectedDivision == "CIU" and player:isInGroupAsync(GroupInfo.CIU) then
					setPrefixRankLabel(textLabel, "CIU", "#173c82", player:GetRoleInGroupAsync(GroupInfo.CIU), "#C5CEE0")
				elseif selectedDivision == "OSS" and player:isInGroupAsync(GroupInfo.OSS) then
					setPrefixRankLabel(textLabel, "OSS", "#6262b8", player:GetRoleInGroupAsync(GroupInfo.OSS), "#D8D8ED")
				elseif selectedDivision == "MP" and player:isInGroupAsync(GroupInfo.MP) then
					setPrefixRankLabel(textLabel, "MP", "#A81414", player:GetRoleInGroupAsync(GroupInfo.MP), "#E9C1C1")
				end
			else
				-- Default
				if player:isInGroupAsync(GroupInfo.SC) then
					local prefix = teamPrefixes["Security Corps"]
					local rank = player:GetRoleInGroupAsync(GroupInfo.SC)
					setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
				end

			end
		elseif player.Team == game.Teams["Manufacturing Department"] then
			if player:isInGroupAsync(GroupInfo.MAD) then
				local prefix = teamPrefixes["Lore Department"]
				local rank = player:GetRoleInGroupAsync(GroupInfo.MAD)
				setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
			end
			-- Department ranks
		elseif player.Team == game.Teams["Anomaly Actors"] then
			if player:isInGroupAsync(GroupInfo.AA) then
				local prefix = teamPrefixes["Anomaly Actors"]
				local rank = player:GetRoleInGroupAsync(GroupInfo.AA)
				setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
			end
		elseif player.Team == game.Teams["Lore Department"] then
			if player:isInGroupAsync(GroupInfo.LD) then
				local prefix = teamPrefixes["Lore Department"]
				local rank = player:GetRoleInGroupAsync(GroupInfo.LD)
				setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
			end
		elseif player.Team == game.Teams["Administrative Department"] then
			if player:isInGroupAsync(GroupInfo.AD) then
				local prefix = teamPrefixes["Administrative Department"]
				local rank = player:GetRoleInGroupAsync(GroupInfo.AD)
				setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
			end
		elseif player.Team == game.Teams["Department of External Affairs"] then
			if player:isInGroupAsync(GroupInfo.DEA) then
				local prefix = teamPrefixes["Department of External Affairs"]
				local rank = player:GetRoleInGroupAsync(GroupInfo.DEA)
				setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
			end
		elseif player.Team == game.Teams["Ethics Committee"] then
			if player:isInGroupAsync(GroupInfo.EC) then
				local prefix = teamPrefixes["Ethics Committee"]
				local rank = player:GetRoleInGroupAsync(GroupInfo.EC)
				setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
			end
		elseif player.Team == game.Teams["Foundation Personnel"] then
			-- divs
			local selectedDivision = getPlayerDivision(player)
			if selectedDivision and selectedDivision ~= "None" then
				if selectedDivision == "SV" and player:isInGroupAsync(GroupInfo.SV) then
					setPrefixRankLabel(textLabel, "SV", "#ab1a39", player:GetRoleInGroupAsync(GroupInfo.SV), "#E9C1C7")
				end
			else
				-- Default
				if player:isInGroupAsync(GroupInfo.SCPF) then
					local rank = player:GetRoleInGroupAsync(GroupInfo.SCPF)
				end

			end
		elseif player.Team == game.Teams["Medicinal Department"] then
			if player:isInGroupAsync(GroupInfo.MD) then
				local prefix = teamPrefixes["Medicinal Department"]
				local rank = player:GetRoleInGroupAsync(GroupInfo.MD)
				setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
			end
		elseif player.Team == game.Teams["Scientific Department"] then
			-- divs
			local selectedDivision = getPlayerDivision(player)
			if selectedDivision and selectedDivision ~= "None" then
				if selectedDivision == "SCDSPEC" and player:isInGroupAsync(GroupInfo.SCDSPEC) then
					setPrefixRankLabel(textLabel, "ScD", "#5A5472", player:GetRoleInGroupAsync(GroupInfo.SCDSPEC), "#D6D4E2")
				elseif selectedDivision == "ScD" and player:isInGroupAsync(GroupInfo.SCD) then
					setPrefixRankLabel(textLabel, "ScD", color3ToHex(teamColor), player:GetRoleInGroupAsync(GroupInfo.SCD), color3ToHex(lightenColor(teamColor, 0.75)))
				end
			else
				-- Default
				if player:isInGroupAsync(GroupInfo.SCD) then
					local prefix = teamPrefixes["Scientific Department"]
					local rank = player:GetRoleInGroupAsync(GroupInfo.SCD)
					setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
				end

			end
		elseif player.Team == game.Teams["Engineering and Technical Services"] then
			if player:isInGroupAsync(GroupInfo.ETS) then
				local prefix = teamPrefixes["Engineering and Technical Services"]
				local rank = player:GetRoleInGroupAsync(GroupInfo.ETS)
				setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
			end
			-- --// MOBILE TASK FORCES INITIATIVE \\--
		elseif player.Team == game.Teams["Mobile Task Forces"] then
			-- divs
			local selectedDivision = getPlayerDivision(player)
			if selectedDivision and selectedDivision ~= "None" then
				if selectedDivision == "T-1" and player:isInGroupAsync(GroupInfo.T1) then
					setPrefixRankLabel(textLabel, "T-1", "#4e3d8a", player:GetRoleInGroupAsync(GroupInfo.T1), "#D3CFE2")
				elseif selectedDivision == "A-9" and player:isInGroupAsync(GroupInfo.A9) then
					setPrefixRankLabel(textLabel, "A-9", "#a81f1f", player:GetRoleInGroupAsync(GroupInfo.A9), "#E9C7C7")
				elseif selectedDivision == "E-11" and player:isInGroupAsync(GroupInfo.E11) then
					setPrefixRankLabel(textLabel, "E-11", "#d37033", player:GetRoleInGroupAsync(GroupInfo.E11), "#F4DBCC")
				elseif selectedDivision == "N-7" and player:isInGroupAsync(GroupInfo.N7) then
					setPrefixRankLabel(textLabel, "N-7", "#44506B", player:GetRoleInGroupAsync(GroupInfo.N7), "#D0D3DA")
				elseif selectedDivision == "1st Battalion" and player:isInGroupAsync(GroupInfo.BN1) then
					local rank = player:GetRankInGroupAsync(GroupInfo.BN1)
					local prefix, prefixColor, rankColor
					
					if rank >= 1 and rank <= 9 then
						-- Enlistment & Instruction Command (EIC)
						prefix = "EIC"
						prefixColor = "#8845A0"
						rankColor = "#E1D1E7"
					elseif rank >= 10 and rank <= 19 then
						-- Diplomatic Affairs Office (DAO)
						prefix = "DAO"
						prefixColor = "#55A9E9"
						rankColor = "#D5EAFA"
					elseif rank >= 20 and rank <= 29 then
						-- Internal Standards Commission (ISC)
						prefix = "ISC"
						prefixColor = "#B6335A"
						rankColor = "#EDCCD6"
					else
						-- Default (Init. Director+)
						prefix = "1BN"
						prefixColor = "#ffc03d"
						rankColor = "#FFEFCE"
					end
					
					setPrefixRankLabel(textLabel, prefix, prefixColor, player:GetRoleInGroupAsync(GroupInfo.BN1), rankColor)
				else
					-- Fallback to default MTF if division not available
					if player:isInGroupAsync(GroupInfo.MTFI) then
						local prefix = teamPrefixes["Mobile Task Forces"]
						local rank = player:GetRoleInGroupAsync(GroupInfo.MTFI)
						setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
					end
				end
			else
				-- Default
				if player:isInGroupAsync(GroupInfo.MTFI) then
					local prefix = teamPrefixes["Mobile Task Forces"]
					local rank = player:GetRoleInGroupAsync(GroupInfo.MTFI)
					setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.75)))
				end

			end
		elseif player.Team == game.Teams["Chaos Insurgency"] then
			if player:isInGroupAsync(GroupInfo.CI) then
				local prefix = teamPrefixes["Chaos Insurgency"]
				local rank = player:GetRoleInGroupAsync(GroupInfo.CI)
				setPrefixRankLabel(textLabel, prefix, color3ToHex(teamColor), rank, color3ToHex(lightenColor(teamColor, 0.25)))
			end
		end
	end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(applyNametagToCharacter)
	player:GetPropertyChangedSignal("Team"):Connect(function()
		if player.Character then
			applyNametagToCharacter(player.Character)
		end
	end)
	if player.Character then
		applyNametagToCharacter(player.Character)
	end
end

-- Connect to existing players
for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end

-- Connect to new players
Players.PlayerAdded:Connect(onPlayerAdded)