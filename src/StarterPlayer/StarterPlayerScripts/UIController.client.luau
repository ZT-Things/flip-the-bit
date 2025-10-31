local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local PlayerGui = plr.PlayerGui
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage.Event

local lobbyScreen = PlayerGui:WaitForChild("Lobby")
local gameScreen = PlayerGui:WaitForChild("Game")
local endScreen = PlayerGui:WaitForChild("End")

-- lobby

function clearEnemies()
    for i,v in pairs(gameScreen.Main.Window:GetChildren()) do
        v:Destroy()
    end
end

lobbyScreen.Main.Play.Activated:Connect(function()
    clearEnemies()
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

local TweenService = game:GetService("TweenService")

event.SendEnemy.OnClientEvent:Connect(function(hex, timer)
    -- Random position, and destroy, and tween
    local enemy = ReplicatedStorage.Template.EnemyTemplate:Clone()
    enemy.Name = hex
    enemy.Parent = gameScreen.Main.Window
    enemy.TextLabel.Text = hex
    enemy.AnchorPoint = Vector2.new(0, 1)
    local rng = math.random(1, 90)/100

    -- Create a new UDim2 instead of modifying Scale directly
    enemy.Position = UDim2.new(rng, 0, 0.1, enemy.Position.Y.Offset)

    local tweenInfo = TweenInfo.new(
        timer,                       -- time in seconds
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    local goal = {
        Position = UDim2.new(rng, 0, 1, 0) -- Y scale to 1
    }
    local tween = TweenService:Create(enemy, tweenInfo, goal)
    tween:Play()
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
    print("Holding:", holding)
end)

mouse.Button1Up:Connect(function()
    holding = false
    print("Holding:", holding)
end)

for i,v in pairs(gameScreen.Main:WaitForChild("Buttons"):GetChildren()) do
    if not v:IsA("TextButton") then continue end

    v.MouseButton1Down:Connect(function()
        holding = true
        event.Flip:FireServer(v.Name)
    end)

    v.MouseButton1Up:Connect(function()
        holding = false
    end)

    v.MouseEnter:Connect(function()
        if holding then
            event.Flip:FireServer(v.Name)
        end
    end)
end
