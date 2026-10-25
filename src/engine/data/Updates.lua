local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.updates
local current = constants.version.number

local Updates = {}
Updates.__index = Updates

function Updates.new(data)
    local self = setmetatable({}, Updates)
    self.channel = love.thread.newChannel()

    if data.settings:get("checkUpdates") then
        love.thread.newThread(config.thread):start(self.channel, config.url, config.agent, config.pattern)
    end
    return self
end

function Updates:_latest()
    if self.version == nil then self.version = self.channel:pop() end
    return self.version
end

function Updates:available()
    local latest = self:_latest()
    return latest and utils.outdated(current, latest) and latest
end

return Updates
