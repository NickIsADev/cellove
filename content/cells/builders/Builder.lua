local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")
local utils = require("src/utils")

local Builder = setmetatable({
    name = "builder",
    k3 = 327,
    title = "Builder",
    description = "Clones any cell pushed into its back and pushes the clone out the front.",
    categories = { "builders" },
    outputs = { 0 },
    entry = 0
}, { __index = BaseCell })
Builder.__index = Builder

function Builder:_entry()
    return self.entry
end

function Builder:_build(pusher, output)
    local turn = self.rotates ~= false and (self.bend or self.aligns and output) or nil
    local clone = pusher:clone(turn)
    if not clone then return end

    local facing = constants.directions[(self.rotation + output) % 4]
    local movement = self.simulator.movement

    movement:defer(function()
        movement:release(self.x, self.y, facing[1], facing[2], clone)
    end)
end

function Builder:chained(action, dx, dy, _, pusher)
    if action ~= "push" or not (pusher and pusher:cloneable()) then return end

    local offset = (utils.direction(dx, dy) - self.rotation) % 4
    for _, output in ipairs(self.outputs) do
        if offset == self:_entry(output) then self:_build(pusher, output) end
    end
end

return Builder
