local Bireplicator = require("content/cells/replicators/Bireplicator")

local PhysicalBireplicator = setmetatable({
    name = "physicalbireplicator",
    k3 = 869,
    title = "Physical Bireplicator",
    description = "Replicator that moves backwards to replicate when it is blocked.",
    retreat = "blocked"
}, { __index = Bireplicator })
PhysicalBireplicator.__index = PhysicalBireplicator

return PhysicalBireplicator
