local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Compel = require("content/effects/Compel")

local Settlecompeller = setmetatable({
    name = "settlecompeller",
    k3 = 824,
    title = "Settlecompeller",
    description = "If an affected cell moves, it dies.",
    gives = { Compel },
    value = 1,
    inclusive = false
}, { __index = BaseEffectGiver })
Settlecompeller.__index = Settlecompeller

return Settlecompeller
