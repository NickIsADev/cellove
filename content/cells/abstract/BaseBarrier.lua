local BaseCell = require("content/cells/abstract/BaseCell")

local BaseBarrier = setmetatable({
    name = "barrier",
    layer = "overlay",
    categories = { "walls" },
    solid = true
}, { __index = BaseCell })
BaseBarrier.__index = BaseBarrier

function BaseBarrier:_shut(mover)
    return self.solid
end

function BaseBarrier:bars(dx, dy, action, mover)
    return self:_shut(mover)
end

function BaseBarrier:look()
    return (self:_shut() == self.solid and self or self.paired).texture
end

return BaseBarrier
