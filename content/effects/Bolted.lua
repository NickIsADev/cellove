local BaseEffect = require("content/effects/abstract/BaseEffect")

local Bolted = setmetatable({
    name = "bolted",
    universal = true,
    permanent = true,
    guards = { lock = true }
}, { __index = BaseEffect })
Bolted.__index = Bolted

return Bolted
