local Repulsor = require("content/cells/repulsors/Repulsor")

local Hemirepulsor = setmetatable({
    name = "hemirepulsor",
    k3 = 410,
    title = "Hemirepulsor",
    description = "Repulsor that only pushes in front of it and to its left.",
    outputs = { 0, 3 }
}, { __index = Repulsor })
Hemirepulsor.__index = Hemirepulsor

return Hemirepulsor
