local Builder = require("content/cells/builders/Builder")

local DibuilderCCW = setmetatable({
    name = "dibuilder_ccw",
    k3 = 334,
    title = "Dibuilder (CCW)",
    description = "Builder with a straight and a counter-clockwise output.",
    outputs = { 0, 3 },
    aligns = true
}, { __index = Builder })
DibuilderCCW.__index = DibuilderCCW

return DibuilderCCW
