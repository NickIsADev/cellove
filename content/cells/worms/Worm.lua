local BaseCell = require("content/cells/abstract/BaseCell")

local Worm = setmetatable({
    name = "worm",
    k3 = 1077,
    title = "Worm",
    description = "Transforms the cell in front of it into itself and disappears.",
    categories = { "worms" },
    subtick = { "worm" },
    directional = true,
    spin = 0
}, { __index = BaseCell })
Worm.__index = Worm

function Worm:update(_, direction)
    local front = self:look(direction)
    local target = front and front.target
    if not (target and target:transformable()) then return end

    local class, props = self:generated()
    local clone = class:new({
        rotation = self.rotation,
        props = props,
        effects = self:kept()
    })
    clone:rotate(self.spin, true, true)
    clone.updated, clone.ran = self.updated, self.ran

    self:transform(direction, clone)
    if self.twist then clone:flip((self.rotation * 2 + self.twist) % 4, true) end
    if self.grid:get(self.x, self.y) == self then self:kill() end
end

return Worm
