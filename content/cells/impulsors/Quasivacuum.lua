local Vacuum = require("content/cells/impulsors/Vacuum")

local Quasivacuum = setmetatable({
    name = "quasivacuum",
    k3 = 1009,
    title = "Quasivacuum",
    description = "Vacuum that only pulls in front of it.",
    inputs = { 0 }
}, { __index = Vacuum })
Quasivacuum.__index = Quasivacuum

return Quasivacuum
