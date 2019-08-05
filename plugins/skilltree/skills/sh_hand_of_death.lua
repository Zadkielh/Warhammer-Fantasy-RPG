SKILL.name = "Hand of Death"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/ability_creature_disease_05.png"
SKILL.category = "Lore of Undeath"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "asp_sorcerer"
}

SKILL.desc = [[
The caster can wound with a touch, but cannot use weapons for the duration of the spell.

It lasts for 10 seconds.


Ability Slot: 1


Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 30

local function ability(SKILL, ply )
    local nospam = ply:GetNWBool( "nospamAOE" )
	if (nospam) then 
		if timer.Exists(ply:SteamID().."nospamMelee") then return  end // nospamRanged, nospamUlt, nospamAOE, nospamMelee
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)
		return
	end

	local mana = ply:getLocalVar("mana", 0)
		if mana < 50 then
			return
		end
	ply:setLocalVar("mana", mana - 50)

	ply:Give("dark_hand")
	ply:SelectWeapon( "dark_hand" )
	
	if SERVER then
		
			ply:SetNWBool( "nospamMelee", true )

			net.Start( "MeleeActivated" ) // RangedActivated, UltActivated, AOEActivated, MeleeActivated
			net.Send( ply )


		if timer.Exists(ply:SteamID().."nospamMelee") then return  end
		timer.Create(ply:SteamID().."nospamMelee", SKILL.coolDown, 1, function()
			ply:SetNWBool( "nospamMelee", false )
		end)

	end
end

SKILL.ability = ability