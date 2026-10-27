local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")
local utils = require("src/utils")

local scale = constants.renderer.stored.scale

local BaseHolder = setmetatable({
    categories = { "storage" },
    properties = {
        { id = "stored", title = "Stored", default = {} }
    }
}, { __index = BaseCell })
BaseHolder.__index = BaseHolder

function BaseHolder:_hold(stored)
    local props = utils.copy(self.props)
    props.stored = stored
    self.props = props
end

function BaseHolder:_cell(stored)
    return stored.class:new({ rotation = stored.rotation, props = stored.props })
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
    cell.path, cell.own, cell.turn, cell.grow = self.path, self.own, self.turn, scale
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

    local stored = self.props and self.props.stored
    if stored and stored.class then
        self:_hold({ class = stored.class, rotation = (stored.rotation + amount) % 4, props = stored.props })
    end
end

function BaseHolder:draw(renderer, x, y, angle, ...)
    BaseCell.draw(self, renderer, x, y, angle, ...)
    if self:held() then renderer:drawStored(self.props.stored, x, y, angle - self.rotation, ...) end
end

return BaseHolder
