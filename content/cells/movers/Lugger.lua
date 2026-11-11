local Grabber = require("content/cells/movers/Grabber")
local constants = require("src/constants")

local Lugger = setmetatable({
    name = "lugger",
    k3 = 73,
    title = "Lugger",
    description = "A Grabber that also pulls everything behind it. Cannot push.",
    categories = { "pullers", "grabbers" },
    subtick = { "puller" }
}, { __index = Grabber })
Lugger.__index = Lugger

function Lugger:force(dx, dy, action)
    if action == "push" then return 0 end
    return self:_alignment(dx, dy) * constants.force.strength
end

function Lugger:update()
    local movement = self.simulator.movement
    local x, y, dx, dy = self.x, self.y, self:_aim()

    if self:grab() then
        movement:attract(x - dx, y - dy, dx, dy, constants.force.strength)
    elseif self:pull() then
        movement:flank(x, y, dx, dy)
    end
end

return Lugger
