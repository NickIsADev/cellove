local Seeker = require("content/cells/missiles/Seeker")

local MegaExplosiveSeeker = setmetatable({
    name = "megaexplosiveseeker",
    k3 = 795,
    title = "Mega-Explosive Seeker",
    description = "Explodes when destroyed, destroying all eight cells around it.",
    blast = "surrounding"
}, { __index = Seeker })
MegaExplosiveSeeker.__index = MegaExplosiveSeeker

return MegaExplosiveSeeker
