local BaseSided = require("content/cells/abstract/BaseSided")
local utils = require("src/utils")

local Flipper = setmetatable({
    name = "flipper",
    k3 = 30,
    title = "Flipper",
    description = "Flips adjacent cells every tick.",
    faces = { 0, 2 },
    categories = { "flippers" },
    subtick = { "flipper" },
    axis = "straight"
}, { __index = BaseSided })
Flipper.__index = Flipper

function Flipper:update()
    local key = utils.flip(self.rotation, self.axis)

    self:surrounding(1, function(cell, _, _, dx, dy)
        if cell and self:_reaches(dx, dy) then cell:flip(key, false, self.sides.diagonal) end
    end)
end

return Flipper
