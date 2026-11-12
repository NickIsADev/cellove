local Player = require("content/cells/movers/Player")

local DrillerPlayer = setmetatable({
    name = "drillplayer",
    k3 = 291,
    title = "Driller Player",
    description = "A Player that swaps places with the cell in front of it."
}, { __index = Player })
DrillerPlayer.__index = DrillerPlayer

function DrillerPlayer:_move(dx, dy)
    self:swap(0, 0, dx, dy)
end

return DrillerPlayer
