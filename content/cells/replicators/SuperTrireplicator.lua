local SuperReplicator = require("content/cells/replicators/SuperReplicator")

local SuperTrireplicator = setmetatable({
    name = "supertrireplicator",
    k3 = 515,
    title = "Super Trireplicator",
    description = "Three Super Replicators.",
    outputs = { 0, 1, 3 }
}, { __index = SuperReplicator })
SuperTrireplicator.__index = SuperTrireplicator

return SuperTrireplicator
