local BaseSource = require("src/engine/sources/abstract/BaseSource")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.texturepacks
local text = config.text

local function locate(root, folder, file)
    local path = root and root .. "/" .. folder .. "/" .. file
    if path and love.filesystem.getInfo(path) then return path end
end

local TexturePacks = setmetatable({}, { __index = BaseSource })
TexturePacks.__index = TexturePacks

function TexturePacks.new(data)
    local self = setmetatable({}, TexturePacks)
    self:setup(config, data.settings)
    self.mods = data.mods
    self:_discover()
    return self
end

function TexturePacks:_locked(id)
    if id == config.default then return text.default end

    for _, mod in ipairs(self.mods:linked()) do
        if mod.texturepack == id then return string.format(text.linked, mod.name) end
    end
end

function TexturePacks:_order()
    local ids = {}
    for _, id in ipairs(BaseSource._order(self)) do
        if not self:_locked(id) then ids[#ids + 1] = id end
    end

    for _, mod in ipairs(self.mods:linked()) do
        if not utils.has(ids, mod.texturepack) then ids[#ids + 1] = mod.texturepack end
    end
    ids[#ids + 1] = config.default
    return ids
end

function TexturePacks:_isRoot(directory)
    if love.filesystem.getInfo(directory .. "/" .. config.metadata) then return true end

    for _, marker in ipairs(config.markers) do
        if love.filesystem.getInfo(directory .. "/" .. marker, "directory") then return true end
    end
    return false
end

function TexturePacks:_read(entry)
    local pack = {
        id = entry.id,
        folder = entry.id,
        root = entry.root,
        name = utils.capitalize(entry.id),
        description = "",
        modtime = entry.modtime,
        locked = self:_locked(entry.id)
    }

    local file = entry.root .. "/" .. config.metadata
    if not love.filesystem.getInfo(file) then return pack end

    local ok, data = pcall(love.filesystem.load(file))
    if not ok or type(data) ~= "table" then return pack end

    for _, key in ipairs(config.fields) do
        if type(data[key]) == "string" then pack[key] = data[key] end
    end
    pack.iconPath = data.icon

    return pack
end

function TexturePacks:has(id)
    return self.roots[id] ~= nil
end

function TexturePacks:path(id)
    return self.roots[id] or self.roots[config.default]
end

function TexturePacks:stack()
    return self:_order()
end

function TexturePacks:find(folder, file)
    for _, id in ipairs(self:stack()) do
        local path = locate(self.roots[id], folder, file)
        if path then return path end
    end
end

return TexturePacks
