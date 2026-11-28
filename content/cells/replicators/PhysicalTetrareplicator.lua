local Tetrareplicator = require("content/cells/replicators/Tetrareplicator")

local PhysicalTetrareplicator = setmetatable({
    name = "physicaltetrareplicator",
    k3 = 875,
    title = "Physical Tetrareplicator",
    description = "Replicator that moves backwards to replicate when it is blocked.",
    retreat = "blocked"
}, { __index = Tetrareplicator })
PhysicalTetrareplicator.__index = PhysicalTetrareplicator

return PhysicalTetrareplicator
