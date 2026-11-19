local FriendlySeeker = require("content/cells/missiles/FriendlySeeker")

local FriendlyMegaExplosiveSeeker = setmetatable({
    name = "friendlymegaexplosiveseeker",
    k3 = 803,
    title = "Friendly Mega-Explosive Seeker",
    description = "Explodes when destroyed, destroying all eight cells around it.",
    blast = "surrounding"
}, { __index = FriendlySeeker })
FriendlyMegaExplosiveSeeker.__index = FriendlyMegaExplosiveSeeker

return FriendlyMegaExplosiveSeeker
