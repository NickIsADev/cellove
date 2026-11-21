local Restrictor = require("content/cells/forces/Restrictor")

local Constrictor = setmetatable({
    name = "constrictor",
    k3 = 631,
    title = "Constrictor",
    description = "Restrictor that only affects force applied to its front.",
    faces = { 0 },
    front = true
}, { __index = Restrictor })
Constrictor.__index = Constrictor

return Constrictor
