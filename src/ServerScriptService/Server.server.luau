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

function reset_state(name)
    state[name] = {false, false, false, false, false, false, false, false}
    event.UpdateState:FireClient(Players:FindFirstChild(name), state[name])
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
        if v.timer <= -1 then
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
            event.Kill:FireClient(Players:FindFirstChild(name), current_hex)

            reset_state(name)

            return
        end
    end
end

-- Send enemy
-- Send enemy with balanced difficulty curve
event.Start.OnServerEvent:Connect(function(plr)
    local waveCount = 0
    local baseCooldown = 5
    local minCooldown = 0.8
    local baseTimer = 10
    local minTimer = 3

    while true do
        local name = plr.Name
        if not enemies[name] then return end

        waveCount += 1

        -- Exponential decay curve for cooldown (spawn rate)
        -- Fast decrease at start, slows down as it approaches minimum
        local cdProgress = math.min(waveCount / 50, 1) -- Reaches minimum at wave 50
        local cd = baseCooldown - (baseCooldown - minCooldown) * (1 - math.exp(-3 * cdProgress))

        -- Logarithmic decrease for timer (enemy speed)
        -- Slower initial decrease, more gradual difficulty
        local timerProgress = math.min(waveCount / 80, 1) -- Reaches minimum at wave 80
        local timer = baseTimer - (baseTimer - minTimer) * math.log(1 + timerProgress * 9) / math.log(10)

        local hex = Helper.get_random_two_hex()
        local enemy = {
            ["hex"] = hex,
            ["timer"] = timer
        }

        table.insert(enemies[name], enemy)
        event.SendEnemy:FireClient(plr, hex, timer)

        task.wait(cd)
    end
end)

-- Game state
event.Start.OnServerEvent:Connect(function(plr)
    -- init(plr)
    local name = plr.Name
    init(name)

    event.UpdateState:FireClient(plr, state[name])
    while true do -- This logic sucks, fix later by adding movement and shit
        if not enemies[name] then return end

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
