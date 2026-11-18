local Transmutator = require("content/cells/transmutators/Transmutator")

local TransmutatorCW = setmetatable({
    name = "transmutator_cw",
    k3 = 509,
    title = "Transmutator (CW)",
    description = "Transmutator that takes its cell from the clockwise side and turns it clockwise.",
    bend = 1
}, { __index = Transmutator })
TransmutatorCW.__index = TransmutatorCW

return TransmutatorCW
