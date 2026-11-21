local Phantom = require("content/cells/destroyers/Phantom")

local Sawblade = setmetatable({
    name = "sawblade",
    k3 = 1116,
    title = "Sawblade",
    description = "A Phantom that can be moved by Sawblade Orbiters.",
    blade = true
}, { __index = Phantom })
Sawblade.__index = Sawblade

return Sawblade
