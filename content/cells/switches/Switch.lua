local BaseCell = require("content/cells/abstract/BaseCell")
local Audio = require("src/engine/audio/Audio")
local Switches = require("content/stores/Switches")

local Switch = setmetatable({
    name = "switch",
    k3 = 563,
    title = "Switch",
    description = "Toggles every Switch Door, Switch Gate and Switch of its ID when a cell moves into it, and deletes that cell.",
    categories = { "trashes" },
    fixed = true,
    destroys = true,
    switch = true,
    properties = {
        { id = "id", title = "ID", default = 0, min = 0, max = 99 },
        { id = "on", title = "On", default = false }
    }
}, { __index = BaseCell })
Switch.__index = Switch

function Switch:eats()
    return true
end

function Switch:absorb()
    Audio.play("destroy")
    Switches.flip(self.grid, self.props.id)
end

function Switch:preview(props)
    return props.on and self.texture .. "_on" or self.texture
end

function Switch:sprite()
    return Switches.on(self.grid, self.props.id) and self.texture .. "_on" or self.texture
end

function Switch:draw(renderer, ...)
    BaseCell.draw(self, renderer, ...)
    renderer:drawTag(self.props.id, ...)
end

return Switch
