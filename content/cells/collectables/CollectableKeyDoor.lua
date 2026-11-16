local BaseCell = require("content/cells/abstract/BaseCell")
local Audio = require("src/engine/audio/Audio")
local Keys = require("content/stores/Keys")
local constants = require("src/constants")

local colors, names = constants.keys.colors, constants.keys.names

local CollectableKeyDoor = setmetatable({
    name = "collectablekeydoor",
    k3 = 1181,
    title = "Collectable Key Door",
    description = "Cannot be pushed or destroyed. Once a Collectable Key of its color is collected, it is destroyed when something tries to move into it, like a Staller.",
    categories = { "collectables" },
    fixed = true,
    properties = {
        { id = "color", title = "Color", default = 1, min = 1, max = #colors, swatches = colors }
    }
}, { __index = BaseCell })
CollectableKeyDoor.__index = CollectableKeyDoor

function CollectableKeyDoor:bump()
    if not Keys.held(self.grid, self.props.color) then return end

    Audio.play("unlock")
    Audio.play("destroy")
    self.spark = "greysparkle"
    self.simulator.movement:destroy(self)
end

function CollectableKeyDoor:preview(props)
    return self.texture .. "_" .. names[props.color]
end

return CollectableKeyDoor
