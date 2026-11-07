local Impulsor = require("content/cells/impulsors/Impulsor")

local Henaimpulsor = setmetatable({
    name = "henaimpulsor",
    k3 = 416,
    title = "Henaimpulsor",
    description = "Impulsor that only pulls in front of it and to both its sides.",
    inputs = { 0, 1, 3 }
}, { __index = Impulsor })
Henaimpulsor.__index = Henaimpulsor

return Henaimpulsor
