local BaseDiverger = require("content/cells/abstract/BaseDiverger")

local DiodeDiverger = setmetatable({
    name = "diodediverger",
    k3 = 208,
    title = "Diode Diverger",
    description = "Lets cells pass straight through in one direction only.",
    routes = { [2] = 0 },
    reverse = { [0] = 0 }
}, { __index = BaseDiverger })
DiodeDiverger.__index = DiodeDiverger

return DiodeDiverger
