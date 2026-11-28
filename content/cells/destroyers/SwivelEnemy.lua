local Enemy = require("content/cells/destroyers/Enemy")

local SwivelEnemy = setmetatable({
    name = "swivelenemy",
    k3 = 164,
    title = "Swivel Enemy",
    description = "Takes as many hits to destroy as its rotation, from 1 facing right to 4 facing up. Turns counter-clockwise when pushed into, taking the cell that pushed it along."
}, { __index = Enemy })
SwivelEnemy.__index = SwivelEnemy

function SwivelEnemy:health()
    return self.rotation + 1
end

function SwivelEnemy:hit(damage)
    if damage > self.rotation then
        Enemy.hit(self, damage)
    else
        self:rotate(-damage, { forced = true })
    end
end

return SwivelEnemy
