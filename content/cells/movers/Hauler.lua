local Heaver = require("content/cells/movers/Heaver")

local Hauler = setmetatable({
    name = "hauler",
    k3 = 273,
    title = "Hauler",
    description = "A Heaver that slices the cell in front of it when it cannot push. Cannot pull.",
    categories = {
        "movers",
        "grabbers",
        "slicers"
    }
}, { __index = Heaver })
Hauler.__index = Hauler

function Hauler:update()
    local x, y, dx, dy = self.x, self.y, self:_aim()

    if self:push() or self:slice() then
        self.simulator.movement:flank(x, y, dx, dy)
    else
        self:grab()
    end
end

return Hauler
