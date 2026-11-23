local Driller = require("content/cells/drillers/Driller")

local Slicer = setmetatable({
    name = "slicer",
    k3 = 115,
    title = "Slicer",
    description = "Moves forward; upon hitting a cell, it will attempt to push the cell out of the way in a direction perpendicular to its own.",
    categories = { "slicers" },
    subtick = { "slicer" },
    slices = true
}, { __index = Driller })
Slicer.__index = Slicer

function Slicer:drill() end

return Slicer
