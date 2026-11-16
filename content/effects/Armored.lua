local BaseEffect = require("content/effects/abstract/BaseEffect")

local Armored = setmetatable({
    name = "armored",
    universal = true,
    permanent = true,
    guards = { protect = true }
}, { __index = BaseEffect })
Armored.__index = Armored

return Armored
