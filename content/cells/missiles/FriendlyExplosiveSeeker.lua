local FriendlySeeker = require("content/cells/missiles/FriendlySeeker")

local FriendlyExplosiveSeeker = setmetatable({
    name = "friendlyexplosiveseeker",
    k3 = 802,
    title = "Friendly Explosive Seeker",
    description = "Explodes when destroyed, destroying the cells next to it.",
    blast = "neighbors"
}, { __index = FriendlySeeker })
FriendlyExplosiveSeeker.__index = FriendlyExplosiveSeeker

return FriendlyExplosiveSeeker
