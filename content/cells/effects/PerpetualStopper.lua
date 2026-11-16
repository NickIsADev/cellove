local BaseEffectRemover = require("content/cells/abstract/BaseEffectRemover")
local Spin = require("content/effects/Spin")

local PerpetualStopper = setmetatable({
    name = "perpetualstopper",
    k3 = 525,
    title = "Perpetual Stopper",
    description = "Stops adjacent cells from rotating or flipping perpetually.",
    removes = { Spin },
    inclusive = false
}, { __index = BaseEffectRemover })
PerpetualStopper.__index = PerpetualStopper

return PerpetualStopper
