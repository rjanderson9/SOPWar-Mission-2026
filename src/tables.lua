--[[
New SOPWar Persistant Dynamic Mission
Table Structures
by
Robert Anderson
]]--

activeGround = {}

function activeGround.new( startZone, template )
	return {
		Group  = template:SpawnInZone( startZone, true ),   -- group tracker
		Zone = home,  -- Zone
		Template = template, -- Group Template to use
		isAlive = true
	}
end

--[[ 
Example spawn of ground unit: 
	table.insert( activeGround, activeGround.new( startZone, template ) )
	activeGround[activeGround.length].Group:RouteGroundOnRoad( targetZone.GetCoordinate(), speed )
]]--

--[[
Same idea here for aircraft:
]]--

activeAir = {}

function activeAir.new( airbase, template )
	return {
		Group = template:SpawnAtAirbase( AIRBASE:FindByName( airbase ), SPAWN.Takeoff.Hot ),
		Template = template,
		isAlive = true,
	}
end

--[[
Example aircraft spawn:
	table.insert( activeAir, activeAir.new( AIRBASE:FindByName( airbase ), template ) )
	activeAir[activeAir.length].Group:
]]--