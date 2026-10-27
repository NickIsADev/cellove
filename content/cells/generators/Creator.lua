local Tetramaker = require("content/cells/generators/Tetramaker")

local Creator = setmetatable({
    name = "creator",
    k3 = 235,
    title = "Creator",
    description = "Like an unbreakable Tetramaker."
}, { __index = Tetramaker })
Creator.__index = Creator

function Creator:transformable()
    return false
end

return Creator
