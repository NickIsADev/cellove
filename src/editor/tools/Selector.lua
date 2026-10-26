local BaseTool = require("src/editor/tools/abstract/BaseTool")
local Markers = require("src/engine/simulation/Markers")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.editor.selection
local files = constants.contraptions
local ghost = constants.editor.ghost
local rotating = constants.editor.marker.rotating
local colors = constants.ui.colors

local shortcuts = config.shortcuts

local function rotated(clip, amount)
    local width, height = clip.width, clip.height
    local function place(x, y)
        if amount > 0 then return height - y + 1, x end
        return y, width - x + 1
    end

    local result = {
        width = height,
        height = width,
        cells = {},
        markers = {}
    }
    for _, cell in ipairs(clip.cells) do
        local x, y = place(cell.x, cell.y)
        result.cells[#result.cells + 1] = {
            class = cell.class,
            rotation = (cell.rotation + amount) % 4,
            props = cell.props,
            x = x,
            y = y
        }
    end
    for _, marker in ipairs(clip.markers) do
        local x1, y1 = place(marker.x, marker.y)
        local x2, y2 = place(Markers.extent(marker))
        local turned = {
            kind = marker.kind,
            x = math.min(x1, x2),
            y = math.min(y1, y2),
            text = marker.text,
            color = marker.color
        }
        if marker.kind == "box" then turned.width, turned.height = math.abs(x1 - x2) + 1, math.abs(y1 - y2) + 1 end
        if rotating[marker.kind] then turned.rotation = (marker.rotation + amount) % 4 end
        result.markers[#result.markers + 1] = turned
    end
    return result
end

local Selector = setmetatable({}, { __index = BaseTool })
Selector.__index = Selector

function Selector.new(editor)
    local self = setmetatable({}, Selector)
    self:setup(editor, config.buttons)
    self.actions = {
        copy = self._copy,
        cut = self._cut,
        paste = self._paste,
        export = self._export,
        import = self._import,
        save = self._saveStamp,
        stamps = self._openStamps
    }
    return self
end

function Selector:_inside(x, y)
    local area = self.area
    return x >= area.x1 and x <= area.x2 and y >= area.y1 and y <= area.y2
end

function Selector:_holds(marker)
    local x2, y2 = Markers.extent(marker)
    return self:_inside(marker.x, marker.y) and self:_inside(x2, y2)
end

function Selector:_clamp(gx, gy)
    local grid = self.editor.simulator.grid
    return utils.clamp(gx, 1, grid.width), utils.clamp(gy, 1, grid.height)
end

function Selector:_extend(gx, gy)
    gx, gy = self:_clamp(gx, gy)

    self.area = {
        x1 = math.min(self.anchor[1], gx),
        y1 = math.min(self.anchor[2], gy),
        x2 = math.max(self.anchor[1], gx),
        y2 = math.max(self.anchor[2], gy)
    }
end

function Selector:_capture()
    local area, editor = self.area, self.editor
    local data = {
        width = area.x2 - area.x1 + 1,
        height = area.y2 - area.y1 + 1,
        cells = {},
        markers = {}
    }

    for y = area.y1, area.y2 do
        for x = area.x1, area.x2 do
            local cell = editor.simulator.grid:get(x, y)
            if cell then
                data.cells[#data.cells + 1] = {
                    class = getmetatable(cell),
                    rotation = cell.rotation,
                    props = cell.props,
                    x = x - area.x1 + 1,
                    y = y - area.y1 + 1
                }
            end
        end
    end

    for _, marker in ipairs(editor.markers.items) do
        if self:_holds(marker) then
            data.markers[#data.markers + 1] = Markers.offset(marker, 1 - area.x1, 1 - area.y1)
        end
    end
    return data
end

function Selector:_clear()
    local area, editor = self.area, self.editor

    for y = area.y1, area.y2 do
        for x = area.x1, area.x2 do
            editor:setCell(x, y, nil)
        end
    end
    local items = editor.markers.items
    for i = #items, 1, -1 do
        local marker = items[i]
        if self:_holds(marker) then
            if Markers.areas[marker.kind] then editor:removeArea(marker) else editor:setMarker(marker.x, marker.y, nil) end
        end
    end
    editor:commit()
end

function Selector:_stamp(gx, gy)
    local clip, editor = self.clip, self.editor
    local ox, oy = self:_origin(gx, gy)

    for _, cell in ipairs(clip.cells) do
        editor:setCell(cell.x + ox, cell.y + oy, cell)
    end
    for _, marker in ipairs(clip.markers) do
        local moved = Markers.offset(marker, ox, oy)
        if Markers.areas[moved.kind] then editor:addArea(moved) else editor:setMarker(moved.x, moved.y, moved) end
    end
end

function Selector:_origin(gx, gy)
    return gx - math.floor(self.clip.width / 2) - 1, gy - math.floor(self.clip.height / 2) - 1
end

function Selector:_copy()
    self.clip = self:_capture()
    self.editor.toast:show(config.text.copied)
end

function Selector:_cut()
    self.clip = self:_capture()
    self:_clear()
    self.editor.toast:show(config.text.cut)
end

function Selector:_all()
    local grid = self.editor.simulator.grid

    self.pasting = false
    self.area = {
        x1 = 1,
        y1 = 1,
        x2 = grid.width,
        y2 = grid.height
    }
end

function Selector:_turn(amount)
    self.clip = rotated(self.clip, amount)
end

function Selector:_paste()
    if self.clip then
        self.pasting = true
    else
        self.editor.toast:show(config.text.empty, true)
    end
end

function Selector:_export()
    love.system.setClipboardText(self.editor.contraptions:export(self:_capture()))
    self.editor.toast:show(config.text.exported)
end

function Selector:_import()
    local data, err = self.editor.contraptions:import(love.system.getClipboardText())
    if not data then return self.editor.toast:show(err, true) end

    self:load(data)
end

function Selector:_saveStamp()
    local editor, stamps = self.editor, self.editor.stamps
    local text, data = config.text.stamp, self:_capture()

    editor.prompt:open({
        title = text.title,
        message = text.message,
        confirm = text.confirm,
        text = stamps:unique(text.default),
        filter = files.forbidden,
        limit = files.maxName,
        onConfirm = function(name)
            name = stamps:unique(name)
            local saved = stamps:save(name, data)
            editor.toast:show(saved and string.format(text.saved, name) or text.failed, not saved)
        end
    })
end

function Selector:_openStamps()
    self.editor.stampList:open()
end

function Selector:load(data)
    self.clip, self.pasting = data, true
end

function Selector:click(id)
    self.actions[id](self)
end

function Selector:refresh()
    self.byId.copy.enabled = self.area ~= nil
    self.byId.cut.enabled = self.area ~= nil
    self.byId.export.enabled = self.area ~= nil
    self.byId.save.enabled = self.area ~= nil
    self.byId.paste.enabled = self.clip ~= nil
end

function Selector:press(gx, gy, button)
    if self.pasting then
        if button == 1 then self:_stamp(gx, gy) else self.pasting = false end
        return false
    end

    if button == 2 then
        self.area = nil
        return false
    end

    self.anchor = { self:_clamp(gx, gy) }
    self:_extend(gx, gy)
    return true
end

function Selector:move(gx, gy)
    self:_extend(gx, gy)
end

function Selector:release()
    self.anchor = nil
end

function Selector:keypressed(key)
    if key == "escape" then
        if self.pasting then
            self.pasting = false
            return true
        elseif self.area then
            self.area = nil
            return true
        end
        return false
    end

    local hotkeys = self.editor.hotkeys
    local turn = hotkeys:turn(key)

    if self.pasting and turn ~= 0 then
        self:_turn(turn)
        return true
    end

    if (key == "delete" or key == "backspace") and self.area and not self.pasting then
        self:_clear()
        return true
    end

    if hotkeys:pressed("selectAll", key) then
        self:_all()
        return true
    end

    for _, action in ipairs(shortcuts) do
        if hotkeys:pressed(action, key) then
            if self.byId[action].enabled then
                self.actions[action](self)
            elseif action == "paste" then
                self.editor.toast:show(config.text.empty, true)
            end
            return true
        end
    end
end

function Selector:draw(gx, gy)
    local renderer = self.editor.renderer

    if self.pasting then
        if not gx then return end

        local clip = self.clip
        local ox, oy = self:_origin(gx, gy)
        renderer:drawGhosts(clip.cells, ox, oy, ghost)
        renderer:drawMarkers(clip.markers, ghost, ox, oy)
        renderer:drawBox(ox + 1, oy + 1, ox + clip.width, oy + clip.height, colors.accent)
    elseif self.area then
        local area = self.area
        renderer:drawBox(area.x1, area.y1, area.x2, area.y2, colors.white)
    end
end

function Selector:leave()
    self.pasting, self.area, self.anchor = false, nil, nil
end

function Selector:reset()
    self:leave()
    self.clip = nil
end

return Selector
