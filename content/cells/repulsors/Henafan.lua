local Fan = require("content/cells/repulsors/Fan")

local Henafan = setmetatable({
    name = "henafan",
    k3 = 421,
    title = "Henafan",
    description = "Fan that only pushes in front of it and to both its sides.",
    outputs = { 0, 1, 3 }
}, { __index = Fan })
Henafan.__index = Henafan

return Henafan
