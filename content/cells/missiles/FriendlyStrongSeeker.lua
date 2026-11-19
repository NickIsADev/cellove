local FriendlySeeker = require("content/cells/missiles/FriendlySeeker")

local FriendlyStrongSeeker = setmetatable({
    name = "friendlystrongseeker",
    k3 = 800,
    title = "Friendly Strong Seeker",
    description = "Takes two hits to destroy. Becomes a Friendly Seeker when hit.",
    weak = FriendlySeeker
}, { __index = FriendlySeeker })
FriendlyStrongSeeker.__index = FriendlyStrongSeeker

return FriendlyStrongSeeker
