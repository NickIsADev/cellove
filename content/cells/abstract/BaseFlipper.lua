local BaseSided = require("content/cells/abstract/BaseSided")
local utils = require("src/utils")

local BaseFlipper = setmetatable({
    faces = { 0, 2 },
    categories = { "flippers" },
    subtick = { "flipper" },
    sweep = {
        x = 1,
        y = -1,
        columns = true
    },
    axis = "straight"
}, { __index = BaseSided })
BaseFlipper.__index = BaseFlipper

function BaseFlipper:update()
    local key = utils.flip(self.rotation, self.axis)

    self:surrounding(1, function(cell, _, _, dx, dy)
        if cell and self:_reaches(dx, dy) then cell:flip(key, false, self.sides.diagonal) end
    end)
end

return BaseFlipper
