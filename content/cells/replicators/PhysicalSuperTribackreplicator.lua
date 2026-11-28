local SuperTrireplicator = require("content/cells/replicators/SuperTrireplicator")

local PhysicalSuperTribackreplicator = setmetatable({
    name = "physicalsupertribackreplicator",
    k3 = 885,
    title = "Physical Super Tribackreplicator",
    description = "Super Replicator that moves backwards to replicate, or acts like a Super Replicator if it is blocked from going backwards.",
    retreat = "first"
}, { __index = SuperTrireplicator })
PhysicalSuperTribackreplicator.__index = PhysicalSuperTribackreplicator

return PhysicalSuperTribackreplicator
