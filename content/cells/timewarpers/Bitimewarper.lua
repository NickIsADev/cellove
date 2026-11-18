local Timewarper = require("content/cells/timewarpers/Timewarper")

local Bitimewarper = setmetatable({
    name = "bitimewarper",
    k3 = 615,
    title = "Bitimewarper",
    description = "Two Timewarpers in one, facing forward and backward.",
    outputs = { 0, 2 }
}, { __index = Timewarper })
Bitimewarper.__index = Bitimewarper

return Bitimewarper
