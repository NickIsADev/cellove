local Enemy = require("content/cells/destroyers/Enemy")

local SwivelEnemy = setmetatable({
    name = "swivelenemy",
    k3 = 164,
    title = "Swivel Enemy",
    description = "Takes as many hits to destroy as its rotation, from 1 facing right to 4 facing up. Turns counter-clockwise when pushed into, taking the cell that pushed it along."
}, { __index = Enemy })
SwivelEnemy.__index = SwivelEnemy

function SwivelEnemy:absorb()
    if self.rotation > 0 then
        self:rotate(-1, true)
    else
        self:kill(true)
    end
end

return SwivelEnemy
