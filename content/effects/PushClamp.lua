local BaseEffect = require("content/effects/abstract/BaseEffect")

local PushClamp = setmetatable({
    name = "pushclamp",
    guards = { push = true }
}, { __index = BaseEffect })
PushClamp.__index = PushClamp

return PushClamp
