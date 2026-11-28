local Replicator = require("content/cells/replicators/Replicator")

local PhysicalBackreplicator = setmetatable({
    name = "physicalbackreplicator",
    k3 = 396,
    title = "Physical Backreplicator",
    description = "Replicator that moves backwards to replicate, or acts like a Replicator if it is blocked from going backwards.",
    retreat = "first"
}, { __index = Replicator })
PhysicalBackreplicator.__index = PhysicalBackreplicator

return PhysicalBackreplicator
