local BaseTool = require("src/editor/tools/abstract/BaseTool")
local Markers = require("src/engine/simulation/Markers")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.editor.marker
local ghost = constants.editor.ghost
local colors = constants.ui.colors
local fixed = constants.markers.fixed
local presets = constants.markers.presets
local colored = constants.markers.colored

local Marker = setmetatable({}, { __index = BaseTool })
Marker.__index = Marker

function Marker.new(editor)
    local self = setmetatable({}, Marker)
    self:setup(editor, config.buttons)
    for _, preset in ipairs(presets) do
        self.byId[preset.id].color = preset.color
    end
    self:reset()
    return self
end

function Marker:_label(gx, gy)
    local editor = self.editor
    if not editor.simulator.grid:bounds(gx, gy) then return end

    local existing = editor.markers:at(gx, gy)
    editor.prompt:open({
        title = config.prompt.title,
        message = config.prompt.message,
        confirm = config.prompt.confirm,
        text = existing and existing.text or "",
        onConfirm = function(text)
            editor:setMarker(gx, gy, {
                kind = "label",
                x = gx,
                y = gy,
                rotation = editor.targetRotation % 4,
                text = text,
                color = self.color
            })
            editor:commit()
        end
    })
end

function Marker:_stretch(gx, gy)
    local grid = self.editor.simulator.grid
    local x, y = utils.clamp(gx, 1, grid.width), utils.clamp(gy, 1, grid.height)

    self.box = {
        kind = "box",
        x = math.min(self.anchor[1], x),
        y = math.min(self.anchor[2], y),
        width = math.abs(self.anchor[1] - x) + 1,
        height = math.abs(self.anchor[2] - y) + 1,
        color = self.color
    }
end

function Marker:_paint(gx, gy)
    local editor = self.editor

    if self.kind == "placeable" then
        editor:setPlaceable(gx, gy, not self.erasing and self.color)
    elseif self.erasing then
        editor:setMarker(gx, gy)
    else
        editor:setMarker(gx, gy, {
            kind = self.kind,
            x = gx,
            y = gy,
            rotation = editor.targetRotation % 4
        })
    end
end

function Marker:reset()
    self.kind, self.color = config.default, config.color
    self:leave()
end

function Marker:leave()
    self.anchor, self.box = nil, nil
end

function Marker:click(id)
    local hue = self.byId[id].color

    if hue then self.color = hue else self.kind = id end
end

function Marker:refresh()
    local turn = self.editor.visualRotation * math.pi / 2

    for id, button in pairs(self.byId) do
        button.tint = id == self.kind and colors.accent or colors.white
        button.rotation = fixed[id] and 0 or turn
    end
    for _, preset in ipairs(presets) do
        local swatch = self.byId[preset.id]

        swatch.selected = preset.color == self.color
        swatch.enabled = colored[self.kind]
    end
end

function Marker:press(gx, gy, button)
    local editor = self.editor

    if self.kind == "box" then
        if button == 2 then
            local box = editor.markers:boxAt(gx, gy)
            if box then editor:removeArea(box) end
            return false
        end

        local grid = editor.simulator.grid
        self.anchor = { utils.clamp(gx, 1, grid.width), utils.clamp(gy, 1, grid.height) }
        self:_stretch(gx, gy)
        return true
    end

    self.erasing = button == 2
    if self.kind == "label" and not self.erasing then return self:_label(gx, gy) end

    self.x, self.y = gx, gy
    self:_paint(gx, gy)
    return true
end

function Marker:move(gx, gy)
    if self.box then
        self:_stretch(gx, gy)
    else
        self:_drag(gx, gy)
    end
end

function Marker:release()
    if self.box then self.editor:addArea(self.box) end
    self.anchor, self.box = nil, nil
end

function Marker:draw(gx, gy)
    local editor = self.editor

    if self.box then return editor.renderer:drawMarkers({ self.box }) end
    if not (gx and editor.simulator.grid:bounds(gx, gy)) then return end

    if self.kind == "label" or Markers.areas[self.kind] then
        editor.renderer:drawBox(gx, gy, gx, gy, self.kind == "placeable" and self.color or colors.white)
    else
        editor.renderer:drawMarkers({
            {
                kind = self.kind,
                x = gx,
                y = gy,
                rotation = editor.visualRotation
            }
        }, ghost)
    end
end

return Marker
