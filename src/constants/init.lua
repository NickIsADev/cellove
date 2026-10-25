local constants = {}

for _, name in ipairs({ "simulation", "cells", "data", "engine", "graphics", "sources", "ui", "menu", "puzzles", "editor", "toolbar", "markers", "version" }) do
    for key, value in pairs(require("src/constants/" .. name)) do
        constants[key] = value
    end
end

return constants
