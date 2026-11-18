local Transmutator = require("content/cells/transmutators/Transmutator")

local CrossTransmutator = setmetatable({
    name = "crosstransmutator",
    k3 = 268,
    title = "Cross Transmutator",
    description = "Two Transmutators in one, facing forward and left.",
    outputs = { 0, 3 }
}, { __index = Transmutator })
CrossTransmutator.__index = CrossTransmutator

return CrossTransmutator
