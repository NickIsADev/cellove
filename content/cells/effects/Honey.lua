local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Viscous = require("content/effects/Viscous")

local Honey = setmetatable({
    name = "honey",
    k3 = 649,
    title = "Honey",
    description = "Makes adjacent cells stick to each other like Slime, but not to cells made sticky by Slime.",
    categories = { "sticky", "effects" },
    gives = { Viscous }
}, { __index = BaseEffectGiver })
Honey.__index = Honey

return Honey
