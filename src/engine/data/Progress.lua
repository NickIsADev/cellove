local constants = require("src/constants")

local config = constants.progress

local Progress = {}
Progress.__index = Progress

function Progress.new()
    local self = setmetatable({}, Progress)
    self.solved = {}
    self:_load()
    return self
end

function Progress:_load()
    local text = love.filesystem.read(config.path)
    if not text then return end

    for id in text:gmatch("[^\r\n]+") do
        self.solved[id] = true
    end
end

function Progress:_save()
    local ids = {}
    for id in pairs(self.solved) do
        ids[#ids + 1] = id
    end
    table.sort(ids)

    love.filesystem.write(config.path, table.concat(ids, "\n") .. "\n")
end

function Progress:reset()
    self.solved = {}
    self:_save()
end

function Progress:has(id)
    return self.solved[id] == true
end

function Progress:complete(id)
    if self.solved[id] then return end

    self.solved[id] = true
    self:_save()
end

return Progress
