local BaseEffect = require("content/effects/abstract/BaseEffect")

local Locked = setmetatable({
    name = "locked",
    guards = { lock = true }
}, { __index = BaseEffect })
Locked.__index = Locked

return Locked
