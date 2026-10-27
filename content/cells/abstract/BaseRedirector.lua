local BaseCell = require("content/cells/abstract/BaseCell")

local BaseRedirector = setmetatable({
    categories = { "rotators", "redirectors" },
    subtick = { 1 },
    outputs = { 0, 1, 2, 3 },
    sides = { orthogonal = true },
    redirector = true
}, { __index = BaseCell })
BaseRedirector.__index = BaseRedirector

function BaseRedirector:_bearing(dx, dy)
    return dx > 0 and 0 or dy > 0 and 1 or dx < 0 and 2 or 3
end

function BaseRedirector:_reaches(dx, dy)
    local class = getmetatable(self)
    if dx ~= 0 and dy ~= 0 then return class.sides.diagonal end

    return class.sides.orthogonal and class.lookup.outputs[(self:_bearing(dx, dy) - self.rotation) % 4]
end

function BaseRedirector:_facing(dx, dy)
    local class = getmetatable(self)
    if class.random then return math.random(0, 3) end
    if not class.around then return self.rotation end

    return (self:_bearing(dx, dy) + class.around) % 4
end

function BaseRedirector:update()
    self:surrounding(1, function(cell, _, _, dx, dy)
        if cell and not cell.redirector and self:_reaches(dx, dy) then
            cell:rotate(self:_facing(dx, dy) - cell.rotation)
        end
    end)
end

return BaseRedirector
