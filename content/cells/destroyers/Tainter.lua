local Trash = require("content/cells/destroyers/Trash")

local Tainter = setmetatable({
    name = "tainter",
    k3 = 176,
    title = "Tainter",
    description = "Deletes any cell that moves into it, then spreads into the tile that cell came from.",
    categories = { "trashes", "infectious" }
}, { __index = Trash })
Tainter.__index = Tainter

function Tainter:_taint(x, y, dx, dy)
    local target = self.grid:get(x, y)
    if x == self.x and y == self.y or target and not target:transformable(dx, dy) then return end

    local class, props = self:template()
    local clone = class:new({ rotation = self.rotation, props = props })

    clone.updated = self.simulator.time.tick
    self.simulator.movement:place(x, y, clone)
end

function Tainter:ate(cell, dx, dy)
    local x, y = cell.x, cell.y
    self.simulator.movement:defer(function() self:_taint(x, y, -dx, -dy) end)
end

return Tainter
