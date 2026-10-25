local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local Weight = setmetatable({
    name = "weight",
    k3 = 22,
    title = "Weight",
    description = "Absorbs 1 unit of force from anything pushing or pulling it.",
    categories = { "forces" }
}, { __index = BaseCell })
Weight.__index = Weight

function Weight:force()
    return constants.force.weight
end

return Weight
