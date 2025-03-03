-- Diurnal Dynamics: hide flare from factoriopedia, since we're disabling it using mod setting.
RAW.capsule["data-dd-flare-capsule"].hidden_in_factoriopedia = true
RECIPE["data-dd-flare-capsule"].hidden_in_factoriopedia = true
-- Also hide non-user-facing stuff from factoriopedia. (Shouldn't be created at all if flares are disabled.)
RAW.explosion["data-dd-explosion-flare"].hidden = true
RAW.projectile["data-dd-flare-capsule"].hidden = true
RAW["smoke-with-trigger"]["data-dd-flare-cloud"].hidden = true