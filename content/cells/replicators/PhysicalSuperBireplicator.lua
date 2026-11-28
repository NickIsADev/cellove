local SuperBireplicator = require("content/cells/replicators/SuperBireplicator")

local PhysicalSuperBireplicator = setmetatable({
    name = "physicalsuperbireplicator",
    k3 = 881,
    title = "Physical Super Bireplicator",
    description = "Super Replicator that moves backwards to replicate when it is blocked.",
    retreat = "blocked"
}, { __index = SuperBireplicator })
PhysicalSuperBireplicator.__index = PhysicalSuperBireplicator

return PhysicalSuperBireplicator
