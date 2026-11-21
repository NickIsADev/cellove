local BaseSpinner = require("content/cells/abstract/BaseSpinner")

local SpinnerCCW = setmetatable({
    name = "spinner_ccw",
    k3 = 151,
    title = "Spinner (CCW)",
    description = "Cannot be pushed, rotated, or destroyed. Rotates any cell that tries to push it counter-clockwise.",
    spin = -1
}, { __index = BaseSpinner })
SpinnerCCW.__index = SpinnerCCW

return SpinnerCCW
