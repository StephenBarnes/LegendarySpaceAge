-- Biochemistry mod: change biofuel tech to require fish breeding and tree seeding. And fish comes after Gleba science, doesn't need tree seeding.
--TECH["biofuel"].prerequisites = {"fish-breeding", "tree-seeding"}
--TECH["fish-breeding"].prerequisites = {"agricultural-science-pack"}

-- Change fish spoil timer to a more sane number. No fun allowed.
RAW.capsule["raw-fish"].spoil_ticks = 2 * HOURS