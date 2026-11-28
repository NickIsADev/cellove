local Generator = require("content/cells/generators/Generator")
local constants = require("src/constants")

local SuperGenerator = setmetatable({
    name = "supergenerator",
    k3 = 55,
    title = "Super Generator",
    description = "Generator that generates the entire row of cells behind it.",
    categories = { "supergenerators" },
    subtick = { "superGenerator" },
    farFirst = true
}, { __index = Generator })
SuperGenerator.__index = SuperGenerator

function SuperGenerator:_scan(direction, options)
    local grid, movement = self.grid, self.simulator.movement
    local facing = constants.directions[options.source or (direction + 2) % 4]
    local x, y, dx, dy, turn = self.x, self.y, facing[1], facing[2], 0
    local row, visits = {}, {}

    for _ = 1, constants.grid.limits.max do
        local look = movement:look(x, y, dx, dy, true)
        local target = look and look.target
        if not (target and target:cloneable()) then return row end

        local index = (look.y - 1) * grid.width + look.x
        visits[index] = (visits[index] or 0) + 1
        if visits[index] > constants.simulator.crossings then return {} end

        turn = turn + look.turn
        row[#row + 1] = { cell = target, turn = turn }
        x, y, dx, dy = look.x, look.y, look.dx, look.dy
    end
    return {}
end

function SuperGenerator:_lay(at, cell, turn, options)
    local grid, movement = self.grid, self.simulator.movement
    local ahead = movement:look(at.x, at.y, at.dx, at.dy)
    local onward = ahead and { x = ahead.x, y = ahead.y, dx = ahead.dx, dy = ahead.dy }

    local done, placed
    if cell then
        done, placed = movement:release(at.x, at.y, at.dx, at.dy, cell:clone(turn), {
            source = cell,
            force = options.force,
            bend = options.bend,
            retreat = options.retreat
        })
    else
        done = onward and movement:push(onward.x, onward.y, onward.dx, onward.dy, { force = options.force or constants.force.generate })
    end

    if not done then return end
    return onward and (not placed or grid:get(onward.x, onward.y) == placed) and onward or at
end

function SuperGenerator:update(_, direction)
    local options = self:_options(direction)
    if not options then return end

    local row = self:_scan(direction, options)
    local facing = constants.directions[direction]
    local at = { x = self.x, y = self.y, dx = facing[1], dy = facing[2] }
    local first, last, step = 1, #row, 1
    if self.farFirst then first, last, step = #row, 1, -1 end

    for i = first, last, step do
        if i == 1 then self:generated() end

        at = self:_lay(at, row[i].cell, row[i].turn + (options.turn or 0), options)
        if not at then return end
    end
end

return SuperGenerator
