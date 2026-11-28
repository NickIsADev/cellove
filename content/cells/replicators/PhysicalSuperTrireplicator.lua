local SuperTrireplicator = require("content/cells/replicators/SuperTrireplicator")

local PhysicalSuperTrireplicator = setmetatable({
    name = "physicalsupertrireplicator",
    k3 = 884,
    title = "Physical Super Trireplicator",
    description = "Super Replicator that moves backwards to replicate when it is blocked.",
    retreat = "blocked"
}, { __index = SuperTrireplicator })
PhysicalSuperTrireplicator.__index = PhysicalSuperTrireplicator

return PhysicalSuperTrireplicator
