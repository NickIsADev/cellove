return {
    screenshots = {
        root = "screenshots",
        pattern = "^(.+)%.[pP][nN][gG]$",
        extension = ".png",
        scale = 8,
        name = "Screenshot %Y-%m-%d %H-%M-%S",
        title = { text = "Screenshots", size = 40 },
        empty = "No screenshots yet...",
        width = 720,
        margin = 16,
        bottom = 8,
        gap = 12,
        font = 14,
        top = { ratio = 0.16 },
        cell = {
            width = 160,
            height = 140,
            pad = 8,
            trash = {
                folder = "cells",
                texture = "trash",
                size = 24,
                backdrop = 0.5,
                alpha = { idle = 0.6, hover = 1 }
            }
        },
        preview = {
            margin = 48,
            pad = 12,
            gap = 8,
            header = 48,
            min = 360,
            dim = 0.7,
            font = 20,
            button = 32,
            buttons = {
                {
                    id = "rename",
                    folder = "ui",
                    texture = "pencil",
                    title = "Rename",
                    description = "Renames this screenshot."
                },
                {
                    id = "delete",
                    folder = "cells",
                    texture = "trash",
                    title = "Delete",
                    description = "Deletes this screenshot."
                },
                {
                    id = "close",
                    folder = "ui",
                    texture = "x",
                    title = "Close",
                    description = "Closes the preview."
                }
            }
        },
        button = {
            size = 40,
            alpha = { idle = 0.5, hover = 0.75 },
            title = "Screenshots",
            description = "View your screenshots."
        },
        folder = {
            size = 40,
            margin = 24,
            title = "Screenshots Folder",
            description = "Opens the screenshots folder."
        },
        text = {
            saved = "Saved screenshot",
            renamed = "Renamed \"%s\" to \"%s\"",
            deleted = "Deleted \"%s\"",
            failed = "Couldn't rename the screenshot",
            rename = {
                title = "Rename Screenshot",
                message = "Enter a new name.",
                confirm = "Rename"
            },
            delete = {
                title = "Delete Screenshot",
                message = "Delete \"%s\"? This can't be undone.",
                confirm = "Delete"
            }
        }
    }
}
