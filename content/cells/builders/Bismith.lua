local Bibuilder = require("content/cells/builders/Bibuilder")

local Bismith = setmetatable({
    name = "bismith",
    k3 = 337,
    title = "Bismith",
    description = "Bibuilder that does not rotate cells.",
    rotates = false
}, { __index = Bibuilder })
Bismith.__index = Bismith

return Bismith
