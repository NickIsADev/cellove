local CyclerCCW = require("content/cells/cyclers/CyclerCCW")

local TetracyclerCCW = setmetatable({
    name = "tetracycler_ccw",
    k3 = 637,
    title = "Tetracycler (CCW)",
    description = "Four-sided CCW Cycler.",
    outputs = { 0, 1, 2, 3 }
}, { __index = CyclerCCW })
TetracyclerCCW.__index = TetracyclerCCW

return TetracyclerCCW
