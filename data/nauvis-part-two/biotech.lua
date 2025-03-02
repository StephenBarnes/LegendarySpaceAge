-- This file will adjust Nauvis biotech, in "Nauvis part 2" - meat paste, fish breeding, etc.
-- TODO lots more

-- Make biology recipes biochamber-only, not in chem plants.
for _, recipeName in pairs{"fish-breeding", "nutrients-from-fish", "nutrients-from-biter-egg"} do
	RECIPE[recipeName].category = "organic"
end

-- Create fluid for meat paste.
local meatPaste = copy(FLUID["water"])
meatPaste.name = "meat-paste"
Icon.set(meatPaste, "LSA/fluids/meat-paste")
-- TODO fluid colors
Item.setFluidSimpleTemp(meatPaste, 100, true, 10)
extend{meatPaste}