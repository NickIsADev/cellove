local files = {}

function files.openFolder(path)
    love.filesystem.createDirectory(path)
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/" .. path)
end

return files
