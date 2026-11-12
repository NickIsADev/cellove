local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local abilities = {
    push = "pushes",
    pull = "pulls",
    grab = "grabs"
}

local Driller = setmetatable({
    name = "driller",
    k3 = 58,
    title = "Driller",
    description = "Swaps places with the cell in front of it.",
    categories = { "drillers" },
    subtick = { "driller" },
    drive = { push = true, pull = true, grab = true },
    directional = true
}, { __index = BaseCell })
Driller.__index = Driller

function Driller:_follow(x, y, dx, dy)
    if self.pulls then self.simulator.movement:attract(x - dx, y - dy, dx, dy, constants.force.strength) end
end

function Driller:force(dx, dy, action)
    if not self[abilities[action]] then return 0 end
    return self:_alignment(dx, dy) * constants.force.strength
end

function Driller:drill()
    return self:swap(0, 0, self:_aim())
end

function Driller:update()
    local x, y, dx, dy = self.x, self.y, self:_aim()

    if (self.pushes and self:push()) or (self.slices and self:slice()) or self:drill() then
        if self.grabs then self.simulator.movement:flank(x, y, dx, dy) end
        self:_follow(x, y, dx, dy)
    elseif self.grabs and self:grab() then
        self:_follow(x, y, dx, dy)
    elseif self.pulls then
        self:pull()
    end
end

return Driller
