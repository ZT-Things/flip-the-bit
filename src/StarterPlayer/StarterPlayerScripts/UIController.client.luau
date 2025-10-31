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
    local enemy = ReplicatedStorage
end)

event.UpdateState.OnClientEvent:Connect(function(x)
    for i = 1,8 do
        local button = gameScreen.Main.Buttons:FindFirstChild(tostring(i))
        if x[i] == true then
            button.Text = "1"
        else
            button.Text = "0"
        end
    end
end)

-- Buttons

local holding = false

local mouse = plr:GetMouse()

mouse.Button1Down:Connect(function()
    holding = true
end)

mouse.Button1Up:Connect(function()
    holding = false
end)

for i,v in pairs(gameScreen.Main:WaitForChild("Buttons"):GetChildren()) do
    if not v:IsA("TextButton") then continue end

    v.Activated:Connect(function()
        event.Flip:FireServer(v.Name)
    end)

    v.MouseEnter:Connect(function()
        if holding then
            event.Flip:FireServer(v.Name)
        end
    end)
end
