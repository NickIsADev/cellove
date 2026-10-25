local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local Bidiverger = setmetatable({
    name = "bidiverger",
    k3 = 31,
    title = "Bidiverger",
    description = "Two Divergers in one, pointing opposite ways.",
    routes = {
        [0] = -1,
        [1] = 1,
        [2] = -1,
        [3] = 1
    }
}, { __index = BaseDiverger })
Bidiverger.__index = Bidiverger

return Bidiverger
