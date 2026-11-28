local Replicator = require("content/cells/replicators/Replicator")

local Tetrareplicator = setmetatable({
    name = "tetrareplicator",
    k3 = 399,
    title = "Tetrareplicator",
    description = "Four-sided Replicator.",
    outputs = { 0, 1, 2, 3 }
}, { __index = Replicator })
Tetrareplicator.__index = Tetrareplicator

return Tetrareplicator
