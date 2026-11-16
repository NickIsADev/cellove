local BaseEffect = require("content/effects/abstract/BaseEffect")

local PullClamp = setmetatable({
    name = "pullclamp",
    guards = { pull = true }
}, { __index = BaseEffect })
PullClamp.__index = PullClamp

return PullClamp
