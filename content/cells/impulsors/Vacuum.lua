local Impulsor = require("content/cells/impulsors/Impulsor")
local constants = require("src/constants")

local Vacuum = setmetatable({
    name = "vacuum",
    k3 = 1007,
    title = "Vacuum",
    description = "An Impulsor with a range of 3 cells.",
    subtick = { 19 }
}, { __index = Impulsor })
Vacuum.__index = Vacuum

function Vacuum:update(_, direction)
    local movement = self.simulator.movement
    local move = self:look((direction + 2) % 4, true)
    move = move and movement:look(move.x, move.y, move.dx, move.dy, true)
    if not move then return end

    local strength = constants.force.strength
    local x, y, dx, dy = move.x, move.y, -move.dx, -move.dy

    if self.simulator.grid:get(x, y) or movement:attract(x - dx, y - dy, dx, dy, strength) then
        movement:attract(x, y, dx, dy, strength * 2)
    end
end

return Vacuum
