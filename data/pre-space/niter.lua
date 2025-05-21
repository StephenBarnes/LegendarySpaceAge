-- This file adds the niter item. Niter recipe is in ammonia file.

-- Create niter item
local niterItem = copy(ITEM["sulfur"])
niterItem.name = "niter"
Icon.set(niterItem, "LSA/niter/niter-1")
Icon.variants(niterItem, "LSA/niter/niter-%", 3)
Item.clearFuel(niterItem)
extend{niterItem}