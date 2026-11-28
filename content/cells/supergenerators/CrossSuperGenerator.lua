local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")

local CrossSuperGenerator = setmetatable({
    name = "crosssupergenerator",
    k3 = 457,
    title = "Cross Super Generator",
    description = "Two Super Generators.",
    outputs = { 0, 3 }
}, { __index = SuperGenerator })
CrossSuperGenerator.__index = CrossSuperGenerator

return CrossSuperGenerator
