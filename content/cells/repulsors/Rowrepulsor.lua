local Repulsor = require("content/cells/repulsors/Repulsor")

local Rowrepulsor = setmetatable({
    name = "rowrepulsor",
    k3 = 763,
    title = "Rowrepulsor",
    description = "Pushes whole rows away from it.",
    row = true
}, { __index = Repulsor })
Rowrepulsor.__index = Rowrepulsor

return Rowrepulsor
