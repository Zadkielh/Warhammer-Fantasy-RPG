SKILL.name = "Akaran's Dark Knights"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_shadow_shadowfury.png"
SKILL.category = "Lore of Undeath"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "asp_sorcerer"
}

SKILL.desc = [[
At the wizard's command, the ground opens up to reveal a portal through which long-dead knights charge forth to do battle.

Maxrange: 500 Units.
Cost: 100 Energy
Cooldown: 60 Seconds
Ability Slot: 4
Class Restriction: Aspiring Sorcerer

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 15

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
			
		local Ent = ents.Create("obj_40k_vortex")
		
		local AbilityPos = ply:GetEyeTrace()
			
		if ply:GetPos():Distance( AbilityPos.HitPos ) <= 500 then
		
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