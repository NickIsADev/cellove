local BaseCycler = require("content/cells/abstract/BaseCycler")

local CyclerCCW = setmetatable({
    name = "cycler_ccw",
    k3 = 626,
    title = "Cycler (CCW)",
    description = "Cycles the 3 cells in front of it counter-clockwise.",
    subtick = { "cyclerCCW" },
    spin = -1
}, { __index = BaseCycler })
CyclerCCW.__index = CyclerCCW

return CyclerCCW
