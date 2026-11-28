local SuperBigenerator = require("content/cells/supergenerators/SuperBigenerator")

local SuperBicloner = setmetatable({
    name = "superbicloner",
    k3 = 610,
    title = "Super Bicloner",
    description = "Super Bigenerator that does not rotate the generated cells.",
    rotates = false
}, { __index = SuperBigenerator })
SuperBicloner.__index = SuperBicloner

return SuperBicloner
