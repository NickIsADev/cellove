local Cutter = require("content/cells/drillers/Cutter")

local Piercer = setmetatable({
    name = "piercer",
    k3 = 278,
    title = "Piercer",
    description = "A Cutter that also pulls everything behind it.",
    categories = { "pullers", "drillers" },
    pulls = true
}, { __index = Cutter })
Piercer.__index = Piercer

return Piercer
