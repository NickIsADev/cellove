local BaseEffect = require("content/effects/abstract/BaseEffect")

local Protected = setmetatable({
    name = "protected",
    universal = true,
    guards = { protect = true }
}, { __index = BaseEffect })
Protected.__index = Protected

return Protected
