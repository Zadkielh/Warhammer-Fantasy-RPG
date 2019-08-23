SKILL.name = "Invocation of Nehek"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_shadow_deadofnight.png"
SKILL.category = "Lore of Undeath"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "ULT" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
   -- "asp_sorcerer"
}

SKILL.desc = [[
The caster intones the dread syllables handed down from Nagash himself, breathing unlife into the cadavers strewn across the battlefield.

Maxrange: 500 Units.
Cost: 100 Energy
Cooldown: 60 Seconds
Ability Slot: 4
Class Restriction: Aspiring Sorcerer

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 5

local function ability(SKILL, ply )
    local nospam = ply:GetNWBool( "nospamUlt" ) // nospamRanged, nospamUlt, nospamAOE, nospamMelee
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamUlt") then return  end
		timer.Create(ply:SteamID().."nospamUlt", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamUlt", false )
		end)
		return
	end

	
	
	local _ents = ents.FindInSphere(ply:GetPos(), 1000)

	local NPCTable = {}
	NPCTable[1] = "npc_zad_vmp_skeleton_warrior_sp"
	NPCTable[2] = "npc_zad_vmp_skeleton_warrior_sws"

	
 
	for k, v in pairs(_ents) do
		local number = math.random(1, 2)
		if v:IsRagdoll() then
			v:Ressurect(NPCTable[number], ply, 20, 1)
		end
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