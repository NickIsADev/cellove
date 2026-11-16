local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local Petrified = require("content/effects/Petrified")

local Petrifier = setmetatable({
    name = "petrifier",
    k3 = 736,
    title = "Petrifier",
    description = "Permanently makes adjacent cells immovable, unrotatable and indestructible, while keeping their abilities.",
    gives = { Petrified }
}, { __index = BaseEffectGiver })
Petrifier.__index = Petrifier

return Petrifier
