local Grabber = require("content/cells/movers/Grabber")
local constants = require("src/constants")

local Heaver = setmetatable({
    name = "heaver",
    k3 = 72,
    title = "Heaver",
    description = "A Grabber that also pushes whatever is in front of it. Cannot pull.",
    categories = { "movers", "grabbers" }
}, { __index = Grabber })
Heaver.__index = Heaver

function Heaver:force(dx, dy, action)
    if action == "pull" then return 0 end
    return self:_alignment(dx, dy) * constants.force.strength
end

function Heaver:update()
    local x, y, dx, dy = self.x, self.y, self:_aim()

    if self:push() then
        self.simulator.movement:flank(x, y, dx, dy)
    else
        self:grab()
    end
end

return Heaver
