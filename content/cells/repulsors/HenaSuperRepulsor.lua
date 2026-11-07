local SuperRepulsor = require("content/cells/repulsors/SuperRepulsor")

local HenaSuperRepulsor = setmetatable({
    name = "henasuperrepulsor",
    k3 = 724,
    title = "Super Henarepulsor",
    description = "Super Repulsor that only pushes in front of it and to both its sides.",
    outputs = { 0, 1, 3 }
}, { __index = SuperRepulsor })
HenaSuperRepulsor.__index = HenaSuperRepulsor

return HenaSuperRepulsor
