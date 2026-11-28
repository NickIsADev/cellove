local BaseSpinner = require("content/cells/abstract/BaseSpinner")
local utils = require("src/utils")

local FlipSpinner = setmetatable({
    name = "flipspinner",
    k3 = 709,
    title = "Flip Spinner",
    description = "Cannot be pushed, rotated, or destroyed. Flips any cell that tries to push it across the axis it is facing.",
    categories = { "walls", "flippers" },
    axis = "straight"
}, { __index = BaseSpinner })
FlipSpinner.__index = FlipSpinner

function FlipSpinner:_spin(cell, dx, dy)
    cell:flip(utils.flip(self.rotation, self.axis), { dx = dx, dy = dy })
end

return FlipSpinner
