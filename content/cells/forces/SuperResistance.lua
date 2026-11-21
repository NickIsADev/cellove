local Resistance = require("content/cells/forces/Resistance")

local SuperResistance = setmetatable({
    name = "superresistance",
    k3 = 1194,
    title = "Super Resistance",
    description = "Blocks any force that is not infinite."
}, { __index = Resistance })
SuperResistance.__index = SuperResistance

function SuperResistance:_limit()
    return math.huge
end

return SuperResistance
