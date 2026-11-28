local Tetramaker = require("content/cells/generators/Tetramaker")
local constants = require("src/constants")
local stored = constants.renderer.stored

local Creator = setmetatable({
    name = "creator",
    k3 = 235,
    title = "Creator",
    description = "Like an unbreakable Tetramaker.",
    fixed = true,
    anchored = true,
    fit = stored.storage
}, { __index = Tetramaker })
Creator.__index = Creator

return Creator
