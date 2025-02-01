-- This file will add recipes for low-density structures (which we rename to "Lightweight structure").

-- Move item and recipes into the subgroup.
data.raw.item["low-density-structure"].subgroup = "lightweight-structure"
data.raw.recipe["low-density-structure"].subgroup = "lightweight-structure"
data.raw.recipe["low-density-structure"].order = "02"
data.raw.recipe["casting-low-density-structure"].subgroup = "lightweight-structure"
data.raw.recipe["casting-low-density-structure"].order = "03"

-- Reduce weight of low-density structure.
data.raw.item["low-density-structure"].weight = 500

-- TODO create new recipes for lightweight-structure.