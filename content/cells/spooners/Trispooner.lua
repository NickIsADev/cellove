local Spooner = require("content/cells/spooners/Spooner")

local Trispooner = setmetatable({
    name = "trispooner",
    k3 = 187,
    title = "Trispooner",
    description = "Spooner that also takes cells from behind.",
    inputs = { [1] = 1, [2] = 0, [3] = -1 },
    reverse = { [0] = 0 }
}, { __index = Spooner })
Trispooner.__index = Trispooner

return Trispooner
