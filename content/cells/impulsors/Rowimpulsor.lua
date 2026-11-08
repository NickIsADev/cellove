local Impulsor = require("content/cells/impulsors/Impulsor")

local Rowimpulsor = setmetatable({
    name = "rowimpulsor",
    k3 = 1012,
    title = "Rowimpulsor",
    description = "Pulls whole rows towards it.",
    row = true
}, { __index = Impulsor })
Rowimpulsor.__index = Rowimpulsor

return Rowimpulsor
