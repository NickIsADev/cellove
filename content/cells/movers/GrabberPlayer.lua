local Player = require("content/cells/movers/Player")
local constants = require("src/constants")

local GrabberPlayer = setmetatable({
    name = "grabplayer",
    k3 = 290,
    title = "Grabber Player",
    description = "A Player that moves into empty space, dragging the cells at its sides along with it. Cannot push or pull."
}, { __index = Player })
GrabberPlayer.__index = GrabberPlayer

function GrabberPlayer:_move(dx, dy)
    self:grab(dx, dy)
end

function GrabberPlayer:force(dx, dy, action)
    if action ~= "grab" then return 0 end
    return self:_alignment(dx, dy) * constants.force.strength
end

return GrabberPlayer
