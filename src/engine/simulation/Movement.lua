local constants = require("src/constants")
local utils = require("src/utils")

local none = {}
local sides = { 1, -1 }

local function movable(cell, action, dx, dy, bare)
    return cell:pushable(dx, dy, bare, action) and not cell:guarded(action)
end

local function apply(cell, force, dx, dy, action)
    return cell:resist(force + cell:strength(dx, dy, action), dx, dy, action)
end

local function swappable(cell, dx, dy)
    return cell:swappable(dx, dy) and not cell:guarded("swap")
end

local function devours(eater, mover, dx, dy, action)
    if mover and action ~= "swap" and mover:rams(eater, dx, dy, action) then return true end

    return eater:eats(dx, dy, action, mover) and not (eater.destroys and mover and mover:guarded("protect", -dx, -dy))
end

local function rewind(grid, x, y, dx, dy)
    local cell = grid:get(x, y)
    local effect = cell and cell:clinging(dx, dy)

    while effect do
        local other = grid:get(x + dx, y + dy)
        if not (other and other:clinging(-dx, -dy) == effect) then break end
        x, y, cell = x + dx, y + dy, other
    end
    return x, y, cell
end

local function heading(dx, dy)
    return dx > 0 and 0 or dy > 0 and 1 or dx < 0 and 2 or 3
end

local function normals(dx, dy, bend)
    if bend then return { { -dy * bend, dx * bend } } end
    return { { math.abs(dy), -math.abs(dx) }, { -math.abs(dy), math.abs(dx) } }
end

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
    self.anchor = {}
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

function Movement:_barred(x, y, dx, dy, action, mover)
    local barrier = self.grid:barred(x, y, dx, dy, action, mover)
    if barrier then self:_bump(barrier, dx, dy, mover) end
    return barrier
end

function Movement:_open(x, y, dx, dy, action, mover)
    if self:_barred(x, y, dx, dy, action, mover) then return false end

    local cell = self.grid:get(x, y)
    if cell then return devours(cell, mover, dx, dy, action) end
    return self.grid:bounds(x, y)
end

function Movement:_jammed(move)
    local cell = self.grid:get(move.x, move.y)
    return cell ~= nil and not cell:eats(move.dx, move.dy) and cell:eats(move.dx, move.dy, "pull")
end

function Movement:_reach(move)
    local cell = self.grid:get(move.x, move.y)
    if cell == move.cell then return true end

    local open = self:_open(move.x, move.y, move.dx, move.dy, move.action, move.cell)
    if not open and cell then self:_bump(cell, move.dx, move.dy, move.cell) end
    return open
end

function Movement:_absorb(eater, cell, dx, dy, action)
    eater.simulator = self.simulator
    if cell and cell:rams(eater, dx, dy, action) then return cell:ram(eater, dx, dy) end

    return eater:absorb(cell, dx, dy, action)
end

function Movement:_spawn(clone, front, origin)
    local grid = self.grid
    clone.born = true
    clone.path = { { origin[1], origin[2] } }
    extend(clone, front)
    grid:touch(clone)

    local occupant = grid:get(front.x, front.y)
    local cover = grid:swallower(front.x, front.y, front.dx, front.dy, nil, clone)
    if occupant or cover then clone.x, clone.y, clone.grid = front.x, front.y, grid end

    if cover and not self:_absorb(cover, clone, front.dx, front.dy) then
        table.insert(self.simulator.dying, clone)
    elseif not occupant or self:_absorb(occupant, clone, front.dx, front.dy) then
        grid:set(front.x, front.y, clone)
    else
        table.insert(self.simulator.dying, clone)
    end
    return clone
end

function Movement:_slips(x, y, dx, dy)
    local grid = self.grid
    if not grid:bounds(x, y) then return false end

    local before = grid:bounds(x + dy, y + dx) and grid:get(x + dy, y + dx)
    local after = grid:bounds(x - dy, y - dx) and grid:get(x - dy, y - dx)
    return before and before.slick or after and after.slick or false
end

function Movement:_step(x, y, dx, dy, reverse, moved)
    local grid = self.grid
    local via, turn = none, 0
    local mover = grid:get(x, y)

    for _ = 1, constants.simulator.hops do
        x, y = x + dx, y + dy

        local cell = grid:get(x, y)
        local free = cell and not (moved and moved[cell])
        local nx, ny, spin, halt, jx, jy
        if free and cell.lookup.jump then jx, jy, nx, ny, spin = cell:jump(dx, dy, x, y, reverse) end

        if jx then nx, ny, spin = nx or dx, ny or dy, spin or 0
        elseif free and cell.lookup.divert then nx, ny, spin, halt = cell:divert(dx, dy, reverse, mover)
        elseif not cell and self:_slips(x, y, dx, dy) then nx, ny, spin = dx, dy, 0 end

        if halt then dx, dy, nx, turn = nx, ny, nil, turn + spin end
        if not nx then return x, y, dx, dy, reverse and -turn or turn, via, cell, halt end

        if via == none then via = {} end
        table.insert(via, reverse and 1 or #via + 1, { x, y, dx, dy })
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

function Movement:_bump(cell, dx, dy, pusher)
    if self.dry then return end

    cell.simulator = self.simulator
    cell:bump(dx, dy, pusher)
end

function Movement:_touch(cell, action, dx, dy)
    if self.dry then return end

    cell.simulator = self.simulator
    cell:chained(action, dx, dy, self.anchor)
end

function Movement:_post(run, ...)
    local outer = self.after
    self.after = {}
    local result = run(self, ...)
    local queued = self.after
    self.after = outer

    for _, action in ipairs(queued) do
        action(result)
    end
    return result
end

function Movement:_bend(last, tries, home)
    local ax, ay = 0, -1
    if home[1] == 0 then ax, ay = 1, 0 end
    if tries > 0 then ax, ay = -ax, -ay end

    local nx, ny, ndx, ndy, turn, via, target = self:_step(last.cell.x, last.cell.y, ax, ay)
    if not nx then return end

    last.x, last.y, last.dx, last.dy, last.ox, last.oy, last.via = nx, ny, ndx, ndy, ax, ay, via
    last.turn = turn + heading(ax, ay) - heading(home[1], home[2])
    return nx, ny, ndx, ndy, target
end

function Movement:_walk(x, y, dx, dy, force, chain, bare)
    local grid, dead = self.grid, self.dead
    local width, version = grid.width, grid.version
    local limit, bend = self.limit, self.bend
    chain = chain or {}

    self.stamp = self.stamp + 1
    local stamp, first = self.stamp, #chain
    for _, move in ipairs(chain) do
        move.cell.walked = stamp
    end

    local tries, home = 0
    local cell = grid:get(x, y)
    while true do
        if not (cell or grid:bounds(x, y)) then return self:_seal(chain, first) end

        local last, before = chain[#chain], force
        local barred = last and self:_barred(x, y, dx, dy, "push", last.cell)
        if not barred then
            if not cell or devours(cell, last and last.cell, dx, dy) then return chain end
            if cell.walked == stamp then return cell == chain[1].cell and chain or nil end
        end

        local pushable = not barred and movable(cell, "push", dx, dy, bare and #chain == first)
        if not (barred or pushable) then self:_bump(cell, dx, dy, last and last.cell) end

        local sealed = barred or not pushable or dead[key(width, x, y, dx, dy)] == version
        if not sealed then
            if limit and #chain - first >= limit then return end

            self:_touch(cell, "push", dx, dy)
            force = apply(cell, force, dx, dy, "push")
        end

        local nx, ny, ndx, ndy, turn, via, target
        if sealed or force <= 0 then
            if bend and last and tries < 2 then
                home = home or { last.ox, last.oy }
                nx, ny, ndx, ndy, target = self:_bend(last, tries, home)
            end

            if not nx then
                self.depth = #chain
                if sealed then return self:_seal(chain, first) end
                return
            end

            tries, force = tries + 1, before
        else
            nx, ny, ndx, ndy, turn, via, target = self:_step(x, y, dx, dy)
            if not nx then return end

            cell.walked = stamp

            local move = self:_take()
            move.cell, move.x, move.y, move.dx, move.dy, move.pushed = cell, nx, ny, ndx, ndy, "push"
            move.ox, move.oy, move.turn, move.via = dx, dy, turn, via
            chain[#chain + 1] = move

            tries, home = 0
        end
        x, y, dx, dy, cell = nx, ny, ndx, ndy, target
    end
end

function Movement:_cling(chain, force)
    local grid = self.grid

    for _, move in ipairs(chain) do
        local cell = move.cell
        for _, side in ipairs(sides) do
            local sx, sy = -side * move.oy, side * move.ox
            local sticky = cell:clinging(sx, sy)
            local other = sticky and grid:get(cell.x + sx, cell.y + sy)
            local stuck = other and other:clinging(-sx, -sy) == sticky and other.walked ~= self.stamp

            if stuck and not self:_walk(other.x, other.y, move.ox, move.oy, force, chain) then return end
        end
    end
    return chain
end

function Movement:_settle(chain)
    local total = 0
    for _, move in ipairs(chain) do
        if move.pushed then total = total + move.cell:imaginary(move.ox, move.oy) end
    end

    for _, move in ipairs(chain) do
        if move.pushed and not move.cell:settled(total) then return end
    end
    return chain
end

function Movement:_line(x, y, dx, dy, force, chain, bare)
    chain = self:_walk(x, y, dx, dy, force, chain, bare)
    chain = chain and self:_cling(chain, force)
    return chain and self:_settle(chain)
end

function Movement:_carry(cell, x, y, dx, dy, action)
    local move = self:_take()
    move.cell, move.x, move.y, move.dx, move.dy, move.action = cell, x, y, dx, dy, action
    move.turn, move.via = 0, none
    return move
end

function Movement:_spoil(chain, from, last, turn)
    if last and turn ~= 0 then last:rotate(turn, nil, true) end

    for i = #chain, from, -1 do
        local entry = chain[i]
        if entry.turn ~= 0 then entry.cell:rotate(entry.turn, nil, true) end
        chain[i] = nil
    end
end

function Movement:_rows(rows, x, y, dx, dy, force, bare)
    local grid = self.grid

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

function Movement:_extend(chain, force)
    local last = chain[#chain]
    if self.grid:get(last.x, last.y) then return end

    local gap = self:_route(last.x, last.y, last.dx, last.dy)
    if gap then self:_rows(chain, gap.x, gap.y, gap.dx, gap.dy, force) end
end

function Movement:_trail(chain, x, y, dx, dy, force, row, strict)
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
        if not movable(cell, "pull", ox, oy) then return true end

        self:_touch(cell, "pull", ox, oy)

        force = apply(cell, force, ox, oy, "pull")
        if force <= 0 then
            if not strict then self:_spoil(chain, size + 1, cell, walk.turn) end
            return false
        end

        seen[cell] = true

        local forward = self:_route(walk.x, walk.y, ox, oy, false, seen)
        if not forward or taken[slot(width, forward.x, forward.y)] then return true end

        if walk.halt then
            if not self:_open(forward.x, forward.y, forward.dx, forward.dy, nil, cell) then return true end
        elseif walk.via ~= none and (forward.x ~= x or forward.y ~= y) then
            return true
        end

        local entry = self:_take()
        entry.cell, entry.x, entry.y, entry.dx, entry.dy, entry.pushed = cell, forward.x, forward.y, forward.dx, forward.dy, "pull"
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
        move.eater = occupant and (occupant:eats(move.dx, move.dy, move.action, move.cell)
            or move.cell:rams(occupant, move.dx, move.dy, move.action)) and occupant or nil
        move.cover = grid:swallower(move.x, move.y, move.dx, move.dy, move.action, move.cell)
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

        if move.turn ~= 0 then cell:rotate(move.turn, nil, true) end
        if move.pushed then
            cell.simulator = self.simulator
            cell:pushed(move.ox, move.oy, move.pushed)
        end

        for _, point in ipairs(move.via) do
            local via = grid:get(point[1], point[2])
            if via then via:passed(cell, point[3], point[4]) end
        end

        local consumed = move.cover and not self:_absorb(move.cover, cell, move.dx, move.dy, move.action)
            or move.eater and not self:_absorb(move.eater, cell, move.dx, move.dy, move.action)

        if consumed then
            table.insert(self.simulator.dying, cell)
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

    if not forced and (a and grid:barred(bx, by, adx, ady, "swap", a) or b and grid:barred(ax, ay, bdx, bdy, "swap", b)) then return false end

    local meeting = a and b and not forced
    local aEats = meeting and swappable(b, -adx, -ady) and devours(a, b, bdx, bdy, "swap")
    local bEats = meeting and not aEats and swappable(a, -bdx, -bdy) and devours(b, a, adx, ady, "swap")
    if not forced and (a and not aEats and not swappable(a, -bdx, -bdy) or b and not bEats and not swappable(b, -adx, -ady)) then return false end

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

function Movement:slice(x, y, dx, dy, bend)
    if self:nudge(x, y, dx, dy) then return true end

    local grid = self.grid
    local slicer, front = grid:get(x, y), grid:get(x + dx, y + dy)
    if not (slicer and front) then return end

    for _, side in ipairs(normals(dx, dy, bend)) do
        local sx, sy = side[1], side[2]

        if movable(front, "push", sx, sy) and self:push(x + dx, y + dy, sx, sy, constants.force.strength) then
            return slicer.x == x and slicer.y == y and self:nudge(x, y, dx, dy)
        end
    end
end

function Movement:staple(x, y, dx, dy, bend)
    for _, side in ipairs(normals(dx, dy, bend)) do
        self:pull(x + side[1], y + side[2], -side[1], -side[2], constants.force.strength)
    end
end

function Movement:_pushChain(x, y, dx, dy, force, options)
    self.depth = 0

    local pusher
    x, y, pusher = rewind(self.grid, x, y, -dx, -dy)
    if not pusher or pusher:guarded("push") then return false end

    force = (force or constants.force.push) + pusher:strength(dx, dy, "push", true)
    if force <= 0 then return false end

    local anchor = self.anchor
    anchor.x, anchor.y, anchor.dx, anchor.dy, anchor.extended = x, y, dx, dy, nil

    self.top = 0
    local move = self:_route(x, y, dx, dy)
    if not move then return false end

    move.cell = pusher
    local chain = { move }
    options = options or none

    local limit, bend = self.limit, self.bend
    self.limit, self.bend = options.limit, options.bend
    local line = self:_line(move.x, move.y, move.dx, move.dy, force, chain)
    self.limit, self.bend = limit, bend
    if not line then return false end

    if options.row then self:_extend(chain, force) end

    self:_drive(chain, "push")
    self:_shift(chain)
    return true
end

function Movement:_pullChain(x, y, dx, dy, force, passive, row)
    local puller
    x, y, puller = rewind(self.grid, x, y, dx, dy)
    if not puller or puller:guarded("pull") then return false end

    self.top = 0
    local move = self:_route(x, y, dx, dy)
    if not move then return false end

    move.cell, move.action = puller, "pull"
    if not self:_reach(move) then return false end

    force = (force or constants.force.pull) + puller:strength(dx, dy, "pull", true)
    if force <= 0 then return false end

    local chain = { move }
    if not self:_trail(chain, x, y, dx, dy, force, row) then
        local eater = self.grid:get(move.x, move.y)
        if not eater then return false end

        puller:rotate(move.turn, true, true)
        self:_absorb(eater, puller, move.dx, move.dy, "pull")
        puller:rotate(-move.turn, true, true)
        return false
    end

    if not self:_settle(chain) then return false end

    if not passive then self:_drive(chain, "pull") end
    self:_shift(chain, passive)
    return true
end

function Movement:pull(x, y, dx, dy, force, row)
    return self.grid:bounds(x, y) and self:_pull(x, y, dx, dy, force, nil, row)
end

function Movement:attract(x, y, dx, dy, force, row)
    local grid = self.grid
    local cell = grid:get(x, y)

    while row and not cell and grid:bounds(x, y) do
        x, y = x - dx, y - dy
        cell = grid:get(x, y)
    end
    if not (cell and movable(cell, "pull", dx, dy)) then return false end

    return self:_pull(x, y, dx, dy, force, true, row)
end

function Movement:advance(x, y, dx, dy, options)
    local advancer = self.grid:get(x, y)
    if not advancer then return false end

    options = options or none
    local push = constants.force.push + advancer:strength(dx, dy, "push", true)
    local pull = constants.force.pull + advancer:strength(dx, dy, "pull", true)

    self.top = 0
    local move = self:_route(x, y, dx, dy)
    if not move then return false end

    move.cell = advancer
    local chain = { move }
    if advancer:guarded("push") or not (push > 0 and self:_line(move.x, move.y, move.dx, move.dy, push, chain)) then
        if options.strict then return false end
        if self:_jammed(move) then return true end

        return self:pull(x, y, dx, dy, nil, options.row)
    end

    if options.row then self:_extend(chain, push) end

    local size = #chain
    local trailed = self:_trail(chain, x, y, dx, dy, pull, options.row, options.strict)
    if options.strict and not (trailed and #chain > size) then return false end

    self:_drive(chain, "push")
    self:_shift(chain)
    return true
end

function Movement:_flanks(chain, x, y, dx, dy, force, skew, strong)
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
            if not (move and movable(cell, "grab", fx, fy)) then break end
            if not strong and not self:_open(move.x, move.y, move.dx, move.dy, nil, cell) then break end

            self:_touch(cell, "grab", fx, fy)

            force = apply(cell, force, fx, fy, "grab")
            if force <= 0 then return false end

            move.cell, move.pushed = cell, "grab"
            if strong then
                local pushed = apply(cell, constants.force.strength, fx, fy, "push")
                local line = { move }
                if pushed <= 0 or not self:_line(move.x, move.y, move.dx, move.dy, pushed, line) then break end

                for i = 2, #line do
                    seen[line[i].cell] = true
                    chain[#chain + 1] = line[i]
                end
            end

            seen[cell] = true
            chain[#chain + 1] = move
            cx, cy, sx, sy = walk.x, walk.y, walk.dx, walk.dy
        end
    end
    return true
end

function Movement:_grabChain(x, y, dx, dy, skew, strong)
    local grabber = self.grid:get(x, y)
    if not grabber or grabber:guarded("grab") then return false end

    self.top = 0
    local move = self:_route(x, y, dx, dy)
    if not move then return false end

    move.cell, move.action = grabber, "pull"
    if not self:_reach(move) then return false end

    local force = constants.force.grab + grabber:strength(dx, dy, "grab", true)
    local chain = { move }
    if force <= 0 or not self:_flanks(chain, x, y, dx, dy, force, skew, strong) then return false end

    if not self:_settle(chain) then return false end

    self:_drive(chain, "grab")
    self:_shift(chain)
    return true
end

function Movement:_flankChain(x, y, dx, dy, skew, strong)
    self.top = 0
    local chain = {}
    if not self:_flanks(chain, x, y, dx, dy, constants.force.strength, skew, strong) then return false end

    if not self:_settle(chain) then return false end

    self:_drive(chain, "grab")
    self:_shift(chain, true)
    return true
end

function Movement:push(x, y, dx, dy, force, options)
    return self:_post(self._pushChain, x, y, dx, dy, force, options)
end

function Movement:_pull(x, y, dx, dy, force, passive, row)
    return self:_post(self._pullChain, x, y, dx, dy, force, passive, row)
end

function Movement:grab(x, y, dx, dy, skew, strong)
    return self:_post(self._grabChain, x, y, dx, dy, skew, strong)
end

function Movement:flank(x, y, dx, dy, skew, strong)
    return self:_post(self._flankChain, x, y, dx, dy, skew, strong)
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
    local source = back and (options.cell or grid:get(back.x, back.y))
    local front = self:_route(x, y, dx, dy)
    if not (source and source:generatable() and front) then return false end
    if grid:barred(front.x, front.y, front.dx, front.dy, "generate", source) then return false end

    local class, props, rotation = source:generated()
    local clone = class and class:new({ rotation = rotation or source.rotation, props = props, effects = source:kept() })
    if clone and self:_crash(clone, front, x, y) then return true end

    local chain = self:_line(front.x, front.y, front.dx, front.dy, constants.force.generate)
    if not chain then return false end

    if #chain > 0 then self:_shift(chain, true) end
    if not clone then return true end

    local origin = generator.path and generator.path[1] or { x, y }
    local turn = back.turn + front.turn + (options.turn or 0)

    clone:rotate(turn, true, true)
    clone.updated = source.updated
    clone.ran = source.ran
    return true, self:_spawn(clone, front, origin), back.turn + front.turn
end

function Movement:clear(x, y, dx, dy)
    local probe = key(self.grid.width, x, y, dx, dy)
    if self.probes[probe] then return false end

    local front = self:_route(x, y, dx, dy)
    if not front or self.grid:barred(front.x, front.y, front.dx, front.dy, "generate") then return false end

    local dry = self.dry
    self.probes[probe], self.dry = true, true
    local chain = self:_line(front.x, front.y, front.dx, front.dy, constants.force.generate)
    self.probes[probe], self.dry = nil, dry
    return chain ~= nil
end

function Movement:_strike(cell, x, y, occupant)
    cell.grid, cell.x, cell.y = self.grid, x, y

    local damage = math.min(cell:health(), occupant:health())
    occupant:hit(damage)
    return damage
end

function Movement:_crash(cell, front, x, y)
    local occupant = self.grid:get(front.x, front.y)
    if not (cell.collides and cell:breakable() and occupant and occupant:breakable()) then return false end
    if occupant:eats(front.dx, front.dy, "push", cell) then return false end

    local damage = self:_strike(cell, x, y, occupant)
    if cell.struck then cell:struck(damage) end
    return true
end

function Movement:fire(x, y, dx, dy, cell)
    local front = self:look(x, y, dx, dy)
    if not front then return false end

    local occupant = self.grid:get(front.x, front.y)
    if occupant and not occupant:eats(front.dx, front.dy, "push", cell) then
        if not (cell.struck and occupant:breakable()) then return false end

        local damage = self:_strike(cell, front.x, front.y, occupant)
        self:flush()
        if not cell:struck(damage) or self.grid:get(front.x, front.y) then return true end
    end

    cell:rotate(front.turn, true, true)
    self:_spawn(cell, front, { x, y })
    return true
end

function Movement:release(x, y, dx, dy, cell, mode)
    self.top = 0
    local front = self:_route(x, y, dx, dy)
    if not front or self.grid:barred(front.x, front.y, front.dx, front.dy, "generate", cell) then return false end
    if self:_crash(cell, front, x, y) then return true end

    local chain = self:_line(front.x, front.y, front.dx, front.dy, constants.force.generate)
    if not chain then return false end

    if #chain > 0 then
        if mode == "eject" then self:_drive(chain, "push") end
        self:_shift(chain, true)
    end

    if mode ~= "keep" then cell:rotate(front.turn, true, true) end
    if mode == "eject" then cell.updated = self.simulator.time.tick end

    self:_spawn(cell, front, { x, y })
    return true
end

function Movement:repel(x, y, dx, dy, force, row)
    self.top = 0
    local front = self:_route(x, y, dx, dy)
    if not front then return false end

    force = constants.force.push + (force or constants.force.strength)

    local chain = row and self:_rows({}, front.x, front.y, front.dx, front.dy, force, true) or self:_line(front.x, front.y, front.dx, front.dy, force, nil, true)
    if not chain then return false end

    local cell = self.grid:get(front.x, front.y)
    if cell and #chain == 0 then self:_bump(cell, front.dx, front.dy) end

    self:_shift(chain, true)
    return front
end

function Movement:tunnel(x, y, dx, dy, strong)
    local tunneler = self.grid:get(x, y)
    if not tunneler then return false end

    for _ = 1, constants.grid.limits.max do
        self.top = 0
        local move = self:_route(x, y, dx, dy)
        if not move then return false end

        move.cell = tunneler
        local chain = { move }
        local target = move.target

        if strong then
            local force = constants.force.push + tunneler:strength(dx, dy, "push", true)
            if force > 0 and self:_line(move.x, move.y, move.dx, move.dy, force, chain) then
                self:_drive(chain, "push")
                self:_shift(chain)
                return true
            end
        elseif self:_open(move.x, move.y, move.dx, move.dy, nil, tunneler) then
            self:_shift(chain)
            return true
        end

        if not target or target.fixed or target:guarded("tunnel") then return false end
        x, y, dx, dy = move.x, move.y, move.dx, move.dy
    end
    return false
end

function Movement:destroy(cell, exploded)
    self:defer(function()
        if self.grid:get(cell.x, cell.y) ~= cell or cell:guarded("protect") then return end

        cell.simulator = self.simulator
        cell:kill(exploded)
    end)
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

    cell:rotate(front.turn, true, true)
    self:place(front.x, front.y, cell)
    return true
end

function Movement:post(action)
    local queued = self.after
    if queued then queued[#queued + 1] = action end
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
