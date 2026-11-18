local Transmutator = require("content/cells/transmutators/Transmutator")

local DitransmutatorCCW = setmetatable({
    name = "ditransmutator_ccw",
    k3 = 547,
    title = "Ditransmutator (CCW)",
    description = "Transmutator that outputs forward and counter-clockwise from the cell behind it.",
    outputs = { 0, 3 },
    rear = true
}, { __index = Transmutator })
DitransmutatorCCW.__index = DitransmutatorCCW

return DitransmutatorCCW
