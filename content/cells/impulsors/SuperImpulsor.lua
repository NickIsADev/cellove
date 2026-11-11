local Impulsor = require("content/cells/impulsors/Impulsor")
local constants = require("src/constants")

local SuperImpulsor = setmetatable({
    name = "superimpulsor",
    k3 = 248,
    title = "Super Impulsor",
    description = "Pulls the nearest cell on every side all the way to itself with unlimited force every tick.",
    subtick = { "superImpulsor" }
}, { __index = Impulsor })
SuperImpulsor.__index = SuperImpulsor

function SuperImpulsor:update(_, direction)
    local movement = self.simulator.movement
    local move = self:look((direction + 2) % 4, true)

    while move and not move.target do
        move = movement:look(move.x, move.y, move.dx, move.dy, true)
    end
    if not move then return end

    local x, y, dx, dy = move.x, move.y, -move.dx, -move.dy
    for _ = 1, constants.grid.limits.max do
        if not movement:attract(x, y, dx, dy, math.huge) then return end

        move = movement:look(x, y, dx, dy)
        if not move then return end

        x, y, dx, dy = move.x, move.y, move.dx, move.dy
    end
end

return SuperImpulsor
