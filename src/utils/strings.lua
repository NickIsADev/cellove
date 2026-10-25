local constants = require("src/constants")
local fromHex = require("src/utils/color").fromHex

local function tagColor(tag)
    local hex = tag:match("^#(%x%x%x%x%x%x)$")
    return hex and tonumber(hex, 16) or constants.tags[tag:lower()]
end

local strings = {}

function strings.capitalize(text)
    return (text:gsub("^%l", string.upper))
end

function strings.trim(text)
    return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

function strings.texture(id)
    return (id:gsub(":", "/"))
end

function strings.colored(text, default, alpha)
    local result, color = {}, default

    for segment in text:gmatch("<?[^<]*") do
        local tag, body = segment:match("^<(.-)>(.*)$")
        local hex = tag and tagColor(tag)

        if hex then
            color = { fromHex(hex, alpha) }
        elseif tag and tag:find("^/") then
            color = default
        else
            body = segment
        end
        result[#result + 1] = color
        result[#result + 1] = body
    end
    return result
end

function strings.plain(text)
    local colored, parts = strings.colored(text, {}), {}
    for index = 2, #colored, 2 do
        parts[#parts + 1] = colored[index]
    end
    return table.concat(parts)
end

return strings
