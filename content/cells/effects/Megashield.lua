local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Protected = require("content/effects/Protected")

local Megashield = setmetatable({
    name = "megashield",
    k3 = 145,
    title = "Megashield",
    description = "Prevents cells within 2 tiles from being destroyed, infected or transformed.",
    gives = { Protected },
    distance = 2,
    sides = { orthogonal = true, diagonal = true }
}, { __index = BaseEffectGiver })
Megashield.__index = Megashield

return Megashield
