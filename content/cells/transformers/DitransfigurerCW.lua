local Transformer = require("content/cells/transformers/Transformer")

local DitransfigurerCW = setmetatable({
    name = "ditransfigurer_cw",
    k3 = 542,
    title = "Ditransfigurer (CW)",
    description = "Transfigurer that outputs forward and clockwise from the cell behind it, without turning it.",
    outputs = { 0, 1 },
    rear = true,
    rotates = false
}, { __index = Transformer })
DitransfigurerCW.__index = DitransfigurerCW

return DitransfigurerCW
