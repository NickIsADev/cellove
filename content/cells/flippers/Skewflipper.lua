local BaseFlipper = require("content/cells/abstract/BaseFlipper")

local Skewflipper = setmetatable({
    name = "skewflipper",
    k3 = 1048,
    title = "Skewflipper",
    description = "Flips diagonal cells along the direction it faces every tick.",
    sides = { diagonal = true }
}, { __index = BaseFlipper })
Skewflipper.__index = Skewflipper

return Skewflipper
