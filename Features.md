New mission to script, 2026

Map: Caucasus

Github Link: https://github.com/rjanderson9/SOPWar-Mission-2026

Pretense Modifications as an option:
	Save survival bonus on landing instead of engine shutdown.
		Line 7190
		Updated on Github
	Assign Missions to AI
		Commander mode?
	Might change ranks to USMC for shits and giggles
	Make better for fewer pilots
		More Blue AI in the air?
		Restrict Red AI?
		Increase AI Tasking
		The problem I’m having here is I don’t know how it handles spawning AI for both sides.
			I want to try adjusting the blueAdvantage config option, as it works within the RNG to boost one side over the other.

Features:
	Persistent
		JSON Files
		Player Data
		Current state of zones
		Persistent mission board?
	Dynamic mission board
		Can we upload a JSON to a server to create a webUI for missions?
		Direct WebSocket to DCS Server?
		Assign missions to AI
	Easily port to other maps
		Script will be written before Mission Editor work starts
		Test functions and ideas with Training Mission
		Should only need to recreate templates and set zones on new map to port
	Capture zones by sending ground forces
		Ground Forces driven by AI
			Must be guarded from attack
		Player initiates capture when zone’s defenses are depleted
			Maybe automate? When units at zone < x, initiate capture?
		Red will send reinforcements at level y, will need to tune difference between them. 
			Red reinforcements when y AND z amount of time since last reinforcement.
		Maybe try to make supply levels dynamic and track supplies by point.
			Then only send reinforcements when supplies exist at closest base.
		Different zone types have different capacities
			Maybe instead of automate, notify Blue when a zone is depleted and ready to be attacked.
	Blue resources unlimited in Carrier, limited at captured zones same as red
	Separate tick script?
		Just a function
		How often to generate missions?
		Multiple ticks with multiple config values for timing
	Mission Generation
		Enemy Missions
			Should be slightly less frequent than blue missions
		Blue ai ground missions
			Supply Levels and abilities
				Deploy SAM Site
					250 pts standard
			Depend on type?
				Does this mission include traveling to site?
					Maybe convoy of trucks go to set up site?
				Randomize, can these be transferred by helicopter?
			Supply mission
				500 pts to start
				Transfers 250 to target
				Maybe require supply mission to deploy SAM?
			Different zone types are limited to what they can deploy
				Airfields can directly deploy SAM on site
				Outposts need SAM to travel to it.
			Can deploy infantry?
	Player ranking
		E-1 to O-10
		Marine ranks, because yeah.
	Survival Bonus
		Save at Landing
		Landing anywhere?
		Verify landing by verifying AGL and speed 
		Player alive
		Maybe 50% if not at friendly airfield
	Mission generation favors battle plan
		Assign priorities to nearby zones
		Allow players to see prioritized zones
	Configurable percentage or number of missions that red will have running at once.

Mission Object
	Mission Type
		String
	Default Group Red
		Group Template
	Default Group Blue
		Group Template
	Target Zone
		Zone
	Target Unit (If Applicable)
		Group ID/Spawn Tracker
	Target Action
		Switch Case Index
			Determines completion condition
			Attack
			Deliver Supplies
			Deploy SAM (Randomize type?)
			Deploy Something Else
				Maybe radar only stations?
			Infantry Outposts
				Motor Pools
					Maybe motor pool can deploy SAM sites
			Artillery?
			SEAD
	Spawn Time
		Time Mark
	Time Limit? 0 for unlimited time
		Time
	isAI
		Boolean, will affect completion condition
	GroupTracker
		Index in activeUnits table
		
Zone Object
	ID
		String
	Type
		Switch Case Index
			Outpost
			Airfield
			FOB
	Supplies Max
		Dependent on Type
	Supplies Rate
		Dependent on Type
		Amount of supplies regenerated per Tick
	Max Regen
		Max supplies from regeneration
			Standard 50%?
	Buildings
		Group Template, I think
		Buildings that should exist at this location
	Building Regen Ticks
		Buildings will regenerate this many ticks after the zone is captured
	Captive State
		-50 to 50
		-50 = Red
		50 = Blue
		0 = Neutral
	Buildings State
		Boolean, do they exist or not?
		Percentage?
		Let’s think

Current Groups Object
	Dynamic LUA table of current groups
	Maybe just stationary ground units?
	Group Template
		Template that created this group
		Will define coalition
	Zone
		Where the group is stationed
	Group Name
		Allows us to directly check on group status
	isAlive
		Check current alive status of group

AI Help with creating Structured LUA Tables:


	In the DCS MOOSE framework and standard Lua, you define a structured table that grows dynamically by using a blueprint function (constructor) to enforce the layout, and standard array functions to append data. Lua tables are dynamic by nature and have no fixed size limits, allowing them to expand as your mission progresses.
	Here is the cleanest way to implement a growing table with a defined structure:
	1. Define the Blueprint and the Container
	lua
	-- Factory function to enforce your structural blueprint
	local function NewTargetData(groupName, targetType, priority)
		return {
			GroupName  = groupName,   -- String
			TargetType = targetType,  -- String
			Priority   = priority,    -- Number
			IsDetected = false,       -- Boolean (Default)
			Timestamp  = timer.getTime() -- DCS engine timestamp
		}
	end

	-- Your master table initialized as empty
	local ActiveTargets = {}

	2. Grow the Table Dynamically
	To append new structured data to your table, use table.insert(). This dynamically increases the size of the table.
	lua
	-- Adding items using the structural blueprint
	table.insert(ActiveTargets, NewTargetData("Red_Tank_1", "Armor", 1))
	table.insert(ActiveTargets, NewTargetData("Red_SAM_2", "Air Defense", 2))

	3. Iterate Through the Structured Table
	You can loop through the list securely using ipairs(), knowing exactly what properties each element contains.
	lua
	for index, target in ipairs(ActiveTargets) do
		if target.Priority == 1 then
			-- Utilize MOOSE logging to inspect the structured data safely
			BASE:E("High priority group found: " .. target.GroupName)
		end
	end

	Alternative: Key-Value Dictionary Growth
	If you need to query items quickly by a unique identifier (like a group name) instead of an indexed list, use the unique identifier as the key:
	lua
	local TrackedGroups = {}

	-- Add or update directly by key
	local gName = "Red_CAP_Alpha"
	TrackedGroups[gName] = NewTargetData(gName, "Intercept", 3)

	-- Access directly without looping
	if TrackedGroups["Red_CAP_Alpha"] then
		TrackedGroups["Red_CAP_Alpha"].IsDetected = true
	end


