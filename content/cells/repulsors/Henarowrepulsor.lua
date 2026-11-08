local Rowrepulsor = require("content/cells/repulsors/Rowrepulsor")

local Henarowrepulsor = setmetatable({
    name = "henarowrepulsor",
    k3 = 767,
    title = "Henarowrepulsor",
    description = "Rowrepulsor that only pushes in front of it and to both its sides.",
    outputs = { 0, 1, 3 }
}, { __index = Rowrepulsor })
Henarowrepulsor.__index = Henarowrepulsor

return Henarowrepulsor
