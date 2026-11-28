local DibuilderCCW = require("content/cells/builders/DibuilderCCW")

local DismithCCW = setmetatable({
    name = "dismith_ccw",
    k3 = 340,
    title = "Dismith (CCW)",
    description = "Dibuilder (CCW) that does not rotate cells.",
    rotates = false
}, { __index = DibuilderCCW })
DismithCCW.__index = DismithCCW

return DismithCCW
