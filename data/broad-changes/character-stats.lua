-- Boost some character speed stats, because this modpack is for people who are not slow in the head.
local character = RAW.character.character
character.ticks_to_keep_aiming_direction = 50 -- default 100
character.running_speed = .2 -- default 0.15
--character.distance_per_frame = .13 -- default 0.13, seems to be for calculating how fast to play animation frames (along with eg speed bonuses from exoskeletons), so shouldn't be changed.
-- TODO maybe add some techs for running speed bonuses? Or can we have eg techs for spidertron running speed, car driving speed, etc.?