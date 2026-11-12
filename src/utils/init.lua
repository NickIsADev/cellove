local utils = {}

for _, file in ipairs(love.filesystem.getDirectoryItems("src/utils")) do
    local name = file:match("^(.+)%.lua$")

    if name and name ~= "init" then
        for key, value in pairs(require("src/utils/" .. name)) do
            utils[key] = value
        end
    end
end

return utils
