local Settlecompeller = require("content/cells/effects/Settlecompeller")

local Motocompeller = setmetatable({
    name = "motocompeller",
    k3 = 825,
    title = "Motocompeller",
    description = "If an affected cell stays still, it dies.",
    value = 2
}, { __index = Settlecompeller })
Motocompeller.__index = Motocompeller

return Motocompeller
