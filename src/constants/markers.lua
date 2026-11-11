local function icon(id, title)
    return {
        kind = "icon",
        id = id,
        folder = "markers",
        texture = id,
        title = title,
        description = "Places the " .. title:lower() .. " marker."
    }
end

local presets = {
    { id = "white", title = "White", color = 0xFFFFFF },
    { id = "red", title = "Red", color = 0xFF4040 },
    { id = "orange", title = "Orange", color = 0xFF9A40 },
    { id = "yellow", title = "Yellow", color = 0xFFE640 },
    { id = "green", title = "Green", color = 0x4DDB4D },
    { id = "cyan", title = "Cyan", color = 0x40E0E0 },
    { id = "blue", title = "Blue", color = 0x4D7FFF },
    { id = "purple", title = "Purple", color = 0xB04DFF }
}

local buttons = {
    icon("arrow", "Arrow"),
    icon("diagonal_arrow", "Diagonal Arrow"),
    icon("check", "Check"),
    icon("x", "Cross"),
    icon("plus", "Plus"),
    icon("subtract", "Minus"),
    icon("divide", "Divide"),
    icon("equal", "Equal"),
    icon("question", "Question"),
    icon("exclamation", "Exclamation"),
    icon("interrobang", "Interrobang"),
    icon("warning", "Warning"),
    icon("stop", "Stop"),
    icon("like", "Like"),
    icon("dislike", "Dislike"),
    { kind = "separator", id = "shapes" },
    icon("label", "Label"),
    {
        kind = "icon",
        id = "box",
        folder = "ui",
        texture = "select",
        title = "Box",
        description = "Drag to outline an area with a box."
    },
    {
        kind = "icon",
        id = "placeable",
        folder = "ui",
        texture = "puzzle",
        title = "Placeable",
        description = "Paint tiles where cells can be moved in puzzles. Cells only move between tiles of the same color."
    },
    { kind = "separator", id = "colors" }
}

for _, preset in ipairs(presets) do
    buttons[#buttons + 1] = {
        kind = "swatch",
        id = preset.id,
        title = preset.title,
        description = "Colors labels, boxes and placeables " .. preset.title:lower() .. "."
    }
end

return {
    markers = {
        fixed = { box = true, placeable = true },
        kinds = {
            "arrow",
            "label",
            "diagonal_arrow",
            "check",
            "x",
            "plus",
            "subtract",
            "divide",
            "equal",
            "question",
            "exclamation",
            "interrobang",
            "warning",
            "stop",
            "like",
            "dislike",
            "box",
            "placeable"
        },
        colored = { label = true, box = true, placeable = true },
        presets = presets,
        buttons = buttons
    }
}
