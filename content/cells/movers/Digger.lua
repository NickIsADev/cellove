local Mover = require("content/cells/movers/Mover")

local Digger = setmetatable({
    name = "digger",
    k3 = 904,
    title = "Digger",
    description = "Mover that tunnels through cells it cannot push. Cannot tunnel through unbreakables.",
    categories = { "movers", "othermovers" }
}, { __index = Mover })
Digger.__index = Digger

function Digger:update()
    local dx, dy = self:_aim()
    self.simulator.movement:tunnel(self.x, self.y, dx, dy, { strong = true })
end

return Digger
