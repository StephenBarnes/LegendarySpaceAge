--[[ This file defines the order and item-groups and item-subgroups of all items, fluids, and recipes, in Factoriopedia and in crafting menu for players and machines.
See data/broad-changes/item-recipe-arrangement.lua for the actual code that applies this file.
	Orders of items/recipe/etc, subgroups, and groups (tabs) are set based on order in this file.
	Item-subgroups named in this file are automatically created if they don't already exist.
	Item-groups named in this file are not automatically created, they're explicitly created in data/broad-changes/item-recipe-arrangement.lua.
]]

return {
	logistics = {
		storage = {"steel-chest", "tiny-inline-storage-tank", "storage-tank", "large-storage-tank"},
		belt = {"transport-belt", "fast-transport-belt", "express-transport-belt", "turbo-transport-belt", "underground-belt", "fast-underground-belt", "express-underground-belt", "turbo-underground-belt"},
		inserter = {"splitter", "fast-splitter", "express-splitter", "turbo-splitter", "inserter", "long-handed-inserter", "fast-inserter", "bulk-inserter", "stack-inserter", "burner-inserter"},
		["energy-pipe-distribution"] = {"small-electric-pole", "medium-electric-pole", "big-electric-pole", "substation", "po-small-electric-fuse", "po-medium-electric-fuse", "po-big-electric-fuse", "po-transformer"},
		["fluid-logistics"] = {"pipe", "pipe-to-ground", "pump", "offshore-pump", "waste-pump", "gas-vent"},
		["train-transport"] = {"train-stop", "rail-signal", "rail-chain-signal", "locomotive", "cargo-wagon", "artillery-wagon", "rail", "rail-ramp", "rail-support"},
		water_transport = {"port", "buoy", "chain_buoy", "boat", "cargo_ship", "oil_tanker", "waterway", "straight-waterway", "half-diagonal-waterway", "curved-waterway-a", "curved-waterway-b"},
		transport = {"car", "tank", "spidertron"},
		["logistic-network"] = {"logistic-robot", "construction-robot", "active-provider-chest", "passive-provider-chest", "storage-chest", "buffer-chest", "requester-chest", "roboport"},
		["circuit-network"] = {"small-lamp", "arithmetic-combinator", "decider-combinator", "selector-combinator", "constant-combinator", "power-switch", "programmable-speaker", "display-panel", "aai-signal-sender", "aai-signal-receiver", "aai-filter"},
		paving = {"concrete", "hazard-concrete", "refined-concrete", "refined-hazard-concrete", "cliff-explosives", "make-cement"},
		terrain = {"landfill", "artificial-yumako-soil", "overgrowth-yumako-soil", "artificial-jellynut-soil", "overgrowth-jellynut-soil", "ice-platform", "foundation"},
	},
	production = {
		tool = {"repair-pack", "blueprint", "deconstruction-planner", "upgrade-planner", "blueprint-book"},
		energy = {"boiler", "electric-boiler", "gas-boiler", "heating-tower", "fluid-heating-tower", "heat-pipe", "heat-exchanger"},
		generator = {"er-hcg", "steam-engine", "steam-turbine", "condensing-turbine"},
		["electricity-related"] = {"solar-panel", "battery-charger", "battery-discharger", "accumulator", "lightning-rod", "lightning-collector", "nuclear-reactor", "fusion-reactor", "fusion-generator"},
		["extraction-machine"] = {"burner-mining-drill", "electric-mining-drill", "big-mining-drill", "deep-drill", "pumpjack", "agricultural-tower", "air-separator", "drill-node-dummy-miner"},
		["smelting-machine"] = {"stone-furnace", "steel-furnace", "ff-furnace", "arc-furnace"},
		["production-machine"] = {"assembling-machine-1", "assembling-machine-2", "assembling-machine-3", "clean-assembler"},
		["chemical-processing"] = {"chemical-plant", "oil-refinery", "filtration-plant", "cryogenic-plant", "gasifier", "fluid-fuelled-gasifier"},
		["heat-processing"] = {"electric-furnace", "exothermic-plant"},
		["planetary-special"] = {"foundry", "biochamber", "recycler", "electromagnetic-plant", "captive-biter-spawner", "centrifuge"},
		["environmental-protection"] = {},
		lab = {"lab", "glebalab", "biolab"},
		beacons = {"efficiency-regulator", "productivity-regulator", "speed-regulator", "quality-regulator", "basic-beacon", "beacon"},
		module = {},
		["module-2"] = {"electronic-circuit-primed", "advanced-circuit-primed", "processing-unit-primed", "white-circuit-primed", "circuit-primer"},
		["module-3"] = {"electronic-circuit-superclocked", "advanced-circuit-superclocked", "processing-unit-superclocked", "white-circuit-superclocked", "superclocker"},
	},
	["material-processing"] = {
		["raw-resource"] = {"stone", "calcite", "uranium-ore", "fluorite", "ice"},
		["raw-material"] = {"stone-brick", "ash", "sand", "glass", "sulfur", "niter", "gunpowder", "ash-reprocessing"},
		rubber = {"rubber", "rubber-from-latex", "rubber-from-oil"},
		["silicon-processing"] = {"silica", "crude-silicon", "polysilicon", "silicon-gas", "silicon-waste-gas"},
		["uranium-processing"] = {"uranium-processing", "plutonium", "uranium-235", "uranium-238", "yellowcake", "fuel-rod", "uranium-fuel-cell", "depleted-uranium-fuel-cell", "depleted-fuel-rod", "nuclear-fuel-reprocessing", "kovarex-enrichment-process"},

		-- TODO move these to better places.
		["fulgora-processes"] = {"scrap", "scrap-recycling", "holmium-ore", "make-holmium-solution", "holmium-plate", "superconductor", "make-electrolyte", "supercapacitor"},
		["aquilo-processes"] = {"ammoniacal-solution", "fluorine", "lithium-brine", "fusion-plasma"},

		["filter-meta"] = {"filter", "spent-filter", "clean-filter"},
		["planet-filtration"] = {"filter-lake-water", "volcanic-gas-separation", "filter-slime", "fulgoran-sludge-filtration", "ammoniacal-solution-separation"},
		["air-separation"] = {"air-separation-nauvis", "air-separation-vulcanus", "air-separation-gleba", "air-separation-fulgora", "air-separation-aquilo"},
		["deep-drilling"] = {"deep-drill-nauvis", "deep-drill-apollo", "recipe-drill-node-ice", "recipe-drill-node-carbon", "deep-drill-vulcanus", "deep-drill-gleba", "recipe-drill-node-geoplasm", "deep-drill-fulgora"},
	},
	metallurgy = {
		ores = {"iron-ore", "copper-ore", "tungsten-ore"},
		["ore-intermediates"] = {"copper-matte"},
		ingots = {"ingot-iron-hot", "ingot-copper-hot", "ingot-steel-hot", "ingot-iron-cold", "ingot-copper-cold", "ingot-steel-cold"},
		["basic-metal-intermediates"] = {"test-exothermic", "iron-plate", "iron-gear-wheel", "iron-stick", "copper-plate", "copper-cable", "steel-plate", "advanced-parts"},
		rust = {"rusty-ingot-iron-cold", "rusty-iron-plate", "rusty-iron-gear-wheel", "rusty-iron-stick"},
		derusting = {"sand-derust-ingot-iron-cold", "sand-derust-iron-plate", "sand-derust-iron-gear-wheel", "sand-derust-iron-stick", "acid-derust-ingot-iron-cold", "acid-derust-iron-plate", "acid-derust-iron-gear-wheel", "acid-derust-iron-stick"},
		["tungsten-metallurgy"] = {"tungsten-carbide", "tungsten-plate", "tungsten-steel"},

		["vulcanus-processes"] = {"metals-from-lava", "make-molten-iron", "make-molten-copper", "make-molten-steel", "make-molten-tungsten", "tungsten-heating"},
		["vulcanus-casting"] = {"casting-iron", "casting-copper", "casting-steel", "casting-brick", "sulfur-concrete", "sulfur-refined-concrete", "casting-iron-gear-wheel", "casting-iron-stick", "casting-copper-cable", "casting-advanced-parts", "tungsten-carbide-from-molten", "tungsten-steel-from-molten"},
	},
	petrochemistry = {
		["petroleum-materials"] = {"coal", "pitch", "carbon", "solid-fuel", "explosives", "plastic-bar", "char-carbon", "inverse-vulcanization"},
		["petrochem-processing"] = {"oil-fractionation", "gas-fractionation", "heavy-oil-cracking", "rich-gas-cracking", "light-oil-cracking"},
		["petrochem-processing-2"] = {"make-syngas", "syngas-liquefaction", "coal-coking", "heavy-oil-coking", "tar-distillation", "pitch-processing", "make-lubricant", "make-diesel"},
	},
	chemistry = {
		chloric = {"chloric-acid", "chloride-salt", "chlorine-gas", "chloric-acid-from-gas", "acid-salt-shift-chloric-nitric", "acid-salt-shift-chloric-sulfuric", "acid-salt-shift-chloric-fluoric", "acid-salt-shift-chloric-phosphoric"},
		sulfuric = {"sulfuric-acid", "salt-cake", "sulfur-dioxide", "sulfuric-acid-from-gas", "acid-salt-shift-sulfuric-chloric", "acid-salt-shift-sulfuric-nitric", "acid-salt-shift-sulfuric-fluoric", "acid-salt-shift-sulfuric-phosphoric", "make-sulfuric-acid"},
			-- TODO remove make-sulfuric-acid once we have the real recipes for making acids from gases.
		nitric = {"nitric-acid", "niter", "nox-gas", "nitric-acid-from-gas", "acid-salt-shift-nitric-chloric", "acid-salt-shift-nitric-sulfuric", "acid-salt-shift-nitric-fluoric", "acid-salt-shift-nitric-phosphoric"},
		fluoric = {"fluoric-acid", "fluoride-salt", "fluorine-gas", "fluoric-acid-from-gas", "acid-salt-shift-fluoric-chloric", "acid-salt-shift-fluoric-sulfuric", "acid-salt-shift-fluoric-nitric", "acid-salt-shift-fluoric-phosphoric"},
		phosphoric = {"phosphoric-acid", "phosphate-salt", "phosphine-gas", "phosphoric-acid-from-gas", "acid-salt-shift-phosphoric-chloric", "acid-salt-shift-phosphoric-sulfuric", "acid-salt-shift-phosphoric-nitric", "acid-salt-shift-phosphoric-fluoric"},
		bases = {"lye", "alkali-ash", "quicklime", "slaked-lime"},

		["ammonia-related"] = {"ammonia", "ammonia-synthesis", "ammonia-cracking"},
		["misc-chem"] = {"syngas-reforming", "electrolysis"},
		["internal-process"] = {},
	},
	["intermediate-factors"] = {
		resin = {"resin", "wood-resin", "pitch-resin", "rich-gas-resin", "smelt-slipstack-pearl"},
		["circuit-board"] = {"circuit-board", "makeshift-circuit-board", "wood-circuit-board", "plastic-circuit-board", "calcite-circuit-board"},
		["wiring"] = {"wiring", "makeshift-wiring", "wiring-from-resin", "wiring-from-rubber", "wiring-from-plastic", "wiring-from-neurofibril"},
		["electronic-components"] = {"electronic-components", "components-basic", "components-from-plastic", "components-from-glass-plastic", "components-from-silicon"},
		panel = {"panel", "panel-from-wood", "panel-from-iron", "panel-from-copper", "panel-from-glass", "panel-from-rubber", "panel-from-steel"},
		frame = {"frame", "frame-from-wood", "frame-from-iron", "frame-from-iron-and-steel", "frame-from-steel", "frame-from-tubules"},
		structure = {"structure", "structure-from-resin", "structure-from-vitrified-brick", "structure-from-cement", "structure-from-concrete", "structure-from-refined-concrete", "structure-from-chitin"},
		["fluid-fitting"] = {"fluid-fitting", "fluid-fitting-from-copper", "fluid-fitting-from-plastic"},
		["shielding"] = {"shielding", "shielding-from-iron", "shielding-from-steel", "shielding-from-casting-steel", "shielding-from-tungsten-carbide", "shielding-from-tungsten", "shielding-from-casting-tungsten"},
		mechanism = {"mechanism", "mechanism-from-basic", "mechanism-from-advanced", "mechanism-from-appendage"},
		sensor = {"sensor", "sensor-from-green-circuit", "sensor-from-red-circuit", "sensor-from-blue-circuit", "sensor-from-sencytium"},
		actuator = {"electric-engine-unit", "actuator-standard", "actuator-from-blue-circuit", "actuator-augmented", "actuator-from-appendage"},
		["low-density-structure"] = {"low-density-structure", "low-density-structure-standard", "casting-low-density-structure", "lds-from-chitin-and-carbon-fiber"},
	},
	["intermediate-products"] = { -- Renamed to "manufacturing" via localized strings, but reusing the existing item-group internal name in case other mods want to put stuff in there.
		circuits = {"electronic-circuit", "advanced-circuit", "processing-unit", "white-circuit"},
		["intermediate-product"] = {"doped-wafer", "microchip", "engine-unit", "flying-robot-frame", "barrel", "gas-tank", "battery", "charged-battery", "holmium-battery", "charged-holmium-battery"},
		["intermediate-recipe"] = {},
		["science-pack"] = {"automation-science-pack", "logistic-science-pack", "military-science-pack", "chemical-science-pack", "production-science-pack", "utility-science-pack", "space-science-pack"},
		["alien-science-packs"] = {"asteroid-science-pack", "metallurgic-science-pack", "agricultural-science-pack", "electromagnetic-science-pack", "nuclear-science-pack", "cryogenic-science-pack", "promethium-science-pack"},
	},
	["bio-processing"] = {
		["early-agriculture"] = {"wood", "tree-seed", "fertilizer", "sapling", "spoilage-from-wood", "ammonia-from-spoilage"},
		["nauvis-agriculture"] = {"raw-fish", "fish-breeding", "nutrients-from-fish", "nutrients-from-biter-egg", "biter-egg"},
		["spoilage-and-nutrients"] = {"spoilage", "nutrients-from-spoilage", "sugar", "nutrients-from-yumako-mash", "nutrients-from-bioflux", "nutrients", "nutrients-from-marrow"},
		["yumako-and-jellynut"] = {"yumako-seed", "jellynut-seed", "fertilized-yumako-seed", "fertilized-jellynut-seed", "yumako", "jellynut", "yumako-mash", "jelly", "yumako-processing", "jellynut-processing"},
		["agriculture-processes"] = {"pentapod-egg", "activated-pentapod-egg"},
		["gleba-non-agriculture"] = {"marrow", "chitin-fragments", "chitin-block", "tubule", "appendage", "sencytium", "making-chitin-broth", "landfill-from-chitin"},
		["agriculture-products"] = {"bioflux", "bioflux-from-eggs", "biolubricant", "bioplastic", "slipstack-nest", "sprouted-boomnut", "pentapod-egg", "activated-pentapod-egg"},
		["slipstacks-and-boompuffs"] = {"slipstack-pearl", "slipstack-nest", "boomnut", "sprouted-boomnut", "boomsac", "crush-boomnut", "boomsac-deflation", "petrophage", "petrophage-cultivation", "refresh-petrophages"},
		["stingfrond-products"] = {"stingfrond-sprout", "neurofibril", "cyclosome-resynchronization", "carbon-fiber", "explosive-desynchronization", "cyclosome-1", "cyclosome-2", "cyclosome-3", "cyclosome-4", "cyclosome-5"},
		["fulgora-agriculture"] = {"fulgorite-shard", "electrophage", "polysalt", "fulgorite-starter", "electrophage-cultivation", "electrophage-cultivation-holmium"},
	},
	space = {
		["space-interactors"] = {"rocket-silo", "cargo-bay", "space-platform-starter-pack", "cargo-landing-pad", "cargo-pod", "rocket-part", "assembled-rocket-part", "cargo-pod-container", "telescope"},
		["space-platform"] = {"space-platform-foundation", "space-platform-hub", "asteroid-collector", "crusher", "thruster"},
		["space-rocket"] = {},
		["space-related"] = {},
		["space-environment"] = {"small-metallic-asteroid", "medium-metallic-asteroid", "big-metallic-asteroid", "huge-metallic-asteroid", "small-carbonic-asteroid", "medium-carbonic-asteroid", "big-carbonic-asteroid", "huge-carbonic-asteroid"},
		["space-environment-2"] = {"small-oxide-asteroid", "medium-oxide-asteroid", "big-oxide-asteroid", "huge-oxide-asteroid", "small-promethium-asteroid", "medium-promethium-asteroid", "big-promethium-asteroid", "huge-promethium-asteroid"},
		["space-material"] = {"metallic-asteroid-chunk", "carbonic-asteroid-chunk", "oxide-asteroid-chunk", "promethium-asteroid-chunk", },
		["space-crushing"] = {"metallic-asteroid-crushing", "carbonic-asteroid-crushing", "oxide-asteroid-crushing", "metallic-asteroid-reprocessing", "carbonic-asteroid-reprocessing", "oxide-asteroid-reprocessing", "advanced-metallic-asteroid-crushing", "advanced-carbonic-asteroid-crushing", "advanced-oxide-asteroid-crushing", },
		["space-processing"] = {},
		planets = {"vulcanus", "gleba", "nauvis", "apollo", "fulgora", "aquilo"},
		["space-locations"] = {"metallic-belt", "carbonic-belt", "ice-belt", "belt-of-aquilo", "shattered-planet", "solar-system-edge"},
		satellites = {},
		["belt-connections"] = {"metallic-belt-carbonic-belt", "carbonic-belt-ice-belt", "ice-belt-belt-of-aquilo", "belt-of-aquilo-shattered-planet", "solar-system-edge-shattered-planet"},
		["planet-connections"] = {"vulcanus-metallic-belt", "metallic-belt-gleba", "gleba-carbonic-belt", "carbonic-belt-apollo", "apollo-nauvis", "apollo-ice-belt", "ice-belt-fulgora", "fulgora-belt-of-aquilo", "belt-of-aquilo-aquilo", "aquilo-shattered-planet"},
	},
	combat = {
		gun = {"shotgun", "combat-shotgun", "submachine-gun", "flamethrower", "rocket-launcher", "teslagun", "railgun"},
		ammo = {"shotgun-shell", "piercing-shotgun-shell", "firearm-magazine", "piercing-rounds-magazine", "uranium-rounds-magazine", "flamethrower-ammo", "tesla-ammo", "wriggler-missile", "capture-robot-rocket", "railgun-ammo"},
		["ammo-2"] = {"rocket", "explosive-rocket", "atomic-bomb", "cannon-shell", "explosive-cannon-shell", "uranium-cannon-shell", "explosive-uranium-cannon-shell", "artillery-shell"},
		capsule = {"poison-capsule", "slowdown-capsule", "grenade", "cluster-grenade", "defender-capsule", "defender", "distractor-capsule", "distractor", "destroyer", "destroyer-capsule"},
		armor = {"light-armor", "heavy-armor", "modular-armor", "power-armor", "power-armor-mk2", "mech-armor"},
		equipment = {"personal-burner-generator", "personal-battery-generator", "solar-panel-equipment", "fission-reactor-equipment", "fusion-reactor-equipment", "battery-equipment", "battery-mk2-equipment", "battery-mk3-equipment"},
		["utility-equipment"] = {"belt-immunity-equipment", "exoskeleton-equipment", "personal-roboport-equipment", "personal-roboport-mk2-equipment", "night-vision-equipment", "toolbelt-equipment"},
		["military-equipment"] = {"energy-shield-equipment", "energy-shield-mk2-equipment", "personal-laser-defense-equipment", "discharge-defense-equipment"},
		["defensive-structure"] = {"stone-wall", "gate", "radar", "land-mine", "poison-land-mine", "slowdown-land-mine"},
		["turret"] = {"shotgun-turret", "gun-turret", "laser-turret", "flamethrower-turret", "artillery-turret", "rocket-turret", "tesla-turret", "railgun-turret"},
		["ammo-category"] = {},
	},
	heat = {
		["heat-ingots"] = {"heat-ingot-iron", "heat-ingot-copper", "heat-ingot-steel"},
		["water-heat"] = {"steam-condensation", "ice-melting", "lava-water-heating"},
		["cryo-gas-recipes"] = {"nitrogen-compression", "nitrogen-expansion", "oxygen-cascade-cooling", "hydrogen-cascade-cooling", "regenerative-cooling"},
	},
	fluids = {
		-- TODO basically all of this should be moved to other groups. Fluid item-group should be mostly just un/barrelling and venting.
		["nauvis-fluids"] = {"lake-water", "water", "steam", "latex", "cement", "lubricant"},
		["mixed-gases"] = {"air", "flue-gas", "sulfurous-gas"},
		["petrochem-fluids"] = {"crude-oil", "natural-gas", "tar", "heavy-oil", "light-oil", "petroleum-gas", "dry-gas", "syngas", "diesel"},
		["cryo-fluids"] = {"nitrogen-gas", "compressed-nitrogen-gas", "oxygen-gas", "hydrogen-gas", "liquid-nitrogen", "thruster-oxidizer", "thruster-fuel"},
		["vulcanus-fluids"] = {"lava", "volcanic-gas", "molten-iron", "molten-copper", "molten-steel", "molten-tungsten"},
		["gleba-fluids"] = {"slime", "geoplasm", "chitin-broth", "spore-gas"},
		["fulgora-fluids"] = {"fulgoran-sludge", "holmium-solution", "electrolyte"},
		["nauvis-return-fluids"] = {"meat-paste", "uranium-hexafluoride", "hydrofluoric-acid"},
		["fluid"] = {},
			-- This is the default group. Will contain stuff from other mods.
		["aquilo-fluids"] = {"ammoniacal-solution", "fluorine", "lithium-brine", "fusion-plasma"},

		-- Barrel / gas tank recipes: hidden in factoriopedia.
		-- TODO maybe move these to a separate tab entirely?
		-- TODO maybe remove these from here, and set orders programatically to be the same as the fluids.
		barrel = {"crude-oil-barrel", "nitrogen-gas-barrel", "slime-barrel", "fulgoran-sludge-barrel", "natural-gas-barrel", "water-barrel", "geoplasm-barrel", "holmium-solution-barrel", "fluorine-barrel", "compressed-nitrogen-gas-barrel", "tar-barrel", "oxygen-gas-barrel", "electrolyte-barrel", "chitin-broth-barrel", "spore-gas-barrel", "hydrogen-gas-barrel", "heavy-oil-barrel", "ammonia-barrel", "liquid-nitrogen-barrel", "light-oil-barrel", "lithium-brine-barrel", "latex-barrel", "petroleum-gas-barrel", "thruster-oxidizer-barrel", "thruster-fuel-barrel", "sulfuric-acid-barrel", "dry-gas-barrel", "lubricant-barrel", "syngas-barrel", "diesel-barrel", "meat-paste-barrel", "hydrofluoric-acid-barrel"},
		["fill-barrel"] = {"fulgoran-sludge-barrel", "slime-barrel", "crude-oil-barrel", "water-barrel", "holmium-solution-barrel", "geoplasm-barrel", "electrolyte-barrel", "tar-barrel", "chitin-broth-barrel", "heavy-oil-barrel", "lithium-brine-barrel", "light-oil-barrel", "latex-barrel", "sulfuric-acid-barrel", "lubricant-barrel", "diesel-barrel", "meat-paste-barrel"},
		["fill-gas-tank"] = {"nitrogen-gas-barrel", "natural-gas-barrel", "fluorine-barrel", "compressed-nitrogen-gas-barrel", "oxygen-gas-barrel", "hydrogen-gas-barrel", "spore-gas-barrel", "ammonia-barrel", "liquid-nitrogen-barrel", "thruster-oxidizer-barrel", "petroleum-gas-barrel", "dry-gas-barrel", "thruster-fuel-barrel", "syngas-barrel", "hydrofluoric-acid-barrel"},
		["empty-barrel"] = {"empty-crude-oil-barrel", "empty-slime-barrel", "empty-fulgoran-sludge-barrel", "empty-holmium-solution-barrel", "empty-geoplasm-barrel", "empty-water-barrel", "empty-electrolyte-barrel", "empty-tar-barrel", "empty-chitin-broth-barrel", "empty-heavy-oil-barrel", "empty-lithium-brine-barrel", "empty-light-oil-barrel", "empty-latex-barrel", "empty-sulfuric-acid-barrel", "empty-lubricant-barrel", "empty-diesel-barrel", "empty-meat-paste-barrel"},
		["empty-gas-tank"] = {"empty-nitrogen-gas-barrel", "empty-natural-gas-barrel", "empty-fluorine-barrel", "empty-compressed-nitrogen-gas-barrel", "empty-oxygen-gas-barrel", "empty-hydrogen-gas-barrel", "empty-spore-gas-barrel", "empty-ammonia-barrel", "empty-liquid-nitrogen-barrel", "empty-thruster-oxidizer-barrel", "empty-petroleum-gas-barrel", "empty-dry-gas-barrel", "empty-thruster-fuel-barrel", "empty-syngas-barrel", "empty-hydrofluoric-acid-barrel"},
		
		-- Waste pump categories: orders get set the same as the fluids.
		["waste-pump"] = {},
		["gas-vent-on-surface"] = {},
		["gas-vent-in-space"] = {},
	},
	signals = {},
	enemies = {},
	tiles = {}, -- TODO include tiles later?
	environment = {},
	effects = {},
	other = {},
}