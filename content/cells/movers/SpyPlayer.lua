local Player = require("content/cells/movers/Player")
local constants = require("src/constants")
local utils = require("src/utils")

local SpyPlayer = setmetatable({
    name = "spyplayer",
    k3 = 846,
    title = "Spy Player",
    description = "Player that disguises as a neighboring cell with Z or Enter, and drops the disguise with another press. Sentries, Turrets and Seekers see the disguise instead of a Player. Cannot disguise as an ungeneratable or moving cell.",
    properties = {
        { id = "disguise", title = "Disguise", default = {} }
    }
}, { __index = Player })
SpyPlayer.__index = SpyPlayer

function SpyPlayer:_mask(content)
    local props = utils.copy(self.props)
    props.disguise = content
    self.props = props
end

function SpyPlayer:_disguise()
    for direction = 0, 3 do
        local facing = constants.directions[direction]
        local x, y = self.x + facing[1], self.y + facing[2]
        local cell = self.grid:bounds(x, y) and self.grid:get(x, y)

        if cell and cell:cloneable() and not cell.path then
            local class, props = cell:template()
            if class and class ~= SpyPlayer then
                return self:_mask({ class = class, rotation = cell.rotation, props = props })
            end
        end
    end
end

function SpyPlayer:side()
    local mask = self.props.disguise.class
    if mask then return mask:side() end
    return Player.side(self)
end

function SpyPlayer:preview(props)
    local mask = props.disguise.class
    return mask and mask.texture or Player.preview(self, props)
end

function SpyPlayer:update(_, direction)
    local simulator = self.simulator
    local input = simulator.input
    if direction ~= (input or 0) then return end

    if simulator.action then
        if self.props.disguise.class then self:_mask({}) else self:_disguise() end
    end
    if input then self:_move(unpack(constants.directions[input])) end
end

function SpyPlayer:draw(renderer, x, y, angle, scale, offset)
    Player.draw(self, renderer, x, y, angle, scale, offset)
    if self.props.disguise.class then renderer:drawSprite("spyoverlay", x, y, angle, scale, offset) end
end

return SpyPlayer
