local Maker = require("content/cells/generators/Maker")

local Backmaker = setmetatable({
    name = "backmaker",
    k3 = 1068,
    title = "Backmaker",
    description = "Back version of Maker.",
    retreat = "always"
}, { __index = Maker })
Backmaker.__index = Backmaker

return Backmaker
