local BaseEffect = require("content/effects/abstract/BaseEffect")

local Viscous = setmetatable({
    name = "viscous",
    cling = 2
}, { __index = BaseEffect })
Viscous.__index = Viscous

return Viscous
