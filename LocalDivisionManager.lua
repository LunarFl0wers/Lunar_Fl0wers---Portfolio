local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")

-- Wait for player and GUI
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local divisionUI = playerGui:WaitForChild("DivisionUI")
local scrollingFrame = divisionUI.MainFrame.ScrollingFrame
local template = scrollingFrame:WaitForChild("Template")

-- Create RemoteEvent
local DivisionRemote = ReplicatedStorage:FindFirstChild("DivisionRemote")
if not DivisionRemote then
    DivisionRemote = Instance.new("RemoteEvent")
    DivisionRemote.Name = "DivisionRemote"
    DivisionRemote.Parent = ReplicatedStorage
end

-- Populate division buttons
local function populateButtons()
    
     --Clear ALL existing buttons (including duplicates)
    local buttonsToDestroy = {}
    for _, child in scrollingFrame:GetChildren() do
        if child:IsA("TextButton") and child.Name ~= "Template" then
            table.insert(buttonsToDestroy, child)
        end
    end
    
    -- Destroy them outside the loop
    for _, button in buttonsToDestroy do
        button:Destroy()
    end
    
    local team = player.Team
    if not team then 
        return 
    end
   
    
    local divisions = {}
    
    if team.Name == "Security Corps" then
        divisions = {
			{name = "None", prefix = "SC", color = "#ffffff"},
			{name = "SVSD", prefix = "SVSD", color = "#ab1a39"},
            {name = "CIU", prefix = "CIU", color = "#173c82"},
            {name = "OSS", prefix = "OSS", color = "#6262b8"},
			{name = "MP", prefix = "MP", color = "#A81414"}
        }
    elseif team.Name == "Mobile Task Forces" then
        divisions = {
            {name = "None", prefix = "MTF", color = "#ffffff"},
			{name = "T-1", prefix = "T-1", color = "#4e3d8a"},
			{name = "A-9", prefix = "A-9", color = "#a81f1f"},
			{name = "E-11", prefix = "E-11", color = "#d37033"},
			{name = "N-7", prefix = "N-7", color = "#44506B"},
			{name = "1st Battalion", prefix = "1BN", color = "#ffc03d"}
		}
	elseif team.Name == "Scientific Department" then
		divisions = {
			{name = "ScD", prefix = "ScD", color = "#6b327c"},
			{name = "SCDSPEC", prefix = "SCDSPEC", color = "#6b327c"},
		}
	elseif team.Name == "Foundation Personnel" then
		divisions = {
			{name = "None", prefix = "", color = "#FFFFFF"},
			{name = "SV", prefix = "SV", color = "#ab1a39"},
		}
    end
    
    -- buttons
    for i, division in ipairs(divisions) do
        local button = template:Clone()
        button.Name = "DivisionButton_" .. i .. "_" .. division.name -- Unique name
        button.Text = division.name
        button.Visible = true
        button.Parent = scrollingFrame
        
        -- store division data in attributes
        button:SetAttribute("DivisionName", division.name)
        button:SetAttribute("DivisionPrefix", division.prefix)
        
        -- Set color
        if division.name == "None" then
            button.BackgroundColor3 = Color3.fromHex("#FFFFFF")
e       else
            button.BackgroundColor3 = Color3.fromHex(division.color)
        end

        -- Click handler with debugging
        button.MouseButton1Click:Connect(function()
            local selectedDivision = button:GetAttribute("DivisionName")
            DivisionRemote:FireServer("SelectDivision", selectedDivision)
            divisionUI.Enabled = false
        end)
        
    end
    
end

-- ui toggle
local toggleCount = 0
local function toggleGUI()
    divisionUI.Enabled = not divisionUI.Enabled
    if divisionUI.Enabled then
        populateButtons()
    end
end

-- keybinds for UI toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.KeypadZero then
        toggleCount = toggleCount + 1
        if toggleCount == 2 then
            toggleGUI()
        elseif toggleCount == 4 then
            toggleGUI()
            toggleCount = 0
        end
    end
end)

-- Update when team changes
player:GetPropertyChangedSignal("Team"):Connect(function()
    task.wait(0.5)
    if divisionUI.Enabled then
        populateButtons()
    end
end)