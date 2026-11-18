local BaseCell = require("content/cells/abstract/BaseCell")
local Initial = require("content/stores/Initial")

local Timewarper = setmetatable({
    name = "timewarper",
    k3 = 146,
    title = "Timewarper",
    description = "Reverts the space in front of it back to what it was in the initial state.",
    categories = { "timewarpers" },
    subtick = { "timewarper" },
    directional = true
}, { __index = BaseCell })
Timewarper.__index = Timewarper

function Timewarper:_warp(front)
    local target = front.target
    local initial = Initial.at(self.grid, front.x, front.y)
    if target and not target:transformable() or not (initial or target) then return false end

    local movement = self.simulator.movement
    if initial then
        movement:place(front.x, front.y, initial.class:new({ rotation = initial.rotation, props = initial.props }))
    else
        movement:destroy(target)
    end
    return true
end

function Timewarper:update(_, direction)
    local front = self:look(direction)
    if front then self:_warp(front) end
end

return Timewarper
