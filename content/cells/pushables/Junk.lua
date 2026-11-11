local Pushable = require("content/cells/pushables/Pushable")

local Junk = setmetatable({
    name = "junk",
    k3 = 326,
    title = "Junk",
    description = "A Pushable that counts as an Enemy.",
    hostile = true,
    categories = { "enemies" }
}, { __index = Pushable })
Junk.__index = Junk

return Junk
