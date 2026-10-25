local encoding = {}

function encoding.packVarint(value)
    local bytes = {}
    while value >= 128 do
        bytes[#bytes + 1] = string.char(value % 128 + 128)
        value = math.floor(value / 128)
    end
    bytes[#bytes + 1] = string.char(value)
    return table.concat(bytes)
end

function encoding.unpackVarint(data, position)
    local value, scale = 0, 1
    while scale < 2 ^ 35 do
        local byte = data:byte(position)
        if not byte then return end

        position = position + 1
        value = value + (byte % 128) * scale
        if byte < 128 then return value, position end
        scale = scale * 128
    end
end

function encoding.packString(text)
    return encoding.packVarint(#text) .. text
end

function encoding.unpackString(data, position)
    local length
    length, position = encoding.unpackVarint(data, position)
    if not length or position + length - 1 > #data then return end
    return data:sub(position, position + length - 1), position + length
end

function encoding.encode85(data, alphabet)
    local out = {}
    for i = 1, #data, 4 do
        local a, b, c, d = data:byte(i, i + 3)
        local count = (d and 4) or (c and 3) or (b and 2) or 1
        local value = ((a * 256 + (b or 0)) * 256 + (c or 0)) * 256 + (d or 0)

        local chars = {}
        for j = 5, 1, -1 do
            local digit = value % 85
            chars[j] = alphabet:sub(digit + 1, digit + 1)
            value = math.floor(value / 85)
        end
        out[#out + 1] = table.concat(chars, "", 1, count + 1)
    end
    return table.concat(out)
end

function encoding.decode85(text, alphabet)
    local lookup = {}
    for i = 1, #alphabet do lookup[alphabet:byte(i)] = i - 1 end

    local out = {}
    for i = 1, #text, 5 do
        local group = text:sub(i, i + 4)
        local count = #group
        if count == 1 then return end

        local value = 0
        for j = 1, 5 do
            local digit = 84
            if j <= count then
                digit = lookup[group:byte(j)]
                if not digit then return end
            end
            value = value * 85 + digit
        end
        if value >= 2 ^ 32 then return end

        local bytes = string.char(
            math.floor(value / 16777216) % 256,
            math.floor(value / 65536) % 256,
            math.floor(value / 256) % 256,
            value % 256
        )
        out[#out + 1] = bytes:sub(1, count == 5 and 4 or count - 1)
    end
    return table.concat(out)
end

return encoding
