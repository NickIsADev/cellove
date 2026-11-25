local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local Biorientator = setmetatable({
    name = "biorientator",
    k3 = 573,
    title = "Biorientator",
    description = "Orientator that outputs to both sides from the cell behind it.",
    outputs = { 1, 3 },
    rear = true
}, { __index = BaseOrientator })
Biorientator.__index = Biorientator

return Biorientator
