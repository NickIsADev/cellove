local Grabber = require("content/cells/movers/Grabber")
local constants = require("src/constants")

local Hoister = setmetatable({
    name = "hoister",
    k3 = 74,
    title = "Hoister",
    description = "A Grabber that also pushes whatever is in front of it and pulls everything behind it.",
    categories = { "movers", "pullers", "grabbers" },
    subtick = { 30 }
}, { __index = Grabber })
Hoister.__index = Hoister

function Hoister:force(dx, dy)
    return self:_alignment(dx, dy) * constants.force.strength
end

function Hoister:update()
    local movement = self.simulator.movement
    local x, y, dx, dy = self.x, self.y, self:_aim()

    if self:push() then
        movement:flank(x, y, dx, dy)
    elseif not self:grab() then
        return self:pull(dx, dy, constants.force.strength)
    end
    movement:attract(x - dx, y - dy, dx, dy, constants.force.strength)
end

return Hoister
