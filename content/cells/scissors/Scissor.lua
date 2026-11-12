local BaseScissor = require("content/cells/abstract/BaseScissor")

local Scissor = setmetatable({
    name = "scissor",
    k3 = 178,
    title = "Scissor",
    description = "Moves forward into empty space. Upon hitting a cell, splits it in two and pushes the halves out its sides."
}, { __index = BaseScissor })
Scissor.__index = Scissor

return Scissor
