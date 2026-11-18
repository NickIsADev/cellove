local SuperTimewarper = require("content/cells/timewarpers/SuperTimewarper")

local SuperTritimewarper = setmetatable({
    name = "supertritimewarper",
    k3 = 836,
    title = "Super Tritimewarper",
    description = "Three Super Timewarpers in one, facing forward and to both sides.",
    outputs = { 0, 1, 3 }
}, { __index = SuperTimewarper })
SuperTritimewarper.__index = SuperTritimewarper

return SuperTritimewarper
