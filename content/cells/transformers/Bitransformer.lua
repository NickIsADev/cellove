local Transformer = require("content/cells/transformers/Transformer")

local Bitransformer = setmetatable({
    name = "bitransformer",
    k3 = 536,
    title = "Bitransformer",
    description = "Transformer that outputs to both sides from the cell behind it.",
    outputs = { 1, 3 },
    rear = true
}, { __index = Transformer })
Bitransformer.__index = Bitransformer

return Bitransformer
