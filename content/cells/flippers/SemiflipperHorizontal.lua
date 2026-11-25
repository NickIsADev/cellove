local BaseFlipper = require("content/cells/abstract/BaseFlipper")

local SemiflipperHorizontal = setmetatable({
    name = "semiflipper_horizontal",
    k3 = 89,
    title = "Semiflipper (Horizontal)",
    description = "Flips the cells in front of and behind it along the direction it faces every tick.",
    outputs = { 0, 2 }
}, { __index = BaseFlipper })
SemiflipperHorizontal.__index = SemiflipperHorizontal

return SemiflipperHorizontal
