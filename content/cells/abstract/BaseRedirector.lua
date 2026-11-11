local BaseSided = require("content/cells/abstract/BaseSided")
local utils = require("src/utils")

local BaseRedirector = setmetatable({
    categories = { "redirectors" },
    subtick = { "redirector" },
    redirector = true
}, { __index = BaseSided })
BaseRedirector.__index = BaseRedirector

function BaseRedirector:_facing(dx, dy)
    if self.random then return math.random(0, 3) end
    if not self.around then return self.rotation end

    return (utils.direction(dx, dy) + self.around) % 4
end

function BaseRedirector:update()
    self:surrounding(1, function(cell, _, _, dx, dy)
        if cell and not cell.redirector and self:_reaches(dx, dy) then
            cell:rotate(self:_facing(dx, dy) - cell.rotation)
        end
    end)
end

return BaseRedirector
