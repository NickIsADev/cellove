local Rowrepulsor = require("content/cells/repulsors/Rowrepulsor")

local Semirowrepulsor = setmetatable({
    name = "semirowrepulsor",
    k3 = 764,
    title = "Semirowrepulsor",
    description = "Rowrepulsor that only pushes in front of and behind it.",
    outputs = { 0, 2 }
}, { __index = Rowrepulsor })
Semirowrepulsor.__index = Semirowrepulsor

return Semirowrepulsor
