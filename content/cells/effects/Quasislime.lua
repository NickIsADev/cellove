local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Sticky = require("content/effects/Sticky")

local Quasislime = setmetatable({
    name = "quasislime",
    k3 = 648,
    title = "Quasislime",
    description = "Makes the cell in front of it sticky like Slime.",
    faces = { 0 },
    outputs = { 0 },
    gives = { Sticky }
}, { __index = BaseEffectGiver })
Quasislime.__index = Quasislime

return Quasislime
