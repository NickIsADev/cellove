local Mover = require("content/cells/movers/Mover")

local BrokenMover = setmetatable({
    name = "brokenmover",
    k3 = 304,
    title = "Broken Mover",
    description = "Mover that is destroyed once it pushes a cell."
}, { __index = Mover })
BrokenMover.__index = BrokenMover

function BrokenMover:update()
    local front = self:look(self.rotation)
    local target = front and front.target
    local blocked = target and not target:eats(front.dx, front.dy, "push", self)

    if self:push() and blocked then self.simulator.movement:destroy(self) end
end

return BrokenMover
