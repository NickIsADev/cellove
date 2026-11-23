local Slicer = require("content/cells/slicers/Slicer")

local SlicerCW = setmetatable({
    name = "slicer_cw",
    k3 = 1086,
    title = "Slicer (CW)",
    description = "A Slicer that only slices to the right.",
    bend = 1
}, { __index = Slicer })
SlicerCW.__index = SlicerCW

return SlicerCW
