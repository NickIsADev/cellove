local BaseCell = require("content/cells/abstract/BaseCell")

local Life = setmetatable({
    name = "life",
    k3 = 149,
    title = "Life",
    description = "Spreads like Conway's Game of Life. Infects non-Life cells.",
    faces = {},
    categories = { "infectious" },
    subtick = { 38, 39 },
    living = true
}, { __index = BaseCell })
Life.__index = Life

function Life:_alive(x, y)
    local tick, count = self.simulator.time.tick, 0

    self.simulator.grid:surrounding(x, y, 1, function(cell)
        if cell and cell.living and cell.updated ~= tick then count = count + 1 end
    end)
    return count
end

function Life:_spreads(cell, x, y)
    if not cell then return self:_alive(x, y) == 3 end
    return not cell.living and cell:transformable()
end

function Life:_spawn(x, y)
    local class, props = self:generated()
    local clone = class:new({ rotation = self.rotation, props = props })

    clone.updated = self.simulator.time.tick
    self.simulator.movement:place(x, y, clone)
end

function Life:_spread()
    local alive = self:_alive(self.x, self.y)
    self.doomed = alive ~= 2 and alive ~= 3

    self:surrounding(1, function(cell, x, y)
        if self:_spreads(cell, x, y) then self:_spawn(x, y) end
    end)
end

function Life:update(subtick)
    if subtick == self.subtick[1] then
        self:_spread()
    elseif self.doomed then
        self:kill()
    end
end

return Life
