local BaseImaginary = require("content/cells/abstract/BaseImaginary")

local ImaginaryWeight = setmetatable({
    name = "imaginaryweight",
    k3 = 1182,
    title = "Imaginary Weight",
    description = "Counts as 1 unit of weight, but only cancels out once every push is finished. The push fails if more weight than anti-weight is moving."
}, { __index = BaseImaginary })
ImaginaryWeight.__index = ImaginaryWeight

function ImaginaryWeight.imaginary()
    return -1
end

return ImaginaryWeight
