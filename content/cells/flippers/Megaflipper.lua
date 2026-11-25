local BaseFlipper = require("content/cells/abstract/BaseFlipper")

local Megaflipper = setmetatable({
    name = "megaflipper",
    k3 = 640,
    title = "Megaflipper",
    description = "Flips surrounding cells along the direction it faces every tick.",
    sides = { orthogonal = true, diagonal = true }
}, { __index = BaseFlipper })
Megaflipper.__index = Megaflipper

return Megaflipper
