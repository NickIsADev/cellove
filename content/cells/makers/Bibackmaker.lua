local Bimaker = require("content/cells/generators/Bimaker")

local Bibackmaker = setmetatable({
    name = "bibackmaker",
    k3 = 1070,
    title = "Bibackmaker",
    description = "Back version of Bimaker.",
    retreat = "always"
}, { __index = Bimaker })
Bibackmaker.__index = Bibackmaker

return Bibackmaker
