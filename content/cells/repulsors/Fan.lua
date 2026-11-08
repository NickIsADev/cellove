local Repulsor = require("content/cells/repulsors/Repulsor")
local constants = require("src/constants")

local Fan = setmetatable({
    name = "fan",
    k3 = 417,
    title = "Fan",
    description = "A Repulsor with a range of 2 cells.",
    subtick = { 25 }
}, { __index = Repulsor })
Fan.__index = Fan

function Fan:update(_, direction)
    local strength = constants.force.strength
    local front = self:repel(direction, strength * 2)

    if front then self.simulator.movement:repel(front.x, front.y, front.dx, front.dy, strength) end
end

return Fan
