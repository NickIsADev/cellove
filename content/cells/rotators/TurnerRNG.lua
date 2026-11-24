local BaseTurner = require("content/cells/abstract/BaseTurner")
local utils = require("src/utils")

local TurnerRNG = setmetatable({
    name = "turner_rng",
    k3 = 966,
    title = "Turner (RNG)",
    description = "Rotates any cell that pushes it either clockwise or counter-clockwise."
}, { __index = BaseTurner })
TurnerRNG.__index = TurnerRNG

function TurnerRNG:_spin(cell)
    cell:rotate(utils.randomSign())
end

return TurnerRNG
