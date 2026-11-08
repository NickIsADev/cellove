local CyclerCW = require("content/cells/cyclers/CyclerCW")

local TricyclerCW = setmetatable({
    name = "tricycler_cw",
    k3 = 634,
    title = "Tricycler (CW)",
    description = "Three-sided CW Cycler, facing forward and to both sides.",
    outputs = { 0, 1, 3 }
}, { __index = CyclerCW })
TricyclerCW.__index = TricyclerCW

return TricyclerCW
