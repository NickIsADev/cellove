local Properties = require("src/engine/registry/Properties")
local constants = require("src/constants")

local config = constants.k3
local limits = constants.grid.limits
local tokens = config.tokens
local held = config.held
local base, digits, codes, slots = #config.alphabet, {}, {}, {}
for index = 1, base do
    digits[config.alphabet:sub(index, index)] = index - 1
end
for id, kind in pairs(config.markers) do
    codes[kind] = id
end
for slot, id in ipairs(config.borders) do
    slots[id] = slot - 1
end

local function number(text)
    local negative = text:sub(1, 1) == ">"
    local value = 0

    for char in text:sub(negative and 2 or 1):gmatch(".") do
        value = value * base + digits[char]
    end
    return negative and -value or value
end

local function numeral(value)
    local text = ""
    repeat
        local digit = value % base
        text = config.alphabet:sub(digit + 1, digit + 1) .. text
        value = math.floor(value / base)
    until value == 0
    return text
end

local function pack(code)
    local text = numeral(code)
    if code < base then return text end
    if code < base ^ 2 then return tokens.wide .. numeral(0):rep(2 - #text) .. text end
    return tokens.long .. numeral(#text) .. text
end

local function quote(text)
    return tokens.quote .. text:gsub("[\\<]", "\\%0") .. tokens.quote
end

local function write(value)
    return type(value) == "string" and quote(value) or pack(value)
end

local function entry(id, rotation)
    if type(id) == "string" then return write(id) .. rotation end
    return pack(id * 4 + rotation)
end

local function token(text, pos)
    local char = text:sub(pos, pos)

    if char == "(" then return number(text:sub(pos + 1, pos + 2)), pos + 3 end
    if char ~= ")" then return number(char), pos + 1 end

    local size = number(text:sub(pos + 1, pos + 1))
    return number(text:sub(pos + 2, pos + 1 + size)), pos + 2 + size
end

local function quoted(text, pos)
    local chars, escaped = {}, false

    pos = pos + 1
    local char = text:sub(pos, pos)
    while char ~= "<" or escaped do
        assert(char ~= "", "unterminated string")
        if char == "\\" and not escaped then
            escaped = true
        else
            chars[#chars + 1] = char
            escaped = false
        end
        pos = pos + 1
        char = text:sub(pos, pos)
    end
    return table.concat(chars), pos + 1
end

local function read(text, pos)
    if text:sub(pos, pos) == "<" then return quoted(text, pos) end
    return token(text, pos)
end

local function stores(class)
    local first = class.properties[1]
    return first and first.id == held.property
end

local K3 = {}
K3.__index = K3

function K3.new(data)
    local self = setmetatable({}, K3)
    self.classes, self.ids = {}, {}
    for _, class in ipairs(data.registry:list()) do
        local id = rawget(class, "k3")
        if id then self.classes[id], self.ids[class] = class, id end
    end
    return self
end

function K3:_supported(cell)
    for _, property in ipairs(cell.class.properties) do
        local value = Properties.value(cell.props, property)

        if property.id == held.property and value.class then
            if not self.ids[value.class] or Properties.custom(value) then return false end
        elseif value ~= property.default then
            return false
        end
    end
    return true
end

function K3:_stored(cell)
    local content = cell.props and cell.props[held.property]
    if not (content and content.class) then return "" end

    return tokens.property .. pack(held.id) .. write(self.ids[content.class])
        .. tokens.property .. pack(held.rotation) .. pack(content.rotation)
end

function K3:_property(target, key, value)
    if target.kind == "label" then
        if key == 1 then target.text = tostring(value) end
    elseif stores(target.class) then
        if key == held.id then
            target.props = { [held.property] = { class = self.classes[value], rotation = 0 } }
        elseif key == held.rotation and target.props then
            target.props[held.property].rotation = value % 4
        end
    end
end

function K3:supports(data)
    if data.border and not slots[self.ids[data.border]] then return false end

    for _, cell in ipairs(data.cells) do
        if not self.ids[cell.class] or not self:_supported(cell) then return false end
    end

    for _, marker in ipairs(data.markers or {}) do
        if not (codes[marker.kind] or marker.kind == "placeable") or marker.color then return false end
    end
    return true
end

function K3:matches(text)
    return text:sub(1, #config.prefix) == config.prefix
end

function K3:decode(text)
    local width, height, body = text:match("^" .. config.prefix .. "[^;]*;([^;]*);([^;]*);(.*)$")
    local border, data = (body or ""):match("^(.):?[^;]*;([^;]*)")
    if not data then return end

    width, height = number(width), number(height)
    if width < limits.min or height < limits.min or width > limits.max or height > limits.max then return end

    local raw = love.data.decompress("string", "zlib", love.data.decode("string", "base64", data))
    local cells, markers, index, layer, pos, last = {}, {}, 0, 0, 1

    while pos <= #raw do
        local char = raw:sub(pos, pos)
        local x, y = index % width + 1, math.floor(index / width) + 1

        if char == "\\" then
            index = index - 1
            layer, pos = number(raw:sub(pos + 1, pos + 1)), pos + 2
        elseif char == "]" then
            pos = select(2, read(raw, pos + 1))
            if y <= height then markers[#markers + 1] = { kind = "placeable", x = x, y = y } end
        elseif char == "[" then
            local key, value
            key, pos = read(raw, pos + 1)
            value, pos = read(raw, pos)

            if last then self:_property(last, key, value) end
        else
            local id, rotation
            if char == "<" then
                id, pos = quoted(raw, pos)
                rotation, pos = tonumber(raw:sub(pos, pos)), pos + 1
            else
                local code
                code, pos = token(raw, pos)
                id, rotation = math.floor(code / 4), code % 4
            end

            local class = layer == 0 and self.classes[id]
            local kind = config.markers[id]

            last = nil
            if class and y <= height then
                last = { class = class, rotation = rotation, x = x, y = y }
                cells[#cells + 1] = last
            elseif kind and y <= height then
                local marker = { kind = kind, x = x, y = y, rotation = rotation }
                markers[#markers + 1] = marker
                if kind == "label" then marker.text, last = config.label, marker end
            end
            layer, index = 0, index + 1
        end
    end
    return {
        width = width,
        height = height,
        border = self.classes[config.borders[number(border) + 1]],
        cells = cells,
        markers = markers
    }
end

function K3:encode(data)
    local cells, marks = {}, {}
    for _, cell in ipairs(data.cells) do
        cells[(cell.y - 1) * data.width + cell.x] = entry(self.ids[cell.class], cell.rotation) .. self:_stored(cell)
    end

    for _, marker in ipairs(data.markers or {}) do
        local at = (marker.y - 1) * data.width + marker.x
        marks[at] = marks[at] or {}
        table.insert(marks[at], marker)
    end

    local parts = {}
    for at = 1, data.width * data.height do
        for _, marker in ipairs(marks[at] or {}) do
            if marker.kind == "placeable" then parts[#parts + 1] = tokens.placeable .. quote(config.placeable) end
        end

        parts[#parts + 1] = cells[at] or pack(0)
        for _, marker in ipairs(marks[at] or {}) do
            local code = codes[marker.kind]
            if code then
                parts[#parts + 1] = tokens.layer .. numeral(1) .. pack(code * 4 + (marker.rotation or 0))
                if marker.kind == "label" then parts[#parts + 1] = tokens.property .. pack(1) .. quote(marker.text or "") end
            end
        end
    end

    local packed = love.data.compress("string", config.compression, table.concat(parts))
    local body = love.data.encode("string", "base64", packed)
    local border = slots[self.ids[data.border]] or 0
    return table.concat({ config.prefix, numeral(data.width), numeral(data.height), numeral(border), body, "" }, ";")
end

return K3
