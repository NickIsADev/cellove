local SuperTrireplicator = require("content/cells/replicators/SuperTrireplicator")

local SuperTribackreplicator = setmetatable({
    name = "supertribackreplicator",
    k3 = 886,
    title = "Super Tribackreplicator",
    description = "Super Replicator that always moves backwards to replicate, as if it were blocked.",
    retreat = "always"
}, { __index = SuperTrireplicator })
SuperTribackreplicator.__index = SuperTribackreplicator

return SuperTribackreplicator
