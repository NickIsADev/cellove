local Nudger = require("content/cells/movers/Nudger")
local Life = require("content/cells/infectious/Life")

local LifeMissile = setmetatable({
    name = "lifemissile",
    k3 = 161,
    title = "Life Missile",
    description = "Moves forward into empty space like a Nudger. Turns into a Life cell when it hits something.",
    categories = { "othermovers" }
}, { __index = Nudger })
LifeMissile.__index = LifeMissile

function LifeMissile:update()
    if self:nudge() then return end

    self:become(Life)
    self.updated = self.simulator.time.tick
end

return LifeMissile
