local Tetramaker = require("content/cells/generators/Tetramaker")

local Creator = setmetatable({
    name = "creator",
    k3 = 235,
    title = "Creator",
    description = "Like an unbreakable Tetramaker.",
    fixed = true,
    anchored = true
}, { __index = Tetramaker })
Creator.__index = Creator

return Creator
