local BaseTwirler = require("content/cells/abstract/BaseTwirler")
local utils = require("src/utils")

local TwirlerRNG = setmetatable({
    name = "twirler_rng",
    k3 = 1129,
    title = "Twirler (RNG)",
    description = "When pushed, rotates the cell it pushes into either clockwise or counter-clockwise."
}, { __index = BaseTwirler })
TwirlerRNG.__index = TwirlerRNG

function TwirlerRNG:_spin(cell, dx, dy)
    cell:rotate(utils.randomSign(), { dx = dx, dy = dy })
end

return TwirlerRNG
