--[[ This folder adjusts numbers for all infrastructure buildings and recipes, by group and subgroup.
Aims:
* Create more interesting tradeoffs. E.g. sometimes you should prefer assembler 1's and 2's even when you have 3's.
* Use intermediate factors instead of regular intermediates wherever possible, to make recipes possible eg on Gleba, and to make them effectively have more possible production routes.
* Generally increase electricity usages to make the game a bit harder. (Formerly used PowerMultiplier mod. But rather not using that, rather just set them all separately.)
* Simplify numbers for recipe ingredients, products, times, and machine crafting speeds etc. Prefer to only have 2 and 5 as factors for numbers (including 1/2 and 1/5). No 3's and 6's. Avoid 8, 12, 15, 16, 32, 60, etc. Most machines with most recipes should have simple per-second rates like 1 or 0.5 or 0.2 or 2, etc. (These numbers will break down when you use quality machines or modules or beacons.)
]]

require("0-environment.main")
require("1-logistics.main")
require("2-production.main")
require("3-simple-intermediates.main")
require("5-space.main")
require("6-military.main")