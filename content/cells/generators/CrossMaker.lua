local Maker = require("content/cells/generators/Maker")

local CrossMaker = setmetatable({
    name = "crossmaker",
    k3 = 527,
    title = "Cross Maker",
    description = "Two Makers.",
    outputs = { 0, 3 }
}, { __index = Maker })
CrossMaker.__index = CrossMaker

return CrossMaker
