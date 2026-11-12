local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.text

local function hexOf(renderer, name)
    local hex = name:match("^#(%x%x%x%x%x%x)$")
    return hex and tonumber(hex, 16) or config.colors[name:lower()] or renderer:dominant(utils.texture(name))
end

local function split(state, gap, newline)
    state.word = { gap = gap, newline = newline, items = {} }
    state.words[#state.words + 1] = state.word
end

local function push(state, piece)
    local items = state.word.items
    items[#items + 1] = piece
end

local function write(state, text)
    for word, gap, line in text:gmatch("(%S*)([^%S\n]*)(\n?)") do
        if word ~= "" then push(state, { text = word, color = state.color }) end
        if gap ~= "" or line ~= "" then split(state, gap, line ~= "") end
    end
end

local tags = {
    color = function(state, name)
        if not name then
            state.color = state.base
            return true
        end

        local hex = hexOf(state.renderer, name)
        if hex then state.color = { utils.fromHex(hex, state.alpha) } end
        return hex
    end,
    cell = function(state, id)
        if id then push(state, { cell = utils.texture(id), color = { 1, 1, 1, state.alpha } }) end
        return true
    end
}

local function apply(state, tag)
    local name, arg = tag:match("^(%w+):(.*)$")
    local handler = tags[name or tag:match("^/(%w+)$")]
    return handler and handler(state, arg)
end

local function parse(renderer, text, base, alpha)
    local state = { renderer = renderer, base = base, color = base, alpha = alpha or 1, words = {} }
    split(state, "", false)

    for segment in text:gmatch("<?[^<]*") do
        local tag, body = segment:match("^<(.-)>(.*)$")

        if not (tag and apply(state, tag)) then body = segment end
        write(state, body)
    end
    return state.words
end

local function newLine(layout)
    local line = { items = {}, width = 0 }
    layout.lines[#layout.lines + 1] = line
    return line
end

local RichText = {}
RichText.__index = RichText

function RichText.new(renderer, text, color, alpha)
    local self = setmetatable({}, RichText)
    self.renderer = renderer
    self.words = parse(renderer, text, color, alpha)
    return self
end

function RichText:_layout(font, wrap)
    local cache = self.cache
    if cache and cache.font == font and cache.wrap == wrap then return cache end

    local limit = wrap or math.huge
    local size = font:getBaseline()
    local layout = { font = font, wrap = wrap, lines = {}, width = 0 }
    local line = newLine(layout)

    for _, word in ipairs(self.words) do
        local total = 0

        if word.newline then line = newLine(layout) end
        for _, piece in ipairs(word.items) do
            piece.width = piece.cell and size or font:getWidth(piece.text)
            total = total + piece.width
        end

        if total > 0 then
            local gap = line.width > 0 and font:getWidth(word.gap) or 0
            if line.width > 0 and line.width + gap + total > limit then line, gap = newLine(layout), 0 end

            local x = line.width + gap
            for _, piece in ipairs(word.items) do
                piece.x = x
                x = x + piece.width
                line.items[#line.items + 1] = piece
            end
            line.width = x
            layout.width = math.max(layout.width, x)
        end
    end

    self.cache = layout
    return layout
end

function RichText:measure(font, wrap)
    local layout = self:_layout(font, wrap)
    return layout.width, #layout.lines * font:getHeight()
end

function RichText:draw(x, y, wrap, align, tint)
    local font = love.graphics.getFont()
    local layout = self:_layout(font, wrap)
    local height = font:getHeight()
    local size = font:getBaseline()

    for index, line in ipairs(layout.lines) do
        local left = x + (align == "center" and math.floor(((wrap or layout.width) - line.width) / 2) or 0)
        local top = y + (index - 1) * height

        for _, piece in ipairs(line.items) do
            love.graphics.setColor(tint or piece.color)
            if piece.cell then
                self.renderer:drawCell(piece.cell, left + piece.x, top, size)
            else
                love.graphics.print(piece.text, left + piece.x, top)
            end
        end
    end
end

return RichText
