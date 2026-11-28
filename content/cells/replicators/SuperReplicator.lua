local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")
local Replicator = require("content/cells/replicators/Replicator")

local SuperReplicator = setmetatable({
    name = "superreplicator",
    k3 = 177,
    title = "Super Replicator",
    description = "Replicator that replicates the entire row of cells in front of it.",
    categories = { "replicators" },
    subtick = { "superReplicator" },
    farFirst = false
}, { __index = SuperGenerator })
SuperReplicator.__index = SuperReplicator

SuperReplicator._source = Replicator._source

return SuperReplicator
