local Trispooner = require("content/cells/spooners/Trispooner")

local Tricompounder = setmetatable({
    name = "tricompounder",
    k3 = 191,
    title = "Tricompounder",
    description = "Trispooner that doesn't rotate cells.",
    rotates = false
}, { __index = Trispooner })
Tricompounder.__index = Tricompounder

return Tricompounder
