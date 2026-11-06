local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.screenshots
local files = constants.contraptions

local Screenshots = {}
Screenshots.__index = Screenshots

function Screenshots.new(data)
    local self = setmetatable({}, Screenshots)
    self.renderer = data.renderer
    return self
end

function Screenshots:_path(name)
    return config.root .. "/" .. name .. config.extension
end

function Screenshots:list()
    local items = {}

    for _, file in ipairs(love.filesystem.getDirectoryItems(config.root)) do
        local name = file:match(config.pattern)
        local path = name and self:_path(name)

        if name then items[#items + 1] = { name = name, path = path, time = love.filesystem.getInfo(path).modtime } end
    end
    table.sort(items, function(a, b) return a.time > b.time end)
    return items
end

function Screenshots:clean(name)
    name = utils.trim(name:gsub(files.forbidden, ""):sub(1, files.maxName))
    name = utils.trim(name:gsub("[%. ]+$", ""))
    return name ~= "" and name or nil
end

function Screenshots:unique(name)
    local candidate, index = name, 1

    while love.filesystem.getInfo(self:_path(candidate)) do
        index = index + 1
        candidate = name .. " (" .. index .. ")"
    end
    return candidate
end

function Screenshots:take(simulator, markers, area)
    local grid = simulator.grid
    local data = self.renderer:capture(simulator, markers, area or { x1 = 1, y1 = 1, x2 = grid.width, y2 = grid.height })

    love.filesystem.createDirectory(config.root)
    data:encode("png", self:_path(os.date(config.name)))
end

function Screenshots:rename(shot, name)
    local path = self:_path(name)
    local data = love.filesystem.read(shot.path)

    if not (data and love.filesystem.write(path, data)) then return false end

    love.filesystem.remove(shot.path)
    shot.name, shot.path = name, path
    return true
end

function Screenshots:delete(shot)
    return love.filesystem.remove(shot.path)
end

function Screenshots:open()
    utils.openFolder(config.root)
end

return Screenshots
