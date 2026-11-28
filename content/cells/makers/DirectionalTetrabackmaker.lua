local DirectionalTetramaker = require("content/cells/generators/DirectionalTetramaker")

local DirectionalTetrabackmaker = setmetatable({
    name = "directionaltetrabackmaker",
    k3 = 1076,
    title = "Directional Tetrabackmaker",
    description = "Back version of Directional Tetramaker.",
    retreat = "always"
}, { __index = DirectionalTetramaker })
DirectionalTetrabackmaker.__index = DirectionalTetrabackmaker

return DirectionalTetrabackmaker
