local helper = {}

--[[
Returns 2 random hexadecimal as string
]]
function helper.get_random_two_hex()
    local value = string.format("%02X", math.random(0, 255))
    return value
end

--[[
Accept 8 bits in string
]]
function helper.tohex(str)
    local decimal = tonumber(str, 2)

    local hex = string.format("%02X", decimal)

    return hex
end

return helper
