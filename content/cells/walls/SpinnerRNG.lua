local BaseSpinner = require("content/cells/abstract/BaseSpinner")
local utils = require("src/utils")

local SpinnerRNG = setmetatable({
    name = "spinner_rng",
    k3 = 965,
    title = "Spinner (RNG)",
    description = "Cannot be pushed, rotated, or destroyed. Rotates any cell that tries to push it either clockwise or counter-clockwise."
}, { __index = BaseSpinner })
SpinnerRNG.__index = SpinnerRNG

function SpinnerRNG:_spin(cell, dx, dy)
    cell:rotate(utils.randomSign(), { dx = dx, dy = dy })
end

return SpinnerRNG
