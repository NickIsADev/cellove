local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local Bialigner = setmetatable({
    name = "bialigner",
    k3 = 579,
    title = "Bialigner",
    description = "Biorientator that does not turn the cell.",
    outputs = { 1, 3 },
    rear = true,
    rotates = false
}, { __index = BaseOrientator })
Bialigner.__index = Bialigner

return Bialigner
