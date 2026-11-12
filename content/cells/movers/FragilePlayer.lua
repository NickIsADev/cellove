local Player = require("content/cells/movers/Player")

local FragilePlayer = setmetatable({
    name = "fragileplayer",
    k3 = 288,
    title = "Fragile Player",
    description = "Like a Player, but explodes when pushed into, taking the cell that pushed it along.",
    fragile = true
}, { __index = Player })
FragilePlayer.__index = FragilePlayer

return FragilePlayer
