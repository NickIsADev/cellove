local CrossMaker = require("content/cells/generators/CrossMaker")

local CrossBackmaker = setmetatable({
    name = "crossbackmaker",
    k3 = 1069,
    title = "Cross Backmaker",
    description = "Back version of Cross Maker.",
    retreat = "always"
}, { __index = CrossMaker })
CrossBackmaker.__index = CrossBackmaker

return CrossBackmaker
