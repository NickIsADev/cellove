local ToughTrash = require("content/cells/destroyers/ToughTrash")

local Semitrash = setmetatable({
    name = "semitrash",
    k3 = 226,
    title = "Semitrash",
    description = "Deletes any cell that moves into its front or back. Acts like a Pushable on the other sides.",
    fixed = false
}, { __index = ToughTrash })
Semitrash.__index = Semitrash

return Semitrash
