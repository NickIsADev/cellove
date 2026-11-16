local BaseEffect = require("content/effects/abstract/BaseEffect")

local GrabClamp = setmetatable({
    name = "grabclamp",
    guards = { grab = true }
}, { __index = BaseEffect })
GrabClamp.__index = GrabClamp

return GrabClamp
