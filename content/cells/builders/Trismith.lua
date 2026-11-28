local Tribuilder = require("content/cells/builders/Tribuilder")

local Trismith = setmetatable({
    name = "trismith",
    k3 = 338,
    title = "Trismith",
    description = "Tribuilder that does not rotate cells.",
    rotates = false
}, { __index = Tribuilder })
Trismith.__index = Trismith

return Trismith
