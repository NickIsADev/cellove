return {
    force = {
        push = 0,
        pull = 0,
        grab = 0,
        generate = 1,
        gravity = 1,
        strength = 1,
        unit = 1,
        weight = -1
    },

    adjustable = {
        amount = { id = "amount", title = "Amount", default = 1, min = 1, max = 99 },
        count = { id = "count", title = "Count", default = 0, min = 0, max = 99 },
        run = { id = "run", title = "Run", default = 1, min = 0, max = 99 },
        rise = { id = "rise", title = "Rise", default = 0, min = 0, max = 99 },
        numerator = { id = "numerator", title = "Numerator", default = 0, min = 0, max = 99 },
        denominator = { id = "denominator", title = "Denominator", default = 1, min = 1, max = 99 },
        speed = { id = "speed", title = "Speed", default = 1, min = 1, max = 99 },
        delay = { id = "delay", title = "Delay", default = 1, min = 1, max = 99 },
        time = { id = "time", title = "Time", default = 0, min = 0, max = 99 },
        maximum = { id = "maximum", title = "Max", default = 0, min = 0, max = 99, names = { [0] = "0 (inf)" } }
    },

    registry = {
        base = { path = "content/cells", namespace = "cellove" },
        effects = "content/effects",
        pattern = "^[a-z0-9_]+$",
        categories = {
            {
                id = "basic",
                title = "Basic",
                icon = "pushable"
            },
            {
                id = "walls",
                title = "Walls",
                icon = "wall",
                parent = "basic"
            },
            {
                id = "pushables",
                title = "Pushables",
                icon = "pushable",
                parent = "basic"
            },
            {
                id = "oppositions",
                title = "Oppositions",
                icon = "unpushable",
                parent = "basic"
            },
            {
                id = "weights",
                title = "Weights",
                icon = "weight",
                parent = "basic"
            },
            {
                id = "sticky",
                title = "Sticky",
                icon = "slime",
                parent = "basic"
            },
            {
                id = "extensions",
                title = "Extensions",
                icon = "pushextension",
                parent = "basic"
            },
            {
                id = "input",
                title = "Input",
                icon = "inputpushable",
                parent = "basic"
            },
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
                id = "drillers",
                title = "Drillers",
                icon = "driller",
                parent = "movers"
            },
            {
                id = "slicers",
                title = "Slicers",
                icon = "cutter",
                parent = "movers"
            },
            {
                id = "scissors",
                title = "Scissors",
                icon = "scissor",
                parent = "movers"
            },
            {
                id = "missiles",
                title = "Missiles",
                icon = "missile",
                parent = "movers"
            },
            {
                id = "players",
                title = "Players",
                icon = "player",
                parent = "movers"
            },
            {
                id = "othermovers",
                title = "Other",
                icon = "nudger",
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
                id = "shifters",
                title = "Shifters",
                icon = "shifter",
                parent = "generators"
            },
            {
                id = "gates",
                title = "Gates",
                icon = "orgate",
                parent = "generators"
            },
            {
                id = "builders",
                title = "Builders",
                icon = "constructor",
                parent = "generators"
            },
            {
                id = "replicators",
                title = "Replicators",
                icon = "memoryreplicator",
                parent = "generators"
            },
            {
                id = "rotators",
                title = "Rotators",
                icon = "rotator_cw"
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
                id = "flippers",
                title = "Flippers",
                icon = "perpetualflipper",
                parent = "rotators"
            },
            {
                id = "orientators",
                title = "Orientators",
                icon = "orientator",
                parent = "rotators"
            },
            {
                id = "otherrotators",
                title = "Other",
                icon = "transmitter",
                parent = "rotators"
            },
            {
                id = "forces",
                title = "Forces",
                icon = "repulsor"
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
                id = "otherforces",
                title = "Other",
                icon = "magnet",
                parent = "forces"
            },
            {
                id = "divergers",
                title = "Divergers",
                icon = "diverger"
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
                id = "forkers",
                title = "Forkers",
                icon = "forker",
                parent = "divergers"
            },
            {
                id = "spooners",
                title = "Spooners",
                icon = "spooner",
                parent = "divergers"
            },
            {
                id = "slopes",
                title = "Slopes",
                icon = "slope",
                parent = "divergers"
            },
            {
                id = "paraboles",
                title = "Paraboles",
                icon = "parabole",
                parent = "divergers"
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
                id = "sentries",
                title = "Sentries",
                icon = "sentry",
                parent = "destroyers"
            },
            {
                id = "acids",
                title = "Acids",
                icon = "acid",
                parent = "destroyers"
            },
            {
                id = "allies",
                title = "Allies",
                icon = "ally",
                parent = "destroyers"
            },
            {
                id = "transformers",
                title = "Transformers",
                icon = "transformer"
            },
            {
                id = "transmutators",
                title = "Transmutators",
                icon = "transmutator",
                parent = "transformers"
            },
            {
                id = "worms",
                title = "Worms",
                icon = "worm",
                parent = "transformers"
            },
            {
                id = "timewarpers",
                title = "Timewarpers",
                icon = "timewarper",
                parent = "transformers"
            },
            {
                id = "midases",
                title = "Midases",
                icon = "midas",
                parent = "transformers"
            },
            {
                id = "misc",
                title = "Miscellaneous",
                icon = "ungeneratable"
            },
            {
                id = "generation",
                title = "Generation",
                icon = "ungeneratable",
                parent = "misc"
            },
            {
                id = "infectious",
                title = "Infectious",
                icon = "life",
                parent = "misc"
            },
            {
                id = "effects",
                title = "Effect Givers",
                icon = "freezer",
                parent = "misc"
            },
            {
                id = "unlocking",
                title = "Unlocking",
                icon = "key",
                parent = "misc"
            },
            {
                id = "storage",
                title = "Storage",
                icon = "storage",
                parent = "misc"
            },
            {
                id = "collectables",
                title = "Collectables",
                icon = "coin",
                parent = "misc"
            },
            {
                id = "truecells",
                title = "True Cells",
                icon = "truegear_cw",
                parent = "misc"
            },
            {
                id = "puzzles",
                title = "Puzzles",
                icon = "puzzle",
                folder = "ui"
            }
        }
    }
}
