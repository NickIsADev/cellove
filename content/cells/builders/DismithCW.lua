local DibuilderCW = require("content/cells/builders/DibuilderCW")

local DismithCW = setmetatable({
    name = "dismith_cw",
    k3 = 339,
    title = "Dismith (CW)",
    description = "Dibuilder (CW) that does not rotate cells.",
    rotates = false
}, { __index = DibuilderCW })
DismithCW.__index = DismithCW

return DismithCW
