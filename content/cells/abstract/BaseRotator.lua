local BaseSided = require("content/cells/abstract/BaseSided")
local utils = require("src/utils")

local BaseRotator = setmetatable({
    faces = {},
    categories = { "rotators" },
    subtick = { "rotator" },
    spin = 1
}, { __index = BaseSided })
BaseRotator.__index = BaseRotator

function BaseRotator:_spin(dx, dy)
    if self.random then return utils.randomSign() end

    return self.spins and self.spins[(utils.direction(dx, dy) - self.rotation) % 4] or self.spin
end

function BaseRotator:update()
    self:surrounding(1, function(cell, _, _, dx, dy)
        if cell and self:_reaches(dx, dy) then cell:rotate(self:_spin(dx, dy)) end
    end)
end

return BaseRotator
