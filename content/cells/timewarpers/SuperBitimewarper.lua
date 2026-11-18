local SuperTimewarper = require("content/cells/timewarpers/SuperTimewarper")

local SuperBitimewarper = setmetatable({
    name = "superbitimewarper",
    k3 = 835,
    title = "Super Bitimewarper",
    description = "Two Super Timewarpers in one, facing forward and backward.",
    outputs = { 0, 2 }
}, { __index = SuperTimewarper })
SuperBitimewarper.__index = SuperBitimewarper

return SuperBitimewarper
