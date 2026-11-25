local BaseFlipper = require("content/cells/abstract/BaseFlipper")

local SemiflipperVertical = setmetatable({
    name = "semiflipper_vertical",
    k3 = 90,
    title = "Semiflipper (Vertical)",
    description = "Flips the cells to its left and right along the direction it faces every tick.",
    outputs = { 1, 3 }
}, { __index = BaseFlipper })
SemiflipperVertical.__index = SemiflipperVertical

return SemiflipperVertical
