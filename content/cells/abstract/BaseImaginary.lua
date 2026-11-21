local BaseCell = require("content/cells/abstract/BaseCell")

local BaseImaginary = setmetatable({
    categories = { "weights" },
    faces = {}
}, { __index = BaseCell })
BaseImaginary.__index = BaseImaginary

function BaseImaginary.settled(_, total)
    return total >= 0
end

return BaseImaginary
