local Fan = require("content/cells/repulsors/Fan")

local Hemifan = setmetatable({
    name = "hemifan",
    k3 = 420,
    title = "Hemifan",
    description = "Fan that only pushes in front of it and to its left.",
    outputs = { 0, 3 }
}, { __index = Fan })
Hemifan.__index = Hemifan

return Hemifan
