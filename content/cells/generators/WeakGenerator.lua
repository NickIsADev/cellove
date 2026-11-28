local Generator = require("content/cells/generators/Generator")

local WeakGenerator = setmetatable({
    name = "weakgenerator",
    k3 = 366,
    title = "Weak Generator",
    description = "Generator that cannot push.",
    pushing = { force = 0 }
}, { __index = Generator })
WeakGenerator.__index = WeakGenerator

return WeakGenerator
