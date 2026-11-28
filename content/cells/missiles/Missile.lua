local BaseWeapon = require("content/cells/abstract/BaseWeapon")

local Missile = setmetatable({
    name = "missile",
    k3 = 160,
    title = "Missile",
    description = "Moves forward into empty space like a Nudger. Reacts to hits like an Enemy, but puzzles don't count it as one.",
    categories = { "missiles", "destroyers" },
    subtick = { "nudger" },
    drive = { push = true, pull = true, grab = true },
    directional = true,
    unsmart = true
}, { __index = BaseWeapon })
Missile.__index = Missile

function Missile:_collide()
    local front = self:look(self.rotation)
    local cell = front and self.grid:get(front.x, front.y)
    if not (cell and cell:breakable(front.dx, front.dy)) then return end

    local damage = math.min(self:health(), cell:health())
    cell:hit(damage)
    self:hit(damage)

    self.simulator.movement:flush()
    if self.grid:get(self.x, self.y) == self then self:nudge() end
end

function Missile:update()
    if not self:nudge() then self:_collide() end
end

return Missile
