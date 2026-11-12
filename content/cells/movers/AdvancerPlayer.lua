local Player = require("content/cells/movers/Player")
local constants = require("src/constants")

local AdvancerPlayer = setmetatable({
    name = "advancerplayer",
    k3 = 829,
    title = "Advancer Player",
    description = "A Player that pushes whatever is in front of it and pulls everything behind it."
}, { __index = Player })
AdvancerPlayer.__index = AdvancerPlayer

function AdvancerPlayer:_move(dx, dy)
    local x, y = self.x, self.y

    if self:push(dx, dy, constants.force.strength) then
        self.simulator.movement:attract(x - dx, y - dy, dx, dy, constants.force.strength)
    else
        self:pull(dx, dy, constants.force.strength)
    end
end

return AdvancerPlayer
