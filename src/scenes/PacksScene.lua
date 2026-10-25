local SelectScene = require("src/scenes/abstract/SelectScene")
local constants = require("src/constants")

local PacksScene = setmetatable({}, { __index = SelectScene })
PacksScene.__index = PacksScene

function PacksScene.new(data)
    local self = setmetatable({}, PacksScene)
    self:setup(data, constants.texturepacks, data.texturePacks)
    return self
end

return PacksScene
