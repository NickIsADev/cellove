local SuperRepulsor = require("content/cells/repulsors/SuperRepulsor")

local SemiSuperRepulsor = setmetatable({
    name = "semisuperrepulsor",
    k3 = 721,
    title = "Super Semirepulsor",
    description = "Super Repulsor that only pushes in front of and behind it.",
    outputs = { 0, 2 }
}, { __index = SuperRepulsor })
SemiSuperRepulsor.__index = SemiSuperRepulsor

return SemiSuperRepulsor
