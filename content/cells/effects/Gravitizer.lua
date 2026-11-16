local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Gravity = require("content/effects/Gravity")

local Gravitizer = setmetatable({
    name = "gravitizer",
    k3 = 232,
    title = "Gravitizer",
    description = "Causes cells near it to start falling in the direction it's pointing in.",
    gives = { Gravity },
    inclusive = false
}, { __index = BaseEffectGiver })
Gravitizer.__index = Gravitizer

function Gravitizer:_value()
    return self.rotation
end

return Gravitizer
