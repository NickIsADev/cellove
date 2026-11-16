local BaseEffectRemover = require("content/cells/abstract/BaseEffectRemover")
local Gravity = require("content/effects/Gravity")

local Degravitizer = setmetatable({
    name = "degravitizer",
    k3 = 266,
    title = "Degravitizer",
    description = "Un-gravitizes cells.",
    removes = { Gravity }
}, { __index = BaseEffectRemover })
Degravitizer.__index = Degravitizer

return Degravitizer
