local BaseImaginary = require("content/cells/abstract/BaseImaginary")

local ImaginaryConductance = setmetatable({
    name = "imaginaryconductance",
    k3 = 1196,
    title = "Imaginary Conductance",
    description = "Makes the push fail if the imaginary weight of the moving cells adds up to exactly 0."
}, { __index = BaseImaginary })
ImaginaryConductance.__index = ImaginaryConductance

function ImaginaryConductance.settled(_, total)
    return total ~= 0
end

return ImaginaryConductance
