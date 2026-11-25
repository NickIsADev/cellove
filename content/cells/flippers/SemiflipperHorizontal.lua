local Flipper = require("content/cells/flippers/Flipper")

local SemiflipperHorizontal = setmetatable({
    name = "semiflipper_horizontal",
    k3 = 89,
    title = "Semiflipper (Horizontal)",
    description = "Flips the cells to its left and right every tick. Flips above and below when rotated.",
    outputs = { 0, 2 }
}, { __index = Flipper })
SemiflipperHorizontal.__index = SemiflipperHorizontal

return SemiflipperHorizontal
