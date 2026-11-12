local PullerPlayer = require("content/cells/movers/PullerPlayer")

local FragilePullerPlayer = setmetatable({
    name = "fragilepullplayer",
    k3 = 293,
    title = "Fragile Puller Player",
    description = "Like a Puller Player, but explodes when pushed into, taking the cell that pushed it along.",
    fragile = true
}, { __index = PullerPlayer })
FragilePullerPlayer.__index = FragilePullerPlayer

return FragilePullerPlayer
