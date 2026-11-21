local BaseSpinner = require("content/cells/abstract/BaseSpinner")

local Spinner180 = setmetatable({
    name = "spinner_180",
    k3 = 152,
    title = "Spinner (180)",
    description = "Cannot be pushed, rotated, or destroyed. Rotates any cell that tries to push it 180 degrees.",
    spin = 2
}, { __index = BaseSpinner })
Spinner180.__index = Spinner180

return Spinner180
