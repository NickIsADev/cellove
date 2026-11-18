local Transformer = require("content/cells/transformers/Transformer")

local DitransformerCW = setmetatable({
    name = "ditransformer_cw",
    k3 = 538,
    title = "Ditransformer (CW)",
    description = "Transformer that outputs forward and clockwise from the cell behind it.",
    outputs = { 0, 1 },
    rear = true
}, { __index = Transformer })
DitransformerCW.__index = DitransformerCW

return DitransformerCW
