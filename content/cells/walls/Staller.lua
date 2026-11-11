local Wall = require("content/cells/walls/Wall")

local Staller = setmetatable({
    name = "staller",
    k3 = 162,
    title = "Staller",
    description = "Cannot be pushed or rotated, but is destroyed when something tries to move into it."
}, { __index = Wall })
Staller.__index = Staller

function Staller:_destroy(cell, exploded)
    local sim = self.simulator

    sim.movement:defer(function()
        if cell.grid:get(cell.x, cell.y) ~= cell then return end

        cell.simulator = sim
        cell:kill(exploded)
    end)
end

function Staller:bump()
    self:_destroy(self, true)
end

return Staller
