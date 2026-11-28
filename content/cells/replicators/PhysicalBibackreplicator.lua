local Bireplicator = require("content/cells/replicators/Bireplicator")

local PhysicalBibackreplicator = setmetatable({
    name = "physicalbibackreplicator",
    k3 = 870,
    title = "Physical Bibackreplicator",
    description = "Replicator that moves backwards to replicate, or acts like a Replicator if it is blocked from going backwards.",
    retreat = "first"
}, { __index = Bireplicator })
PhysicalBibackreplicator.__index = PhysicalBibackreplicator

return PhysicalBibackreplicator
