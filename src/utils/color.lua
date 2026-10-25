local function channel(h, s, v, n)
    local k = (n + h * 6) % 6
    return v - v * s * math.max(0, math.min(k, 4 - k, 1))
end

local color = {}

function color.fromHex(hex, alpha)
    local r = bit.rshift(bit.band(hex, 0xFF0000), 16) / 255
    local g = bit.rshift(bit.band(hex, 0x00FF00), 8) / 255
    local b = bit.band(hex, 0x0000FF) / 255
    return r, g, b, alpha or 1
end

function color.toHex(r, g, b)
    return math.floor(r * 255 + 0.5) * 65536 + math.floor(g * 255 + 0.5) * 256 + math.floor(b * 255 + 0.5)
end

function color.fromHsv(h, s, v)
    return channel(h, s, v, 5), channel(h, s, v, 3), channel(h, s, v, 1)
end

function color.toHsv(r, g, b)
    local max = math.max(r, g, b)
    local delta = max - math.min(r, g, b)
    local h = 0

    if delta > 0 and max == r then
        h = ((g - b) / delta) % 6
    elseif delta > 0 and max == g then
        h = (b - r) / delta + 2
    elseif delta > 0 then
        h = (r - g) / delta + 4
    end
    return h / 6, max == 0 and 0 or delta / max, max
end

return color
