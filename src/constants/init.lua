local constants = {}

for _, name in ipairs({ "simulation", "cells", "data", "scene", "reload", "audio", "debug", "graphics", "sources", "ui", "menu", "hotkeys", "puzzles", "editor", "toolbar", "markers", "version", "updates" }) do
    for key, value in pairs(require("src/constants/" .. name)) do
        constants[key] = value
    end
end

return constants
