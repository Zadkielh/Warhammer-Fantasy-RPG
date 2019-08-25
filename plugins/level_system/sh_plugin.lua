PLUGIN.name = "Level System"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = "Level System that's needed for the schema."

if (!nut.char) then include("sh_character.lua") end
nut.util.includeDir("libs")

function PLUGIN:OnNPCKilled(npc, attacker, inflictor)
	if IsValid(npc) and IsValid(attacker) then
		local entID = npc:EntIndex()
		if !(NPC_STATS[entID]) then return end
		if attacker:IsPlayer() then
			local class = npc:GetClass()
			local char = attacker:getChar()
			local DefaultXP = false
			local entID = npc:EntIndex()
			local npcStats = NPC_STATS[entID]

			for k, v in pairs(NPC_XP) do
				if class == v.class then
					local xp = v.value + (v.value * (v.xpmulti / 200 * NPC_STATS[entID].Level))
					netstream.Start(client, "NpcDieXP", attacker, xp, npc)
					char:updateXP(xp)
					DefaultXP = false	
					break 
				else
					DefaultXP = true
				end
			end

			if (DefaultXP and npcStats) then
				char:updateXP(0.5 * npcStats.Level)
			end
		
		elseif attacker:GetOwner():IsPlayer() then

			local class = npc:GetClass()
			local char = attacker:GetOwner():getChar()
			local DefaultXP = false
			local entID = npc:EntIndex()
			local npcStats = NPC_STATS[entID]

			for k, v in pairs(NPC_XP) do
				if class == v.class then
					local xp = v.value + (v.value * (v.xpmulti / 200 * NPC_STATS[entID].Level))
					netstream.Start(client, "NpcDieXP", attacker, xp, npc)
					char:updateXP(xp)
					DefaultXP = false	
					break 
				else
					DefaultXP = true
				end
			end

			if (DefaultXP) then
				char:updateXP(0.5 * NPC_STATS[entID].Level)
			end
		end
	end
end

hook.Add("EntityTakeDamage", "sharedXpOnNpcDamaged", function(Entity, dmg)
	if dmg:GetAttacker():IsPlayer() then
		local xp = math.min(dmg:GetDamage() / 2000, Entity:Health() / 2000)
		if (dmg:GetAttacker():getChar()) then
			dmg:GetAttacker():getChar():updateXP(xp)
		end
	elseif dmg:GetAttacker():GetOwner():IsPlayer() then
		local xp = math.min(dmg:GetDamage() / 2000, Entity:Health() / 2000)
		if (dmg:GetAttacker():GetOwner():getChar()) then
			dmg:GetAttacker():GetOwner():getChar():updateXP(xp)
		end
	end

	local attacker = dmg:GetAttacker()
	local damage = dmg:GetDamage()
	local entID = attacker:EntIndex()
	if (entID) then
		for k, v in pairs(NPC_XP) do
			if attacker:GetClass() == v.class then
				
				if !(NPC_STATS[entID].Level) then
					NPC_STATS[entID].Level = v.maxlevel/2
				end
				damage = damage + (damage / 100 * NPC_STATS[entID].Level * v.damagemulti)
				dmg:SetDamage(damage)

			end
		end
	end
	
    
end)

do
	if (SERVER)	then
	util.AddNetworkString( "levelBroadcast" )
	util.AddNetworkString( "levelRequestAllLevels" )
	util.AddNetworkString( "levelSendAllLevels" )

		netstream.Hook("UpdateAttribByStatPoint", function(client, data)
			local character = client:getChar()
			local xp = character:getXP()
			local StatPoints = character:getStatPoints()

			if (character) then
				if (data.attrib) and !(character:getStatPoints() <= 0) then
					character:updateAttrib(data.attrib, 1)
					character:updateStatPoints(-1)
					client:notifyLocalized("You gained 1 point in ".. tostring(data.attrib))
				end
			end
		end)
	
	local charMeta = nut.meta.character

		net.Receive( "levelRequestAllLevels", function(len, ply)
		    print("AllLevels.Received")
			tableCharacters = {}
			for k, v in pairs(player.GetHumans()) do
				if (v:getChar()) then
					local id = v:getChar():getID()
					local level = v:getChar():getLevel()
					
					tableCharacters[k] = {}
					tableCharacters[k].id = id
					tableCharacters[k].level = level
				end
			end
            
			net.Start("levelSendAllLevels")
			    print("AllLevels.Sending")
				net.WriteTable(tableCharacters)
			net.Send(ply)
		end)

		netstream.Hook("levelup", function(client, data)
			local character = nut.char.loaded[data.char.id]
			local xp = character:getXP()
			local level = character:getLevel()
			if (character) then
				if data.xp >= character:getMaxXP(level) then
					character:updateLevel(1)
					character:updateStatPoints(1)
					character:addSkillPoints(1)
					client:notifyLocalized("Level Up! New level is ".. character:getLevel())
					ParticleEffectAttach("fantasy_level_up", PATTACH_ABSORIGIN, character:getPlayer(), 1)
				end
			end
		end)

		function charMeta:updateLevel(value)
				local client = self:getPlayer()
				local level = math.min((self:getLevel() or 1) + value, 100)
				if (IsValid(client)) then
					self:setData("level", level)
					net.Start("levelBroadcast")
						print("Sending.levelBroadcast")
						net.WriteInt(level, 32)
						net.WriteInt(self:getID(), 32)
					net.Broadcast()
				end
		end

		function charMeta:setLevel(value)
				local client = self:getPlayer()
				local level = value

				if (IsValid(client)) then
					self:setData("level", level)
					net.Start("levelBroadcast")
						print("Sending.levelBroadcast")
						print(level)
						net.WriteInt(level, 32)
						net.WriteInt(self:getID(), 32)
					net.Broadcast()
				end
		end

		function charMeta:updateXP(value)
				local client = self:getPlayer()

				xp = math.min((self:getXP() or 0) + value, 999999)

				if (IsValid(client)) then
					self:setData("xp", xp)
					netstream.Start(client, "xp", self:getID(), xp)
				end
		end

		function charMeta:setXP(value)
				local client = self:getPlayer()

				xp = value

				if (IsValid(client)) then
					self:setData("xp", xp)
					netstream.Start(client, "xp", self:getID(), xp)
				end
		end

		function charMeta:updateStatPoints(value)
				local client = self:getPlayer()
				local StatPoints = (self:getStatPoints() or 0) + value
				if (IsValid(client)) then
					self:setData("StatPoints", StatPoints)
					netstream.Start(client, "StatPoints", self:getID(), StatPoints)
				end
		end

		function charMeta:setStatPoints(value)
				local client = self:getPlayer()
				local StatPoints = value

				if (IsValid(client)) then
					print("Setting Stat Points")
					self:setData("StatPoints", StatPoints)
					netstream.Start(client, "StatPoints", self:getID(), StatPoints)
				end
		end
	else
		net.Receive("levelBroadcast", function(len, client)
			print("Receiving.levelBroadcast")
			local level = net.ReadInt(32)
			local id = net.ReadInt(32)
			local character = nut.char.loaded[id]
			
			if (character) then
				print("levelBroadcast.ValidChar")
				character.level = level
			end

			print("levelBroadcast " .. character.level)
		end
		)

		net.Receive("levelSendAllLevels", function(len, client)
			print("Receiving.levelSendAllLevels")
			local characters = net.ReadTable()
			for k, v in pairs(characters) do
				local character = nut.char.loaded[v.id]
				local level = v.level
				if (character) then
					character.level = level
				end
			end
		end
		)
		
		netstream.Hook("xp", function(id, value)
			local character = nut.char.loaded[id]
			local xp = character:getXP()
			local level = character:getLevel()

			if (character) then
				xp = value
				if tonumber(xp) >= character:getMaxXP(level) then
					netstream.Start("levelup", {
						char = character,
						xp = xp
					})
				end
			end
		end)

		netstream.Hook("StatPoints", function(id, value)
			local character = nut.char.loaded[id]
			local StatPoints = character:getStatPoints()
			if (character) then
					StatPoints = value
			end
		end)
	end

	local charMeta = nut.meta.character

	function charMeta:getXP()
		local xp = self:getData("xp") or 1
	
		return xp
	end

	function charMeta:getMaxXP(level)
		local level = level
		local MaxXP = 100
		level = tonumber(level)
		if level < 10 then
			MaxXP = 40*(level * level)
		elseif level >= 10 then
			MaxXP = 0.1*(level * level * level) + 40*(level * level)
		elseif level >= 21 then
				MaxXP = 2*(level * level * level) + 40*(level * level) + 396*level
		end

		return MaxXP
	end
	
	function charMeta:getLevel()
		local level = self:getData("level") or 1
		return level
	end

	function charMeta:getStatPoints()
		local StatPoints = self:getData("StatPoints") or 0
	
		return StatPoints
	end
end

local levelTextTable = {
	[1] = {"Level ", Color(0, 255, 0)},
	[2] = {"Level ", Color(250, 200, 0)},
	[3] = {"Level ", Color(200, 0, 0)},
    [4] = {"Level ", Color(255, 0, 100)},
    [5] = {"Level ", Color(255, 0, 200)},
    [6] = {"Level ", Color(155, 0, 155)},
    [7] = {"Level ", Color(255, 100, 15)},
    [8] = {"Level ", Color(100, 200, 255)},
    [9] = {"Level ", Color(50, 255, 0)},
    [10] = {"Level ", Color(100, 10, 255)},
    [11] = {"Level ", Color(0, 0, 0)},
}

function PLUGIN:GetLevelText(character)
	local id = character:getID()
	local char = nut.char.loaded[id]
	--print(char.level)
	if (char) then
    	for k, v in pairs(levelTextTable) do
    	    --print(k)
    		if (math.ceil( char.level / 10 ) == k) then
    			return v[1], v[2]
    		end
	    end
	end
end

function PLUGIN:DrawCharInfo(client, character, info)
	local levelText, levelColor = self:GetLevelText(character)
	local char = nut.char.loaded[character:getID()]
	if (char) then
    	if (levelText) then
    		info[#info + 1] = {levelText..char.level, levelColor}
    	end
    end
end

hook.Add("CharacterLoaded", "CharLoad.GetLevels", function(id)
	if (CLIENT) then
		print("AllLevels.SendingClient")
		net.Start("levelRequestAllLevels")
		net.SendToServer()
	end
end)

hook.Add("PostPlayerLoadout", "CharCreated.SetLevel", function(client)
	if IsValid(client) then

		local char = client:getChar()
		if (char:getLevel() <= 1) then
			char:setLevel(1)
			print("CharCreated.SetLevel")
		else
    		net.Start("levelBroadcast")
    			print("Sending.levelBroadcast")
    			net.WriteInt(char:getLevel(), 32)
    			net.WriteInt(char:getID(), 32)
    		net.Broadcast()
    	end
	end
end)

nut.command.add("charsetxp", {
    adminOnly = true,
    syntax = "<string name> <int xp>",
    onRun = function(client, args)
        local Target = nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		char:setXP(args[2])
		client:notifyLocalized("Xp set to " .. args[2])
    end
})

nut.command.add("charaddxp", {
    adminOnly = true,
    syntax = "<string name> <int xp>",
    onRun = function(client, args)
        local Target = nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		char:setXP(char:getXP() + args[2])
		client:notifyLocalized("You gained " .. args[2] .. "experience!")
    end
})

nut.command.add("charsetlevel", {
    adminOnly = true,
    syntax = "<string name> <int xp>",
    onRun = function(client, args)
        local Target = nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()

		
		char:setLevel(args[2])
		client:notifyLocalized("Level set to " .. args[2])
    end
})


nut.command.add("charlevelup", {
    adminOnly = true,
    syntax = "<string name> <x times>",
    onRun = function(client, args)
        local Target = nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()

		if isnumber( tonumber(args[2]) ) then
			timer.Create("levelUp"..client:SteamID(), 0.1, args[2], function()
				char:setXP(char:getMaxXP(char:getLevel()) + 1)
			end)
		else
			char:setXP(char:getMaxXP(char:getLevel()) + 1)

			netstream.Start("levelup", {
				id = id,
				xp = xp
			})	
		end

		
    end
})

nut.command.add("charsetstatpoints", {
    adminOnly = true,
    syntax = "<string name> <int xp>",
    onRun = function(client, args)
        local Target = nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()

		
		char:setStatPoints(args[2])
		client:notifyLocalized("Statpoints set to " .. args[2])
    end
})

nut.command.add("respec", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, args)
		if !client:IsSuperAdmin() then return end
        local Target = nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		local StatPoints = char:getStatPoints()

		for k,v in pairs(nut.attribs.list) do
			char:setAttrib(k, 0)
		end

		char:setStatPoints(char:getLevel() - 1)
		client:notifyLocalized(Target:Nick() .." reset.")
    end
})

nut.command.add("chargetxp", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, args)
        local Target = nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		client:ChatPrint(char:getXP())
		client:ChatPrint(char:getMaxXP(char:getLevel()))

    end
})

nut.command.add("chargetlevel", {
    adminOnly = true,
    syntax = "<string name>",
    onRun = function(client, args)
        local Target = nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
        if (SERVER) then
			print(char)
        	print(char:getData("level"))
		end
		
		client:ChatPrint(char:getData("level"))
		    
    end
})

local function saveLevel(char)
	local level = char:getLevel()
	local xp = char:getXP()

	nut.db.updateTable({
		_level = char:getLevel(),
		_xp = char:getXP(),
		_statpoints = char:getStatPoints()
	}, nil, "levels", "_charID = "..char:getID())
end

do
	if (SERVER) then
		local MYSQL_CREATE_TABLES = [[
CREATE TABLE IF NOT EXISTS `nut_levels` (
  `_charID` int(11) NOT NULL,
  `_xp` int unsigned DEFAULT NULL,
  `_level` int unsigned DEFAULT NULL,
  `_statpoints` int unsigned DEFAULT NULL,
  PRIMARY KEY (`_charID`)
);

		]]
		local SQLITE_CREATE_TABLES = [[
CREATE TABLE IF NOT EXISTS `nut_levels` (
	`_charID` INTEGER PRIMARY KEY,
    `_xp` INTEGER,
	`_level` INTEGER
	`_statpoints` INTEGER
);
		]]

		function PLUGIN:OnLoadTables()
			if (nut.db.module == "mysqloo") then
				nut.db.query(MYSQL_CREATE_TABLES)
			else
				nut.db.query(SQLITE_CREATE_TABLES)
			end
		end

		function PLUGIN:CharacterPreSave(char)
			saveLevel(char)
		end

		function PLUGIN:CharacterLoaded(id)
			local char = nut.char.loaded[id]

			/*nut.db.query("SELECT _xp, _level FROM nut_levels WHERE _charID = "..id, function(data)
					nut.db.insertTable({
						_xp = char:getXP(),
						_level = char:getLevel(),
						_charID = id,
					}, function(data)
					end, "levels")
			end)*/
		end
	end
end