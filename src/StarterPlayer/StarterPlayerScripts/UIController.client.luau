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
    endScreen.Main.Score.Text = "Score: " .. tostring(score)
end)

endScreen.Main.Back.Activated:Connect(function()
    endScreen.Enabled = false
    lobbyScreen.Enabled = true
end)

event.SendEnemy.OnClientEvent:Connect(function(hex)
    print(hex)
    local text = Instance.new("TextLabel")
    text.Parent = gameScreen.Main.Frame
    text.Text = hex
end)

for i,v in pairs(gameScreen:WaitForChild("Buttons"):GetChildren()) do
    if not v:IsA("TextButton") then continue end

    v.Activated:Connect(function()
        event.Flip:FireServer(v.Name)
    end)
end
