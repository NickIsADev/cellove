local Transmutator = require("content/cells/transmutators/Transmutator")

local DitransmogrifierCW = setmetatable({
    name = "ditransmogrifier_cw",
    k3 = 550,
    title = "Ditransmogrifier (CW)",
    description = "Transmogrifier that outputs forward and clockwise from the cell behind it, without turning it.",
    outputs = { 0, 1 },
    rear = true,
    rotates = false
}, { __index = Transmutator })
DitransmogrifierCW.__index = DitransmogrifierCW

return DitransmogrifierCW
