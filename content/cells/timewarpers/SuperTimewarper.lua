local Timewarper = require("content/cells/timewarpers/Timewarper")
local constants = require("src/constants")

local SuperTimewarper = setmetatable({
    name = "supertimewarper",
    k3 = 833,
    title = "Super Timewarper",
    description = "Reverts a row of spaces back to what they were in the initial state, stopping at the first one it can't transform or that is empty in both states.",
    subtick = { "superTimewarper" }
}, { __index = Timewarper })
SuperTimewarper.__index = SuperTimewarper

function SuperTimewarper:update(_, direction)
    local movement = self.simulator.movement
    local facing = constants.directions[direction]
    local x, y, dx, dy = self.x, self.y, facing[1], facing[2]

    for _ = 1, constants.grid.limits.max do
        local front = movement:look(x, y, dx, dy)
        if not (front and self:_warp(front)) then return end

        x, y, dx, dy = front.x, front.y, front.dx, front.dy
    end
end

return SuperTimewarper
