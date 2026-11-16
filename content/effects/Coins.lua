local BaseEffect = require("content/effects/abstract/BaseEffect")

local Coins = setmetatable({
    name = "coins",
    universal = true,
    permanent = true,
    relays = false
}, { __index = BaseEffect })
Coins.__index = Coins

function Coins:give(cell, amount)
    local total = (cell:effect(self) or 0) + amount

    if total > 0 then
        self:apply(cell, total)
    else
        self:remove(cell)
    end
end

function Coins:draw(renderer, value, x, y, size, offset)
    BaseEffect.draw(self, renderer, value, x, y, size, offset)
    renderer:drawCount(value, x, y, 0, size, offset)
end

return Coins
