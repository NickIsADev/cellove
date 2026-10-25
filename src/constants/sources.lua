return {
    texturepacks = {
        root = "texturepacks",
        setting = "packs",
        default = "default",
        metadata = "pack.lua",
        fields = { "name", "description", "author" },
        archive = "^(.+)%.[zZ][iI][pP]$",
        ignored = "__MACOSX",
        markers = { "cells", "ui", "font" },
        missing = { folder = "ui", name = "missing" },
        title = { text = "Texture Packs", size = 40 },
        available = {
            title = "Available",
            empty = "No texture packs available"
        },
        active = {
            title = "Active",
            empty = "Drag texture packs here to enable them"
        },
        folder = {
            texture = "folder",
            size = 40,
            margin = 24,
            title = "Texture Packs Folder",
            description = "Opens the texture packs folder."
        },
        text = {
            author = "by %s",
            linked = "Linked to %s",
            default = "Always enabled",
            installed = "Installed \"%s\"",
            exists = "\"%s\" is already installed.",
            notArchive = "Only .zip texture packs can be installed.",
            unreadable = "The file couldn't be read.",
            writeFailed = "Couldn't write the file."
        }
    },

    mods = {
        root = "mods",
        setting = "mods",
        reload = "Reloading mods...",
        metadata = "mod.lua",
        main = "main.lua",
        cells = "cells",
        puzzles = "puzzles",
        fields = { "name", "description", "author", "version" },
        archive = "^(.+)%.[zZ][iI][pP]$",
        ignored = "__MACOSX",
        layouts = {
            editor = { "editor" },
            puzzle = { "puzzle", "custom" }
        },
        title = { text = "Mods", size = 40 },
        available = {
            title = "Available",
            empty = "No mods available"
        },
        active = {
            title = "Active",
            empty = "Drag mods here to enable them"
        },
        folder = {
            texture = "folder",
            size = 40,
            margin = 24,
            title = "Mods Folder",
            description = "Opens the mods folder."
        },
        alert = {
            time = 6,
            one = "%s failed to load",
            many = "%d mods failed to load"
        },
        text = {
            author = "by %s",
            separator = "  -  ",
            invalid = "Invalid mod.lua",
            id = "Invalid or reserved mod id",
            dots = "Folder names can't contain dots",
            pack = "Missing texture pack: %s",
            dependency = "Requires mod: %s",
            listener = "Event %s failed: %s",
            conflict = "Conflicts with %s: %s",
            location = "%s (%s:%s)",
            error = "Failed to load: %s",
            installed = "Installed \"%s\"",
            exists = "\"%s\" is already installed.",
            notArchive = "Only .zip mods can be installed.",
            unreadable = "The file couldn't be read.",
            writeFailed = "Couldn't write the file."
        }
    },

    selection = {
        width = 920,
        gap = 16,
        margin = 16,
        top = { ratio = 0.16 },
        header = {
            font = 18,
            height = 44,
            gap = 8
        },
        drag = {
            threshold = 8,
            edge = 40,
            speed = 10,
        },
        row = {
            height = 72,
            pad = 12,
            gap = 12,
            lineGap = 2,
            lines = 2,
            icon = 48,
            badge = 28,
            font = { name = 18, detail = 14 }
        }
    }
}
