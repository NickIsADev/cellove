local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Protected = require("content/effects/Protected")

local Shield = setmetatable({
    name = "shield",
    k3 = 43,
    title = "Shield",
    description = "Prevents surrounding cells from being destroyed, infected or transformed.",
    gives = { Protected },
    sides = { orthogonal = true, diagonal = true }
}, { __index = BaseEffectGiver })
Shield.__index = Shield

return Shield
