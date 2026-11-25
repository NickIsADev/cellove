local Flipper = require("content/cells/flippers/Flipper")

local Skewflipper = setmetatable({
    name = "skewflipper",
    k3 = 1048,
    title = "Skewflipper",
    description = "Flips the diagonal cells every tick.",
    sides = { diagonal = true }
}, { __index = Flipper })
Skewflipper.__index = Skewflipper

return Skewflipper
