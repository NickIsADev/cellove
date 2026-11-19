local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Viscous = require("content/effects/Viscous")

local Henahoney = setmetatable({
    name = "henahoney",
    k3 = 791,
    title = "Henahoney",
    description = "Makes the cells in front of, to the left of and to the right of it stick to each other like Slime, but not to cells made sticky by Slime.",
    categories = { "sticky", "effects" },
    faces = { 0, 1, 3 },
    outputs = { 0, 1, 3 },
    gives = { Viscous }
}, { __index = BaseEffectGiver })
Henahoney.__index = Henahoney

return Henahoney
