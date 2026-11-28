local SuperBireplicator = require("content/cells/replicators/SuperBireplicator")

local PhysicalSuperBibackreplicator = setmetatable({
    name = "physicalsuperbibackreplicator",
    k3 = 882,
    title = "Physical Super Bibackreplicator",
    description = "Super Replicator that moves backwards to replicate, or acts like a Super Replicator if it is blocked from going backwards.",
    retreat = "first"
}, { __index = SuperBireplicator })
PhysicalSuperBibackreplicator.__index = PhysicalSuperBibackreplicator

return PhysicalSuperBibackreplicator
