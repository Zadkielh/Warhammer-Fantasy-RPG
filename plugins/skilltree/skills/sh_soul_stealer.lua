SKILL.name = "Soul Stealer"

SKILL.LevelReq = 2
SKILL.SkillPointCost = 1
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_creature_cursed_03.png"
SKILL.category = "Dark Magic"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "RANGED" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "asp_sorcerer"
}

SKILL.desc = [[
Tendrils of pure, solidified darkness writhe out from the wizard’s outstretched hands, draining the life force from their hapless enemies to renew their own vigour.

Ability Slot: 2
Class Restriction: Sorcerer

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 20

local function ability(SKILL, ply )
   local nospam = ply:GetNWBool( "nospamRanged" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
		timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamRanged", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
	ply:setLocalVar("mana", mana - 20)
			
	local AbilityPos = ply:GetEyeTrace()

	if (AbilityPos.Entity:IsNPC() or AbilityPos.Entity:IsPlayer()) then
		if ply:GetPos():Distance( AbilityPos.Entity:GetPos() ) <= 500 then
			net.Start("skills.SoulStealer")
				net.WriteEntity(AbilityPos.Entity)
			net.Send(ply)

			timer.Create("SoulStealer"..ply:SteamID(), 0.25, 20, function()
				if IsValid(ply) and IsValid(AbilityPos.Entity) then
					ply:SetHealth(ply:Health() + 5 + (char:getAttrib("mgc") * 1) + ((25 * (char:getLevel()*char:getLevel()) / (char:getLevel()+char:getLevel()))))
					AbilityPos.Entity:TakeDamage(5 + (char:getAttrib("mgc") * 1) + ((25 * (char:getLevel()*char:getLevel()) / (char:getLevel()+char:getLevel()))), ply, ply)
				end 
			end)
		end
	end
			
	if (SERVER) then
		ply:SetNWBool( "nospamRanged", true )
		print("Cdstart")

		net.Start( "RangedActivated" )
		net.Send( ply )

		if timer.Exists(ply:SteamID().."nospamRanged") then return  end
			timer.Create(ply:SteamID().."nospamRanged", SKILL.coolDown, 1, function()
				ply:SetNWBool( "nospamRanged", false )
			end)

	end
end

SKILL.ability = ability


if (SERVER) then
	util.AddNetworkString("skills.SoulStealer")
end

if (CLIENT) then
	net.Receive("skills.SoulStealer", function(ply, len)

		local ent = net.ReadEntity()

		hook.Add( "PreDrawHalos", "skills.SoulStealer", function()
			local Enemies = {}
			Enemies[1] = ent

			halo.Add( Enemies, Color( 155, 0, 0 ), 0, 0, 4, true, true )
		end)

			timer.Simple(5, function()
				hook.Remove("PreDrawHalos", "skills.SoulStealer")
			end)
			
	end)
end