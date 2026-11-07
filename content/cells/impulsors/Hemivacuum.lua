local Vacuum = require("content/cells/impulsors/Vacuum")

local Hemivacuum = setmetatable({
    name = "hemivacuum",
    k3 = 1010,
    title = "Hemivacuum",
    description = "Vacuum that only pulls in front of it and to its left.",
    inputs = { 0, 3 }
}, { __index = Vacuum })
Hemivacuum.__index = Hemivacuum

return Hemivacuum
