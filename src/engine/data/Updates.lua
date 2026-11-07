local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.updates
local current = constants.version.number

local function bundled()
    return love.filesystem.isFused() or love.filesystem.getSource():find(config.bundle, 1, true) ~= nil
end

local Updates = {}
Updates.__index = Updates

function Updates.new(data)
    local self = setmetatable({}, Updates)
    local checking = data.settings:get("checkUpdates")

    self.channel = love.thread.newChannel()
    self.unsupported = checking and not bundled()

    if checking and not self.unsupported then
        local url = config.url[utils.prerelease(current) and "prerelease" or "stable"]

        love.thread.newThread(config.thread):start(
            self.channel,
            url,
            config.agent,
            config.pattern,
            love.filesystem.getSourceBaseDirectory(),
            config.libraries
        )
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
