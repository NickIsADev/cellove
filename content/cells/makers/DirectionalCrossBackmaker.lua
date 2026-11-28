local DirectionalCrossMaker = require("content/cells/generators/DirectionalCrossMaker")

local DirectionalCrossBackmaker = setmetatable({
    name = "directionalcrossbackmaker",
    k3 = 1073,
    title = "Directional Cross Backmaker",
    description = "Back version of Directional Cross Maker.",
    retreat = "always"
}, { __index = DirectionalCrossMaker })
DirectionalCrossBackmaker.__index = DirectionalCrossBackmaker

return DirectionalCrossBackmaker
