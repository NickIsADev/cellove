local MemoryTransformer = require("content/cells/transformers/MemoryTransformer")

local MemoryTransmutator = setmetatable({
    name = "memorytransmutator",
    k3 = 762,
    title = "Memory Transmutator",
    description = "Like a Transmutator, but once it sees a cell it will transmute into that cell infinitely until it sees another.",
    categories = { "transmutators" }
}, { __index = MemoryTransformer })
MemoryTransmutator.__index = MemoryTransmutator

function MemoryTransmutator:update(_, direction)
    local scout = self:_scout(direction)
    if not scout then return end

    self:_store(scout)
    if not self:held() then return end

    local clone = self:_make(direction)
    local front = self:look(direction)
    local target = front and front.target
    if not (target and target:transformable(front.dx, front.dy) and self:_movable(clone, scout)) then return end
    if self:_withdraw(scout) then self:transform(direction, clone) end
end

return MemoryTransmutator
