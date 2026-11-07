local CellBrowser = require("src/ui/abstract/CellBrowser")
local IconButton = require("src/ui/widgets/IconButton")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.library
local colors = constants.ui.colors

local function addBox(x, y, width, height)
    local size = config.row.add
    return x + width - size - config.row.pad, y + (height - size) / 2, size
end

local Library = setmetatable({}, { __index = CellBrowser })
Library.__index = Library

function Library.new(data)
    local self = setmetatable({}, Library)
    self:setup({ renderer = data.renderer, onPick = data.onPick })
    self.registry = data.registry
    self.hotkeys = data.hotkeys
    self.toolbar = data.toolbar
    self.prompt = data.prompt
    self.fresh = data.fresh
    self.reset = IconButton.new({
        id = "reset",
        renderer = data.renderer,
        folder = "cells",
        texture = config.reset.texture,
        size = config.reset.size,
        title = config.reset.title,
        description = config.reset.description
    })

    self.tools[#self.tools + 1] = self.reset
    self.actions.reset = self._askReset
    return self
end

function Library:_askReset()
    local text = config.reset.prompt

    self.prompt:open({
        title = text.title,
        message = text.message,
        confirm = text.confirm,
        onConfirm = function() self.toolbar:restore() end
    })
end

function Library:_shines(class)
    return self.fresh:has(class)
end

function Library:_drawExtras(class, x, y, width, height)
    local bx, by, size = addBox(x, y, width, height)
    local icon = self.renderer.textures.ui[self.toolbar:has(class) and "subtract" or "add"]
    local alpha = utils.inside(love.mouse.getX(), love.mouse.getY(), bx, by, size, size) and 1 or 0.6

    love.graphics.setColor(utils.fromHex(colors.white, alpha))
    love.graphics.draw(icon, bx, by, 0, size / icon:getWidth(), size / icon:getHeight())
end

function Library:_describe(class, index, x, y)
    local bx, by, size = addBox(self.cells:bounds(index))
    if not utils.inside(x, y, bx, by, size, size) then return CellBrowser._describe(self, class) end

    local text = self.toolbar:has(class) and config.remove or config.add
    return text.title, text.description
end

function Library:_choose(class, index, x, y)
    self.fresh:clear(class)

    local bx, by, size = addBox(self.cells:bounds(index))
    if utils.inside(x, y, bx, by, size, size) or love.keyboard.isDown("lshift", "rshift") then
        self.toolbar:toggle(class)
    else
        self:_pick(class)
    end
end

function Library:open()
    CellBrowser.open(self, self.registry:list())
end

function Library:keypressed(key)
    if self.active and self.hotkeys:pressed("library", key) then
        self:close()
        return true
    end
    return CellBrowser.keypressed(self, key)
end

return Library
