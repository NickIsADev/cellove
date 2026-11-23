local Slicer = require("content/cells/slicers/Slicer")

local Lifter = setmetatable({
    name = "lifter",
    k3 = 272,
    title = "Lifter",
    description = "A Slicer that also drags the cells at its sides along with it.",
    categories = {
        "grabbers",
        "slicers"
    },
    subtick = { "grabber" },
    grabs = true
}, { __index = Slicer })
Lifter.__index = Lifter

return Lifter
