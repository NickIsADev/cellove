local Transmutator = require("content/cells/transmutators/Transmutator")

local DitransmogrifierCCW = setmetatable({
    name = "ditransmogrifier_ccw",
    k3 = 551,
    title = "Ditransmogrifier (CCW)",
    description = "Transmogrifier that outputs forward and counter-clockwise from the cell behind it, without turning it.",
    outputs = { 0, 3 },
    rear = true,
    rotates = false
}, { __index = Transmutator })
DitransmogrifierCCW.__index = DitransmogrifierCCW

return DitransmogrifierCCW
