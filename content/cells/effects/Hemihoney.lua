local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Viscous = require("content/effects/Viscous")

local Hemihoney = setmetatable({
    name = "hemihoney",
    k3 = 790,
    title = "Hemihoney",
    description = "Makes the cells in front of and to the left of it stick to each other like Slime, but not to cells made sticky by Slime.",
    categories = { "sticky", "effects" },
    faces = { 0, 3 },
    outputs = { 0, 3 },
    gives = { Viscous }
}, { __index = BaseEffectGiver })
Hemihoney.__index = Hemihoney

return Hemihoney
