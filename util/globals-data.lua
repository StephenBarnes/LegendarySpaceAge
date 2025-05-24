-- Globals used in data stage and settings stage, but not control stage.

-- Global shortcuts for indexing data.raw.
RAW = data.raw
RECIPE = RAW.recipe
ITEM = RAW.item
MODULE = RAW.module
FLUID = RAW.fluid
TECH = RAW.technology
ASSEMBLER = RAW["assembling-machine"]
FURNACE = RAW.furnace
PLANET = RAW.planet
SPACE_CONNECTION = RAW["space-connection"]

-- Import utils.
Table = require "util.table"
Gen = require "util.general"
Icon = require "util.icon"
Item = require "util.item"
Fluid = require "util.fluid"
Recipe = require "util.recipe"
Tech = require "util.tech"
GreyPipes = require "util.grey-pipes"
ExclusionZones = require "util.exclusion-zones"