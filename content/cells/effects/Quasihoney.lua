local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Viscous = require("content/effects/Viscous")

local Quasihoney = setmetatable({
    name = "quasihoney",
    k3 = 651,
    title = "Quasihoney",
    description = "Makes the cell in front of it sticky like Honey.",
    categories = { "sticky", "effects" },
    faces = { 0 },
    outputs = { 0 },
    gives = { Viscous }
}, { __index = BaseEffectGiver })
Quasihoney.__index = Quasihoney

return Quasihoney
