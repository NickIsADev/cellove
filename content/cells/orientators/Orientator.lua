local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local Orientator = setmetatable({
    name = "orientator",
    k3 = 569,
    title = "Orientator",
    description = "Rotates the cell in front of it to match the cell behind it."
}, { __index = BaseOrientator })
Orientator.__index = Orientator

return Orientator
