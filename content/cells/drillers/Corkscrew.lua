local Auger = require("content/cells/drillers/Auger")

local Corkscrew = setmetatable({
    name = "corkscrew",
    k3 = 60,
    title = "Corkscrew",
    description = "A Driller that pushes the cell in front of it and pulls everything behind it before drilling.",
    categories = { "movers", "pullers", "drillers" },
    pulls = true
}, { __index = Auger })
Corkscrew.__index = Corkscrew

function Corkscrew:update()
    local x, y, dx, dy = self.x, self.y, self:_aim()

    if self:push() then
        self:_follow(x, y, dx, dy)
    elseif not self:pull() then
        self:drill()
    end
end

return Corkscrew
