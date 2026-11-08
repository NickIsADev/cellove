local Repulsor = require("content/cells/repulsors/Repulsor")

local Henarepulsor = setmetatable({
    name = "henarepulsor",
    k3 = 411,
    title = "Henarepulsor",
    description = "Repulsor that only pushes in front of it and to both its sides.",
    outputs = { 0, 1, 3 }
}, { __index = Repulsor })
Henarepulsor.__index = Henarepulsor

return Henarepulsor
