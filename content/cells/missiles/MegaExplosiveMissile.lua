local Missile = require("content/cells/missiles/Missile")

local MegaExplosiveMissile = setmetatable({
    name = "megaexplosivemissile",
    k3 = 368,
    title = "Mega-Explosive Missile",
    description = "Explodes when destroyed, destroying all eight cells around it.",
    blast = "surrounding"
}, { __index = Missile })
MegaExplosiveMissile.__index = MegaExplosiveMissile

return MegaExplosiveMissile
