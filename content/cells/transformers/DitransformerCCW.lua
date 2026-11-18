local Transformer = require("content/cells/transformers/Transformer")

local DitransformerCCW = setmetatable({
    name = "ditransformer_ccw",
    k3 = 539,
    title = "Ditransformer (CCW)",
    description = "Transformer that outputs forward and counter-clockwise from the cell behind it.",
    outputs = { 0, 3 },
    rear = true
}, { __index = Transformer })
DitransformerCCW.__index = DitransformerCCW

return DitransformerCCW
