local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")
local utils = require("src/utils")

local stored = constants.renderer.stored

local BaseHolder = setmetatable({
    categories = { "storage" },
    properties = {
        { id = "stored", title = "Stored", default = {} }
    },
    fit = stored.storage
}, { __index = BaseCell })
BaseHolder.__index = BaseHolder

function BaseHolder:_hold(content)
    local props = utils.copy(self.props)
    props.stored = content
    self.props = props
end

function BaseHolder:_cell(content, turn)
    return content.class:new({ rotation = content.rotation + (turn or 0), props = content.props })
end

function BaseHolder:_make(direction)
    local turn = getmetatable(self).aligns and direction - self.rotation or 0
    return self:_cell(self.props.stored, turn)
end

function BaseHolder:_release(direction)
    local cell = self:_make(direction)
    cell.updated, cell.ran = self.simulator.time.tick, self.simulator.time.subtick

    local facing = constants.directions[direction]
    return self.simulator.movement:release(self.x, self.y, facing[1], facing[2], cell)
end

function BaseHolder:_shrink()
    self.path = self.path or { { self.x, self.y }, { self.x, self.y } }
    self.own, self.born = nil, true
    self:_hold({})

    local dying = self.simulator.dying
    dying[#dying + 1] = self
end

function BaseHolder:_become()
    local cell = self:_cell(self.props.stored)
    cell.path, cell.own, cell.turn, cell.grow = self.path, self.own, self.turn, getmetatable(self).fit
    self:_shrink()

    self.grid:set(self.x, self.y, cell)
    self.grid:touch(cell)
end

function BaseHolder:held()
    return self.props.stored.class ~= nil
end

function BaseHolder:eats()
    return true
end

function BaseHolder:absorb(cell)
    self:_hold({ class = getmetatable(cell), rotation = cell.rotation, props = cell.props })
end

function BaseHolder:rotate(amount)
    BaseCell.rotate(self, amount)

    local content = self.props and self.props.stored
    if content and content.class then
        self:_hold({ class = content.class, rotation = (content.rotation + amount) % 4, props = content.props })
    end
end

function BaseHolder:draw(renderer, x, y, angle, scale, offset)
    BaseCell.draw(self, renderer, x, y, angle, scale, offset)
    if self:held() then
        renderer:drawStored(self.props.stored, x, y, angle - self.rotation, scale * getmetatable(self).fit, offset)
    end
end

return BaseHolder
