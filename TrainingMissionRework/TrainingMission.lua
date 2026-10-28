
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
	BlueAWACSTemplate = SPAWN:New("BlueAWACS"),
	TexacoTemplate = SPAWN:New("Texaco-1"),
	ShellTemplate = SPAWN:New("Shell-1"),
	RedAWACSTemplate = SPAWN:New("RedAWACS"),
	}

zones = { 
	 { zone = ZONE:New("Range Alpha"), spawn = spawns.SA2, diff = "Average", qty = 1 },
	 { zone = ZONE:New("Range Bravo"), spawn = spawns.SA2, diff = "Average", qty = 1 },
	 { zone = ZONE:New("Range Charlie"), spawn = spawns.SA2, diff = "Average", qty = 1 },
	 { zone = ZONE:New("Range Delta"), spawn = spawns.SA2, diff = "Average", qty = 1 },
	 { zone = ZONE:New("Northern Range"), spawn = spawns.SU25, diff = "Average", qty = 1 }
	 }

spawnTracker = {}

function spawnTracker.new ( template, zone, rand )
	return {
		Group = template.SpawnInZone( zone, rand )
	}
end
		
diffs = {
	"Average",
	"Good",
	"High",
	"Excellent",
	"Random"
}

-- Update paused here

aircraftSpawnNumber = 1
BlueAWACS = { spawn }
Texaco = { spawn }
Shell = { spawn }
RedAWACS = { spawn }
BlueAWACSTemplate = SPAWN:New("BlueAWACS")
TexacoTemplate = SPAWN:New("Texaco-1")
ShellTemplate = SPAWN:New("Shell-1")
RedAWACSTemplate = SPAWN:New("RedAWACS")

-- Functions
 function spawnTargets( groupTemplate, spawnZone, diff, QTY, tracker, rand )
	if tracker.spawn then
		tracker.spawn:Destroy()
		messageText = "Previous Units Destroyed at " .. spawnZone:GetName()
		MESSAGE:New(messageText, 15):ToAll()
	end
	groupTemplate:InitSkill(diff)
	tracker.spawn = groupTemplate:SpawnInZone( spawnZone, rand )
	messageText = groupTemplate.SpawnTemplatePrefix  .. " Spawned at " .. spawnZone:GetName() .. " with a difficulty of " .. diff .. "."
	MESSAGE:New(messageText, 15):ToAll()
end

function spawnAirTargets( groupTemplate, spawnZone, diff, QTY, tracker, rand )
	for index,grp in ipairs(tracker.spawn) do
		grp:Destroy()
		messageText = "Previous Units Destroyed at " .. spawnZone:GetName()
		MESSAGE:New(messageText, 15):ToAll()
	end
	groupTemplate:InitSkill(diff)
	for i=1, QTY do
		local tempTrack = groupTemplate:SpawnInZone( spawnZone, rand )
		table.insert( tracker.spawn, tempTrack )
	end
	messageText = QTY .. " " .. groupTemplate.SpawnTemplatePrefix  .. " Spawned at " .. spawnZone:GetName() .. " with a difficulty of " .. diff .. "."
	MESSAGE:New(messageText, 15):ToAll()
end

 function clearRange( range, tracker )
	if tracker.spawn then
		tracker.spawn:Destroy()
		messageText = "Previous Units Destroyed at " .. range:GetName()
		MESSAGE:New(messageText, 15):ToAll()
	else
		messageText = "No Units to be Destroyed at " .. range:GetName()
		MESSAGE:New(messageText, 15):ToAll()
	end
end

 function clearAirRange( range, tracker )
	if tracker.spawn then
		for index, grp in ipairs(tracker.spawn) do
			grp:Destroy()
		end
		messageText = "Previous Units Destroyed at " .. range:GetName()
		MESSAGE:New(messageText, 15):ToAll()
	else
		messageText = "No Units to be Destroyed at " .. range:GetName()
		MESSAGE:New(messageText, 15):ToAll()
	end
end

 function despawn( tracker, text )
	tracker.spawn:Destroy()
	 messageText = text .. " despawned."
	MESSAGE:New(messageText, 15):ToAll()
end
	
 function respawn( tracker, groupTemplate, text )
	tracker.spawn:Destroy()
	tracker.spawn = groupTemplate:Spawn()
	messageText = text .. " respawned."
	MESSAGE:New(messageText, 15):ToAll()
end

-- F10 Menu
 rangeAlpha = MENU_COALITION:New(coalition.side.BLUE, "Range Alpha")
 rangeBravo = MENU_COALITION:New(coalition.side.BLUE, "Range Bravo")
 rangeCharlie = MENU_COALITION:New(coalition.side.BLUE, "Range Charlie")
 rangeDelta = MENU_COALITION:New(coalition.side.BLUE, "Range Delta")
 airTargets = MENU_COALITION:New(coalition.side.BLUE, "Air Targets")
 airSupportBlue = MENU_COALITION:New(coalition.side.BLUE, "Air Support")
 airSupportRed = MENU_COALITION:New(coalition.side.RED, "Air Support")

-- Air Support Options
 airSupportBlueDespawnAWACS = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Despawn AWACS", airSupportBlue, function() despawn(BlueAWACS, "BLUE AWACS" ) end )
 airSupportBlueRespawnAWACS = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Respawn AWACS", airSupportBlue, function() respawn(BlueAWACS, BlueAWACSTemplate, "BLUE AWACS" ) end )
 airSupportBlueRespawnTexaco = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Respawn Texaco", airSupportBlue, function() respawn(Texaco, TexacoTemplate, "TEXACO" ) end )
 airSupportBlueRespawnShell = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Respawn Shell", airSupportBlue, function() respawn(Shell, ShellTemplate, "SHELL" ) end )
 airSupportRedDespawnAWACS = MENU_COALITION_COMMAND:New(coalition.side.RED, "Despawn AWACS", airSupportRed, function() despawn(RedAWACS, "RED AWACS" ) end )
 airSupportRedRespawnAWACS = MENU_COALITION_COMMAND:New(coalition.side.RED, "Respawn AWACS", airSupportRed, function() respawn(RedAWACS, RedAWACSTemplate, "RED AWACS" ) end )

-- Air Target Options
 airTargetsQTY = MENU_COALITION:New(coalition.side.BLUE, "Aircraft Spawn Quantity", airTargets)
 airTargetsQTY1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "1", airTargetsQTY, function() aircraftSpawnNumber = 1 end)
 airTargetsQTY2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "2", airTargetsQTY, function() aircraftSpawnNumber = 2 end)
 airTargetsQTY3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "3", airTargetsQTY, function() aircraftSpawnNumber = 3 end)
 airTargetsQTY4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "4", airTargetsQTY, function() aircraftSpawnNumber = 4 end)
 airTargetsQTY5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "5", airTargetsQTY, function() aircraftSpawnNumber = 5 end)

 airTargetsDiff = MENU_COALITION:New(coalition.side.BLUE, "Aircraft Spawn Difficulty", airTargets)
 airTargetsDiff1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Average", airTargetsDiff, function() rangeAirDifficulty = "Average" end)
 airTargetsDiff2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Good", airTargetsDiff, function() rangeAirDifficulty = "Good" end)
 airTargetsDiff3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "High", airTargetsDiff, function() rangeAirDifficulty = "High" end)
 airTargetsDiff4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Excellent", airTargetsDiff, function() rangeAirDifficulty = "Excellent" end)
 airTargetsDiff5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Random", airTargetsDiff, function() rangeAirDifficulty = "Random" end)

 airTargets1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SU-25", airTargets, function() spawnAirTargets( SU25_Spawn, airRangeZone, rangeAirDifficulty, aircraftSpawnNumber, rangeAirSpawned, true ) end )
 airTargets2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SU-34", airTargets, function() spawnAirTargets( SU34_Spawn, airRangeZone, rangeAirDifficulty, aircraftSpawnNumber, rangeAirSpawned, true ) end )
 airTargets3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "JF-17", airTargets, function() spawnAirTargets( JF17_Spawn, airRangeZone, rangeAirDifficulty, aircraftSpawnNumber, rangeAirSpawned, true ) end )
 airTargets4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Mig-29", airTargets, function() spawnAirTargets( Mig29_Spawn, airRangeZone, rangeAirDifficulty, aircraftSpawnNumber, rangeAirSpawned, true ) end )
 airTargets5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Mig-31", airTargets, function() spawnAirTargets( Mig31_Spawn, airRangeZone, rangeAirDifficulty, aircraftSpawnNumber, rangeAirSpawned, true ) end )
	
 airTargetsClear = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Air Targets", airTargets, function() clearAirRange( airRangeZone, rangeAirSpawned ) end )

-- Range Alpha
 rangeAlphaDiff = MENU_COALITION:New(coalition.side.BLUE, "Range Alpha Spawn Difficulty", rangeAlpha)
 rangeAlphaDiff1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Average", rangeAlphaDiff, function()  rangeAlphaDifficulty = "Average"  messageText = "Range Alpha Difficulty set to: " .. rangeAlphaDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeAlphaDiff2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Good", rangeAlphaDiff, function()  rangeAlphaDifficulty = "Good"  messageText = "Range Alpha Difficulty set to: " .. rangeAlphaDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeAlphaDiff3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "High", rangeAlphaDiff, function()  rangeAlphaDifficulty = "High"  messageText = "Range Alpha Difficulty set to: " .. rangeAlphaDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeAlphaDiff4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Excellent", rangeAlphaDiff, function()  rangeAlphaDifficulty = "Excellent"  messageText = "Range Alpha Difficulty set to: " .. rangeAlphaDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeAlphaDiff5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Random", rangeAlphaDiff, function()  rangeAlphaDifficulty = "Random"  messageText = "Range Alpha Difficulty set to: " .. rangeAlphaDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeAlphaDiff6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Current Difficulty", rangeAlphaDiff, function()  messageText = "Range Alpha Difficulty set to: " .. rangeAlphaDifficulty MESSAGE:New(messageText, 15):ToAll() end )

-- Range Alpha Random
 rangeAlphaRandom = MENU_COALITION:New(coalition.side.BLUE, "Randomized",rangeAlpha)
 rangeAlphaRandomSAM = MENU_COALITION:New(coalition.side.BLUE, "SAM Targets",rangeAlphaRandom)
 rangeAlphaRandomSAM1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", rangeAlphaRandomSAM, function() spawnTargets( SA2_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeAlphaRandomSAM2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", rangeAlphaRandomSAM, function() spawnTargets( SA11_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeAlphaRandomSAM3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", rangeAlphaRandomSAM, function() spawnTargets( SA6_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeAlphaRandomSAM4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", rangeAlphaRandomSAM, function() spawnTargets( SA10_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeAlphaRandomSAM5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", rangeAlphaRandomSAM, function() spawnTargets( SA18_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeAlphaRandomSAM6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", rangeAlphaRandomSAM, function() spawnTargets( SAM_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )

-- Armor
 rangeAlphaRandomArmor = MENU_COALITION:New(coalition.side.BLUE, "Armor Targets",rangeAlphaRandom)
 rangeAlphaRandomArmor1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", rangeAlphaRandomArmor, function() spawnTargets( BTR80_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeAlphaRandomArmor2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", rangeAlphaRandomArmor, function() spawnTargets( T90_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeAlphaRandomArmor3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", rangeAlphaRandomArmor, function() spawnTargets( T72_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
	
-- Infantry/Trucks
 rangeAlphaRandomInfantry = MENU_COALITION:New(coalition.side.BLUE, "Infantry/Truck Targets",rangeAlphaRandom)
 rangeAlphaRandomInfantry1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", rangeAlphaRandomInfantry, function() spawnTargets( GAZ66_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeAlphaRandomInfantry2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", rangeAlphaRandomInfantry, function() spawnTargets( Ural_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeAlphaRandomInfantry3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", rangeAlphaRandomInfantry, function() spawnTargets( Inf_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
	
-- Range Alpha Static
 rangeAlphaStatic = MENU_COALITION:New(coalition.side.BLUE, "Static",rangeAlpha)
 rangeAlphaStaticSAM = MENU_COALITION:New(coalition.side.BLUE, "SAM Targets",rangeAlphaStatic)
 rangeAlphaStaticSAM1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", rangeAlphaStaticSAM, function() spawnTargets( SA2_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeAlphaStaticSAM2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", rangeAlphaStaticSAM, function() spawnTargets( SA11_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeAlphaStaticSAM3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", rangeAlphaStaticSAM, function() spawnTargets( SA6_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeAlphaRandomSAM4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", rangeAlphaStaticSAM, function() spawnTargets( SA10_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeAlphaRandomSAM5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", rangeAlphaStaticSAM, function() spawnTargets( SA18_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeAlphaRandomSAM6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", rangeAlphaStaticSAM, function() spawnTargets( SAM_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )

-- Armor
 rangeAlphaStaticArmor = MENU_COALITION:New(coalition.side.BLUE, "Armor Targets",rangeAlphaStatic)
 rangeAlphaStaticArmor1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", rangeAlphaStaticArmor, function() spawnTargets( BTR80_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeAlphaStaticArmor2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", rangeAlphaStaticArmor, function() spawnTargets( T90_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeAlphaStaticArmor3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", rangeAlphaStaticArmor, function() spawnTargets( T72_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
	
-- Infantry/Trucks
 rangeAlphaStaticInfantry = MENU_COALITION:New(coalition.side.BLUE, "Infantry/Truck Targets",rangeAlphaStatic)
 rangeAlphaStaticInfantry1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", rangeAlphaStaticInfantry, function() spawnTargets( GAZ66_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeAlphaStaticInfantry2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", rangeAlphaStaticInfantry, function() spawnTargets( Ural_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeAlphaStaticInfantry3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", rangeAlphaStaticInfantry, function() spawnTargets( Inf_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
-- Clear the Range
 rangeAlphaClear = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Range", rangeAlpha, function() clearRange( rangeAlphaZone, rangeAlphaSpawned ) end )

-- Range Bravo
 rangeBravoDiff = MENU_COALITION:New(coalition.side.BLUE, "Range Bravo Spawn Difficulty", rangeBravo)
 rangeBravoDiff1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Average", rangeBravoDiff, function()  rangeBravoDifficulty = "Average"  messageText = "Range Bravo Difficulty set to: " .. rangeBravoDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeBravoDiff2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Good", rangeBravoDiff, function()  rangeBravoDifficulty = "Good"  messageText = "Range Bravo Difficulty set to: " .. rangeBravoDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeBravoDiff3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "High", rangeBravoDiff, function()  rangeBravoDifficulty = "High"  messageText = "Range Bravo Difficulty set to: " .. rangeBravoDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeBravoDiff4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Excellent", rangeBravoDiff, function()  rangeBravoDifficulty = "Excellent"  messageText = "Range Bravo Difficulty set to: " .. rangeBravoDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeBravoDiff5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Random", rangeBravoDiff, function()  rangeBravoDifficulty = "Random"  messageText = "Range Bravo Difficulty set to: " .. rangeBravoDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeBravoDiff6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Current Difficulty", rangeBravoDiff, function()  messageText = "Range Bravo Difficulty set to: " .. rangeBravoDifficulty MESSAGE:New(messageText, 15):ToAll() end )

-- Range Bravo Random
 rangeBravoRandom = MENU_COALITION:New(coalition.side.BLUE, "Randomized",rangeBravo)
 rangeBravoRandomSAM = MENU_COALITION:New(coalition.side.BLUE, "SAM Targets",rangeBravoRandom)
 rangeBravoRandomSAM1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", rangeBravoRandomSAM, function() spawnTargets( SA2_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, true ) end )
 rangeBravoRandomSAM2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", rangeBravoRandomSAM, function() spawnTargets( SA11_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, true ) end )
 rangeBravoRandomSAM3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", rangeBravoRandomSAM, function() spawnTargets( SA6_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, true ) end )
 rangeBravoRandomSAM4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", rangeBravoRandomSAM, function() spawnTargets( SA10_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeBravoRandomSAM5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", rangeBravoRandomSAM, function() spawnTargets( SA18_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeBravoRandomSAM6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", rangeBravoRandomSAM, function() spawnTargets( SAM_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )

-- Armor
 rangeBravoRandomArmor = MENU_COALITION:New(coalition.side.BLUE, "Armor Targets",rangeBravoRandom)
 rangeBravoRandomArmor1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", rangeBravoRandomArmor, function() spawnTargets( BTR80_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, true ) end )
 rangeBravoRandomArmor2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", rangeBravoRandomArmor, function() spawnTargets( T90_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, true ) end )
 rangeBravoRandomArmor3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", rangeBravoRandomArmor, function() spawnTargets( T72_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, true ) end )
	
-- Infantry/Trucks
 rangeBravoRandomInfantry = MENU_COALITION:New(coalition.side.BLUE, "Infantry/Truck Targets",rangeBravoRandom)
 rangeBravoRandomInfantry1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", rangeBravoRandomInfantry, function() spawnTargets( GAZ66_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, true ) end )
 rangeBravoRandomInfantry2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", rangeBravoRandomInfantry, function() spawnTargets( Ural_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, true ) end )
 rangeBravoRandomInfantry3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", rangeBravoRandomInfantry, function() spawnTargets( Inf_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, true ) end )
	
-- Range Bravo Static
 rangeBravoStatic = MENU_COALITION:New(coalition.side.BLUE, "Static",rangeBravo)
 rangeBravoStaticSAM = MENU_COALITION:New(coalition.side.BLUE, "SAM Targets",rangeBravoStatic)
 rangeBravoStaticSAM1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", rangeBravoStaticSAM, function() spawnTargets( SA2_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, false ) end )
 rangeBravoStaticSAM2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", rangeBravoStaticSAM, function() spawnTargets( SA11_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, false ) end )
 rangeBravoStaticSAM3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", rangeBravoStaticSAM, function() spawnTargets( SA6_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, false ) end )
 rangeBravoRandomSAM4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", rangeBravoStaticSAM, function() spawnTargets( SA10_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeBravoRandomSAM5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", rangeBravoStaticSAM, function() spawnTargets( SA18_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeBravoRandomSAM6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", rangeBravoStaticSAM, function() spawnTargets( SAM_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )

-- Armor
 rangeBravoStaticArmor = MENU_COALITION:New(coalition.side.BLUE, "Armor Targets",rangeBravoStatic)
 rangeBravoStaticArmor1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", rangeBravoStaticArmor, function() spawnTargets( BTR80_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, false ) end )
 rangeBravoStaticArmor2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", rangeBravoStaticArmor, function() spawnTargets( T90_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, false ) end )
 rangeBravoStaticArmor3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", rangeBravoStaticArmor, function() spawnTargets( T72_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, false ) end )
	
-- Infantry/Trucks
 rangeBravoStaticInfantry = MENU_COALITION:New(coalition.side.BLUE, "Infantry/Truck Targets",rangeBravoStatic)
 rangeBravoStaticInfantry1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", rangeBravoStaticInfantry, function() spawnTargets( GAZ66_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, false ) end )
 rangeBravoStaticInfantry2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", rangeBravoStaticInfantry, function() spawnTargets( Ural_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, false ) end )
 rangeBravoStaticInfantry3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", rangeBravoStaticInfantry, function() spawnTargets( Inf_Spawn, rangeBravoZone, rangeBravoDifficulty, 1, rangeBravoSpawned, false ) end )
-- Clear the Range
 rangeBravoClear = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Range", rangeBravo, function() clearRange( rangeBravoZone, rangeBravoSpawned ) end )

-- Range Charlie
 rangeCharlieDiff = MENU_COALITION:New(coalition.side.BLUE, "Range Charlie Spawn Difficulty", rangeCharlie)
 rangeCharlieDiff1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Average", rangeCharlieDiff, function()  rangeCharlieDifficulty = "Average"  messageText = "Range Charlie Difficulty set to: " .. rangeCharlieDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeCharlieDiff2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Good", rangeCharlieDiff, function()  rangeCharlieDifficulty = "Good"  messageText = "Range Charlie Difficulty set to: " .. rangeCharlieDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeCharlieDiff3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "High", rangeCharlieDiff, function()  rangeCharlieDifficulty = "High"  messageText = "Range Charlie Difficulty set to: " .. rangeCharlieDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeCharlieDiff4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Excellent", rangeCharlieDiff, function()  rangeCharlieDifficulty = "Excellent"  messageText = "Range Charlie Difficulty set to: " .. rangeCharlieDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeCharlieDiff5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Random", rangeCharlieDiff, function()  rangeCharlieDifficulty = "Random"  messageText = "Range Charlie Difficulty set to: " .. rangeCharlieDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeCharlieDiff6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Current Difficulty", rangeCharlieDiff, function()  messageText = "Range Charlie Difficulty set to: " .. rangeCharlieDifficulty MESSAGE:New(messageText, 15):ToAll() end )

-- Range Charlie Random
 rangeCharlieRandom = MENU_COALITION:New(coalition.side.BLUE, "Randomized",rangeCharlie)
 rangeCharlieRandomSAM = MENU_COALITION:New(coalition.side.BLUE, "SAM Targets",rangeCharlieRandom)
 rangeCharlieRandomSAM1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", rangeCharlieRandomSAM, function() spawnTargets( SA2_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, true ) end )
 rangeCharlieRandomSAM2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", rangeCharlieRandomSAM, function() spawnTargets( SA11_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, true ) end )
 rangeCharlieRandomSAM3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", rangeCharlieRandomSAM, function() spawnTargets( SA6_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, true ) end )
 rangeCharlieRandomSAM4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", rangeCharlieRandomSAM, function() spawnTargets( SA10_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeCharlieRandomSAM5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", rangeCharlieRandomSAM, function() spawnTargets( SA18_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeCharlieRandomSAM6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", rangeCharlieRandomSAM, function() spawnTargets( SAM_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )

-- Armor
 rangeCharlieRandomArmor = MENU_COALITION:New(coalition.side.BLUE, "Armor Targets",rangeCharlieRandom)
 rangeCharlieRandomArmor1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", rangeCharlieRandomArmor, function() spawnTargets( BTR80_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, true ) end )
 rangeCharlieRandomArmor2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", rangeCharlieRandomArmor, function() spawnTargets( T90_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, true ) end )
 rangeCharlieRandomArmor3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", rangeCharlieRandomArmor, function() spawnTargets( T72_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, true ) end )
	
-- Infantry/Trucks
 rangeCharlieRandomInfantry = MENU_COALITION:New(coalition.side.BLUE, "Infantry/Truck Targets",rangeCharlieRandom)
 rangeCharlieRandomInfantry1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", rangeCharlieRandomInfantry, function() spawnTargets( GAZ66_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, true ) end )
 rangeCharlieRandomInfantry2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", rangeCharlieRandomInfantry, function() spawnTargets( Ural_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, true ) end )
 rangeCharlieRandomInfantry3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", rangeCharlieRandomInfantry, function() spawnTargets( Inf_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, true ) end )
	
-- Range Charlie Static
 rangeCharlieStatic = MENU_COALITION:New(coalition.side.BLUE, "Static",rangeCharlie)
 rangeCharlieStaticSAM = MENU_COALITION:New(coalition.side.BLUE, "SAM Targets",rangeCharlieStatic)
 rangeCharlieStaticSAM1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", rangeCharlieStaticSAM, function() spawnTargets( SA2_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, false ) end )
 rangeCharlieStaticSAM2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", rangeCharlieStaticSAM, function() spawnTargets( SA11_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, false ) end )
 rangeCharlieStaticSAM3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", rangeCharlieStaticSAM, function() spawnTargets( SA6_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, false ) end )
 rangeCharlieRandomSAM4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", rangeCharlieStaticSAM, function() spawnTargets( SA10_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeCharlieRandomSAM5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", rangeCharlieStaticSAM, function() spawnTargets( SA18_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeCharlieRandomSAM6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", rangeCharlieStaticSAM, function() spawnTargets( SAM_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )

-- Armor
 rangeCharlieStaticArmor = MENU_COALITION:New(coalition.side.BLUE, "Armor Targets",rangeCharlieStatic)
 rangeCharlieStaticArmor1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", rangeCharlieStaticArmor, function() spawnTargets( BTR80_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, false ) end )
 rangeCharlieStaticArmor2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", rangeCharlieStaticArmor, function() spawnTargets( T90_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, false ) end )
 rangeCharlieStaticArmor3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", rangeCharlieStaticArmor, function() spawnTargets( T72_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, false ) end )
	
-- Infantry/Trucks
 rangeCharlieStaticInfantry = MENU_COALITION:New(coalition.side.BLUE, "Infantry/Truck Targets",rangeCharlieStatic)
 rangeCharlieStaticInfantry1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", rangeCharlieStaticInfantry, function() spawnTargets( GAZ66_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, false ) end )
 rangeCharlieStaticInfantry2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", rangeCharlieStaticInfantry, function() spawnTargets( Ural_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, false ) end )
 rangeCharlieStaticInfantry3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", rangeCharlieStaticInfantry, function() spawnTargets( Inf_Spawn, rangeCharlieZone, rangeCharlieDifficulty, 1, rangeCharlieSpawned, false ) end )
-- Clear the Range
 rangeCharlieClear = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Range", rangeCharlie, function() clearRange( rangeCharlieZone, rangeCharlieSpawned ) end )

-- Range Delta
 rangeDeltaDiff = MENU_COALITION:New(coalition.side.BLUE, "Range Delta Spawn Difficulty", rangeDelta)
 rangeDeltaDiff1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Average", rangeDeltaDiff, function()  rangeDeltaDifficulty = "Average"  messageText = "Range Delta Difficulty set to: " .. rangeDeltaDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeDeltaDiff2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Good", rangeDeltaDiff, function()  rangeDeltaDifficulty = "Good"  messageText = "Range Delta Difficulty set to: " .. rangeDeltaDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeDeltaDiff3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "High", rangeDeltaDiff, function()  rangeDeltaDifficulty = "High"  messageText = "Range Delta Difficulty set to: " .. rangeDeltaDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeDeltaDiff4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Excellent", rangeDeltaDiff, function()  rangeDeltaDifficulty = "Excellent"  messageText = "Range Delta Difficulty set to: " .. rangeDeltaDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeDeltaDiff5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Random", rangeDeltaDiff, function()  rangeDeltaDifficulty = "Random"  messageText = "Range Delta Difficulty set to: " .. rangeDeltaDifficulty MESSAGE:New(messageText, 15):ToAll() end )
 rangeDeltaDiff6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Current Difficulty", rangeDeltaDiff, function()  messageText = "Range Delta Difficulty set to: " .. rangeDeltaDifficulty MESSAGE:New(messageText, 15):ToAll() end )

-- Range Delta Random
 rangeDeltaRandom = MENU_COALITION:New(coalition.side.BLUE, "Randomized",rangeDelta)
 rangeDeltaRandomSAM = MENU_COALITION:New(coalition.side.BLUE, "SAM Targets",rangeDeltaRandom)
 rangeDeltaRandomSAM1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", rangeDeltaRandomSAM, function() spawnTargets( SA2_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, true ) end )
 rangeDeltaRandomSAM2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", rangeDeltaRandomSAM, function() spawnTargets( SA11_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, true ) end )
 rangeDeltaRandomSAM3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", rangeDeltaRandomSAM, function() spawnTargets( SA6_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, true ) end )
 rangeDeltaRandomSAM4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", rangeDeltaRandomSAM, function() spawnTargets( SA10_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeDeltaRandomSAM5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", rangeDeltaRandomSAM, function() spawnTargets( SA18_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )
 rangeDeltaRandomSAM6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", rangeDeltaRandomSAM, function() spawnTargets( SAM_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, true ) end )

-- Armor
 rangeDeltaRandomArmor = MENU_COALITION:New(coalition.side.BLUE, "Armor Targets",rangeDeltaRandom)
 rangeDeltaRandomArmor1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", rangeDeltaRandomArmor, function() spawnTargets( BTR80_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, true ) end )
 rangeDeltaRandomArmor2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", rangeDeltaRandomArmor, function() spawnTargets( T90_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, true ) end )
 rangeDeltaRandomArmor3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", rangeDeltaRandomArmor, function() spawnTargets( T72_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, true ) end )
	
-- Infantry/Trucks
 rangeDeltaRandomInfantry = MENU_COALITION:New(coalition.side.BLUE, "Infantry/Truck Targets",rangeDeltaRandom)
 rangeDeltaRandomInfantry1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", rangeDeltaRandomInfantry, function() spawnTargets( GAZ66_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, true ) end )
 rangeDeltaRandomInfantry2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", rangeDeltaRandomInfantry, function() spawnTargets( Ural_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, true ) end )
 rangeDeltaRandomInfantry3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", rangeDeltaRandomInfantry, function() spawnTargets( Inf_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, true ) end )
	
-- Range Delta Static
 rangeDeltaStatic = MENU_COALITION:New(coalition.side.BLUE, "Static",rangeDelta)
 rangeDeltaStaticSAM = MENU_COALITION:New(coalition.side.BLUE, "SAM Targets",rangeDeltaStatic)
 rangeDeltaStaticSAM1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-2", rangeDeltaStaticSAM, function() spawnTargets( SA2_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, false ) end )
 rangeDeltaStaticSAM2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-11", rangeDeltaStaticSAM, function() spawnTargets( SA11_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, false ) end )
 rangeDeltaStaticSAM3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-6", rangeDeltaStaticSAM, function() spawnTargets( SA6_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, false ) end )
 rangeDeltaRandomSAM4 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-10", rangeDeltaStaticSAM, function() spawnTargets( SA10_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeDeltaRandomSAM5 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "SA-18", rangeDeltaStaticSAM, function() spawnTargets( SA18_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )
 rangeDeltaRandomSAM6 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Integrated SAM", rangeDeltaStaticSAM, function() spawnTargets( SAM_Spawn, rangeAlphaZone, rangeAlphaDifficulty, 1, rangeAlphaSpawned, false ) end )

-- Armor
 rangeDeltaStaticArmor = MENU_COALITION:New(coalition.side.BLUE, "Armor Targets",rangeDeltaStatic)
 rangeDeltaStaticArmor1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "BTR-80", rangeDeltaStaticArmor, function() spawnTargets( BTR80_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, false ) end )
 rangeDeltaStaticArmor2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-90", rangeDeltaStaticArmor, function() spawnTargets( T90_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, false ) end )
 rangeDeltaStaticArmor3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "T-72", rangeDeltaStaticArmor, function() spawnTargets( T72_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, false ) end )
	
-- Infantry/Trucks
 rangeDeltaStaticInfantry = MENU_COALITION:New(coalition.side.BLUE, "Infantry/Truck Targets",rangeDeltaStatic)
 rangeDeltaStaticInfantry1 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "GAZ-66", rangeDeltaStaticInfantry, function() spawnTargets( GAZ66_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, false ) end )
 rangeDeltaStaticInfantry2 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Ural", rangeDeltaStaticInfantry, function() spawnTargets( Ural_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, false ) end )
 rangeDeltaStaticInfantry3 = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Infantry", rangeDeltaStaticInfantry, function() spawnTargets( Inf_Spawn, rangeDeltaZone, rangeDeltaDifficulty, 1, rangeDeltaSpawned, false ) end )
-- Clear the Range
 rangeDeltaClear = MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Range", rangeDelta, function() clearRange( rangeDeltaZone, rangeDeltaSpawned ) end )

Texaco.spawn = TexacoTemplate:Spawn()
Shell.spawn = ShellTemplate:Spawn()
BlueAWACS.spawn = BlueAWACSTemplate:Spawn()
RedAWACS.spawn = RedAWACSTemplate:Spawn()

MESSAGE:New( "Loaded Mission Successfully.", 35, "INFO" ):ToAll()
