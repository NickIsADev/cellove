local GrabberPlayer = require("content/cells/movers/GrabberPlayer")

local FragileGrabberPlayer = setmetatable({
    name = "fragilegrabplayer",
    k3 = 294,
    title = "Fragile Grabber Player",
    description = "Like a Grabber Player, but explodes when pushed into, taking the cell that pushed it along.",
    fragile = true
}, { __index = GrabberPlayer })
FragileGrabberPlayer.__index = FragileGrabberPlayer

return FragileGrabberPlayer
