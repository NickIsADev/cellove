local Mover = require("content/cells/movers/Mover")
local BaseTough = require("content/cells/abstract/BaseTough")
local Audio = require("src/engine/audio/Audio")

local Crusher = setmetatable({
    name = "crusher",
    k3 = 1160,
    title = "Crusher",
    description = "Mover that crushes the cell in front of it against an immovable cell. Cannot be destroyed from its front.",
    shields = { front = true },
    damage = 1
}, { __index = Mover })
Crusher.__index = Crusher

Crusher.guarded = BaseTough.guarded

function Crusher:_crush()
    local target = self.simulator.movement.depth >= 2 and self:_breakable()
    if not target then return end

    target:hit(self.damage)
    Audio.play("destroy")
end

function Crusher:update()
    if not self:push() then self:_crush() end
end

return Crusher
