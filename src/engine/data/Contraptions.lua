local CL = require("src/engine/data/codecs/CL")
local K3 = require("src/engine/data/codecs/K3")
local Events = require("src/engine/modding/Events")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.contraptions

local Contraptions = {}
Contraptions.__index = Contraptions
Contraptions.codecs = { K3 }

function Contraptions.new(data)
    local self = setmetatable({}, Contraptions)
    self.root = data.root or config.root
    self.cl = CL.new({ registry = data.registry })
    self.codecs = { self.cl }
    for _, Codec in ipairs(Contraptions.codecs) do
        self.codecs[#self.codecs + 1] = Codec.new({ registry = data.registry })
    end
    love.filesystem.createDirectory(self.root)
    return self
end

function Contraptions:_path(name)
    return self.root .. "/" .. name .. config.extension
end

function Contraptions:_unpack(text)
    for _, codec in ipairs(self.codecs) do
        if codec:matches(text) then
            local ok, data = pcall(codec.decode, codec, text)
            if ok and data then return data end
            return nil, "corrupt"
        end
    end
    return nil, "prefix"
end

function Contraptions:blank(width, height)
    local size = constants.grid.default
    return {
        width = width or size.width,
        height = height or size.height,
        cells = {},
        markers = {}
    }
end

function Contraptions:clean(name)
    name = utils.trim(name:gsub(config.forbidden, ""):sub(1, config.maxName))
    name = utils.trim(name:gsub("[%. ]+$", ""))
    return name ~= "" and name or nil
end

function Contraptions:unique(name)
    local base = self:clean(name or "") or config.defaultName
    local candidate, index = base, 1
    while love.filesystem.getInfo(self:_path(candidate)) do
        index = index + 1
        candidate = base .. " (" .. index .. ")"
    end
    return candidate
end

function Contraptions:export(data)
    return self.cl:encode(data)
end

function Contraptions:import(text)
    text = (text or ""):gsub("%s+", "")
    if text == "" then return nil, config.errors.empty end

    local data, key = self:_unpack(text)
    if not data then return nil, config.errors[key] end

    Events.emit("contraption:imported", data)
    return data
end

function Contraptions:text(name)
    return love.filesystem.read(self:_path(name))
end

function Contraptions:load(name)
    local text = self:text(name)
    if not text then return nil, config.errors.unreadable end
    return self:import(text)
end

function Contraptions:save(name, data)
    love.filesystem.createDirectory(self.root)
    return love.filesystem.write(self:_path(name), self:export(data))
end

function Contraptions:rename(name, newName)
    local text = self:text(name)
    return text and love.filesystem.write(self:_path(newName), text) and love.filesystem.remove(self:_path(name))
end

function Contraptions:delete(name)
    return love.filesystem.remove(self:_path(name))
end

function Contraptions:fromFile(file)
    local name = file:getFilename():match("([^/\\]+)$"):match(config.pattern)
    if not name then return nil, nil, config.errors.prefix end

    if not file:open("r") then return nil, nil, config.errors.unreadable end
    local text = file:read()
    file:close()

    local data, err = self:import(text)
    return name, data, err
end

function Contraptions:list()
    local entries = {}
    for _, item in ipairs(love.filesystem.getDirectoryItems(self.root)) do
        local name = item:match(config.pattern)
        local info = name and love.filesystem.getInfo(self.root .. "/" .. item, "file")
        if info then
            local entry = { name = name, modtime = info.modtime or 0 }
            local data = self:load(name)
            if data then
                entry.valid, entry.width, entry.height, entry.count = true, data.width, data.height, #data.cells
                entry.missing = data.missing
            end
            entries[#entries + 1] = entry
        end
    end

    table.sort(entries, function(a, b)
        if a.modtime ~= b.modtime then return a.modtime > b.modtime end
        return a.name:lower() < b.name:lower()
    end)
    return entries
end

function Contraptions:open()
    utils.openFolder(self.root)
end

return Contraptions
