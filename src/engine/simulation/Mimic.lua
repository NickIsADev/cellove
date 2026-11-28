local function struck(dx, dy, action)
    if action and action ~= "push" then return -dx, -dy end
    return dx, dy
end

local directions = {
    eats = 1,
    bars = 1,
    bumped = 1,
    pushed = 1,
    breakable = 1,
    imaginary = 1,
    rammed = 2,
    ate = 2,
    force = struck,
    resist = function(_, dx, dy, action)
        return struck(dx, dy, action)
    end,
    swappable = function(dx, dy)
        return -dx, -dy
    end,
    pushable = function(dx, dy, _, _, gx, gy)
        return gx or dx, gy or dy
    end
}

local delegates = {}

for name, direction in pairs(directions) do
    if type(direction) == "number" then
        local index = direction
        direction = function(...)
            return select(index, ...), (select(index + 1, ...))
        end
    end

    delegates[name] = function(self, ...)
        local side = self:_mimicked(direction(...))
        if side then return side[name](side, ...) end
        return getmetatable(self)[name](self, ...)
    end
end

local Mimic = {}

function Mimic.install(cell)
    for name, delegate in pairs(delegates) do
        cell[name] = delegate
    end
end

return Mimic
