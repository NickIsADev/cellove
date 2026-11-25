local Flipper = require("content/cells/flippers/Flipper")

local SemiflipperVertical = setmetatable({
    name = "semiflipper_vertical",
    k3 = 90,
    title = "Semiflipper (Vertical)",
    description = "Flips the cells above and below it every tick. Flips left and right when rotated.",
    outputs = { 1, 3 }
}, { __index = Flipper })
SemiflipperVertical.__index = SemiflipperVertical

return SemiflipperVertical
