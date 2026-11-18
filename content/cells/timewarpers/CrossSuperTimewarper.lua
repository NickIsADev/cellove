local SuperTimewarper = require("content/cells/timewarpers/SuperTimewarper")

local CrossSuperTimewarper = setmetatable({
    name = "crosssupertimewarper",
    k3 = 834,
    title = "Cross Super Timewarper",
    description = "Two Super Timewarpers in one, facing forward and left.",
    outputs = { 0, 3 }
}, { __index = SuperTimewarper })
CrossSuperTimewarper.__index = CrossSuperTimewarper

return CrossSuperTimewarper
