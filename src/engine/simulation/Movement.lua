local constants = require("src/constants")
local utils = require("src/utils")

local none = {}

local function slot(width, x, y)
    return (y - 1) * width + x
end

local function key(width, x, y, dx, dy)
    return slot(width, x, y) * 5 + dx + 2 * dy
end

local function extend(cell, move, own)
    local path = cell.path
    own = own or #move.via > 0

    for _, point in ipairs(move.via) do
        path[#path + 1] = point
    end

    local size = #path
    if not own and size > 1 and (cell.own or 0) < 2 then
        local last = path[size]
        last[1], last[2] = move.x, move.y
    else
        path[size + 1] = { move.x, move.y }
    end

    if own then cell.own = (cell.own or 0) + #move.via + 1 end
end

local Movement = {}
Movement.__index = Movement

function Movement.new(data)
    local self = setmetatable({}, Movement)
    self.simulator = data.simulator
    self.grid = data.simulator.grid
    self.pool = {}
    self.top = 0
    self.stamp = 0
    self.dead = {}
    self.probes = {}
    self.queue = {}
    self.moves = 0
    return self
end

function Movement:_take()
    local top = self.top + 1
    self.top = top

    local move = self.pool[top]
    if not move then
        move = {}
        self.pool[top] = move
    end
    move.action, move.pushed = nil, nil
    return move
end

function Movement:_seal(chain, first)
    local dead, grid = self.dead, self.grid

    for i = #chain, first + 1, -1 do
        local move = chain[i]
        if move.via ~= none then return end
        dead[key(grid.width, move.cell.x, move.cell.y, move.ox, move.oy)] = grid.version
    end
end

function Movement:_open(x, y, dx, dy, action)
    local cell = self.grid:get(x, y)
    if cell then return cell:eats(dx, dy, action) end
    return self.grid:bounds(x, y)
end

function Movement:_jammed(move)
    local cell = self.grid:get(move.x, move.y)
    return cell ~= nil and not cell:eats(move.dx, move.dy) and cell:eats(move.dx, move.dy, "pull")
end

function Movement:_reach(move)
    local cell = self.grid:get(move.x, move.y)
    if cell == move.cell then return true end

    local open = self:_open(move.x, move.y, move.dx, move.dy, move.action)
    if not open and cell then self:_bump(cell, move.dx, move.dy) end
    return open
end

function Movement:_absorb(eater, cell, dx, dy, action)
    eater.simulator = self.simulator
    eater:absorb(cell, dx, dy, action)
end

function Movement:_spawn(clone, front, origin)
    local grid = self.grid
    clone.born = true
    clone.path = { { origin[1], origin[2] } }
    extend(clone, front)
    grid:touch(clone)

    local occupant = grid:get(front.x, front.y)
    if occupant then
        clone.x, clone.y = front.x, front.y
        table.insert(self.simulator.dying, clone)
        self:_absorb(occupant, clone, front.dx, front.dy)
    else
        grid:set(front.x, front.y, clone)
    end
end

function Movement:_step(x, y, dx, dy, reverse, moved)
    local grid = self.grid
    local via, turn = none, 0

    for _ = 1, constants.simulator.hops do
        x, y = x + dx, y + dy

        local cell = grid:get(x, y)
        local free = cell and not (moved and moved[cell])
        local nx, ny, spin, halt, jx, jy
        if free and cell.lookup.jump then jx, jy = cell:jump(dx, dy, x, y) end

        if jx then nx, ny, spin = dx, dy, 0
        elseif free and cell.lookup.divert then nx, ny, spin, halt = cell:divert(dx, dy, reverse) end

        if halt then dx, dy, nx, turn = nx, ny, nil, turn + spin end
        if not nx then return x, y, dx, dy, reverse and -turn or turn, via, cell, halt end

        if via == none then via = {} end
        table.insert(via, reverse and 1 or #via + 1, { x, y })
        if jx then x, y = jx, jy end
        dx, dy, turn = nx, ny, turn + spin
    end
end

function Movement:_route(x, y, dx, dy, reverse, moved)
    local nx, ny, ndx, ndy, turn, via, target, halt = self:_step(x, y, dx, dy, reverse, moved)
    if not nx then return end

    local move = self:_take()
    move.x, move.y, move.dx, move.dy = nx, ny, ndx, ndy
    move.ox, move.oy, move.turn, move.via, move.target, move.halt = dx, dy, turn, via, target, halt
    return move
end

function Movement:_bump(cell, dx, dy)
    if self.dry then return end

    cell.simulator = self.simulator
    cell:bump(dx, dy)
end

function Movement:_line(x, y, dx, dy, force, chain, bare)
    local grid, dead = self.grid, self.dead
    local width, version = grid.width, grid.version
    chain = chain or {}

    self.stamp = self.stamp + 1
    local stamp, first = self.stamp, #chain
    for _, move in ipairs(chain) do
        move.cell.walked = stamp
    end

    local cell = grid:get(x, y)
    while true do
        if not (cell or grid:bounds(x, y)) then return self:_seal(chain, first) end
        if not cell or cell:eats(dx, dy) then return chain end
        if cell.walked == stamp then return cell == chain[1].cell and chain or nil end

        local pushable = cell:pushable(dx, dy, bare and #chain == first)
        if not pushable then self:_bump(cell, dx, dy) end
        if not pushable or dead[key(width, x, y, dx, dy)] == version then return self:_seal(chain, first) end

        force = force + cell:force(dx, dy, "push")
        if force <= 0 then return end

        local nx, ny, ndx, ndy, turn, via, target = self:_step(x, y, dx, dy)
        if not nx then return end

        cell.walked = stamp

        local move = self:_take()
        move.cell, move.x, move.y, move.dx, move.dy, move.pushed = cell, nx, ny, ndx, ndy, true
        move.ox, move.oy, move.turn, move.via = dx, dy, turn, via
        chain[#chain + 1] = move

        x, y, dx, dy, cell = nx, ny, ndx, ndy, target
    end
end

function Movement:_carry(cell, x, y, dx, dy, action)
    local move = self:_take()
    move.cell, move.x, move.y, move.dx, move.dy, move.action = cell, x, y, dx, dy, action
    move.turn, move.via = 0, none
    return move
end

function Movement:_spoil(chain, from, last, turn)
    if last and turn ~= 0 then last:rotate(turn) end

    for i = #chain, from, -1 do
        local entry = chain[i]
        if entry.turn ~= 0 then entry.cell:rotate(entry.turn) end
        chain[i] = nil
    end
end

function Movement:_rows(front, force)
    local grid, rows = self.grid, {}
    local x, y, dx, dy = front.x, front.y, front.dx, front.dy
    local bare = true

    for _ = 1, constants.grid.limits.max do
        if not grid:bounds(x, y) then break end

        local chain = self:_line(x, y, dx, dy, force, nil, bare)
        if not chain then break end

        for _, move in ipairs(chain) do
            rows[#rows + 1] = move
        end

        local last = chain[#chain]
        if last then x, y, dx, dy = last.x, last.y, last.dx, last.dy end
        if grid:get(x, y) then break end

        local gap = self:_route(x, y, dx, dy)
        if not gap then break end

        x, y, dx, dy, bare = gap.x, gap.y, gap.dx, gap.dy, false
    end
    return rows
end

function Movement:_trail(chain, x, y, dx, dy, force, row)
    local size, seen, taken, width = #chain, {}, {}, self.grid.width
    for _, move in ipairs(chain) do
        seen[move.cell] = true
        taken[slot(width, move.x, move.y)] = true
    end

    local wx, wy = -dx, -dy
    while true do
        local walk = self:_route(x, y, wx, wy, true)
        while row and walk and not walk.target and self.grid:bounds(walk.x, walk.y) do
            walk = self:_route(walk.x, walk.y, walk.dx, walk.dy, true)
        end

        local cell = walk and walk.target
        if not cell or seen[cell] or cell:eats(walk.dx, walk.dy) then return true end

        local ox, oy = -walk.dx, -walk.dy
        if not cell:pushable(ox, oy) then return true end

        force = force + cell:force(ox, oy, "pull")
        if force <= 0 then
            self:_spoil(chain, size + 1, cell, walk.turn)
            return false
        end

        seen[cell] = true

        local forward = self:_route(walk.x, walk.y, ox, oy, false, seen)
        if not forward or taken[slot(width, forward.x, forward.y)] then return true end

        if walk.halt then
            if not self:_open(forward.x, forward.y, forward.dx, forward.dy) then return true end
        elseif walk.via ~= none and (forward.x ~= x or forward.y ~= y) then
            return true
        end

        local entry = self:_take()
        entry.cell, entry.x, entry.y, entry.dx, entry.dy = cell, forward.x, forward.y, forward.dx, forward.dy
        entry.ox, entry.oy, entry.turn, entry.via = ox, oy, forward.turn, forward.via
        chain[#chain + 1] = entry
        taken[slot(width, forward.x, forward.y)] = true

        x, y, wx, wy = walk.x, walk.y, walk.dx, walk.dy
    end
end

function Movement:_drive(chain, action)
    for _, move in ipairs(chain) do
        if move.cell:driven(move.ox, move.oy, action) then
            move.cell.updated = self.simulator.time.tick
        end
    end
end

function Movement:_shift(chain, silent)
    local grid, subtick = self.grid, self.simulator.time.subtick
    self.moves = self.moves + #chain

    for _, move in ipairs(chain) do
        grid:set(move.cell.x, move.cell.y)
    end

    for _, move in ipairs(chain) do
        local occupant = grid:get(move.x, move.y)
        move.eater = occupant and occupant:eats(move.dx, move.dy, move.action) and occupant or nil
    end

    for i, move in ipairs(chain) do
        local cell = move.cell
        if not cell.path then
            cell.path = { { cell.x, cell.y } }
            grid:touch(cell)
        end
        local own = not silent and i == 1
        extend(cell, move, own and cell.leg ~= subtick)
        if own then cell.leg = subtick end

        if move.turn ~= 0 then cell:rotate(move.turn) end
        if move.pushed then cell:pushed(move.ox, move.oy) end

        if move.eater then
            table.insert(self.simulator.dying, cell)
            self:_absorb(move.eater, cell, move.dx, move.dy, move.action)
        else
            grid:set(move.x, move.y, cell)
        end
    end
end

function Movement:_pair(chain, ax, ay, bx, by, forced, heading)
    local grid = self.grid
    local a, b = grid:get(ax, ay), grid:get(bx, by)
    if not ((a or grid:bounds(ax, ay)) and (b or grid:bounds(bx, by))) then return false end

    local adx, ady, bdx, bdy = utils.sign(bx - ax), utils.sign(by - ay)
    bdx, bdy = -adx, -ady
    if heading then adx, ady, bdx, bdy = unpack(heading) end

    local meeting = a and b and not forced
    local aEats = meeting and b:swappable(-adx, -ady) and a:eats(bdx, bdy, "swap")
    local bEats = meeting and not aEats and a:swappable(-bdx, -bdy) and b:eats(adx, ady, "swap")
    if not forced and (a and not aEats and not a:swappable(-bdx, -bdy) or b and not bEats and not b:swappable(-adx, -ady)) then return false end

    if a and not aEats then chain[#chain + 1] = self:_carry(a, bx, by, adx, ady, meeting and "swap" or nil) end
    if b and not bEats then chain[#chain + 1] = self:_carry(b, ax, ay, bdx, bdy, meeting and "swap" or nil) end
    return true, aEats or bEats
end

function Movement:nudge(x, y, dx, dy)
    local nudger = self.grid:get(x, y)
    if not nudger then return false end

    self.top = 0
    local move = self:_route(x, y, dx, dy)
    if not move then return false end

    move.cell, move.action = nudger, "pull"
    if not self:_reach(move) then return false end

    self:_shift({ move })
    return true
end

function Movement:push(x, y, dx, dy, force)
    local pusher = self.grid:get(x, y)
    if not pusher then return false end

    force = (force or constants.force.push) + pusher:force(dx, dy, "push")
    if force <= 0 then return false end

    self.top = 0
    local move = self:_route(x, y, dx, dy)
    if not move then return false end

    move.cell = pusher
    local chain = { move }
    if not self:_line(move.x, move.y, move.dx, move.dy, force, chain) then return false end

    self:_drive(chain, "push")
    self:_shift(chain)
    return true
end

function Movement:_pull(x, y, dx, dy, force, passive, row)
    local puller = self.grid:get(x, y)
    if not puller then return false end

    self.top = 0
    local move = self:_route(x, y, dx, dy)
    if not move then return false end

    move.cell, move.action = puller, "pull"
    if not self:_reach(move) then return false end

    force = (force or constants.force.pull) + puller:force(dx, dy, "pull")
    if force <= 0 then return false end

    local chain = { move }
    if not self:_trail(chain, x, y, dx, dy, force, row) then
        local eater = self.grid:get(move.x, move.y)
        if not eater then return false end

        puller:rotate(move.turn, true)
        self:_absorb(eater, puller, move.dx, move.dy, "pull")
        puller:rotate(-move.turn, true)
        return false
    end

    if not passive then self:_drive(chain, "pull") end
    self:_shift(chain, passive)
    return true
end

function Movement:pull(x, y, dx, dy, force)
    return self:_pull(x, y, dx, dy, force)
end

function Movement:attract(x, y, dx, dy, force, row)
    local grid = self.grid
    local cell = grid:get(x, y)

    while row and not cell and grid:bounds(x, y) do
        x, y = x - dx, y - dy
        cell = grid:get(x, y)
    end
    if not (cell and cell:pushable(dx, dy)) then return false end

    return self:_pull(x, y, dx, dy, force, true, row)
end

function Movement:advance(x, y, dx, dy)
    local advancer = self.grid:get(x, y)
    if not advancer then return false end

    local push = constants.force.push + advancer:force(dx, dy, "push")
    local pull = constants.force.pull + advancer:force(dx, dy, "pull")

    self.top = 0
    local move = self:_route(x, y, dx, dy)
    if not move then return false end

    move.cell = advancer
    local chain = { move }
    if not (push > 0 and self:_line(move.x, move.y, move.dx, move.dy, push, chain)) then
        if self:_jammed(move) then return true end

        return self:pull(x, y, dx, dy)
    end

    self:_trail(chain, x, y, dx, dy, pull)
    self:_drive(chain, "push")
    self:_shift(chain)
    return true
end

function Movement:_flanks(chain, x, y, dx, dy, force, skew)
    local seen = {}
    for _, move in ipairs(chain) do
        seen[move.cell] = true
    end

    skew = skew or 0
    local scale = skew * skew + 1

    for _, side in ipairs({ 1, -1 }) do
        local cx, cy, sx, sy = x, y, skew * dx - side * dy, skew * dy + side * dx

        for _ = 1, constants.grid.limits.max do
            local walk = self:_route(cx, cy, sx, sy)
            local cell = walk and walk.target
            if not cell or seen[cell] then break end

            local fx = (skew * walk.dx + side * walk.dy) / scale
            local fy = (skew * walk.dy - side * walk.dx) / scale
            local move = self:_route(walk.x, walk.y, fx, fy)
            if not (move and cell:pushable(fx, fy) and self:_open(move.x, move.y, move.dx, move.dy)) then break end

            force = force + cell:force(fx, fy, "grab")
            if force <= 0 then return false end

            move.cell = cell
            seen[cell] = true
            chain[#chain + 1] = move
            cx, cy, sx, sy = walk.x, walk.y, walk.dx, walk.dy
        end
    end
    return true
end

function Movement:grab(x, y, dx, dy, skew)
    local grabber = self.grid:get(x, y)
    if not grabber then return false end

    self.top = 0
    local move = self:_route(x, y, dx, dy)
    if not move then return false end

    move.cell, move.action = grabber, "pull"
    if not self:_reach(move) then return false end

    local force = constants.force.grab + grabber:force(dx, dy, "grab")
    local chain = { move }
    if force <= 0 or not self:_flanks(chain, x, y, dx, dy, force, skew) then return false end

    self:_drive(chain, "grab")
    self:_shift(chain)
    return true
end

function Movement:flank(x, y, dx, dy, skew)
    self.top = 0
    local chain = {}
    if not self:_flanks(chain, x, y, dx, dy, constants.force.strength, skew) then return false end

    self:_drive(chain, "grab")
    self:_shift(chain, true)
    return true
end

function Movement:swap(ax, ay, bx, by, heading)
    self.top = 0
    local chain = {}
    local mover = self.grid:get(ax, ay)
    local paired, eaten = self:_pair(chain, ax, ay, bx, by, false, heading)
    if not paired or #chain == 0 then return false end

    self:_shift(chain, true)
    if mover and not eaten then
        mover.simulator = self.simulator
        mover:swapped(heading and heading[1] or utils.sign(bx - ax), heading and heading[2] or utils.sign(by - ay))
    end
    return not eaten
end

function Movement:exchange(pairs)
    self.top = 0
    local chain = {}

    for _, pair in ipairs(pairs) do
        if not self:_pair(chain, pair[1], pair[2], pair[3], pair[4], true) then return false end
    end

    self:_shift(chain, true)
    return true
end

function Movement:cycle(points)
    local grid = self.grid
    local chain = {}
    self.top = 0

    for i, from in ipairs(points) do
        if not grid:bounds(from[1], from[2]) then return false end

        local cell = grid:get(from[1], from[2])
        if cell then
            local to = points[i % #points + 1]
            local dx, dy = utils.sign(to[1] - from[1]), utils.sign(to[2] - from[2])
            chain[#chain + 1] = self:_carry(cell, to[1], to[2], dx, dy)
        end
    end

    self:_shift(chain, true)
    return true
end

function Movement:look(x, y, dx, dy, reverse)
    self.top = 0

    local move = self:_route(x, y, dx, dy, reverse)
    return move and (self.grid:bounds(move.x, move.y) or self.grid.edge) and move
end

function Movement:generate(x, y, dx, dy, options)
    local grid = self.grid
    local generator = grid:get(x, y)
    if not generator then return false end

    self.top = 0
    options = options or {}
    local sx, sy = -dx, -dy
    if options.source then
        local facing = constants.directions[options.source]
        sx, sy = facing[1], facing[2]
    end

    local back = self:_route(x, y, sx, sy, true)
    local source = back and grid:get(back.x, back.y)
    local front = self:_route(x, y, dx, dy)
    if not (source and source:generatable() and front) then return false end

    local chain = self:_line(front.x, front.y, front.dx, front.dy, constants.force.generate)
    if not chain then return false end

    if #chain > 0 then self:_shift(chain, true) end

    local class, props, rotation = source:generated()
    if not class then return true end

    local origin = generator.path and generator.path[1] or { x, y }
    local turn = back.turn + front.turn + (options.turn or 0)

    local clone = class:new({ rotation = rotation or source.rotation, props = props })
    clone:rotate(turn, true)
    clone.updated = source.updated
    clone.ran = source.ran
    self:_spawn(clone, front, origin)

    return true
end

function Movement:clear(x, y, dx, dy)
    local probe = key(self.grid.width, x, y, dx, dy)
    if self.probes[probe] then return false end

    local front = self:_route(x, y, dx, dy)
    if not front then return false end

    local dry = self.dry
    self.probes[probe], self.dry = true, true
    local chain = self:_line(front.x, front.y, front.dx, front.dy, constants.force.generate)
    self.probes[probe], self.dry = nil, dry
    return chain ~= nil
end

function Movement:release(x, y, dx, dy, cell, mode)
    self.top = 0
    local front = self:_route(x, y, dx, dy)
    if not front then return false end

    local chain = self:_line(front.x, front.y, front.dx, front.dy, constants.force.generate)
    if not chain then return false end

    if #chain > 0 then
        if mode == "eject" then self:_drive(chain, "push") end
        self:_shift(chain, true)
    end

    if mode ~= "keep" then cell:rotate(front.turn, true) end
    if mode == "eject" then cell.updated = self.simulator.time.tick end

    self:_spawn(cell, front, { x, y })
    return true
end

function Movement:repel(x, y, dx, dy, force, row)
    self.top = 0
    local front = self:_route(x, y, dx, dy)
    if not front then return false end

    force = constants.force.push + (force or constants.force.strength)

    local chain = row and self:_rows(front, force) or self:_line(front.x, front.y, front.dx, front.dy, force, nil, true)
    if not chain then return false end

    local cell = self.grid:get(front.x, front.y)
    if cell and #chain == 0 then self:_bump(cell, front.dx, front.dy) end

    self:_shift(chain, true)
    return front
end

function Movement:place(x, y, cell)
    local target = self.grid:get(x, y)
    if target then
        target.simulator = self.simulator
        target:kill()
    end

    cell.grow = 0
    self.grid:set(x, y, cell)
    self.grid:touch(cell)
end

function Movement:transform(x, y, dx, dy, cell)
    self.top = 0

    local front = self:_route(x, y, dx, dy)
    local target = front and front.target
    if not (target and target:transformable()) then return false end

    cell:rotate(front.turn, true)
    self:place(front.x, front.y, cell)
    return true
end

function Movement:defer(action)
    self.queue[#self.queue + 1] = action
end

function Movement:flush()
    for _ = 1, constants.simulator.flushes do
        local queue = self.queue
        if #queue == 0 then return end

        self.queue = {}
        for _, action in ipairs(queue) do
            action()
        end
    end
end

return Movement
