local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Sticky = require("content/effects/Sticky")

local Slime = setmetatable({
    name = "slime",
    k3 = 252,
    title = "Slime",
    description = "Makes adjacent cells stick to each other, so they move together when pushed.",
    gives = { Sticky }
}, { __index = BaseEffectGiver })
Slime.__index = Slime

return Slime
