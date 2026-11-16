local BaseEffect = require("content/effects/abstract/BaseEffect")

local Petrified = setmetatable({
    name = "petrified",
    universal = true,
    permanent = true,
    guards = {
        immune = true,
        protect = true,
        lock = true,
        push = true,
        pull = true,
        grab = true,
        swap = true,
        scissor = true,
        tunnel = true
    }
}, { __index = BaseEffect })
Petrified.__index = Petrified

return Petrified
