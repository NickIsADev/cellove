local Missile = require("content/cells/missiles/Missile")

local SuperMissile = setmetatable({
    name = "supermissile",
    k3 = 359,
    title = "Super Missile",
    description = "Cannot be destroyed by hits.",
    tough = true
}, { __index = Missile })
SuperMissile.__index = SuperMissile

return SuperMissile
