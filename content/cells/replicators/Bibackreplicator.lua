local Bireplicator = require("content/cells/replicators/Bireplicator")

local Bibackreplicator = setmetatable({
    name = "bibackreplicator",
    k3 = 871,
    title = "Bibackreplicator",
    description = "Replicator that always moves backwards to replicate, as if it were blocked.",
    retreat = "always"
}, { __index = Bireplicator })
Bibackreplicator.__index = Bibackreplicator

return Bibackreplicator
