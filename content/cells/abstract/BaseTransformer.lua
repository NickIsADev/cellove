local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local BaseTransformer = setmetatable({
    categories = { "transformers" },
    subtick = { "transformer" },
    directional = true,
    rotates = true
}, { __index = BaseCell })
BaseTransformer.__index = BaseTransformer

function BaseTransformer:_plan(direction)
    if self.rear then
        return (self.rotation + 2) % 4, self.rotates and direction - self.rotation or 0
    elseif self.bend then
        return (direction + self.bend) % 4, self.rotates and self.bend or 0
    end
    return (direction + 2) % 4, 0
end

function BaseTransformer:_scout(direction)
    local source, turn = self:_plan(direction)
    local back = self:look(source, true)
    if not back then return end

    local scout = {
        x = back.x,
        y = back.y,
        dx = back.dx,
        dy = back.dy,
        turn = back.turn
    }
    local cell = back.target
    if cell and cell:generatable() and cell:generated() then scout.cell = cell end
    return scout, turn
end

function BaseTransformer:_build(scout, turn)
    local cell = scout.cell
    local class, props, rotation = cell:generated()
    local clone = class:new({ rotation = rotation or cell.rotation, props = props, effects = cell:kept() })

    clone:rotate(scout.turn + turn, true, true)
    clone.updated, clone.ran = cell.updated, cell.ran
    return clone
end

function BaseTransformer:_movable(cell, scout)
    return cell:pushable(scout.dx, scout.dy, nil, "pull") and not cell:guarded("pull")
end

function BaseTransformer:_withdraw(scout)
    local grid, movement = self.grid, self.simulator.movement
    local cell = scout.cell
    if cell then grid:set(scout.x, scout.y, nil) end

    local behind = movement:look(scout.x, scout.y, scout.dx, scout.dy)
    local target = behind and behind.target
    if not target then return true end

    local dx, dy = -behind.dx, -behind.dy
    if target:pushable(dx, dy, nil, "pull") and not target:guarded("pull") and movement:pull(behind.x, behind.y, dx, dy, constants.force.strength) then return true end

    if cell then grid:set(scout.x, scout.y, cell) end
    return false
end

function BaseTransformer:update(_, direction)
    local scout, turn = self:_scout(direction)
    if scout and scout.cell then self:transform(direction, self:_build(scout, turn)) end
end

return BaseTransformer
