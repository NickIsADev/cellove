local BaseCell = require("content/cells/abstract/BaseCell")
local Audio = require("src/engine/audio/Audio")
local Keys = require("content/stores/Keys")

local colors, names = Keys.colors, Keys.names

local CollectableKey = setmetatable({
    name = "collectablekey",
    k3 = 1180,
    title = "Collectable Key",
    description = "Unlocks Collectable Key Doors of its color when a cell moves into it.",
    categories = { "collectables" },
    hollow = true,
    properties = {
        { id = "color", title = "Color", default = 1, min = 1, max = #colors, swatches = colors }
    }
}, { __index = BaseCell })
CollectableKey.__index = CollectableKey

function CollectableKey:eats(dx, dy, action)
    return action ~= "swap"
end

function CollectableKey:ate()
    Keys.collect(self.grid, self.props.color)
    Audio.play("coin")
    self.spark = "greysparkle"
    self:kill()
    return true
end

function CollectableKey:preview(props)
    return self.texture .. "_" .. names[props.color]
end

return CollectableKey
