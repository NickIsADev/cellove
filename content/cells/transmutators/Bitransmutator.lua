local Transmutator = require("content/cells/transmutators/Transmutator")

local Bitransmutator = setmetatable({
    name = "bitransmutator",
    k3 = 544,
    title = "Bitransmutator",
    description = "Transmutator that outputs to both sides from the cell behind it.",
    outputs = { 1, 3 },
    rear = true
}, { __index = Transmutator })
Bitransmutator.__index = Bitransmutator

return Bitransmutator
