local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Protected = require("content/effects/Protected")

local Microshield = setmetatable({
    name = "microshield",
    k3 = 309,
    title = "Microshield",
    description = "Prevents only itself from being destroyed, infected or transformed.",
    gives = { Protected },
    sides = {}
}, { __index = BaseEffectGiver })
Microshield.__index = Microshield

return Microshield
