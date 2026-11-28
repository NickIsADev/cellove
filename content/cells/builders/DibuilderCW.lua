local Builder = require("content/cells/builders/Builder")

local DibuilderCW = setmetatable({
    name = "dibuilder_cw",
    k3 = 333,
    title = "Dibuilder (CW)",
    description = "Builder with a straight and a clockwise output.",
    outputs = { 0, 1 },
    aligns = true
}, { __index = Builder })
DibuilderCW.__index = DibuilderCW

return DibuilderCW
