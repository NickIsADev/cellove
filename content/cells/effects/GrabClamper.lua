local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local GrabClamp = require("content/effects/GrabClamp")

local GrabClamper = setmetatable({
    name = "grabclamper",
    k3 = 138,
    title = "Grab Clamper",
    description = "Prevents adjacent cells from being grabbed.",
    gives = { GrabClamp }
}, { __index = BaseEffectGiver })
GrabClamper.__index = GrabClamper

return GrabClamper
