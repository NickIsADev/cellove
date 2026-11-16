local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Thawed = require("content/effects/Thawed")

local Thawer = setmetatable({
    name = "thawer",
    k3 = 285,
    title = "Thawer",
    description = "Prevents adjacent cells from being frozen.",
    subtick = { "thawer" },
    gives = { Thawed }
}, { __index = BaseEffectGiver })
Thawer.__index = Thawer

return Thawer
