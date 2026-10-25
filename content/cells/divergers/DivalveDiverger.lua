local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local DivalveDiverger = setmetatable({
    name = "divalvediverger",
    k3 = 433,
    title = "Divalve Diverger",
    description = "Sends cells out the front. Accepts them from both sides, but not behind.",
    routes = { [1] = 1, [3] = -1 },
    reverse = { [2] = -1 }
}, { __index = BaseDiverger })
DivalveDiverger.__index = DivalveDiverger

return DivalveDiverger
