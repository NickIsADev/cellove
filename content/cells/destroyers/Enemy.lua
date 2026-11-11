local BaseCell = require("content/cells/abstract/BaseCell")

local Enemy = setmetatable({
    name = "enemy",
    k3 = 13,
    title = "Enemy",
    description = "Explodes when pushed into, taking the cell that pushed it along.",
    faces = {},
    hostile = true,
    categories = { "enemies" }
}, { __index = BaseCell })
Enemy.__index = Enemy

function Enemy:eats()
    return true
end

function Enemy:absorb()
    self:kill(true)
end

return Enemy
