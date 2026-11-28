local SuperGenerator = require("content/cells/supergenerators/SuperGenerator")
local BaseBroken = require("content/cells/abstract/BaseBroken")

local BrokenSuperGenerator = setmetatable({
    name = "brokensupergenerator",
    k3 = 1089,
    title = "Broken Super Generator",
    description = "Super Generator that can only be used once. It is destroyed after generating."
}, { __index = SuperGenerator })
BrokenSuperGenerator.__index = BrokenSuperGenerator

BrokenSuperGenerator.generated = BaseBroken.generated

return BrokenSuperGenerator
