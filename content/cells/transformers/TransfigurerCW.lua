local Transformer = require("content/cells/transformers/Transformer")

local TransfigurerCW = setmetatable({
    name = "transfigurer_cw",
    k3 = 507,
    title = "Transfigurer (CW)",
    description = "Transformer (CW) that does not turn the cell.",
    bend = 1,
    rotates = false
}, { __index = Transformer })
TransfigurerCW.__index = TransfigurerCW

return TransfigurerCW
