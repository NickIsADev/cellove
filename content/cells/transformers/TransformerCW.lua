local Transformer = require("content/cells/transformers/Transformer")

local TransformerCW = setmetatable({
    name = "transformer_cw",
    k3 = 505,
    title = "Transformer (CW)",
    description = "Transformer that takes its cell from the clockwise side and turns it clockwise.",
    bend = 1
}, { __index = Transformer })
TransformerCW.__index = TransformerCW

return TransformerCW
