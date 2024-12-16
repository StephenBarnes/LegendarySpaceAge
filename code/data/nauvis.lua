-- Biochemistry mod: change biofuel tech to require fish breeding and tree seeding. And fish comes after Gleba science, doesn't need tree seeding.
--data.raw.technology["biofuel"].prerequisites = {"fish-breeding", "tree-seeding"}
--data.raw.technology["fish-breeding"].prerequisites = {"agricultural-science-pack"}

-- Change fish spoil timer to a more sane number. No fun allowed.
data.raw.capsule["raw-fish"].spoil_ticks = 60 * 60 * 60 * 2 -- 2 hours.