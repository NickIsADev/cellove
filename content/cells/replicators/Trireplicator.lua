local Replicator = require("content/cells/replicators/Replicator")

local Trireplicator = setmetatable({
    name = "trireplicator",
    k3 = 398,
    title = "Trireplicator",
    description = "Three-sided Replicator.",
    outputs = { 0, 1, 3 }
}, { __index = Replicator })
Trireplicator.__index = Trireplicator

return Trireplicator
