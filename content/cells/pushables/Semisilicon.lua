local Silicon = require("content/cells/pushables/Silicon")
local BaseCell = require("content/cells/abstract/BaseCell")

local Semisilicon = setmetatable({
    name = "semisilicon",
    k3 = 249,
    title = "Semisilicon",
    description = "Pushable that sticks to adjacent Silicon cells in front of and behind it, so they move together when pushed.",
    faces = { 0, 2 }
}, { __index = Silicon })
Semisilicon.__index = Semisilicon

function Semisilicon:clinging(dx, dy)
    if self:_along(dx, dy) == 0 then return BaseCell.clinging(self, dx, dy) end

    return self.bond
end

return Semisilicon
