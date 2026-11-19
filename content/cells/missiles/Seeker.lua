local Missile = require("content/cells/missiles/Missile")

local Seeker = setmetatable({
    name = "seeker",
    k3 = 319,
    title = "Seeker",
    description = "Missile that turns toward a Player it can see in a straight line, and turns away from obstacles instead of crashing into them.",
    unsmart = false
}, { __index = Missile })
Seeker.__index = Seeker

function Seeker:_open()
    local front = self:look(self.rotation)
    local cell = front and self.grid:get(front.x, front.y)
    return front and (not cell or cell.hollow)
end

function Seeker:update()
    local aim = self:_target(0)
    if aim then
        self:rotate(aim - self.rotation, true)
        return Missile.update(self)
    end

    for _ = 1, 2 do
        if self:_open() then return Missile.update(self) end
        self:rotate(-1, true)
    end
    Missile.update(self)
end

return Seeker
