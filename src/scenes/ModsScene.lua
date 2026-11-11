local SelectScene = require("src/scenes/abstract/SelectScene")
local constants = require("src/constants")

local config = constants.mods

local ModsScene = setmetatable({}, { __index = SelectScene })
ModsScene.__index = ModsScene

function ModsScene.new(data)
    local self = setmetatable({}, ModsScene)
    self:setup(data, config, data.mods)
    return self
end

return ModsScene
