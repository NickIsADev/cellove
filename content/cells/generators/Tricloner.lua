local Trigenerator = require("content/cells/generators/Trigenerator")

local Tricloner = setmetatable({
    name = "tricloner",
    k3 = 171,
    title = "Tricloner",
    description = "Trigenerator that does not rotate the generated cells.",
    rotates = false
}, { __index = Trigenerator })
Tricloner.__index = Tricloner

return Tricloner
