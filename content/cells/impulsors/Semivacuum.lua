local Vacuum = require("content/cells/impulsors/Vacuum")

local Semivacuum = setmetatable({
    name = "semivacuum",
    k3 = 1008,
    title = "Semivacuum",
    description = "Vacuum that only pulls in front of and behind it.",
    inputs = { 0, 2 }
}, { __index = Vacuum })
Semivacuum.__index = Semivacuum

return Semivacuum
