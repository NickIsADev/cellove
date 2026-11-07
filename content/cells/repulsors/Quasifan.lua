local Fan = require("content/cells/repulsors/Fan")

local Quasifan = setmetatable({
    name = "quasifan",
    k3 = 419,
    title = "Quasifan",
    description = "Fan that only pushes in front of it.",
    outputs = { 0 }
}, { __index = Fan })
Quasifan.__index = Quasifan

return Quasifan
