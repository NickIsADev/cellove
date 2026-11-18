local Transformer = require("content/cells/transformers/Transformer")

local Tritransfigurer = setmetatable({
    name = "tritransfigurer",
    k3 = 541,
    title = "Tritransfigurer",
    description = "Transfigurer that outputs forward and to both sides from the cell behind it, without turning it.",
    outputs = { 0, 1, 3 },
    rear = true,
    rotates = false
}, { __index = Transformer })
Tritransfigurer.__index = Tritransfigurer

return Tritransfigurer
