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
        buttons = {
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
            {
                kind = "icon",
                id = "placeable",
                folder = "ui",
                texture = "puzzle",
                title = "Placeable",
                description = "Paint tiles where cells can be moved in puzzles."
            },
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
                id = "label",
                folder = "markers",
                texture = "label",
                title = "Label",
                description = "Places a text label."
            },
            { kind = "separator", id = "divider" },
            {
                kind = "swatch",
                id = "color",
                title = "Color",
                description = "Picks the color of labels and boxes."
            }
        }
    }
}
