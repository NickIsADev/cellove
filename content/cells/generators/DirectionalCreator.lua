local DirectionalTetramaker = require("content/cells/generators/DirectionalTetramaker")
local constants = require("src/constants")
local stored = constants.renderer.stored

local DirectionalCreator = setmetatable({
    name = "directionalcreator",
    k3 = 427,
    title = "Directional Creator",
    description = "Like an unbreakable Directional Tetramaker.",
    fixed = true,
    anchored = true,
    fit = stored.storage
}, { __index = DirectionalTetramaker })
DirectionalCreator.__index = DirectionalCreator

return DirectionalCreator
