local Transmutator = require("content/cells/transmutators/Transmutator")

local Tritransmogrifier = setmetatable({
    name = "tritransmogrifier",
    k3 = 549,
    title = "Tritransmogrifier",
    description = "Transmogrifier that outputs forward and to both sides from the cell behind it, without turning it.",
    outputs = { 0, 1, 3 },
    rear = true,
    rotates = false
}, { __index = Transmutator })
Tritransmogrifier.__index = Tritransmogrifier

return Tritransmogrifier
