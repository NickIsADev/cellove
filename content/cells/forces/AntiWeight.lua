local BaseCell = require("content/cells/abstract/BaseCell")
local constants = require("src/constants")

local AntiWeight = setmetatable({
    name = "antiweight",
    k3 = 104,
    title = "Anti-Weight",
    description = "Adds 1 unit of force to applied forces.",
    categories = { "forces" }
}, { __index = BaseCell })
AntiWeight.__index = AntiWeight

function AntiWeight:force()
    return -constants.force.weight
end

return AntiWeight
