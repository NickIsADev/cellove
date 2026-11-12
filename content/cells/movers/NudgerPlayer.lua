local Player = require("content/cells/movers/Player")

local NudgerPlayer = setmetatable({
    name = "nudgeplayer",
    k3 = 292,
    title = "Nudger Player",
    description = "A Player that moves into empty space. Cannot push or pull."
}, { __index = Player })
NudgerPlayer.__index = NudgerPlayer

function NudgerPlayer:_move(dx, dy)
    self:nudge(dx, dy)
end

return NudgerPlayer
