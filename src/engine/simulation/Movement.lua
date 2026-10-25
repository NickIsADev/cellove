local constants = require("src/constants")

local function extend(path, move, own)
    own = own or #move.via > 0

    for _, point in ipairs(move.via) do
        path[#path + 1] = { point[1], point[2], own }
    end
    path[#path + 1] = { move.x, move.y, own }
end

local Movement = {}
Movement.__index = Movement

function Movement.new(data)
    local self = setmetatable({}, Movement)
    self.simulator = data.simulator
    self.grid = data.simulator.grid
    return self
end

function Movement:_open(x, y, dx, dy)
    if not self.grid:bounds(x, y) then return false end
    local cell = self.grid:get(x, y)
    return not cell or cell:eats(dx, dy)
end

function Movement:_absorb(eater, cell, dx, dy)
    eater.simulator = self.simulator
    eater:absorb(cell, dx, dy)
end

function Movement:_route(x, y, dx, dy, reverse)
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

function Movement:_line(x, y, dx, dy, force, chain)
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

function Movement:_drive(chain, action)
    for _, move in ipairs(chain) do
        if move.cell:driven(move.out[1], move.out[2], action) then
            move.cell.updated = self.simulator.time.tick
        end
    end
end

function Movement:_shift(chain, silent)
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
            table.insert(self.simulator.dying, cell)
            self:_absorb(eaten[move], cell, move.dx, move.dy)
        else
            grid:set(move.x, move.y, cell)
        end
    end
end

function Movement:nudge(x, y, dx, dy)
    local nudger = self.grid:get(x, y)
    if not nudger then return false end

    local move = self:_route(x, y, dx, dy)
    if not move or not self:_open(move.x, move.y, move.dx, move.dy) then return false end

    move.cell = nudger
    self:_shift({ move })
    return true
end

function Movement:push(x, y, dx, dy, force)
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

function Movement:pull(x, y, dx, dy, force)
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

function Movement:generate(x, y, dx, dy, options)
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
        table.insert(self.simulator.dying, clone)
        self:_absorb(occupant, clone, front.dx, front.dy)
    else
        grid:set(front.x, front.y, clone)
    end

    return true
end

return Movement
