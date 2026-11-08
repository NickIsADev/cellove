local CyclerCW = require("content/cells/cyclers/CyclerCW")

local BicyclerCW = setmetatable({
    name = "bicycler_cw",
    k3 = 632,
    title = "Bicycler (CW)",
    description = "Two-sided CW Cycler, facing forward and backward.",
    outputs = { 0, 2 }
}, { __index = CyclerCW })
BicyclerCW.__index = BicyclerCW

return BicyclerCW
