local BaseImaginary = require("content/cells/abstract/BaseImaginary")

local ImaginaryBias = setmetatable({
    name = "imaginarybias",
    k3 = 1184,
    title = "Imaginary Bias",
    description = "Counts as Imaginary Anti-Weight when pushed from behind, and as Imaginary Weight when pushed from its front.",
    faces = { 0 }
}, { __index = BaseImaginary })
ImaginaryBias.__index = ImaginaryBias

function ImaginaryBias:imaginary(dx, dy)
    return self:_along(dx, dy)
end

return ImaginaryBias
