local Flipper = require("content/cells/flippers/Flipper")

local Megaflipper = setmetatable({
    name = "megaflipper",
    k3 = 640,
    title = "Megaflipper",
    description = "Flips all surrounding cells every tick.",
    sides = { orthogonal = true, diagonal = true }
}, { __index = Flipper })
Megaflipper.__index = Megaflipper

return Megaflipper
