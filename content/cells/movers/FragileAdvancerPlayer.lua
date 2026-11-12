local AdvancerPlayer = require("content/cells/movers/AdvancerPlayer")

local FragileAdvancerPlayer = setmetatable({
    name = "fragileadvancerplayer",
    k3 = 830,
    title = "Fragile Advancer Player",
    description = "Like a Advancer Player, but explodes when pushed into, taking the cell that pushed it along.",
    fragile = true
}, { __index = AdvancerPlayer })
FragileAdvancerPlayer.__index = FragileAdvancerPlayer

return FragileAdvancerPlayer
