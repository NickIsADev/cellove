local Trimaker = require("content/cells/generators/Trimaker")

local Tribackmaker = setmetatable({
    name = "tribackmaker",
    k3 = 1071,
    title = "Tribackmaker",
    description = "Back version of Trimaker.",
    retreat = "always"
}, { __index = Trimaker })
Tribackmaker.__index = Tribackmaker

return Tribackmaker
