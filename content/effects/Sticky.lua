local BaseEffect = require("content/effects/abstract/BaseEffect")

local Sticky = setmetatable({
    name = "sticky",
    cling = 1
}, { __index = BaseEffect })
Sticky.__index = Sticky

return Sticky
