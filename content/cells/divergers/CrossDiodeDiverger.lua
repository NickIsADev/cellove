local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local CrossDiodeDiverger = setmetatable({
    name = "crossdiodediverger",
    k3 = 209,
    title = "Crossdiode Diverger",
    description = "Lets cells pass straight through in two directions, one way each.",
    routes = { [1] = 0, [2] = 0 },
    reverse = { [0] = 0, [3] = 0 }
}, { __index = BaseDiverger })
CrossDiodeDiverger.__index = CrossDiodeDiverger

return CrossDiodeDiverger
