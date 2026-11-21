local BaseDiverger = require("content/cells/abstract/BaseDiverger")
local constants = require("src/constants")
local utils = require("src/utils")

local DividerDiverger = setmetatable({
    name = "dividerdiverger",
    k3 = 1085,
    title = "Divider Diverger",
    description = "Eats cells entering from behind until it has taken its amount, then lets one through.",
    destroys = true,
    routes = { [2] = 0 },
    reverse = { [0] = 0 },
    properties = { constants.adjustable.count, constants.adjustable.amount }
}, { __index = BaseDiverger })
DividerDiverger.__index = DividerDiverger

function DividerDiverger:_ready()
    return self.props.count >= self.props.amount - 1
end

function DividerDiverger:_count(count)
    local props = utils.copy(self.props)
    props.count = count
    self.props = props
end

function DividerDiverger:divert(dx, dy, reverse)
    if reverse or self:_ready() then return BaseDiverger.divert(self, dx, dy, reverse) end
end

function DividerDiverger:eats(dx, dy, action)
    return not action and self:_entry(dx, dy) == 2 and not self:_ready()
end

function DividerDiverger:absorb()
    self:_count(self.props.count + 1)
end

function DividerDiverger:passed(_, dx, dy)
    if self:_entry(dx, dy) == 2 and self.props.count > 0 then self:_count(0) end
end

function DividerDiverger:draw(renderer, ...)
    BaseDiverger.draw(self, renderer, ...)
    renderer:drawTag(self.props.count .. "/" .. self.props.amount, ...)
end

return DividerDiverger
