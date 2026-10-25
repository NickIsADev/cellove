local utils = require("src/utils")

local BaseSource = {}
BaseSource.__index = BaseSource

function BaseSource:setup(config, settings)
    self.config = config
    self.settings = settings
    self.boot = settings:get(config.setting)
    self.roots = {}
    self.mounted = {}
end

function BaseSource:_isRoot(directory)
end

function BaseSource:_read(entry)
end

function BaseSource:_order()
    local ids = {}
    for id in self.settings:get(self.config.setting):gmatch("[^,]+") do
        if not utils.has(ids, id) then ids[#ids + 1] = id end
    end
    return ids
end

function BaseSource:_locate(directory)
    if self:_isRoot(directory) then return directory end

    local inner
    for _, item in ipairs(love.filesystem.getDirectoryItems(directory)) do
        local path = directory .. "/" .. item
        if item ~= self.config.ignored and love.filesystem.getInfo(path, "directory") then
            if inner then return directory end
            inner = path
        end
    end

    return inner and self:_isRoot(inner) and inner or directory
end

function BaseSource:_mount(id, archive)
    if not self.mounted[id] then
        self.mounted[id] = love.filesystem.mount(archive, self.config.root .. "/" .. id)
    end
    return self.mounted[id]
end

function BaseSource:_icon(directory, icon)
    if type(icon) ~= "string" then return end

    local path = directory .. "/" .. icon
    if not love.filesystem.getInfo(path) then return end

    local ok, image = pcall(love.graphics.newImage, path)
    return ok and image or nil
end

function BaseSource:_discover()
    local root = self.config.root
    local items = love.filesystem.getDirectoryItems(root)
    local entries, taken = {}, {}

    for _, item in ipairs(items) do
        local path = root .. "/" .. item
        local info = love.filesystem.getInfo(path, "directory")
        if info and not self.mounted[item] then
            taken[item] = true
            entries[#entries + 1] = {
                id = item,
                directory = path,
                modtime = info.modtime or 0
            }
        end
    end

    for _, item in ipairs(items) do
        local path = root .. "/" .. item
        local id = item:match(self.config.archive)
        local info = id and not taken[id] and love.filesystem.getInfo(path, "file")
        if info and self:_mount(id, path) then
            entries[#entries + 1] = {
                id = id,
                directory = root .. "/" .. id,
                modtime = info.modtime or 0
            }
        end
    end

    self.roots = {}
    for _, entry in ipairs(entries) do
        entry.root = self:_locate(entry.directory)
        self.roots[entry.id] = entry.root
    end

    return entries
end

function BaseSource:count()
    return #self:_order()
end

function BaseSource:status()
    return { enabled = self:count(), failed = 0, conflicts = 0 }
end

function BaseSource:changed()
    return self.settings:get(self.config.setting) ~= self.boot
end

function BaseSource:save(list)
    local ids = {}
    for _, item in ipairs(list) do
        if not item.locked then ids[#ids + 1] = item.id end
    end
    self.settings:set(self.config.setting, table.concat(ids, ","))
end

function BaseSource:install(file)
    local config = self.config
    local text = config.text
    local name = file:getFilename():match("([^/\\]+)$")
    local id = name:match(config.archive)
    if not id then return nil, text.notArchive end

    local path = config.root .. "/" .. name
    if love.filesystem.getInfo(path) or love.filesystem.getInfo(config.root .. "/" .. id) then
        return nil, string.format(text.exists, id)
    end

    local data = file:open("r") and file:read()
    file:close()
    if not data then return nil, text.unreadable end

    love.filesystem.createDirectory(config.root)
    if not love.filesystem.write(path, data) then return nil, text.writeFailed end
    return id
end

function BaseSource:scan()
    local active, available, order = {}, {}, {}
    for index, id in ipairs(self:_order()) do
        order[id] = index
    end

    for _, entry in ipairs(self:_discover()) do
        local item = self:_read(entry)

        item.enabled = order[item.id] ~= nil
        item.icon = self:_icon(item.root, item.iconPath)
        table.insert(item.enabled and active or available, item)
    end

    table.sort(active, function(a, b) return order[a.id] < order[b.id] end)
    table.sort(available, function(a, b) return a.name:lower() < b.name:lower() end)
    return active, available
end

function BaseSource:open()
    utils.openFolder(self.config.root)
end

return BaseSource
