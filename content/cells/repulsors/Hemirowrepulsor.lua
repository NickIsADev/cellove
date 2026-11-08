local Rowrepulsor = require("content/cells/repulsors/Rowrepulsor")

local Hemirowrepulsor = setmetatable({
    name = "hemirowrepulsor",
    k3 = 766,
    title = "Hemirowrepulsor",
    description = "Rowrepulsor that only pushes in front of it and to its left.",
    outputs = { 0, 3 }
}, { __index = Rowrepulsor })
Hemirowrepulsor.__index = Hemirowrepulsor

return Hemirowrepulsor
