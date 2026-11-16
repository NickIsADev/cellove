local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Bolted = require("content/effects/Bolted")

local Bolter = setmetatable({
    name = "bolter",
    k3 = 1199,
    title = "Bolter",
    description = "Permanently prevents adjacent cells from being rotated or flipped.",
    gives = { Bolted }
}, { __index = BaseEffectGiver })
Bolter.__index = Bolter

return Bolter
