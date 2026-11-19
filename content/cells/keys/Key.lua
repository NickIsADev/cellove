local BaseCell = require("content/cells/abstract/BaseCell")

local Key = setmetatable({
    name = "key",
    k3 = 153,
    title = "Key",
    description = "Destroys a Door it moves into, and is destroyed with it.",
    categories = { "unlocking" },
    key = "door"
}, { __index = BaseCell })
Key.__index = Key

return Key
