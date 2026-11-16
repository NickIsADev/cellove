local BaseEffect = {
    name = "base",
    subtick = {},
    relays = true,
    guards = {}
}
BaseEffect.__index = BaseEffect

function BaseEffect:accepts(cell)
    return self.universal or not (cell.fixed or cell:guarded("immune"))
end

function BaseEffect:apply(cell, value, wide)
    if not self:accepts(cell, value) then return end

    cell.effects = cell.effects or {}
    cell.effects[self] = value
    cell.grid.effected[cell] = true
    self:applied(cell)

    if self.relays and cell.transmits then
        cell:relay(function(other) self:apply(other, value, wide) end, wide)
    end
end

function BaseEffect:remove(cell)
    if cell.effects then cell.effects[self] = nil end
end

function BaseEffect:applied(cell)
end

function BaseEffect:tint(value)
end

function BaseEffect:force(value, dx, dy, action, actor)
    return 0
end

function BaseEffect:rotated(value, amount)
    return value
end

function BaseEffect:flipped(value, key, turned)
    return value
end

function BaseEffect:update(cell, value, subtick, direction)
end

function BaseEffect:texture(value)
    return self.name
end

function BaseEffect:draw(renderer, value, x, y, size, offset)
    renderer:drawSprite(self:texture(value), x, y, 0, size, offset, "effects")
end

return BaseEffect
