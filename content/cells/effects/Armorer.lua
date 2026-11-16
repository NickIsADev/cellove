local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Armored = require("content/effects/Armored")

local Armorer = setmetatable({
    name = "armorer",
    k3 = 619,
    title = "Armorer",
    description = "Permanently prevents surrounding cells from being destroyed, infected or transformed.",
    gives = { Armored },
    sides = { orthogonal = true, diagonal = true }
}, { __index = BaseEffectGiver })
Armorer.__index = Armorer

return Armorer
