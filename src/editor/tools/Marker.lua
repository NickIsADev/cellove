local BaseTool = require("src/editor/tools/abstract/BaseTool")
local Markers = require("src/engine/simulation/Markers")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.editor.marker
local ghost = constants.editor.ghost
local colors = constants.ui.colors
local rotating = config.rotating

local Marker = setmetatable({}, { __index = BaseTool })
Marker.__index = Marker

function Marker.new(editor)
    local self = setmetatable({}, Marker)
    self:setup(editor, config.buttons)
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

function Marker:reset()
    self.kind, self.color = config.default, config.color
    self:leave()
end

function Marker:leave()
    self.anchor, self.box = nil, nil
end

function Marker:click(id)
    if id == "color" then
        self.editor.picker:open(self.color, function(color) self.color = color end)
    else
        self.kind = id
    end
end

function Marker:refresh()
    for id, button in pairs(self.byId) do
        button.tint = id == self.kind and colors.accent or colors.white
    end
    self.byId.color.color = self.color
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

    if self.kind == "placeable" then
        self.paint = button == 1
        editor:setPlaceable(gx, gy, self.paint)
        return true
    end

    if button == 2 then
        editor:setMarker(gx, gy, nil)
    elseif self.kind == "label" then
        self:_label(gx, gy)
    else
        local rotation = rotating[self.kind] and editor.targetRotation % 4
        editor:setMarker(gx, gy, {
            kind = self.kind,
            x = gx,
            y = gy,
            rotation = rotation or nil
        })
    end
end

function Marker:move(gx, gy)
    if self.kind == "placeable" then return self.editor:setPlaceable(gx, gy, self.paint) end

    self:_stretch(gx, gy)
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
        editor.renderer:drawBox(gx, gy, gx, gy, colors.white)
    else
        local rotation = rotating[self.kind] and editor.visualRotation
        editor.renderer:drawMarkers({
            {
                kind = self.kind,
                x = gx,
                y = gy,
                rotation = rotation or nil
            }
        }, ghost)
    end
end

return Marker
