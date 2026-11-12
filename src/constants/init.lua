local constants = {}

for _, file in ipairs(love.filesystem.getDirectoryItems("src/constants")) do
    local name = file:match("^(.+)%.lua$")

    if name and name ~= "init" then
        for key, value in pairs(require("src/constants/" .. name)) do
            constants[key] = value
        end
    end
end

return constants
