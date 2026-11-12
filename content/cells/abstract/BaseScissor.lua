local Nudger = require("content/cells/movers/Nudger")
local constants = require("src/constants")

local BaseScissor = setmetatable({
    categories = { "scissors" },
    splits = { "left", "right" },
    rotates = true
}, { __index = Nudger })
BaseScissor.__index = BaseScissor

function BaseScissor:_split(target, name)
    local class, props, rotation = target:generated()
    if not class then return end

    local split = constants.scissors[name]
    local facing = constants.directions[(self.rotation + split.side) % 4]
    local turn = self.rotates and split.turn or 0
    local clone = class:new({ rotation = (rotation or target.rotation) + turn, props = props })

    clone.updated, clone.ran = target.updated, target.ran
    self.simulator.movement:release(self.x, self.y, facing[1], facing[2], clone)
end

function BaseScissor:update()
    local facing = constants.directions[self.rotation]
    local target = self.grid:get(self.x + facing[1], self.y + facing[2])

    if self:nudge() or not (target and target:transformable()) then return end

    target.simulator, target.born = self.simulator, true
    target:kill()
    if not self:nudge() then return end

    for _, name in ipairs(self.splits) do
        self:_split(target, name)
    end
end

return BaseScissor
