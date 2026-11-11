local AttackTrash = require("content/cells/destroyers/AttackTrash")

local AttackPhantom = setmetatable({
    name = "attackphantom",
    k3 = 695,
    title = "Attack Phantom",
    description = "An Attack Trash that cannot be generated.",
    phantom = true
}, { __index = AttackTrash })
AttackPhantom.__index = AttackPhantom

return AttackPhantom
