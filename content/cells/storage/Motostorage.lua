local Settlestorage = require("content/cells/storage/Settlestorage")

local Motostorage = setmetatable({
    name = "motostorage",
    k3 = 1151,
    title = "Motostorage",
    description = "Stores the first cell that moves into it. Turns into it after a tick where it gets moved.",
    moves = true
}, { __index = Settlestorage })
Motostorage.__index = Motostorage

return Motostorage
