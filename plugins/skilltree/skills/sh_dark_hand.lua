SKILL.name = "Dark Hand of Destruction"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/Spell_deathknight_strangulate.png"
SKILL.category = "Dark Magic"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "asp_sorcerer"
}

SKILL.desc = [[
Talons of dark energy sprout from the fingertips of one of the caster's hands, and can be used as a weapon in hand-to-hand combat. 

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