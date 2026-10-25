return {
    puzzles = {
        root = "content/puzzles",
        info = "puzzle",
        data = "puzzle.cellove",
        title = { text = "Puzzles", size = 40 },
        empty = "No puzzles yet...",
        width = 580,
        margin = 16,
        top = { ratio = 0.16 },
        hidden = { initial = true },
        delay = 0.15,
        difficulties = {
            easier = { title = "Easier", texture = "difficulty/easier", color = 0x22B4E3 },
            easy = { title = "Easy", texture = "difficulty/easy", color = 0x16D10C },
            medium = { title = "Medium", texture = "difficulty/medium", color = 0xF1D622 },
            hard = { title = "Hard", texture = "difficulty/hard", color = 0xF38700 },
            harder = { title = "Harder", texture = "difficulty/harder", color = 0xD71223 },
            extreme = { title = "Extreme", texture = "difficulty/extreme", color = 0xE50F94 },
            unknown = { title = "Unknown", texture = "difficulty/unknown", color = 0xA6A6A6 }
        },
        wipe = {
            texture = "trash",
            size = 40,
            margin = 24,
            title = "Reset Progress",
            description = "Forgets every puzzle you've solved.",
            prompt = {
                title = "Reset Progress",
                message = "Forget every puzzle you've solved?",
                confirm = "Reset"
            }
        },
        summary = {
            font = 16,
            height = 48,
            gap = 8,
            text = "%d / %d solved",
            bar = { width = 240, height = 6 }
        },
        row = {
            height = 88,
            pad = 16,
            lineGap = 6,
            font = { name = 22, detail = 16, number = 24 },
            badge = { size = 56, icon = 28 },
            level = { icon = 20, gap = 8 }
        },
        hud = {
            title = 24,
            detail = 16,
            count = 24,
            icon = 40,
            margin = 16,
            gap = 6,
            width = 480
        },
        held = { alpha = 0.85 }
    },

    victory = {
        width = 360,
        margin = 16,
        pad = 24,
        gap = 8,
        dim = 0.6,
        fade = 0.25,
        font = { title = 28, name = 16 },
        title = "Puzzle Solved!",
        button = {
            size = 40,
            gap = 40,
            font = 16,
            labelGap = 6
        },
        buttons = {
            { id = "replay", folder = "cells", texture = "rotator_180", label = "Reset" },
            { id = "puzzles", folder = "ui", texture = "puzzle", label = "Puzzles" },
            { id = "next", folder = "cells", texture = "nudger", tint = "accent", label = "Next" }
        }
    }
}
