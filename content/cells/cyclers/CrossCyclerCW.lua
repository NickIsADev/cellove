local CyclerCW = require("content/cells/cyclers/CyclerCW")

local CrossCyclerCW = setmetatable({
    name = "crosscycler_cw",
    k3 = 627,
    title = "Cross Cycler (CW)",
    description = "Two CW Cyclers, facing forward and left.",
    outputs = { 0, 3 }
}, { __index = CyclerCW })
CrossCyclerCW.__index = CrossCyclerCW

return CrossCyclerCW
