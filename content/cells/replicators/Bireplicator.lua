local Replicator = require("content/cells/replicators/Replicator")

local Bireplicator = setmetatable({
    name = "bireplicator",
    k3 = 397,
    title = "Bireplicator",
    description = "Two-sided Replicator.",
    outputs = { 0, 2 }
}, { __index = Replicator })
Bireplicator.__index = Bireplicator

return Bireplicator
