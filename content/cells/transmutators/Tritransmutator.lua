local Transmutator = require("content/cells/transmutators/Transmutator")

local Tritransmutator = setmetatable({
    name = "tritransmutator",
    k3 = 545,
    title = "Tritransmutator",
    description = "Transmutator that outputs forward and to both sides from the cell behind it.",
    outputs = { 0, 1, 3 },
    rear = true
}, { __index = Transmutator })
Tritransmutator.__index = Tritransmutator

return Tritransmutator
