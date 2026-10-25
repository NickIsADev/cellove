local Properties = require("src/engine/data/Properties")
local constants = require("src/constants")
local utils = require("src/utils")

local config = constants.contraptions
local limits = constants.grid.limits
local rotating = constants.editor.marker.rotating
local base = constants.registry.base.namespace
local kinds, codes = config.kinds, {}
for code, kind in ipairs(kinds) do
    codes[kind] = code - 1
end

local function byPosition(a, b)
    if a.y ~= b.y then return a.y < b.y end
    return a.x < b.x
end

local function shorten(id)
    return (id:gsub("^" .. base .. ":", ""))
end

local function expand(id)
    return id:find(":") and id or base .. ":" .. id
end

local function custom(entry)
    for _, property in ipairs(entry.class.properties) do
        if Properties.value(entry.props, property) ~= property.default then return true end
    end
end

local function serialize(data)
    local cells = {}
    for _, entry in ipairs(data.cells) do
        cells[#cells + 1] = entry
    end
    table.sort(cells, byPosition)

    local palette, slots, counts = {}, {}, {}
    for _, entry in ipairs(cells) do
        local id = entry.class.id
        if not counts[id] then palette[#palette + 1] = id end
        counts[id] = (counts[id] or 0) + 1
    end

    table.sort(palette, function(a, b)
        if counts[a] ~= counts[b] then return counts[a] > counts[b] end
        return a < b
    end)
    for slot, id in ipairs(palette) do
        slots[id] = slot - 1
    end

    local function code(entry) return slots[entry.class.id] * 4 + entry.rotation end
    local function index(entry) return (entry.y - 1) * data.width + entry.x - 1 end

    local parts = { utils.packVarint(data.width), utils.packVarint(data.height), utils.packVarint(#palette) }
    for _, id in ipairs(palette) do
        parts[#parts + 1] = utils.packString(shorten(id))
    end

    local last, i = 0, 1
    while i <= #cells do
        local entry = cells[i]
        local start, run = index(entry), 1
        while cells[i + run] and code(cells[i + run]) == code(entry) and index(cells[i + run]) == start + run do
            run = run + 1
        end

        parts[#parts + 1] = utils.packVarint(start - last)
        if run > 1 then
            parts[#parts + 1] = utils.packVarint(code(entry) * 2 + 1)
            parts[#parts + 1] = utils.packVarint(run - 2)
        else
            parts[#parts + 1] = utils.packVarint(code(entry) * 2)
        end

        last = start + run
        i = i + run
    end

    local markers = {}
    for _, marker in ipairs(data.markers or {}) do
        markers[#markers + 1] = marker
    end
    table.sort(markers, byPosition)

    if #markers > 0 then
        parts[#parts + 1] = utils.packVarint(data.width * data.height)
        parts[#parts + 1] = utils.packVarint(#markers)

        local at = 0
        for _, marker in ipairs(markers) do
            local code = codes[marker.kind] or config.custom.code
            parts[#parts + 1] = utils.packVarint(code + (marker.color and config.colorFlag or 0))
            parts[#parts + 1] = utils.packVarint(index(marker) - at)
            at = index(marker)

            if not codes[marker.kind] then
                parts[#parts + 1] = utils.packString(marker.kind)
                parts[#parts + 1] = utils.packVarint(marker.rotation or 0)
            elseif rotating[marker.kind] then
                parts[#parts + 1] = utils.packVarint(marker.rotation)
            elseif marker.kind == "label" then
                parts[#parts + 1] = utils.packString(marker.text)
            elseif marker.kind == "box" then
                parts[#parts + 1] = utils.packVarint(marker.width)
                parts[#parts + 1] = utils.packVarint(marker.height)
            end
            if marker.color then parts[#parts + 1] = utils.packVarint(marker.color) end
        end
    end

    local tuned = {}
    for _, entry in ipairs(cells) do
        if custom(entry) then tuned[#tuned + 1] = entry end
    end

    if #tuned > 0 then
        parts[#parts + 1] = utils.packVarint(data.width * data.height + 1)
        parts[#parts + 1] = utils.packVarint(#tuned)

        local at = 0
        for _, entry in ipairs(tuned) do
            local properties = entry.class.properties
            parts[#parts + 1] = utils.packVarint(index(entry) - at)
            parts[#parts + 1] = utils.packVarint(#properties)
            at = index(entry)

            for _, property in ipairs(properties) do
                parts[#parts + 1] = Properties.pack(property, Properties.value(entry.props, property))
            end
        end
    end
    return table.concat(parts)
end

local function parseMarkers(payload, position, width, total)
    local count
    count, position = utils.unpackVarint(payload, position)
    if not count then return end

    local markers, at = {}, 0
    for _ = 1, count do
        local code, gap
        code, position = utils.unpackVarint(payload, position)
        if not code then return end
        gap, position = utils.unpackVarint(payload, position)
        if not gap or at + gap >= total then return end

        at = at + gap
        local slot = code % config.colorFlag
        local marker = {
            x = at % width + 1,
            y = math.floor(at / width) + 1
        }

        if slot == config.custom.code then
            marker.kind, position = utils.unpackString(payload, position)
            if not marker.kind then return end

            marker.rotation, position = utils.unpackVarint(payload, position)
            if not marker.rotation or marker.rotation > 3 then return end
            if not rotating[marker.kind] then marker.rotation = nil end
        else
            marker.kind = kinds[slot + 1]

            if rotating[marker.kind] then
                marker.rotation, position = utils.unpackVarint(payload, position)
                if not marker.rotation or marker.rotation > 3 then return end
            elseif marker.kind == "label" then
                marker.text, position = utils.unpackString(payload, position)
                if not marker.text then return end
            elseif marker.kind == "box" then
                marker.width, position = utils.unpackVarint(payload, position)
                if not marker.width then return end
                marker.height, position = utils.unpackVarint(payload, position)
                if not marker.height then return end
                if marker.width < 1 or marker.height < 1 or marker.x + marker.width - 1 > width or marker.y + marker.height - 1 > total / width then return end
            elseif not marker.kind then return end
        end

        if code >= config.colorFlag then
            marker.color, position = utils.unpackVarint(payload, position)
            if not marker.color or marker.color > 0xFFFFFF then return end
        end
        if slot ~= config.custom.code or config.custom.kinds[marker.kind] then
            markers[#markers + 1] = marker
        end
    end
    return markers, position
end

local function parseProps(payload, position, byIndex, partial)
    local count
    count, position = utils.unpackVarint(payload, position)
    if not count then return end

    local at = 0
    for _ = 1, count do
        local gap, size
        gap, position = utils.unpackVarint(payload, position)
        if not gap then return end
        size, position = utils.unpackVarint(payload, position)
        if not size then return end

        at = at + gap
        local cell = byIndex[at]
        if not cell then return partial and #payload + 1 end

        cell.props = {}
        for slot = 1, size do
            local property, value = cell.class.properties[slot]
            if not property then return end

            value, position = Properties.unpack(property, payload, position)
            if not position then return end
            cell.props[property.id] = value
        end
    end
    return position
end

local function parse(payload, registry)
    local width, position = utils.unpackVarint(payload, 1)
    if not width then return end
    local height
    height, position = utils.unpackVarint(payload, position)
    if not height then return end
    if width < limits.min or height < limits.min or width > limits.max or height > limits.max then return end

    local count
    count, position = utils.unpackVarint(payload, position)
    if not count then return end

    local palette, missing = {}, {}
    for i = 1, count do
        local id
        id, position = utils.unpackString(payload, position)
        if not id then return end

        id = expand(id)
        palette[i] = registry.cells[id]

        local namespace = id:match("^[^:]+")
        if not palette[i] and not utils.has(missing, namespace) then missing[#missing + 1] = namespace end
    end

    local cells, markers, byIndex, index, total = {}, {}, {}, 0, width * height
    while position <= #payload do
        local gap, tag, run = nil, nil, 1

        gap, position = utils.unpackVarint(payload, position)
        if not gap then return end

        if gap == total then
            markers, position = parseMarkers(payload, position, width, total)
            if not markers then return end
        elseif gap == total + 1 then
            position = parseProps(payload, position, byIndex, #missing > 0)
            if not position then return end
        else
            tag, position = utils.unpackVarint(payload, position)
            if not tag then return end

            if tag % 2 == 1 then
                local extra
                extra, position = utils.unpackVarint(payload, position)
                if not extra then return end
                run = extra + 2
            end

            index = index + gap
            if index + run > total then return end

            local code = math.floor(tag / 2)
            local class, rotation = palette[math.floor(code / 4) + 1], code % 4
            if class then
                for at = index, index + run - 1 do
                    local cell = {
                        class = class,
                        rotation = rotation,
                        x = at % width + 1,
                        y = math.floor(at / width) + 1
                    }
                    cells[#cells + 1] = cell
                    byIndex[at] = cell
                end
            end
            index = index + run
        end
    end
    return {
        width = width,
        height = height,
        cells = cells,
        markers = markers,
        missing = missing
    }
end

local CL = {}
CL.__index = CL

function CL.new(data)
    local self = setmetatable({}, CL)
    self.registry = data.registry
    return self
end

function CL:matches(text)
    for _, prefix in pairs(config.prefix) do
        if text:sub(1, #prefix) == prefix then return true end
    end
end

function CL:encode(data)
    local raw = serialize(data)
    local packed = love.data.compress("string", config.compression, raw, config.level)

    if #packed < #raw then return config.prefix.deflate .. utils.encode85(packed, config.alphabet) end
    return config.prefix.raw .. utils.encode85(raw, config.alphabet)
end

function CL:decode(text)
    for mode, prefix in pairs(config.prefix) do
        if text:sub(1, #prefix) == prefix then
            local body = utils.decode85(text:sub(#prefix + 1), config.alphabet)
            local ok, payload = pcall(function()
                if mode == "deflate" then return love.data.decompress("string", config.compression, body) end
                return body
            end)
            return ok and payload and parse(payload, self.registry)
        end
    end
end

return CL
