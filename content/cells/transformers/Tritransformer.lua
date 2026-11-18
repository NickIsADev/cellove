local Transformer = require("content/cells/transformers/Transformer")

local Tritransformer = setmetatable({
    name = "tritransformer",
    k3 = 537,
    title = "Tritransformer",
    description = "Transformer that outputs forward and to both sides from the cell behind it.",
    outputs = { 0, 1, 3 },
    rear = true
}, { __index = Transformer })
Tritransformer.__index = Tritransformer

return Tritransformer
