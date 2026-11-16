local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local PullClamp = require("content/effects/PullClamp")

local PullClamper = setmetatable({
    name = "pullclamper",
    k3 = 137,
    title = "Pull Clamper",
    description = "Prevents adjacent cells from being pulled.",
    gives = { PullClamp }
}, { __index = BaseEffectGiver })
PullClamper.__index = PullClamper

return PullClamper
