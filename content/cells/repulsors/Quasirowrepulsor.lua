local Rowrepulsor = require("content/cells/repulsors/Rowrepulsor")

local Quasirowrepulsor = setmetatable({
    name = "quasirowrepulsor",
    k3 = 765,
    title = "Quasirowrepulsor",
    description = "Rowrepulsor that only pushes in front of it.",
    outputs = { 0 }
}, { __index = Rowrepulsor })
Quasirowrepulsor.__index = Quasirowrepulsor

return Quasirowrepulsor
