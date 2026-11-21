local Pushable = require("content/cells/pushables/Pushable")
local BaseCell = require("content/cells/abstract/BaseCell")

local Silicon = setmetatable({
    name = "silicon",
    k3 = 231,
    title = "Silicon",
    description = "Pushable that sticks to adjacent Silicon cells, so they move together when pushed.",
    categories = { "sticky" },
    bond = "silicon"
}, { __index = Pushable })
Silicon.__index = Silicon

function Silicon:clinging(dx, dy)
    return self.bond or BaseCell.clinging(self, dx, dy)
end

return Silicon
