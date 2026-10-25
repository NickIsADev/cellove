local Simulator = require("src/engine/simulation/Simulator")
local Markers = require("src/engine/simulation/Markers")

local Puzzle = {}
Puzzle.__index = Puzzle

function Puzzle.new(data)
    local self = setmetatable({}, Puzzle)
    local subticks, rear = data.registry:subticks()
    self.simulator = Simulator.new({ subticks = subticks, rear = rear })
    self.markers = Markers.new()

    data.settings:listen("tickSpeed", function(tickSpeed)
        self.simulator.interval = 1 / tickSpeed
    end)
    return self
end

function Puzzle:load(data)
    self.simulator:load(data)
    self.markers:load(data.markers)
    self.held = nil
end

function Puzzle:placeable(x, y)
    return self.markers:placeableAt(x, y) ~= nil
end

function Puzzle:movable(x, y)
    return not self.simulator:started() and self:placeable(x, y) and self.simulator.grid:get(x, y) ~= nil
end

function Puzzle:lift(x, y)
    if not self:movable(x, y) then return false end

    local grid = self.simulator.grid
    self.held = { cell = grid:get(x, y), x = x, y = y }
    grid:set(x, y)
    return true
end

function Puzzle:drop(x, y)
    local held, grid = self.held, self.simulator.grid
    if not self:placeable(x, y) then x, y = held.x, held.y end

    grid:set(held.x, held.y, grid:get(x, y))
    grid:set(x, y, held.cell)
    self.held = nil
    self.simulator:save()
end

function Puzzle:cancel()
    if self.held then self:drop(self.held.x, self.held.y) end
end

function Puzzle:remaining()
    local grid = self.simulator.grid
    local count = self.held and self.held.cell.hostile and 1 or 0

    for index = 1, grid.width * grid.height do
        local cell = grid.cells[index]
        if cell and cell.hostile then count = count + 1 end
    end
    return count
end

function Puzzle:solved()
    return self.simulator:started() and self:remaining() == 0
end

return Puzzle
