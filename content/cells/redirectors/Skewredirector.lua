local BaseRedirector = require("content/cells/abstract/BaseRedirector")

local Skewredirector = setmetatable({
    name = "skewredirector",
    k3 = 1044,
    title = "Skewredirector",
    description = "Redirector that only redirects diagonal neighbors.",
    sides = { diagonal = true }
}, { __index = BaseRedirector })
Skewredirector.__index = Skewredirector

return Skewredirector
