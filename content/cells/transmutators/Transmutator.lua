local BaseTransformer = require("content/cells/abstract/BaseTransformer")

local Transmutator = setmetatable({
    name = "transmutator",
    k3 = 267,
    title = "Transmutator",
    description = "Like a Transformer combined with a Shifter.",
    categories = { "transmutators" }
}, { __index = BaseTransformer })
Transmutator.__index = Transmutator

function Transmutator:update(_, direction)
    local scout, turn = self:_scout(direction)
    if not scout then return end

    local stamp = self.simulator.time.subtick
    local shared = self.rear and self.carried and self.carried.stamp == stamp
    if shared then
        scout.cell = self.carried.cell
    elseif not scout.cell then
        return
    end

    local front = self:look(direction)
    local target = front and front.target
    if not (target and target:transformable() and self:_movable(scout.cell, scout)) then return end
    if not shared and not self:_withdraw(scout) then return end

    self:transform(direction, self:_build(scout, turn))
    if self.rear then self.carried = { cell = scout.cell, stamp = stamp } end
end

return Transmutator
