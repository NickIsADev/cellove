local Transformer = require("content/cells/transformers/Transformer")

local Bitransfigurer = setmetatable({
    name = "bitransfigurer",
    k3 = 540,
    title = "Bitransfigurer",
    description = "Transfigurer that outputs to both sides from the cell behind it, without turning it.",
    outputs = { 1, 3 },
    rear = true,
    rotates = false
}, { __index = Transformer })
Bitransfigurer.__index = Bitransfigurer

return Bitransfigurer
