local FriendlySeeker = require("content/cells/missiles/FriendlySeeker")

local FriendlySuperSeeker = setmetatable({
    name = "friendlysuperseeker",
    k3 = 801,
    title = "Friendly Super Seeker",
    description = "Cannot be destroyed by hits.",
    tough = true
}, { __index = FriendlySeeker })
FriendlySuperSeeker.__index = FriendlySuperSeeker

return FriendlySuperSeeker
