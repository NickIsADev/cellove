local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local Triorientator = setmetatable({
    name = "triorientator",
    k3 = 574,
    title = "Triorientator",
    description = "Orientator that outputs forward and to both sides from the cell behind it.",
    outputs = { 0, 1, 3 },
    rear = true
}, { __index = BaseOrientator })
Triorientator.__index = Triorientator

return Triorientator
