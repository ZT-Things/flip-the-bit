print("Hello world!")
local value = string.format("%02X", math.random(0, 255))
print(value)

local test = "00110001"

-- Convert binary string to number
local decimal = tonumber(test, 2)

-- Convert number to 2-digit hexadecimal
local hex = string.format("%02X", decimal)

print(hex)  -- Output: 31
