local Grid = require("src/engine/simulation/Grid")
local Events = require("src/engine/modding/Events")
local Audio = require("src/engine/audio/Audio")
local constants = require("src/constants")
local utils = require("src/utils")

local function range(size, direction, rear)
    if (rear and direction or -direction) > 0 then return 1, size, 1 end
    return size, 1, -1
end

local function extend(path, move, own)
    own = own or #move.via > 0

    for _, point in ipairs(move.via) do
        path[#path + 1] = { point[1], point[2], own }
    end
    path[#path + 1] = { move.x, move.y, own }
end

local Simulator = {}
Simulator.__index = Simulator

function Simulator.new(data)
    local self = setmetatable({}, Simulator)
    self.maxSubticks = data.subticks or constants.simulator.subticks
    self.rear = data.rear or {}
    self.grid = Grid.new(data)
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

function Simulator:_open(x, y, dx, dy)
    if not self.grid:bounds(x, y) then return false end
    local cell = self.grid:get(x, y)
    return not cell or cell:eats(dx, dy)
end

function Simulator:_absorb(eater, cell, dx, dy)
    eater.simulator = self
    eater:absorb(cell, dx, dy)
end

function Simulator:_route(x, y, dx, dy, reverse)
    local out = { dx, dy }
    local via, turn = {}, 0

    for _ = 1, constants.simulator.hops do
        x, y = x + dx, y + dy

        local cell = self.grid:get(x, y)
        local nx, ny, spin
        if cell then nx, ny, spin = cell:divert(dx, dy, reverse) end

        if not nx then
            return {
                x = x,
                y = y,
                dx = dx,
                dy = dy,
                out = out,
                turn = reverse and -turn or turn,
                via = via
            }
        end

        table.insert(via, reverse and 1 or #via + 1, { x, y })
        dx, dy, turn = nx, ny, turn + spin
    end
end

function Simulator:_line(x, y, dx, dy, force, chain)
    local grid = self.grid
    chain = chain or {}

    local seen = {}
    for _, move in ipairs(chain) do seen[move.cell] = true end

    while true do
        if not grid:bounds(x, y) then return end

        local cell = grid:get(x, y)
        if not cell or cell:eats(dx, dy) then break end
        if seen[cell] or not cell:pushable(dx, dy) then return end

        force = force + cell:force(dx, dy, "push")
        if force <= 0 then return end

        local move = self:_route(x, y, dx, dy)
        if not move then return end

        move.cell, seen[cell] = cell, true
        chain[#chain + 1] = move
        x, y, dx, dy = move.x, move.y, move.dx, move.dy
    end

    return chain
end

function Simulator:_drive(chain, action)
    for _, move in ipairs(chain) do
        if move.cell:driven(move.out[1], move.out[2], action) then
            move.cell.updated = self.time.tick
        end
    end
end

function Simulator:_shift(chain, silent)
    local grid = self.grid

    local moving, eaten = {}, {}
    for _, move in ipairs(chain) do moving[move.cell] = true end
    for _, move in ipairs(chain) do
        local occupant = grid:get(move.x, move.y)
        if occupant and not moving[occupant] and occupant:eats(move.dx, move.dy) then
            eaten[move] = occupant
        end
    end

    for _, move in ipairs(chain) do
        grid:set(move.cell.x, move.cell.y)
    end

    for i, move in ipairs(chain) do
        local cell = move.cell
        cell.path = cell.path or { { cell.x, cell.y } }
        extend(cell.path, move, not silent and i == 1)

        if move.turn ~= 0 then cell:rotate(move.turn) end

        if eaten[move] then
            self.dying[#self.dying + 1] = cell
            self:_absorb(eaten[move], cell, move.dx, move.dy)
        else
            grid:set(move.x, move.y, cell)
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

function Simulator:nudge(x, y, dx, dy)
    local nudger = self.grid:get(x, y)
    if not nudger then return false end

    local move = self:_route(x, y, dx, dy)
    if not move or not self:_open(move.x, move.y, move.dx, move.dy) then return false end

    move.cell = nudger
    self:_shift({ move })
    return true
end

function Simulator:push(x, y, dx, dy, force)
    local pusher = self.grid:get(x, y)
    if not pusher then return false end

    force = (force or constants.force.push) + pusher:force(dx, dy, "push")
    if force <= 0 then return false end

    local move = self:_route(x, y, dx, dy)
    if not move then return false end

    move.cell = pusher
    local chain = self:_line(move.x, move.y, move.dx, move.dy, force, { move })
    if not chain then return false end

    self:_drive(chain, "push")
    self:_shift(chain)
    return true
end

function Simulator:pull(x, y, dx, dy, force)
    local grid = self.grid
    local puller = grid:get(x, y)
    if not puller then return false end

    local move = self:_route(x, y, dx, dy)
    if not move or not self:_open(move.x, move.y, move.dx, move.dy) then return false end

    force = (force or constants.force.pull) + puller:force(dx, dy, "pull")
    if force <= 0 then return false end

    move.cell = puller
    local chain, seen = { move }, { [puller] = true }
    local px, py, wx, wy = x, y, -dx, -dy

    while true do
        local walk = self:_route(px, py, wx, wy, true)
        local cell = walk and grid:get(walk.x, walk.y)
        if not cell or seen[cell] then break end

        local out = { -walk.dx, -walk.dy }
        if not cell:pushable(out[1], out[2]) then break end

        force = force + cell:force(out[1], out[2], "pull")
        if force <= 0 then return false end

        seen[cell] = true
        chain[#chain + 1] = {
            cell = cell,
            x = px,
            y = py,
            dx = -wx,
            dy = -wy,
            out = out,
            turn = walk.turn,
            via = walk.via
        }
        px, py, wx, wy = walk.x, walk.y, walk.dx, walk.dy
    end

    self:_drive(chain, "pull")
    self:_shift(chain)
    return true
end

function Simulator:generate(x, y, dx, dy, options)
    local grid = self.grid
    local generator = grid:get(x, y)
    if not generator then return false end

    options = options or {}
    local sx, sy = -dx, -dy
    if options.source then
        local facing = constants.directions[options.source]
        sx, sy = facing[1], facing[2]
    end

    local back = self:_route(x, y, sx, sy, true)
    local source = back and grid:get(back.x, back.y)
    local front = self:_route(x, y, dx, dy)
    if not source or not front then return false end

    local chain = self:_line(front.x, front.y, front.dx, front.dy, constants.force.generate)
    if not chain then return false end

    if #chain > 0 then self:_shift(chain, true) end
    if not source:generatable() then return true end

    local origin = generator.path and generator.path[1] or { x, y }
    local turn = back.turn + front.turn + (options.turn or 0)

    local clone = getmetatable(source):new({ rotation = source.rotation + turn, props = source.props })
    clone.updated = source.updated
    clone.ran.any = source.ran.any
    clone.born = true
    clone.path = { { origin[1], origin[2] } }
    extend(clone.path, front)

    local occupant = grid:get(front.x, front.y)
    if occupant then
        clone.x, clone.y = front.x, front.y
        self.dying[#self.dying + 1] = clone
        self:_absorb(occupant, clone, front.dx, front.dy)
    else
        grid:set(front.x, front.y, clone)
    end

    return true
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
