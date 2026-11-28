local Hoister = require("content/cells/movers/Hoister")
local constants = require("src/constants")

local Mincer = setmetatable({
    name = "mincer",
    k3 = 275,
    title = "Mincer",
    description = "A Hoister that slices the cell in front of it when it cannot push.",
    categories = {
        "movers",
        "pullers",
        "grabbers",
        "slicers"
    }
}, { __index = Hoister })
Mincer.__index = Mincer

function Mincer:update()
    local movement = self.simulator.movement
    local x, y, dx, dy = self.x, self.y, self:_aim()

    if self:push() or self:slice() then
        movement:flank(x, y, dx, dy)
    elseif not self:grab() then
        return self:pull()
    end
    movement:attract(x - dx, y - dy, dx, dy, { force = constants.force.strength })
end

return Mincer
