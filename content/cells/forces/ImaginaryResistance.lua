local BaseImaginary = require("content/cells/abstract/BaseImaginary")

local ImaginaryResistance = setmetatable({
    name = "imaginaryresistance",
    k3 = 1185,
    title = "Imaginary Resistance",
    description = "Makes the push fail unless the imaginary weight of the moving cells adds up to exactly 0."
}, { __index = BaseImaginary })
ImaginaryResistance.__index = ImaginaryResistance

function ImaginaryResistance.settled(_, total)
    return total == 0
end

return ImaginaryResistance
