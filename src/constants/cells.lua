return {
    tags = {
        mover = 0x1979FF,
        enemy = 0xEB1A00,
        pushable = 0xFFB009
    },

    force = {
        push = 0,
        pull = 0,
        grab = 0,
        generate = 1,
        strength = 1,
        weight = -1
    },

    registry = {
        base = { path = "content/cells", namespace = "cellove" },
        pattern = "^[a-z0-9_]+$",
        categories = {
            {
                id = "movers",
                title = "Movers",
                icon = "mover"
            },
            {
                id = "pullers",
                title = "Pullers",
                icon = "puller",
                parent = "movers"
            },
            {
                id = "grabbers",
                title = "Grabbers",
                icon = "grabber",
                parent = "movers"
            },
            {
                id = "players",
                title = "Players",
                icon = "player",
                parent = "movers"
            },
            {
                id = "generators",
                title = "Generators",
                icon = "generator"
            },
            {
                id = "makers",
                title = "Makers",
                icon = "maker",
                parent = "generators"
            },
            {
                id = "pipes",
                title = "Pipes",
                icon = "pipe",
                parent = "divergers"
            },
            {
                id = "tubes",
                title = "Tubes",
                icon = "tube",
                parent = "divergers"
            },
            {
                id = "divergers",
                title = "Divergers",
                icon = "diverger"
            },
            {
                id = "displacers",
                title = "Displacers",
                icon = "displacer",
                parent = "divergers"
            },
            {
                id = "wraps",
                title = "Wraps",
                icon = "wrap",
                parent = "divergers"
            },
            {
                id = "mirrors",
                title = "Mirrors",
                icon = "mirror",
                parent = "forces"
            },
            {
                id = "cyclers",
                title = "Cyclers",
                icon = "cycler_cw",
                parent = "forces"
            },
            {
                id = "redirectors",
                title = "Redirectors",
                icon = "redirector",
                parent = "rotators"
            },
            {
                id = "gears",
                title = "Gears",
                icon = "gear_cw",
                parent = "rotators"
            },
            {
                id = "rotators",
                title = "Rotators",
                icon = "rotator_cw"
            },
            {
                id = "gates",
                title = "Gates",
                icon = "andgate",
                parent = "generators"
            },
            {
                id = "forces",
                title = "Forces",
                icon = "bias"
            },
            {
                id = "repulsors",
                title = "Repulsors",
                icon = "repulsor",
                parent = "forces"
            },
            {
                id = "impulsors",
                title = "Impulsors",
                icon = "impulsor",
                parent = "forces"
            },
            {
                id = "walls",
                title = "Walls",
                icon = "wall"
            },
            {
                id = "pushables",
                title = "Pushables",
                icon = "pushable"
            },
            {
                id = "destroyers",
                title = "Destroyers",
                icon = "trash"
            },
            {
                id = "trashes",
                title = "Trashes",
                icon = "trash",
                parent = "destroyers"
            },
            {
                id = "enemies",
                title = "Enemies",
                icon = "enemy",
                parent = "destroyers"
            },
            {
                id = "allies",
                title = "Allies",
                icon = "ally",
                parent = "destroyers"
            },
            {
                id = "storage",
                title = "Storage",
                icon = "storage"
            },
            {
                id = "midases",
                title = "Midases",
                icon = "midas",
                parent = "storage"
            },
            {
                id = "infectious",
                title = "Infectious",
                icon = "life"
            },
            {
                id = "misc",
                title = "Miscellaneous",
                icon = "base",
                folder = "ui"
            }
        }
    }
}
