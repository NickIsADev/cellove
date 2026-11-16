local BaseCell = require("content/cells/abstract/BaseCell")

local SuperKey = setmetatable({
    name = "superkey",
    k3 = 584,
    title = "Super Key",
    description = "Destroys a Door it moves into, and takes its place.",
    categories = { "keys" },
    key = "door",
    survives = true
}, { __index = BaseCell })
SuperKey.__index = SuperKey

return SuperKey
