local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")

local SuperBigenerator = setmetatable({
    name = "superbigenerator",
    k3 = 606,
    title = "Super Bigenerator",
    description = "Bigenerator that generates entire rows.",
    outputs = { 1, 3 },
    aligns = true
}, { __index = SuperGenerator })
SuperBigenerator.__index = SuperBigenerator

return SuperBigenerator
