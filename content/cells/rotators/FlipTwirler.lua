local BaseTwirler = require("content/cells/abstract/BaseTwirler")
local utils = require("src/utils")

local FlipTwirler = setmetatable({
    name = "fliptwirler",
    k3 = 1130,
    title = "Flip Twirler",
    description = "When pushed, flips the cell it pushes into.",
    categories = { "flippers" },
    faces = { 0, 2 },
    axis = "straight"
}, { __index = BaseTwirler })
FlipTwirler.__index = FlipTwirler

function FlipTwirler:_spin(cell, dx, dy)
    cell:flip(utils.flip(self.rotation, self.axis), {
        quiet = true,
        dx = dx,
        dy = dy
    })
end

return FlipTwirler
