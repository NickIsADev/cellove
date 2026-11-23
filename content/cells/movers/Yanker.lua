local Advancer = require("content/cells/movers/Advancer")
local constants = require("src/constants")

local Yanker = setmetatable({
    name = "yanker",
    k3 = 271,
    title = "Yanker",
    description = "An Advancer that slices the cell in front of it when it cannot push, pulling everything behind it along.",
    categories = {
        "movers",
        "pullers",
        "slicers"
    }
}, { __index = Advancer })
Yanker.__index = Yanker

function Yanker:update()
    local x, y, dx, dy = self.x, self.y, self:_aim()

    if self:push() or self:slice() then
        self.simulator.movement:attract(x - dx, y - dy, dx, dy, constants.force.strength)
    else
        self:pull()
    end
end

return Yanker
