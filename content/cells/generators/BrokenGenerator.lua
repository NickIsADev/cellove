local Generator = require("content/cells/generators/Generator")
local BaseBroken = require("content/cells/abstract/BaseBroken")

local BrokenGenerator = setmetatable({
    name = "brokengenerator",
    k3 = 301,
    title = "Broken Generator",
    description = "Generator that can only be used once. It is destroyed after generating."
}, { __index = Generator })
BrokenGenerator.__index = BrokenGenerator

BrokenGenerator.generated = BaseBroken.generated

return BrokenGenerator
