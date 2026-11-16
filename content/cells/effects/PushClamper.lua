local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local PushClamp = require("content/effects/PushClamp")

local PushClamper = setmetatable({
    name = "pushclamper",
    k3 = 136,
    title = "Push Clamper",
    description = "Prevents adjacent cells from being pushed.",
    gives = { PushClamp }
}, { __index = BaseEffectGiver })
PushClamper.__index = PushClamper

return PushClamper
