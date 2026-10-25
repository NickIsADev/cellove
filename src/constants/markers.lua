local markers = {
    kinds = { "arrow", "label" },
    rotating = {},
    buttons = {}
}
local icons = {
    {
        id = "arrow",
        title = "Arrow",
        rotates = true
    },
    {
        id = "diagonal_arrow",
        title = "Diagonal Arrow",
        rotates = true
    },
    { id = "check", title = "Check" },
    { id = "x", title = "Cross" },
    { id = "plus", title = "Plus" },
    { id = "subtract", title = "Minus" },
    { id = "divide", title = "Divide" },
    { id = "equal", title = "Equal" },
    { id = "question", title = "Question" },
    { id = "exclamation", title = "Exclamation" },
    { id = "interrobang", title = "Interrobang" },
    { id = "warning", title = "Warning" },
    { id = "stop", title = "Stop" },
    { id = "like", title = "Like" },
    { id = "dislike", title = "Dislike" }
}
for _, icon in ipairs(icons) do
    if icon.id ~= "arrow" then markers.kinds[#markers.kinds + 1] = icon.id end
    markers.rotating[icon.id] = icon.rotates
    markers.buttons[#markers.buttons + 1] = {
        kind = "icon",
        id = icon.id,
        folder = "markers",
        texture = icon.id,
        title = icon.title,
        description = "Places the " .. icon.title:lower() .. " marker."
    }
end
markers.kinds[#markers.kinds + 1] = "box"
markers.kinds[#markers.kinds + 1] = "placeable"
markers.buttons[#markers.buttons + 1] = {
    kind = "icon",
    id = "placeable",
    folder = "ui",
    texture = "puzzle",
    title = "Placeable",
    description = "Paint tiles where cells can be moved in puzzles."
}
markers.buttons[#markers.buttons + 1] = {
    kind = "icon",
    id = "box",
    folder = "ui",
    texture = "select",
    title = "Box",
    description = "Drag to outline an area with a box."
}
markers.buttons[#markers.buttons + 1] = {
    kind = "icon",
    id = "label",
    folder = "markers",
    texture = "label",
    title = "Label",
    description = "Places a text label."
}
markers.buttons[#markers.buttons + 1] = { kind = "separator", id = "divider" }
markers.buttons[#markers.buttons + 1] = {
    kind = "swatch",
    id = "color",
    title = "Color",
    description = "Picks the color of labels and boxes."
}

return { markers = markers }
