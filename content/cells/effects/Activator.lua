local BaseFreezer = require("content/cells/abstract/BaseFreezer")
local utils = require("src/utils")

local Activator = setmetatable({
    name = "activator",
    k3 = 1164,
    title = "Activator",
    description = "Freezes the cell in front of it. When a cell enters its back side, it will stop freezing for one tick.",
    faces = { 0 },
    outputs = { 0 },
    inclusive = false,
    properties = {
        { id = "paused", title = "Paused", default = false }
    }
}, { __index = BaseFreezer })
Activator.__index = Activator

function Activator:_pause(paused)
    local props = utils.copy(self.props)
    props.paused = paused
    self.props = props
end

function Activator:update()
    if self.props.paused then return self:_pause(false) end
    BaseFreezer.update(self)
end

function Activator:eats(dx, dy)
    return (dx == 0 or dy == 0) and self:_alignment(dx, dy) > 0
end

function Activator:absorb(cell, dx, dy, action)
    if action ~= "swap" then self:_pause(true) end
end

return Activator
