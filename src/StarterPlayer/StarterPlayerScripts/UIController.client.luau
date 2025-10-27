local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local PlayerGui = plr.PlayerGui
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage.Event

local lobbyScreen = PlayerGui:WaitForChild("Lobby")
local gameScreen = PlayerGui:WaitForChild("Game")
local endScreen = PlayerGui:WaitForChild("End")

-- lobby
lobbyScreen.Main.Play.Activated:Connect(function()
    event.Start:FireServer()
    lobbyScreen.Enabled = false
    gameScreen.Enabled = true
end)

event.GameOver.OnClientEvent:Connect(function(score)
    gameScreen.Enabled = false
    endScreen.Enabled = true
end)
