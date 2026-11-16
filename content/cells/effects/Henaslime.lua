local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Sticky = require("content/effects/Sticky")

local Henaslime = setmetatable({
    name = "henaslime",
    k3 = 789,
    title = "Henaslime",
    description = "Makes the cells in front of, to the left of and to the right of it stick to each other, so they move together when pushed.",
    faces = { 0, 1, 3 },
    outputs = { 0, 1, 3 },
    gives = { Sticky }
}, { __index = BaseEffectGiver })
Henaslime.__index = Henaslime

return Henaslime
