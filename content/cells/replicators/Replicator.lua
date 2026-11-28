local Generator = require("content/cells/generators/Generator")

local Replicator = setmetatable({
    name = "replicator",
    k3 = 45,
    title = "Replicator",
    description = "Clones the cell in front of it.",
    categories = { "replicators" },
    subtick = { "replicator" }
}, { __index = Generator })
Replicator.__index = Replicator

function Replicator:_source(direction)
    return direction
end

return Replicator
