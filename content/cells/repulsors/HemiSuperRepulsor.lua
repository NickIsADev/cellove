local SuperRepulsor = require("content/cells/repulsors/SuperRepulsor")

local HemiSuperRepulsor = setmetatable({
    name = "hemisuperrepulsor",
    k3 = 723,
    title = "Super Hemirepulsor",
    description = "Super Repulsor that only pushes in front of it and to its left.",
    outputs = { 0, 3 }
}, { __index = SuperRepulsor })
HemiSuperRepulsor.__index = HemiSuperRepulsor

return HemiSuperRepulsor
