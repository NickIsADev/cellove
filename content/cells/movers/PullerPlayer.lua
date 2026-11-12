local Player = require("content/cells/movers/Player")
local constants = require("src/constants")

local PullerPlayer = setmetatable({
    name = "pullplayer",
    k3 = 289,
    title = "Puller Player",
    description = "A Player that moves into empty space, pulling everything behind it. Cannot push."
}, { __index = Player })
PullerPlayer.__index = PullerPlayer

function PullerPlayer:_move(dx, dy)
    self:pull(dx, dy, constants.force.strength)
end

return PullerPlayer
