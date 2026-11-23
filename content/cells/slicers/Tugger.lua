local Slicer = require("content/cells/slicers/Slicer")

local Tugger = setmetatable({
    name = "tugger",
    k3 = 270,
    title = "Tugger",
    description = "A Slicer that also pulls everything behind it.",
    categories = {
        "pullers",
        "slicers"
    },
    subtick = { "puller" },
    pulls = true
}, { __index = Slicer })
Tugger.__index = Tugger

return Tugger
