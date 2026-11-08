local Repulsor = require("content/cells/repulsors/Repulsor")

local Semirepulsor = setmetatable({
    name = "semirepulsor",
    k3 = 408,
    title = "Semirepulsor",
    description = "Repulsor that only pushes in front of and behind it.",
    outputs = { 0, 2 }
}, { __index = Repulsor })
Semirepulsor.__index = Semirepulsor

return Semirepulsor
