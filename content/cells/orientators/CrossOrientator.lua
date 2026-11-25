local BaseOrientator = require("content/cells/abstract/BaseOrientator")

local CrossOrientator = setmetatable({
    name = "crossorientator",
    k3 = 570,
    title = "Cross Orientator",
    description = "Two Orientators in one, facing forward and left.",
    outputs = { 0, 3 }
}, { __index = BaseOrientator })
CrossOrientator.__index = CrossOrientator

return CrossOrientator
