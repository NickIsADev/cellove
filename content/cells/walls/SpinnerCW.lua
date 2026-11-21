local BaseSpinner = require("content/cells/abstract/BaseSpinner")

local SpinnerCW = setmetatable({
    name = "spinner_cw",
    k3 = 150,
    title = "Spinner (CW)",
    description = "Cannot be pushed, rotated, or destroyed. Rotates any cell that tries to push it clockwise."
}, { __index = BaseSpinner })
SpinnerCW.__index = SpinnerCW

return SpinnerCW
