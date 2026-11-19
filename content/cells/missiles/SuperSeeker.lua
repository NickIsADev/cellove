local Seeker = require("content/cells/missiles/Seeker")

local SuperSeeker = setmetatable({
    name = "superseeker",
    k3 = 793,
    title = "Super Seeker",
    description = "Cannot be destroyed by hits.",
    tough = true
}, { __index = Seeker })
SuperSeeker.__index = SuperSeeker

return SuperSeeker
