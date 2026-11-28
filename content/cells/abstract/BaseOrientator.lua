local BaseCell = require("content/cells/abstract/BaseCell")

local BaseOrientator = setmetatable({
    categories = { "orientators" },
    subtick = { "orientator" },
    directional = true,
    rotates = true,
    faces = {}
}, { __index = BaseCell })
BaseOrientator.__index = BaseOrientator

function BaseOrientator:_plan(direction)
    if self.rear then return (self.rotation + 2) % 4, self.rotates and direction - self.rotation or 0 end
    if self.bend then return (direction + self.bend) % 4, self.rotates and self.bend or 0 end
    return (direction + 2) % 4, 0
end

function BaseOrientator:update(_, direction)
    local source, turn = self:_plan(direction)
    local back = self:look(source, true)
    local from = back and back.target
    if not from then return end

    local rotation = from.rotation + back.turn + turn
    local front = self:look(direction)
    local to = front and front.target

    if to then to:rotate(rotation - to.rotation, { dx = front.dx, dy = front.dy }) end
end

return BaseOrientator
