--Tables--
spawns = {
	SA2 = SPAWN:New("Red SAM SA-2"),
	SA11 = SPAWN:New("Red SAM SA-11"),
	SA10 = SPAWN:New("Red SAM SA-10"),
	SA18 = SPAWN:New("Red SAM SA-18"),
	SA6 = SPAWN:New("Red SAM SA-6"),
	SAM = SPAWN:New("Red SAM INT"),
	BTR80 = SPAWN:New("Red BTR-80"),
	T90 = SPAWN:New("Red T-90"),
	T72 = SPAWN:New("Red T-72"),
	GAZ66 = SPAWN:New("Red GAZ-66"),
	Ural = SPAWN:New("Red Ural"),
	Inf = SPAWN:New("Red Inf"),
	SU25 = SPAWN:New("Red SU-25"),
	SU34 = SPAWN:New("Red SU-34"),
	JF17 = SPAWN:New("Red JF-17"),
	Mig29 = SPAWN:New("Red Mig-29"),
	Mig31 = SPAWN:New("Red Mig-31")
	}

zones = { 
	 { zone = ZONE:New("Range Alpha"), template = spawns.SA2, diff = "Average", qty = 1, rand = false },
	 { zone = ZONE:New("Range Bravo"), template = spawns.SA2, diff = "Average", qty = 1, rand = false },
	 { zone = ZONE:New("Range Charlie"), template = spawns.SA2, diff = "Average", qty = 1, rand = false },
	 { zone = ZONE:New("Range Delta"), template = spawns.SA2, diff = "Average", qty = 1, rand = false },
	 { zone = ZONE:New("Northern Range"), template = spawns.SU25, diff = "Average", qty = 1, rand = true }
	 }

spawnTracker = {}

function spawnTracker.new ( template, zone, rand, diff )
	template:InitSkill(diff)
	return {
		Group = template.SpawnInZone( zone, rand )
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
		}
	RedAWACS = {
		template = SPAWN:New("RedAWACS"),
		tracker,
		active = false
		}
	Texaco = {
		template = SPAWN:New("Texaco-1"),
		tracker,
		active = false
		}
	Shell = {
		template = SPAWN:New("Shell-1"),
		tracker,
		active = false
		}
	}
	
-- Functions
function despawn( unit, text )
	if unit.tracker:IsAlive() then
		unit.tracker:Destroy()
	end
	local messageText = text .. " despawned."
	MESSAGE:New(messageText, 15):ToAll()
end
	
function respawn( unit, text )
	if unit.tracker:IsAlive() then
		unit.tracker:Destroy()
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
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Despawn AWACS", MenuMain[6], function() despawn(BlueAWACS, "BLUE AWACS" ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Respawn AWACS", MenuMain[6], function() respawn(BlueAWACS, "BLUE AWACS" ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Respawn Texaco", MenuMain[6], function() respawn(Texaco, "TEXACO" ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Respawn Shell", MenuMain[6], function() respawn(Shell, "SHELL" ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.RED, "Despawn AWACS", MenuMain[7], function() despawn(RedAWACS, "RED AWACS" ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.RED, "Respawn AWACS", MenuMain[7], function() respawn(RedAWACS, "RED AWACS" ) end )
	}
	
-- Air Target Options
MenuRangeEcho = {
	MENU_COALITION:New(coalition.side.BLUE, "Spawn Quantity", MenuMain[5]),
	MENU_COALITION:New(coalition.side.BLUE, "Aircraft Spawn Difficulty", MenuMain[5]),
	MENU_COALITION:New(coalition.side.BLUE, "Aircraft Type", MenuMain[5]),
	}
MenuRangeEchoCommands = {
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn Air Targets", MenuMain[5], function() spawnTargets( Zones.rangeEcho ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Air Targets", MenuMain[5], function() clearRange( Zones.rangeEcho ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "1", MenuRangeEcho[1], function() zones.rangeEcho.qty = 1 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "2", MenuRangeEcho[1], function() zones.rangeEcho.qty = 2 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "3", MenuRangeEcho[1], function() zones.rangeEcho.qty = 3 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "4", MenuRangeEcho[1], function() zones.rangeEcho.qty = 4 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "5", MenuRangeEcho[1], function() zones.rangeEcho.qty = 5 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Average", MenuRangeEcho[2], function() zones.rangeEcho.diff = "Average" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Good", MenuRangeEcho[2], function() zones.rangeEcho.diff = "Good" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "High", MenuRangeEcho[2], function() zones.rangeEcho.diff = "High" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Excellent", MenuRangeEcho[2], function() zones.rangeEcho.diff = "Excellent" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Random", MenuRangeEcho[2], function() zones.rangeEcho.diff = "Random" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SU-25", MenuRangeEcho[3], function() zones.rangeEcho.template = spawns.SU25 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SU-34", MenuRangeEcho[3], function() zones.rangeEcho.template = spawns.SU34 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "JF-17", MenuRangeEcho[3], function() zones.rangeEcho.template = spawns.JF17 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Mig-29", MenuRangeEcho[3], function() zones.rangeEcho.template = spawns.Mig29 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Mig-31", MenuRangeEcho[3], function() zones.rangeEcho.template = spawns.Mig31 end )
	}

rangeMenus = {}
rangeMenuCommands = {}

for i=1, 4, 1 do
	rangeMenus[i] = {
		MENU_COALITION:New(coalition.side.BLUE, "Spawn Quantity", MenuMain[i]),
		MENU_COALITION:New(coalition.side.BLUE, "Unit Spawn Difficulty", MenuMain[i]),
		MENU_COALITION:New(coalition.side.BLUE, "Unit Type", MenuMain[i]),
		MENU_COALITION:New(coalition.side.BLUE, "Randomize Spawn", MenuMain[i]),
		MENU_COALITION:New(coalition.side.BLUE, "SAM Targets", rangeMenus[i][3]),
		MENU_COALITION:New(coalition.side.BLUE, "Armor Targets", rangeMenus[i][3]),
		MENU_COALITION:New(coalition.side.BLUE, "Infantry Targets", rangeMenus[i][3])
		}
	rangeMenuCommands[i] = {
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn Range Targets", MenuMain[i], function() spawnTargets( Zones[i] ) end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Range", MenuMain[i], function() clearRange( Zones[i] ) end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "1", rangeMenus[i][1], function() zones[i].qty = 1 end),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "2", rangeMenus[i][1], function() zones[i].qty = 2 end),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "3", rangeMenus[i][1], function() zones[i].qty = 3 end),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "4", rangeMenus[i][1], function() zones[i].qty = 4 end),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "5", rangeMenus[i][1], function() zones[i].qty = 5 end),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Average", rangeMenus[i][2], function() zones[i].diff = "Average" end),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Good", rangeMenus[i][2], function() zones[i].diff = "Good" end),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "High", rangeMenus[i][2], function() zones[i].diff = "High" end),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Excellent", rangeMenus[i][2], function() zones[i].diff = "Excellent" end),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Random", rangeMenus[i][2], function() zones[i].diff = "Random" end),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Randomized", rangeMenus[i][4], function() zones[i].rand = true end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Static", rangeMenus[i][4], function() zones[i].rand = false end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", rangeMenus[i][5], function() zones[i].template = spawns.SA2 end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", rangeMenus[i][5], function() zones[i].template = spawns.SA11 end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", rangeMenus[i][5], function() zones[i].template = spawns.SA10 end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", rangeMenus[i][5], function() zones[i].template = spawns.SA18 end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", rangeMenus[i][5], function() zones[i].template = spawns.SA6 end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", rangeMenus[i][5], function() zones[i].template = spawns.SAM end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", rangeMenus[i][6], function() zones[i].template = spawns.BTR80 end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", rangeMenus[i][6], function() zones[i].template = spawns.T90 end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", rangeMenus[i][6], function() zones[i].template = spawns.T72 end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", rangeMenus[i][7], function() zones[i].template = spawns.GAZ66 end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", rangeMenus[i][7], function() zones[i].template = spawns.Ural end ),
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", rangeMenus[i][7], function() zones[i].template = spawns.Inf end ),
		}
end

--[[
-- Range Alpha
MenuRangeAlpha = {
	MENU_COALITION:New(coalition.side.BLUE, "Spawn Quantity", MenuMain[1]),
	MENU_COALITION:New(coalition.side.BLUE, "Unit Spawn Difficulty", MenuMain[1]),
	MENU_COALITION:New(coalition.side.BLUE, "Unit Type", MenuMain[1]),
	MENU_COALITION:New(coalition.side.BLUE, "Randomize Spawn", MenuMain[1]),
	MENU_COALITION:New(coalition.side.BLUE, "SAM Targets", MenuRangeAlpha[3]),
	MENU_COALITION:New(coalition.side.BLUE, "Armor Targets", MenuRangeAlpha[3]),
	MENU_COALITION:New(coalition.side.BLUE, "Infantry Targets", MenuRangeAlpha[3])
	}
MenuRangeAlphaCommands = {
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn Range Alpha Targets", MenuMain[1], function() spawnTargets( Zones.rangeAlpha ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Range Alpha", MenuMain[1], function() clearRange( Zones.rangeAlpha ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "1", MenuRangeAlpha[1], function() zones.rangeAlpha.qty = 1 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "2", MenuRangeAlpha[1], function() zones.rangeAlpha.qty = 2 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "3", MenuRangeAlpha[1], function() zones.rangeAlpha.qty = 3 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "4", MenuRangeAlpha[1], function() zones.rangeAlpha.qty = 4 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "5", MenuRangeAlpha[1], function() zones.rangeAlpha.qty = 5 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Average", MenuRangeAlpha[2], function() zones.rangeAlpha.diff = "Average" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Good", MenuRangeAlpha[2], function() zones.rangeAlpha.diff = "Good" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "High", MenuRangeAlpha[2], function() zones.rangeAlpha.diff = "High" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Excellent", MenuRangeAlpha[2], function() zones.rangeAlpha.diff = "Excellent" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Random", MenuRangeAlpha[2], function() zones.rangeAlpha.diff = "Random" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Randomized", MenuRangeAlpha[4], function() zones.rangeAlpha.rand = true end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Static", MenuRangeAlpha[4], function() zones.rangeAlpha.rand = false end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", MenuRangeAlpha[5], function() zones.rangeAlpha.template = spawns.SA2 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", MenuRangeAlpha[5], function() zones.rangeAlpha.template = spawns.SA11 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", MenuRangeAlpha[5], function() zones.rangeAlpha.template = spawns.SA10 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", MenuRangeAlpha[5], function() zones.rangeAlpha.template = spawns.SA18 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", MenuRangeAlpha[5], function() zones.rangeAlpha.template = spawns.SA6 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", MenuRangeAlpha[5], function() zones.rangeAlpha.template = spawns.SAM end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", MenuRangeAlpha[6], function() zones.rangeAlpha.template = spawns.BTR80 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", MenuRangeAlpha[6], function() zones.rangeAlpha.template = spawns.T90 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", MenuRangeAlpha[6], function() zones.rangeAlpha.template = spawns.T72 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", MenuRangeAlpha[7], function() zones.rangeAlpha.template = spawns.GAZ66 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", MenuRangeAlpha[7], function() zones.rangeAlpha.template = spawns.Ural end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", MenuRangeAlpha[7], function() zones.rangeAlpha.template = spawns.Inf end ),
	}
	
-- Range Bravo
MenuRangeBravo = {
	MENU_COALITION:New(coalition.side.BLUE, "Spawn Quantity", MenuMain[2]),
	MENU_COALITION:New(coalition.side.BLUE, "Unit Spawn Difficulty", MenuMain[2]),
	MENU_COALITION:New(coalition.side.BLUE, "Unit Type", MenuMain[2]),
	MENU_COALITION:New(coalition.side.BLUE, "Randomize Spawn", MenuMain[2]),
	MENU_COALITION:New(coalition.side.BLUE, "SAM Targets", MenuRangeBravo[3]),
	MENU_COALITION:New(coalition.side.BLUE, "Armor Targets", MenuRangeBravo[3]),
	MENU_COALITION:New(coalition.side.BLUE, "Infantry Targets", MenuRangeBravo[3])
	}
MenuRangeBravoCommands = {
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn Range Bravo Targets", MenuMain[1], function() spawnTargets( Zones.rangeBravo ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Range Bravo", MenuMain[1], function() clearRange( Zones.rangeBravo ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "1", MenuRangeBravo[1], function() zones.rangeBravo.qty = 1 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "2", MenuRangeBravo[1], function() zones.rangeBravo.qty = 2 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "3", MenuRangeBravo[1], function() zones.rangeBravo.qty = 3 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "4", MenuRangeBravo[1], function() zones.rangeBravo.qty = 4 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "5", MenuRangeBravo[1], function() zones.rangeBravo.qty = 5 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Average", MenuRangeBravo[2], function() zones.rangeBravo.diff = "Average" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Good", MenuRangeBravo[2], function() zones.rangeBravo.diff = "Good" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "High", MenuRangeBravo[2], function() zones.rangeBravo.diff = "High" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Excellent", MenuRangeBravo[2], function() zones.rangeBravo.diff = "Excellent" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Random", MenuRangeBravo[2], function() zones.rangeBravo.diff = "Random" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Randomized", MenuRangeBravo[4], function() zones.rangeBravo.rand = true end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Static", MenuRangeBravo[4], function() zones.rangeBravo.rand = false end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", MenuRangeBravo[5], function() zones.rangeBravo.template = spawns.SA2 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", MenuRangeBravo[5], function() zones.rangeBravo.template = spawns.SA11 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", MenuRangeBravo[5], function() zones.rangeBravo.template = spawns.SA10 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", MenuRangeBravo[5], function() zones.rangeBravo.template = spawns.SA18 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", MenuRangeBravo[5], function() zones.rangeBravo.template = spawns.SA6 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", MenuRangeBravo[5], function() zones.rangeBravo.template = spawns.SAM end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", MenuRangeBravo[6], function() zones.rangeBravo.template = spawns.BTR80 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", MenuRangeBravo[6], function() zones.rangeBravo.template = spawns.T90 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", MenuRangeBravo[6], function() zones.rangeBravo.template = spawns.T72 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", MenuRangeBravo[7], function() zones.rangeBravo.template = spawns.GAZ66 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", MenuRangeBravo[7], function() zones.rangeBravo.template = spawns.Ural end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", MenuRangeBravo[7], function() zones.rangeBravo.template = spawns.Inf end ),
	}
	
-- Range Charlie
MenuRangeCharlie = {
	MENU_COALITION:New(coalition.side.BLUE, "Spawn Quantity", MenuMain[3]),
	MENU_COALITION:New(coalition.side.BLUE, "Unit Spawn Difficulty", MenuMain[3]),
	MENU_COALITION:New(coalition.side.BLUE, "Unit Type", MenuMain[3]),
	MENU_COALITION:New(coalition.side.BLUE, "Randomize Spawn", MenuMain[3]),
	MENU_COALITION:New(coalition.side.BLUE, "SAM Targets", MenuRangeCharlie[3]),
	MENU_COALITION:New(coalition.side.BLUE, "Armor Targets", MenuRangeCharlie[3]),
	MENU_COALITION:New(coalition.side.BLUE, "Infantry Targets", MenuRangeCharlie[3])
	}
MenuRangeCharlieCommands = {
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn Range Charlie Targets", MenuMain[1], function() spawnTargets( Zones.rangeCharlie ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Range Charlie", MenuMain[1], function() clearRange( Zones.rangeCharlie ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "1", MenuRangeCharlie[1], function() zones.rangeCharlie.qty = 1 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "2", MenuRangeCharlie[1], function() zones.rangeCharlie.qty = 2 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "3", MenuRangeCharlie[1], function() zones.rangeCharlie.qty = 3 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "4", MenuRangeCharlie[1], function() zones.rangeCharlie.qty = 4 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "5", MenuRangeCharlie[1], function() zones.rangeCharlie.qty = 5 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Average", MenuRangeCharlie[2], function() zones.rangeCharlie.diff = "Average" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Good", MenuRangeCharlie[2], function() zones.rangeCharlie.diff = "Good" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "High", MenuRangeCharlie[2], function() zones.rangeCharlie.diff = "High" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Excellent", MenuRangeCharlie[2], function() zones.rangeCharlie.diff = "Excellent" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Random", MenuRangeCharlie[2], function() zones.rangeCharlie.diff = "Random" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Randomized", MenuRangeCharlie[4], function() zones.rangeCharlie.rand = true end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Static", MenuRangeCharlie[4], function() zones.rangeCharlie.rand = false end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", MenuRangeCharlie[5], function() zones.rangeCharlie.template = spawns.SA2 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", MenuRangeCharlie[5], function() zones.rangeCharlie.template = spawns.SA11 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", MenuRangeCharlie[5], function() zones.rangeCharlie.template = spawns.SA10 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", MenuRangeCharlie[5], function() zones.rangeCharlie.template = spawns.SA18 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", MenuRangeCharlie[5], function() zones.rangeCharlie.template = spawns.SA6 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", MenuRangeCharlie[5], function() zones.rangeCharlie.template = spawns.SAM end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", MenuRangeCharlie[6], function() zones.rangeCharlie.template = spawns.BTR80 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", MenuRangeCharlie[6], function() zones.rangeCharlie.template = spawns.T90 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", MenuRangeCharlie[6], function() zones.rangeCharlie.template = spawns.T72 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", MenuRangeCharlie[7], function() zones.rangeCharlie.template = spawns.GAZ66 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", MenuRangeCharlie[7], function() zones.rangeCharlie.template = spawns.Ural end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", MenuRangeCharlie[7], function() zones.rangeCharlie.template = spawns.Inf end ),
	}

-- Range Delta
MenuRangeDelta = {
	MENU_COALITION:New(coalition.side.BLUE, "Spawn Quantity", MenuMain[4]),
	MENU_COALITION:New(coalition.side.BLUE, "Unit Spawn Difficulty", MenuMain[4]),
	MENU_COALITION:New(coalition.side.BLUE, "Unit Type", MenuMain[4]),
	MENU_COALITION:New(coalition.side.BLUE, "Randomize Spawn", MenuMain[4]),
	MENU_COALITION:New(coalition.side.BLUE, "SAM Targets", MenuRangeDelta[3]),
	MENU_COALITION:New(coalition.side.BLUE, "Armor Targets", MenuRangeDelta[3]),
	MENU_COALITION:New(coalition.side.BLUE, "Infantry Targets", MenuRangeDelta[3])
	}
MenuRangeDeltaCommands = {
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn Range Delta Targets", MenuMain[1], function() spawnTargets( Zones.rangeDelta ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Range Delta", MenuMain[1], function() clearRange( Zones.rangeDelta ) end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "1", MenuRangeDelta[1], function() zones.rangeDelta.qty = 1 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "2", MenuRangeDelta[1], function() zones.rangeDelta.qty = 2 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "3", MenuRangeDelta[1], function() zones.rangeDelta.qty = 3 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "4", MenuRangeDelta[1], function() zones.rangeDelta.qty = 4 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "5", MenuRangeDelta[1], function() zones.rangeDelta.qty = 5 end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Average", MenuRangeDelta[2], function() zones.rangeDelta.diff = "Average" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Good", MenuRangeDelta[2], function() zones.rangeDelta.diff = "Good" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "High", MenuRangeDelta[2], function() zones.rangeDelta.diff = "High" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Excellent", MenuRangeDelta[2], function() zones.rangeDelta.diff = "Excellent" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Random", MenuRangeDelta[2], function() zones.rangeDelta.diff = "Random" end),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Randomized", MenuRangeDelta[4], function() zones.rangeDelta.rand = true end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Static", MenuRangeDelta[4], function() zones.rangeDelta.rand = false end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", MenuRangeDelta[5], function() zones.rangeDelta.template = spawns.SA2 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", MenuRangeDelta[5], function() zones.rangeDelta.template = spawns.SA11 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", MenuRangeDelta[5], function() zones.rangeDelta.template = spawns.SA10 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", MenuRangeDelta[5], function() zones.rangeDelta.template = spawns.SA18 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", MenuRangeDelta[5], function() zones.rangeDelta.template = spawns.SA6 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", MenuRangeDelta[5], function() zones.rangeDelta.template = spawns.SAM end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", MenuRangeDelta[6], function() zones.rangeDelta.template = spawns.BTR80 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", MenuRangeDelta[6], function() zones.rangeDelta.template = spawns.T90 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", MenuRangeDelta[6], function() zones.rangeDelta.template = spawns.T72 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", MenuRangeDelta[7], function() zones.rangeDelta.template = spawns.GAZ66 end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", MenuRangeDelta[7], function() zones.rangeDelta.template = spawns.Ural end ),
	MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", MenuRangeDelta[7], function() zones.rangeDelta.template = spawns.Inf end ),
	}
]]--

respawn(Texaco, "TEXACO" )
respawn(Shell, "SHELL" )
respawn(BlueAWACS, "BLUE AWACS" )
respawn(RedAWACS, "RED AWACS" )

MESSAGE:New( "Loaded Mission Successfully.", 35, "INFO" ):ToAll()
