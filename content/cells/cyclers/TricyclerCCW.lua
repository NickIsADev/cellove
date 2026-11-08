local CyclerCCW = require("content/cells/cyclers/CyclerCCW")

local TricyclerCCW = setmetatable({
    name = "tricycler_ccw",
    k3 = 635,
    title = "Tricycler (CCW)",
    description = "Three-sided CCW Cycler, facing forward and to both sides.",
    outputs = { 0, 1, 3 }
}, { __index = CyclerCCW })
TricyclerCCW.__index = TricyclerCCW

return TricyclerCCW
