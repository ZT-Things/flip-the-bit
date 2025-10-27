local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local PlayerGui = plr.PlayerGui
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage.Event

local lobbyScreen = PlayerGui.Lobby
local gameScreen = PlayerGui.Game
local endScreen = PlayerGui.End

-- lobby
lobbyScreen.Main.Play.Activated:Connect(function()
    event.Start:FireServer()
    lobbyScreen.Enabled = false
    gameScreen.Enabled = false
end)


