local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local event = ReplicatedStorage.Event

local enemies = {}
local state = {}

Players.PlayerRemoving:Connect(function(plr)
    local name = plr.Name
    enemies[name] = nil
    state[name] = nil
end)

local Helper = require(ReplicatedStorage.Helper)

event.Start.OnServerEvent:Connect(function(plr)
    local name = plr.Name
    enemies[name] = {}
    enemies[state] = {0, 0, 0, 0, 0, 0, 0, 0}

    while true do
        local hex = Helper.get_random_two_hex()

        enemies[name].append(hex)
        print(enemies[name])

        event.SendEnemy(hex)
        task.wait(1)
    end
end)
