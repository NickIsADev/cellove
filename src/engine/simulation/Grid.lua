local constants = require("src/constants")

local Grid = {}
Grid.__index = Grid

function Grid.new(data)
    data = data or {}

    local self = setmetatable({}, Grid)
    self.width = data.width or constants.grid.default.width
    self.height = data.height or constants.grid.default.height
    self:clear()
    return self
end

function Grid:_index(x, y)
    return (y - 1) * self.width + x
end

function Grid:_coordinates(index)
    return (index - 1) % self.width + 1, math.floor((index - 1) / self.width) + 1
end

function Grid:_count(cell, amount)
    for subtick in pairs(getmetatable(cell).lookup.subtick) do
        self.counts[subtick] = (self.counts[subtick] or 0) + amount
    end
end

function Grid:_around(x, y, distance, diamond, callback)
    for dy = -distance, distance do
        for dx = -distance, distance do
            local nx, ny = x + dx, y + dy
            local reached = not diamond or math.abs(dx) + math.abs(dy) <= distance

            if reached and (dx ~= 0 or dy ~= 0) and self:bounds(nx, ny) then
                callback(self.cells[self:_index(nx, ny)], nx, ny, dx, dy)
            end
        end
    end
end

function Grid:bounds(x, y)
    return x > 0 and x <= self.width and y > 0 and y <= self.height
end

function Grid:get(x, y)
    if not self:bounds(x, y) then return end
    return self.cells[self:_index(x, y)]
end

function Grid:neighbors(x, y, distance, callback)
    self:_around(x, y, distance, true, callback)
end

function Grid:surrounding(x, y, distance, callback)
    self:_around(x, y, distance, false, callback)
end

function Grid:has(subtick)
    return (self.counts[subtick] or 0) > 0
end

function Grid:touch(cell)
    self.touched[#self.touched + 1] = cell
end

function Grid:set(x, y, cell)
    if not self:bounds(x, y) then return false end

    local index = self:_index(x, y)
    local old = self.cells[index]
    if old then self:_count(old, -1) end

    self.cells[index] = cell

    if cell then
        self:_count(cell, 1)
        cell.x, cell.y, cell.grid = x, y, self
    end

    return true
end

function Grid:resize(width, height)
    self:clear()
    self.width = width
    self.height = height
end

function Grid:reshape(width, height)
    local kept = {}
    for i = 1, self.width * self.height do
        local cell = self.cells[i]
        if cell and cell.x <= width and cell.y <= height then kept[#kept + 1] = cell end
    end

    self:clear()
    self.width, self.height = width, height
    for _, cell in ipairs(kept) do
        self:set(cell.x, cell.y, cell)
    end
end

function Grid:clear()
    self.cells = {}
    self.counts = {}
    self.touched = {}
end

function Grid:snapshot()
    local cells = {}
    for i = 1, self.width * self.height do
        local cell = self.cells[i]
        if cell then
            cells[#cells + 1] = {
                class = getmetatable(cell),
                rotation = cell.rotation,
                props = cell.props,
                x = cell.x,
                y = cell.y
            }
        end
    end
    return {
        width = self.width,
        height = self.height,
        cells = cells
    }
end

function Grid:populate(cells)
    for _, entry in ipairs(cells) do
        self:set(entry.x, entry.y, entry.class:new({ rotation = entry.rotation, props = entry.props }))
    end
end

function Grid:save()
    self.saved = self:snapshot()
end

function Grid:reset()
    self:clear()
    self:populate(self.saved.cells)
end

return Grid
