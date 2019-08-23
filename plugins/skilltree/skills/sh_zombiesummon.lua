SKILL.name = "Bloodletter Summoning"

SKILL.LevelReq = 15
SKILL.SkillPointCost = 3
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_shadow_deadofnight.png"
SKILL.category = "Dark Magic"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "asp_sorcerer"
}

SKILL.desc = [[
Summon a Bloodletter

Maxrange: 500 Units.
Cost: 100 Energy
Cooldown: 60 Seconds
Ability Slot: 4
Class Restriction: Aspiring Sorcerer

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 120

local function ability(SKILL, ply )
    local nospam = ply:GetNWBool( "nospamUlt" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamUlt") then return  end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
		return
	end

	local pos = ply:GetPos()
	
	ply:Summon("npc_vj_bloodletter", 20, 2, pos) 

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