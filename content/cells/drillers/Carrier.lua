local Raker = require("content/cells/drillers/Raker")

local Carrier = setmetatable({
    name = "carrier",
    k3 = 77,
    title = "Carrier",
    description = "A Raker that also pulls everything behind it.",
    categories = { "pullers", "grabbers", "drillers" },
    pulls = true
}, { __index = Raker })
Carrier.__index = Carrier

function Carrier:update()
    local movement = self.simulator.movement
    local x, y, dx, dy = self.x, self.y, self:_aim()

    if self:grab() then
        self:_follow(x, y, dx, dy)
    elseif self:pull() then
        movement:flank(x, y, dx, dy)
    elseif self:drill() then
        movement:flank(x, y, dx, dy)
        self:_follow(x, y, dx, dy)
    end
end

return Carrier
