SKILL.name = "Lightning Storm"

SKILL.LevelReq = 10
SKILL.SkillPointCost = 2
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_shadow_shadowfury.png"
SKILL.category = "Lore of Heavens"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "celestial_wizard"
}

SKILL.desc = [[
Summon a storm of lightning anywhere within a wide area.

Maxrange: 500 Units.
Cost: 100 Energy
Cooldown: 60 Seconds
Ability Slot: 4
Class Restriction: Aspiring Sorcerer

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 60

local function ability(SKILL, ply )
    local nospam = ply:GetNWBool( "nospamUlt" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamUlt") then return  end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 20 then
			return
		end
	ply:setLocalVar("mana", mana - 20)
			
		local Ent = ents.Create("sent_zad_thunderstorm")
		
		local AbilityPos = ply:GetEyeTrace()
			
		if ply:GetPos():Distance( AbilityPos.HitPos ) <= 1000 then
		
			Ent:SetPos(AbilityPos.HitPos)
			Ent:SetOwner(ply)
			Ent:Spawn()
		
		else
			local OwnerPos = ply:GetPos()
			local OwnerAng = ply:GetAimVector():Angle()
			OwnerPos = OwnerPos + ply:GetForward()*5

			Ent:SetPos(OwnerPos)
			Ent:SetOwner(ply)
			Ent:Spawn()

		end

	if SERVER then

		ply:SetNWBool( "nospamUlt", true )
		print("Cdstart")

		net.Start( "UltActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
		net.Send( ply )


		if timer.Exists(ply:SteamID().."nospamUlt") then return  end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false ) 
		end)

	end
end

SKILL.ability = ability