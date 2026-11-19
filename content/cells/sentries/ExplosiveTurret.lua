local Turret = require("content/cells/sentries/Turret")
local ExplosiveSeeker = require("content/cells/missiles/ExplosiveSeeker")

local ExplosiveTurret = setmetatable({
    name = "explosiveturret",
    k3 = 798,
    title = "Explosive Turret",
    description = "Explodes when destroyed. Fires Explosive Seekers.",
    blast = "neighbors",
    missile = ExplosiveSeeker
}, { __index = Turret })
ExplosiveTurret.__index = ExplosiveTurret

return ExplosiveTurret
