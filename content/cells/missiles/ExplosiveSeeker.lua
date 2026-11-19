local Seeker = require("content/cells/missiles/Seeker")

local ExplosiveSeeker = setmetatable({
    name = "explosiveseeker",
    k3 = 794,
    title = "Explosive Seeker",
    description = "Explodes when destroyed, destroying the cells next to it.",
    blast = "neighbors"
}, { __index = Seeker })
ExplosiveSeeker.__index = ExplosiveSeeker

return ExplosiveSeeker
