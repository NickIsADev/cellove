local BaseCycler = require("content/cells/abstract/BaseCycler")

local CyclerCW = setmetatable({
    name = "cycler_cw",
    k3 = 625,
    title = "Cycler (CW)",
    description = "Cycles the 3 cells in front of it clockwise."
}, { __index = BaseCycler })
CyclerCW.__index = CyclerCW

return CyclerCW
