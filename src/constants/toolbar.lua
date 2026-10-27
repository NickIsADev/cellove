local toolbar = {
    colors = { fill = 0x1C1C1C, line = 0x4D4D4D },
    slot = 40,
    pad = 6,
    margin = 6,
    gap = 8,
    inset = 3,
    hover = { growth = 0.2, lift = 4 },
    slide = 16,
    drag = { threshold = 6, flip = 0.5 },
    picker = {
        texture = "pencil",
        title = "Tools",
        description = "Selects the active tool."
    },
    library = {
        texture = "library",
        title = "Cell Library",
        description = "Browse every cell."
    },
    arrow = { texture = "arrow" },
    empty = {
        text = "Add cells to your toolbar via the Cell Library",
        font = 12,
        margin = 12,
        alpha = 0.5
    },
    panel = { pad = 6, gap = 6 },
    layout = {
        "cellove:wall",
        "cellove:pushable",
        "cellove:slider",
        "cellove:mover",
        "cellove:puller",
        "cellove:advancer",
        "cellove:nudger",
        "cellove:generator",
        "cellove:diverger",
        "cellove:displacer",
        "cellove:mirror",
        "cellove:rotator_cw",
        "cellove:rotator_ccw",
        "cellove:trash",
        "cellove:bias",
        "cellove:weight"
    }
}
toolbar.height = toolbar.slot + toolbar.margin * 2
toolbar.start = toolbar.pad + (toolbar.slot + toolbar.pad) * 2 + toolbar.gap

return { toolbar = toolbar }
