local Transformer = require("content/cells/transformers/Transformer")

local TransfigurerCCW = setmetatable({
    name = "transfigurer_ccw",
    k3 = 508,
    title = "Transfigurer (CCW)",
    description = "Transformer (CCW) that does not turn the cell.",
    bend = -1,
    rotates = false
}, { __index = Transformer })
TransfigurerCCW.__index = TransfigurerCCW

return TransfigurerCCW
