local BaseSided = require("content/cells/abstract/BaseSided")
local utils = require("src/utils")

local BaseEffector = setmetatable({
    faces = {},
    categories = { "effects" },
    distance = 1,
    inclusive = true
}, { __index = BaseSided })
BaseEffector.__index = BaseEffector

function BaseEffector:_reaches(dx, dy)
    return BaseSided._reaches(self, utils.sign(dx), utils.sign(dy))
end

function BaseEffector:update()
    self:surrounding(self.distance, function(cell, _, _, dx, dy)
        if cell and self:_reaches(dx, dy) then self:_affect(cell) end
    end)
    if self.inclusive then self:_affect(self) end
end

return BaseEffector
