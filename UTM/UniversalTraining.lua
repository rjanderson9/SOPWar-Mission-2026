--[[
Universal Training Mission
By
Robert Anderson
]]--
ranges = SET_ZONE:New()
    :FilterPrefixes("utm-")
    :FilterStart()
mapFontSize = 25
zones = {}
templates = {}
diffs = {
	"Average",
	"Good",
	"High",
	"Excellent",
	"Random"
}
typeString = {
	"gnd",	-- Index 1, Ground Target/Spawn Zone
	"air",	-- Index 2, Air Target/Spawn Zone
	"bdg",	-- Index 3, Building Target/Spawn Zone
	"sup",	-- Index 4, Support Aircraft, get despawn and respawn menu options.
}
zoneTypeColors = {
	{1,0,0},
	{0,1,0},
	{0,0,1},
	{1,1,0},
}
spawnTracker = {}
function spawnTracker.new ( template, zone, rand, diff )
	template:InitSkill(diff)
	return {
		Group = template:SpawnInZone( zone, rand ),
		Zone = zone
	}
end
buildingTracker = {}
function buildingTracker.new ( template, zone )
	return {
		Group = template:SpawnFromZone( zone, 0, template.GetName() .. string.format("%03d",#buildingTracker+1) ),
		Zone = zone
	}
end
function zones.new ( Zone, Name, ztype )
	return {
		name = Name,
		zone = Zone,
		zType = ztype,
		template,
		tType,
		diff = diffs[1],
		qty = 1,
		rand = true
	}
end
function templates.new ( group, name, tType )
	return {
		name = name,
		tType = tType,
		group = group,
		tracker,
	}
end
function ProcessZone(zone)
    zoneName = string.sub( zone:GetName(), 9 )
    zoneCoord = zone:GetCoordinate()
	zoneRadius = zone:GetRadius()
	zoneTypeStr = string.sub( zone:GetName(), 5, 7 )
	zoneType = 0
	tZone = ZONE:New( zone:GetName() )
	for index, value in ipairs(typeString) do
		if value == zoneTypeStr then
			zoneType = index
			break
		end
	end
	if zoneType == 0 then return end
	if zoneType == 1 or zoneType == 2 then
		zoneCoord:CircleToAll( zoneRadius, -1, { zoneTypeColors[zoneType][1], zoneTypeColors[zoneType][2], zoneTypeColors[zoneType][3] }, 1, { zoneTypeColors[zoneType][1], zoneTypeColors[zoneType][2], zoneTypeColors[zoneType][3] }, 0, 1, true, zoneName )
		zoneCoord:TextToAll( zoneName, -1, { zoneTypeColors[zoneType][1], zoneTypeColors[zoneType][2], zoneTypeColors[zoneType][3] }, 1, { zoneTypeColors[zoneType][1], zoneTypeColors[zoneType][2], zoneTypeColors[zoneType][3] }, 0, mapFontSize, true )
	end
	table.insert( zones, zones.new( tZone, zoneName, zoneType ) )
	BASE:I("Found zone: " .. tostring(zoneName))
end
ranges:ForEachZone(ProcessZone)
tImport = SET_GROUP:New(DATABASE:New())
	:FilterPrefixes( "utm-" )
	:FilterOnce()
function ProcessTemplate(template)
	tName = string.sub( template:GetName(), 9 )
	tTypeStr = string.sub( template:GetName(), 5, 7 )
	tType = 0
	for index, value in ipairs(typeString) do
		if value == tTypeStr then
			tType = index
			break
		end
	end	
	group = SPAWN:New( template:GetName() )
	if tType == 0 then return end
	table.insert( templates, templates.new( group, tName, tType ) )
	BASE:I( "Found Template: " .. tName .. " Type: " .. typeString[tType] )
end
tImport:ForEachGroup(ProcessTemplate)
function despawnSupport( unit )
	if unit.tracker then
		if unit.tracker:IsAlive() then
			unit.tracker:Destroy()
		end
	end
	local messageText = unit.name .. " despawned."
	MESSAGE:New(messageText, 15):ToAll()
end
function respawnSupport( unit )
	if unit.tracker then
		if unit.tracker:IsAlive() then
			unit.tracker:Destroy()
		end
	end
	unit.tracker = unit.group:Spawn()
	local messageText = unit.name .. " respawned."
	MESSAGE:New(messageText, 15):ToAll()
end
function spawnTargets( zone )		
	if zone.tType == 3 then
		for i=1, zone.qty do
			table.insert( buildingTracker, buildingTracker.new( zone.template, zone.zone ) )
		end
	else
		for i=1, zone.qty do
			table.insert( spawnTracker, spawnTracker.new( zone.template, zone.zone, zone.rand, zone.diff ) )
		end
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
	for i = #buildingTracker, 1, -1 do
		if buildingTracker[i].Zone == zone.zone then
			if buildingTracker[i].Group:IsAlive() then
				buildingTracker[i].Group:Destroy()
			end
			table.remove( buildingTracker, i )
			local messageText = "Previous targets despawned."
			MESSAGE:New(messageText, 15):ToAll()
		end
	end
	local prefix = units > 0 and "Previous Units Destroyed at " or "No Units to be Destroyed at "
	MESSAGE:New(prefix .. zone.zone:GetName(), 15):ToAll()
end
MainMenu = {}
SubMenus = {}
if zones then
	for i=1, #zones, 1 do
		MainMenu[i] = MENU_COALITION:New(coalition.side.BLUE, zones[i].name)
		SubMenus[i] = {
			MENU_COALITION:New(coalition.side.BLUE, "Spawn Quantity", MainMenu[i]),
			MENU_COALITION:New(coalition.side.BLUE, "Unit Spawn Difficulty", MainMenu[i]),
			MENU_COALITION:New(coalition.side.BLUE, "Randomize Spawn", MainMenu[i]),
			}
		for m=1, 5, 1 do
			MENU_COALITION_COMMAND:New(coalition.side.BLUE, m, SubMenus[i][1], function() zones[i].qty = m end)
		end
		for n=1, #diffs, 1 do
			MENU_COALITION_COMMAND:New(coalition.side.BLUE, diffs[n], SubMenus[i][2], function() zones[i].diff = diffs[n] end)
		end
		k = 1
		l = 1
		SubMenus[i][4] = { MENU_COALITION:New(coalition.side.BLUE, "Unit Type", MainMenu[i]), }
		for j=1, #templates, 1 do
			if templates[j].tType == zones[i].zType or ( templates[j].tType == typeString[3] and zones[i].zType == typeString[1] ) then
				MENU_COALITION_COMMAND:New(coalition.side.BLUE, templates[j].name, SubMenus[i][4][l], function() zones[i].template = templates[j].group zones[i].tType = templates[j].tType end )
				k = k + 1
			end
			if k>8 then
				SubMenus[i][4][l+1]=MENU_COALITION:New(coalition.side.BLUE, "More",SubMenus[i][4][l])
				k=1
				l = l + 1
			end	
		end
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Spawn Range Targets", MainMenu[i], function() spawnTargets( zones[i] ) end )
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Clear Range", MainMenu[i], function() clearRange( zones[i] ) end )
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Randomized", SubMenus[i][3], function() zones[i].rand = true end )
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Static", SubMenus[i][3], function() zones[i].rand = false end )
	end
end	
Support = false
for i=1, #templates, 1 do
	if templates[i].tType == 4 then
		if not Support then
			MainMenu[#MainMenu+1] = MENU_COALITION:New(coalition.side.BLUE, "Support Aircraft")
		end
		SubMenus[#SubMenus+1] = MENU_COALITION:New(coalition.side.BLUE, templates[i].name, MainMenu[#MainMenu])
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Respawn", SubMenus[#SubMenus], function() respawnSupport( templates[i] ) end )
		MENU_COALITION_COMMAND:New(coalition.side.BLUE, "Despawn", SubMenus[#SubMenus], function() despawnSupport( templates[i] ) end )
	end
end
MESSAGE:New("Mission Load Successful", 15):ToAll()
