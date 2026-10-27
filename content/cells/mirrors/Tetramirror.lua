local BaseMirror = require("content/cells/abstract/BaseMirror")

local Tetramirror = setmetatable({
    name = "tetramirror",
    k3 = 80,
    title = "Tetramirror",
    description = "Four Mirrors in one, along every axis and diagonal.",
    swaps = {
        { 0, 2 },
        { 1, 3 },
        { 0.5, 2.5 },
        { 1.5, 3.5 }
    }
}, { __index = BaseMirror })
Tetramirror.__index = Tetramirror

return Tetramirror
