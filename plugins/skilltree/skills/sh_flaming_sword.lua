SKILL.name = "Flaming Sword of Rhuin"

SKILL.LevelReq = 1
SKILL.SkillPointCost = 0
SKILL.Incompatible = {

}
SKILL.RequiredSkills = {

}
SKILL.icon = "vgui/skills/inv_sword_01.png"
SKILL.category = "Lore of Fire"-- Common Passives, Warrior, Lore of Light, Lore of Life

SKILL.slot = "MELEE" -- ULT, RANGED, MELEE, AOE, PASSIVE
SKILL.class = {
    "bright_wizard"
}

SKILL.desc = [[
A fiery sword materializes in the caster's grasp. Being magical in nature, it also imparts greater prowess in battle.
The wizard can also ensorcel his allies' weapons, making them burn with a savagely hungry flame.
Ability Slot: 2
Class Restriction: Bright Wizard

Level Requirement: ]] .. SKILL.LevelReq .. [[

Skill Point Cost:]] .. SKILL.SkillPointCost .. [[
    
]]

SKILL.coolDown = 2

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

	ply:Give("fire_sword")
	ply:SelectWeapon( "fire_sword" )
	
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