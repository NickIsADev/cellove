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

return strings
