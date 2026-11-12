local DrillerPlayer = require("content/cells/movers/DrillerPlayer")

local FragileDrillerPlayer = setmetatable({
    name = "fragiledrillplayer",
    k3 = 295,
    title = "Fragile Driller Player",
    description = "Like a Driller Player, but explodes when pushed into, taking the cell that pushed it along.",
    fragile = true
}, { __index = DrillerPlayer })
FragileDrillerPlayer.__index = FragileDrillerPlayer

return FragileDrillerPlayer
