local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local SwapClamp = require("content/effects/SwapClamp")

local SwapClamper = setmetatable({
    name = "swapclamper",
    k3 = 139,
    title = "Swap Clamper",
    description = "Prevents adjacent cells from being swapped.",
    gives = { SwapClamp }
}, { __index = BaseEffectGiver })
SwapClamper.__index = SwapClamper

return SwapClamper
