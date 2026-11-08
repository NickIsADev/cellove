local CyclerCCW = require("content/cells/cyclers/CyclerCCW")

local BicyclerCCW = setmetatable({
    name = "bicycler_ccw",
    k3 = 633,
    title = "Bicycler (CCW)",
    description = "Two-sided CCW Cycler, facing forward and backward.",
    outputs = { 0, 2 }
}, { __index = CyclerCCW })
BicyclerCCW.__index = BicyclerCCW

return BicyclerCCW
