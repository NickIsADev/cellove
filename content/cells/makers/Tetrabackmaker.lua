local Tetramaker = require("content/cells/generators/Tetramaker")

local Tetrabackmaker = setmetatable({
    name = "tetrabackmaker",
    k3 = 1072,
    title = "Tetrabackmaker",
    description = "Back version of Tetramaker.",
    retreat = "always"
}, { __index = Tetramaker })
Tetrabackmaker.__index = Tetrabackmaker

return Tetrabackmaker
