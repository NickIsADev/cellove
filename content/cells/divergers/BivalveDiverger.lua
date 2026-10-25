local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local BivalveDiverger = setmetatable({
    name = "bivalvediverger",
    k3 = 83,
    title = "Bivalve Diverger",
    description = "Sends cells out the front. Accepts them from behind and both sides.",
    routes = {
        [1] = 1,
        [2] = 0,
        [3] = -1
    },
    reverse = { [2] = 0 }
}, { __index = BaseDiverger })
BivalveDiverger.__index = BivalveDiverger

return BivalveDiverger
