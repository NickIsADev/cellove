local BaseEffect = require("content/effects/abstract/BaseEffect")

local Thawed = setmetatable({
    name = "thawed",
    universal = true
}, { __index = BaseEffect })
Thawed.__index = Thawed

return Thawed
