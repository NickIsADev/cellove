local Impulsor = require("content/cells/impulsors/Impulsor")

local Semiimpulsor = setmetatable({
    name = "semiimpulsor",
    k3 = 413,
    title = "Semiimpulsor",
    description = "Impulsor that only pulls in front of and behind it.",
    inputs = { 0, 2 }
}, { __index = Impulsor })
Semiimpulsor.__index = Semiimpulsor

return Semiimpulsor
