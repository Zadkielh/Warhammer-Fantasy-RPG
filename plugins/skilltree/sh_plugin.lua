PLUGIN.name = "Skills"
PLUGIN.author = "Zadkiel"
PLUGIN.desc = "Faen."

nut.skills = nut.skills or {}
nut.skills.list = nut.skills.list or {}

nut.skillCategories = nut.skillCategories or {}
nut.skillCategories.list = nut.skillCategories.list or {}

nut.util.include("sv_networking.lua")
nut.util.includeDir("effects")

nut.command.add("forceskill", {
    adminOnly = true,
    syntax = "<string name> <int xp>",
    onRun = function(client, args)
        local Target = client or nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		char:OnAquireSkill(args[2])
    end
})

nut.command.add("clearskilltables", {
    adminOnly = true,
    syntax = "<string name> <int xp>",
    onRun = function(client, args)
        local Target = client or nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		char:setData("Skills", {})
    end
})

nut.command.add("chargetskills", {
    adminOnly = true,
    syntax = "<string name> <int xp>",
    onRun = function(client, args)
        local Target = client or nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		
		local skills = char:getData("Skills", {})

		for k, v in pairs(skills) do
			print(k)
		end
    end
})

	function nut.skills.loadFromDir(directory)
		for k, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
			local niceName = v:sub(4, -5)

			SKILL = nut.skills.list[niceName] or {}

				nut.util.include(directory.."/"..v)

				SKILL.name = SKILL.name or "Unknown"
				SKILL.desc = SKILL.desc or "No description available."

				nut.skills.list[niceName] = SKILL
			SKILL = nil 
		end
	end

	function nut.skillCategories.loadFromDir(directory)
		for k, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
			local niceName = v:sub(4, -5)

			CAT = nut.skillCategories.list[niceName] or {}

				nut.util.include(directory.."/"..v)

				CAT.name = CAT.name or "Unknown"
				CAT.desc = CAT.desc or "No description available."
				CAT.icon = CAT.icon or "vgui/white"

				nut.skillCategories.list[niceName] = CAT
			CAT = nil 
		end
	end

nut.skills.loadFromDir("warhammer-fantasy-rpg/plugins/skilltree/skills")
nut.skillCategories.loadFromDir("warhammer-fantasy-rpg/plugins/skilltree/categories")

local charMeta = nut.meta.character
function charMeta:getSkillPoints()
	local SP = self:getData("SkillPoints", 0)
	return SP
end

if SERVER then
	function charMeta:addSkillPoints(value)
		local SP = math.max(self:getData("SkillPoints", 0), 0)
		self:setData("SkillPoints", SP + value)

	end
end

function charMeta:canClientAquireSkill(key)
local skill = nut.skills.list[key]
local color = Color(0,200,0, 200)
local class = false

	if (self:hasSkill(key)) then
		return false 
	end

	if (skill.class) then
		for k, v in pairs(skill.class) do
			if self:getClass() == v then
				class = true
			end
        end
	else
		class = true
	end

	if (skill.SkillPointCost) then
		if self:getData("SkillPoints", 0) < skill.SkillPointCost then
			color = Color(223, 180, 127, 230)
		end
	end

	if (skill.RequiredSkills) then
		local skills = self:getData("Skills", {})
	
		for k, v in pairs(skill.RequiredSkills) do
			if !(skills[v]) then
				color = Color(50, 50, 100, 230)
			end
		end
	end

	

	if (skill.Incompatible) then
		for k,v in pairs(skill.Incompatible) do
			if self:hasSkill(v) then 
				color = Color(200, 10, 10, 230) 
			end
		end
	end

	if (skill.LevelReq) then 
		if tonumber(self:getLevel()) < skill.LevelReq then 
			color = Color(180, 11, 209, 230)
		end
	end

	if !(class) then
		color = Color(10, 10, 10, 230)
	end

	return color 
end

function charMeta:canAquireSkill(key)
	local skill = nut.skills.list[key]
	
	if (self:hasSkill(key)) then
		self:getPlayer():notify("You already know this skill.") return false 
	end
 
	if (skill.LevelReq) then 
		if tonumber(self:getLevel()) < skill.LevelReq then self:getPlayer():notify("Level Requirement not met.") return false end
	end

	if (skill.SkillPointCost) then
		if self:getData("SkillPoints", 0) < skill.SkillPointCost then self:getPlayer():notify("You require more Skill Points.") return false end
	end

	if (skill.Incompatible) then
		for k,v in pairs(skill.Incompatible) do
			if self:hasSkill(v) then self:getPlayer():notify("You have one or more incompatible skills.") return false end
		end
	end

	if (skill.RequiredSkills) then
		local skills = self:getData("Skills", {})

		for k, v in pairs(skill.RequiredSkills) do
			if !(skills[v]) then
				self:getPlayer():notify("You are missing a required skill.") return false
			end
		end
	end

	if (skill.class) then
		for k, v in pairs(skill.class) do
			if self:getClass() == v then
				return true 
			end
        end
        self:getPlayer():notify("Wrong class.")
	    return false
	end

	return true 
end

function charMeta:hasSkill(key)
	
	local skill = nut.skills.list[key]
	local skills = self:getData("Skills", {})
	--PrintTable(skills)
	if (skills) then
		for k, v in pairs(skills) do
			--print(k == key)
			if k == key then return true end
		end
	end
		
	return false
end

function charMeta:getSkills()
	
	local skills = self:getData("Skills", {})
		
	return skills
end

function charMeta:OnAquireSkill(key)
	local skill = nut.skills.list[key]
	local skills = self:getData("Skills", {})
	if !self:canAquireSkill(key) then print("errorSkillAquired") return false end
	if !(table.HasValue( skills, skill)) then
	
		skills[key] = true

		self:setData("Skills", skills)
		if (skill.SkillPointCost) then
			
			local SkillPoints = self:getData("SkillPoints", 0) - skill.SkillPointCost
			self:setData("SkillPoints", SkillPoints)
			
		end
	    
	    if (skill.onAquire) then
			skill.onAquire(skill, self)
		end
	else
		print("errorSkillAquired")
	end
end


if (SERVER)	then
	netstream.Hook("AquireSkill", function(client, data)
		local character = client:getChar()
		if (character) then
			if (character:canAquireSkill(data.skill)) then
				character:OnAquireSkill(data.skill)
				client:notifyLocalized("You gained ".. tostring(data.skill))
			end
		end
	end)

	netstream.Hook("ChangeAbility", function(client, data)
		local character = client:getChar()
		if (character) then
			if (character:hasSkill(data.skill)) then
				local bool = character:ChangeAbility(data.skill)
				if (bool) then
				    client:notifyLocalized("You switched to ".. tostring(nut.skills.list[data.skill].name))
			    end
			end
		end
	end)

	netstream.Hook("AddSkillPoint", function(client, data)
		local character = client:getChar()
		if (character) then
				character:addSkillPoints(data.value)
		end
	end)
	
end
/*
hook.Add( "OnCharCreated", "SetupAbilitySlots", function(client, char)
	local AbilitySlots = {}
	
	for k, v in pairs(nut.skills.list) do
		AbilitySlots[v.slot] = true
	end
	char:setData("AbilitySlots", AbilitySlots)
end
)
*/

function charMeta:ChangeAbility(key)
	local skill = nut.skills.list[key]

	if (skill.slot) then
		local slot = skill.slot
		local AbilitySlots = self:getData("AbilitySlots", {})

		AbilitySlots[slot] = key

		self:setData("AbilitySlots", AbilitySlots)
		return true
	else
		self:getPlayer():notifyLocalized("Not an Ability")
		return false
	end
end


function charMeta:GetAbility(slot)
	local AbilitySlots = self:getData("AbilitySlots", {})

	return AbilitySlots[slot]
end

function charMeta:SelectedSkill(skill, slot)
	local AbilitySlots = self:getData("AbilitySlots", {})

	if skill == AbilitySlots[slot] then
		return AbilitySlots[slot]
	else
		return false 
	end
end

function PLUGIN:PostPlayerLoadout(client)
	
	if (client:GetNWBool( "nospamUlt" )) then
		client:SetNWBool( "nospamUlt", false )
	end

	if (client:GetNWBool( "nospamRanged" )) then
		client:SetNWBool( "nospamRanged", false )
	end

	if (client:GetNWBool( "nospamAOE" )) then
		client:SetNWBool( "nospamAOE", false )
	end

	if (client:GetNWBool( "nospamMelee" )) then
		client:SetNWBool( "nospamMelee", false )
	end

	if (client:GetNWBool( "noWeaponSwitchAbility")) then
		client:SetNWBool( "noWeaponSwitchAbility", false )
	end

	if (client:GetNWBool( "hasWeaponSteroid")) then
		client:SetNWBool("hasWeaponSteroid", false)
	end

	timer.Simple(0.1, function()
		client:getChar():CleanSummonerPool()
		client:getChar():CreateSummonerPool()
	end)
end


	
	function PLUGIN:PlayerButtonUp( ply, key )
		if !(ply:Alive()) then return end
		local options = ply:getChar():getData("OptionPreferences", {})

			if SERVER then
				
				if key == (options["ULTIMATE"] or KEY_4)then
					self:ActivateUlt(ply)
				elseif key == (options["AOE"] or KEY_3) then
					self:ActivateAOE(ply)
				elseif key == (options["MELEE"] or KEY_1)then
					self:ActivateMelee(ply)
				elseif key == (options["RANGED"] or KEY_2) then
					self:ActivateRanged(ply)
				elseif key == (options["FOLLOW"] or KEY_5) then
					local SummonerLimit = ply:getChar():GetPoolLimit()
					local SummonerPool = ply:getChar():GetSummonerPool()
					local following = nil
					for ID, _ in pairs(SummonerPool) do
						
						local entity = Entity(ID)
						
						if (following != nil) then
							if following == 0 then
								if (entity.FollowingPlayer) then
									entity:FollowPlayerReset()
								end
								entity:FollowPlayerCode("Use", ply, ply, nil)
							elseif following == 1 then
								entity:FollowPlayerReset()
							end
						else
							if (entity.IsVJBaseSNPC) and (entity.FollowingPlayer) then
								entity:FollowPlayerReset()
								following = 1
								ply:notify("Summons no longer follow you follow you")
							else
								entity:FollowPlayerCode("Use", ply, ply, nil)
								following = 0
								ply:notify("Summons now follow you")
							end
						end
					end
				elseif key == (options["COMMAND"] or KEY_6) then
					local SummonerLimit = ply:getChar():GetPoolLimit()
					local SummonerPool = ply:getChar():GetSummonerPool()
					local HitPos = ply:GetEyeTrace().HitPos
						for k, v in pairs(SummonerPool) do
							local ent = Entity(k)
							if (IsValid(ent)) then
								if (ent.FollowingPlayer) then
									ent:FollowPlayerReset()
								end
								ent:StopMoving()
								ent:SetLastPosition(HitPos)
								if (ent.IsVJBaseSNPC) and (ent.IsVJBaseSNPC_Creature or ent.IsVJBaseSNPC_Human) then
										ent:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH", function(x)
										if IsValid(ent:GetEnemy()) && ent:Visible(ent:GetEnemy()) then
											x:EngTask("TASK_FACE_ENEMY", 0) 
											x.CanShootWhenMoving = true 
											x.ConstantlyFaceEnemy = true
										end
									end)
								else
									ent:SetSchedule(SCHED_FORCED_GO_RUN)
								end
								ply:notify("Summons are moving")
							end
						end
				end

				if key == KEY_I then
					net.Start( "openGear" )
					net.Send( ply )
				end

			end
	end

if SERVER then

	function PLUGIN:ActivateUlt( ply )
			
		local char = ply:getChar()
		local skill = nut.skills.list[char:GetAbility("ULT")]
		if (skill and skill.ability) then
			skill.ability(skill, ply)

		end
		
	end

	function PLUGIN:ActivateRanged( ply )
			
		local char = ply:getChar()
		local skill = nut.skills.list[char:GetAbility("RANGED")]
		if (skill and skill.ability) then
			
			skill.ability(skill, ply)

		end
	end

	function PLUGIN:ActivateAOE( ply )
			
		local char = ply:getChar()
		local skill = nut.skills.list[char:GetAbility("AOE")]
		if (skill and skill.ability) then
			skill.ability(skill, ply)

		end
	end

	function PLUGIN:ActivateMelee( ply )
			
		local char = ply:getChar()
		local skill = nut.skills.list[char:GetAbility("MELEE")]
		if (skill and skill.ability) then
			skill.ability(skill, ply)
		end

	end
	
end

function HideWeaponSelect( ply, bind, pressed )
	local tableSkills = {["slot1"] = 1, ["slot2"] = 2, ["slot3"] = 3, ["slot4"] = 4}

	if tableSkills[bind] then
		return true
	end
	
end

if SERVER then
	util.AddNetworkString("dropPodComingDown")
	util.AddNetworkString("TransmitOptionsToServer")
end

if SERVER then
	
	net.Receive( "TransmitOptionsToServer", function(len, pl)
		local compressedTable = net.ReadData(60000)
		local JSONTable = util.Decompress(compressedTable)
		local table = util.JSONToTable(JSONTable)
		pl:getChar():setData("OptionPreferences", table)
	end)

end
if CLIENT then
	net.Receive("dropPodComingDown", function()
		local client = net.ReadEntity()
		local pos = net.ReadVector()
		local uniqueID = client:SteamID()
		hook.Add( "PostDrawTranslucentRenderables", "dropPodIncoming"..uniqueID, function( bDepth, bSkybox )

			render.SetColorMaterial()
			
			render.DrawBeam(pos, Vector(pos.x, pos.y,pos.z+5000), 5, 0, 1, Color(255,255,255))
			--render.DrawBox( pos, Angle(0,0,0), Vector(pos.x -100, pos.y -100, pos.z), Vector(pos.x +100, pos.y +100, pos.z +50000), Color( 255, 255, 255 ) )

		end )
		timer.Simple(5, function()
			hook.Remove("PostDrawTranslucentRenderables", "dropPodIncoming"..uniqueID)
		end)
	end)
end
hook.Add( "PlayerBindPress", "HideWeaponSelect", HideWeaponSelect ) 
/*


concommand.Add("DisableAbilites", function(client)

	if !(client:GetNWBool("DisableAbilites")) then
		client:SetNWBool("DisableAbilites", true)
	else
		client:SetNWBool("DisableAbilites", false)
	end

	net.Start( "disableAbilites" )
	net.SendToServer()

end)


hook.Add( "OnSpawnMenuOpen", "SpawnMenuAbilityBlock", function()
	if !( LocalPlayer():GetNWBool("DisableAbilites") ) then
		return false
	end
end )


hook.Add( "ContextMenuOpen", "CMenuAbilityBlock", function()
	if !( LocalPlayer():GetNWBool("DisableAbilites") ) then
		return false
	end
end )

if SERVER then
	net.Receive( "disableAbilites", function( len, client )
		if !(client:GetNWBool("DisableAbilites")) then
			client:SetNWBool("DisableAbilites", true)
		else
			client:SetNWBool("DisableAbilites", false)
		end
	end)
end
*/
game.AddParticles( "particles/fantasy_daemon.pcf" )
PrecacheParticleSystem( "fantasy_warcry" )
PrecacheParticleSystem( "fantasy_wind" )
PrecacheParticleSystem( "fantasy_heal" )
PrecacheParticleSystem( "fantasy_summoning_circle" )
PrecacheParticleSystem( "emperors_blessing" )



---- SUMMONING AND NECROMANCY -----------------------------------

local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")
local charMeta = nut.meta.character

nut.command.add("cleanpool", {
    adminOnly = true,
    syntax = "<string name> <int xp>",
    onRun = function(client, args)
        local Target = client or nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		char:CleanSummonerPool()
    end
})

nut.command.add("getsummonerpool", {
    adminOnly = true,
    syntax = "<string name> <int xp>",
    onRun = function(client, args)
        local Target = client or nut.command.findPlayer(client, args[1])
        if not IsValid(Target) then return end
		local char = Target:getChar()
		local client = char:getPlayer()
		char:PrintEntitiesInSummonerPool()
		if (char:IsSummonerPoolFull(1)) then
			print("Summoner Pool Full")
		else
			print("Summoner Pool Not Full")
		end
    end
})

function entityMeta:Ressurect(NPC, Owner, Cost, SummonerPop)
	timer.Simple(math.random(0.1, 1), function()
		if IsValid(self) then
			if (Owner:IsPlayer() and Owner:getChar()) then
				local SummonerLimit = Owner:getChar():GetPoolLimit()
				local SummonerPool = Owner:getChar():GetSummonerPool()
				
				if (Owner:getChar():IsSummonerPoolFull(SummonerPop)) then return false end

				local mana = Owner:getLocalVar("mana", 0)
				if mana < Cost then
					return
				end
				Owner:setLocalVar("mana", mana - Cost)

				timer.Create("RessurectRagdoll"..self:EntIndex(), 0.1, 2, function()
					ParticleEffectAttach("fantasy_green_flame", PATTACH_ABSORIGIN_FOLLOW, self, 0)
				end)
				
				local NPC = ents.Create(NPC)
				NPC:AddEntityToSummonerPool(Owner:getChar(), SummonerPop)
				NPC:SetPos(self:GetPos())
				NPC.SummonerLevel = Owner:getChar():getLevel()
				
				NPC.IsSummoned = true
				NPC:Spawn()
				
				timer.Create("FrailSummoning"..NPC:EntIndex(), 0.5, 0, function()
					if (IsValid(NPC)) then
						if NPC:Health() >= (NPC:GetMaxHealth()*0.1) then
							NPC:SetHealth(NPC:Health() - 1)
						end
					end
				end)
					
				timer.Simple(2, function()
					self:Remove()
				end)
			end
		end
	end)
end

function playerMeta:Summon(NPC, Cost, SummonerPop, Pos)
	timer.Simple(math.random(0.1, 1), function()
			if (self:getChar()) then
				local SummonerLimit = self:getChar():GetPoolLimit()
				local SummonerPool = self:getChar():GetSummonerPool()
				
				if (self:getChar():IsSummonerPoolFull(SummonerPop)) then return false end

				local mana = self:getLocalVar("mana", 0)
				if mana < Cost then
					return
				end
				self:setLocalVar("mana", mana - Cost)

				
				local NPC = ents.Create(NPC)
				NPC:AddEntityToSummonerPool(self:getChar(), SummonerPop)
				NPC:SetPos(Pos)
				NPC.SummonerLevel = self:getChar():getLevel()
				NPC.IsSummoned = true
				NPC:EmitSound( "warpgate.wav", 75, 100, 1, CHAN_AUTO)
				timer.Simple(7.5, function()
					NPC:Spawn()
					NPC:EmitSound("undead/wc3_undead"..math.random(1,9)..".wav", 80, 100, 1)
				end)

				timer.Create("Summon"..NPC:EntIndex(), 0.1, 2, function()
					ParticleEffect( "fantasy_summoning_circle", Pos, Angle(0,0,0), nil )
				end)
				
				
				timer.Create("FrailSummoning"..NPC:EntIndex(), 0.5, 0, function()
					if (IsValid(NPC)) then
						if NPC:Health() >= (NPC:GetMaxHealth()*0.1) then
							NPC:SetHealth(NPC:Health() - 1)
						end
					end
				end)
			end
	end)
end

function entityMeta:RemoveEntityFromSummonerTable(ply)
	if !(IsValid(ply)) then return end
	local entID = self:EntIndex()
	local exists = false

	local SummonerLimit = ply:getChar():GetPoolLimit()
	local SummonerPool = ply:getChar():GetSummonerPool()
	
	for k, v in pairs(SummonerPool) do
		if k != entID then continue end
		
		exists = true
	end
	
	if exists then		
		SummonerPool[entID] = nil
		
		ply:getChar():setData("SummonerPool", SummonerPool)
		--net.Start("NPC_STATS_remove_Info")
		--	net.WriteInt(entID, 16)
		--net.Broadcast()
	end
	
	return exists
end

function entityMeta:AddEntityToSummonerPool(character, SummonerPop)
	if !(self:IsNPC()) then return end
	
	if (IsValid(self) and (character)) then

		local SummonerLimit = character:GetPoolLimit()
		local SummonerPool = character:GetSummonerPool()
		local entID = self:EntIndex()
		
		SummonerPool[entID] = SummonerPop
		character:setData("SummonerPool", SummonerPool)
		self:SetOwner(character:getPlayer())

		if (self.IsVJBaseSNPC) then
			
			self.VJ_NPC_Class = {"CLASS_SUMMONER"..character:getPlayer():Nick()}
			character:getPlayer().VJ_NPC_Class = {"CLASS_SUMMONER"..character:getPlayer():Nick()}
			self:AddEntityRelationship( character:getPlayer(), D_LI, 109 )
			self.AllowPrintingInChat = false
			self:FollowPlayerCode("Use", character:getPlayer(), character:getPlayer(), nil)
		else
			self:AddEntityRelationship( character:getPlayer(), D_LI, 109 )
		end
		
	end 	
end

function charMeta:CreateSummonerPool()
	if (self) then
		self:setData("SummonerPool", {})
		self:setData("SummonerLimit", math.max(self:getLevel()/5, 1))
		print(self:getData("SummonerLimit"))
	end
end

function charMeta:CleanSummonerPool()
	local SummonerPool = self:GetSummonerPool()
		
		for k, _ in pairs(SummonerPool) do
			if (Entity(k):IsNPC() and (Entity(k):GetOwner() == self:getPlayer())) then
				local d = DamageInfo()
				d:SetDamage( Entity(k):Health() * 2 )
				d:SetAttacker( game.GetWorld() )
				d:SetDamageType( DMG_DISSOLVE )

				Entity(k):TakeDamageInfo( d )
			end
		end
		self:setData("SummonerPool", {})
end

function charMeta:PrintEntitiesInSummonerPool()
	local SummonerPool = self:getData("SummonerPool", {})
	for k, v in pairs(SummonerPool) do
		print(Entity(k))
	end
	print(table.Count(SummonerPool))
end

function charMeta:GetSummonerPool()
	local SummonerPool = self:getData("SummonerPool", {})
	return SummonerPool
end

function charMeta:GetPoolLimit()
	local SummonerLimit = self:getData("SummonerLimit", 5)
	return SummonerLimit
end

function charMeta:IsSummonerPoolFull(NewPop)
	
	local SummonerLimit = self:GetPoolLimit()
	local SummonerPool = self:GetSummonerPool()
	--print(table.Count(SummonerPool))
	--PrintTable(SummonerPool)
	local SummonerPop = 0
	for k, v in pairs(SummonerPool) do
		SummonerPop = SummonerPop + v
	end
	SummonerPop = SummonerPop + NewPop

	if SummonerPop < (SummonerLimit+1) then
		return false
	else
		return true 
	end
	/*
	if (table.Count(SummonerPool) < SummonerLimit) then
		return false
	else
		return true
	end*/
end

hook.Add("OnNPCKilled", "Summoning.CleanOnKill", function(ent, attacker, inflictor)
	if !(ent:IsNPC() or IsValid(ent)) then return end
	if ((ent:GetOwner():IsPlayer()) and ent:GetOwner():getChar()) then
		ent:RemoveEntityFromSummonerTable(ent:GetOwner())
	end
end)

hook.Add("EntityRemoved", "Summoning.CleanOnRemove", function(ent)
	if !(ent:IsNPC() or IsValid(ent)) then return end
	if ((ent:GetOwner():IsPlayer()) and ent:GetOwner():getChar()) then
		ent:RemoveEntityFromSummonerTable(ent:GetOwner())
	end
end)

---- CHAOS ASCENSIONS -----------------------------------
do
	
	local entityMeta = FindMetaTable("Entity")
	local playerMeta = FindMetaTable("Player")
	local charMeta = nut.meta.character

	function charMeta:IsKhorneFollower()

	end
end 

------ IMPORTANT HOOKS -----------------------------

hook.Add("EntityTakeDamage", "skillMods", function(Entity, dmg)

	if dmg:GetAttacker():IsPlayer() then
		
        local ply = dmg:GetAttacker()
		local char = ply:getChar()

		if (ply:GetNWBool("RavCarni")) then
			timer.Simple(0.05, function()
				local lifeSteal = char:getData("lifeSteal", 0)
				char:setData("templifeSteal", math.max(0, lifeSteal))
				ply:SetNWBool("RavCarni", false)
			end)
		end

		if (ply:GetNWBool("SigmarHammer" )) then
			timer.Simple(0.05, function()
				local naturalDamage = char:getData("naturalDamage",0)
				local faith = char:getAttrib("fth")
				local damage = naturalDamage - (faith * 2) - 100
				char:setData("tempDamage", math.max(0,naturalDamage))
				ply:SetNWBool("SigmarHammer", false)
			end)
		end

		if (ply:GetNWBool("WarriorCleave" )) then
			timer.Simple(0.05, function()
				local naturalDamage = char:getData("naturalDamage",0)
				local str = char:getAttrib("str")
				local damage = naturalDamage - (str * 2) - 100
				char:setData("tempDamage", math.max(0,naturalDamage))
				ply:SetNWBool("WarriorCleave", false)
			end)
		end

		if (ply:GetNWBool("MortalStrike" )) then
			timer.Simple(0.05, function()
				local naturalDamage = char:getData("naturalDamage",0)
				local str = char:getAttrib("str")
				local damage = naturalDamage - (str * 5) - 100
				char:setData("tempDamage", math.max(0,naturalDamage))
				ply:SetNWBool("MortalStrike", false)
				if Entity:IsPlayer() then
					local targetChar = Entity:getChar()
					Entity:SetNWBool("RegenDisable", true)
					timer.Simple(10, function()
						Entity:SetNWBool("RegenDisable", false)
						Entity:HealthRegeneration()
					end)
				end
				
			end)
		end

		if (ply:GetNWBool("ColiSmash" )) then
			timer.Simple(0.05, function()
				local naturalDamage = char:getData("naturalDamage",0)
				local str = char:getAttrib("str")
				local damage = naturalDamage - (str * 5) - 100
				char:setData("tempDamage", math.max(0,naturalDamage))
				ply:SetNWBool("ColiSmash", false)
				if Entity:IsPlayer() then
					local targetChar = Entity:getChar()
					local armor = Entity:getData("naturalArmorRating")
					targetChar:setData("naturalArmorRating", armor - 200)
					timer.Simple(10, function()
						targetChar:setData("naturalArmorRating", math.max(0,armor))
					end)
				end
				
			end)
		end
    end
end)