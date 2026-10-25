local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local CrossDiverger = setmetatable({
    name = "crossdiverger",
    k3 = 39,
    title = "Cross Diverger",
    description = "Lets cells pass straight through in every direction.",
    routes = {
        [0] = 0,
        [1] = 0,
        [2] = 0,
        [3] = 0
    }
}, { __index = BaseDiverger })
CrossDiverger.__index = CrossDiverger

return CrossDiverger
