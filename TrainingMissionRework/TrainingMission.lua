--Tables--
groundSpawns = {
	SPAWN:New("Red SAM SA-2"),
	SPAWN:New("Red SAM SA-11"),
	SPAWN:New("Red SAM SA-10"),
	SPAWN:New("Red SAM SA-18"),
	SPAWN:New("Red SAM SA-6"),
	SPAWN:New("Red SAM INT"),
	SPAWN:New("Red BTR-80"),
	SPAWN:New("Red T-90"),
	SPAWN:New("Red T-72"),
	SPAWN:New("Red GAZ-66"),
	SPAWN:New("Red Ural"),
	SPAWN:New("Red Inf"),
	}
airSpawns = {
	SPAWN:New("Red SU-25"),
	SPAWN:New("Red SU-34"),
	SPAWN:New("Red JF-17"),
	SPAWN:New("Red Mig-29"),
	SPAWN:New("Red Mig-31"),
	}

zones = { 
	 { zone = ZONE:New("Range Alpha"), template = groundSpawns[1], diff = "Average", qty = 1, rand = false },
	 { zone = ZONE:New("Range Bravo"), template = groundSpawns[1], diff = "Average", qty = 1, rand = false },
	 { zone = ZONE:New("Range Charlie"), template = groundSpawns[1], diff = "Average", qty = 1, rand = false },
	 { zone = ZONE:New("Range Delta"), template = groundSpawns[1], diff = "Average", qty = 1, rand = false },
	 { zone = ZONE:New("Northern Range"), template = airSpawns[1], diff = "Average", qty = 1, rand = true }
	 }

spawnTracker = {}

function spawnTracker.new ( template, zone, rand, diff )
	template:InitSkill(diff)
	return {
		Group = template:SpawnInZone( zone, rand ),
		Zone = zone
	}
end
		
diffs = {
	"Average",
	"Good",
	"High",
	"Excellent",
	"Random"
}

supportSpawns = {
	BlueAWACS = {
		template = SPAWN:New("BlueAWACS"),
		tracker,
		active = false
		},
	RedAWACS = {
		template = SPAWN:New("RedAWACS"),
		tracker,
		active = false
		},
	Texaco = {
		template = SPAWN:New("Texaco-1"),
		tracker,
		active = false
		},
	Shell = {
		template = SPAWN:New("Shell-1"),
		tracker,
		active = false
		}
	}
	
-- Functions
function despawn( unit, text )
	if unit.tracker then
		if unit.tracker:IsAlive() then
			unit.tracker:Destroy()
		end
	end
	local messageText = text .. " despawned."
	MESSAGE:New(messageText, 15):ToAll()
end
	
function respawn( unit, text )
	if unit.tracker then
		if unit.tracker:IsAlive() then
			unit.tracker:Destroy()
		end
	end
	unit.tracker = unit.template:Spawn()
	local messageText = text .. " respawned."
	MESSAGE:New(messageText, 15):ToAll()
end

function spawnTargets( zone )		
	for i = #spawnTracker, 1, -1 do
		if spawnTracker[i].Zone == zone.zone then
			if spawnTracker[i].Group:IsAlive() then
				spawnTracker[i].Group:Destroy()
			end
			table.remove( spawnTracker, i )
			local messageText = "Previous targets despawned."
			MESSAGE:New(messageText, 15):ToAll()
		end
	end
	for i=0, zone.qty do
		table.insert( spawnTracker, spawnTracker.new( zone.template, zone.zone, zone.rand, zone.diff ) )
	end
	local messageText = zone.qty .. " " .. zone.template.SpawnTemplatePrefix  .. " Spawned at " .. zone.zone:GetName() .. " with a difficulty of " .. zone.diff .. "."
	MESSAGE:New(messageText, 15):ToAll()
end
	
function clearRange( zone )
	local units = 0
	for i = #spawnTracker, 1, -1 do
		if spawnTracker[i].Zone == zone.zone then
			if spawnTracker[i].Group:IsAlive() then
				spawnTracker[i].Group:Destroy()
			end
			table.remove( spawnTracker, i )
			units = units + 1
		end
	end
	local prefix = units > 0 and "Previous Units Destroyed at " or "No Units to be Destroyed at "
	MESSAGE:New(prefix .. zone.zone:GetName(), 15):ToAll()
end

-- F10 Menu
MenuMain = {
	MENU_COALITION:New(coalition.side.BLUE, "Range Alpha"),
	MENU_COALITION:New(coalition.side.BLUE, "Range Bravo"),
	MENU_COALITION:New(coalition.side.BLUE, "Range Charlie"),
	MENU_COALITION:New(coalition.side.BLUE, "Range Delta"),
	MENU_COALITION:New(coalition.side.BLUE, "Range Echo (Air Targets)"),
	MENU_COALITION:New(coalition.side.BLUE, "Air Support"),
	MENU_COALITION:New(coalition.side.RED, "Air Support")
	}
	
-- Air Support Options
MenuAirSupport = {
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Despawn AWACS", MenuMain[6], function() despawn(supportSpawns.BlueAWACS, "BLUE AWACS" ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Respawn AWACS", MenuMain[6], function() respawn(supportSpawns.BlueAWACS, "BLUE AWACS" ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Respawn Texaco", MenuMain[6], function() respawn(supportSpawns.Texaco, "TEXACO" ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Respawn Shell", MenuMain[6], function() respawn(supportSpawns.Shell, "SHELL" ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.RED, "Despawn AWACS", MenuMain[7], function() despawn(supportSpawns.RedAWACS, "RED AWACS" ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.RED, "Respawn AWACS", MenuMain[7], function() respawn(supportSpawns.RedAWACS, "RED AWACS" ) end )
	}
	
-- Air Target Options
MenuRangeEcho = {
	MENU_COALITION:New(coalition.side.BLUE, "Spawn Quantity", MenuMain[5]),
	MENU_COALITION:New(coalition.side.BLUE, "Aircraft Spawn Difficulty", MenuMain[5]),
	MENU_COALITION:New(coalition.side.BLUE, "Aircraft Type", MenuMain[5]),
	}
MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn Air Targets", MenuMain[5], function() spawnTargets( Zones.rangeEcho ) end )
MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Air Targets", MenuMain[5], function() clearRange( Zones.rangeEcho ) end )
for m=1, 5, 1 do
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, m, MenuRangeEcho[1], function() zones[5].qty = m end)
end
for n=1, #diffs, 1 do
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, diffs[n], MenuRangeEcho[2], function() zones[5].diff = diffs[n] end)
end
k = 1
l = 3
for j=1, #airSpawns, 1 do
	if k>8 then
		MenuRangeEcho[l+1]=MENU_COALITION:New(coalition.side.BLUE, "More",MenuRangeEcho[l])
		k=1
		l = l + 1
	end
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, string.sub(airSpawns[j].SpawnTemplatePrefix,5), MenuRangeEcho[l], function() zones[5].template = airSpawns[j] end )
	k = k + 1
end
	
rangeMenus = {}
rangeMenuCommands = {}
rangeUnitMenu = {}

for i=1, 4, 1 do
	rangeMenus[i] = {
		MENU_COALITION:New(coalition.side.BLUE, "Spawn Quantity", MenuMain[i]),
		MENU_COALITION:New(coalition.side.BLUE, "Unit Spawn Difficulty", MenuMain[i]),
		MENU_COALITION:New(coalition.side.BLUE, "Randomize Spawn", MenuMain[i]),
		}
	rangeUnitMenu[i] = {}
	rangeUnitMenu[i][1] = {
		MENU_COALITION:New(coalition.side.BLUE, "Unit Type", MenuMain[i]),
		}
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn Range Targets", MenuMain[i], function() spawnTargets( zones[i] ) end )
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Range", MenuMain[i], function() clearRange( zones[i] ) end )
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Randomized", rangeMenus[i][3], function() zones[i].rand = true end )
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Static", rangeMenus[i][3], function() zones[i].rand = false end )
	for m=1, 5, 1 do
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, m, rangeMenus[i][1], function() zones[i].qty = m end)
	end
	for n=1, #diffs, 1 do
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, diffs[n], rangeMenus[i][2], function() zones[i].diff = diffs[n] end)
	end
	k = 1
	l = 1
	rangeUnitCommands[i] = {}
	for j=1, #groundSpawns, 1 do
		if k>8 then
			rangeUnitMenu[i][l+1]=MENU_COALITION:New(coalition.side.BLUE, "More",rangeUnitMenu[i][l])
			k=1
			l = l + 1
		end
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, string.sub(groundSpawns[j].SpawnTemplatePrefix,5), rangeUnitMenu[i][l], function() zones[i].template = groundSpawns[j] end )
		k = k + 1
	end
end

respawn(supportSpawns.Texaco, "TEXACO" )
respawn(supportSpawns.Shell, "SHELL" )
respawn(supportSpawns.BlueAWACS, "BLUE AWACS" )
respawn(supportSpawns.RedAWACS, "RED AWACS" )

MESSAGE:New( "Loaded Mission Successfully.", 35, "INFO" ):ToAll()
