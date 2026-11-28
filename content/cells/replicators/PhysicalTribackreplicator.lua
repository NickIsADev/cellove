local Trireplicator = require("content/cells/replicators/Trireplicator")

local PhysicalTribackreplicator = setmetatable({
    name = "physicaltribackreplicator",
    k3 = 873,
    title = "Physical Tribackreplicator",
    description = "Replicator that moves backwards to replicate, or acts like a Replicator if it is blocked from going backwards.",
    retreat = "first"
}, { __index = Trireplicator })
PhysicalTribackreplicator.__index = PhysicalTribackreplicator

return PhysicalTribackreplicator
