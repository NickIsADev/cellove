local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Locked = require("content/effects/Locked")

local Locker = setmetatable({
    name = "locker",
    k3 = 112,
    title = "Locker",
    description = "Prevents adjacent cells from being rotated or flipped.",
    gives = { Locked }
}, { __index = BaseEffectGiver })
Locker.__index = Locker

return Locker
