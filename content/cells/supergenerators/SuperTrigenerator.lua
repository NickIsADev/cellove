local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")

local SuperTrigenerator = setmetatable({
    name = "supertrigenerator",
    k3 = 607,
    title = "Super Trigenerator",
    description = "Trigenerator that generates entire rows.",
    outputs = { 0, 1, 3 },
    aligns = true
}, { __index = SuperGenerator })
SuperTrigenerator.__index = SuperTrigenerator

return SuperTrigenerator
