local BaseCell = require("content/cells/abstract/BaseCell")

local Tunneller = setmetatable({
    name = "tunneller",
    k3 = 903,
    title = "Tunneller",
    description = "Teleports through cells. Cannot teleport through unbreakables.",
    categories = { "othermovers" },
    subtick = { "slicer" },
    drive = {
        push = true,
        pull = true,
        grab = true
    },
    directional = true
}, { __index = BaseCell })
Tunneller.__index = Tunneller

function Tunneller:update()
    local dx, dy = self:_aim()
    self.simulator.movement:tunnel(self.x, self.y, dx, dy)
end

return Tunneller
