local Transmutator = require("content/cells/transmutators/Transmutator")

local TransmutatorCCW = setmetatable({
    name = "transmutator_ccw",
    k3 = 510,
    title = "Transmutator (CCW)",
    description = "Transmutator that takes its cell from the counter-clockwise side and turns it counter-clockwise.",
    bend = -1
}, { __index = Transmutator })
TransmutatorCCW.__index = TransmutatorCCW

return TransmutatorCCW
