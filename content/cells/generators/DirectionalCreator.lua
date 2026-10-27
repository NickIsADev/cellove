local DirectionalTetramaker = require("content/cells/generators/DirectionalTetramaker")

local DirectionalCreator = setmetatable({
    name = "directionalcreator",
    k3 = 427,
    title = "Directional Creator",
    description = "Like an unbreakable Directional Tetramaker."
}, { __index = DirectionalTetramaker })
DirectionalCreator.__index = DirectionalCreator

function DirectionalCreator:transformable()
    return false
end

return DirectionalCreator
