local utils = {}

for _, name in ipairs({ "color", "strings", "graphics", "calc", "lists", "encoding", "files", "version" }) do
    for key, value in pairs(require("src/utils/" .. name)) do
        utils[key] = value
    end
end

return utils
