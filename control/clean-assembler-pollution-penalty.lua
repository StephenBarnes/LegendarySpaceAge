--[[ This file implements a productivity penalty for clean assemblers in polluted chunks.
The idea is that clean assemblers do processes that are sensitive to dust or whatever, like manufacturing microchips. So they need to be situated away from polluted regions.
How this works:
	1. Uses Quezler's Beacon Interface mod as dependency. This allows setting arbitrary module effects for hidden beacons with runtime scripting.
	2. Create beacon interface on each clean assembler when it's built, using child entities system.
	3. Maintain a list of all clean assemblers, and associated beacon interfaces, organized by chunk.
	4. Run a regular on_nth_tick function that updates each chunk's clean assemblers' productivity by looking up the pollution level of the chunk.
]]