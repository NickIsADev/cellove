local DirectionalTetramaker = require("content/cells/generators/DirectionalTetramaker")

local DirectionalCreator = setmetatable({
    name = "directionalcreator",
    k3 = 427,
    title = "Directional Creator",
    description = "Like an unbreakable Directional Tetramaker.",
    fixed = true,
    anchored = true
}, { __index = DirectionalTetramaker })
DirectionalCreator.__index = DirectionalCreator

return DirectionalCreator
