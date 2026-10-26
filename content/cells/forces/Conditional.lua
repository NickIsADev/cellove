local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Conditional = setmetatable({
    name = "conditional",
    k3 = 103,
    title = "Conditional",
    description = "The weight of this cell depends on its rotation. (0-3, increases clockwise)",
    categories = { "forces" }
}, { __index = BaseCell })
Conditional.__index = Conditional

function Conditional:force()
    return self.rotation * constants.force.weight
end

return Conditional
