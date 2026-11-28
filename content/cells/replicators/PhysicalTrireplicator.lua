local Trireplicator = require("content/cells/replicators/Trireplicator")

local PhysicalTrireplicator = setmetatable({
    name = "physicaltrireplicator",
    k3 = 872,
    title = "Physical Trireplicator",
    description = "Replicator that moves backwards to replicate when it is blocked.",
    retreat = "blocked"
}, { __index = Trireplicator })
PhysicalTrireplicator.__index = PhysicalTrireplicator

return PhysicalTrireplicator
