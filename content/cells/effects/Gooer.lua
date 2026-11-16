local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Goo = require("content/effects/Goo")

local Gooer = setmetatable({
    name = "gooer",
    k3 = 896,
    title = "Gooer",
    description = "Freezes cells in place until they are moved.",
    gives = { Goo },
    inclusive = false
}, { __index = BaseEffectGiver })
Gooer.__index = Gooer

return Gooer
