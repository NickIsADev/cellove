return {
    tags = {
        mover = 0x1979FF,
        enemy = 0xEB1A00,
        pushable = 0xFFB009
    },

    force = {
        push = 0,
        pull = 0,
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
                icon = "puller"
            },
            {
                id = "generators",
                title = "Generators",
                icon = "generator"
            },
            {
                id = "pipes",
                title = "Pipes",
                icon = "pipe"
            },
            {
                id = "divergers",
                title = "Divergers",
                icon = "diverger"
            },
            {
                id = "displacers",
                title = "Displacers",
                icon = "displacer"
            },
            {
                id = "mirrors",
                title = "Mirrors",
                icon = "mirror"
            },
            {
                id = "redirectors",
                title = "Redirectors",
                icon = "redirector"
            },
            {
                id = "gears",
                title = "Gears",
                icon = "gear_cw"
            },
            {
                id = "rotators",
                title = "Rotators",
                icon = "rotator_cw"
            },
            {
                id = "gates",
                title = "Gates",
                icon = "andgate"
            },
            {
                id = "forces",
                title = "Forces",
                icon = "bias"
            },
            {
                id = "repulsors",
                title = "Repulsors",
                icon = "repulsor"
            },
            {
                id = "impulsors",
                title = "Impulsors",
                icon = "impulsor"
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
                id = "storage",
                title = "Storage",
                icon = "storage"
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
