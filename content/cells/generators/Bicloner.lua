local Bigenerator = require("content/cells/generators/Bigenerator")

local Bicloner = setmetatable({
    name = "bicloner",
    k3 = 172,
    title = "Bicloner",
    description = "Bigenerator that does not rotate the generated cells.",
    rotates = false
}, { __index = Bigenerator })
Bicloner.__index = Bicloner

return Bicloner
