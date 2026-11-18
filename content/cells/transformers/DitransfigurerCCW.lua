local Transformer = require("content/cells/transformers/Transformer")

local DitransfigurerCCW = setmetatable({
    name = "ditransfigurer_ccw",
    k3 = 543,
    title = "Ditransfigurer (CCW)",
    description = "Transfigurer that outputs forward and counter-clockwise from the cell behind it, without turning it.",
    outputs = { 0, 3 },
    rear = true,
    rotates = false
}, { __index = Transformer })
DitransfigurerCCW.__index = DitransfigurerCCW

return DitransfigurerCCW
