local CyclerCW = require("content/cells/cyclers/CyclerCW")

local TetracyclerCW = setmetatable({
    name = "tetracycler_cw",
    k3 = 636,
    title = "Tetracycler (CW)",
    description = "Four-sided CW Cycler.",
    outputs = { 0, 1, 2, 3 }
}, { __index = CyclerCW })
TetracyclerCW.__index = TetracyclerCW

return TetracyclerCW
