--[[ This file creates "clean assemblers" (better name?).
These are assemblers that suffer a big productivity hit in polluted chunks, but also generate zero pollution.
These are necessary for making microchips (like "cleanrooms" in real microchip manufacturing).
So the basic challenge is that they have to be placed far away from the main factory, shipping in ingredients and shipping out products and waste.

I'll also allow all other assembler recipes in them too. So players COULD choose a strategy of only using clean assemblers for everything, but then they need to put all polluting buildings in their factory (like boilers) far away and use lots of air filters etc.
]]

-- TODO get sprites (assembler building but white?)
-- TODO create item, entity, etc.
-- TODO use control-stage scripting to create an invisible beacon inside every clean assembler, and use control-stage scripting to check pollution and put modules in them depending on pollution level. Also cache table of all clean assemblers.
-- TODO ban them completely on Gleba? Since ambient air has spores? Or ban based on spore level?
-- TODO what to do for Fulgora and Vulcanus?