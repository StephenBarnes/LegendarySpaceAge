--[[ This file implements a productivity penalty for clean assemblers in polluted chunks.
The idea is that clean assemblers do processes that are sensitive to dust or whatever, like manufacturing microchips. So they need to be situated away from polluted regions.
How this works:
	1. Uses Quezler's Beacon Interface mod as dependency. This allows 