local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local StraightDiverger = setmetatable({
    name = "straightdiverger",
    k3 = 38,
    title = "Straight Diverger",
    description = "Lets cells pass straight through along its axis.",
    routes = { [0] = 0, [2] = 0 }
}, { __index = BaseDiverger })
StraightDiverger.__index = StraightDiverger

return StraightDiverger
