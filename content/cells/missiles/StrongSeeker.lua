local Seeker = require("content/cells/missiles/Seeker")

local StrongSeeker = setmetatable({
    name = "strongseeker",
    k3 = 792,
    title = "Strong Seeker",
    description = "Takes two hits to destroy. Becomes a Seeker when hit.",
    weak = Seeker
}, { __index = Seeker })
StrongSeeker.__index = StrongSeeker

return StrongSeeker
