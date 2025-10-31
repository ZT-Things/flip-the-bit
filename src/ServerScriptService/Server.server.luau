local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local event = ReplicatedStorage.Event

local enemies = {}
local state = {}

Players.PlayerRemoving:Connect(function(plr)
    local plrName = plr.Name
    enemies[plrName] = nil
    state[plrName] = nil
end)

local Helper = require(ReplicatedStorage.Helper)

function init(name)
    enemies[name] = {}
    state[name] = {false, false, false, false, false, false, false, false}
end

function tick_timer(name)
    if not enemies[name] then return end
    for i,v in pairs(enemies[name]) do
        v.timer -= 1
    end
end

function check_lose(name)
    print("Check")
    for i,v in pairs(enemies[name]) do
        if v.timer == 0 then
            print("Lost")
            return true
        end
    end
    print("Still going")

    return false
end

function state_to_string(name)
    local hex_string = ""
    for i = 1,8 do
        if state[name][i] == true then
            hex_string = hex_string .. "1"
        else
            hex_string = hex_string .. "0"
        end
    end
    return hex_string
end

function check_kill(name)
    local current_state = state_to_string(name)

    local current_hex = Helper.tohex(current_state)

    print("state", current_state, current_hex)

    for i,v in pairs(enemies[name]) do
        if v.hex == current_hex then
            print("Killed", v.hex)
            table.remove(enemies[name], i)
            return
        end
    end
end

event.Start.OnServerEvent:Connect(function(plr)
    -- init(plr)
    local name = plr.Name
    init(name)

    event.UpdateState:FireClient(plr, state[name])
    while true do -- This logic sucks, fix later by adding movement and shit
        local hex = Helper.get_random_two_hex()

        local timer = 10

        local enemy = {
            ["hex"] = hex,
            ["timer"] = timer -- Time it takes for this to reach the funny
        }

        table.insert(enemies[name], enemy)
        -- enemies[name][hex] = enemy -- This wouldn't allow 2 enemies with the same hex
        -- print(enemies[name])
        print(enemies)

        event.SendEnemy:FireClient(plr, hex, timer)
        task.wait(1)
        tick_timer(name)
        if check_lose(name) then
            local score = 10
            event.GameOver:FireClient(plr, score)
            return
        end
    end
end)

event.Flip.OnServerEvent:Connect(function(plr, bit)
    local name = plr.Name
    bit = tonumber(bit)
    if not state[name] then
        init(name)
    end
    state[name][bit] = not state[name][bit]
    print(state)
    check_kill(name)
    event.UpdateState:FireClient(plr, state[name])
end)
