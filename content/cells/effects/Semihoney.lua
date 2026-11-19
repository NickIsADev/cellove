local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Viscous = require("content/effects/Viscous")

local Semihoney = setmetatable({
    name = "semihoney",
    k3 = 650,
    title = "Semihoney",
    description = "Makes the cells in front of and behind it stick to each other like Slime, but not to cells made sticky by Slime.",
    categories = { "sticky", "effects" },
    faces = { 0, 2 },
    outputs = { 0, 2 },
    gives = { Viscous }
}, { __index = BaseEffectGiver })
Semihoney.__index = Semihoney

return Semihoney
