local Properties = require("src/engine/data/Properties")
local constants = require("src/constants")

local BaseCell = {
    name = "base",
    title = "Base",
    description = "",
    hostile = false,
    subtick = {},
    outputs = { 0 },
    properties = {}
}
BaseCell.__index = BaseCell

function BaseCell:new(data)
    assert(self ~= BaseCell, "BaseCell is abstract")
    data = data or {}

    local cell = setmetatable({}, self)
    cell.rotation = 0
    cell:rotate(data.rotation or 0)
    cell.turn = 0
    cell.ran = {}
    cell.props = {}

    for _, property in ipairs(self.properties) do
        cell.props[property.id] = Properties.value(data.props, property)
    end
    return cell
end

function BaseCell:_alignment(dx, dy)
    local facing = constants.directions[self.rotation]
    return facing[1] * dx + facing[2] * dy
end

function BaseCell:_side(dx, dy)
    local facing = constants.directions[self.rotation]
    return facing[1] * dy - facing[2] * dx
end

function BaseCell:_aim(dx, dy)
    local facing = constants.directions[self.rotation]
    return dx or facing[1], dy or facing[2]
end

function BaseCell:force(dx, dy, action)
    return 0
end

function BaseCell:driven(dx, dy, action)
    local drive = getmetatable(self).drive
    return drive and drive[action] and self:_alignment(dx, dy) > 0
end

function BaseCell:pushable(dx, dy)
    return true
end

function BaseCell:eats(dx, dy)
    return false
end

function BaseCell:absorb(cell, dx, dy)
end

function BaseCell:generatable()
    return true
end

function BaseCell:divert(dx, dy, reverse)
end

function BaseCell:nudge(dx, dy)
    return self.simulator:nudge(self.x, self.y, self:_aim(dx, dy))
end

function BaseCell:push(dx, dy, force)
    dx, dy = self:_aim(dx, dy)
    return self.simulator:push(self.x, self.y, dx, dy, force)
end

function BaseCell:pull(dx, dy, force)
    dx, dy = self:_aim(dx, dy)
    return self.simulator:pull(self.x, self.y, dx, dy, force)
end

function BaseCell:rotate(amount)
    self.turn = (self.turn or 0) + (amount + 2) % 4 - 2
    self.rotation = (self.rotation + amount) % 4
end

function BaseCell:neighbors(distance, callback)
    self.simulator.grid:neighbors(self.x, self.y, distance, callback)
end

function BaseCell:surrounding(distance, callback)
    self.simulator.grid:surrounding(self.x, self.y, distance, callback)
end

function BaseCell:rotateNeighbors(amount, predicate)
    self:neighbors(1, function(cell)
        if cell and (not predicate or predicate(cell)) then cell:rotate(amount) end
    end)
end

function BaseCell:kill(exploded)
    local sim = self.simulator

    sim.grid:set(self.x, self.y)
    self.exploded = exploded
    self.path = { { self.x, self.y }, { self.x, self.y } }
    sim.dying[#sim.dying + 1] = self
end

function BaseCell:generate(direction, options)
    local facing = constants.directions[direction or self.rotation]
    return self.simulator:generate(self.x, self.y, facing[1], facing[2], options)
end

function BaseCell:update(subtick, direction)
end

function BaseCell:draw(renderer, x, y, angle, scale, offset)
    renderer:drawSprite(self.texture, x, y, angle, scale, offset)
end

return BaseCell
