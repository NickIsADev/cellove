local Grid = require("src/engine/simulation/Grid")
local Movement = require("src/engine/simulation/Movement")
local Events = require("src/engine/modding/Events")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local function range(size, direction, rear)
    if (rear and direction or -direction) > 0 then return 1, size, 1 end
    return size, 1, -1
end

local Simulator = {}
Simulator.__index = Simulator

function Simulator.new(data)
    local self = setmetatable({}, Simulator)
    self.maxSubticks = data.subticks or constants.simulator.subticks
    self.rear = data.rear or {}
    self.grid = Grid.new(data)
    self.movement = Movement.new({ simulator = self })
    self.interval = data.interval or constants.simulator.interval
    self:_rewind()
    return self
end

function Simulator:_rewind()
    self.paused = true
    self.timer = 0
    self.dying = {}
    self.time = {
        tick = 0,
        subtick = 0,
        pass = 0
    }
end

function Simulator:_run(cell, subtick, direction)
    local class = getmetatable(cell)
    if not utils.has(class.subtick, subtick) then return end

    local key = "any"
    if class.directional then
        if not utils.has(class.outputs, (direction - cell.rotation) % 4) then return end
        if #class.outputs > 1 then key = direction end
    elseif direction ~= constants.simulator.scan then return end

    local stamp = self.time.subtick
    if cell.ran[key] == stamp or (class.drive and cell.updated == self.time.tick) then return end

    cell.ran[key] = stamp
    cell.simulator = self
    cell:update(subtick, direction)
end

function Simulator:_sync()
    self.dying = {}

    for i = 1, self.grid.width * self.grid.height do
        local cell = self.grid.cells[i]
        if cell then
            cell.path = nil
            cell.turn = 0
            cell.born = nil
        end
    end
end

function Simulator:_scan(subtick, direction)
    local grid = self.grid
    local cells, width, height = grid.cells, grid.width, grid.height
    local facing = constants.directions[direction]

    local outerFrom, outerTo, outerStep, outerStride
    local innerFrom, innerTo, innerStep, innerStride
    if facing[1] ~= 0 then
        outerFrom, outerTo, outerStep, outerStride = 1, height, 1, width
        innerFrom, innerTo, innerStep = range(width, facing[1], self.rear[subtick])
        innerStride = 1
    else
        outerFrom, outerTo, outerStep, outerStride = width, 1, -1, 1
        innerFrom, innerTo, innerStep = range(height, facing[2], self.rear[subtick])
        innerStride = width
    end

    for outer = outerFrom, outerTo, outerStep do
        local base = outer * outerStride - width
        for inner = innerFrom, innerTo, innerStep do
            local cell = cells[base + inner * innerStride]
            if cell then self:_run(cell, subtick, direction) end
        end
    end
end

function Simulator:_changed()
    if #self.dying > 0 then return true end

    for i = 1, self.grid.width * self.grid.height do
        local cell = self.grid.cells[i]
        if cell and (cell.path or cell.turn ~= 0) then return true end
    end
end

function Simulator:_tick()
    repeat
        self:_pass()
    until self.time.subtick % self.maxSubticks == 0 and self.time.pass == 0

    if self:_changed() then Audio.play("tick") end
    Events.emit("simulator:tick", self)
end

function Simulator:_pass()
    local time, passes = self.time, constants.simulator.passes

    if time.pass == 0 then
        self:save()
        time.subtick = time.subtick + 1
        if (time.subtick - 1) % self.maxSubticks == 0 then
            time.tick = time.tick + 1
        end
    end

    time.pass = time.pass + 1
    self:_scan((time.subtick - 1) % self.maxSubticks, passes[time.pass])
    if time.pass == #passes then time.pass = 0 end
end

function Simulator:started()
    return not self.paused or self.time.subtick > 0
end

function Simulator:position()
    local time = self.time
    if time.subtick == 0 then return 0, 0, 0 end
    return time.tick, (time.subtick - 1) % self.maxSubticks, time.pass == 0 and #constants.simulator.passes or time.pass
end

function Simulator:progress()
    return math.min(self.timer / self.interval, 1.0)
end

function Simulator:update(dt)
    if self.timer < self.interval then
        self.timer = self.timer + dt
    end

    if not self.paused and self.timer >= self.interval then
        self.timer = self.timer - self.interval
        self:_sync()
        self:_tick()
    end
end

function Simulator:play()
    self.paused = false
end

function Simulator:pause()
    self.paused = true
end

function Simulator:toggle()
    if self.paused then self:play() else self:pause() end
end

function Simulator:step()
    self.paused = true
    self.timer = 0
    self:_sync()
    self:_tick()
end

function Simulator:substep()
    self.paused = true
    self:_sync()
    self:_pass()
end

function Simulator:save()
    if self.time.subtick ~= 0 then return end
    self.grid:save()
end

function Simulator:snapshot()
    return self:started() and self.grid.saved or self.grid:snapshot()
end

function Simulator:load(data)
    self:_rewind()
    self.grid:resize(data.width, data.height)
    self.grid:populate(data.cells)
    self.grid:save()
end

function Simulator:reset()
    self:_rewind()
    self.grid:reset()
end

return Simulator
