local Spooner = require("content/cells/spooners/Spooner")

local Compounder = setmetatable({
    name = "compounder",
    k3 = 190,
    title = "Compounder",
    description = "Spooner that doesn't rotate cells.",
    rotates = false
}, { __index = Spooner })
Compounder.__index = Compounder

return Compounder
