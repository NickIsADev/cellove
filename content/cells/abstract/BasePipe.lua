local BaseHolder = require("content/cells/abstract/BaseHolder")
local BaseDiverger = require("content/cells/abstract/BaseDiverger")
local utils = require("src/utils")

local BasePipe = setmetatable({
    categories = { "pipes" },
    subtick = { "pipe" },
    directional = true,
    pipe = true,
    outputs = { 0, 1, 2, 3 },
    faces = { 0 },
    fixed = true,
    stockable = false,
    rotates = true,
    _entry = BaseDiverger._entry,
    _bend = BaseDiverger.divert
}, { __index = BaseHolder })
BasePipe.__index = BasePipe

function BasePipe:_heading()
    return (self.rotation + (self.props.stored.exit or 0)) % 4
end

function BasePipe:_yield(direction)
    local front = self:look(direction)
    local target = front and front.target
    if not (target and target.pipe and target:held()) then return end

    self.simulator:run(target, target.subtick[1], target:_heading())
end

function BasePipe:_make(direction)
    local cell = BaseHolder._make(self, direction)
    cell.grow = self.fit
    return cell
end

function BasePipe:eats(dx, dy)
    return not self:held() and (dx == 0 or dy == 0) and self:_bend(dx, dy) ~= nil
end

function BasePipe:absorb(cell, dx, dy)
    local nx, ny, spin = self:_bend(dx, dy)

    self:_hold({
        class = getmetatable(cell),
        rotation = (cell.rotation + spin) % 4,
        props = cell.props,
        exit = (utils.direction(nx, ny) - self.rotation) % 4
    })
    self.updated = self.simulator.time.tick
    cell.shrink, cell.born = self.fit, true
    self.arriving = cell
    self.grid:touch(self)
end

function BasePipe:update(_, direction)
    if not (self:held() and direction == self:_heading()) then return end

    self:_yield(direction)
    local content, cell = self.props.stored, self:_make(direction)

    self:_hold({})
    if not self:_release(direction, "eject", cell) then self:_hold(content) end
end

return BasePipe
