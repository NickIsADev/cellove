local BaseCell = require("content/cells/abstract/BaseCell")

local ToggleKey = setmetatable({
    name = "togglekey",
    k3 = 705,
    title = "Toggle Key",
    description = "Turns a Toggle Door into a Toggle Gate and back when it moves into one, and is destroyed.",
    categories = { "unlocking" },
    key = "toggle"
}, { __index = BaseCell })
ToggleKey.__index = ToggleKey

return ToggleKey
