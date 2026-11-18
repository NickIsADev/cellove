local Timewarper = require("content/cells/timewarpers/Timewarper")

local Tritimewarper = setmetatable({
    name = "tritimewarper",
    k3 = 616,
    title = "Tritimewarper",
    description = "Three Timewarpers in one, facing forward and to both sides.",
    outputs = { 0, 1, 3 }
}, { __index = Timewarper })
Tritimewarper.__index = Tritimewarper

return Tritimewarper
