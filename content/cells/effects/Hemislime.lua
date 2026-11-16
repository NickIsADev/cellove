local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Sticky = require("content/effects/Sticky")

local Hemislime = setmetatable({
    name = "hemislime",
    k3 = 788,
    title = "Hemislime",
    description = "Makes the cells in front of and to the left of it stick to each other, so they move together when pushed.",
    faces = { 0, 3 },
    outputs = { 0, 3 },
    gives = { Sticky }
}, { __index = BaseEffectGiver })
Hemislime.__index = Hemislime

return Hemislime
