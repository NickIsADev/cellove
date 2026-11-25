local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local Trialigner = setmetatable({
    name = "trialigner",
    k3 = 580,
    title = "Trialigner",
    description = "Triorientator that does not turn the cell.",
    outputs = { 0, 1, 3 },
    rear = true,
    rotates = false
}, { __index = BaseOrientator })
Trialigner.__index = Trialigner

return Trialigner
