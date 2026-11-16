local BaseEffect = require("content/effects/abstract/BaseEffect")

local SwapClamp = setmetatable({
    name = "swapclamp",
    guards = { swap = true }
}, { __index = BaseEffect })
SwapClamp.__index = SwapClamp

return SwapClamp
