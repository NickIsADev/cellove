local Phantom = require("content/cells/destroyers/Phantom")

local speed = 20

local Sawblade = setmetatable({
    name = "sawblade",
    k3 = 1116,
    title = "Sawblade",
    description = "A Phantom that can be moved by Sawblade Orbiters.",
    blade = true
}, { __index = Phantom })
Sawblade.__index = Sawblade

function Sawblade:sprite()
    return not self.grid.simulator.paused and math.floor(love.timer.getTime() * speed) % 2 == 1 and self.texture .. "_spin" or self.texture
end

return Sawblade
