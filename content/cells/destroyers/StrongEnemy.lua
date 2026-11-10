local Enemy = require("content/cells/destroyers/Enemy")

local StrongEnemy = setmetatable({
    name = "strongenemy",
    k3 = 24,
    title = "Strong Enemy",
    description = "Takes two hits to destroy. Becomes an Enemy when pushed into, taking the cell that pushed it along."
}, { __index = Enemy })
StrongEnemy.__index = StrongEnemy

function StrongEnemy:absorb()
    local cell = Enemy:new({ rotation = self.rotation })
    cell.path, cell.own, cell.turn = self.path, self.own, self.turn

    self:kill(true)
    self.grid:set(self.x, self.y, cell)
    self.grid:touch(cell)
end

return StrongEnemy
