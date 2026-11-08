local Bipipe = require("content/cells/pipes/Bipipe")

local Bitube = setmetatable({
    name = "bitube",
    title = "Bitube",
    description = "Bipipe that doesn't rotate cells.",
    categories = { "tubes" },
    rotates = false
}, { __index = Bipipe })
Bitube.__index = Bitube

return Bitube
