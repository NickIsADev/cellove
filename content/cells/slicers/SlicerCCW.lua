local Slicer = require("content/cells/slicers/Slicer")

local SlicerCCW = setmetatable({
    name = "slicer_ccw",
    k3 = 1087,
    title = "Slicer (CCW)",
    description = "A Slicer that only slices to the left.",
    bend = -1
}, { __index = Slicer })
SlicerCCW.__index = SlicerCCW

return SlicerCCW
