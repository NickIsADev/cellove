local Fan = require("content/cells/repulsors/Fan")

local Semifan = setmetatable({
    name = "semifan",
    k3 = 418,
    title = "Semifan",
    description = "Fan that only pushes in front of and behind it.",
    outputs = { 0, 2 }
}, { __index = Fan })
Semifan.__index = Semifan

return Semifan
