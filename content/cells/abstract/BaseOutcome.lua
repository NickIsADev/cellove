local BaseCell = require("content/cells/abstract/BaseCell")
local Audio = require("src/engine/audio/Audio")

local BaseOutcome = setmetatable({
    name = "outcome",
    fixed = true,
    destroys = true,
    properties = {
        { id = "id", title = "ID", default = 0, min = 0, max = 99 },
        { id = "on", title = "Enabled", default = false }
    }
}, { __index = BaseCell })
BaseOutcome.__index = BaseOutcome

function BaseOutcome:new(data)
    local cell = BaseCell.new(self, data)

    cell.enabled = cell.props.on
    return cell
end

function BaseOutcome:eats()
    return true
end

function BaseOutcome:absorb()
    Audio.play("destroy")
    self.enabled = not self.enabled
end

function BaseOutcome:group()
    return self.props.id
end

function BaseOutcome:lit()
    return self.enabled
end

function BaseOutcome:preview(props)
    return props.on and self.texture .. "_on" or self.texture
end

function BaseOutcome:sprite()
    return self.enabled and self.texture .. "_on" or self.texture
end

function BaseOutcome:draw(renderer, ...)
    BaseCell.draw(self, renderer, ...)
    renderer:drawTag(self.props.id, ...)
end

return BaseOutcome
