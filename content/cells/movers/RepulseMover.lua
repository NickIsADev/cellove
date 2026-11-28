local Mover = require("content/cells/movers/Mover")
local constants = require("src/constants")

local RepulseMover = setmetatable({
    name = "repulsemover",
    k3 = 346,
    title = "Repulse Mover",
    description = "Pushes the cells at its sides away and moves forward."
}, { __index = Mover })
RepulseMover.__index = RepulseMover

function RepulseMover:_repel(x, y)
    local movement = self.simulator.movement

    for _, direction in ipairs(self.rotation % 2 == 0 and { 3, 1 } or { 0, 2 }) do
        local facing = constants.directions[direction]
        movement:repel(x, y, facing[1], facing[2])
    end
end

function RepulseMover:resist(force, dx, dy, action)
    if action == "push" and self:_along(dx, dy) == 0 and force <= 1 then return 0 end
    return force
end

function RepulseMover:pushed(dx, dy, action)
    if action ~= "push" or self:_along(dx, dy) <= 0 then return end

    local x, y = self.x, self.y
    self.simulator.movement:post(function() self:_repel(x, y) end)
end

function RepulseMover:update()
    self:_repel(self.x, self.y)
    self:push()
end

return RepulseMover
