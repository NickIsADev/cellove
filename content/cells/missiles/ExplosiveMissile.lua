local Missile = require("content/cells/missiles/Missile")

local ExplosiveMissile = setmetatable({
    name = "explosivemissile",
    k3 = 367,
    title = "Explosive Missile",
    description = "Explodes when destroyed, destroying the cells next to it.",
    blast = "neighbors"
}, { __index = Missile })
ExplosiveMissile.__index = ExplosiveMissile

return ExplosiveMissile
