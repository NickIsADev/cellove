local BaseCell = require("content/cells/abstract/BaseCell")

local Enemy = setmetatable({
    name = "enemy",
    k3 = 13,
    title = "Enemy",
    description = "Explodes when pushed into, taking the cell that pushed it along.",
    faces = {},
    hostile = true,
    destroys = true,
    collides = true,
    categories = { "enemies" }
}, { __index = BaseCell })
Enemy.__index = Enemy

function Enemy:eats()
    return true
end

function Enemy:hit(damage)
    self:kill(true)
end

function Enemy:absorb(cell)
    local damage = math.min(self:health(), cell:health())
    self:hit(damage)
    return not self.grid:get(self.x, self.y) and cell.struck and cell:struck(damage)
end

return Enemy
