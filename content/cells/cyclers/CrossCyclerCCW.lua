local CyclerCCW = require("content/cells/cyclers/CyclerCCW")

local CrossCyclerCCW = setmetatable({
    name = "crosscycler_ccw",
    k3 = 628,
    title = "Cross Cycler (CCW)",
    description = "Two CCW Cyclers, facing forward and left.",
    outputs = { 0, 3 }
}, { __index = CyclerCCW })
CrossCyclerCCW.__index = CrossCyclerCCW

return CrossCyclerCCW
