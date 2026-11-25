local BaseTurner = require("content/cells/abstract/BaseTurner")
local utils = require("src/utils")

local FlipTurner = setmetatable({
    name = "flipturner",
    k3 = 711,
    title = "Flip Turner",
    description = "Flips any cell that pushes it along the direction it faces.",
    categories = { "flippers" },
    faces = { 0, 2 },
    axis = "straight"
}, { __index = BaseTurner })
FlipTurner.__index = FlipTurner

function FlipTurner:_spin(cell)
    cell:flip(utils.flip(self.rotation, self.axis))
end

return FlipTurner
