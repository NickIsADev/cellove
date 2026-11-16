local constants = require("src/constants")

local Effects = {}

function Effects.sweep(grid)
    for cell in pairs(grid.effected) do
        local effects = cell.effects

        for effect in pairs(effects) do
            if not effect.permanent then effects[effect] = nil end
        end
        if not next(effects) then cell.effects = nil end
        if not (cell.effects and grid:get(cell.x, cell.y) == cell) then grid.effected[cell] = nil end
    end
end

local function order(direction)
    local dx, dy = unpack(constants.directions[direction])
    local sx, sy = math.abs(dy), -math.abs(dx)

    return function(a, b)
        local ahead, behind = a.x * dx + a.y * dy, b.x * dx + b.y * dy
        if ahead ~= behind then return ahead > behind end
        return a.x * sx + a.y * sy < b.x * sx + b.y * sy
    end
end

function Effects.run(grid, effect, subtick, direction)
    local cells = {}

    for cell in pairs(grid.effected) do
        if cell:effect(effect) then cells[#cells + 1] = cell end
    end
    if effect.directional then table.sort(cells, order(direction)) end

    for _, cell in ipairs(cells) do
        local value = cell:effect(effect)
        if value and grid:get(cell.x, cell.y) == cell then
            cell.simulator = grid.simulator
            effect:update(cell, value, subtick, direction)
            grid.simulator.movement:flush()
        end
    end
end

return Effects
