local constants = require("src/constants")

local layers, main = constants.grid.layers, constants.grid.layer

local function tally(lines, index, amount)
    lines[index] = (lines[index] or 0) + amount
end

local Grid = {}
Grid.__index = Grid

function Grid.new(data)
    data = data or {}

    local self = setmetatable({}, Grid)
    self.width = data.width or constants.grid.default.width
    self.height = data.height or constants.grid.default.height
    self.version = 0
    self:clear()
    return self
end

function Grid:_index(x, y)
    return (y - 1) * self.width + x
end

function Grid:_coordinates(index)
    return (index - 1) % self.width + 1, math.floor((index - 1) / self.width) + 1
end

function Grid:_count(cell, x, y, amount)
    for _, subtick in ipairs(cell.subtick) do
        local count = self.counts[subtick] or { rows = {}, cols = {} }

        tally(count.rows, y, amount)
        tally(count.cols, x, amount)
        self.counts[subtick] = count
    end
end

function Grid:_around(x, y, distance, diamond, callback, layer)
    local stack = self.stacks[layer or main]

    for dy = -distance, distance do
        for dx = -distance, distance do
            local nx, ny = x + dx, y + dy
            local reached = not diamond or math.abs(dx) + math.abs(dy) <= distance

            if reached and (dx ~= 0 or dy ~= 0) and self:bounds(nx, ny) then
                callback(stack[self:_index(nx, ny)], nx, ny, dx, dy)
            end
        end
    end
end

function Grid:bounds(x, y)
    return x > 0 and x <= self.width and y > 0 and y <= self.height
end

function Grid:get(x, y, layer)
    if not self:bounds(x, y) then return not layer and self.edge or nil end
    return (layer and self.stacks[layer] or self.cells)[self:_index(x, y)]
end

function Grid:top(x, y)
    if not self:bounds(x, y) then return end

    local index = self:_index(x, y)
    for i = #layers, 1, -1 do
        local cell = self.stacks[layers[i]][index]
        if cell then return cell end
    end
end

function Grid:barred(x, y, dx, dy, action, mover)
    if self.extra == 0 or not self:bounds(x, y) then return false end

    local index = self:_index(x, y)
    for _, stack in ipairs(self.layered) do
        local cell = stack[index]
        if cell and cell:bars(dx, dy, action, mover) then return cell end
    end
    return false
end

function Grid:swallower(x, y, dx, dy, action, mover)
    if self.extra == 0 or not self:bounds(x, y) then return end

    local index = self:_index(x, y)
    for _, stack in ipairs(self.layered) do
        local cell = stack[index]
        if cell and cell:eats(dx, dy, action, mover) then return cell end
    end
end

function Grid:neighbors(x, y, distance, callback, layer)
    self:_around(x, y, distance, true, callback, layer)
end

function Grid:surrounding(x, y, distance, callback, layer)
    self:_around(x, y, distance, false, callback, layer)
end

function Grid:flood(x, y, accept, layer)
    local seen, points = { [self:_index(x, y)] = true }, { { x, y } }

    for _, point in ipairs(points) do
        self:neighbors(point[1], point[2], 1, function(cell, nx, ny)
            local index = self:_index(nx, ny)
            if seen[index] or not accept(cell, nx, ny) then return end

            seen[index] = true
            points[#points + 1] = { nx, ny }
        end, layer)
    end
    return points
end

function Grid:scanned()
    return self.extra > 0 and self.order or self.front
end

function Grid:lines(subtick, axis)
    local count = self.counts[subtick]
    return count and count[axis]
end

function Grid:invalidate()
    self.version = self.version + 1
end

function Grid:touch(cell)
    self.version = self.version + 1
    self.touched[#self.touched + 1] = cell
end

function Grid:_put(x, y, cell, layer)
    local stack = self.stacks[layer]
    local index = self:_index(x, y)
    local old = stack[index]

    if old then self:_count(old, x, y, -1) end
    stack[index] = cell
    self.extra = self.extra - (old and 1 or 0) + (cell and 1 or 0)

    if cell then
        self:_count(cell, x, y, 1)
        cell.x, cell.y, cell.grid = x, y, self
    end
    return true
end

function Grid:set(x, y, cell, layer)
    if not self:bounds(x, y) then return false end

    layer = cell and cell.layer or layer or main
    self.version = self.version + 1
    if layer ~= main then return self:_put(x, y, cell, layer) end

    local index = self:_index(x, y)
    local old = self.cells[index]
    if old then self:_count(old, x, y, -1) end

    self.cells[index] = cell
    self.players[index] = cell and cell.player and cell or nil
    self.total = self.total - (old and 1 or 0) + (cell and 1 or 0)

    if cell then
        self:_count(cell, x, y, 1)
        cell.x, cell.y, cell.grid = x, y, self
        if cell.effects then self.effected[cell] = true end
    end

    return true
end

function Grid:resize(width, height, border)
    self:clear()
    self.width = width
    self.height = height
    self:setBorder(border)
end

function Grid:setBorder(border)
    self.version = self.version + 1
    self.border = border
    self.edge = border:new()
    self.edge.fixed, self.edge.anchored, self.edge.grid = true, true, self
    if self.edge.held then self.edge.eats = function() return false end end
    if self.saved then self.saved.border = border end
end

function Grid:reshape(width, height)
    local kept = {}
    for _, layer in ipairs(layers) do
        for i = 1, self.width * self.height do
            local cell = self.stacks[layer][i]
            if cell and cell.x <= width and cell.y <= height then kept[#kept + 1] = cell end
        end
    end

    self:clear()
    self.width, self.height = width, height
    for _, cell in ipairs(kept) do
        self:set(cell.x, cell.y, cell)
    end
end

function Grid:clear()
    self.version = self.version + 1
    self.stacks, self.order, self.layered, self.extra = {}, {}, {}, 0
    for i, layer in ipairs(layers) do
        self.stacks[layer] = {}
        self.order[i] = self.stacks[layer]
        if layer ~= main then self.layered[#self.layered + 1] = self.stacks[layer] end
    end
    self.cells = self.stacks[main]
    self.front = { self.cells }
    self.players = {}
    self.counts = {}
    self.touched = {}
    self.effected = {}
    self.total = 0
end

function Grid:snapshot()
    local cells = {}
    for _, layer in ipairs(layers) do
        for i = 1, self.width * self.height do
            local cell = self.stacks[layer][i]
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
    end
    return {
        width = self.width,
        height = self.height,
        border = self.border,
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
