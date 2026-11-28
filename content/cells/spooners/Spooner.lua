local BaseDiverger = require("content/cells/abstract/BaseDiverger")
local constants = require("src/constants")

local Spooner = setmetatable({
    name = "spooner",
    k3 = 186,
    title = "Spooner",
    description = "Merges cells entering from its sides into one, sent out the front and turned to face it.",
    categories = { "spooners" },
    subtick = { "gate" },
    destroys = true,
    rear = true,
    rotates = true,
    routes = {},
    inputs = { [1] = 1, [3] = -1 },
    reverse = { [0] = -1 }
}, { __index = BaseDiverger })
Spooner.__index = Spooner

function Spooner:eats(dx, dy, action)
    return not action and self.inputs[self:_entry(dx, dy)] ~= nil
end

function Spooner:ate(cell, dx, dy)
    if self.output then return end

    local turn = self.rotates and self.inputs[self:_entry(dx, dy)] or 0
    self.output = cell:contents((cell.rotation + turn) % 4)
end

function Spooner:update()
    local output = self.output
    if not output then return end

    self.output = nil
    local facing = constants.directions[self.rotation]
    local cell = output.class:new({ rotation = output.rotation, props = output.props, effects = output.effects })
    self.simulator.movement:release(self.x, self.y, facing[1], facing[2], cell)
end

return Spooner
