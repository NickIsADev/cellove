local BaseFlipper = require("content/cells/abstract/BaseFlipper")

local Flipper = setmetatable({
    name = "flipper",
    k3 = 30,
    title = "Flipper",
    description = "Flips adjacent cells along the direction it faces every tick."
}, { __index = BaseFlipper })
Flipper.__index = Flipper

return Flipper
