local Enemy = require("content/cells/destroyers/Enemy")
local constants = require("src/constants")

local FearfulEnemy = setmetatable({
    name = "fearfulenemy",
    k3 = 1172,
    title = "Fearful Enemy",
    description = "Runs away from adjacent cells every tick, pushing whatever is in its way. Explodes when pushed into, taking the cell that pushed it along.",
    subtick = { "fearful" },
    sweep = { x = 1, y = -1 }
}, { __index = Enemy })
FearfulEnemy.__index = FearfulEnemy

function FearfulEnemy:_scared(direction)
    local move = self:look(direction)
    return move and self.grid:get(move.x, move.y) and 1 or 0
end

function FearfulEnemy:update()
    local right, down, left, up = self:_scared(0), self:_scared(1), self:_scared(2), self:_scared(3)
    local dx, dy = left - right, up - down

    if dx ~= 0 then
        dy = 0
    elseif dy == 0 then
        if left == up then return end

        local side = math.random(0, 1) * 2 - 1
        dx, dy = up * side, left * side
    end
    self:push(dx, dy, constants.force.strength)
end

return FearfulEnemy
