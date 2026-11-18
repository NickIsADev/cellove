local Transmutator = require("content/cells/transmutators/Transmutator")

local DitransmutatorCW = setmetatable({
    name = "ditransmutator_cw",
    k3 = 546,
    title = "Ditransmutator (CW)",
    description = "Transmutator that outputs forward and clockwise from the cell behind it.",
    outputs = { 0, 1 },
    rear = true
}, { __index = Transmutator })
DitransmutatorCW.__index = DitransmutatorCW

return DitransmutatorCW
