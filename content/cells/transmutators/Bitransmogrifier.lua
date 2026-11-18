local Transmutator = require("content/cells/transmutators/Transmutator")

local Bitransmogrifier = setmetatable({
    name = "bitransmogrifier",
    k3 = 548,
    title = "Bitransmogrifier",
    description = "Transmogrifier that outputs to both sides from the cell behind it, without turning it.",
    outputs = { 1, 3 },
    rear = true,
    rotates = false
}, { __index = Transmutator })
Bitransmogrifier.__index = Bitransmogrifier

return Bitransmogrifier
