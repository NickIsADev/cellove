local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Sticky = require("content/effects/Sticky")

local Semislime = setmetatable({
    name = "semislime",
    k3 = 647,
    title = "Semislime",
    description = "Makes the cells in front of and behind it stick to each other, so they move together when pushed.",
    faces = { 0, 2 },
    outputs = { 0, 2 },
    gives = { Sticky }
}, { __index = BaseEffectGiver })
Semislime.__index = Semislime

return Semislime
