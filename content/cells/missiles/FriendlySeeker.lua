local Seeker = require("content/cells/missiles/Seeker")

local FriendlySeeker = setmetatable({
    name = "friendlyseeker",
    k3 = 454,
    title = "Friendly Seeker",
    description = "Seeker that targets Enemies. Hostile Sentries and Seekers target it, friendly ones ignore it.",
    team = "friendly"
}, { __index = Seeker })
FriendlySeeker.__index = FriendlySeeker

return FriendlySeeker
