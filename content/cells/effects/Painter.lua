local BaseEffectGiver = require("content/cells/abstract/BaseEffectGiver")
local BaseCell = require("content/cells/abstract/BaseCell")
local Paint = require("content/effects/Paint")
local utils = require("src/utils")

local Painter = setmetatable({
    name = "painter",
    k3 = 745,
    title = "Painter",
    description = "Paints the cell it's pointing at with it's own paint.",
    faces = { 0 },
    outputs = { 0 },
    inclusive = false,
    properties = {
        { id = "paint", title = "Paint (hex)", default = "", limit = 6 }
    }
}, { __index = BaseEffectGiver })
Painter.__index = Painter

function Painter:_color()
    return tonumber(self.props.paint, 16)
end

function Painter:_affect(cell)
    local color = self:_color()

    if color then
        Paint:apply(cell, color)
    else
        Paint:remove(cell)
    end
end

function Painter:draw(renderer, ...)
    local color = self:_color()
    if not color then return BaseCell.draw(self, renderer, ...) end

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(utils.fromHex(color, a))
    BaseCell.draw(self, renderer, ...)
    love.graphics.setColor(r, g, b, a)
end

return Painter
