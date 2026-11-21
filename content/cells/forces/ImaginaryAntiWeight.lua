local BaseImaginary = require("content/cells/abstract/BaseImaginary")

local ImaginaryAntiWeight = setmetatable({
    name = "imaginaryantiweight",
    k3 = 1183,
    title = "Imaginary Anti-Weight",
    description = "Counts as 1 unit of anti-weight, which can cancel out Imaginary Weights."
}, { __index = BaseImaginary })
ImaginaryAntiWeight.__index = ImaginaryAntiWeight

function ImaginaryAntiWeight.imaginary()
    return 1
end

return ImaginaryAntiWeight
