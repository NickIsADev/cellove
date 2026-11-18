local Timewarper = require("content/cells/timewarpers/Timewarper")

local CrossTimewarper = setmetatable({
    name = "crosstimewarper",
    k3 = 148,
    title = "Cross Timewarper",
    description = "Two Timewarpers in one, facing forward and left.",
    outputs = { 0, 3 }
}, { __index = Timewarper })
CrossTimewarper.__index = CrossTimewarper

return CrossTimewarper
