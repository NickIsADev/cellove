local Paragenerator = require("content/cells/generators/Paragenerator")

local Tetragenerator = setmetatable({
    name = "tetragenerator",
    k3 = 364,
    title = "Tetragenerator",
    description = "Four Generators in one.",
    outputs = { 0, 1, 2, 3 }
}, { __index = Paragenerator })
Tetragenerator.__index = Tetragenerator

return Tetragenerator
