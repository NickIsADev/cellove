local BaseEffect = require("content/effects/abstract/BaseEffect")
local constants = require("src/constants")

local sides = { [0] = "right", "down", "left", "up" }

local Gravity = setmetatable({
    name = "gravity",
    permanent = true,
    directional = true,
    subtick = { "gravity" }
}, { __index = BaseEffect })
Gravity.__index = Gravity

function Gravity:force(value, dx, dy, action, actor)
    if action ~= "push" then return 0 end

    local fall = constants.directions[value % 4]
    local force = fall[1] * dx + fall[2] * dy
    return actor and force > 0 and 0 or force
end

function Gravity:rotated(value, amount)
    return value < 4 and value or (value + amount) % 4 + 4
end

function Gravity:flipped(value, key, turned)
    local dir = (value - turned) % 4
    if value < 4 then return value end

    return (dir == 0 and 0 or key - dir) % 4 + 4
end

function Gravity:update(cell, value, _, direction)
    if value % 4 ~= direction then return end

    local fall = constants.directions[direction]
    cell:push(fall[1], fall[2], constants.force.gravity)
end

function Gravity:texture(value)
    return self.name .. (value < 4 and "_" or "_rotatable_") .. sides[value % 4]
end

return Gravity
