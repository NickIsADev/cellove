local SelectScene = require("src/scenes/abstract/SelectScene")
local constants = require("src/constants")

local config = constants.mods
local text = config.text
local colors = constants.ui.colors

local ModsScene = setmetatable({}, { __index = SelectScene })
ModsScene.__index = ModsScene

function ModsScene.new(data)
    local self = setmetatable({}, ModsScene)
    self:setup(data, config, data.mods)
    self.texturePacks = data.texturePacks
    return self
end

function ModsScene:_issue(mod)
    if not mod.error and mod.texturepack and not self.texturePacks:has(mod.texturepack) then
        return string.format(text.pack, mod.texturepack), colors.danger
    end
    return SelectScene._issue(self, mod)
end

return ModsScene
