local Repulsor = require("content/cells/repulsors/Repulsor")
local constants = require("src/constants")

local SuperRepulsor = setmetatable({
    name = "superrepulsor",
    k3 = 50,
    title = "Super Repulsor",
    description = "Pushes every cell in line with it away with unlimited force and range every tick.",
    subtick = { 23 }
}, { __index = Repulsor })
SuperRepulsor.__index = SuperRepulsor

function SuperRepulsor:update(_, direction)
    local movement = self.simulator.movement
    local facing = constants.directions[direction]
    local x, y, dx, dy = self.x, self.y, facing[1], facing[2]

    for _ = 1, constants.grid.limits.max do
        local front = movement:repel(x, y, dx, dy, math.huge)
        if not front then return end

        x, y, dx, dy = front.x, front.y, front.dx, front.dy
    end
end

return SuperRepulsor
