local helper = {}

--[[
Returns 2 random hexadecimal as string, will never be 00
]]
function helper.get_random_two_hex()
    local value = string.format("%02X", math.random(1, 255))
    return value
end

--[[
Accept 8 bits in string and converet into 2 hexadecimal
]]
function helper.tohex(str)
    local decimal = tonumber(str, 2)

    local hex = string.format("%02X", decimal)

    return hex
end

return helper
