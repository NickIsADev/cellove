local Transformer = require("content/cells/transformers/Transformer")

local TransformerCCW = setmetatable({
    name = "transformer_ccw",
    k3 = 506,
    title = "Transformer (CCW)",
    description = "Transformer that takes its cell from the counter-clockwise side and turns it counter-clockwise.",
    bend = -1
}, { __index = Transformer })
TransformerCCW.__index = TransformerCCW

return TransformerCCW
