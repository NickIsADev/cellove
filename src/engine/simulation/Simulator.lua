local Grid = require("src/engine/simulation/Grid")
local Movement = require("src/engine/simulation/Movement")
local Events = require("src/engine/modding/Events")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")

local function range(size, direction, rear)
    if (rear and direction or -direction) > 0 then return 1, size, 1 end
    return size, 1, -1
end

local Simulator = {}
Simulator.__index = Simulator

function Simulator.new(data)
    local self = setmetatable({}, Simulator)
    self.order = data.subticks or { 0 }
    self.maxSubticks = #self.order
    self.rear = data.rear or {}
    self.sweeps = data.sweeps or {}
    self.grid = Grid.new(data)
    self.grid.simulator = self
    self.movement = Movement.new({ simulator = self })
    self.interval = data.interval or constants.simulator.interval
    self.profile = { sim = 0, post = 0, memory = 0, moves = 0 }
    self:_rewind()
    return self
end

function Simulator:_rewind()
    self.paused = true
    self.timer = 0
    self.dying = {}
    self.movement.queue = {}
    self.time = {
        tick = 0,
        subtick = 0,
        pass = 0
    }
end

function Simulator:_sync()
    self.dying = {}

    for _, cell in ipairs(self.grid.touched) do
        cell.path, cell.own, cell.turn, cell.born, cell.grow, cell.shrink, cell.arriving = nil, nil, 0, nil, nil, nil, nil
    end
    self.grid.touched = {}
end

function Simulator:_sweep(subtick, direction, sweep)
    local grid = self.grid
    local columns = sweep.columns
    local lines = grid:lines(subtick, columns and "cols" or "rows")
    if not lines then return end

    local cells, width = grid.cells, grid.width
    local outerFrom, outerTo, outerStep = range(columns and width or grid.height, columns and sweep.x or sweep.y, true)
    local innerFrom, innerTo, innerStep = range(columns and grid.height or width, columns and sweep.y or sweep.x, true)

    for outer = outerFrom, outerTo, outerStep do
        if (lines[outer] or 0) > 0 then
            for inner = innerFrom, innerTo, innerStep do
                local x, y = inner, outer
                if columns then x, y = outer, inner end

                local cell = cells[(y - 1) * width + x]
                if cell then self:run(cell, subtick, direction) end
            end
        end
    end
end

function Simulator:_scan(subtick, direction)
    local sweeps = self.sweeps[subtick]
    if sweeps then
        local sweep = sweeps[direction]
        return sweep and self:_sweep(subtick, direction, sweep)
    end

    local grid = self.grid
    local facing = constants.directions[direction]
    local horizontal = facing[1] ~= 0

    local lines = grid:lines(subtick, horizontal and "cols" or "rows")
    if not lines then return end

    local cells, width, height = grid.cells, grid.width, grid.height
    local outerFrom, outerTo, outerStep = range(horizontal and width or height, horizontal and facing[1] or facing[2], self.rear[subtick])
    local innerFrom, innerTo, innerStep = 1, width, 1
    if horizontal then innerFrom, innerTo, innerStep = height, 1, -1 end

    for outer = outerFrom, outerTo, outerStep do
        if (lines[outer] or 0) > 0 then
            for inner = innerFrom, innerTo, innerStep do
                local cell = cells[horizontal and (inner - 1) * width + outer or (outer - 1) * width + inner]
                if cell then self:run(cell, subtick, direction) end
            end
        end
    end
end

function Simulator:_changed()
    if #self.dying > 0 then return true end

    for _, cell in ipairs(self.grid.touched) do
        if cell.path or cell.turn ~= 0 then return true end
    end
end

function Simulator:_tick()
    local profile, start, memory = self.profile, love.timer.getTime(), collectgarbage("count")
    self.movement.moves = 0

    repeat
        self:_pass()
    until self.time.subtick % self.maxSubticks == 0 and self.time.pass == 0

    local middle = love.timer.getTime()
    if self:_changed() then Audio.play("tick") end
    Events.emit("simulator:tick", self)

    profile.sim, profile.post = (middle - start) * 1000, (love.timer.getTime() - middle) * 1000
    profile.memory, profile.moves = (collectgarbage("count") - memory) / 1024, self.movement.moves
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
    self:_scan(self.order[(time.subtick - 1) % self.maxSubticks + 1], passes[time.pass])
    if time.pass == #passes then time.pass = 0 end
end

function Simulator:run(cell, subtick, direction)
    local class = getmetatable(cell)
    local lookup = class.lookup
    if not lookup.subtick[subtick] then return end

    local multi = false
    if class.directional then
        if not lookup.outputs[(direction - cell.rotation) % 4] then return end
        multi = #class.outputs > 1
    elseif direction ~= constants.simulator.scan then return end

    local stamp = self.time.subtick
    if cell.updated == self.time.tick then return end

    if multi then
        cell.dirs = cell.dirs or {}
        if cell.dirs[direction] == stamp then return end
        cell.dirs[direction] = stamp
    else
        if cell.ran == stamp then return end
        cell.ran = stamp
    end

    cell.simulator = self
    cell:update(subtick, direction)
    self.movement:flush()
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

function Simulator:click(x, y, button)
    local cell = self.grid:get(x, y)
    if not (cell and self:started()) then return false end

    cell.simulator = self
    return cell:click(button)
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
    self.grid:resize(data.width, data.height, data.border)
    self.grid:populate(data.cells)
    self.grid:save()
end

function Simulator:reset()
    self:_rewind()
    self.grid:reset()
end

return Simulator
