local BaseSource = require("src/engine/sources/BaseSource")
local Patcher = require("src/engine/modding/Patcher")
local API = require("src/engine/modding/API")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.mods
local text = config.text
local base = constants.registry.base.namespace

local function escape(path)
    return (path:gsub("%p", "%%%0"))
end

local function describe(err, root)
    err = tostring(err)

    local message = err:match("[^\r\n]+") or err
    for _, prefix in ipairs({ root, "src/engine/modding" }) do
        message = message:gsub("^" .. escape(prefix) .. "/[%w_/%.%-]+%.lua:%d+: ", "")
    end

    local file, line = err:match(escape(root) .. "/([^\r\n:]+):(%d+)")
    return file and string.format(text.location, message, file, line) or message
end

local function problem(entry, data)
    local id = data.id

    if entry.id:find("%.") then return text.dots end
    if type(id) ~= "string" or not id:match(constants.registry.pattern) or id == base then return text.id end
end

local Mods = setmetatable({}, { __index = BaseSource })
Mods.__index = Mods

function Mods.new(data)
    local self = setmetatable({}, Mods)
    self:setup(config, data.settings)
    self.loaded = {}
    self.byId = {}
    self.claims = {}
    self.scenes = {}
    return self
end

function Mods:_isRoot(directory)
    return love.filesystem.getInfo(directory .. "/" .. config.metadata) ~= nil
end

function Mods:_read(entry)
    local mod = {
        folder = entry.id,
        root = entry.root,
        name = utils.capitalize(entry.id),
        description = "",
        modtime = entry.modtime
    }

    local ok, data = pcall(love.filesystem.load(entry.root .. "/" .. config.metadata))
    if not ok or type(data) ~= "table" then
        mod.error = text.invalid
        return mod
    end

    for _, field in ipairs(config.fields) do
        if type(data[field]) == "string" then mod[field] = data[field] end
    end
    mod.texturepack = data.texturepack
    mod.dependencies = type(data.dependencies) == "table" and data.dependencies or {}
    mod.iconPath = data.icon
    mod.error = problem(entry, data)
    mod.id = not mod.error and data.id or nil

    local started = self.byId[mod.id]
    mod.error = mod.error or started and started.error
    mod.warning = started and started.warning

    return mod
end

function Mods:_needs(mod, found)
    for _, id in ipairs(mod.dependencies) do
        local needed = found[id]
        if needed then self:_start(needed, found) end
        if not needed or needed.error then return id end
    end
end

function Mods:_start(mod, found)
    if self.byId[mod.id] then return end

    mod.cells = {}
    mod.exports = {}
    self.byId[mod.id] = mod

    local missing = self:_needs(mod, found)
    self.loaded[#self.loaded + 1] = mod
    mod.error = missing and string.format(text.dependency, missing)
    if mod.error then return end

    local ok, err = xpcall(function()
        local path = mod.root .. "/" .. config.main
        if love.filesystem.getInfo(path) then assert(love.filesystem.load(path))()(API.new(self, mod)) end
    end, debug.traceback)
    if not ok then mod.error = describe(err, mod.root) end
end

function Mods:load()
    Patcher.hook()

    local order, found = self:_order(), {}
    local entries = self:_discover()
    table.sort(entries, function(a, b) return a.id < b.id end)

    for _, entry in ipairs(entries) do
        local mod = self:_read(entry)
        if utils.has(order, mod.id) then found[mod.id] = found[mod.id] or mod end
    end

    for _, id in ipairs(order) do
        if found[id] then self:_start(found[id], found) end
    end
end

function Mods:each(callback)
    for _, mod in ipairs(self.loaded) do
        if not mod.error then
            local ok, err = xpcall(function() callback(mod) end, debug.traceback)
            if not ok then mod.error = describe(err, mod.root) end
        end
    end
end

function Mods:claim(mod, key)
    local owner = self.byId[self.claims[key]]
    self.claims[key] = self.claims[key] or mod.id
    if not owner or owner == mod then return end

    owner.warning = owner.warning or string.format(text.conflict, mod.name, key)
    mod.warning = mod.warning or string.format(text.conflict, owner.name, key)
end

function Mods:failed()
    local list = {}
    for _, mod in ipairs(self.loaded) do
        if mod.error then list[#list + 1] = mod end
    end
    return list
end

function Mods:linked()
    local list = {}
    for _, mod in ipairs(self.loaded) do
        if mod.texturepack and not mod.error then list[#list + 1] = mod end
    end
    return list
end

function Mods:status()
    local status = {
        enabled = self:count(),
        failed = #self:failed(),
        conflicts = 0
    }

    for _, mod in ipairs(self.loaded) do
        if mod.warning and not mod.error then status.conflicts = status.conflicts + 1 end
    end
    return status
end

return Mods
